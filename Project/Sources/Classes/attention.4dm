/*
This class manages a button widget to display a small alert or warning marker
the explanation is given thru a helptip displayed immediately

the button must be defined with this properties:

"_widget_Name_": {
    "type": "button",
    "style": "custom",
    "events": [
        "onMouseEnter",
        "onMouseLeave"
    ]
}
*/

Class extends widget

Class constructor($name : Text)
	
	Super:C1705($name)
	
	//=============================================================
Function alert($message : Text)
	
	This:C1470.title:="🚫"
	This:C1470.setHelpTip($message)
	
	//=============================================================
Function warning($message : Text)
	
	This:C1470.title:="❗"
	This:C1470.setHelpTip($message)
	
	//=============================================================
Function reset
	
	This:C1470.title:=""
	This:C1470.setHelpTip()
	
	//=============================================================
Function method($e : Object)
	
	$e:=$e=Null:C1517 ? FORM Event:C1606 : $e
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Mouse Enter:K2:33)
			
			// Backup the current settings
			This:C1470.status:=New object:C1471(\
				"enabled"; Get database parameter:C643(Tips enabled:K37:79)=1; \
				"delay"; Get database parameter:C643(Tips delay:K37:80); \
				"duration"; Get database parameter:C643(Tips duration:K37:81))
			
			// Define Tips as immediate displaying and give time to read it
			SET DATABASE PARAMETER:C642(Tips enabled:K37:79; 1)
			SET DATABASE PARAMETER:C642(Tips delay:K37:80; 1)
			SET DATABASE PARAMETER:C642(Tips duration:K37:81; 720*2)
			
			//______________________________________________________
		: ($e.code=On Mouse Leave:K2:34)
			
			If (This:C1470.status#Null:C1517)
				
				// Restore previous settings
				SET DATABASE PARAMETER:C642(Tips enabled:K37:79; Num:C11(This:C1470.status.enabled))
				SET DATABASE PARAMETER:C642(Tips delay:K37:80; Num:C11(This:C1470.status.delay))
				SET DATABASE PARAMETER:C642(Tips duration:K37:81; Num:C11(This:C1470.status.duration))
				
			Else 
				
				// Restore to default
				SET DATABASE PARAMETER:C642(Tips enabled:K37:79; 1)
				SET DATABASE PARAMETER:C642(Tips delay:K37:80; 45)
				SET DATABASE PARAMETER:C642(Tips duration:K37:81; 720)
				
			End if 
			
			//______________________________________________________
	End case 