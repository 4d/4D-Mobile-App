<!--#4DCODE  
  ARRAY TEXT:C222(t;0) 
  ARRAY TEXT:C222(tt;0)
  ARRAY TEXT:C222(ttt;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($1); t;"name";tt;"label";ttt;"comment") 
--> #DECLARE($request : Object)->$response : Object

/*
	$request = Informations provided by mobile application
	$response = Informations returned to mobile application
*/

$response:=New object:C1471 

Case of 
<!--#4DLOOP t-->
:($request.action="$4DEVAL(t{t})") 

// Insert here the code for the action "$4DEVAL(tt{t})" ($4DEVAL(ttt{t}))
<!--#4DENDLOOP-->
Else

// Unknown action

End case
