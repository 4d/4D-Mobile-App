
C_OBJECT:C1216($0;$response)
C_OBJECT:C1216($1;$request)

$request:=$1  // Informations provided by mobile application
$response:=New object:C1471  // Informations returned to mobile application

Case of 
		
	: ($request.action="addCommands")
		
		  // Insert here the code for the action "Add…"
		
	: ($request.action="editThemes")
		
		  // Insert here the code for the action "Edit…"
		
	: ($request.action="action_0")
		
		  // Insert here the code for the action "action_0"
		
	: ($request.action="action_5")
		
		  // Insert here the code for the action "action_5"
		
	Else 
		
		  // Unknown action
		
End case 

$0:=$response
