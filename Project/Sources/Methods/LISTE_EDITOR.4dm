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
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//___________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: ($ƒ.name.catch($e; On Data Change:K2:15))
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.formatDropdown.catch($e; On Data Change:K2:15))
			
			Form:C1466.format:=$ƒ.format
			
			//==============================================
		: ($ƒ.static.catch())\
			 | ($ƒ.datasource.catch())
			
			$ƒ.refresh()
			
			//==============================================
		: ($ƒ.add.catch($e; On Clicked:K2:4))
			
			$ƒ.doAdd()
			
			//==============================================
		: ($ƒ.list.catch($e))
			
			Case of 
					
					//___________________________________________
				: ($e.code=On Double Clicked:K2:5)
					
					$ƒ.list.edit($e)
					
					//___________________________________________
				: ($e.code=On Selection Change:K2:29)
					
					$ƒ.refresh()
					
					//___________________________________________
				Else 
					
					$ƒ.refresh()
					
					//___________________________________________
			End case 
			
			//==============================================
		: ($ƒ.dataclasses.catch())\
			 | ($ƒ.attributes.catch())
			
			$ƒ.setDatasource()
			
			//==============================================
		: ($ƒ.label.catch())\
			 | ($ƒ.image.catch())
			
			$ƒ.doType()
			
			//==============================================
	End case 
End if 