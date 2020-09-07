//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_OBJECTS_HANDLER
// ID[33A96C70CD6F4A70A0910ADDDEDD6491]
// Created 11-03-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $0 : Integer

If (False:C215)
	C_LONGINT:C283(ACTIONS_OBJECTS_HANDLER; $0)
End if 

var $t : Text
var $icon : Picture
var $i; $index : Integer
var $x : Blob
var $context; $current; $field; $form; $o; $oo; $table; $widget : Object
var $c; $fields : Collection

var $addMenu; $deleteMenu; $editMenu; $menu; $shareMenu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$form:=ACTIONS_Handler(New object:C1471(\
"action"; "init"))

$context:=$form[""]

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($form.form.eventCode=On Display Detail:K2:22)
		
		// Should not!
		
		//==================================================
	: ($form.form.current=$form.actions.name)  // Actions listbox
		
		$widget:=$form.actions
		
		Case of 
				
				//______________________________________________________
			: ($form.form.eventCode=On Getting Focus:K2:7)
				
				$context.listUI()
				
				//______________________________________________________
			: ($form.form.eventCode=On Losing Focus:K2:8)
				
				If (Bool:C1537($context.$edit))
					
					// Loss after cell edition
					OB REMOVE:C1226($context; "$cellEdition")
					
				Else 
					
					$context.listUI()
					
				End if 
				
				//______________________________________________________
			: ($form.form.eventCode=On Selection Change:K2:29)
				
				$context.$current:=$context.current
				
				// Update parameters panel if any
				Form:C1466.$dialog.ACTIONS_PARAMS.action:=$context.$current
				$form.form.call("selectParameters")
				
				$form.form.refresh()
				
				//______________________________________________________
			: (editor_Locked)
				
				$0:=-1
				
				//______________________________________________________
			: ($widget.row=0)
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($form.form.eventCode=On Mouse Leave:K2:34)
				
				$form.dropCursor.hide()
				
				//______________________________________________________
			: ($form.form.eventCode=On Begin Drag Over:K2:44)
				
				$o:=New object:C1471(\
					"src"; $context.index)
				
				// Put into the container
				VARIABLE TO BLOB:C532($o; $x)
				APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.action"; $x)
				SET BLOB SIZE:C606($x; 0)
				
				//______________________________________________________
			: ($form.form.eventCode=On Drag Over:K2:13)  // Manage drag & drop cursor
				
				// Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.action"; $x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x; $o)
					SET BLOB SIZE:C606($x; 0)
					
					$o.tgt:=Drop position:C608
					
					If ($o.tgt=-1)  // After the last line
						
						If ($o.src#$widget.rowsNumber())  // Not if the source was the last line
							
							$o:=$widget.cellCoordinates(1; $widget.rowsNumber()).cellBox
							$o.top:=$o.bottom
							$o.right:=$widget.coordinates.right
							
							$form.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
							$form.dropCursor.show()
							
						Else 
							
							// Reject drop
							$form.dropCursor.hide()
							$0:=-1
							
						End if 
						
					Else 
						
						If ($o.src#$o.tgt)\
							 & ($o.tgt#($o.src+1))  // Not the same or the next one
							
							$o:=$widget.cellCoordinates(1; $o.tgt).cellBox
							$o.bottom:=$o.top
							$o.right:=$widget.coordinates.right
							
							$form.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
							$form.dropCursor.show()
							
						Else 
							
							// Reject drop
							$form.dropCursor.hide()
							$0:=-1
							
						End if 
					End if 
					
				Else 
					
					// Reject drop
					$form.dropCursor.hide()
					$0:=-1
					
				End if 
				
				//______________________________________________________
			: ($form.form.eventCode=On Drop:K2:12)
				
				// Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.action"; $x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x; $o)
					SET BLOB SIZE:C606($x; 0)
					
					$o.tgt:=Drop position:C608
					
				End if 
				
				If ($o.src#$o.tgt)
					
					$current:=Form:C1466.actions[$o.src-1]
					
					If ($o.tgt=-1)  // After the last line
						
						Form:C1466.actions.push($current)
						Form:C1466.actions.remove($o.src-1)
						
					Else 
						
						Form:C1466.actions.insert($o.tgt-1; $current)
						
						If ($o.tgt<$o.src)
							
							Form:C1466.actions.remove($o.src)
							
						Else 
							
							Form:C1466.actions.remove($o.src-1)
							
						End if 
					End if 
				End if 
				
				$form.dropCursor.hide()
				
				//______________________________________________________
			: ($form.form.eventCode=On Double Clicked:K2:5)
				
				$widget.update()
				
				Case of 
						
						//…………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.name].number)
						
						EDIT ITEM:C870(*; $form.name; Num:C11($context.index))
						
						//…………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.shortLabel].number)
						
						EDIT ITEM:C870(*; $form.shortLabel; Num:C11($context.index))
						
						//…………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.label].number)
						
						EDIT ITEM:C870(*; $form.label; Num:C11($context.index))
						
						//…………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)
				
				$widget.update()
				
				Case of 
						
						//…………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.icon].number)  // Open the fields icons picker
						
						If ($context.current#Null:C1517)
							
							$o:=$form.iconGrid.pointer()->
							
							$o.item:=$o.pathnames.indexOf(String:C10($context.current.icon))
							$o.item:=$o.item+1  // Widget work with array
							
							$o.row:=$widget.row
							
							$o.left:=$widget.cellBox.right
							$o.top:=34
							
							$o.action:="actionIcons"
							
							$o.background:=0x00FFFFFF
							$o.backgroundStroke:=UI.strokeColor
							$o.promptColor:=0x00FFFFFF
							$o.promptBackColor:=UI.strokeColor
							$o.hidePromptSeparator:=True:C214
							$o.forceRedraw:=True:C214
							$o.prompt:=str.setText("chooseAnIconForTheAction").localized(String:C10($context.current.name))
							
							// Display selector
							$form.form.call(New object:C1471(\
								"parameters"; New collection:C1472("pickerShow"; \
								$o)))
							
						End if 
						
						//…………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($form.form.eventCode=On Before Data Entry:K2:39)
				
				$0:=-1  // Reject data entry
				
				$widget.update()
				
				Case of 
						
						//…………………………………………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.name].number)\
						 | ($widget.column=$widget.columns[$form.shortLabel].number)\
						 | ($widget.column=$widget.columns[$form.label].number)
						
						// Put an edit flag to manage loss of focus
						$context.$cellEdition:=True:C214
						
						$0:=0  // Allow direct entry
						
						//…………………………………………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.table].number)  // Display published table menu
						
						$menu:=cs:C1710.menu.new()
						
						For each ($t; Form:C1466.dataModel)
							
							$menu.append(Form:C1466.dataModel[$t][""].name; $t; Num:C11($context.current.tableNumber)=Num:C11($t))
							
						End for each 
						
						If ($widget.popup($menu).selected)
							
							$context.current.tableNumber:=Num:C11($menu.choice)
							
							$form.form.refresh()
							PROJECT.save()
							
						End if 
						
						//…………………………………………………………………………………………………………………………………………
					: ($widget.column=$widget.columns[$form.scope].number)  // Display scope menu
						
						$menu:=cs:C1710.menu.new()
						
						Repeat 
							
							$i:=$i+1
							$t:=Get localized string:C991("scope_"+String:C10($i))
							
							If (Length:C16($t)>0)  //#ACI0100966
								
								$menu.append(":xliff:"+$t; $t; String:C10($context.current.scope)=$t)
								
								Case of 
										
										//________________________________________
									: ($i=1)\
										 & (String:C10($context.current.preset)="suppression")  // Table
										
										$menu.disable()
										
										//________________________________________
									: ($i=2)\
										 & (String:C10($context.current.preset)="adding")  // Current entity
										
										$menu.disable()
										
										//________________________________________
								End case 
							End if 
						Until (Length:C16($t)=0)  //#ACI0100966
						
						If ($widget.popup($menu).selected)
							
							$context.current.scope:=$menu.choice
							PROJECT.save()
							
						End if 
						
						//…………………………………………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($form.form.current=$form.add.name)
		
		If ($form.form.eventCode=On Alternative Click:K2:36)
			
			$menu:=cs:C1710.menu.new().append(":xliff:newAction"; "new").line()
			
			$addMenu:=cs:C1710.menu.new()
			$menu.append(":xliff:addActionFor"; $addMenu)
			
			$editMenu:=cs:C1710.menu.new()
			$menu.append(":xliff:editActionFor"; $editMenu)
			
			$deleteMenu:=cs:C1710.menu.new()
			$menu.append(":xliff:deleteActionFor"; $deleteMenu)
			
			If (FEATURE.with(117618))
				
				$shareMenu:=cs:C1710.menu.new()
				$menu.append(":xliff:shareActionFor"; $shareMenu)
				
			End if 
			
			For each ($t; Form:C1466.dataModel)
				
				$addMenu.append(Form:C1466.dataModel[$t][""].name; "add_"+$t)
				$editMenu.append(Form:C1466.dataModel[$t][""].name; "edit_"+$t)
				$deleteMenu.append(Form:C1466.dataModel[$t][""].name; "delete_"+$t)
				
				If (FEATURE.with(117618))
					
					$shareMenu.append(Form:C1466.dataModel[$t][""].name; "share_"+$t)
					
				End if 
			End for each 
			
			$menu.popup(""; $form.add.getCoordinates())
			
			CLEAR VARIABLE:C89($o)
			
			Case of 
					
					//______________________________________________________
				: (Not:C34($menu.selected))
					
					//______________________________________________________
				: ($menu.choice="new")
					
					$form.form.eventCode:=On Clicked:K2:4  // Default action
					
					//______________________________________________________
				Else 
					
					$t:=$menu.choice
					
					$menu.edit:=($t="edit_@")
					$menu.delete:=($t="delete_@")
					$menu.add:=($t="add_@")
					$menu.share:=($t="share_@")
					
					$t:=Replace string:C233($t; "edit_"; "")
					$t:=Replace string:C233($t; "delete_"; "")
					$t:=Replace string:C233($t; "add_"; "")
					$t:=Replace string:C233($t; "share_"; "")
					
					$menu.table:=$t
					$menu.tableNumber:=Num:C11($t)
					
					Case of 
							
							//……………………………………………………………………
						: ($menu.edit)
							
							$menu.preset:="edition"
							$menu.prefix:="edit"
							$menu.icon:="actions/Edit.svg"
							$menu.scope:="currentRecord"
							$menu.label:=Get localized string:C991("edit...")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Edit.svg").platformPath; $icon)
							
							//……………………………………………………………………
						: ($menu.add)
							
							$menu.preset:="adding"
							$menu.prefix:="add"
							$menu.icon:="actions 2/Add.svg"
							$menu.scope:="table"
							$menu.label:=Get localized string:C991("add...")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions 2/Add.svg").platformPath; $icon)
							
							//……………………………………………………………………
						: ($menu.delete)
							
							$menu.preset:="suppression"
							$menu.prefix:="delete"
							$menu.icon:="actions/Delete.svg"
							$menu.scope:="currentRecord"
							$menu.label:=Get localized string:C991("remove")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Delete.svg").platformPath; $icon)
							
							//……………………………………………………………………
						: ($menu.share)
							
							$menu.preset:="share"
							$menu.prefix:="share"
							$menu.icon:="actions/Send-basic.svg"
							$menu.scope:="currentRecord"
							$menu.label:=Get localized string:C991("share...")
							READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/tableIcons/actions/Send-basic.svg").platformPath; $icon)
							$menu.description:=""
							
							//……………………………………………………………………
					End case 
					
					CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
					
					$table:=Form:C1466.dataModel[$menu.table]
					
					// Generate a unique name
					$t:=str(formatString("label"; $table[""].name)).uperCamelCase()
					
					$menu.name:=$menu.prefix+$t
					
					If (Form:C1466.actions#Null:C1517)
						
						Repeat 
							
							$c:=Form:C1466.actions.query("name=:1"; $menu.name)
							
							If ($c.length>0)
								
								$i:=$i+1+Num:C11($i=0)
								$menu.name:=$menu.prefix+$t+String:C10($i)
								
							End if 
						Until ($c.length=0)
					End if 
					
					$o:=New object:C1471(\
						"preset"; $menu.preset; \
						"icon"; $menu.icon; \
						"$icon"; $icon; \
						"tableNumber"; $menu.tableNumber; \
						"scope"; $menu.scope; \
						"name"; $menu.name; \
						"shortLabel"; $menu.label; \
						"label"; $menu.label)
					
					Case of 
							
							//……………………………………………………………………
						: ($menu.delete)
							
							$o.style:="destructive"
							
							//……………………………………………………………………
						: ($menu.share)
							
							$o.description:=$menu.description
							
							//……………………………………………………………………
						Else 
							
							$o.parameters:=New collection:C1472
							
							$fields:=catalog("fields"; New object:C1471("tableName"; $table[""].name)).fields
							
							For each ($t; $table)
								
								Case of 
										
										//______________________________________________________
									: (Length:C16($t)=0)
										
										// <NOTHING MORE TO DO>
										
										//______________________________________________________
									: (PROJECT.isField($t))
										
										If ($table[$t].name#$table[""].primaryKey)  // DO NOT ADD A PRIMARY KEY
											
											$field:=$fields.query("name = :1"; $table[$t].name).pop()
											
											$oo:=New object:C1471(\
												"fieldNumber"; $field.fieldNumber; \
												"name"; str($table[$t].name).uperCamelCase(); \
												"label"; $table[$t].label; \
												"shortLabel"; $table[$t].shortLabel; \
												"type"; Choose:C955($field.fieldType=Is time:K8:8; "time"; $field.valueType))
											
											If ($menu.edit)
												
												$oo.defaultField:=formatString("field-name"; $table[$t].name)
												
											End if 
											
											If ($oo#Null:C1517)
												
												If (Bool:C1537($field.mandatory))
													
													$oo.rules:=New collection:C1472("mandatory")
													
												End if 
												
												// Preset formats
												Case of 
														
														//……………………………………………………………………
													: ($field.fieldType=Is integer:K8:5)\
														 | ($field.fieldType=Is longint:K8:6)\
														 | ($field.fieldType=Is integer 64 bits:K8:25)
														
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
									: (Value type:C1509($table[$t])#Is object:K8:27)
										
										// <NOTHING MORE TO DO>
										
										//______________________________________________________
									: (PROJECT.isRelation($table[$t]))
										
										//
										
										//______________________________________________________
								End case 
							End for each 
							
							//……………………………………………………………………
					End case 
					
					//______________________________________________________
			End case 
		End if 
		
		If ($form.form.eventCode=On Clicked:K2:4)
			
			READ PICTURE FILE:C678(UI.noIcon; $icon)
			CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
			
			$t:="action_"+String:C10($index)
			
			If (Form:C1466.actions#Null:C1517)
				
				// Generate a unique name
				$index:=Form:C1466.actions.count()+1
				
				Repeat 
					
					$c:=Form:C1466.actions.query("name=:1"; $t)
					
					If ($c.length>0)
						
						$index:=$index+1
						$t:="action_"+String:C10($index)
						
					End if 
				Until ($c.length=0)
			End if 
			
			$o:=New object:C1471(\
				"name"; $t; \
				"scope"; "table"; \
				"shortLabel"; $t; \
				"label"; $t; \
				"$icon"; $icon)
			
			// Auto define the target table if only one is published
			$i:=0
			
			For each ($t; Form:C1466.dataModel) While ($i<2)
				
				$i:=$i+1
				
			End for each 
			
			If ($i=1)
				
				$o.tableNumber:=Num:C11($t)
				
			End if 
		End if 
		
		If ($o#Null:C1517)  // An action was created
			
			// Ensure the action collection exists
			ob_createPath(Form:C1466; "actions"; Is collection:K8:32)
			Form:C1466.actions.push($o)
			
			$form.actions.focus()
			$form.actions.reveal($form.actions.rowsNumber()+Num:C11($form.actions.rowsNumber()=0))
			
			Form:C1466.$dialog.ACTIONS_PARAMS.action:=$o
			
			// Warning edit stop code execution -> must be delegate
			//EDIT ITEM(*;$Obj_form.name;Form.actions.length)
			
			$form.form.refresh()
			PROJECT.save()
			
			$form.form.call("selectParameters")
			
		End if 
		
		//==================================================
	: ($form.form.current=$form.remove.name)
		
		Case of 
				
				//______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)
				
				GOTO OBJECT:C206(*; "")
				
				$index:=Form:C1466.actions.indexOf($context.current)
				
				If ($index#-1)
					
					Form:C1466.actions.remove($index; 1)
					
					If (Num:C11($context.index)>$form.actions.rowsNumber())
						
						$form.actions.deselect()
						
						$context.index:=0
						$context.current:=Null:C1517
						
					Else 
						
						$form.actions.select(Num:C11($context.index))
						
					End if 
					
					Form:C1466.$dialog.ACTIONS_PARAMS.action:=$context.current
					$form.form.call("selectParameters")
					
				End if 
				
				$form.form.refresh()
				PROJECT.save()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($form.form.current=$form.databaseMethod.name)
		
		// Create/Open the "On Mobile Action" Database method
		ARRAY TEXT:C222($tTxt_; 0x0000)
		METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
		$tTxt_{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAction")
		
		If (Macintosh option down:C545)\
			 & (Structure file:C489=Structure file:C489(*))
			
			If (Find in array:C230($tTxt_; $tTxt_{0})>0)
				
				// Delete to recreate.
				// WARNING: Generates an error if the method is open
				File:C1566("/PACKAGE/Project/Sources/DatabaseMethods/onMobileAppAction.4dm").delete()
				DELETE FROM ARRAY:C228($tTxt_; Find in array:C230($tTxt_; $tTxt_{0}))
				
			End if 
		End if 
		
		// Create method if not exist
		If (Find in array:C230($tTxt_; $tTxt_{0})=-1)
			
			If (Command name:C538(1)="Somme")
				
				// FR language
				$o:=File:C1566("/RESOURCES/fr.lproj/onMobileAppAction.4dm")
				
			Else 
				
				$o:=File:C1566(Get localized document path:C1105("onMobileAppAction.4dm"); fk platform path:K87:2)
				
			End if 
			
			If ($o.exists)
				
				PROCESS 4D TAGS:C816($o.getText(); $t; Form:C1466.actions.extract("name"); Form:C1466.actions.extract("label"))
				METHOD SET CODE:C1194($tTxt_{0}; $t; *)
				
			End if 
			//]
			
		End if 
		
		// Open method
		METHOD OPEN PATH:C1213($tTxt_{0}; *)
		
		//==================================================
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown widget: \""+$form.form.current+"\"")
		
		//==================================================
End case 

If (Bool:C1537(FEATURE._8858))
	
	PROJECT.save()
	
End if 

// ----------------------------------------------------
// Return
// ----------------------------------------------------
// End