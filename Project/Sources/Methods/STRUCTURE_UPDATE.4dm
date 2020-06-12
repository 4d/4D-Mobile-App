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
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_found)
C_LONGINT:C283($Lon_indx;$Lon_type)
C_TEXT:C284($t;$Txt_fieldNumber;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$o;$Obj_context;$Obj_currentTable;$Obj_dataModel;$Obj_field)
C_OBJECT:C1216($Obj_form;$Obj_related;$Obj_table)
C_COLLECTION:C1488($Col_published)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_UPDATE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Count parameters:C259>=1)
	
	$Obj_form:=$1
	
Else 
	
	$Obj_form:=STRUCTURE_Handler (New object:C1471(\
		"action";"init"))
	
End if 

$Obj_context:=$Obj_form.form

$ƒ:=Storage:C1525.ƒ

  // ----------------------------------------------------
$Obj_dataModel:=Form:C1466.dataModel
$Obj_currentTable:=$Obj_context.currentTable
$Txt_tableNumber:=String:C10($Obj_currentTable.tableNumber)

  // GET THE PUBLISHED FIELD NAMES LIST
$Col_published:=New collection:C1472
ARRAY TO COLLECTION:C1563($Col_published;($Obj_form.publishedPtr)->;"published";(ui.pointer($Obj_form.fields))->;"name")

If ($Col_published.extract("published").countValues(0)=$Col_published.length)\
 & ($Col_published.extract("published").indexOf(2)=-1)\
 & (Length:C16(String:C10($Obj_context.fieldFilter))=0)\
 & (Not:C34(Bool:C1537($Obj_context.fieldFilterPublished)))
	
	  // NO FIELD PUBLISHED
	
	OB REMOVE:C1226($Obj_dataModel;$Txt_tableNumber)
	
	  // Update main menu
	main_Handler (New object:C1471(\
		"action";"remove";\
		"tableNumber";$Txt_tableNumber))
	
	  // UI - De-emphasize the table name
	$Lon_indx:=Find in array:C230((ui.pointer($Obj_form.tableList))->;True:C214)
	LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_indx;Plain:K14:1)
	
Else 
	
	$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
	
	  // Create the table if it does not exist
	If ($Obj_table=Null:C1517)
		
		$Obj_table:=STRUCTURE_Handler (New object:C1471(\
			"action";"addTable"))
		
	End if 
	
	For each ($o;$Col_published)  // For each published field
		
		  // Find if the field exists in the data model [
		CLEAR VARIABLE:C89($Boo_found)
		
		For each ($t;$Obj_table) Until ($Boo_found)
			
			Case of 
					
					  //………………………………………………………………………………………………………
				: (Length:C16($t)=0)
					
					  // <NOTHING MORE TO DO>
					
					  //………………………………………………………………………………………………………
				: ($ƒ.isField($t))
					
					$Boo_found:=(String:C10($Obj_table[$t].name)=$o.name)
					
					If ($Boo_found)
						
						$Obj_field:=$Obj_currentTable.field[$Obj_currentTable.field.extract("name").indexOf($o.name)]
						
					End if 
					
					  //………………………………………………………………………………………………………
				: (Value type:C1509($Obj_table[$t])#Is object:K8:27)
					
					  // <NOTHING MORE TO DO>
					
					  //………………………………………………………………………………………………………
				: ($ƒ.isRelationToOne($Obj_table[$t]))  // N -> 1 relation
					
					$Boo_found:=(String:C10($o.name)=$t) & (Num:C11($o.published)#2)  // Not mixed
					
					If ($Boo_found)
						
						$Obj_field:=$Obj_currentTable.field[$Obj_currentTable.field.extract("name").indexOf($t)]
						
					End if 
					
					  //………………………………………………………………………………………………………
				: ($ƒ.isRelationToMany($Obj_table[$t]))  // 1 -> N relation
					
					$Boo_found:=(String:C10($o.name)=$t)
					
					If ($Boo_found)
						
						$Obj_field:=$Obj_currentTable.field[$Obj_currentTable.field.extract("name").indexOf($t)]
						
					End if 
					
					  //………………………………………………………………………………………………………
			End case 
		End for each 
		  //]
		
		If (Not:C34($Boo_found))
			
			  // Get from cache
			$Lon_indx:=$Obj_currentTable.field.extract("name").indexOf($o.name)
			$Obj_field:=$Obj_currentTable.field[$Lon_indx]
			
		End if 
		
		$Lon_type:=Num:C11($Obj_field.type)
		$Txt_fieldNumber:=String:C10($Obj_field.id)
		
		Case of 
				
				  //_____________________________________________________
			: (Num:C11($o.published)=1)\
				 & (Not:C34($Boo_found))  // ADDED
				
				Case of 
						
						  //………………………………………………………………………………………………………
					: ($Lon_type=-1)  // N -> 1 relation
						
						  //#MARK_TO_OPTIMIZE
						  // Add all related fields
						$o:=structure (New object:C1471(\
							"action";"relatedCatalog";\
							"table";$Obj_table[""].name;\
							"relatedEntity";$o.name))
						
						If (Asserted:C1132($o.success))
							
							$Obj_table[$Obj_field.name]:=New object:C1471(\
								"relatedDataClass";$Obj_field.relatedDataClass;\
								"relatedTableNumber";$o.relatedTableNumber;\
								"inverseName";$o.inverseName)
							
							For each ($Obj_related;$o.fields)
								
								If ($Obj_related.fieldType>=0)
									
									$Obj_table[$Obj_field.name][String:C10($Obj_related.fieldNumber)]:=New object:C1471(\
										"name";$Obj_related.name;\
										"label";formatString ("label";$Obj_related.name);\
										"shortLabel";formatString ("label";$Obj_related.name);\
										"fieldType";$Obj_related.fieldType;\
										"relatedTableNumber";$o.relatedTableNumber)
									
									  // #TEMPO [
									$Obj_table[$Obj_field.name][String:C10($Obj_related.fieldNumber)].type:=$Obj_related.type
									  //]
									
								End if 
							End for each 
						End if 
						
						  //………………………………………………………………………………………………………
					: ($Lon_type=-2)  // 1 -> N relation
						
						$Obj_table[$Obj_field.name]:=New object:C1471(\
							"label";formatString ("label";str ("listOf").localized($Obj_field.name));\
							"shortLabel";formatString ("label";$Obj_field.name);\
							"relatedEntities";$Obj_field.relatedDataClass;\
							"relatedTableNumber";$Obj_field.relatedTableNumber;\
							"inverseName";$Obj_field.inverseName)
						
						  //………………………………………………………………………………………………………
					Else 
						
						  // Add the field to data model
						$Obj_table[$Txt_fieldNumber]:=New object:C1471(\
							"name";$Obj_field.name;\
							"label";formatString ("label";$Obj_field.name);\
							"shortLabel";formatString ("label";$Obj_field.name);\
							"fieldType";$Obj_field.fieldType)
						
						  // #TEMPO [
						$Obj_table[$Txt_fieldNumber].type:=$Obj_field.type
						  //]
						
						  //………………………………………………………………………………………………………
				End case 
				
				  //_____________________________________________________
			: (Num:C11($o.published)=0)\
				 & ($Boo_found)  // REMOVED
				
				Case of 
						
						  //………………………………………………………………………………………………………
					: ($Lon_type=-1)  // N -> 1 relation
						
						  // Remove all related fields
						If ($Obj_table[$o.name]#Null:C1517)
							
							OB REMOVE:C1226($Obj_table;$o.name)
							
						End if 
						
						  //………………………………………………………………………………………………………
					: ($Lon_type=-2)  // 1 -> N relation
						
						If ($Obj_table[$o.name]#Null:C1517)
							
							OB REMOVE:C1226($Obj_table;$o.name)
							
						End if 
						
						  //………………………………………………………………………………………………………
					Else 
						
						  // Remove the field
						OB REMOVE:C1226($Obj_table;$Txt_fieldNumber)
						
						  //………………………………………………………………………………………………………
				End case 
				
				  //_____________________________________________________
			Else 
				
				  // MIXED
				
				  //_____________________________________________________
		End case 
	End for each 
	
	  // REMOVE TABLE IF NO MORE PUBLISHED FIELDS
	CLEAR VARIABLE:C89($Boo_found)
	
	For each ($t;$Obj_table) Until ($Boo_found)
		
		Case of 
				
				  //………………………………………………………………………………………………………
			: (Length:C16($t)=0)
				
				  // <NOTHING MORE TO DO>
				
				  //………………………………………………………………………………………………………
			: ($ƒ.isField($t))
				
				$Boo_found:=True:C214
				
				  //………………………………………………………………………………………………………
			: (Value type:C1509($Obj_table[$t])=Is object:K8:27)
				
				$Boo_found:=$ƒ.isRelation($Obj_table[$t])
				
				  //………………………………………………………………………………………………………
		End case 
	End for each 
	
	If (Not:C34($Boo_found))
		
		OB REMOVE:C1226($Obj_dataModel;$Txt_tableNumber)
		
		  // Update main menu
		main_Handler (New object:C1471(\
			"action";"remove";\
			"tableNumber";$Txt_tableNumber))
		
		  // UI - De-emphasize the table name
		$Lon_indx:=Find in array:C230((ui.pointer($Obj_form.tableList))->;True:C214)
		LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_indx;Plain:K14:1)
		
	End if 
End if 

  // Update field list
structure_FIELD_LIST ($Obj_form)

$Obj_context.setHelpTip($Obj_form.fieldList;$Obj_form)
ui.saveProject()

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End