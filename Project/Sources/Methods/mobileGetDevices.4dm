//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : mobileGetDevices
// ID[738D4FF89D414DF286DAB9CACD196B02]
// Created 14-1-2021 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Gets the list of simulator devices available
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

// ----------------------------------------------------
// Initialisations
If (Value type:C1509(SHARED)=Is undefined:K8:13)  // For testing purposes
	
	COMPONENT_INIT
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (DATABASE.isMacOs)
		
		If (FEATURE.with("android"))
			
			$out:=New object:C1471(\
				"android"; cs:C1710.avd.new().availableDevices(); \
				"apple"; simulator(New object:C1471(\
				"action"; "devices"; \
				"filter"; "available"; \
				"minimumVersion"; SHARED.iosDeploymentTarget)).devices)
			
		Else 
			
			$out:=simulator(New object:C1471(\
				"action"; "devices"; \
				"filter"; "available"; \
				"minimumVersion"; SHARED.iosDeploymentTarget))
			
		End if 
		
		//______________________________________________________
	: (DATABASE.isWindows)
		
		$out:=New object:C1471(\
			"android"; cs:C1710.avd.new().availableDevices(); \
			"apple"; New collection:C1472)
		
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

// ----------------------------------------------------
// End