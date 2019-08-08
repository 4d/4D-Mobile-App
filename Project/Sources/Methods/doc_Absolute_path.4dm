//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Absolute_path
  // Database: 4D Mobile App
  // ID[8A5E48E09B044D7986B07E1540F01211]
  // Created 22-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_directory;$Txt_absolutePath;$Txt_buffer;$Txt_pathname;$Txt_reference)
C_OBJECT:C1216($Obj_path)

If (False:C215)
	C_TEXT:C284(doc_Absolute_path ;$0)
	C_TEXT:C284(doc_Absolute_path ;$1)
	C_TEXT:C284(doc_Absolute_path ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_pathname:=$1  // Path to be treated
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Dir_directory:=$2  // Reference directory (database folder if omitted)
		
	Else 
		
		  // Default is the host database folder
		$Dir_directory:=Get 4D folder:C485(Database folder:K5:14;*)
		
	End if 
	
	$Txt_reference:=Convert path system to POSIX:C1106($Dir_directory)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

Repeat 
	
	$Obj_path:=Path to object:C1547($Txt_pathname)
	
	$Txt_buffer:=$Obj_path.name+$Obj_path.extension+("/"*Num:C11($Obj_path.isFolder))+$Txt_buffer
	
	If (Length:C16(String:C10($Obj_path.parentFolder))>0)
		
		$Obj_path:=Path to object:C1547($Obj_path.parentFolder)
		$Txt_pathname:=Object to path:C1548($Obj_path)
		
	End if 
Until (String:C10($Obj_path.parentFolder)="")

$Txt_buffer:=$Obj_path.name+$Obj_path.extension+"/"+$Txt_buffer

If (Position:C15($Txt_reference;$Txt_buffer)=0)
	
	$Txt_buffer:=$Txt_reference+$Txt_buffer
	
End if 

$Txt_absolutePath:=Convert path POSIX to system:C1107($Txt_buffer)

  // ----------------------------------------------------
  // Return
$0:=$Txt_absolutePath

  // ----------------------------------------------------
  // End