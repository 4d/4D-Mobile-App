//%attributes = {}
#DECLARE($form : Object; $row : Integer)


var $fieldID : Text
var $count : Integer
var $context; $dataModel; $linkDataModel; $relatedCatalog; $tableDataModel; $target : Object
var $c : Collection
var $field : cs:C1710.field

$context:=$form.form

$relatedCatalog:=Form:C1466.$project.ExposedStructure.relatedCatalog($context.currentTable.name; $context.fieldName; True:C214)

If ($relatedCatalog.success)  // Open field picker
	
	$dataModel:=Form:C1466.dataModel
	
	If (Bool:C1537($context.fieldSortByName))
		
		$relatedCatalog.fields:=$relatedCatalog.fields.orderBy("path")
		
	End if 
	
	$tableDataModel:=$dataModel[String:C10($context.currentTable.tableNumber)]
	$linkDataModel:=$tableDataModel[$relatedCatalog.relatedEntity]
	
	For each ($field; $relatedCatalog.fields)
		
		Case of 
				
				//______________________________________________________
			: (String:C10($field.valueType)="@Selection")  // 1 -> N
				
				$field.fieldType:=8859
				$field.published:=($linkDataModel[$field.name]#Null:C1517)
				
				//______________________________________________________
			: ($field.kind="calculated")
				
				$field.published:=($linkDataModel[$field.name]#Null:C1517)
				
				//______________________________________________________
			: ($field.kind="alias")
				
				$field.published:=($linkDataModel[$field.name]#Null:C1517)
				
				//______________________________________________________
			Else 
				
				$fieldID:=String:C10($field.fieldNumber)
				$c:=Split string:C1554($field.path; ".")
				
				If ($c.length=1)
					
					$field.published:=($linkDataModel[$fieldID]#Null:C1517)
					
				Else 
					
					// Enhance_relation
					$field.published:=($linkDataModel[$c[0]][$fieldID]#Null:C1517)
					
				End if 
				
				//______________________________________________________
		End case 
		
		$field.icon:=EDITOR.fieldIcons[$field.fieldType]
		
	End for each 
	
	$relatedCatalog.window:=Open form window:C675("RELATED"; Sheet form window:K39:12; *)
	DIALOG:C40("RELATED"; $relatedCatalog)
	
	If ($relatedCatalog.success)  // Dialog was validated
		
		// The number of published
		$count:=$relatedCatalog.fields.query("published=true").length
		
		If ($count>0)  // At least one related field is published
			
			If ($tableDataModel=Null:C1517)\
				 | OB Is empty:C1297($tableDataModel)
				
				$tableDataModel:=PROJECT.addTable($context.currentTable)
				
			End if 
			
			For each ($field; $relatedCatalog.fields)
				
				$fieldID:=String:C10($field.fieldNumber)
				$c:=Split string:C1554($field.path; ".")
				
				If ($field.published)
					
					$target:=$tableDataModel[$context.fieldName]
					
					If ($target=Null:C1517)
						
						// Create the relation
						$target:=New object:C1471(\
							"relatedDataClass"; $relatedCatalog.relatedDataClass; \
							"inverseName"; $relatedCatalog.inverseName; \
							"relatedTableNumber"; $relatedCatalog.relatedTableNumber)
						
						$tableDataModel[$context.fieldName]:=$target
						
					End if 
					
					// Create the field, if any
					If ($c.length>1)
						
						If ($target[$c[0]]=Null:C1517)
							
							$target[$c[0]]:=New object:C1471(\
								"relatedDataClass"; $field.tableName; \
								"inverseName"; $context.currentTable.field.query("name=:1"; $context.fieldName).pop().inverseName; \
								"relatedTableNumber"; $field.tableNumber)
							
						End if 
						
						If ($target[$c[0]][$fieldID]=Null:C1517)
							
							$target[$c[0]][$fieldID]:=New object:C1471(\
								"name"; $field.name; \
								"path"; $field.path; \
								"label"; PROJECT.label($field.name); \
								"shortLabel"; PROJECT.shortLabel($field.name); \
								"type"; $field.type; \
								"fieldType"; $field.fieldType)
							
						End if 
						
					Else 
						
						Case of 
								
								//______________________________________________________
							: ($field.kind="relatedEntities")
								
								If ($target[$field.name]=Null:C1517)
									
									$target[$field.name]:=New object:C1471(\
										"name"; $field.name; \
										"relatedDataClass"; $field.relatedDataClass; \
										"relatedTableNumber"; $field.relatedTableNumber; \
										"path"; $context.fieldName+"."+$field.path; \
										"label"; PROJECT.labelList($field.name); \
										"shortLabel"; PROJECT.label($field.name); \
										"inverseName"; $field.inverseName; \
										"isToMany"; True:C214)
									
								End if 
								
								//______________________________________________________
							: ($field.kind="calculated")
								
								If ($target[$field.name]=Null:C1517)
									
									$target[$field.name]:=New object:C1471(\
										"name"; $field.name; \
										"path"; $field.path; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name); \
										"fieldType"; $field.fieldType; \
										"computed"; True:C214)
									
								End if 
								
								//______________________________________________________
							Else 
								
								If ($target[$fieldID]=Null:C1517)
									
									$target[$fieldID]:=New object:C1471(\
										"name"; $field.name; \
										"path"; $field.path; \
										"label"; PROJECT.label($field.name); \
										"shortLabel"; PROJECT.shortLabel($field.name); \
										"type"; $field.type; \
										"fieldType"; $field.fieldType)
									
								End if 
								
								//______________________________________________________
						End case 
					End if 
					
				Else 
					
					// Remove the field, if any
					
					Case of 
							//______________________________________________________
						: ($field.kind="relatedEntities")
							
							If ($linkDataModel#Null:C1517)
								
								OB REMOVE:C1226($linkDataModel; $field.name)
								
							End if 
							
							//______________________________________________________
						: ($field.kind="calculated")
							
							If ($target#Null:C1517)
								
								OB REMOVE:C1226($target; $field.name)
								
							End if 
							
							//______________________________________________________
						Else 
							
							If ($c.length>1)
								
								If ($target[$c[0]][String:C10($field.fieldNumber)]#Null:C1517)
									
									OB REMOVE:C1226($target[$c[0]]; String:C10($field.fieldNumber))
									
									// Remove the link if no more fields are published
									If (OB Entries:C1720($target[$c[0]]).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1))).length=0)
										
										OB REMOVE:C1226($target; $c[0])
										
									End if 
								End if 
								
							Else 
								
								If ($target[$fieldID].path#Null:C1517)
									
									If ($target[$fieldID].path=$field.path)
										
										OB REMOVE:C1226($target; $fieldID)
										
									End if 
								End if 
							End if 
							
							//______________________________________________________
					End case 
				End if 
			End for each 
			
			// Checkbox value according to the count
			If ($count>0)
				
				$count:=1+Num:C11($count#$relatedCatalog.fields.length)
				
			End if 
		End if 
		
		($form.publishedPtr)->{$row}:=$count
		
	End if 
	
Else 
	
	If (Macintosh command down:C546 | Shift down:C543)
		
		//
		
	Else 
		
		// Invert published status
		($form.publishedPtr)->{$row}:=1-($form.publishedPtr)->{$row}
		
	End if 
End if 

STRUCTURE_UPDATE($form)