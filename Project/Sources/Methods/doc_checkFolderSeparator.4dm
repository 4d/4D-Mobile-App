//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_checkFolderSeparator
  // ID[5CFF35FDEC5D4EE3A96409A2AA6D6A4C]
  // Created 25-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Checks if the last character of a pathname is a folder separator,
  // adds it if not
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_in;$Dir_out)
C_OBJECT:C1216($Obj_buffer)

If (False:C215)
	C_TEXT:C284(doc_checkFolderSeparator ;$0)
	C_TEXT:C284(doc_checkFolderSeparator ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dir_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Dir_out:=$Dir_in
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_buffer:=Path to object:C1547($Dir_in)

If (Not:C34($Obj_buffer.isFolder))
	
	  // Add missing final folder separator
	$Obj_buffer.isFolder:=True:C214
	$Dir_out:=Object to path:C1548($Obj_buffer)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dir_out

  // ----------------------------------------------------
  // End