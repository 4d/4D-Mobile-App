//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : env_System_path
  // Database: 4D Mobile Express
  // ID[9F9CD87FDDDB491389865E3C3C6C5D56]
  // Created 23-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD-SAFE
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_POSIX)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_pathname;$Txt_buffer;$Txt_selector)

If (False:C215)
	C_TEXT:C284(_o_env_System_path ;$0)
	C_TEXT:C284(_o_env_System_path ;$1)
	C_BOOLEAN:C305(_o_env_System_path ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1  // "boot"
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_POSIX:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_selector="boot")
		
		$Txt_buffer:="/"
		
		  //______________________________________________________
	: ($Txt_selector="volumes")
		
		$Txt_buffer:="/Volumes/"
		
		  //______________________________________________________
	: ($Txt_selector="library")
		
		$Txt_buffer:="/Library/"
		
		  //______________________________________________________
	: ($Txt_selector="caches")
		
		$Txt_buffer:="/Library/Caches/"
		
		  //______________________________________________________
	: ($Txt_selector="applicationSupport")
		
		$Txt_buffer:="/Library/Application Support/"
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

If ($Boo_POSIX)
	
	  // NOTHING MORE TO DO
	$Dir_pathname:=$Txt_buffer
	
Else 
	
	$Dir_pathname:=Convert path POSIX to system:C1107($Txt_buffer)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dir_pathname

  // ----------------------------------------------------
  // End