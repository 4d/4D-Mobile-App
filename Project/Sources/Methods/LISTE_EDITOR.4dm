//%attributes = {}
var $e; $ƒ : Object

$e:=FORM Event:C1606
$ƒ:=Form:C1466.$

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//___________________________________________
		: ($e.code=On Load:K2:1)
			
			If (Form:C1466.$=Null:C1517)
				
				// Instantiation of the dialog class
				Form:C1466.$:=cs:C1710.LIST_EDITOR.new(Form:C1466)
				
			End if 
			
			//___________________________________________
		: ($e.code=On Activate:K2:9)
			
			$ƒ.refresh()
			
			//___________________________________________
		: ($e.code=On Deactivate:K2:10)
			
			$ƒ.refresh()
			
			//___________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//___________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: ($ƒ.list.catch($e))
			
			Case of 
					
					//___________________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.choiceListBorder.colors:=UI.selectedColor
					
					//___________________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					$ƒ.choiceListBorder.colors:=UI.backgroundUnselectedColor
					
					//___________________________________________
				: ($e.code=On Double Clicked:K2:5)
					
					$ƒ.list.edit($e)
					
					//_____________________________________
				: ($e.code=On Data Change:K2:15)
					
					$ƒ.list.autoSelect()
					
					//_____________________________________
				: ($e.code=On Begin Drag Over:K2:44)
					
					//$ƒ.doBeginDrag()
					
					//___________________________________________
				: ($e.code=On Drag Over:K2:13)\
					 | ($e.code=On Drop:K2:12)
					
					//_____________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					$ƒ.dropCursor.hide()
					
					//___________________________________________
				Else 
					
					$ƒ.refresh()
					
					//___________________________________________
			End case 
			
			//==============================================
		: ($ƒ.name.catch($e; On Data Change:K2:15))
			
			If (Length:C16(Form:C1466.name)>0)
				
				Form:C1466.dial.folder:=Form:C1466.dial.host.folder(UI.str.setText(Form:C1466.name).suitableWithFileName())
				$ƒ.controlAlreadyExists.show(Form:C1466.dial.folder.exists)
				
			Else 
				
				BEEP:C151
				
				OB REMOVE:C1226(Form:C1466.dial; "folder")
				$ƒ.controlAlreadyExists.hide()
				$ƒ.name.focus()
				
			End if 
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.revealFolder.catch($e; On Clicked:K2:4))
			
			Form:C1466.dial.folder.create()
			SHOW ON DISK:C922(Form:C1466.dial.folder.platformPath)
			
			//==============================================
		: ($ƒ.formatDropdown.catch($e; On Data Change:K2:15))
			
			Form:C1466.format:=$ƒ.format
			
			//==============================================
		: ($ƒ.label.catch())\
			 | ($ƒ.image.catch())
			
			$ƒ.doLinkedTo()
			
			//==============================================
		: ($ƒ.add.catch($e; On Clicked:K2:4))
			
			$ƒ.doAdd()
			
			//==============================================
		: ($ƒ.remove.catch($e; On Clicked:K2:4))
			
			$ƒ.doRemove()
			
			//==============================================
		: ($ƒ.dataclasses.catch($e)) | ($ƒ.attributes.catch($e))
			
			Case of 
					//___________________________________________
				: ($e.code=On Selection Change:K2:29)
					
					If ($e.objectName=$ƒ.dataclasses.name)
						
						Form:C1466.dial.attributes:=Form:C1466.dial.dataclasses[$ƒ.dataclasses.itemPosition-1].field
						$ƒ.attributes.unselect()
						
					End if 
					
					$ƒ.setDatasource()
					
					//___________________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.datasourceBorder.foregroundColor:=UI.selectedColor
					
					//___________________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					$ƒ.datasourceBorder.foregroundColor:=UI.backgroundUnselectedColor
					
					//___________________________________________
			End case 
			
			//==============================================
	End case 
End if 