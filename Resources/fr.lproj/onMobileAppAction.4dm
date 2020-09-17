<!--#4DCODE  
  ARRAY TEXT:C222(t;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($1);t)  
  ARRAY TEXT:C222(tt;0)
  COLLECTION TO ARRAY:C1562($4DEVAL($2);tt)  
-->
var $1 : Object // Informations fournies par l'application mobile
var $0 : Object // Informations retournées à l'application mobile

$0:=New object:C1471 

Au cas ou 
<!--#4DLOOP t-->
:($1.action="$4DEVAL(t{t})") 

// Insérez ici le code de l'action "$4DEVAL(tt{t})"
<!--#4DENDLOOP-->
Sinon

// Action inconnue

Fin de cas
