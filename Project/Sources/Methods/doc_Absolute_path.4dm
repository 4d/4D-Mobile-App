//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : doc_Absolute_path
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
C_TEXT:C284($Dir_directory;$Txt_absolutePath;$Txt_pathname;$Txt_reference)

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
	
	$Txt_absolutePath:=$Txt_pathname
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Txt_pathname[[1]]="/")
	
	$Txt_pathname:=Replace string:C233($Txt_pathname;Folder separator:K24:12;"/")
	$Txt_absolutePath:=Convert path system to POSIX:C1106($Dir_directory)+Delete string:C232($Txt_pathname;1;1)
	
End if 

$Txt_absolutePath:=Convert path POSIX to system:C1107($Txt_absolutePath)
  // ----------------------------------------------------
  // Return
$0:=$Txt_absolutePath

  // ----------------------------------------------------
  // End