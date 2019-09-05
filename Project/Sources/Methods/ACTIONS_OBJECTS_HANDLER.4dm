//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_OBJECTS_HANDLER
  // ID[33A96C70CD6F4A70A0910ADDDEDD6491]
  // Created 11-03-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BLOB:C604($x)
C_LONGINT:C283($i;$l)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_add;$Obj_context;$Obj_current;$Obj_delete;$Obj_edit)
C_OBJECT:C1216($Obj_form;$Obj_popup;$Obj_table;$Obj_widget;$oo)
C_COLLECTION:C1488($c;$cc;$Col_fields)

If (False:C215)
	C_LONGINT:C283(ACTIONS_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Obj_form:=ACTIONS_Handler (New object:C1471(\
"action";"init"))

$Obj_context:=$Obj_form.$

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Obj_form.form.event=On Display Detail:K2:22)
		
		  // Should not!
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.actions.name)  // Actions listbox
		
		$Obj_widget:=$Obj_form.actions
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Getting Focus:K2:7)
				
				$Obj_context.listUI()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Losing Focus:K2:8)
				
				If (Bool:C1537($Obj_context.$edit))
					
					  // Loss after cell edition
					OB REMOVE:C1226($Obj_context;"$cellEdition")
					
				Else 
					
					$Obj_context.listUI()
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Selection Change:K2:29)
				
				$Obj_context.$current:=$Obj_context.current
				
				  // Update parameters panel if any
				Form:C1466.$dialog.ACTIONS_PARAMS.action:=$Obj_context.$current
				$Obj_form.form.call("selectParameters")
				
				$Obj_form.form.refresh()
				
				  //______________________________________________________
			: (editor_Locked )
				
				$0:=-1
				
				  //______________________________________________________
			: ($Obj_widget.row=0)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Mouse Leave:K2:34)
				
				$Obj_form.dropCursor.hide()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Begin Drag Over:K2:44)
				
				$o:=New object:C1471(\
					"src";$Obj_context.index)
				
				  // Put into the container
				VARIABLE TO BLOB:C532($o;$x)
				APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.action";$x)
				SET BLOB SIZE:C606($x;0)
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Drag Over:K2:13)  // Manage drag & drop cursor
				
				  // Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.action";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					SET BLOB SIZE:C606($x;0)
					
					$o.tgt:=Drop position:C608
					
					If ($o.tgt=-1)  // After the last line
						
						If ($o.src#$Obj_widget.rowsNumber())  // Not if the source was the last line
							
							$o:=$Obj_widget.cellCoordinates(1;$Obj_widget.rowsNumber()).cellBox
							$o.top:=$o.bottom
							$o.right:=$Obj_widget.coordinates.right
							
							$Obj_form.dropCursor.setCoordinates($o.left;$o.top;$o.right;$o.bottom)
							$Obj_form.dropCursor.show()
							
						Else 
							
							  // Reject drop
							$Obj_form.dropCursor.hide()
							$0:=-1
							
						End if 
						
					Else 
						
						If ($o.src#$o.tgt)\
							 & ($o.tgt#($o.src+1))  // Not the same or the next one
							
							$o:=$Obj_widget.cellCoordinates(1;$o.tgt).cellBox
							$o.bottom:=$o.top
							$o.right:=$Obj_widget.coordinates.right
							
							$Obj_form.dropCursor.setCoordinates($o.left;$o.top;$o.right;$o.bottom)
							$Obj_form.dropCursor.show()
							
						Else 
							
							  // Reject drop
							$Obj_form.dropCursor.hide()
							$0:=-1
							
						End if 
					End if 
					
				Else 
					
					  // Reject drop
					$Obj_form.dropCursor.hide()
					$0:=-1
					
				End if 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Drop:K2:12)
				
				  // Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.action";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					SET BLOB SIZE:C606($x;0)
					
					$o.tgt:=Drop position:C608
					
				End if 
				
				If ($o.src#$o.tgt)
					
					$Obj_current:=Form:C1466.actions[$o.src-1]
					
					If ($o.tgt=-1)  // After the last line
						
						Form:C1466.actions.push($Obj_current)
						Form:C1466.actions.remove($o.src-1)
						
					Else 
						
						Form:C1466.actions.insert($o.tgt-1;$Obj_current)
						
						If ($o.tgt<$o.src)
							
							Form:C1466.actions.remove($o.src)
							
						Else 
							
							Form:C1466.actions.remove($o.src-1)
							
						End if 
					End if 
				End if 
				
				$Obj_form.dropCursor.hide()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Double Clicked:K2:5)
				
				$Obj_widget.update()
				
				Case of 
						
						  //…………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.name].number)
						
						EDIT ITEM:C870(*;$Obj_form.name;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.shortLabel].number)
						
						EDIT ITEM:C870(*;$Obj_form.shortLabel;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.label].number)
						
						EDIT ITEM:C870(*;$Obj_form.label;Num:C11($Obj_context.index))
						
						  //…………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)
				
				$Obj_widget.update()
				
				Case of 
						
						  //…………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.icon].number)  // Open the fields icons picker
						
						If ($Obj_context.current#Null:C1517)
							
							$o:=$Obj_form.iconGrid.pointer()->
							
							$o.item:=$o.pathnames.indexOf(String:C10($Obj_context.current.icon))
							$o.item:=$o.item+1  // Widget work with array
							
							$o.row:=$Obj_widget.row
							
							$o.left:=$Obj_widget.cellBox.right
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
				
				$Obj_widget.update()
				
				Case of 
						
						  //…………………………………………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.name].number)\
						 | ($Obj_widget.column=$Obj_widget.columns[$Obj_form.shortLabel].number)\
						 | ($Obj_widget.column=$Obj_widget.columns[$Obj_form.label].number)
						
						  // Put an edit flag to manage loss of focus
						$Obj_context.$cellEdition:=True:C214
						
						$0:=0  // Allow direct entry
						
						  //…………………………………………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.table].number)  // Display published table menu
						
						$Obj_popup:=menu 
						
						For each ($t;Form:C1466.dataModel)
							
							$Obj_popup.append(Form:C1466.dataModel[$t].name;$t;Num:C11($Obj_context.current.tableNumber)=Num:C11($t))
							
						End for each 
						
						If ($Obj_widget.popup($Obj_popup).selected)
							
							$Obj_context.current.tableNumber:=Num:C11($Obj_popup.choice)
							
							$Obj_form.form.refresh()
							project.save()
							
						End if 
						
						  //…………………………………………………………………………………………………………………………………………
					: ($Obj_widget.column=$Obj_widget.columns[$Obj_form.scope].number)  // Display scope menu
						
						$Obj_popup:=menu 
						
						Repeat 
							
							$i:=$i+1
							$t:=Get localized string:C991("scope_"+String:C10($i))
							
							If (Bool:C1537(OK))
								
								$Obj_popup.append(":xliff:"+$t;$t;String:C10($Obj_context.current.scope)=$t)
								
								Case of 
										
										  //________________________________________
									: ($i=1)\
										 & (String:C10($Obj_context.current.preset)="suppression")  // Table
										
										$Obj_popup.disable()
										
										  //________________________________________
									: ($i=2)\
										 & (String:C10($Obj_context.current.preset)="adding")  // Current entity
										
										$Obj_popup.disable()
										
										  //________________________________________
								End case 
							End if 
						Until (OK=0)
						
						If ($Obj_widget.popup($Obj_popup).selected)
							
							$Obj_context.current.scope:=$Obj_popup.choice
							project.save()
							
						End if 
						
						  //…………………………………………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.add.name)
		
		If ($Obj_form.form.event=On Alternative Click:K2:36)
			
			$Obj_popup:=menu .append(":xliff:newAction";"new").line()
			
			$Obj_add:=menu 
			
			$Obj_popup.append(":xliff:addActionFor";$Obj_add)
			
			$Obj_edit:=menu 
			
			$Obj_popup.append(":xliff:editActionFor";$Obj_edit)
			
			$Obj_delete:=menu 
			
			$Obj_popup.append(":xliff:deleteActionFor";$Obj_delete)
			
			For each ($t;Form:C1466.dataModel)
				
				$Obj_add.append(Form:C1466.dataModel[$t].name;"add_"+$t)
				$Obj_edit.append(Form:C1466.dataModel[$t].name;"edit_"+$t)
				$Obj_delete.append(Form:C1466.dataModel[$t].name;"delete_"+$t)
				
			End for each 
			
			$Obj_popup.popup("";$Obj_form.add.getCoordinates())
			
			CLEAR VARIABLE:C89($o)
			
			Case of 
					
					  //______________________________________________________
				: (Not:C34($Obj_popup.selected))
					
					  //______________________________________________________
				: ($Obj_popup.choice="new")
					
					$Obj_form.form.event:=On Clicked:K2:4  // Default action
					
					  //______________________________________________________
				Else 
					
					$t:=$Obj_popup.choice
					
					$Obj_popup.edit:=($t="edit_@")
					$Obj_popup.delete:=($t="delete_@")
					$Obj_popup.add:=($t="add_@")
					
					$t:=Replace string:C233($t;"edit_";"")
					$t:=Replace string:C233($t;"delete_";"")
					$t:=Replace string:C233($t;"add_";"")
					$Obj_popup.table:=$t
					$Obj_popup.tableNumber:=Num:C11($t)
					
					Case of 
							
							  //……………………………………………………………………
						: ($Obj_popup.edit)
							
							$Obj_popup.preset:="edition"
							$Obj_popup.prefix:="edit"
							$Obj_popup.icon:="actions/Edit.svg"
							$Obj_popup.scope:="currentRecord"
							$Obj_popup.label:=Get localized string:C991("edit...")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Edit.svg").platformPath;$p)
							
							  //……………………………………………………………………
						: ($Obj_popup.add)
							
							$Obj_popup.preset:="adding"
							$Obj_popup.prefix:="add"
							$Obj_popup.icon:="actions 2/Add.svg"
							$Obj_popup.scope:="table"
							$Obj_popup.label:=Get localized string:C991("add...")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions 2/Add.svg").platformPath;$p)
							
							  //……………………………………………………………………
						: ($Obj_popup.delete)
							
							$Obj_popup.preset:="suppression"
							$Obj_popup.prefix:="delete"
							$Obj_popup.icon:="actions/Delete.svg"
							$Obj_popup.scope:="currentRecord"
							$Obj_popup.label:=Get localized string:C991("remove")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Delete.svg").platformPath;$p)
							
							  //……………………………………………………………………
					End case 
					
					CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
					
					$Obj_table:=Form:C1466.dataModel[$Obj_popup.table]
					
					  // Generate a unique name
					$t:=str (formatString ("label";$Obj_table.name)).uperCamelCase()
					
					$Obj_popup.name:=$Obj_popup.prefix+$t
					
					If (Form:C1466.actions#Null:C1517)
						
						Repeat 
							
							$c:=Form:C1466.actions.query("name=:1";$Obj_popup.name)
							
							If ($c.length>0)
								
								$i:=$i+1+Num:C11($i=0)
								$Obj_popup.name:=$Obj_popup.prefix+$t+String:C10($i)
								
							End if 
						Until ($c.length=0)
					End if 
					
					$o:=New object:C1471(\
						"preset";$Obj_popup.preset;\
						"icon";$Obj_popup.icon;\
						"$icon";$p;\
						"tableNumber";$Obj_popup.tableNumber;\
						"scope";$Obj_popup.scope;\
						"name";$Obj_popup.name;\
						"shortLabel";$Obj_popup.label;\
						"label";$Obj_popup.label)
					
					Case of 
							
							  //……………………………………………………………………
						: ($Obj_popup.delete)
							
							$o.style:="destructive"
							
							  //……………………………………………………………………
						Else 
							
							$o.parameters:=New collection:C1472
							
							$Col_fields:=catalog ("fields";New object:C1471("tableName";$Obj_table.name)).fields
							
							For each ($t;$Obj_table)
								
								Case of 
										
										  //______________________________________________________
									: (Storage:C1525.ƒ.isField($t))
										
										If ($Obj_table[$t].name#$Obj_table.primaryKey)  // DO NOT ADD A PRIMARY KEY
											
											$cc:=$Col_fields.query("name = :1";$Obj_table[$t].name)
											
											If (featuresFlags.with("allowPictureAsActionParameters"))
												
												$oo:=New object:C1471(\
													"fieldNumber";$cc[0].fieldNumber;\
													"name";str ($Obj_table[$t].name).uperCamelCase();\
													"label";$Obj_table[$t].label;\
													"shortLabel";$Obj_table[$t].shortLabel;\
													"type";Choose:C955($cc[0].fieldType=Is time:K8:8;"time";$cc[0].valueType))
												
												If ($Obj_popup.edit)
													
													$oo.defaultField:=formatString ("field-name";$Obj_table[$t].name)
													
												End if 
												
											Else 
												
												If ($cc[0].valueType#"image")
													
													$oo:=New object:C1471(\
														"fieldNumber";$cc[0].fieldNumber;\
														"name";str ($Obj_table[$t].name).uperCamelCase();\
														"label";$Obj_table[$t].label;\
														"shortLabel";$Obj_table[$t].shortLabel;\
														"type";Choose:C955($cc[0].fieldType=Is time:K8:8;"time";$cc[0].valueType);\
														"defaultField";formatString ("field-name";$Obj_table[$t].name))
													
												Else 
													
													CLEAR VARIABLE:C89($oo)
													
												End if 
											End if 
											
											If ($oo#Null:C1517)
												
												If (Bool:C1537($cc[0].mandatory))
													
													$oo.rules:=New collection:C1472("mandatory")
													
												End if 
												
												  // Preset formats
												Case of 
														
														  //……………………………………………………………………
													: ($cc[0].fieldType=Is integer:K8:5)\
														 | ($cc[0].fieldType=Is longint:K8:6)\
														 | ($cc[0].fieldType=Is integer 64 bits:K8:25)
														
														$oo.format:="integer"
														
														  //……………………………………………………………………
													: ($oo.type="date")
														
														$oo.format:="shortDate"
														
														  //……………………………………………………………………
												End case 
												
												$o.parameters.push($oo)
												
											End if 
										End if 
										
										  //______________________________________________________
									: (Value type:C1509($Obj_table[$t])#Is object:K8:27)
										
										  // <NOTHING MORE TO DO>
										
										  //______________________________________________________
									: (Storage:C1525.ƒ.isRelation($Obj_table[$t]))
										
										  //
										
										  //______________________________________________________
								End case 
							End for each 
							
							  //……………………………………………………………………
					End case 
					
					  //______________________________________________________
			End case 
		End if 
		
		If ($Obj_form.form.event=On Clicked:K2:4)
			
			READ PICTURE FILE:C678(ui.noIcon;$p)
			CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
			
			$t:="action_"+String:C10($l)
			
			If (Form:C1466.actions#Null:C1517)
				
				  // Generate a unique name
				$l:=Form:C1466.actions.count()+1
				
				Repeat 
					
					$c:=Form:C1466.actions.query("name=:1";$t)
					
					If ($c.length>0)
						
						$l:=$l+1
						$t:="action_"+String:C10($l)
						
					End if 
				Until ($c.length=0)
			End if 
			
			$o:=New object:C1471(\
				"name";$t;\
				"scope";"table";\
				"shortLabel";$t;\
				"label";$t;\
				"$icon";$p)
			
			  // Auto define the target table if only one is published
			$i:=0
			For each ($t;Form:C1466.dataModel) While ($i<2)
				
				$i:=$i+1
				
			End for each 
			
			If ($i=1)
				
				$o.tableNumber:=Num:C11($t)
				
			End if 
		End if 
		
		If ($o#Null:C1517)  // An action was created
			
			  // Ensure the action collection exists
			ob_createPath (Form:C1466;"actions";Is collection:K8:32)
			Form:C1466.actions.push($o)
			
			$Obj_form.actions.focus()
			$Obj_form.actions.reveal($Obj_form.actions.rowsNumber()+Num:C11($Obj_form.actions.rowsNumber()=0))
			
			Form:C1466.$dialog.ACTIONS_PARAMS.action:=$o
			
			  // Warning edit stop code execution -> must be delegate
			  //EDIT ITEM(*;$Obj_form.name;Form.actions.length)
			
			$Obj_form.form.refresh()
			project.save()
			
			$Obj_form.form.call("selectParameters")
			
		End if 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.remove.name)
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)
				
				GOTO OBJECT:C206(*;"")
				
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
					
					Form:C1466.$dialog.ACTIONS_PARAMS.action:=$Obj_context.current
					$Obj_form.form.call("selectParameters")
					
				End if 
				
				$Obj_form.form.refresh()
				project.save()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.current=$Obj_form.databaseMethod.name)
		
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
		
		ASSERT:C1129(False:C215;"Unknown widget: \""+$Obj_form.form.current+"\"")
		
		  //==================================================
End case 

If (Bool:C1537(featuresFlags._8858))
	
	project.save()
	
End if 

  // ----------------------------------------------------
  // Return
  // ----------------------------------------------------
  // End