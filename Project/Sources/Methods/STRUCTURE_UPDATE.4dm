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
#DECLARE($form : Object)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_UPDATE; $1)
End if 

var $t : Text
var $found : Boolean
var $indx : Integer
var $context; $currentTable; $field; $o; $table : Object
var $published : Collection
var $structure : cs:C1710.structure

// ----------------------------------------------------
// Initialisations
$context:=$form.form
$currentTable:=$context.currentTable

$structure:=cs:C1710.structure.new()

// ----------------------------------------------------
// GET THE PUBLISHED FIELD NAMES LIST
$published:=New collection:C1472
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
	
	$table:=PROJECT.dataModel[String:C10($currentTable.tableNumber)]
	
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
					
					ASSERT:C1129(PROJECT.isField($table[$t]))
					
					$found:=(String:C10($table[$t].name)=$o.name)
					$t:=$o.name
					
					//………………………………………………………………………………………………………
				: (Value type:C1509($table[$t])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToOne($table[$t]))  // N -> 1 relation
					
					$found:=(String:C10($o.name)=$t) & (Num:C11($o.published)#2)  // Not mixed
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToMany($table[$t]))  // 1 -> N relation
					
					$found:=(String:C10($o.name)=$t)
					
					//………………………………………………………………………………………………………
				: (PROJECT.isComputedAttribute($table[$t]))  // Computed attribute
					
					$found:=(String:C10($o.name)=$t)
					
					//………………………………………………………………………………………………………
				: (PROJECT.isAlias($table[$t]))  // Computed attribute
					
					$found:=(String:C10($o.name)=$t)
					
					//………………………………………………………………………………………………………
				Else 
					
					ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
					
					//………………………………………………………………………………………………………
			End case 
		End for each 
		
		If ($found)
			
			$field:=$currentTable.field.query("name = :1"; $t).pop()
			
		Else 
			
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