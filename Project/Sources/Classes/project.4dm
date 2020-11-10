Class constructor($project : Object)
	
	If (Count parameters:C259>=1)
		
		This:C1470.init($project)
		
	End if 
	
	//====================================
Function init($project : Object)
	
	var $key : Text
	
	For each ($key; $project)
		
		This:C1470[$key]:=$project[$key]
		
	End for each 
	
	//====================================
Function load
	var $1 : Variant
	
	var $o; $project : Object
	
	var $file : 4D:C1709.File
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$file:=File:C1566($1; fk platform path:K87:2)
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			If (OB Instance of:C1731($1; 4D:C1709.File))
				
				$file:=$1
				
			Else 
				
				// ERROR
				
			End if 
			
			//______________________________________________________
		Else 
			
			// ERROR
			
			//______________________________________________________
	End case 
	
	If (Bool:C1537($file.exists))
		
		$project:=JSON Parse:C1218($file.getText())
		
		If (project_Upgrade($project))
			
			// If upgraded, keep a copy of the old project…
			$o:=$file.parent.folder(Replace string:C233(Get localized string:C991("convertedFiles"); "{stamp}"; str_date("stamp")))
			$o.create()
			$file.moveTo($o)
			
			//… & immediately save
			This:C1470.save()
			
		End if 
		
		This:C1470.init($project)
		
	Else 
		
		// ERROR
		
	End if 
	
	//====================================
Function get
	var $0 : Object
	
	var $t; $tt : Text
	var $o; $project : Object
	
	$project:=OB Copy:C1225(This:C1470)
	
	For each ($t; $project)
		
		If ($t[[1]]="$")
			
			OB REMOVE:C1226($project; $t)
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Value type:C1509($project[$t])=Is object:K8:27)
					
					This:C1470.cleanup($project[$t])
					
					//______________________________________________________
				: (Value type:C1509($project[$t])=Is collection:K8:32)
					
					For each ($o; $project[$t])
						
						This:C1470.cleanup($o)
						
					End for each 
					
					//______________________________________________________
			End case 
		End if 
	End for each 
	
	$0:=$project
	
	//====================================
Function cleanup
	var $0 : Object
	var $1 : Object
	
	var $o : Object
	var $project : Object
	
	If (Count parameters:C259>=1)
		
		For each ($o; OB Entries:C1720($1).query("key =:1"; "$@"))
			
			OB REMOVE:C1226($1; $o.key)
			
		End for each 
		
		$0:=$1
		
	Else 
		
		$project:=OB Copy:C1225(This:C1470)
		
		For each ($o; OB Entries:C1720($project).query("key =:1"; "$@"))
			
			OB REMOVE:C1226($project; $o.key)
			
		End for each 
		
		$0:=$project
		
	End if 
	
	//====================================
Function save
	var $file : 4D:C1709.Document
	var $folder : 4D:C1709.Folder
	
	If (Bool:C1537(FEATURE._8858))  // Debug mode
		
		$folder:=Folder:C1567(fk desktop folder:K87:19).folder("DEV")
		
		If ($folder.exists)
			
			$folder.file("project.json").setText(JSON Stringify:C1217(This:C1470; *))
			
		End if 
	End if 
	
	$file:=This:C1470.$project.file
	$file.create()
	$file.setText(JSON Stringify:C1217(This:C1470.get(); *))
	
	//====================================
Function updateActions
	var $indx : Integer
	var $dataModel; $parameter; $table : Object
	var $actions : Collection
	
	$actions:=This:C1470.actions
	
	If ($actions#Null:C1517)
		
		$dataModel:=This:C1470.dataModel
		
		For each ($table; $actions)
			
			If ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
				
				If ($table.parameters#Null:C1517)
					
					For each ($parameter; $table.parameters)
						
						If ($dataModel[String:C10($table.tableNumber)][String:C10($parameter.fieldNumber)]=Null:C1517)
							
							// ❌ THE FIELD DOESN'T EXIST ANYMORE
							$table.parameters.remove($table.parameters.indexOf($parameter))
							
						End if 
					End for each 
				End if 
				
			Else 
				
				// ❌ THE TABLE DOESN'T EXIST ANYMORE
				$actions.remove($indx)
				
			End if 
			
			$indx:=$indx+1
			
		End for each 
		
		If ($actions.length=0)
			
			// ❌ NO MORE ACTION
			OB REMOVE:C1226(This:C1470; "actions")
			
		End if 
	End if 
	
	//====================================
Function removeFromMain
	var $1 : Variant
	
	var $l : Integer
	var $main : Object
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472
		
	Else 
		
		$l:=$main.order.indexOf(String:C10($1))
		
		If ($l#-1)
			
			$main.order.remove($l)
			
		End if 
	End if 
	
	//====================================
Function addToMain
	var $1 : Variant
	
	var $main : Object
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472(String:C10($1))
		
	Else 
		
		If ($main.order.indexOf(String:C10($1))=-1)
			
			$main.order.push(String:C10($1))
			
		End if 
	End if 
	
	//====================================
Function isField
	
	var $0 : Boolean
	var $1 : Text
	$0:=Match regex:C1019("(?m-si)^\\d+$"; $1; 1; *)
	
	//====================================
Function isRelation
	
	var $0 : Boolean
	var $1 : Object
	$0:=((This:C1470.isRelationToOne($1)) | (This:C1470.isRelationToMany($1)))
	
	//====================================
Function isRelationToOne
	
	var $0 : Boolean
	var $1 : Object
	$0:=($1.relatedDataClass#Null:C1517)
	
	//====================================
Function isRelationToMany
	
	var $0 : Boolean
	var $1 : Object  // Field
	$0:=(($1.relatedEntities#Null:C1517) | (String:C10($1.kind)="relatedEntities"))
	
/* ===================================
Add the table to the data model
====================================*/
Function addTable
	var $0 : Object
	var $1 : Object
	
	var $o : Object
	
	$o:=This:C1470.getCatalog().query("tableNumber = :1"; $1.tableNumber).pop()
	
	// Put internal properties into a substructure
	$0:=New object:C1471(\
		""; New object:C1471(\
		"name"; $o.name; \
		"label"; This:C1470.label($o.name); \
		"shortLabel"; This:C1470.shortLabel($o.name); \
		"primaryKey"; String:C10($o.primaryKey); \
		"embedded"; True:C214)\
		)
	
	// Update dataModel
	If (This:C1470.dataModel=Null:C1517)
		
		This:C1470.dataModel:=New object:C1471
		
	End if 
	
	// Update main
	This:C1470.addToMain($1.tableNumber)
	
	This:C1470.dataModel[String:C10($1.tableNumber)]:=$0
	
/* ===================================
Delete the table from the data model
====================================*/
Function removeTable
	var $0 : Collection
	var $1 : Variant
	
	OB REMOVE:C1226(This:C1470.dataModel; String:C10($1))
	
	// Update main
	This:C1470.removeFromMain($1)
	
	//====================================
Function getCatalog
	var $0 : Collection
	
	Case of 
			
			//____________________________________
		: (This:C1470.$project#Null:C1517)
			
			$0:=This:C1470.$project.$catalog
			
			//____________________________________
		: (This:C1470.$catalog#Null:C1517)
			
			$0:=This:C1470.$catalog
			
			//____________________________________
		Else 
			
			ASSERT:C1129(False:C215)
			
			//____________________________________
	End case 
	
	//====================================
Function label  // Format labels
	var $0 : Text
	var $1 : Text
	
	var $t : Text
	var $i : Integer
	
	ARRAY TEXT:C222($words; 0)
	
	$t:=$1
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(Match regex:C1019("(?mi-s)^[[:ascii:]]*$"; $t; 1)))  //#ACI0099182
			
			$0:=$t
			
			//______________________________________________________
		Else 
			
			$t:=Replace string:C233($t; "_"; " ")
			
			// Camelcase to spaced
			If (Rgx_SubstituteText("(?m-si)([[:lower:]])([[:upper:]])"; "\\1 \\2"; ->$t)=0)
				
				$t:=Lowercase:C14($t)
				
			End if 
			
			// Capitalize first letter of words
			GET TEXT KEYWORDS:C1141($t; $words)
			
			For ($i; 1; Size of array:C274($words); 1)
				
				If (Length:C16($words{$i})>3)\
					 | ($i=1)
					
					$words{$i}[[1]]:=Uppercase:C13($words{$i}[[1]])
					
				End if 
				
				$0:=$0+((" ")*Num:C11($i>1))+$words{$i}
				
			End for 
			
			$0:=Replace string:C233($0; "id"; "ID")
			
			//______________________________________________________
	End case 
	
	//====================================
Function shortLabel  // Format short labels
	var $0 : Text
	var $1 : Text
	
	$0:=This:C1470.label($1)
	
	If (Length:C16($0)>10)
		
		$0:=Substring:C12($0; 1; 10)
		
	End if 
	
	//====================================
Function labelList  // List of x
	var $0 : Text
	var $1 : Text
	
	$0:=This:C1470.label(Replace string:C233(Get localized string:C991("listOf"); "{values}"; $1))
	
	//====================================
Function isStorage
	var $0 : Boolean
	var $1 : Object
	
	If (String:C10($1.kind)="storage")
		
		If ($1.fieldType#Is object:K8:27)\
			 & ($1.fieldType#Is BLOB:K8:12)\
			 & ($1.fieldType#Is subtable:K8:11)  // Exclude object and blob fields [AND SUBTABLE]
			
			$0:=True:C214
			
		End if 
	End if 
	
	//====================================
Function getIcon
	var $0 : Picture
	var $1 : Text
	
	var $icon : Picture
	var $file : 4D:C1709.File
	
	If (Length:C16($1)=0)
		
		$file:=File:C1566(UI.noIcon; fk platform path:K87:2)
		
	Else 
		
		$file:=path.icon($1)
		
		If (Not:C34($file.exists))
			
			$file:=File:C1566(UI.errorIcon; fk platform path:K87:2)
			
		End if 
	End if 
	
	If ($file.exists)
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		CREATE THUMBNAIL:C679($icon; $0; 24; 24; Scaled to fit:K6:2)
		
	End if 
	
	//====================================
Function isLink
	var $0 : Boolean
	var $1 : Object
	
	var $t : Text
	
	For each ($t; OB Keys:C1719($1)) Until ($0)
		
		$0:=Value type:C1509($1[$t])=Is object:K8:27
		
	End for each 
	
	//================================================================================
	// Check if a field is still available in the table catalog
Function fieldAvailable($tableID : Variant; $field : Object)->$available : Boolean
	
	var $relatedTableNumber : Integer
	var $o; $relatedCatalog; $tableCatalog : Object
	var $c : Collection
	var $fieldID : Text
	
	// Accept num or string
	$tableID:=String:C10($tableID)
	$fieldID:=String:C10($field.id)
	
	$c:=Split string:C1554($field.name; ".")
	
	If ($c.length=1)
		
		// Check the data class
		If ($field.relatedTableNumber#Null:C1517)
			
			// Relation = use name
			$available:=(This:C1470.dataModel[$tableID][$field.name]#Null:C1517)
			
		Else 
			
			// Field = use id
			$available:=(This:C1470.dataModel[$tableID][$fieldID]#Null:C1517)
			
		End if 
		
	Else 
		
		// Check the related data class
		$tableCatalog:=This:C1470.$project.$catalog.query("tableNumber = :1"; Num:C11($tableID)).pop()
		
		If ($tableCatalog#Null:C1517)  // The table exists
			
			$relatedTableNumber:=Num:C11($tableCatalog.field.query("name= :1"; $c[0]).pop().relatedTableNumber)
			
			If ($relatedTableNumber>0)
				
				$relatedCatalog:=This:C1470.$project.$catalog.query("tableNumber = :1"; $relatedTableNumber).pop()
				
				If ($relatedCatalog#Null:C1517)  // The linked table exists
					
					If (This:C1470.dataModel[$tableID][$c[0]]#Null:C1517)  // The relation is published
						
						If (Num:C11($fieldID)#0)
							
							If ($relatedCatalog.field.query("id = :1"; Num:C11($fieldID)).pop()#Null:C1517)
								
								$available:=(This:C1470.dataModel[$tableID][$c[0]][$fieldID]#Null:C1517)
								
							End if 
							
						Else 
							
							If ($relatedCatalog.field.query("name = :1"; $c[1]).pop()#Null:C1517)
								
								$available:=(This:C1470.dataModel[$tableID][$c[0]][$c[1]]#Null:C1517)
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
	
	//============================================================================
	// Update all form definition according to the datamodel
	// Ie. remove from forms, the fields that are no more published
Function updateFormDefinitions
	var $formType; $tableID : Text
	var $field; $target : Object
	
	For each ($formType; New collection:C1472("list"; "detail"))
		
		If (Form:C1466[$formType]#Null:C1517)
			
			For each ($tableID; This:C1470[$formType])
				
				If (This:C1470.dataModel[$tableID]#Null:C1517)
					
					$target:=Form:C1466[$formType][$tableID]
					
					If ($target.fields#Null:C1517)
						
						// FIELDS ---------------------------------------------------------------------
						For each ($field; $target.fields)
							
							If ($field#Null:C1517)
								
								If (Not:C34(This:C1470.fieldAvailable($tableID; $field)))
									
									$target.fields[$target.fields.indexOf($field)]:=Null:C1517
									
								End if 
							End if 
						End for each 
					End if 
					
					If ($formType="list")
						
						// SEARCH WIDGET --------------------------------------------------------------
						If ($target.searchableField#Null:C1517)
							
							If (Value type:C1509($target.searchableField)=Is collection:K8:32)
								
								For each ($field; $target.searchableField)
									
									If (Not:C34(This:C1470.fieldAvailable($tableID; $field)))
										
										$target.searchableField.remove($target.searchableField.indexOf($field))
										
									End if 
								End for each 
								
								Case of 
										
										//…………………………………………………………………………………………………
									: ($target.searchableField.length=0)  // There are no more
										
										OB REMOVE:C1226($target; "searchableField")
										
										//…………………………………………………………………………………………………
									: ($target.searchableField.length=1)  // Convert to object
										
										$target.searchableField:=$target.searchableField[0]
										
										//…………………………………………………………………………………………………
								End case 
								
							Else 
								
								If (Not:C34(This:C1470.fieldAvailable($tableID; $target.searchableField)))
									
									OB REMOVE:C1226($target; "searchableField")
									
								End if 
							End if 
						End if 
						
						// SECTION WIDGET -------------------------------------------------------------
						If ($target.sectionField#Null:C1517)
							
							If (Not:C34(This:C1470.fieldAvailable($tableID; $target.sectionField)))
								
								OB REMOVE:C1226($target; "sectionField")
								
							End if 
						End if 
					End if 
				End if 
			End for each 
		End if 
	End for each 
	
	
Function fieldDefinition
	