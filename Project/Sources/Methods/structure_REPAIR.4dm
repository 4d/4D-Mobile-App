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
C_LONGINT:C283($i;$Lon_number2;$Lon_published;$Win_current)
C_TEXT:C284($t;$tt)
C_OBJECT:C1216($catalog;$ƒ;$o;$Obj_cache;$Obj_dataModel;$Obj_datastore)
C_OBJECT:C1216($Obj_field;$Obj_project;$Obj_table;$oo)
C_COLLECTION:C1488($c;$cc)

  // ----------------------------------------------------
  // Initialisations

$Obj_project:=(ui.pointer("project"))->
ASSERT:C1129($Obj_project#Null:C1517)

$ƒ:=Storage:C1525.ƒ

$Obj_dataModel:=$Obj_project.dataModel
$Obj_datastore:=catalog ("datastore").datastore

  // ----------------------------------------------------
  // Make a Backup of the project & catalog
$o:=File:C1566(Form:C1466.project;fk platform path:K87:2)  // Project.4dmobileapp

$oo:=$o.parent.folder(Replace string:C233(Get localized string:C991("replacedFiles");"{stamp}";str_date ("stamp")))
$oo.create()

$o.copyTo($oo)

$o:=$o.parent.file("catalog.json")
$o.copyTo($oo)

  // tableNumber starts to 1
For ($i;1;$Obj_project.$dialog.unsynchronizedTableFields.length-1;1)
	
	$c:=$Obj_project.$dialog.unsynchronizedTableFields[$i]
	
	If ($c#Null:C1517)
		
		If ($c.length=0)
			
			  // THE TABLE DOESN'T EXIST ANYMORE
			OB REMOVE:C1226($Obj_dataModel;String:C10($i))
			
		Else 
			
			  // Check the fields
			$Obj_table:=$Obj_dataModel[String:C10($i)]
			$Lon_published:=0
			
			For each ($t;$Obj_table)
				
				Case of 
						
						  //______________________________________________________
					: (Length:C16($t)=0)
						
						  // TABLE PROPERTIES
						
						  //______________________________________________________
					: ($ƒ.isField($t))
						
						$o:=$c.query("fieldNumber = :1";Num:C11($t)).pop()
						
						If ($o=Null:C1517)  // NOT unsynchronized
							
							$Lon_published:=$Lon_published+1
							
						Else 
							
							Case of 
									
									  //______________________________________________________
								: ($o.missing)
									
									OB REMOVE:C1226($Obj_table;String:C10($t))
									
									  //______________________________________________________
								: ($o.typeMismatch)
									
									  // Detect compatible types
									Case of 
											
											  //……………………………………………………………………………………………………………………………………………………………………………
										: (($o.fieldType=Is alpha field:K8:1)\
											 & ($o.current.fieldType=Is text:K8:3))\
											 | (($o.fieldType=Is text:K8:3) & ($o.current.fieldType=Is alpha field:K8:1))  // String
											
											$Obj_table[$t].fieldType:=$o.current.fieldType
											$Lon_published:=$Lon_published+1
											
											  //……………………………………………………………………………………………………………………………………………………………………………
										: (($o.current.fieldType=Is integer:K8:5)\
											 | ($o.current.fieldType=Is longint:K8:6)\
											 | ($o.current.fieldType=Is integer 64 bits:K8:25)\
											 | ($o.current.fieldType=Is real:K8:4)\
											 | ($o.current.fieldType=_o_Is float:K8:26))\
											 & (($o.fieldType=Is integer:K8:5) | ($o.fieldType=Is longint:K8:6) | ($o.fieldType=Is integer 64 bits:K8:25) | ($o.fieldType=Is real:K8:4) | ($o.fieldType=_o_Is float:K8:26))  // Numeric
											
											$Obj_table[$t].fieldType:=$o.current.fieldType
											$Lon_published:=$Lon_published+1
											
											  //……………………………………………………………………………………………………………………………………………………………………………
										Else 
											
											OB REMOVE:C1226($Obj_table;String:C10($t))
											
											  //……………………………………………………………………………………………………………………………………………………………………………
									End case 
									
									  //______________________________________________________
								Else 
									
									  // Only name was modified: ACCEPT
									$Obj_table[$t].name:=$o.current.name
									$Lon_published:=$Lon_published+1
									
									  //______________________________________________________
							End case 
						End if 
						
						  //______________________________________________________
					: ((Value type:C1509($Obj_table[$t])#Is object:K8:27))
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($ƒ.isRelationToOne($Obj_table[$t]))  // N -> 1 relation
						
						If ($Obj_datastore[$Obj_table[$t].relatedDataClass]=Null:C1517)
							
							  // THE RELATED TABLE DOESN'T EXIST ANYMORE
							OB REMOVE:C1226($Obj_table;String:C10($t))
							
						Else 
							
							$Lon_number2:=0
							
							For each ($tt;$Obj_table[$t])
								
								Case of 
										
										  //…………………………………………………………………………
									: ($ƒ.isField($tt))
										
										$Obj_field:=$Obj_table[$t][$tt]
										
										$cc:=$c.extract("fields")
										
										If ($cc.length>0)
											
											If ($cc[0].query("relatedTableNumber = :1 & name = :2";$Obj_field.relatedTableNumber;$Obj_field.name).length=1)
												
												OB REMOVE:C1226($Obj_table[$t];$tt)
												
											Else 
												
												$Lon_number2:=$Lon_number2+1
												
											End if 
											
										Else 
											
											$Lon_number2:=$Lon_number2+1
											
										End if 
										
										  //…………………………………………………………………………
									: ((Value type:C1509($Obj_table[$t])#Is object:K8:27))
										
										  // <NOTHING MORE TO DO>
										
										  //…………………………………………………………………………
									Else 
										
										  // NOT YET MANAGED
										
										  //…………………………………………………………………………
								End case 
							End for each 
							
							If ($Lon_number2=0)
								
								  // NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
								OB REMOVE:C1226($Obj_table;$t)
								
							Else 
								
								$Lon_published:=$Lon_published+1
								
							End if 
						End if 
						
						  //______________________________________________________
					: ($ƒ.isRelationToMany($Obj_table[$t]))  // 1 -> N relation
						
						If ($Obj_datastore[$Obj_table[$t].relatedEntities]=Null:C1517)
							
							  // THE RELATED TABLE DOESN'T EXIST ANYMORE
							OB REMOVE:C1226($Obj_table;String:C10($t))
							
						Else 
							
							$Lon_published:=$Lon_published+1
							
						End if 
						
						  //________________________________________
				End case 
			End for each 
			
			If ($Lon_published=0)
				
				  // NO MORE FIELDS PUBLISHED FOR THIS TABLE
				OB REMOVE:C1226($Obj_dataModel;String:C10($i))
				
			End if 
		End if 
		
	End if 
	
	
End for 

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
$Win_current:=Current form window:C827
CALL FORM:C1391($Win_current;"project_SAVE")

  // Update UI
CALL FORM:C1391($Win_current;"editor_CALLBACK";"updateRibbon")
CALL FORM:C1391($Win_current;"editor_CALLBACK";"refreshViews")
CALL FORM:C1391($Win_current;"editor_CALLBACK";"pickerHide")
CALL FORM:C1391($Win_current;"editor_CALLBACK";"description";New object:C1471(\
"show";False:C215))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End