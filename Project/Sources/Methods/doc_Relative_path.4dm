//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Relative_path
  // Database: 4D Mobile App
  // ID[F4814664202B48FFB36D9D3F6928D848]
  // Created #15-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the relative path into a reference directory
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_directory;$Txt_buffer;$Txt_pathname;$Txt_reference;$Txt_relativePath)

If (False:C215)
	C_TEXT:C284(doc_Relative_path ;$0)
	C_TEXT:C284(doc_Relative_path ;$1)
	C_TEXT:C284(doc_Relative_path ;$2)
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
	
	$Txt_relativePath:=$Txt_pathname
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_buffer:=Convert path system to POSIX:C1106($Txt_pathname)
$Txt_reference:=Convert path system to POSIX:C1106($Dir_directory)

If (Position:C15($Txt_reference;$Txt_buffer)=1)
	
	$Txt_relativePath:=Convert path POSIX to system:C1107(Replace string:C233($Txt_buffer;$Txt_reference;"";1))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Txt_relativePath  // Relative path into the reference, same as input if not relative

  // ----------------------------------------------------
  // End