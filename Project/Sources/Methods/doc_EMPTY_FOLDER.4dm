//%attributes = {"invisible":true,"preemptive":"capable"}
/*
***doc_EMPTY_FOLDER*** ( pathname ; ignore )
 -> pathname (Text)
 -> ignore (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : doc_EMPTY_FOLDER
  // Database: 4D Mobile Express
  // ID[E23E578E76444AA2BD836D23FF85691C]
  // Created #4-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description:
C_TEXT:C284($1)
C_COLLECTION:C1488($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_pathname;$Txt_value)
C_OBJECT:C1216($Obj_;$Obj_folder)
C_COLLECTION:C1488($Col_ignore)

If (False:C215)
	C_TEXT:C284(doc_EMPTY_FOLDER ;$1)
	C_COLLECTION:C1488(doc_EMPTY_FOLDER ;$2)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Dir_pathname:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Col_ignore:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($Dir_pathname)=Is a folder:K24:2)
	
	If ($Col_ignore#Null:C1517)
		
		$Obj_folder:=doc_Folder ($Dir_pathname)
		
		For each ($Txt_value;$Col_ignore)
			
			$Obj_folder.folders:=$Obj_folder.folders.query("name != :1";$Txt_value+"@")
			$Obj_folder.files:=$Obj_folder.files.query("name != :1";$Txt_value+"@")
			
		End for each 
		
		For each ($Obj_;$Obj_folder.folders)
			
			DELETE FOLDER:C693($Obj_.nativePath;Delete with contents:K24:24)
			
		End for each 
		
		For each ($Obj_;$Obj_folder.files)
			
			DELETE DOCUMENT:C159($Obj_.nativePath)
			
		End for each 
		
	Else 
		
		DELETE FOLDER:C693($Dir_pathname;Delete with contents:K24:24)
		
	End if 
End if 

CREATE FOLDER:C475($Dir_pathname;*)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End