<!--#4DCODE  
  ARRAY TEXT:C222(t;0) 
  ARRAY TEXT:C222(tt;0)
  ARRAY TEXT:C222(ttt;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($1); t;"name";tt;"label";ttt;"comment") 
--> #DECLARE($request : Object)->$response : Object

/*
	$request = Informations fournies par l'application mobile
	$response = Informations retournées à l'application mobile
*/

$response:=New object:C1471

Au cas ou 
<!--#4DLOOP t-->
:($request.action="$4DEVAL(t{t})") 

// Insérez ici le code de l'action "$4DEVAL(tt{t})" ($4DEVAL(ttt{t}))
<!--#4DENDLOOP-->
Sinon

// Action inconnue

Fin de cas
