//%attributes = {"invisible":true}
#DECLARE($in : Object)->$out : Object


If (Value type:C1509(SHARED)=Is undefined:K8:13)  // For testing purposes
	
	COMPONENT_INIT
	
End if 

Case of 
		
		//______________________________________________________
	: (DATABASE.isMacOs)
		
		If (FEATURE.with("android"))
			
			var $o : Object
			$o:=simulator(New object:C1471(\
				"action"; "devices"; \
				"filter"; "available"; \
				"minimumVersion"; SHARED.iosDeploymentTarget))
			
			$out:=New object:C1471(\
				"apple"; $o.devices; \
				"android"; cs:C1710.avd.new().availableDevices())
			
		Else 
			
			$out:=simulator(New object:C1471(\
				"action"; "devices"; \
				"filter"; "available"; \
				"minimumVersion"; SHARED.iosDeploymentTarget))
			
		End if 
		
		//______________________________________________________
	: (DATABASE.isWindows)
		
		$out:=New object:C1471(\
			"apple"; New collection:C1472; \
			"android"; cs:C1710.avd.new().availableDevices())
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
If (Bool:C1537($in.caller))
	
	CALL FORM:C1391($in.caller; "editor_CALLBACK"; "simulator"; $out)
	
Else 
	
	$0:=$out
	
End if 