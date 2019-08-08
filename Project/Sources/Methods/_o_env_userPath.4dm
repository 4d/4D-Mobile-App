//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : env_userPath
  // Database: 4D Mobile Express
  // ID[AE12412FB8A447B186B1EB9ED2161714]
  // Created 21-8-2017 by Vincent de Lachaux
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
C_LONGINT:C283($Lon_length;$Lon_parameters;$Lon_pos)
C_TEXT:C284($Dir_pathname;$Txt_path;$Txt_selector)

If (False:C215)
	C_TEXT:C284(_o_env_userPath ;$0)
	C_TEXT:C284(_o_env_userPath ;$1)
	C_BOOLEAN:C305(_o_env_userPath ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1  // "home" | "library" | "logs"
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_POSIX:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_path:=Convert path system to POSIX:C1106(Get 4D folder:C485(Database folder:K5:14;*))

If (Match regex:C1019("(?m-si)/Users/([^/]*)";$Txt_path;1;$Lon_pos;$Lon_length))
	
	$Txt_path:=Substring:C12($Txt_path;1;$Lon_length+1)
	
Else 
	
	$Txt_path:=Convert path system to POSIX:C1106(Path to object:C1547(System folder:C487(Desktop:K41:16)).parentFolder)
	
End if 

Case of 
		
		  //______________________________________________________
	: ($Txt_selector="home")
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Txt_selector="library")
		
		$Txt_path:=$Txt_path+"Library/"
		
		  //______________________________________________________
	: ($Txt_selector="preferences")
		
		$Txt_path:=$Txt_path+"Library/Preferences/"
		
		  //______________________________________________________
	: ($Txt_selector="caches")
		
		$Txt_path:=$Txt_path+"Library/Caches/"
		
		  //______________________________________________________
	: ($Txt_selector="cache")
		
		$Txt_path:=$Txt_path+"Library/Caches/com.4d.mobile/"
		
		  //#ACI0098572
		  //  //______________________________________________________
		  //: ($Txt_selector="cacheSdk")
		  //$Txt_path:=$Txt_path+"Library/Caches/com.4d.mobile/sdk/"
		
		  //______________________________________________________
	: ($Txt_selector="logs")
		
		$Txt_path:=$Txt_path+"Library/Logs/"
		
		  //______________________________________________________
	: ($Txt_selector="applicationSupport")
		
		$Txt_path:=$Txt_path+"Library/Application Support/"
		
		  //______________________________________________________
	: ($Txt_selector="simulators")
		
		$Txt_path:=$Txt_path+"Library/Developer/CoreSimulator/Devices/"
		
		  //______________________________________________________
	: ($Txt_selector="derivedData")
		
		$Txt_path:=$Txt_path+"Library/Developer/Xcode/DerivedData/"
		
		  //______________________________________________________
	: ($Txt_selector="archives")
		
		$Txt_path:=$Txt_path+"Library/Developer/Xcode/Archives/"
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

If ($Boo_POSIX)
	
	  // NOTHING MORE TO DO
	$Dir_pathname:=$Txt_path
	
Else 
	
	$Dir_pathname:=Convert path POSIX to system:C1107($Txt_path)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Dir_pathname

  // ----------------------------------------------------
  // End