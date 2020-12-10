//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : doc_Expand_path
// ID[C11D2FC01A4543E1A05EE387B270B5E0]
// Created 23-11-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Looking for "$XXXX" patterns into a posix path
// and return the expanded native path
//
// *$1 MUST USE A POSIX SYNTAX*
//
// Currently supported patterns :
// - $DESKTOP maps to the user's desktop folder
// - $DOCUMENTS maps to the user's Documents folder
// - $SYSTEM maps to the system folder
// - $TEMP maps to the current temporary folder
// - $LICENCES map's to the Licenses folder
// - $PREFERENCES map's to the system's preferences folder
// - $USER_PREFERENCES map's to the users's freferences folder
// - $4D for the active 4D folder
// - $RESSOURCES map's to the Resources folder
// - $DATA map' to the folder containing the current data file
// - $DATABASE map's to the folder containing the database structure file
// - $HTML map's to the current HTML root folder
// - $LOGS map's to the logs folder
// - $MOBILE map's to the MobileApps folder
//
// The suffix "_HOST" allow to return the host database equivalent when it's relevant
// Apart of execution as a component, $XXX & $XXX_HOST are strictly equivalent
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_directory)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_expanded; $Txt_pattern; $Txt_posix)
C_OBJECT:C1216($Obj_rgx)

If (False:C215)
	C_TEXT:C284(doc_Expand_path; $0)
	C_TEXT:C284(doc_Expand_path; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Txt_posix:=$1
	
	// Default values
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Txt_expanded:=$Txt_posix
	
	$Boo_directory:=($Txt_expanded[[Length:C16($Txt_expanded)]]="/")
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16($Txt_posix)>0)
	
	var $pos; $len : Integer
	If (Match regex:C1019("(?m-si)(\\$[^/]*)"; $Txt_posix; 1; $pos; $len))
		
		$Txt_pattern:=Substring:C12($Txt_posix; $pos; $len)
		
		Case of 
				
				//______________________________________________________
			: ($Txt_pattern="$TEMP")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Temporary folder:C486)
				
				//______________________________________________________
			: ($Txt_pattern="$DESKTOP")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(Desktop:K41:16))
				
				//______________________________________________________
			: ($Txt_pattern="$DOCUMENTS")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(Documents folder:K41:18))
				
				//______________________________________________________
			: ($Txt_pattern="$APPLICATION")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(Applications or program files:K41:17))
				
				//______________________________________________________
			: ($Txt_pattern="$SYSTEM")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(Choose:C955(Is macOS:C1572; System:K41:1; System Win:K41:13)))
				
				//______________________________________________________
			: ($Txt_pattern="$PREFERENCES")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(User preferences_all:K41:3))
				
				//______________________________________________________
			: ($Txt_pattern="$USER_PREFERENCES")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(System folder:C487(User preferences_user:K41:4))
				
				//______________________________________________________
			: ($Txt_pattern="$4D")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Active 4D Folder:K5:10))
				
				//______________________________________________________
			: ($Txt_pattern="$RESSOURCES")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16))
				
				//______________________________________________________
			: ($Txt_pattern="$RESSOURCES_HOST")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16; *))
				
				//______________________________________________________
			: ($Txt_pattern="$DATA")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Data folder:K5:33; *))
				
				//______________________________________________________
			: ($Txt_pattern="$DATABASE")
				
				$Txt_expanded:=Get 4D folder:C485(Database folder UNIX syntax:K5:15)
				
				//______________________________________________________
			: ($Txt_pattern="$DATABASE_HOST")
				
				$Txt_expanded:=Get 4D folder:C485(Database folder UNIX syntax:K5:15; *)
				
				//______________________________________________________
			: ($Txt_pattern="$HTML")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(HTML Root folder:K5:20))
				
				//______________________________________________________
			: ($Txt_pattern="$HTML_HOST")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(HTML Root folder:K5:20; *))
				
				//______________________________________________________
			: ($Txt_pattern="$LICENCES")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Licenses folder:K5:11))
				
				//______________________________________________________
			: ($Txt_pattern="$LOGS")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Logs folder:K5:19))
				
				//______________________________________________________
			: ($Txt_pattern="$LOGS_HOST")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(Logs folder:K5:19; *))
				
				//______________________________________________________
			: ($Txt_pattern="$MOBILE")
				
				$Txt_expanded:=Convert path system to POSIX:C1106(Get 4D folder:C485(MobileApps folder:K5:47; *))
				
				//______________________________________________________
				//: ($Txt_pattern="$MOBILE_HOST")
				
				//$Txt_expanded:=Convert path system to POSIX(Get 4D folder(MobileApps folder;*))
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Unknown pattern: \""+$Txt_pattern+"\"")
				
				//______________________________________________________
		End case 
		
		$Txt_expanded:=Delete string:C232($Txt_expanded; Length:C16($Txt_expanded); 1)
		$Txt_expanded:=Replace string:C233($Txt_posix; $Txt_pattern; $Txt_expanded; 1)
		
		If ($Boo_directory)\
			 & ($Txt_expanded[[Length:C16($Txt_expanded)]]#"/")
			
			$Txt_expanded:=$Txt_expanded+"/"
			
		End if 
	End if 
	
	$Txt_expanded:=Convert path POSIX to system:C1107($Txt_expanded)
	
End if 

// ----------------------------------------------------
// Return
$0:=$Txt_expanded

// ----------------------------------------------------
// End