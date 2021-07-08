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
var $withStudio; $withXcode : Boolean
var $simctl : cs:C1710.simctl
var $avd : cs:C1710.avd

If (Value type:C1509(SHARED)=Is undefined:K8:13)  // For testing purposes
	
	COMPONENT_INIT
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Is macOS:C1572)
		
		$withXcode:=Bool:C1537($in.xCode.ready)
		$withStudio:=Bool:C1537($in.studio.ready) & (FEATURE.with("android"))
		
		If ($withXcode)
			
			$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
			
		End if 
		
		If ($withStudio)
			
			$avd:=cs:C1710.avd.new()
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: ($withStudio & $withXcode)
				
				$out:=New object:C1471(\
					"android"; $avd.availableDevices(); \
					"apple"; $simctl.availableDevices())
				
				//______________________________________________________
			: ($withStudio)
				
				$out:=New object:C1471(\
					"android"; $avd.availableDevices(); \
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
		
		If (FEATURE.with("ConnectedDevices"))
			
			Case of 
					
					//______________________________________________________
				: ($withStudio & $withXcode)
					
					$out.plugged:=New object:C1471(\
						"android"; cs:C1710.adb.new().plugged(); \
						"apple"; $simctl.plugged())
					
					
					//______________________________________________________
				: ($withStudio)
					
					$out.plugged:=New object:C1471(\
						"android"; cs:C1710.adb.new().plugged(); \
						"apple"; New collection:C1472)
					
					//______________________________________________________
				: ($withXcode)
					
					$out.plugged:=New object:C1471(\
						"android"; New collection:C1472; \
						"apple"; $simctl.plugged())
					
					//______________________________________________________
				Else 
					
					$out:=New object:C1471(\
						"android"; New collection:C1472; \
						"apple"; New collection:C1472)
					
					//______________________________________________________
			End case 
			
		Else 
			
			$out.plugged:=New object:C1471(\
				"android"; New collection:C1472; \
				"apple"; New collection:C1472)
			
		End if 
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		$withStudio:=Bool:C1537($in.studio.ready)
		
		If ($withStudio)
			
			$out:=New object:C1471(\
				"android"; cs:C1710.avd.new().availableDevices(); \
				"apple"; New collection:C1472)
			
		Else 
			
			$out:=New object:C1471(\
				"android"; New collection:C1472; \
				"apple"; New collection:C1472)
			
		End if 
		
		If (FEATURE.with("ConnectedDevices"))
			
			If ($withStudio)
				
				$out.plugged:=New object:C1471(\
					"android"; cs:C1710.adb.new().plugged(); \
					"apple"; New collection:C1472)
				
			Else 
				
				$out.plugged:=New object:C1471(\
					"android"; New collection:C1472; \
					"apple"; New collection:C1472)
				
			End if 
			
		Else 
			
			$out.plugged:=New object:C1471(\
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
	
	CALL FORM:C1391($in.caller; "editor_CALLBACK"; "getDevices"; $out)
	
End if 