#DECLARE($request : Object)->$response : Object

/*
	$request = Informations fournies par l'application mobile
	$response = Informations retournées à l'application mobile
*/

$response:=Créer objet:C1471

  // Vérifier l'email de l'utilisateur
Si ($request.email=Null:C1517)
	  // Pas d'e-mail  signifie mode Invité - Autoriser la connexion
	$response.success:=Vrai:C214
Sinon
	  // Mode authentifié - Autoriser ou non la connexion en fonction de l'e-mail ou autres propriétés de l'appareil
	$response.success:=Vrai:C214
Fin de si

  // Message facultatif à afficher sur l'application mobile.
Si ($response.success)
	$response.statusText:="Vous êtes authentifié avec succès"
Sinon
	$response.statusText:="Désolé, vous n'êtes pas autorisé à utiliser cette application"
Fin de si
