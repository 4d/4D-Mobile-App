//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[33A96C70CD6F4A70A0910ADDDEDD6491]
  // Created #11-03-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BOOLEAN:C305($Boo_edit)
C_LONGINT:C283($i;$l;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($Mnu_delete;$Mnu_edit;$Mnu_pop;$t;$tt)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_table)
C_COLLECTION:C1488($c;$cc;$Col_fields)

If (False:C215)
	C_LONGINT:C283(ACTIONS_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Obj_form:=ACTIONS_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Obj_form.form.event=On Display Detail:K2:22)
		
		  // Should not!
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.actions.name)  // Actions listbox
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Getting Focus:K2:7)
				
				$Obj_context.listUI()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Losing Focus:K2:8)
				
				  //$Obj_context.listUI()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Selection Change:K2:29)
				
				$Obj_form.form.refresh()
				
				  //______________________________________________________
			: (editor_Locked )
				
				$0:=-1
				
				  //______________________________________________________
			: ($Obj_form.actions.row=0)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Double Clicked:K2:5)
				
				$Obj_form.actions.update()
				
				Case of 
						
						  //…………………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.name].number)
						
						EDIT ITEM:C870(*;$Obj_form.name;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.shortLabel].number)
						
						EDIT ITEM:C870(*;$Obj_form.shortLabel;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.label].number)
						
						EDIT ITEM:C870(*;$Obj_form.label;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)
				
				$Obj_form.actions.update()
				
				Case of 
						
						  //…………………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.icon].number)  // Open the fields icons picker
						
						If ($Obj_context.current#Null:C1517)
							
							$o:=$Obj_form.iconGrid.pointer()->
							
							$o.item:=$o.pathnames.indexOf(String:C10($Obj_context.current.icon))
							$o.item:=$o.item+1  // Widget work with array
							
							$o.row:=$Obj_form.actions.row
							
							$o.left:=$Obj_form.actions.cellCoordinates.right
							$o.top:=34
							
							$o.action:="actionIcons"
							
							$o.background:=0x00FFFFFF
							$o.backgroundStroke:=ui.strokeColor
							$o.promptColor:=0x00FFFFFF
							$o.promptBackColor:=ui.strokeColor
							$o.hidePromptSeparator:=True:C214
							$o.forceRedraw:=True:C214
							$o.prompt:=str_localized (New collection:C1472("chooseAnIconForTheAction";String:C10($Obj_context.current.name)))
							
							  // Display selector
							$Obj_form.form.call(New object:C1471(\
								"parameters";New collection:C1472("pickerShow";\
								$o)))
							
						End if 
						
						  //…………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Before Data Entry:K2:39)
				
				$0:=-1  // Reject data entry
				
				$Obj_form.actions.update()
				
				Case of 
						
						  //……………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.name].number)\
						 | ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.shortLabel].number)\
						 | ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.label].number)
						
						  // Allow direct entry
						$0:=0
						
						  //……………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.table].number)
						
						  // Display published table menu
						$Mnu_pop:=Create menu:C408
						
						For each ($t;Form:C1466.dataModel)
							
							APPEND MENU ITEM:C411($Mnu_pop;Form:C1466.dataModel[$t].name)
							SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$t)
							
							If (Num:C11($Obj_context.current.tableNumber)=Num:C11($t))
								
								SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18))
								
							End if 
						End for each 
						
						$t:=$Obj_form.actions.popup(New object:C1471("menu";$Mnu_pop)).choice
						
						If (Length:C16($t)>0)
							
							$Obj_context.current.tableNumber:=Num:C11($t)
							
							$Obj_form.form.refresh()
							
							project.save()
							
						End if 
						
						  //……………………………………………………………………………………………………
					: ($Obj_form.actions.column=$Obj_form.actions.columns[$Obj_form.scope].number)
						
						  // Display scope menu
						$Mnu_pop:=Create menu:C408
						
						$i:=Num:C11(String:C10($Obj_context.current.style)="destructive")  // Skip table for a suppression
						
						Repeat 
							
							$i:=$i+1
							$t:=Get localized string:C991("scope_"+String:C10($i))
							
							If (Bool:C1537(OK))
								
								APPEND MENU ITEM:C411($Mnu_pop;":xliff:"+$t)
								SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;$t)
								
								If (String:C10($Obj_context.current.scope)=$t)
									
									SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18))
									
								End if 
							End if 
						Until (OK=0)
						
						$t:=$Obj_form.actions.popup(New object:C1471("menu";$Mnu_pop)).choice
						
						If (Length:C16($t)>0)
							
							$Obj_context.current.scope:=$t
							
							project.save()
							
						End if 
						
						  //……………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.addAction.name)
		
		If ($Obj_form.form.event=On Alternative Click:K2:36)
			
			$Mnu_edit:=Create menu:C408
			$Mnu_delete:=Create menu:C408
			
			$Mnu_pop:=Create menu:C408
			APPEND MENU ITEM:C411($Mnu_pop;":xliff:newAction")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"new")
			
			APPEND MENU ITEM:C411($Mnu_pop;"-")
			
			APPEND MENU ITEM:C411($Mnu_pop;":xliff:editActionFor";$Mnu_edit;1)
			
			RELEASE MENU:C978($Mnu_edit)
			
			APPEND MENU ITEM:C411($Mnu_pop;":xliff:deleteActionFor";$Mnu_delete;1)
			
			RELEASE MENU:C978($Mnu_delete)
			
			For each ($t;Form:C1466.dataModel)
				
				APPEND MENU ITEM:C411($Mnu_edit;Form:C1466.dataModel[$t].name)
				SET MENU ITEM PARAMETER:C1004($Mnu_edit;-1;"edit_"+$t)
				
				APPEND MENU ITEM:C411($Mnu_delete;Form:C1466.dataModel[$t].name)
				SET MENU ITEM PARAMETER:C1004($Mnu_delete;-1;"delete_"+$t)
				
			End for each 
			
			$t:=Dynamic pop up menu:C1006($Mnu_pop)
			RELEASE MENU:C978($Mnu_pop)
			
			If (Length:C16($t)#0)
				
				Case of 
						
						  //______________________________________________________
					: ($t="new")
						
						$Obj_form.form.event:=On Clicked:K2:4  // Default action
						
						  //______________________________________________________
					Else 
						
						  // create edit/delete action:
						
						$Boo_edit:=($t="edit_@")
						$t:=Replace string:C233($t;"edit_";"")
						$t:=Replace string:C233($t;"delete_";"")
						
						ob_createPath (Form:C1466;"actions";Is collection:K8:32)
						
						$Obj_table:=Form:C1466.dataModel[$t]
						
						If ($Boo_edit)
							
							$c:=New collection:C1472
							
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Edit.svg").platformPath;$p)
							CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
							
							$tt:="edit"+str (formatString ("label";$Obj_table.name)).uperCamelCase()
							
							Repeat 
								
								$c:=Form:C1466.actions.query("name=:1";$tt)
								
								If ($c.length>0)
									
									$i:=$i+1+Num:C11($i=0)
									$tt:="edit"+str (formatString ("label";$Obj_table.name)).uperCamelCase()+String:C10($i)
									
								End if 
							Until ($c.length=0)
							
							Form:C1466.actions.push(New object:C1471(\
								"icon";"actions/Edit.svg";\
								"$icon";$p;\
								"tableNumber";Num:C11($t);\
								"scope";"currentRecord";\
								"name";$tt;\
								"shortLabel";Get localized string:C991("edit...");\
								"label";Get localized string:C991("edit...");\
								"parameters";$c))
							
							  // Parameters               Description
							  //  name                    Action ID
							  //  short label             Displayed short label in iOS app
							  //  long label              Displayed long label in iOS app
							  //  type                    Type selection will define the displayed keyboard/picker and format in the iOS app
							  //  input constraint        Define a specific input value range for example
							  //  choice list             Define a choice list (same principle as formatter using json with key value correspondance)
							  //  placeholder             Define placeholder to be displayed in iOS app
							  //  mandatory fields        Define if field is mandatory => fields followed by a star or red fields border in iOS app
							  //  default(field)          Default value definition
							  //  format                  Display/Enter format
							
							$Col_fields:=catalog ("fields";New object:C1471("tableName";$Obj_table.name)).fields
							
							For each ($t;$Obj_table)
								
								Case of 
										
										  //______________________________________________________
									: (Storage:C1525.ƒ.isField($t))
										
										$cc:=$Col_fields.query("name = :1";$Obj_table[$t].name)
										
										$o:=New object:C1471(\
											"fieldNumber";$cc[0].fieldNumber;\
											"name";str ($Obj_table[$t].name).uperCamelCase();\
											"label";$Obj_table[$t].label;\
											"shortLabel";$Obj_table[$t].shortLabel;\
											"type";Choose:C955($cc[0].fieldType=Is time:K8:8;"time";$cc[0].valueType);\
											"defaultField";formatString ("field-name";$Obj_table[$t].name);\
											"mandatory";Bool:C1537($cc[0].mandatory))
										
										Case of 
												
												  //……………………………………………………………………
											: ($cc[0].fieldType=Is integer:K8:5)\
												 | ($cc[0].fieldType=Is longint:K8:6)\
												 | ($cc[0].fieldType=Is integer 64 bits:K8:25)
												
												$o.format:="integer"
												
												  //……………………………………………………………………
											: ($o.type="date")
												
												$o.format:="dateShort"
												
												  //……………………………………………………………………
											: ($o.type="time")
												
												$o.format:="hour"
												
												  //……………………………………………………………………
										End case 
										
										$c.push($o)
										
										  //______________________________________________________
									: (Value type:C1509($Obj_table[$t])#Is object:K8:27)
										
										  // <NOTHING MORE TO DO>
										
										  //______________________________________________________
									: (Storage:C1525.ƒ.isRelatedDataClass($Obj_table[$t]))
										
										  //
										
										  //______________________________________________________
								End case 
							End for each 
							
						Else 
							
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Delete.svg").platformPath;$p)
							CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
							
							$tt:="delete"+str (formatString ("label";$Obj_table.name)).uperCamelCase()
							
							Repeat 
								
								$c:=Form:C1466.actions.query("name=:1";$tt)
								
								If ($c.length>0)
									
									$i:=$i+1+Num:C11($i=0)
									$tt:="delete"+str (formatString ("label";$Obj_table.name)).uperCamelCase()+String:C10($i)
									
								End if 
							Until ($c.length=0)
							
							Form:C1466.actions.push(New object:C1471(\
								"style";"destructive";\
								"icon";"actions/Delete.svg";\
								"$icon";$p;\
								"tableNumber";Num:C11($t);\
								"scope";"currentRecord";\
								"name";$tt;\
								"shortLabel";Get localized string:C991("remove");\
								"label";Get localized string:C991("remove")))
							
						End if 
						
						$Obj_form.actions.focus()
						$Obj_form.actions.reveal($Obj_form.actions.rowsNumber())
						
						$Obj_form.form.refresh()
						
						project.save()
						
						  //______________________________________________________
				End case 
			End if 
		End if 
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)
				
				ob_createPath (Form:C1466;"actions";Is collection:K8:32)
				
				READ PICTURE FILE:C678(ui.noIcon;$p)
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				
				$l:=Form:C1466.actions.count()+1
				
				$o:=New object:C1471(\
					"name";"action_"+String:C10($l);\
					"scope";"table";\
					"shortLabel";"action_"+String:C10($l);\
					"label";"action_"+String:C10($l);\
					"$icon";$p)
				
				Form:C1466.actions.push($o)
				$Obj_form.actions.focus()
				$Obj_form.actions.reveal($Obj_form.actions.rowsNumber())
				
				  // Warning edit stop code execution
				  //EDIT ITEM(*;$Obj_form.name;Form.actions.length)
				
				$Obj_form.form.refresh()
				project.save()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Alternative Click:K2:36)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.removeAction.name)
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)
				
				$l:=Form:C1466.actions.indexOf($Obj_context.current)
				
				If ($l#-1)
					
					Form:C1466.actions.remove($l;1)
					
					If (Num:C11($Obj_context.index)>$Obj_form.actions.rowsNumber())
						
						$Obj_form.actions.deselect()
						
						$Obj_context.index:=0
						$Obj_context.current:=Null:C1517
						
					Else 
						
						$Obj_form.actions.select(Num:C11($Obj_context.index))
						
					End if 
				End if 
				
				$Obj_form.form.refresh()
				
				project.save()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.databaseMethod.name)
		
		  // Create/Open the "On Mobile Action" Database method
		ARRAY TEXT:C222($tTxt_;0x0000)
		METHOD GET PATHS:C1163(Path database method:K72:2;$tTxt_;*)
		$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2;"onMobileAppAction")
		
		  // Create method if not exist
		If (Find in array:C230($tTxt_;$tTxt_{0})=-1)
			
			If (Command name:C538(1)="Somme")
				
				  // FR language
				$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAction.4md")
				
			Else 
				
				$o:=File:C1566(Get localized document path:C1105("onMobileAppAction.4md");fk platform path:K87:2)
				
			End if 
			
			If ($o.exists)
				
				PROCESS 4D TAGS:C816($o.getText();$t;Form:C1466.actions.extract("name");Form:C1466.actions.extract("label"))
				METHOD SET CODE:C1194($tTxt_{0};$t;*)
				
			End if 
			  //]
			
		End if 
		
		  // Open method
		METHOD OPEN PATH:C1213($tTxt_{0};*)
		
		  //==================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown widget: \""+$Obj_form.form.currentWidget+"\"")
		
		  //==================================================
End case 

If (Bool:C1537(featuresFlags._8858))
	
	project.save()
	
End if 

  // ----------------------------------------------------
  // Return
  // ----------------------------------------------------
  // End