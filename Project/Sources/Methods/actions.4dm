//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Load

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25; On Resize:K2:27)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			androidLimitations(True:C214; "Actions are coming soon for Android")
			
			$ƒ.loadActions()
			$ƒ.onLoad()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			androidLimitations(True:C214)
			
			$ƒ.update()
			
			//______________________________________________________
		: ($e.code=On Resize:K2:27)
			
			ui_SET_GEOMETRY($ƒ.context.constraints.rules)
			
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
					
					If (Bool:C1537($ƒ.actions.inEdition))  // Focus is lost after editing a cell
						
						OB REMOVE:C1226($ƒ.actions; "inEdition")
						
					Else 
						
						$ƒ.actions.setColors(Foreground color:K23:1)
						$ƒ.actionsBorder.setColors(EDITOR.backgroundUnselectedColor)
						
					End if 
					
					//_____________________________________
				: (PROJECT.isLocked()) | (Num:C11($e.row)=0)
					
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
							$ƒ.actions.inEdition:=True:C214
							
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
