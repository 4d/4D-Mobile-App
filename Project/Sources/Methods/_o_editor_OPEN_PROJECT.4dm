//%attributes = {"invisible":true}
OBJECT SET VISIBLE:C603(*; "ribbon"; True:C214)
OBJECT SET VISIBLE:C603(*; "description"; True:C214)

EDITOR.goToPage("general")

If (FEATURE.with("wizards"))
	
	// Launch project verifications
	EDITOR.checkProject()
	
	// Audit of development tools
	EDITOR.checkDevTools()
	
Else 
	
	// Launch project verifications
	_o_editor_PROJECT_AUDIT
	
	var $worker : Text
	$worker:="4D Mobile ("+String:C10(Current form window:C827)+")"
	
	// Launch checking the development environment
	CALL WORKER:C1389($worker; "Xcode_CheckInstall"; New object:C1471(\
		"caller"; Current form window:C827))
	
	// Launch recovering the list of available simulator devices
	CALL WORKER:C1389($worker; "_o_simulator"; New object:C1471(\
		"action"; "devices"; \
		"filter"; "available"; \
		"minimumVersion"; SHARED.iosDeploymentTarget; \
		"caller"; Current form window:C827))
	
End if 