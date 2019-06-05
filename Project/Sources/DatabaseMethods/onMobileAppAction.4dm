
C_OBJECT:C1216($0;$response)
C_OBJECT:C1216($1;$request)

$request:=$1  // Informations provided by mobile application
$response:=New object:C1471  // Informations returned to mobile application

Case of 
		
	: ($request.action="action_2")
		
		  // Insert here the code for the action "action_2"
		
	: ($request.action="editAllTypes")
		
		  // Insert here the code for the action "Edit…"
		
	Else 
		
		  // Unknown action
		
End case 

$0:=$response
