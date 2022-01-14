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
				Form:C1466.$:=cs:C1710.LIST_EDITOR.new()
				
			End if 
			
			//___________________________________________
		: ($e.code=On Activate:K2:9)
			
			$ƒ.refresh()
			
			//___________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//___________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: ($ƒ.name.catch($e; On Data Change:K2:15))
			
			If (Length:C16(Form:C1466.name)>0)
				
				Form:C1466._folder:=Form:C1466._host.folder(EDITOR.str.setText(Form:C1466.name).suitableWithFileName())
				
			Else 
				
				BEEP:C151
				
				OB REMOVE:C1226(Form:C1466; "_folder")
				$ƒ.name.focus()
				
			End if 
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.revealFolder.catch($e; On Clicked:K2:4))
			
			Form:C1466._folder.create()
			SHOW ON DISK:C922(Form:C1466._folder.platformPath)
			
			//==============================================
		: ($ƒ.formatDropdown.catch($e; On Data Change:K2:15))
			
			Form:C1466.format:=$ƒ.format
			
			//==============================================
		: ($ƒ.static.catch())\
			 | ($ƒ.datasource.catch())
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.label.catch())\
			 | ($ƒ.image.catch())
			
			$ƒ.doType()
			
			//==============================================
		: ($ƒ.dataclasses.catch())\
			 | ($ƒ.attributes.catch())
			
			$ƒ.setDatasource()
			
			//==============================================
		: ($ƒ.list.catch($e))
			
			Case of 
					
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
					
					//___________________________________________
				Else 
					
					$ƒ.refresh()
					
					//___________________________________________
			End case 
			
			//==============================================
		: ($ƒ.add.catch($e; On Clicked:K2:4))
			
			$ƒ.doAdd()
			
			//==============================================
		: ($ƒ.remove.catch($e; On Clicked:K2:4))
			
			$ƒ.doRemove()
			
			//==============================================
	End case 
End if 