//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : doc_UNLOCK_DIRECTORY
// ID[2E04A66F44A64A7DBF01F62967E4C2FB]
// Created 6-7-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_cmd; $Txt_error; $Txt_in; $Txt_out)
C_OBJECT:C1216($Obj_in_out)

If (False:C215)
	C_OBJECT:C1216(_o_doc_UNLOCK_DIRECTORY; $1)
End if 

// ----------------------------------------------------
// Declarations

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	//Required parameters
	$Obj_in_out:=$1
	
	//Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_in_out.success:=False:C215
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Test path name:C476($Obj_in_out.path)=Is a folder:K24:2)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; $Obj_in_out.path)
	
	$Txt_cmd:=Choose:C955(Is Windows:C1573; \
		"attrib.exe -R /D /S"; \
		"chmod -R u+rwX '"+Convert path system to POSIX:C1106($Obj_in_out.path)+"'")
	
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
		
		If (Length:C16($Txt_error)=0)
			
			$Obj_in_out.success:=True:C214
			
		Else 
			
			$Obj_in_out.error:=$Txt_error
			
		End if 
	End if 
	
Else 
	
	$Obj_in_out.error:="Not a directory!"
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End