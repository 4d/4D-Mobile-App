//%attributes = {"invisible":true}
#DECLARE($action : Text; $data : Object)

var $ƒ : Object

$ƒ:=panel

Case of 
		
		//=========================================================
	: ($action="loadActionIcons")  // Preload the icons
		
		$ƒ.loadIcons()
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$action+"\"")
		
		//=========================================================
End case 