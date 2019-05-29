//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : mobile_Check_installation
  // Database: 4D Mobile Express
  // ID[684C0081C1734937A99F71EC2516C9F8]
  // Created #30-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(mobile_Check_installation ;$0)
	C_OBJECT:C1216(mobile_Check_installation ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Is macOS:C1572)
	
	$Obj_out:=Xcode_CheckInstall ($Obj_in)
	
Else 
	
	$Obj_out:=New object:C1471(\
		"platform";3;\
		"XcodeAvailable";False:C215;\
		"toolsAvalaible";False:C215;\
		"ready";False:C215)
	
End if 

  // ----------------------------------------------------
  // Return
If (Bool:C1537($Obj_in.caller))
	
	CALL FORM:C1391($Obj_in.caller;"editor_CALLBACK";"checkInstall";$Obj_out)
	
Else 
	
	$0:=$Obj_out
	
End if 

  // ----------------------------------------------------
  // End