//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : COMPONENT_Infos
  // ID[75F81CD689A34E77A474AA215699B738]
  // Created 5-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)

C_LONGINT:C283($l)
C_TEXT:C284($t;$t_info;$t_selector)
C_OBJECT:C1216($o)

If (False:C215)
	C_TEXT:C284(COMPONENT_Infos ;$0)
	C_TEXT:C284(COMPONENT_Infos ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$t_selector:=$1
	
	  // Default values
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($t_selector="ideVersion")
		
		$t_info:=Application version:C493
		
		  //______________________________________________________
	: ($t_selector="ideBuildVersion")
		
		$t:=Application version:C493($l)
		$t_info:=String:C10($l)
		
		  //______________________________________________________
	: ($t_selector="componentBuild")
		
		$t_info:=plist_toObject (File:C1566("/PACKAGE/Info.plist").getText()).CFBundleVersion.string
		
		  //______________________________________________________
	: ($t_selector="componentVersion")
		
		$o:=plist_toObject (File:C1566("/PACKAGE/Info.plist").getText())
		
		$t_info:=$o.CFBundleShortVersionString.string+" ("+$o.CFBundleVersion.string+")"
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$t_selector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$t_info

  // ----------------------------------------------------
  // End