//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_GET_DEVICES
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
		
		If (FEATURE.with("android"))  //🚧
			
			var $avd : cs:C1710.avd
			$avd:=cs:C1710.avd.new()
			
			var $simctl : cs:C1710.simctl
			$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
			
			$out:=New object:C1471(\
				"android"; $avd.availableDevices(); \
				"apple"; $simctl.availableDevices())
			
			If (FEATURE.with("ConnectedDevices"))
				
				$out.connected:=New object:C1471(\
					"android"; New collection:C1472; \
					"apple"; $simctl.plugged())
				
			Else 
				
				$out.connected:=New object:C1471(\
					"android"; New collection:C1472; \
					"apple"; New collection:C1472)
				
			End if 
			
		Else 
			
			$out:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget).availableDevices()
			
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