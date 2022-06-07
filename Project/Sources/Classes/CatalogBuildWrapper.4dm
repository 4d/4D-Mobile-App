Class constructor($catalog : Collection)
	This:C1470.catalog:=$catalog
	
Function query($query : Text; $param1 : Variant)->$col : Collection
	$col:=This:C1470.catalog.query.apply(Copy parameters:C1790())
	
Function getTable($tableName : Text)->$table : Object
	$table:=This:C1470.catalog.query("name = :1"; $tableName).pop()
	
Function getField($tableName : Text; $fieldName : Text)->$field : Object
	var $table : Object
	$table:=This:C1470.getTable($tableName)
	If ($table#Null:C1517)
		$field:=$table.fields.query("name = :1"; $fieldName).pop()
	End if 
	
Function getTableInfo($tableName : Text)->$tableInfo : Object
	var $table : Object
	$table:=This:C1470.getTable($tableName)
	If ($table#Null:C1517)
		$tableInfo:=OB Copy:C1225($table)
		OB REMOVE:C1226($tableInfo; "field")
	End if 
	
Function aliasPath($tableName : Text; $alias : Object; $recursive : Boolean)->$result : Object
	ASSERT:C1129(Length:C16($alias.path)>0; "No path for alias "+JSON Stringify:C1217($alias))
	
	var $paths : Collection
	var $path : Text
	$paths:=Split string:C1554($alias.path; ".")
	
	$result:=New object:C1471
	$result.paths:=New collection:C1472
	
	var $sourceDataClass; $destination; $previousDataClass; $pathElement : Object
	$sourceDataClass:=This:C1470.getTable($tableName)
	
	Repeat 
		$path:=$paths.shift()
		$destination:=$sourceDataClass.fields.query("name = :1"; $path).pop()
		
		
		$previousDataClass:=$sourceDataClass
		
		$pathElement:=New object:C1471(\
			"path"; $path; \
			"from"; $sourceDataClass.name)
		$result.paths.push($pathElement)
		
		If ($destination.relatedDataClass#Null:C1517)  // Is relatedDataClass filled for alias? like destination field
			
			$sourceDataClass:=This:C1470.getTable($destination.relatedDataClass)
			
			$pathElement.to:=$sourceDataClass.name
			
		End if 
		
		
	Until ($paths.length=0)
	
	If (Bool:C1537($recursive))
		
		If (String:C10($result.field.kind)="alias")  // Maybe an alias too
			
			var $rs : Object
			$rs:=This:C1470.aliasPath($previousDataClass; $result.field; True:C214)
			
			$result.paths.combine($rs.paths)
			$result.field:=$rs
			
		End if 
	End if 
	
	$result.path:=$result.paths.extract("path").join(".")
	$result.dataClasses:=$result.paths.extract("from").distinct()
	