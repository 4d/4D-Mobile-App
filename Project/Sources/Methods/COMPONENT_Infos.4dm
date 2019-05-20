//%attributes = {"invisible":true}
/*
info := ***COMPONENT_Infos*** ( entryPoint )
 -> entryPoint (Text)
 <- info (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : COMPONENT_Infos
  // Database: 4D Mobile App
  // ID[75F81CD689A34E77A474AA215699B738]
  // Created #5-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_build;$Lon_parameters)
C_TEXT:C284($t;$Txt_entryPoint;$Txt_info)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(COMPONENT_Infos ;$0)
	C_TEXT:C284(COMPONENT_Infos ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_entryPoint:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_entryPoint="ideVersion")
		
		$Txt_info:=String:C10(Application version:C493)
		
		  //______________________________________________________
	: ($Txt_entryPoint="ideBuildVersion")
		
		$t:=Application version:C493($Lon_build)
		
		$Txt_info:=String:C10($Lon_build)
		
		  //______________________________________________________
	: ($Txt_entryPoint="componentBuild")
		
		$Txt_info:=plist_toObject (File:C1566("/PACKAGE/Info.plist").getText()).CFBundleVersion.string
		
		  //______________________________________________________
	: ($Txt_entryPoint="componentVersion")
		
		$o:=plist_toObject (File:C1566("/PACKAGE/Info.plist").getText())
		
		$Txt_info:=$o.CFBundleShortVersionString.string+" ("+$o.CFBundleVersion.string+")"
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_entryPoint+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_info

  // ----------------------------------------------------
  // End