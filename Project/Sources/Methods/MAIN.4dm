//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Load

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.tables.catch())
			
			
			//==============================================
		: ($ƒ.mains.catch())
			
			
			//==============================================
		: ($ƒ.addOne.catch($e; On Clicked:K2:4))
			
			
			//==============================================
		: ($ƒ.addAll.catch($e; On Clicked:K2:4))
			
			
			//==============================================
		: ($ƒ.removeOne.catch($e; On Clicked:K2:4))
			
			
			//==============================================
		: ($ƒ.removeAll.catch($e; On Clicked:K2:4))
			
			
			//==============================================
		: ($ƒ.up.catch($e; On Clicked:K2:4))
			
			
			//==============================================
		: ($ƒ.down.catch($e; On Clicked:K2:4))
			
			
			
			//==============================================
	End case 
End if 
