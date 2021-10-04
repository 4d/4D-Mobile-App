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
var $0 : Text
var $1 : Text

If (False:C215)
	C_TEXT:C284(COMPONENT_Infos; $0)
	C_TEXT:C284(COMPONENT_Infos; $1)
End if 

var $t; $info; $selector : Text
var $l : Integer
var $o : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$selector:=$1
	
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
	: ($selector="ideVersion")
		
		$info:=Application version:C493
		
		//______________________________________________________
	: ($selector="ideBuildVersion")
		
		$t:=Application version:C493($l)
		$info:=String:C10($l)
		
		//______________________________________________________
	: ($selector="componentBuild")
		
		If (File:C1566("/PACKAGE/Info.plist").exists)
			
			$o:=plist_toObject(File:C1566("/PACKAGE/Info.plist").getText())
			
			If ($o.CFBundleVersion.string#Null:C1517)
				
				$info:=$o.CFBundleVersion.string
				
			Else 
				
				$info:=COMPONENT_Infos("ideBuildVersion")
				
			End if 
			
		Else 
			
			$info:=COMPONENT_Infos("ideBuildVersion")
			
		End if 
		
		//______________________________________________________
	: ($selector="componentVersion")
		
		If (File:C1566("/PACKAGE/Info.plist").exists)
			
			$o:=plist_toObject(File:C1566("/PACKAGE/Info.plist").getText())
			
			If ($o.CFBundleShortVersionString.string#Null:C1517)
				
				$info:=$o.CFBundleShortVersionString.string
				
				If ($o.CFBundleVersion.string#Null:C1517)
					
					$info:=$info+" ("+$o.CFBundleVersion.string+")"
					
				End if 
				
			Else 
				
				$info:=COMPONENT_Infos("ideVersion")+" ("+COMPONENT_Infos("ideBuildVersion")+")"
				
			End if 
			
		Else 
			
			$info:=COMPONENT_Infos("ideVersion")+" ("+COMPONENT_Infos("ideBuildVersion")+")"
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$info

// ----------------------------------------------------
// End