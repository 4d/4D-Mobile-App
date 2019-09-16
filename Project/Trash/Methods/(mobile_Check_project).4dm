//%attributes = {"invisible":true}
/*
error := ***mobile_Check_project*** ( project )
 -> project (Object)
 <- error (Long Integer) -  0 if no error
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : mobile_Check_project
  // Database: 4D Mobile Express
  // ID[FDC1FD5A00E043FE9F32876AEB5E1C63]
  // Created #4-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_error;$Lon_parameters)
C_OBJECT:C1216($Obj_project)

If (False:C215)
	C_LONGINT:C283(mobile_Check_project ;$0)
	C_OBJECT:C1216(mobile_Check_project ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_project:=$1
		
	Else 
		
		$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
		
	End if 
	
	$Lon_error:=-1  // Unknown error
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ((Length:C16($Obj_project.product.name)=0))
		
		DO_MESSAGE (New object:C1471(\
			"action";"show";\
			"type";"alert";\
			"title";"theProductNameIsMandatory";\
			"additional";"pleaseGiveNameToYourProduct";\
			"okAction";"goToProductName"))
		
		  //______________________________________________________
	Else 
		
		$Lon_error:=0  // no error
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Lon_error  // 0 if no error

  // ----------------------------------------------------
  // End