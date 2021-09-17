//%attributes = {}
var $e; $ƒ : Object

$e:=FORM Event:C1606
$ƒ:=Form:C1466.$

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			If (Form:C1466.$=Null:C1517)
				
				// Instantiation of the class dialog
				Form:C1466.$:=cs:C1710.LIST_EDITOR.new()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: ($ƒ.name.catch($e; On Data Change:K2:15))
			
			If (Length:C16(Form:C1466.name)>0)
				
				Form:C1466._folder:=Form:C1466._host.folder(EDITOR.str.setText(Form:C1466.name).suitableWithFileName())
				
				If (Form:C1466._folder.exists)
					
					BEEP:C151
					$ƒ.ok.disable()
					$ƒ.name.focus().highlight()
					
				Else 
					
					$ƒ.ok.enable()
					
				End if 
				
			Else 
				
				$ƒ.ok.disable()
				$ƒ.name.focus()
				
			End if 
			
			//==============================================
		: ($ƒ.static.catch())\
			 | ($ƒ.datasource.catch())
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.label.catch())\
			 | ($ƒ.image.catch())
			
			$ƒ._label.setTitle(Get localized string:C991(Choose:C955($ƒ.image.getValue(); "image"; "label")))
			
			//==============================================
	End case 
End if 