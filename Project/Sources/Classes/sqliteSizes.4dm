Class constructor($sqlite3 : 4D:C1709.File)
	
	If (Count parameters:C259>0)
		
		This:C1470.sqlite3:=cs:C1710.sqlite3.new($sqlite3)
		
	Else 
		
		This:C1470.sqlite3:=cs:C1710.sqlite3.new()
		
	End if 
	
	This:C1470.schemaTableName:="sqlite_schema"
	
	/// Main public method to return stats on db file
Function stats($dbFile : 4D:C1709.File)->$stats : Object
	
	var $table : Text
	var $pageSize; $pageNumber : Integer
	var $result; $tablesMap : Object
	
	This:C1470.sqlite3.connect(File:C1566($dbFile.platformPath; fk platform path:K87:2))
	
	$stats:=New object:C1471(\
		"tables"; New object:C1471)
	
	$tablesMap:=This:C1470._tableMaps()
	
	For each ($table; OB Values:C1718($tablesMap).distinct())
		
		$stats.tables[$table]:=0
		
	End for each 
	
	$pageSize:=This:C1470._pageSize()  // $results.extract("pgsize").max()// Suppose equal page size if max
	$pageNumber:=This:C1470._pageCount()
	
	$stats.total:=$pageNumber*$pageSize
	
	For each ($result; This:C1470._dbstat())
		
		If ($tablesMap[$result.name]#Null:C1517)
			
			$stats.tables[$tablesMap[$result.name]]+=$result.pgsize
			
		End if 
	End for each 
	
	This:C1470.sqlite3.disconnect()
	
	// MARK:- privates
Function _pageCount() : Integer
	
	return (This:C1470._pragmaInteger("page_count"))
	
Function _pageSize() : Integer
	
	return (This:C1470._pragmaInteger("page_size"))
	
Function _pragmaInteger($key : Text) : Integer
	
	return (Num:C11(This:C1470.sqlite3.execute("PRAGMA "+$key+";")))
	
Function _tableMaps()->$map : Object
	
	var $line; $result : Text
	var $values : Collection
	
	$result:=This:C1470.sqlite3.execute("SELECT name, tbl_name FROM "+This:C1470.schemaTableName+" WHERE rootpage>0;")
	
	If (Length:C16($result)=0)
		
		$result:=This:C1470.sqlite3.execute("SELECT name, tbl_name FROM sqlite_master WHERE rootpage>0;")
		
	End if 
	
	$map:=New object:C1471
	
	// Under Windows, the line separator is "\r\n" instead of "\n" under macOS.
	$result:=Is Windows:C1573 ? Replace string:C233($result; "\r\n"; "\n") : $result
	
	For each ($line; Split string:C1554($result; "\n"))
		
		$values:=Split string:C1554($line; "|")
		
		If ($values.length=2)
			
			$map[$values[0]]:=$values[1]
			
		End if 
	End for each 
	
Function _dbstat()->$results : Collection
	
	var $line; $text : Text
	var $values : Collection
	
	$results:=New collection:C1472
	$text:=This:C1470.sqlite3.execute("SELECT * FROM dbstat;")
	
	// Under Windows, the line separator is "\r\n" instead of "\n" under macOS.
	$text:=Is Windows:C1573 ? Replace string:C233($text; "\r\n"; "\n") : $text
	
	For each ($line; Split string:C1554($text; "\n"))
		
		$values:=Split string:C1554($line; "|")
		
		If ($values.length=10)
			
			$results.push(New object:C1471(\
				"name"/*TEXT,--Name of table or index*/; $values[0]; \
				"pgsize"/*INTEGER,--Size of the page, in bytes*/; Num:C11($values[9])))
			
		End if 
	End for each 