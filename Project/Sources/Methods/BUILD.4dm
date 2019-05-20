//%attributes = {"invisible":true}
/*
***BUILD*** ( in )
 -> in (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : BUILD
  // Database: 4D Mobile App
  // ID[0E60C5F1D0B948B0BE313B5059F35010]
  // Created #27-4-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Try to make UI building more fluent
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_OBJECT:C1216(BUILD ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
POST_FORM_MESSAGE (New object:C1471(\
"target";$Obj_in.caller;\
"action";"show";\
"type";"progress";\
"title";New collection:C1472("product";" - ";$Obj_in.project.product.name);\
"additional";Get localized string:C991("preparations");\
"autostart";New object:C1471("action";"build_run";"method";"EDITOR_RESUME";"project";$Obj_in)))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End