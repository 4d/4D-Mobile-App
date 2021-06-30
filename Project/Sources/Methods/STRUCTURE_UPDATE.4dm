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

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_UPDATE; $1)
End if 

var $t : Text
var $found : Boolean
var $indx : Integer
var $context; $currentTable; $dataModel; $field; $form; $o; $table : Object
var $published : Collection
var $structure : cs:C1710.structure

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$form:=$1
	
Else 
	
	$form:=STRUCTURE_Handler(New object:C1471(\
		"action"; "init"))
	
End if 

$dataModel:=Form:C1466.dataModel

$context:=$form.form
$currentTable:=$context.currentTable

$structure:=cs:C1710.structure.new()

$published:=New collection:C1472

// ----------------------------------------------------
// GET THE PUBLISHED FIELD NAMES LIST
ARRAY TO COLLECTION:C1563($published; ($form.publishedPtr)->; "published"; (OBJECT Get pointer:C1124(Object named:K67:5; $form.fields))->; "name")

If ($published.extract("published").countValues(0)=$published.length)\
 & ($published.extract("published").indexOf(2)=-1)\
 & (Length:C16(String:C10($context.fieldFilter))=0)\
 & (Not:C34(Bool:C1537($context.fieldFilterPublished)))
	
	// NO FIELD PUBLISHED
	PROJECT.removeTable($currentTable.tableNumber)
	
	// UI - De-emphasize the table name
	$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
	LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
	
Else 
	
	$table:=$dataModel[String:C10($currentTable.tableNumber)]
	
	If ($table=Null:C1517)
		
		// Add the table to the data model
		$table:=PROJECT.addTable($currentTable)
		
		// UI - Emphasize the table name
		$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Bold:K14:2)
		
	End if 
	
	// For each item into the list
	For each ($o; $published)
		
		// Search if the item exists in the data model
		$found:=False:C215
		
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
		
		If (Not:C34($found))
			
			// Get from cache
			$field:=$currentTable.field.query("name = :1"; $o.name).pop()
			
		End if 
		
		Case of 
				
				//_____________________________________________________
			: (Num:C11($o.published)=1) & Not:C34($found)  // ADDED
				
				$structure.addField($table; $field)
				
				//_____________________________________________________
			: (Num:C11($o.published)=0) & $found  // REMOVED
				
				$structure.removeField($table; Choose:C955(Num:C11($field.type)<0; $o.name; $field.id))
				
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
		$indx:=Find in array:C230((OBJECT Get pointer:C1124(Object named:K67:5; $form.tableList))->; True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $indx; Plain:K14:1)
		
	End if 
End if 

PROJECT.save()

// Update field list
structure_FIELD_LIST($form)

$context.setHelpTip($form.fieldList; $form)