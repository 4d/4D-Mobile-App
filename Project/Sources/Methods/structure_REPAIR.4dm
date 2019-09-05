//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : structure_REPAIR
  // ID[56E1D9BCC2274EB9A67DBE09D54B6636]
  // Created 18-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  //
  // EXECUTION SPACE IS THE FORM EDITOR
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($Boo_found)
C_LONGINT:C283($Lon_fieldIndx;$Lon_indx;$Lon_relatedTableIndx;$Lon_tableIndx;$Lon_tableNumber;$Win_current)
C_TEXT:C284($t;$Txt_field;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$o;$Obj_cache;$Obj_catalog;$Obj_dataModel;$Obj_datastore)
C_OBJECT:C1216($Obj_field;$Obj_project;$Obj_relatedDataClass;$Obj_table;$oo)
C_COLLECTION:C1488($c;$Col_catalog;$Col_fieldID;$Col_fields;$Col_relatedID;$Col_tableID)
C_COLLECTION:C1488($Col_tableToRemove)


  // ----------------------------------------------------
  // Initialisations
$Win_current:=Current form window:C827

$Obj_project:=(ui.pointer("project"))->
ASSERT:C1129($Obj_project#Null:C1517)

$Col_catalog:=editor_Catalog 

$Obj_datastore:=catalog ("datastore").datastore

$Col_tableID:=$Col_catalog.extract("tableNumber")

$Col_tableToRemove:=New collection:C1472

$ƒ:=Storage:C1525.ƒ

  // ----------------------------------------------------
  // Make a Backup of the project & catalog
$o:=File:C1566(Form:C1466.project;fk platform path:K87:2)  // Project.4dmobileapp

$oo:=$o.parent.folder(Replace string:C233(Get localized string:C991("replacedFiles");"{stamp}";str_date ("stamp")))
$oo.create()

$o.copyTo($oo)

$o:=$o.parent.file("catalog.json")
$o.copyTo($oo)

  // Check the tables
$Obj_dataModel:=$Obj_project.dataModel

For each ($Txt_tableNumber;$Obj_dataModel)
	
	$Obj_table:=$Obj_dataModel[$Txt_tableNumber]
	
	If ($Obj_table=Null:C1517)
		
		  // NOTHING MORE TO DO - The table is not used in the project
		
	Else 
		
		  // Check that the table is defined in the structure
		$Lon_tableNumber:=Num:C11($Txt_tableNumber)
		
		$Lon_tableIndx:=$Col_tableID.indexOf($Lon_tableNumber)
		
		If ($Lon_tableIndx<0)
			
			  // THE TABLE DOESN'T EXIST ANYMORE
			$Col_tableToRemove.push($Txt_tableNumber)
			
		Else 
			
			$Obj_catalog:=$Col_catalog[$Lon_tableIndx]
			$Col_fieldID:=$Obj_catalog.field.extract("id")
			
			  // Update…
			$Obj_table.name:=$Obj_catalog.name
			$Obj_table.primaryKey:=$Obj_catalog.primaryKey
			
			$Col_fields:=catalog ("table";New object:C1471(\
				"tableName";$Obj_table.name;\
				"datastore";$Obj_datastore)).fields
			
			  // Check the fields
			For each ($Txt_field;$Obj_table)
				
				Case of 
						
						  //______________________________________________________
					: ($ƒ.isField($Txt_field))
						
						$Lon_fieldIndx:=$Col_fieldID.indexOf(Num:C11($Txt_field))
						
						If ($Lon_fieldIndx<0)
							
							  // THE FIELD DOESN'T EXIST ANYMORE
							OB REMOVE:C1226($Obj_table;$Txt_field)
							
						Else 
							
							  // Update…
							$Obj_field:=$Obj_table[$Txt_field]
							
							$Obj_field.name:=$Obj_catalog.field[$Lon_fieldIndx].name
							$Obj_field.fieldType:=$Obj_catalog.field[$Lon_fieldIndx].fieldType
							
							  // #TEMPO [
							$Obj_field.type:=$Obj_catalog.field[$Lon_fieldIndx].fieldType
							  //]
							
						End if 
						
						  //______________________________________________________
					: ((Value type:C1509($Obj_table[$Txt_field])#Is object:K8:27))
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($ƒ.isRelationToOne($Obj_table[$Txt_field]))  // N -> 1 relation
						
						$c:=$Col_fields.extract("name")
						$Lon_indx:=$c.indexOf($Txt_field)
						
						If ($Lon_indx#-1)
							
							  // Perform a diacritical comparison
							If (Not:C34(str_equal ($Txt_field;$c[$Lon_indx])))
								
								$Lon_indx:=-1
								
							End if 
						End if 
						
						If ($Lon_indx<0)
							
							  // THE FIELD DOESN'T EXIST ANYMORE
							OB REMOVE:C1226($Obj_table;$Txt_field)
							
						Else 
							
							  // Check related data class
							$Obj_field:=$Obj_table[$Txt_field]
							$Lon_relatedTableIndx:=$Col_tableID.indexOf($Obj_field.relatedTableNumber)
							
							If ($Lon_relatedTableIndx<0)
								
								  // THE RELATED DATA CLASS IS NOT PUBLISHED ANYMORE
								OB REMOVE:C1226($Obj_table;$Txt_field)
								
							Else 
								
								$Obj_relatedDataClass:=$Col_catalog[$Lon_relatedTableIndx]
								$Col_relatedID:=$Obj_relatedDataClass.field.extract("id")
								
								For each ($t;$Obj_field)
									
									Case of 
											
											  //…………………………………………………………………………………………
										: ($ƒ.isField($t))
											
											$Lon_indx:=$Col_relatedID.indexOf(Num:C11($t))
											
											If ($Lon_indx<0)
												
												  // THE FIELD DOESN'T EXIST ANYMORE
												OB REMOVE:C1226($Obj_field;$t)
												
											Else 
												
												  // Update…
												$Obj_field[$t].name:=$Obj_relatedDataClass.field[$Lon_indx].name
												$Obj_field[$t].fieldType:=$Obj_relatedDataClass.field[$Lon_indx].fieldType
												
												  // #TEMPO [
												$Obj_field[$t].type:=$Obj_relatedDataClass.field[$Lon_indx].fieldType
												  //]
												
											End if 
											
											  //…………………………………………………………………………………………
										: ((Value type:C1509($Obj_relatedDataClass[$t])#Is object:K8:27))
											
											  // <NOTHING MORE TO DO>
											
											  //…………………………………………………………………………………………
										Else 
											
											  // NOT YET MANAGED
											
											  //…………………………………………………………………………………………
									End case 
								End for each 
							End if 
						End if 
						
						  //______________________________________________________
					: ($ƒ.isRelationToMany($Obj_table[$t]))  // 1 -> N relation
						
						  //______________________________________________________
				End case 
			End for each 
			
			For each ($Txt_field;$Obj_table) Until ($Boo_found)
				
				CLEAR VARIABLE:C89($Boo_found)
				
				Case of 
						
						  //______________________________________________________
					: ($ƒ.isField($Txt_field))
						
						$Boo_found:=True:C214
						
						  //______________________________________________________
					: ((Value type:C1509($Obj_table[$Txt_field])#Is object:K8:27))
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($ƒ.isRelationToOne($Obj_table[$Txt_field]))  // N -> 1 relation
						
						$Boo_found:=True:C214
						
						  //______________________________________________________
					: ($ƒ.isRelationToMany($Obj_table[$t]))  // 1 -> N relation
						
						$Boo_found:=True:C214
						
						  //______________________________________________________
				End case 
			End for each 
			
			If (Not:C34($Boo_found))
				
				$Col_tableToRemove.push(String:C10($Obj_catalog.tableNumber))
				
			End if 
		End if 
	End if 
End for each 

  // Remove remaining tables
For each ($Txt_tableNumber;$Col_tableToRemove)
	
	OB REMOVE:C1226($Obj_dataModel;$Txt_tableNumber)
	
	  // Update main menu
	main_Handler (New object:C1471(\
		"action";"remove";\
		"tableNumber";$Txt_tableNumber;\
		"order";$Obj_project.main.order))
	
End for each 

If (OB Is empty:C1297($Obj_dataModel))
	
	OB REMOVE:C1226($Obj_project;"dataModel")
	
End if 

  // Update satus & cache [
OB REMOVE:C1226($Obj_project.$dialog;"unsynchronizedTableFields")
OB REMOVE:C1226($Obj_project.$project.structure;"unsynchronized")

$o:=Folder:C1567($Obj_project.$project.root;fk platform path:K87:2).file("catalog.json")

If ($o.exists)
	
	$Obj_cache:=JSON Parse:C1218($o.getText())
	ob_createPath ($Obj_cache;"structure")
	
Else 
	
	$Obj_cache:=New object:C1471(\
		"structure";New object:C1471)
	
End if 

Form:C1466.$catalog:=structure (New object:C1471("action";"catalog")).value

$Obj_cache.structure.definition:=Form:C1466.$catalog
$Obj_cache.structure.digest:=Generate digest:C1147(JSON Stringify:C1217(Form:C1466.$catalog);SHA1 digest:K66:2)

$o.setText(JSON Stringify:C1217($Obj_cache;*))
  //]

  // Refresh UI
STRUCTURE_Handler (New object:C1471(\
"action";"update";\
"project";$Obj_project))

project_REPAIR ($Obj_project)

  // Save project
CALL FORM:C1391($Win_current;"project_SAVE")
CALL FORM:C1391($Win_current;"editor_CALLBACK";"updateRibbon")

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End