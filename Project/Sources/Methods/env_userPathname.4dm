//%attributes = {"invisible":true,"preemptive":"capable"}
/*
path := ***env_userPathname*** ( selector )
 -> selector (Text) -  "home" | "library" | "logs" | ...
 <- path (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : env_userPath
  // Database: 4D Mobile Express
  // ID[AE12412FB8A447B186B1EB9ED2161714]
  // Created #21-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_selector)
C_OBJECT:C1216($Obj_path)

If (False:C215)
	C_OBJECT:C1216(env_userPathname ;$0)
	C_TEXT:C284(env_userPathname ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1  // "home" | "library" | "logs" | ...
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_path:=Folder:C1567(fk desktop folder:K87:19).parent

Case of 
		
		  //______________________________________________________
	: ($Txt_selector="home")
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Txt_selector="library")
		
		$Obj_path:=$Obj_path.folder("Library/")
		
		  //______________________________________________________
	: ($Txt_selector="preferences")
		
		$Obj_path:=$Obj_path.folder("Library/Preferences/")
		
		  //______________________________________________________
	: ($Txt_selector="caches")
		
		$Obj_path:=$Obj_path.folder("Library/Caches/")
		
		  //______________________________________________________
	: ($Txt_selector="cache")
		
		$Obj_path:=$Obj_path.folder("Library/Caches/com.4d.mobile/")
		
		  //______________________________________________________
	: ($Txt_selector="logs")
		
		$Obj_path:=$Obj_path.folder("Library/Logs/")
		
		  //______________________________________________________
	: ($Txt_selector="applicationSupport")
		
		$Obj_path:=$Obj_path.folder("Library/Application Support/")
		
		  //______________________________________________________
	: ($Txt_selector="simulators")
		
		$Obj_path:=$Obj_path.folder("Library/Developer/CoreSimulator/Devices/")
		
		  //______________________________________________________
	: ($Txt_selector="derivedData")
		
		$Obj_path:=$Obj_path.folder("Library/Developer/Xcode/DerivedData/")
		
		  //______________________________________________________
	: ($Txt_selector="archives")
		
		$Obj_path:=$Obj_path.folder("Library/Developer/Xcode/Archives/")
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
		
		$Obj_path:=New object:C1471(\
			"exists";False:C215)
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_path

  // ----------------------------------------------------
  // End