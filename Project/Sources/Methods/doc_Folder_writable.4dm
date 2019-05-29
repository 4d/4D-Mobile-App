//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Folder_writable
  // Database: 4D Mobile App
  // ID[C0A1D56EE93C40FB898F95A41C6140F9]
  // Created #7-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_root;$File_tgt;$Txt_errorMethod)
C_OBJECT:C1216($Obj_out)

If (False:C215)
	C_OBJECT:C1216(doc_Folder_writable ;$0)
	C_TEXT:C284(doc_Folder_writable ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Dir_root:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_parameters=0)
	
	  //
	
Else 
	
	$Obj_out:=New object:C1471("pathname";$Dir_root)
	
	$File_tgt:=$Dir_root+"."+Generate UUID:C1066
	
	$Txt_errorMethod:=Method called on error:C704
	ON ERR CALL:C155(Current method name:C684)
	
	TEXT TO DOCUMENT:C1237($File_tgt;"")
	
	ON ERR CALL:C155($Txt_errorMethod)
	
	$Obj_out.writable:=(Test path name:C476($File_tgt)=Is a document:K24:1)
	
	If ($Obj_out.writable)
		
		DELETE DOCUMENT:C159($File_tgt)
		
	Else 
		
		$Obj_out.error:=ERROR
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End