//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_CHECK_INSTALLATION
// ID[684C0081C1734937A99F71EC2516C9F8]
// Created 30-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Carries out controls of the development environment
// According to platform and OS target
// ----------------------------------------------------
// Declarations
#DECLARE($in : Object)->$out : Object

var $android; $ios : Boolean
var $studio; $xcode : Object
var $fileManifest : 4D:C1709.File

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Is macOS:C1572)
		
		If (FEATURE.with("android"))  // 🚧
			
			$studio:=$in.studio
			$xcode:=$in.xCode
			
			$android:=Bool:C1537($in.android)
			$ios:=Bool:C1537($in.ios)
			
			If (Not:C34(Bool:C1537($studio.ready)))\
				 & (Not:C34(Bool:C1537($studio.canceled)))
				
				// Silent mode if not Android target
				$in.silent:=Not:C34($android)
				$studio:=studioCheckInstall($in)
				
			End if 
			
			If ($studio.ready)
				
				If ($android)
					
					$fileManifest:=cs:C1710.path.new().cacheSdkAndroid().parent.file("manifest.json")
					
					If (Not:C34($fileManifest.exists))\
						 | ($fileManifest.modificationDate#Current date:C33)
						
						// Get the last 4D Mobile Android SDK from AWS server if any
						CALL WORKER:C1389(1; "downloadSDK"; "aws"; "android"; False:C215; $in.caller)
						
					End if 
				End if 
				
			Else 
				
				$studio.canceled:=Bool:C1537($studio.canceled)
				
			End if 
			
			If (Not:C34(Bool:C1537($xcode.ready)))
				
				If (Not:C34(Bool:C1537($xcode.canceled)))
					
					$in.silent:=Not:C34($ios)
					$xcode:=Xcode_CheckInstall($in)
					
				End if 
			End if 
			
			If ($xcode.ready)
				
				If ($ios)
					
					$fileManifest:=cs:C1710.path.new().cacheSdkApple().parent.file("manifest.json")
					
					If (Not:C34($fileManifest.exists))\
						 | ($fileManifest.modificationDate#Current date:C33)
						
						// Get the last 4D Mobile Android SDK from AWS server if any
						//CALL WORKER(1; "downloadSDK"; "aws"; "ios"; False; $in.caller)
						
					End if 
				End if 
				
			Else 
				
				$xcode.canceled:=Bool:C1537($xcode.canceled)
				
			End if 
			
			$out:=New object:C1471(\
				"xCode"; $xcode; \
				"studio"; $studio)
			
		Else 
			
			$out:=Xcode_CheckInstall($in)
			
		End if 
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		$studio:=$in.studio
		
		If (Not:C34(Bool:C1537($studio.canceled)))
			
			$out:=New object:C1471(\
				"xCode"; New object:C1471("platform"; Windows:K25:3; \
				"XcodeAvailable"; False:C215; \
				"toolsAvalaible"; False:C215; \
				"ready"; False:C215); \
				"studio"; studioCheckInstall($in))
			
			If (Bool:C1537($out.studio.ready))
				
				$fileManifest:=cs:C1710.path.new().cacheSdkAndroid().parent.file("manifest.json")
				
				If (Not:C34($fileManifest.exists))\
					 | ($fileManifest.modificationDate#Current date:C33)
					
					// Get the last 4D Mobile Android SDK from AWS server if any
					CALL WORKER:C1389(1; "downloadSDK"; "aws"; "android"; False:C215; $in.caller)
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

If (Bool:C1537($in.caller))
	
	CALL FORM:C1391($in.caller; "editor_CALLBACK"; "checkInstall"; $out)
	
End if 