<!--#4DCODE  
  ARRAY TEXT:C222(t;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($1);t)  
  ARRAY TEXT:C222(tt;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($2);tt)  
-->
C_OBJECT:C1216($0;$response)
C_OBJECT:C1216($1;$request)

$request:=$1  // Informations fournies par l'application mobile
$response:=New object:C1471  // Informations retournées à l'application mobile

Au cas ou 
<!--#4DLOOP t-->
:($request.name="$4DEVAL(t{t})") 

// Insérez ici le code de l'action "$4DEVAL(tt{t})"
<!--#4DENDLOOP-->
Sinon

// Action inconnue

Fin de cas

$0:=$response