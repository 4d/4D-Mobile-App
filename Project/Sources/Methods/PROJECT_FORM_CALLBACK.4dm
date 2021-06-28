//%attributes = {"invisible":true}
#DECLARE($action : Text; $data : Object)->$result : Object

var $ƒ : Object

If (Form:C1466.$dialog.PROJECT=Null:C1517)
	
	Form:C1466.$dialog.PROJECT:=cs:C1710.PROJECT_FORM.new()
	
End if 

$ƒ:=Form:C1466.$dialog.PROJECT

Case of 
		
		//=========================================================
	: ($action="projectAudit")  // Audit the project
		
		If (Num:C11(EDITOR.window)#0)
			
			// Send result
			EDITOR.callMeBack("projectAuditResult"; PROJECT.audit())
			
		Else 
			
			// Test purpose - Return result
			$result:=PROJECT.audit($data)
			
		End if 
		
		//=========================================================
	: ($action="IconPickerResume")  // Return from the icons' picker
		
		$ƒ.current.icon:=$data.pathnames[$data.item-1]
		PROJECT.save()
		
		// Update UI
		var $p : Picture
		$p:=$data.pictures[$data.item-1]
		CREATE THUMBNAIL:C679($p; $p; 24; 24; Scaled to fit:K6:2)
		$ƒ.current.$icon:=$p
		$ƒ.actions.touch()
		
		$ƒ.refresh()
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$action+"\"")
		
		//=========================================================
End case 