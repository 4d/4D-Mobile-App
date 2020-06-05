//%attributes = {"invisible":true}
var $0 : Integer
$0:=-1

var $e : Object

If (Form:C1466#Null:C1517)  // Prematurely
	
	$e:=FORM Event:C1606
	
	If ($e.objectName=Null:C1517)  // <== Form method
		
		Case of 
				
				  //……………………………………………………………………………………………………………………
			: ($e.code=On Load:K2:1)
				
				Form:C1466.geometry()
				
				  //……………………………………………………………………………………………………………………
			: ($e.code=On Bound Variable Change:K2:52)
				
				Form:C1466.ui()
				
				  //……………………………………………………………………………………………………………………
			: ($e.code=On Resize:K2:27)
				
				Form:C1466.geometry()
				
				  //……………………………………………………………………………………………………………………
		End case 
		
	Else 
		
		Case of 
				
				  //______________________________________________________
			: ($e.objectName="browse")
				
				Case of 
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Clicked:K2:4)
						
						Form:C1466.select()
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Drag Over:K2:13)
						
						$0:=Form:C1466.onDrag()
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Drop:K2:12)
						
						Form:C1466.onDrop()
						
						  //…………………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			: ($e.objectName="menu")
				
				Form:C1466.displayMenu()
				
				  //______________________________________________________
			: ($e.objectName="menu.expand")
				
				Case of 
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Clicked:K2:4)
						
						Form:C1466.displayMenu()
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Drag Over:K2:13)
						
						$0:=Form:C1466.onDrag()
						
						  //……………………………………………………………………………………………………………………
					: ($e.code=On Drop:K2:12)
						
						Form:C1466.onDrop()
						
						  //…………………………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
		End case 
		
	End if 
	
End if 