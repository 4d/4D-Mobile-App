//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : structure_FIELD_LIST
// ID[A234508D040444C6812812D5684858F3]
// Created 1-2-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Displays the field list of the selected table
// with filtering and sort
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(structure_FIELD_LIST; $1)
End if 

var $item : Text
var $isFound; $withError : Boolean
var $color; $column; $i; $row; $style : Integer
var $Ptr_fields; $Ptr_icons; $Ptr_list; $Ptr_published : Pointer
var $context; $field; $form; $o; $table : Object
var $selectedItems; $unsynchronized : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$form:=$1
	
	// Optional parameters
	// <NONE>
	
	$context:=$form.form
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Ptr_fields:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fields)
$Ptr_icons:=OBJECT Get pointer:C1124(Object named:K67:5; $form.icons)
$Ptr_published:=OBJECT Get pointer:C1124(Object named:K67:5; $form.published)

var $dataModel : Object
$dataModel:=Form:C1466.dataModel

// Keep the selected field to restore the selection if necessary
$selectedItems:=New collection:C1472

If (Size of array:C274($Ptr_fields->)>0)
	
	LISTBOX GET CELL POSITION:C971(*; $form.fieldList; $column; $row)
	
	$context.fieldName:=$Ptr_fields->{$row}
	
	// Keep the selection
	$Ptr_list:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fieldList)
	
	For ($i; 1; LISTBOX Get number of rows:C915(*; $form.fieldList); 1)
		
		If ($Ptr_list->{$i})
			
			$selectedItems.push($Ptr_fields->{$i})
			
		End if 
	End for 
End if 

CLEAR VARIABLE:C89($Ptr_fields->)
CLEAR VARIABLE:C89($Ptr_published->)
CLEAR VARIABLE:C89($Ptr_icons->)

// Is there a selected table?
LISTBOX GET CELL POSITION:C971(*; $form.tableList; $column; $row)

If ($row>0)
	
	// ----------------------
	//  POPULATE THE LIST
	// ----------------------
	$table:=$context.currentTable
	
	If ($table#Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: (Length:C16(String:C10($context.fieldFilter))>0)\
				 & (Bool:C1537($context.fieldFilterPublished))  // Filter by name & only published
				
				For each ($field; $table.field)
					
					If (Position:C15($context.fieldFilter; $field.name)>0)
						
						If (PROJECT.isRelationToOne($field))
							
							//#MARK_TO_OPTIMIZE
							$o:=_o_structure(New object:C1471(\
								"action"; "catalog"; \
								"tableNumber"; $field.relatedTableNumber))
							
							If ($o.success)
								
								For each ($o; $o.value[0].field) Until ($isFound)
									
									$isFound:=($dataModel[String:C10($table.tableNumber)][$field.name][String:C10($o.id)]#Null:C1517)
									
									If ($isFound)
										
										STRUCTURE_Handler(New object:C1471(\
											"action"; "appendField"; \
											"table"; $table; \
											"field"; $field; \
											"fields"; $Ptr_fields; \
											"published"; $Ptr_published; \
											"icons"; $Ptr_icons))
										
									End if 
								End for each 
							End if 
							
						Else 
							
							If ($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
								
								STRUCTURE_Handler(New object:C1471(\
									"action"; "appendField"; \
									"table"; $table; \
									"field"; $field; \
									"fields"; $Ptr_fields; \
									"published"; $Ptr_published; \
									"icons"; $Ptr_icons))
								
							End if 
						End if 
					End if 
				End for each 
				
				//______________________________________________________
			: (Length:C16(String:C10($context.fieldFilter))>0)  // Filter by name
				
				For each ($field; $table.field)
					
					If (Position:C15($context.fieldFilter; $field.name)>0)
						
						STRUCTURE_Handler(New object:C1471(\
							"action"; "appendField"; \
							"table"; $table; \
							"field"; $field; \
							"fields"; $Ptr_fields; \
							"published"; $Ptr_published; \
							"icons"; $Ptr_icons))
						
					End if 
				End for each 
				
				//______________________________________________________
			: (Bool:C1537($context.fieldFilterPublished))  // Only published
				
				For each ($field; $table.field)
					
					If (PROJECT.isRelationToOne($field))
						
						//#MARK_TO_OPTIMIZE
						$o:=_o_structure(New object:C1471(\
							"action"; "catalog"; \
							"tableNumber"; $field.relatedTableNumber))
						
						If ($o.success)
							
							For each ($o; $o.value[0].field) Until ($isFound)
								
								$isFound:=($dataModel[String:C10($table.tableNumber)][$field.name][String:C10($o.id)]#Null:C1517)
								
								If ($isFound)
									
									STRUCTURE_Handler(New object:C1471(\
										"action"; "appendField"; \
										"table"; $table; \
										"field"; $field; \
										"fields"; $Ptr_fields; \
										"published"; $Ptr_published; \
										"icons"; $Ptr_icons))
									
								End if 
							End for each 
						End if 
						
					Else 
						
						If ($dataModel[String:C10($table.tableNumber)][String:C10($field.id)]#Null:C1517)
							
							STRUCTURE_Handler(New object:C1471(\
								"action"; "appendField"; \
								"table"; $table; \
								"field"; $field; \
								"fields"; $Ptr_fields; \
								"published"; $Ptr_published; \
								"icons"; $Ptr_icons))
							
						End if 
					End if 
				End for each 
				
				//______________________________________________________
			Else   // No filter
				
				For each ($field; $table.field)
					
					STRUCTURE_Handler(New object:C1471(\
						"action"; "appendField"; \
						"table"; $table; \
						"field"; $field; \
						"fields"; $Ptr_fields; \
						"published"; $Ptr_published; \
						"icons"; $Ptr_icons))
					
				End for each 
				
				If (FEATURE.with("alias"))
					
					
					
					
					
				End if 
				
				If (FEATURE.with("many-one-many"))
					
					var $relatedDataClasses : 4D:C1709.DataClass
					
					For each ($field; $table.field.query("isToMany = true & relatedDataClass != :1"; $table.name))
						
						$relatedDataClasses:=ds:C1482[ds:C1482[$table.name][$field.name].relatedDataClass]
						
						var $t : Text
						For each ($t; $relatedDataClasses)
							
							If ($relatedDataClasses[$t].kind="relatedEntity")\
								 & (String:C10($relatedDataClasses[$t].relatedDataClass)#$table.name)
								
								$o:=New object:C1471(\
									"oneToOne"; True:C214; \
									"name"; $relatedDataClasses[$t].relatedDataClass; \
									"path"; New collection:C1472($field.name; $t; $relatedDataClasses[$t].relatedDataClass).join(".")\
									)
								
								STRUCTURE_Handler(New object:C1471(\
									"action"; "appendField"; \
									"table"; $table; \
									"field"; $o; \
									"fields"; $Ptr_fields; \
									"published"; $Ptr_published; \
									"icons"; $Ptr_icons))
								
							End if 
						End for each 
					End for each 
				End if 
				
				//______________________________________________________
		End case 
		
		// ----------------------
		//       HIGHLIGHT
		// ----------------------
		If (Form:C1466.$dialog.unsynchronizedTableFields#Null:C1517)
			
			If (Form:C1466.$dialog.unsynchronizedTableFields.length>$table.tableNumber)
				
				$unsynchronized:=Form:C1466.$dialog.unsynchronizedTableFields[$table.tableNumber]
				
			End if 
		End if 
		
		CLEAR VARIABLE:C89($row)
		
		For each ($field; $table.field)
			
			If (Find in array:C230($Ptr_fields->; $field.name)>0)  // In list
				
				$row:=$row+1
				
				$withError:=($unsynchronized#Null:C1517)
				
				If ($withError)
					
					$withError:=($unsynchronized.query("name = :1 OR parent = :1"; $field.name).pop()#Null:C1517)\
						 | ($unsynchronized.length=0)
					
				End if 
				
				$style:=Plain:K14:1
				$color:=lk inherited:K53:26
				
				If ($withError)
					
					$color:=EDITOR.errorColor
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($field.type=-1)
							
							$style:=Underline:K14:4
							$color:=EDITOR.selectedColor
							
							//______________________________________________________
						: ($field.type=-2)
							
							If ($field.relatedTableNumber#$table.tableNumber)  // Not for a recursive relation
								
								If ($dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)\
									 & ($dataModel[String:C10($table.tableNumber)][$field.name]#Null:C1517)
									
									$color:=EDITOR.errorColor
									
								End if 
							End if 
							
							//______________________________________________________
						Else 
							
							// Highlight primary key
							If ($field.name=$table.primaryKey)
								
								$style:=Bold:K14:2
								
							End if 
							
							//______________________________________________________
					End case 
				End if 
				
				LISTBOX SET ROW FONT STYLE:C1268(*; $form.fieldList; $row; $style)
				LISTBOX SET ROW COLOR:C1270(*; $form.fieldList; $row; $color; lk font color:K53:24)
				
			End if 
		End for each 
	End if 
End if 

If (Not:C34(FEATURE.with("android1ToNRelations")))
	
	tempoDatamodelWith1toNRelation($context.currentTable)
	
End if 

// Disable field publication if the table is missing
OBJECT SET ENTERABLE:C238($Ptr_published->; PROJECT.isNotLocked())

// Sort if any
If ($context.fieldSortByName)
	
	LISTBOX SORT COLUMNS:C916(*; $form.fieldList; 3; >)
	
End if 

// Restore the selection
LISTBOX SELECT ROW:C912(*; $form.fieldList; 0; lk remove from selection:K53:3)

If ($selectedItems.length>0)
	
	For each ($item; $selectedItems)
		
		$row:=Find in array:C230($Ptr_fields->; $item)
		
		If ($row>0)
			
			LISTBOX SELECT ROW:C912(*; $form.fieldList; $row; lk add to selection:K53:2)
			
		End if 
	End for each 
	
	$row:=Find in array:C230($Ptr_fields->; String:C10($context.fieldName))
	
	If ($row>0)
		
		OBJECT SET SCROLL POSITION:C906(*; $form.fieldList; $row)
		
	Else 
		
		OBJECT SET SCROLL POSITION:C906(*; $form.fieldList)
		OB REMOVE:C1226($context; "fieldName")
		
	End if 
	
Else 
	
	OBJECT SET SCROLL POSITION:C906(*; $form.fieldList)
	OB REMOVE:C1226($context; "fieldName")
	
End if 

SET TIMER:C645(-1)