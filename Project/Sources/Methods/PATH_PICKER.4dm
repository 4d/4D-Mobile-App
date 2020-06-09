//%attributes = {"invisible":true}
If (Form:C1466#Null:C1517)  // Prematurely
	
	var $e : Object
	$e:=FORM Event:C1606
	
	If ($e.objectName=Null:C1517)  // <== Form method
		
		Case of 
				
				  //…………………………………………………………………………………
			: ($e.code=On Load:K2:1)
				
				SET TIMER:C645(-1)
				
				  //…………………………………………………………………………………
			: ($e.code=On Bound Variable Change:K2:52)
				
				Form:C1466.ui()
				
				  //…………………………………………………………………………………
			: ($e.code=On Resize:K2:27)
				
				SET TIMER:C645(-1)
				
				  //…………………………………………………………………………………
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				Form:C1466.geometry()
				
				  //…………………………………………………………………………………
		End case 
		
	Else 
		
		Case of 
				
				  //=============================================
			: ($e.code=On Drag Over:K2:13)
				
				  // <NOTHING MORE TO DO>
				
				  //=============================================
			: ($e.code=On Drop:K2:12)
				
				Form:C1466.onDrop()
				
				  //=============================================
			: ($e.objectName="browse")
				
				Form:C1466.select()
				
				  //=============================================
			: ($e.objectName="menu@")
				
				Form:C1466.displayMenu()
				
				  //=============================================
		End case 
	End if 
	
Else 
	
	SET TIMER:C645(-1)
	
End if 