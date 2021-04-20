//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : DEVELOPER_CALLBACK
// Created 21-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($response : Object)

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($response.action="teamID")  // Call back from provisioningProfiles
		
		panel_Definition("DEVELOPER").updateTeamID($response)
		
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($response.action)+"\"")
		
		//=========================================================
End case 