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
	: (Is macOS:C1572)
		
		If (FEATURE.with("android"))  // 🚧
			
			var $withStudio; $withXcode : Boolean
			$withXcode:=Bool:C1537($in.xCode.ready)
			$withStudio:=Bool:C1537($in.studio.ready)
			
			If ($withXcode)
				
				var $simctl : cs:C1710.simctl
				$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
				
			End if 
			
			Case of 
					
					//______________________________________________________
				: ($withStudio & $withXcode)
					
					$out:=New object:C1471(\
						"android"; cs:C1710.avd.new().availableDevices(); \
						"apple"; $simctl.availableDevices())
					
					//______________________________________________________
				: ($withStudio)
					
					$out:=New object:C1471(\
						"android"; cs:C1710.avd.new().availableDevices(); \
						"apple"; New collection:C1472)
					
					//______________________________________________________
				: ($withXcode)
					
					$out:=New object:C1471(\
						"android"; New collection:C1472; \
						"apple"; $simctl.availableDevices())
					
					//______________________________________________________
				Else 
					
					$out:=New object:C1471(\
						"android"; New collection:C1472; \
						"apple"; New collection:C1472)
					
					//______________________________________________________
			End case 
			
			If (FEATURE.with("ConnectedDevices")) & $withXcode
				
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
	: (Is Windows:C1573)
		
		If ($withStudio)
			
			$out:=New object:C1471(\
				"android"; cs:C1710.avd.new().availableDevices(); \
				"apple"; New collection:C1472)
			
		Else 
			
			$out:=New object:C1471(\
				"android"; New collection:C1472; \
				"apple"; New collection:C1472)
			
		End if 
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
If (Bool:C1537($in.caller))
	
	CALL FORM:C1391($in.caller; "editor_CALLBACK"; "simulator"; $out)
	
End if 