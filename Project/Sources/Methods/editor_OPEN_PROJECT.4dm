//%attributes = {"invisible":true}
OBJECT SET VISIBLE:C603(*; "ribbon"; True:C214)
OBJECT SET VISIBLE:C603(*; "description"; True:C214)

EDITOR.gotoPage("general")

If (FEATURE.with("wizards"))
	
	Form:C1466.$status:=New object:C1471(\
		"teamId"; False:C215; \
		"xCode"; False:C215; \
		"studio"; False:C215)
	
	// Launch project verifications
	editor_PROJECT_AUDIT
	
	// Launch checking the development environment
	CALL WORKER:C1389(Form:C1466.$worker; "editor_CHECK_INSTALLATION"; New object:C1471(\
		"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
	
	// Launch recovering the list of available simulator devices
	CALL WORKER:C1389(Form:C1466.$worker; "editor_GET_DEVICES"; New object:C1471(\
		"caller"; Form:C1466.$mainWindow; "project"; PROJECT))
	
Else 
	
	// Launch project verifications
	editor_PROJECT_AUDIT
	
	var $worker : Text
	$worker:="4D Mobile ("+String:C10(Current form window:C827)+")"
	
	// Launch checking the development environment
	CALL WORKER:C1389($worker; "Xcode_CheckInstall"; New object:C1471(\
		"caller"; Current form window:C827))
	
	// Launch recovering the list of available simulator devices
	CALL WORKER:C1389($worker; "simulator"; New object:C1471(\
		"action"; "devices"; \
		"filter"; "available"; \
		"minimumVersion"; SHARED.iosDeploymentTarget; \
		"caller"; Current form window:C827))
	
End if 