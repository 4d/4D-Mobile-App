//%attributes = {"invisible":true}
#DECLARE($action : Text; $data : Object)

Case of 
		
		//=========================================================
	: ($action="loadActionIcons")  // Preload the icons
		
		panel.loadIcons()
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$action+"\"")
		
		//=========================================================
End case 