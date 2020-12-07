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
	
	var $0 : cs:C1710.project
	$0:=This:C1470
	
	//================================================================================
	// Tests if the project is locked and, if so, makes the provided widgets accessible or not
Function isLocked()->$isLocked : Boolean
	
	If (This:C1470.structure#Null:C1517)
		
		$isLocked:=Bool:C1537(This:C1470.structure.unsynchronized)
		
	Else 
		
		$isLocked:=Bool:C1537(This:C1470.$project.structure.unsynchronized)
		
	End if 
	
	C_VARIANT:C1683(${1})
	//For ($i; 1; Count parameters; 1)
	//If ($isLocked)
	//OBJECT SET ENTERABLE(*; string(${$i}); Not($isLocked))
	//End if 
	//End for 
	
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
	// Save the project
Function save
	
	var $folder : 4D:C1709.Folder
	
	If (Bool:C1537(FEATURE._8858))  // Debug mode
		
		$folder:=Folder:C1567(fk desktop folder:K87:19).folder("DEV")
		
		If ($folder.exists)
			
			$folder.file("project.json").setText(JSON Stringify:C1217(This:C1470; *))
			
			If (This:C1470.$dialog#Null:C1517)
				
				$folder.file("dialog.json").setText(JSON Stringify:C1217(This:C1470.$dialog; *))
				
				var $key : Text
				For each ($key; This:C1470.$dialog)
					
					$folder.file($key+".json").setText(JSON Stringify:C1217(This:C1470.$dialog[$key]; *))
					
				End for each 
				
			End if 
			
			If (This:C1470.$project.$catalog#Null:C1517)
				
				$folder.file("catalog.json").setText(JSON Stringify:C1217(This:C1470.$project.$catalog; *))
				
			End if 
		End if 
	End if 
	
	This:C1470.$project.file.create()
	This:C1470.$project.file.setText(JSON Stringify:C1217(This:C1470.get(); *))
	
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
	// Returns the collection of the tables of the data model
Function tables($datamodel : Object)->$tables : Collection
	
	
	If (Count parameters:C259>=1)
		
		$tables:=OB Entries:C1720($datamodel)
		
	Else 
		
		// Use current
		$tables:=OB Entries:C1720(This:C1470.dataModel)
		
	End if 
	
	$tables:=$tables.filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1)))
	
	//====================================
	// Returns the collection of the fields of a table data model
Function fields($table : Variant)->$fields : Collection
	
	var $model : Object
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($table)=Is object:K8:27)  // Table model
				
				$model:=$table
				
				//______________________________________________________
			: (Value type:C1509($table)=Is longint:K8:6)\
				 | (Value type:C1509($table)=Is real:K8:4)  // Table number
				
				$model:=This:C1470.dataModel[String:C10($table)]
				
				//______________________________________________________
			Else   // Table name
				
				$model:=This:C1470.dataModel[$table]
				
				//______________________________________________________
		End case 
		
		//key # "" et object
		$fields:=OB Entries:C1720($model).filter("col_formula"; Formula:C1597($1.result:=(Length:C16($1.value.key)#0) & (Value type:C1509($1.value.value)=Is object:K8:27)))
		
	Else 
		
		// #Error
		
	End if 
	
	//====================================
	// Returns the collection of the storage  fields of a table data model
Function storageFields($table : Variant)->$fields : Collection
	
	var $model : Object
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($table)=Is object:K8:27)  // Table model
				
				$model:=$table
				
				//______________________________________________________
			: (Value type:C1509($table)=Is longint:K8:6)\
				 | (Value type:C1509($table)=Is real:K8:4)  // Table number
				
				$model:=This:C1470.dataModel[String:C10($table)]
				
				//______________________________________________________
			Else   // Table name
				
				$model:=This:C1470.dataModel[$table]
				
				//______________________________________________________
		End case 
		
		$fields:=OB Entries:C1720($model).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1)))
		
	Else 
		
		// #Error
		
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
	$0:=($1.relatedDataClass#Null:C1517) & (Not:C34(Bool:C1537($1.isToMany)))
	
	//====================================
Function isRelationToMany
	
	var $0 : Boolean
	var $1 : Object  // Field
	$0:=(($1.relatedEntities#Null:C1517) | (String:C10($1.kind)="relatedEntities")) | (Bool:C1537($1.isToMany))
	
	//================================================================================
	// Returns True if the 4D Type is a Numeric type
Function isNumeric($type : Integer)->$isNumeric : Boolean
	
	$isNumeric:=(New collection:C1472(Is integer:K8:5; Is longint:K8:6; Is integer 64 bits:K8:25; Is real:K8:4; _o_Is float:K8:26).indexOf($type)#-1)
	
	//================================================================================
	// Returns True if the 4D Type is a String type
Function isString($type : Integer)->$isNumeric : Boolean
	
	$isNumeric:=(New collection:C1472(Is alpha field:K8:1; Is text:K8:3).indexOf($type)#-1)
	
	//================================================================================
	//Add a table to the data model
Function addTable($table : Object)->$tableModel : Object
	
	var $o : Object
	
	ASSERT:C1129($table.tableNumber#Null:C1517)
	
	$o:=This:C1470.getCatalog().query("tableNumber = :1"; $table.tableNumber).pop()
	ASSERT:C1129($o#Null:C1517)
	
	// Put internal properties into a substructure
	$tableModel:=New object:C1471(\
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
	This:C1470.addToMain($table.tableNumber)
	
	This:C1470.dataModel[String:C10($table.tableNumber)]:=$tableModel
	
/* ===================================
Delete the table from the data model
====================================*/
Function removeTable
	var $0 : Collection
	var $1 : Variant
	
	If (This:C1470.dataModel#Null:C1517)
		
		OB REMOVE:C1226(This:C1470.dataModel; String:C10($1))
		
	End if 
	
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
	
	If (True:C214)
		
		For each ($t; OB Keys:C1719($1)) Until ($0)
			
			$0:=Value type:C1509($1[$t])=Is object:K8:27
			
		End for each 
		
	Else 
		
		$0:=OB Entries:C1720($1).filter("col_formula"; Formula:C1597($1.result:=(Value type:C1509($1.value)=Is object:K8:27))).length>0
		
	End if 
	
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
	
	
Function audit($audits : Object)->$audit : Object
	
	If (Count parameters:C259>=1)
		
		$audit:=project_Audit($audits)
		
	Else 
		
		$audit:=project_Audit
		
	End if 
	
	cs:C1710.ob.new(This:C1470).createPath("$project.status").$project.status.project:=$audit.success
	//cs.ob.new(This).createPath("$project.status").project:=$audit.success
	
	//================================================================================
Function fieldDefinition
	