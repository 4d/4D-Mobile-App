Class constructor($sqlite3 : 4D:C1709.File)
	If (Count parameters:C259>0)
		This:C1470.sqlite3:=cs:C1710.sqlite3.new($sqlite3)
	Else 
		This:C1470.sqlite3:=cs:C1710.sqlite3.new()
	End if 
	
	// Main public method to return stats on db file
Function stats($dbFile : 4D:C1709.File)->$stats : Object
	This:C1470.sqlite3.connect(File:C1566($dbFile.platformPath; fk platform path:K87:2))
	
	$stats:=New object:C1471("tables"; New object:C1471)
	
	var $tablesMap : Object
	$tablesMap:=This:C1470._tableMaps()
	
	var $table : Text
	For each ($table; OB Values:C1718($tablesMap).distinct())
		$stats.tables[$table]:=0
	End for each 
	
	var $results : Collection
	$results:=This:C1470._dbstat()
	
	var $pageSize : Integer
	$pageSize:=This:C1470._pageSize()  // $results.extract("pgsize").max()// suppose equal page size if max
	
	var $pgcnt : Integer
	$pgcnt:=This:C1470._pageCount()
	$stats.total:=$pgcnt*$pageSize
	
	var $result : Object
	For each ($result; $results)
		If ($tablesMap[$result.name]#Null:C1517)
			$stats.tables[$tablesMap[$result.name]]+=$result.pgsize
		End if 
	End for each 
	
	This:C1470.sqlite3.disconnect()
	
	
	// MARK:- privates
	
Function _pageCount()->$pageCount : Integer
	$pageCount:=This:C1470._pragmaInteger("page_count")
	
Function _pageSize()->$pageSize : Integer
	$pageSize:=This:C1470._pragmaInteger("page_size")
	
Function _pragmaInteger($key : Text)->$pageSize : Integer
	$pageSize:=Num:C11(This:C1470.sqlite3.execute("PRAGMA "+$key+";"))
	
Function _tableMaps()->$map : Object
	var $result; $line : Text
	$result:=This:C1470.sqlite3.execute("SELECT name, tbl_name FROM sqlite_schema WHERE rootpage>0;")
	
	If (Length:C16($result)=0)
		$result:=This:C1470.sqlite3.execute("SELECT name, tbl_name FROM sqlite_master WHERE rootpage>0;")
	End if 
	
	$map:=New object:C1471
	
	var $values : Collection
	For each ($line; Split string:C1554($result; "\n"))
		$values:=Split string:C1554($line; "|")
		If ($values.length=2)
			$map[$values[0]]:=$values[1]
		End if 
	End for each 
	
Function _dbstat()->$results : Collection
	$results:=New collection:C1472
	var $text : Text
	$text:=This:C1470.sqlite3.execute("SELECT * FROM dbstat;")
	
	var $line : Text
	var $values : Collection
	For each ($line; Split string:C1554($text; "\n"))
		
		$values:=Split string:C1554($line; "|")
		If ($values.length=10)
			$results.push(New object:C1471(\
				"name"/*TEXT,--Name of table or index*/; $values[0]; \
				"pgsize"/*INTEGER,--Size of the page, in bytes*/; Num:C11($values[9])))
			
			//"path"/*TEXT,--Path to page from root*/; $values[1]; \
												//"pageno"/*INTEGER,--Page number, or page count*/; Num($values[2]); \
												//"pagetype"/*TEXT,--'internal', 'leaf', 'overflow', or NULL*/; $values[3]; \
												//"ncell"/*INTEGER,--Cells on page(0 for overflow pages)*/; Num($values[4]); \
												//"payload"/*INTEGER,--Bytes of payload on this page or btree*/; Num($values[5]); \
												//"unused"/*INTEGER,--Bytes of unused space on this page or btree*/; Num($values[6]); \
												//"mx_payload"/*INTEGER,--Largest payload size of all cells on this row*/; Num($values[7]); \
												//"pgoffset"/*INTEGER,--Byte offset of the page in the database file*/; Num($values[8]); \
												
		End if 
	End for each 
	