//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Definition

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form_common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			androidLimitations(True:C214; "Actions are coming soon for Android")
			
			// This trick remove the horizontal gap
			$ƒ.actions.setScrollbars(0; 2)
			
			// Load project actions
			$ƒ.load()
			
			// Set the initial display
			If (_and(Formula:C1597(Form:C1466.dataModel#Null:C1517); Formula:C1597(Not:C34(OB Is empty:C1297(Form:C1466.dataModel)))))
				
				$ƒ.actions.show()
				$ƒ.noPublishedTable.hide()
				
				$ƒ.add.enable()
				$ƒ.databaseMethod.enable()
				
				If (_and(Formula:C1597(Form:C1466.actions#Null:C1517); Formula:C1597(Form:C1466.actions.length>0)))
					
					// Select last used action (or the first one)
					If ($ƒ.$current#Null:C1517)
						
						var $indx : Integer
						$indx:=Form:C1466.actions.indexOf($ƒ.$current)
						$ƒ.actions.select($indx+1)
						
					Else 
						
						$ƒ.actions.select(1)
						
					End if 
					
					
					//$ƒ.callMeBack("selectParameters")
					
					$ƒ.updateParameters()
					
				End if 
				
				$ƒ.actions.focus()
				
			Else 
				
				$ƒ.actions.hide()
				$ƒ.noPublishedTable.show()
				
				$ƒ.add.disable()
				$ƒ.databaseMethod.disable()
				
			End if 
			
			// Set colors
			$ƒ.dropCursor.setColors(Highlight menu background color:K23:7)
			
			// Preload the icons
			$ƒ.callMeBack("loadActionIcons")
			
			// Give the focus to the actions listbox
			$ƒ.actions.focus()
			
			// Add the events that we cannot select in the form properties 😇
			$ƒ.appendEvents(New collection:C1472(On Alternative Click:K2:36; On Before Data Entry:K2:39))
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			androidLimitations(True:C214)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.actions.catch())
			
			Case of 
					
					//_____________________________________
				: ($e.code=On Selection Change:K2:29)
					
					$ƒ.$current:=$ƒ.current
					
					// Update parameters panel
					$ƒ.updateParameters()
					
					// Update UI
					$ƒ.refresh()
					
					//_____________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.actions.setColors(Foreground color:K23:1)
					$ƒ.actionsBorder.setColors(EDITOR.selectedColor)
					
					//_____________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					If (Bool:C1537($ƒ.$edit))  // Focus is lost after editing a cell
						
						OB REMOVE:C1226($ƒ; "$edit")
						
					Else 
						
						$ƒ.actions.setColors(Foreground color:K23:1)
						$ƒ.actionsBorder.setColors(EDITOR.backgroundUnselectedColor)
						
					End if 
					
					//_____________________________________
				: (editor_Locked) | (Num:C11($e.row)=0)
					
					// <NOTHING MORE TO DO>
					
					//_____________________________________
				: ($e.code=On Clicked:K2:4)
					
					Case of 
							
							//………………………………………………………………
						: ($e.columnName="icons")
							
							$ƒ.doShowIconPicker()
							
							//………………………………………………………………
					End case 
					
					//_____________________________________
				: ($e.code=On Begin Drag Over:K2:44)
					
					$ƒ.doBeginDrag()
					
					//_____________________________________
				: ($e.code=On Drop:K2:12)
					
					$ƒ.doOnDrop()
					
					//_____________________________________
				: ($e.code=On Before Data Entry:K2:39)
					
					Case of 
							
							//………………………………………………………………
						: (New collection:C1472("names"; "shorts"; "labels").indexOf($e.columnName)#-1)
							
							// Set a flag to manage On Losing Focus
							$ƒ.$edit:=True:C214
							
							//………………………………………………………………
						: ($e.columnName="tables")
							
							$ƒ.doTableMenu()
							
							//………………………………………………………………
						: ($e.columnName="scopes")
							
							$ƒ.doScopeMenu()
							
							//………………………………………………………………
					End case 
					
					//_____________________________________
				: ($e.code=On Double Clicked:K2:5)
					
					If (New collection:C1472("names"; "shorts"; "labels").indexOf($e.columnName)#-1)
						
						EDIT ITEM:C870(*; $e.columnName; Num:C11($ƒ.index))
						
					End if 
					
					//_____________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					$ƒ.dropCursor.hide()
					
					//_____________________________________
			End case 
			
			//==============================================
		: ($ƒ.add.catch())
			
			Case of 
					
					//_____________________________
				: ($e.code=On Alternative Click:K2:36)
					
					$ƒ.doAddMenu()
					
					//_____________________________
				: ($e.code=On Clicked:K2:4)
					
					$ƒ.doNewAction()
					
					//_____________________________
			End case 
			
			//==============================================
		: ($ƒ.remove.catch())
			
			$ƒ.doRemoveAction()
			
			//==============================================
		: ($ƒ.databaseMethod.catch())
			
			$ƒ.doOpenDatabaseMethod()
			
			//==============================================
	End case 
End if 
