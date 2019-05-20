C_OBJECT:C1216($0;$response)
C_OBJECT:C1216($1;$request)

$request:=$1  // Informations provided by mobile application
$response:=New object:C1471  // Informations returned to mobile application

Case of 
		
	: ($request.action="editAllTypes")
		
		  // Insert here the code for the action "Edit…"
		
	: ($request.action="action_2")
		
		  // Insert here the code for the action "action_2"
		
	: ($request.action="action_3")
		
		  // Insert here the code for the action "action_3"
		
	: ($request.action="action_4")
		
		  // Insert here the code for the action "action_4"
		
	: ($request.action="action_5")
		
		  // Insert here the code for the action "action_5"
		
	Else 
		
		  // Unknown action
		
End case 

$0:=$response
