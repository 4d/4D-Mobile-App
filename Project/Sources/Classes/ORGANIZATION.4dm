/*===============================================
ORGANIZATION pannel Class
===============================================*/
Class extends form

//________________________________________________________________
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.name:=cs:C1710.widget.new("10_name")
		This:C1470.nameHelp:=cs:C1710.button.new("10_name.help")
		This:C1470.identifier:=cs:C1710.widget.new("30_identifier")
		This:C1470.identifierHelp:=cs:C1710.button.new("30_identifier.help")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	