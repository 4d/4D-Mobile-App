//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_UPDATE
// ID[5478941602C842A7B3FCBC8097348516]
// Created 23-1-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Updating the data model and project dependencies
// ----------------------------------------------------
// Declarations
var $1 : Object

var $t : Text
var $found : Boolean
var $indx; $type : Integer
var $context; $currentTable; $dataModel; $field; $form; $o; $oo; $table : Object
var $published : Collection

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$form:=$1
	
Else 
	
	$form:=STRUCTURE_Handler(New object:C1471(\
		"action"; "init"))
	
End if 

$dataModel:=PROJECT.dataModel

$context:=$form.form
$currentTable:=$context.currentTable
$published:=New collection:C1472

// ----------------------------------------------------

// GET THE PUBLISHED FIELD NAMES LIST
ARRAY TO COLLECTION:C1563($published; ($form.publishedPtr)->; "published"; (UI.pointer($form.fields))->; "name")

If ($published.extract("published").countValues(0)=$published.length)\
 & ($published.extract("published").indexOf(2)=-1)\
 & (Length:C16(String:C10($context.fieldFilter))=0)\
 & (Not:C34(Bool:C1537($context.fieldFilterPublished)))
	
	// NO FIELD PUBLISHED
	PROJECT.removeTable($currentTable.tableNumber)
	
	// UI - De-emphasize the table name
	$indx:=Find in array:C230((UI.pointer($form.tableList))->; True:C214)
	LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
	
Else 
	
	$table:=$dataModel[String:C10($currentTable.tableNumber)]
	
	If ($table=Null:C1517)
		
		// ADD TABLE
		$table:=PROJECT.addTable($currentTable)
		
		// UI - Emphasize the table name
		$indx:=Find in array:C230((UI.pointer($form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Bold:K14:2)
		
	End if 
	
	// For each published field
	For each ($o; $published)
		
		// Find if the field exists in the data model [
		CLEAR VARIABLE:C89($found)
		
		For each ($t; $table) Until ($found)
			
			Case of 
					
					//………………………………………………………………………………………………………
				: (Length:C16($t)=0)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………
				: (PROJECT.isField($t))
					
					$found:=(String:C10($table[$t].name)=$o.name)
					
					If ($found)
						
						$field:=$currentTable.field[$currentTable.field.extract("name").indexOf($o.name)]
						
					End if 
					
					//………………………………………………………………………………………………………
				: (Value type:C1509($table[$t])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToOne($table[$t]))  // N -> 1 relation
					
					$found:=(String:C10($o.name)=$t) & (Num:C11($o.published)#2)  // Not mixed
					
					If ($found)
						
						$field:=$currentTable.field.query("name=:1"; $t).pop()
						
					End if 
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToMany($table[$t]))  // 1 -> N relation
					
					$found:=(String:C10($o.name)=$t)
					
					If ($found)
						
						$field:=$currentTable.field[$currentTable.field.extract("name").indexOf($t)]
						
					End if 
					
					//………………………………………………………………………………………………………
			End case 
		End for each 
		//]
		
		If (Not:C34($found))
			
			// Get from cache
			$field:=$currentTable.field.query("name = :1"; $o.name).pop()
			
		End if 
		
		$type:=Num:C11($field.type)
		
		Case of 
				
				//_____________________________________________________
			: (Num:C11($o.published)=1)\
				 & (Not:C34($found))  // ADDED
				
				Case of 
						
						//………………………………………………………………………………………………………
					: ($type=-1)  // N -> 1 relation
						
						// 🕛 #MARK_TO_OPTIMIZE
						
						// Add all related fields
						$o:=_o_structure(New object:C1471(\
							"action"; "relatedCatalog"; \
							"table"; $table[""].name; \
							"relatedEntity"; $o.name))
						
						If (Asserted:C1132($o.success))
							
							$table[$field.name]:=New object:C1471(\
								"relatedDataClass"; $field.relatedDataClass; \
								"relatedTableNumber"; $o.relatedTableNumber; \
								"inverseName"; $o.inverseName)
							
							For each ($oo; $o.fields)
								
								If ($oo.fieldType>=0)
									
									$table[$field.name][String:C10($oo.fieldNumber)]:=New object:C1471(\
										"name"; $oo.name; \
										"label"; formatString("label"; $oo.name); \
										"shortLabel"; formatString("label"; $oo.name); \
										"fieldType"; $oo.fieldType; \
										"relatedTableNumber"; $o.relatedTableNumber)
									
									// #TEMPO [
									$table[$field.name][String:C10($oo.fieldNumber)].type:=$oo.type
									//]
									
								End if 
							End for each 
						End if 
						
						//………………………………………………………………………………………………………
					: ($type=-2)  // 1 -> N relation
						
						$table[$field.name]:=New object:C1471(\
							"label"; formatString("label"; _o_str("listOf").localized($field.name)); \
							"shortLabel"; formatString("label"; $field.name); \
							"relatedEntities"; $field.relatedDataClass; \
							"relatedTableNumber"; $field.relatedTableNumber; \
							"inverseName"; $field.inverseName)
						
						//………………………………………………………………………………………………………
					Else 
						
						// Add the field to data model
						$table[String:C10($field.id)]:=New object:C1471(\
							"name"; $field.name; \
							"label"; formatString("label"; $field.name); \
							"shortLabel"; formatString("label"; $field.name); \
							"fieldType"; $field.fieldType)
						
						// #TEMPO [
						$table[String:C10($field.id)].type:=$field.type
						//]
						
						//………………………………………………………………………………………………………
				End case 
				
				//_____________________________________________________
			: (Num:C11($o.published)=0)\
				 & ($found)  // REMOVED
				
				Case of 
						
						//………………………………………………………………………………………………………
					: ($type=-1)  // N -> 1 relation
						
						// Remove all related fields
						If ($table[$o.name]#Null:C1517)
							
							OB REMOVE:C1226($table; $o.name)
							
						End if 
						
						//………………………………………………………………………………………………………
					: ($type=-2)  // 1 -> N relation
						
						If ($table[$o.name]#Null:C1517)
							
							OB REMOVE:C1226($table; $o.name)
							
						End if 
						
						//………………………………………………………………………………………………………
					Else 
						
						// Remove the field
						OB REMOVE:C1226($table; String:C10($field.id))
						
						//………………………………………………………………………………………………………
				End case 
				
				//_____________________________________________________
			: (Num:C11($o.published)=0)
				
				// <NOTHING MORE TO DO>
				
				//_____________________________________________________
			Else 
				
				// MIXED
				
				//_____________________________________________________
		End case 
	End for each 
	
	// REMOVE TABLE IF NO MORE PUBLISHED FIELDS
	If (OB Keys:C1719($table).length=1)
		
		PROJECT.removeTable($currentTable.tableNumber)
		
		// UI - De-emphasize the table name
		$indx:=Find in array:C230((UI.pointer($form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
		
	End if 
End if 

PROJECT.save()

// Update field list
structure_FIELD_LIST($form)

$context.setHelpTip($form.fieldList; $form)