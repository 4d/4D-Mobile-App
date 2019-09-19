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
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_error;$Boo_found)
C_LONGINT:C283($i;$l;$Lon_colum;$Lon_parameters;$Lon_row)
C_POINTER:C301($Ptr_fields;$Ptr_icons;$Ptr_list;$Ptr_published)
C_TEXT:C284($t)
C_OBJECT:C1216($ƒ;$Obj_;$Obj_context;$Obj_dataModel;$Obj_field;$Obj_form)
C_OBJECT:C1216($Obj_table)
C_COLLECTION:C1488($Col_;$Col_selected)

ARRAY LONGINT:C221($tLon_fieldID;0)

If (False:C215)
	C_OBJECT:C1216(structure_FIELD_LIST ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_form:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_context:=$Obj_form.form
	
	$ƒ:=Storage:C1525.ƒ
	
	$Obj_dataModel:=Form:C1466.dataModel
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Ptr_fields:=ui.pointer($Obj_form.fields)

If (Size of array:C274($Ptr_fields->)>0)
	
	LISTBOX GET CELL POSITION:C971(*;$Obj_form.fieldList;$Lon_colum;$Lon_row)
	
	  // Keep the selected field to restore the selection if necessary
	$Obj_context.fieldName:=$Ptr_fields->{$Lon_row}
	
End if 

  // Keep the selection
$Ptr_list:=ui.pointer($Obj_form.fieldList)
$Col_selected:=New collection:C1472

For ($i;1;LISTBOX Get number of rows:C915(*;$Obj_form.fieldList);1)
	
	If ($Ptr_list->{$i})
		
		$Col_selected.push($Ptr_fields->{$i})
		
	End if 
End for 

LISTBOX GET CELL POSITION:C971(*;$Obj_form.tableList;$Lon_colum;$Lon_row)

$Ptr_icons:=ui.pointer($Obj_form.icons)
$Ptr_published:=ui.pointer($Obj_form.published)

CLEAR VARIABLE:C89($Ptr_fields->)
CLEAR VARIABLE:C89($Ptr_published->)
CLEAR VARIABLE:C89($Ptr_icons->)

If ($Lon_row>0)
	
	$Obj_table:=$Obj_context.currentTable
	
	If ($Obj_table#Null:C1517)
		
		If (Form:C1466.$dialog.unsynchronizedTableFields#Null:C1517)
			
			If (Form:C1466.$dialog.unsynchronizedTableFields.length>$Obj_table.tableNumber)
				
				If (Form:C1466.$dialog.unsynchronizedTableFields[$Obj_table.tableNumber]#Null:C1517)
					
					If (Form:C1466.$dialog.unsynchronizedTableFields[$Obj_table.tableNumber].length>0)
						
						COLLECTION TO ARRAY:C1562(Form:C1466.$dialog.unsynchronizedTableFields[$Obj_table.tableNumber];$tLon_fieldID)
						
					Else 
						
						  // Mark all
						$tLon_fieldID{0}:=-1
						
					End if 
				End if 
			End if 
		End if 
		
		Case of 
				
				  //______________________________________________________
			: (Length:C16(String:C10($Obj_context.fieldFilter))>0)\
				 & (Bool:C1537($Obj_context.fieldFilterPublished))
				
				For each ($Obj_field;$Obj_table.field)
					
					If (Position:C15($Obj_context.fieldFilter;$Obj_field.name)>0)
						
						If ($ƒ.isRelationToOne($Obj_field))
							
							  //#MARK_TO_OPTIMIZE
							$Obj_:=structure (New object:C1471(\
								"action";"catalog";\
								"tableNumber";$Obj_field.relatedTableNumber))
							
							If ($Obj_.success)
								
								$Col_:=$Obj_.value[0].field
								
								For each ($Obj_;$Col_) Until ($Boo_found)
									
									$Boo_found:=(Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][$Obj_field.name][String:C10($Obj_.id)]#Null:C1517)
									
									If ($Boo_found)
										
										STRUCTURE_Handler (New object:C1471(\
											"action";"appendField";\
											"table";$Obj_table;\
											"field";$Obj_field;\
											"fields";$Ptr_fields;\
											"published";$Ptr_published;\
											"icons";$Ptr_icons))
										
										  //#MARK_TODO
										  //$Boo_unsynchronized:=(Find in array($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
										  //LISTBOX SET ROW COLOR(*;$Obj_form.fieldList;Size of array($Ptr_fields->);Choose($Boo_unsynchronized;UI.errorColor;lk inherited);lk font color)
										
									End if 
								End for each 
							End if 
							
						Else 
							
							If (Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][String:C10($Obj_field.id)]#Null:C1517)
								
								STRUCTURE_Handler (New object:C1471(\
									"action";"appendField";\
									"table";$Obj_table;\
									"field";$Obj_field;\
									"fields";$Ptr_fields;\
									"published";$Ptr_published;\
									"icons";$Ptr_icons))
								
								$Boo_error:=(Find in array:C230($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
								LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;Size of array:C274($Ptr_fields->);Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
								
							End if 
						End if 
					End if 
				End for each 
				
				  //______________________________________________________
			: (Length:C16(String:C10($Obj_context.fieldFilter))>0)  // Filter by name
				
				For each ($Obj_field;$Obj_table.field)
					
					If (Position:C15($Obj_context.fieldFilter;$Obj_field.name)>0)
						
						STRUCTURE_Handler (New object:C1471(\
							"action";"appendField";\
							"table";$Obj_table;\
							"field";$Obj_field;\
							"fields";$Ptr_fields;\
							"published";$Ptr_published;\
							"icons";$Ptr_icons))
						
						$Boo_error:=(Find in array:C230($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
						LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;Size of array:C274($Ptr_fields->);Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
						
					End if 
				End for each 
				
				  //______________________________________________________
			: (Bool:C1537($Obj_context.fieldFilterPublished))  // Filter published
				
				For each ($Obj_field;$Obj_table.field)
					
					If ($ƒ.isRelationToOne($Obj_field))
						
						  //#MARK_TO_OPTIMIZE
						$Obj_:=structure (New object:C1471(\
							"action";"catalog";\
							"tableNumber";$Obj_field.relatedTableNumber))
						
						If ($Obj_.success)
							
							$Col_:=$Obj_.value[0].field
							
							For each ($Obj_;$Col_) Until ($Boo_found)
								
								$Boo_found:=(Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][$Obj_field.name][String:C10($Obj_.id)]#Null:C1517)
								
								If ($Boo_found)
									
									STRUCTURE_Handler (New object:C1471(\
										"action";"appendField";\
										"table";$Obj_table;\
										"field";$Obj_field;\
										"fields";$Ptr_fields;\
										"published";$Ptr_published;\
										"icons";$Ptr_icons))
									
									  //#MARK_TODO
									  //$Boo_unsynchronized:=(Find in array($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
									  //LISTBOX SET ROW COLOR(*;$Obj_form.fieldList;Size of array($Ptr_fields->);Choose($Boo_unsynchronized;UI.errorColor;lk inherited);lk font color)
									
								End if 
							End for each 
						End if 
						
					Else 
						
						If (Form:C1466.dataModel[String:C10($Obj_table.tableNumber)][String:C10($Obj_field.id)]#Null:C1517)
							
							STRUCTURE_Handler (New object:C1471(\
								"action";"appendField";\
								"table";$Obj_table;\
								"field";$Obj_field;\
								"fields";$Ptr_fields;\
								"published";$Ptr_published;\
								"icons";$Ptr_icons))
							$Boo_error:=(Find in array:C230($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
							LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;Size of array:C274($Ptr_fields->);Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
							
						End if 
					End if 
				End for each 
				
				  //______________________________________________________
			Else   // No filter
				
				For each ($Obj_field;$Obj_table.field)
					
					STRUCTURE_Handler (New object:C1471(\
						"action";"appendField";\
						"table";$Obj_table;\
						"field";$Obj_field;\
						"fields";$Ptr_fields;\
						"published";$Ptr_published;\
						"icons";$Ptr_icons))
					
					$l:=Size of array:C274($Ptr_fields->)
					
					Case of 
							
							  //…………………………………………………………………………
						: ($Obj_field.type=-2)  // 1 -> N relation
							
							If (Bool:C1537($Ptr_published->{$l}))
								
								$l:=Form:C1466.$project.$catalog.extract("tableNumber").indexOf($Obj_field.relatedTableNumber)
								$Boo_error:=($l=-1)
								LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;$l;Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
								
							Else 
								
								LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;$l;lk inherited:K53:26;lk font color:K53:24)
								
							End if 
							
							  //…………………………………………………………………………
						: ($Obj_field.type=-1)
							
							If (Bool:C1537($Ptr_published->{$l}))
								
								$Boo_error:=(Find in array:C230($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
								LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;$l;Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
								
							Else 
								
								LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;$l;lk inherited:K53:26;lk font color:K53:24)
								
							End if 
							
							  //…………………………………………………………………………
						Else 
							
							$Boo_error:=(Find in array:C230($tLon_fieldID;$Obj_field.id)>0) | ($tLon_fieldID{0}=-1)
							LISTBOX SET ROW COLOR:C1270(*;$Obj_form.fieldList;$l;Choose:C955($Boo_error;ui.errorColor;lk inherited:K53:26);lk font color:K53:24)
							
							If ($Obj_field.name=$Obj_table.primaryKey)
								
								  // Highlight primary key
								LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.fieldList;$l;Bold:K14:2)
								
							End if 
							
							  //…………………………………………………………………………
					End case 
				End for each 
				
				  //______________________________________________________
		End case 
	End if 
End if 

  // Disable field publication if the table is missing
OBJECT SET ENTERABLE:C238($Ptr_published->;Not:C34(editor_Locked ))

  // Sort if any
If ($Obj_context.fieldSortByName)
	
	LISTBOX SORT COLUMNS:C916(*;$Obj_form.fieldList;3;>)
	
End if 

  // Restore the selection
LISTBOX SELECT ROW:C912(*;$Obj_form.fieldList;0;lk remove from selection:K53:3)

If ($Col_selected.length>0)
	
	For each ($t;$Col_selected)
		
		$Lon_row:=Find in array:C230($Ptr_fields->;$t)
		
		If ($Lon_row>0)
			
			LISTBOX SELECT ROW:C912(*;$Obj_form.fieldList;$Lon_row;lk add to selection:K53:2)
			
		End if 
	End for each 
	
	$Lon_row:=Find in array:C230($Ptr_fields->;String:C10($Obj_context.fieldName))
	
	If ($Lon_row>0)
		
		OBJECT SET SCROLL POSITION:C906(*;$Obj_form.fieldList;$Lon_row)
		
	Else 
		
		OBJECT SET SCROLL POSITION:C906(*;$Obj_form.fieldList)
		OB REMOVE:C1226($Obj_context;"fieldName")
		
	End if 
	
Else 
	
	OBJECT SET SCROLL POSITION:C906(*;$Obj_form.fieldList)
	OB REMOVE:C1226($Obj_context;"fieldName")
	
End if 

SET TIMER:C645(-1)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End