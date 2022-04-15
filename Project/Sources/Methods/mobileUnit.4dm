//%attributes = {"invisible":true,"shared":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : mobileUnit
// ID[397F98984CE44B3CB94A856B86C833B1]
// Created 21-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// API for unit tests
// ----------------------------------------------------
// Declarations
#DECLARE($entryPoint : Text; $parameters : Object)->$response : Object

If (False:C215)
	C_TEXT:C284(mobileUnit; $1)
	C_OBJECT:C1216(mobileUnit; $2)
	C_OBJECT:C1216(mobileUnit; $0)
End if 

var $t : Text
var $b; $run : Boolean
var $o : Object
var $file : 4D:C1709.File
var $path : cs:C1710.path

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	COMPONENT_INIT
	
	// ----------------------------------------------------
	Case of 
			
			//______________________________________________________
		: ($entryPoint="uninstallAndroidStudio")
			
			cs:C1710.studio.new().uninstall()
			
			//______________________________________________________
		: ($entryPoint="testSuites")
			
			$response:=New object:C1471
			$response.errors:=Formula:C1597(lastError)
			$response.component:=SHARED.component
			$response.requirement:=New object:C1471(\
				"xCodeVersion"; SHARED.xCodeMinVersion; \
				"iosDeploymentTarget"; SHARED.iosDeploymentTarget)
			$response.targetedDeviceFamily:=SHARED.targetedDeviceFamily
			$response.simulatorTimeout:=SHARED.simulatorTimeout
			$response.tests:=New collection:C1472
			
			$o:=New signal:C1641
			
			CALL WORKER:C1389(1; Formula:C1597(unitTestSuites).source; $o)
			
			If ($o.wait(10))
				
				For each ($t; $o.result)
					
					$response.tests.push(Formula from string:C1601($t))
					
				End for each 
				
				$response.success:=($response.tests.length>0)
				
			Else 
				
				$response.success:=False:C215
				$response.errors:="Failed to load internal test methods"
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="featuresFlags")
			
			$response:=New object:C1471(\
				"features"; Formula:C1597(Feature))
			
			//______________________________________________________
		: ($entryPoint="loadProject")
			
			If (Asserted:C1132($parameters.project#Null:C1517; "Expected 'project' key into object parameter"))
				
				EXECUTE METHOD:C1007(Formula:C1597(project_Upgrade).source; $b; $parameters.project)
				
				$response:=New object:C1471(\
					"upgraded"; $b)
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="checkRest")
			
			EXECUTE METHOD:C1007(Formula:C1597(env_Database_setting).source; $response; "rest")
			
			//______________________________________________________
		: ($entryPoint="checkInstall")
			
			// Check without message
			EXECUTE METHOD:C1007(Formula:C1597(Xcode_CheckInstall).source; $response; New object:C1471("silent"; True:C214))
			
			//________________________________________
		: (Not:C34(Count parameters:C259=2))
			
			// ALL SUBSEQUENT ENTRY POINTS REQUIRE AT LEAST 2 PARAMETERS
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "Missing object parameter")
			
			//______________________________________________________
		: ($entryPoint="downloadSDK")
			
			$t:=String:C10($parameters.target)
			
			Case of 
					
					//______________________________________________________
				: ($t="android")
					
					$o:=cs:C1710.path.new().cacheSdkAndroidUnzipped()
					
					//______________________________________________________
				: ($t="ios")
					
					$o:=cs:C1710.path.new().cacheSdkAppleUnzipped()
					
					//______________________________________________________
				Else 
					
					$response:=New object:C1471(\
						"success"; False:C215; \
						"error"; "Uknown SDK target: "+$t)
					
					//______________________________________________________
			End case 
			
			If ($response=Null:C1517)  // No error
				
				$run:=True:C214
				
				If (Is macOS:C1572)
					
					$file:=Folder:C1567(fk desktop folder:K87:19).parent.file("Library/Caches/testSDK"+Application version:C493+$t)
					
				Else 
					
					$file:=Folder:C1567(fk desktop folder:K87:19).parent.file("AppData/Local/testSDK"+Application version:C493+$t)
					
				End if 
				
				If ($file.exists)
					
					$run:=($file.modificationDate<Current date:C33)
					
				End if 
				
				If ($run)
					
					$o.parent.delete(Delete with contents:K24:24)
					
					EXECUTE METHOD:C1007(Formula:C1597(downloadSDK).source; *; "aws"; $t; True:C214)
					
					If ($o.exists)
						
						$file.setText(Generate UUID:C1066)
						
						$response:=New object:C1471(\
							"success"; True:C214)
						
					Else 
						
						$response:=New object:C1471(\
							"success"; False:C215)
						
					End if 
					
				Else 
					
					// Already done this day
					$response:=New object:C1471(\
						"skipped"; True:C214; \
						"success"; True:C214)
					
				End if 
			End if 
			
			//______________________________________________________
		: ($entryPoint="structure")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_structure).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="templates")
			
			$response:=TemplateInstanceFactory($parameters).run()
			
			//______________________________________________________
		: ($entryPoint="device")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_device).source; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="rest")
			
			EXECUTE METHOD:C1007(Formula:C1597(Rest).source; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="rest")
			
			EXECUTE METHOD:C1007(Formula:C1597(dump).source; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="pathname")
			
			If (Asserted:C1132($parameters.target#Null:C1517; "Expected 'target' key into object parameter"))
				
				$path:=cs:C1710.path.new()
				
				If (Asserted:C1132($path[$parameters.target]#Null:C1517; "No function for path "+String:C10($parameters.target)))
					
					$response:=New object:C1471(\
						"success"; True:C214; \
						"value"; $path[$parameters.target]().platformPath)
					
				End if 
				
			End if 
			//______________________________________________________
		: ($entryPoint="featuresFlags")
			
			// see if a feature is activated and exist
			$response:=New object:C1471(\
				"value"; Feature["_"+String:C10($parameters.value)])
			
			$response.success:=($response.value#Null:C1517)
			
			//________________________________________
		: (Not:C34(Is macOS:C1572))
			
			// ALL SUBSEQUENT ENTRY POINTS ARE ONLY AVAILABLE ON macOS
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "Command unavailable for this Windows platform")
			
			//________________________________________
		: (Feature.with("xcDataModelClass") & \
			(($entryPoint="dataModel")\
			 | ($entryPoint="xcDataModel")))
			
			$response:=cs:C1710.xcDataModel.new($parameters).run(\
				$parameters.path; \
				$parameters)
			
			//________________________________________
		: ($entryPoint="dataModel")
			
			EXECUTE METHOD:C1007(Formula:C1597(dataModel).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="xcDataModel")
			
			EXECUTE METHOD:C1007(Formula:C1597(xcDataModel).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="simulator")
			
			ASSERT:C1129(False:C215; "Deprecated endpoint")
			
			//________________________________________
		: ($entryPoint="xcode")
			
			EXECUTE METHOD:C1007(Formula:C1597(Xcode).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="xcodeProj")
			
			EXECUTE METHOD:C1007(Formula:C1597(XcodeProj).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="plist")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_plist).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="asset")
			
			EXECUTE METHOD:C1007(Formula:C1597(asset).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="colors")
			
			EXECUTE METHOD:C1007(Formula:C1597(colors).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="provisioningProfiles")
			
			EXECUTE METHOD:C1007(Formula:C1597(provisioningProfiles).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="dataSet")
			
			EXECUTE METHOD:C1007(Formula:C1597(dataSet).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="dataModel")
			
			EXECUTE METHOD:C1007(Formula:C1597(dataModel).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="xcDataModel")
			
			EXECUTE METHOD:C1007(Formula:C1597(xcDataModel).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="storyboard")
			
			//EXECUTE METHOD(Formula(_o_storyboard).source; $response; $parameters)
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "OBSOLETE CALL SINCE 18R6")
			
			//________________________________________
		: ($entryPoint="TEMPLATE")
			
			EXECUTE METHOD:C1007(Formula:C1597(template).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="sdk")
			
			EXECUTE METHOD:C1007(Formula:C1597(sdk).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="git")
			
			EXECUTE METHOD:C1007(Formula:C1597(git).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="itunes_lookup")
			
			EXECUTE METHOD:C1007(Formula:C1597(itunes_lookup).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="xloc")
			
			EXECUTE METHOD:C1007(Formula:C1597(xloc).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="formatters")
			
			EXECUTE METHOD:C1007(Formula:C1597(formatters).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="PROJECT_HANDLER")
			
			EXECUTE METHOD:C1007(Formula:C1597(PROJECT_Handler).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="project_Audit")
			
			EXECUTE METHOD:C1007(Formula:C1597(project_Audit).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="device")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_device).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="teamId")
			
			EXECUTE METHOD:C1007(Formula:C1597(teamId).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="swiftPM")
			
			EXECUTE METHOD:C1007(Formula:C1597(swiftPM).source; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="certificate")
			
			EXECUTE METHOD:C1007(Formula:C1597(certificate).source; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="project")
			
			EXECUTE METHOD:C1007(Formula:C1597(mobile_Project).source; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="_internalWebser")
			
			$response:=WEB Server:C1674().start($parameters)
			
			//______________________________________________________
		: ($entryPoint="Process_tags")
			
			If (Asserted:C1132($parameters.text#Null:C1517; "Expected 'text' key into object parameter"))
				
				Case of 
						
						//……………………………………………………………………………………………………………………………
					: ($parameters.tags#Null:C1517)\
						 & ($parameters.types#Null:C1517)
						
						EXECUTE METHOD:C1007(Formula:C1597(Process_tags).source; $t; $parameters.text; $parameters.tags; $parameters.types)
						
						//……………………………………………………………………………………………………………………………
					: ($parameters.tags#Null:C1517)
						
						EXECUTE METHOD:C1007(Formula:C1597(Process_tags).source; $t; $parameters.text; $parameters.tags)
						
						//……………………………………………………………………………………………………………………………
					Else 
						
						EXECUTE METHOD:C1007(Formula:C1597(Process_tags).source; $t; $parameters.text)
						
						//……………………………………………………………………………………………………………………………
				End case 
				
				$response:=New object:C1471(\
					"success"; True:C214; \
					"value"; $t)
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="Process_tags_on_file")
			
			If (Asserted:C1132($parameters.text#Null:C1517; "Expected 'text' key into object parameter"))
				
				Case of 
						
						//……………………………………………………………………………………………………………………………
					: (Not:C34(Asserted:C1132($parameters.file#Null:C1517; "Expected 'file' key into object parameter")))
						
						//……………………………………………………………………………………………………………………………
					: (Not:C34(Asserted:C1132($parameters.tags#Null:C1517; "Expected 'tags' key into object parameter")))
						
						//……………………………………………………………………………………………………………………………
					: (Not:C34(Asserted:C1132($parameters.types#Null:C1517; "Expected 'types' key into object parameter")))
						
						//……………………………………………………………………………………………………………………………
					Else 
						
						EXECUTE METHOD:C1007(Formula:C1597(Process_tags_on_file).source; *; $parameters.file; $parameters.tags; $parameters.types)
						
						//…………………………………………………………………………………………………………………………
				End case 
			End if 
			
			//______________________________________________________
		Else 
			
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "Unknown entry point: \""+$entryPoint+"\"")
			
			//______________________________________________________
	End case 
	
Else 
	
	$response:=New object:C1471(\
		"success"; False:C215; \
		"error"; "Missing entry point parameter")
	
End if 