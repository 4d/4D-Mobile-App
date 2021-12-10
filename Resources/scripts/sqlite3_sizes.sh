#! /bin/sh
# restart with tclsh \
exec tclsh "$0" ${1+"$@"}
package require sqlite3

# Run this TCL script using "testfixture" in order get a report that shows
# how much disk space is used by a particular data to actually store data
# versus how much space is unused.
#

if {[catch {

# Argument $tname is the name of a table within the database opened by
# database handle [db]. Return true if it is a WITHOUT ROWID table, or
# false otherwise.
#
proc is_without_rowid {tname} {
  set t [string map {' ''} $tname]
  db eval "PRAGMA index_list = '$t'" o {
    if {$o(origin) == "pk"} {
      set n $o(name)
      if {0==[db one { SELECT count(*) FROM sqlite_master WHERE name=$n }]} {
        return 1
      }
    }
  }
  return 0
}

# Quote a string for use in an SQL query.
proc quote {txt} {
  return [string map {' ''} $txt]
}


# Read and run TCL commands from standard input.  Used to implement
# the --tclsh option.
#
proc tclsh {} {
  set line {}
  while {![eof stdin]} {
    if {$line!=""} {
      puts -nonewline "> "
    } else {
      puts -nonewline "% "
    }
    flush stdout
    append line [gets stdin]
    if {[info complete $line]} {
      if {[catch {uplevel #0 $line} result]} {
        puts stderr "Error: $result"
      } elseif {$result!=""} {
        puts $result
      }
      set line {}
    } else {
      append line \n
    }
  }
}

# Get the name of the database to analyze
proc usage {} {
  set argv0 [file rootname [file tail [info script]]]
  puts stderr "Usage: $argv0 database-filename"
  puts stderr {
Analyze the SQLite3 database file specified by the "database-filename"
argument and output a json report detailing size by table.

Options:

   --tclsh      Run the built-in TCL interpreter interactively (for debugging)

   --version    Show the version number of SQLite
}
  exit 1
}
set file_to_analyze {}
set flags(-pageinfo) 0
set flags(-stats) 0
set flags(-debug) 0
append argv {}
foreach arg $argv {
  if {[regexp {^-+pageinfo$} $arg]} {
    set flags(-pageinfo) 1
  } elseif {[regexp {^-+stats$} $arg]} {
    set flags(-stats) 1
  } elseif {[regexp {^-+debug$} $arg]} {
    set flags(-debug) 1
  } elseif {[regexp {^-+tclsh$} $arg]} {
    tclsh
    exit 0
  } elseif {[regexp {^-+version$} $arg]} {
    sqlite3 mem :memory:
    puts [mem one {SELECT sqlite_version()||' '||sqlite_source_id()}]
    mem close
    exit 0
  } elseif {[regexp {^-} $arg]} {
    puts stderr "Unknown option: $arg"
    usage
  } elseif {$file_to_analyze!=""} {
    usage
  } else {
    set file_to_analyze $arg
  }
}
if {$file_to_analyze==""} usage
set root_filename $file_to_analyze
regexp {^file:(//)?([^?]*)} $file_to_analyze all x1 root_filename
if {![file exists $root_filename]} {
  puts stderr "No such file: $root_filename"
  exit 1
}
if {![file readable $root_filename]} {
  puts stderr "File is not readable: $root_filename"
  exit 1
}
set true_file_size [file size $root_filename]
if {$true_file_size<512} {
  puts stderr "Empty or malformed database: $root_filename"
  exit 1
}
set extension [file extension $root_filename]
set pattern $root_filename
append pattern {[0-3][0-9][0-9]}
foreach f [glob -nocomplain $pattern] {
  incr true_file_size [file size $f]
  set extension {}
}
if {[string length $extension]>=2 && [string length $extension]<=4} {
  set pattern [file rootname $root_filename]
  append pattern {.[0-3][0-9][0-9]}
  foreach f [glob -nocomplain $pattern] {
    incr true_file_size [file size $f]
  }
}

# Open the database
if {[catch {sqlite3 db $file_to_analyze -uri 1} msg]} {
  puts stderr "error trying to open $file_to_analyze: $msg"
  exit 1
}
if {$flags(-debug)} {
  proc dbtrace {txt} {puts $txt; flush stdout;}
  db trace ::dbtrace
}

db eval {SELECT count(*) FROM sqlite_master}
set pageSize [expr {wide([db one {PRAGMA page_size}])}]


sqlite3 mem :memory:
if {$flags(-debug)} {
  proc dbtrace {txt} {puts $txt; flush stdout;}
  mem trace ::dbtrace
}
set tabledef {CREATE TABLE space_used(
   name clob,        -- Name of a table or index in the database file
   tblname clob,     -- Name of associated table
   is_index boolean, -- TRUE if it is an index, false for a table
   is_without_rowid boolean, -- TRUE if WITHOUT ROWID table  
   nentry int,       -- Number of entries in the BTree
   leaf_entries int, -- Number of leaf entries
   depth int,        -- Depth of the b-tree
   payload int,      -- Total amount of data stored in this table or index
   ovfl_payload int, -- Total amount of data stored on overflow pages
   ovfl_cnt int,     -- Number of entries that use overflow
   mx_payload int,   -- Maximum payload size
   int_pages int,    -- Number of interior pages used
   leaf_pages int,   -- Number of leaf pages used
   ovfl_pages int,   -- Number of overflow pages used
   int_unused int,   -- Number of unused bytes on interior pages
   leaf_unused int,  -- Number of unused bytes on primary pages
   ovfl_unused int,  -- Number of unused bytes on overflow pages
   gap_cnt int,      -- Number of gaps in the page layout
   compressed_size int  -- Total bytes stored on disk
);}
mem eval $tabledef

# Create a temporary "dbstat" virtual table.
db eval {CREATE VIRTUAL TABLE temp.stat USING dbstat}
db eval {CREATE TEMP TABLE dbstat AS SELECT * FROM temp.stat
         ORDER BY name, path}
db eval {DROP TABLE temp.stat}

set isCompressed 0
set compressOverhead 0
set depth 0
set sql { SELECT name, tbl_name FROM sqlite_schema WHERE rootpage>0 }
foreach {name tblname} [concat sqlite_schema sqlite_schema [db eval $sql]] {
  set is_index [expr {$name!=$tblname}]
  set is_without_rowid [is_without_rowid $name]
  db eval {
    SELECT 
      sum(ncell) AS nentry,
      sum((pagetype=='leaf')*ncell) AS leaf_entries,
      sum(payload) AS payload,
      sum((pagetype=='overflow') * payload) AS ovfl_payload,
      sum(path LIKE '%+000000') AS ovfl_cnt,
      max(mx_payload) AS mx_payload,
      sum(pagetype=='internal') AS int_pages,
      sum(pagetype=='leaf') AS leaf_pages,
      sum(pagetype=='overflow') AS ovfl_pages,
      sum((pagetype=='internal') * unused) AS int_unused,
      sum((pagetype=='leaf') * unused) AS leaf_unused,
      sum((pagetype=='overflow') * unused) AS ovfl_unused,
      sum(pgsize) AS compressed_size,
      max((length(CASE WHEN path LIKE '%+%' THEN '' ELSE path END)+3)/4)
        AS depth
    FROM temp.dbstat WHERE name = $name
  } break

  set total_pages [expr {$leaf_pages+$int_pages+$ovfl_pages}]
  set storage [expr {$total_pages*$pageSize}]
  if {!$isCompressed && $storage>$compressed_size} {
    set isCompressed 1
    set compressOverhead 14
  }

  set gap_cnt 0
  set prev 0
  db eval {
    SELECT pageno, pagetype FROM temp.dbstat
     WHERE name=$name
     ORDER BY pageno
  } {
    if {$prev>0 && $pagetype=="leaf" && $pageno!=$prev+1} {
      incr gap_cnt
    }
    set prev $pageno
  }
  mem eval {
    INSERT INTO space_used VALUES(
      $name,
      $tblname,
      $is_index,
      $is_without_rowid,
      $nentry,
      $leaf_entries,
      $depth,
      $payload,     
      $ovfl_payload,
      $ovfl_cnt,   
      $mx_payload,
      $int_pages,
      $leaf_pages,  
      $ovfl_pages, 
      $int_unused, 
      $leaf_unused,
      $ovfl_unused,
      $gap_cnt,
      $compressed_size
    );
  }
}

proc integerify {real} {
  if {[string is double -strict $real]} {
    return [expr {wide($real)}]
  } else {
    return 0
  }
}
mem function int integerify


proc divide {num denom} {
  if {$denom==0} {return 0.0}
  return [expr double($num)/double($denom)]]
}

set file_pgcnt  [db one {PRAGMA page_count}]
set file_bytes  [expr {$file_pgcnt * $pageSize}]

set first 0
set size 0

puts "{"
puts " \"total\": $file_bytes,"
puts " \"tables\": {"
mem eval {SELECT tblname, count(*) AS cnt, 
              int(sum(int_pages+leaf_pages+ovfl_pages)) AS size
          FROM space_used GROUP BY tblname ORDER BY size+0 DESC, tblname} {} {
  set tablesize [expr {double($size) * double($file_bytes) / double($file_pgcnt)}]
  
  if { $first == 1 } {
    puts ","
  } else {
    set first 1
  }
  puts  -nonewline "  \"$tblname\": $tablesize"
}
puts ""
puts " }"
puts "}"
 


} err]} {
  puts "ERROR: $err"
  puts $errorInfo
  exit 1
}
