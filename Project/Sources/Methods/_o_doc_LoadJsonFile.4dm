//%attributes = {"invisible":true,"preemptive":"capable"}
/*
object := ***doc_LoadJsonFile*** ( path )
 -> path (Text)
 <- object (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : doc_LoadJsonFile
  // Database: 4D Mobile App
  // ID[0FE8A1B89C074B549AA9E97999C60305]
  // Created #9-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_path)
C_OBJECT:C1216($Obj_object)

If (False:C215)
	C_OBJECT:C1216(_o_doc_LoadJsonFile ;$0)
	C_TEXT:C284(_o_doc_LoadJsonFile ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$File_path:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($File_path)=Is a document:K24:1)
	
	$Obj_object:=JSON Parse:C1218(Document to text:C1236($File_path))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_object

  // ----------------------------------------------------
  // End