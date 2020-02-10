//%attributes = {"invisible":true}
  //ALERT("We are going too doux ;-)")
C_OBJECT:C1216($1)

If (False:C215)
	C_OBJECT:C1216(tmpl_INFOS ;$1)
End if 

  // $o.updateURL // lien de téléchargement
  // $o.homepage // repository url
  // $o.version
  // $o.name
  // $o.organisation.avatar_url
  // $o.organisation.description
  // $o.organisation.login

OPEN URL:C673($1.homepage)