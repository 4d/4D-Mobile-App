//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
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
	C_OBJECT:C1216(mobileUnit; $0)
	C_TEXT:C284(mobileUnit; $1)
	C_OBJECT:C1216(mobileUnit; $2)
End if 

var $t : Text
var $b : Boolean
var $o : Object

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
			
			CALL WORKER:C1389(1; "unitTestSuites"; $o)
			
			If ($o.wait(10))
				
				For each ($t; $o.result)
					
					$response.tests.push(Formula from string:C1601($t))
					
				End for each 
				
				$response.success:=($response.tests.length>0)
				
			Else 
				
				ASSERT:C1129(False:C215; "Failed to load internal test methods")
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="featuresFlags")
			
			$response:=New object:C1471(\
				"features"; Formula:C1597(FEATURE))
			
			//______________________________________________________
		: ($entryPoint="loadProject")
			
			If (Asserted:C1132($parameters.project#Null:C1517; "Expected 'project' key into object parameter"))
				
				EXECUTE METHOD:C1007("project_Upgrade"; $b; $parameters.project)
				
				$response:=New object:C1471(\
					"upgraded"; $b)
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="checkRest")
			
			EXECUTE METHOD:C1007("env_Database_setting"; $response; "rest")
			
			//______________________________________________________
		: ($entryPoint="checkInstall")
			
			// Check without message
			EXECUTE METHOD:C1007("Xcode_CheckInstall"; $response; New object:C1471("silent"; True:C214))
			
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
				
				var $file : 4D:C1709.File
				var $run : Boolean
				
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
					
					EXECUTE METHOD:C1007($entryPoint; *; "aws"; $t; True:C214)
					
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
			
			EXECUTE METHOD:C1007("_o_structure"; $response; $parameters)
			
			//________________________________________
		: ($entryPoint="templates")
			
			$response:=TemplateInstanceFactory($parameters).run()
			
			//______________________________________________________
		: ($entryPoint="storyboard")
			
			// if feature.with("templateClass") must not be tested anymore
			EXECUTE METHOD:C1007("_o_storyboard"; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="rest")\
			 | ($entryPoint="dump")
			
			EXECUTE METHOD:C1007($entryPoint; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="pathname")
			
			If (Asserted:C1132($parameters.target#Null:C1517; "Expected 'target' key into object parameter"))
				
				$response:=New object:C1471(\
					"success"; True:C214; \
					"value"; COMPONENT_Pathname($parameters.target).platformPath)
				
			End if 
			
			//______________________________________________________
		: ($entryPoint="featuresFlags")
			
			// see if a feature is activated and exist
			$response:=New object:C1471(\
				"value"; FEATURE["_"+String:C10($parameters.value)])
			
			$response.success:=($response.value#Null:C1517)
			
			//________________________________________
		: (Not:C34(Is macOS:C1572))
			
			// ALL SUBSEQUENT ENTRY POINTS ARE ONLY AVAILABLE ON macOS
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "Command unavailable for this Windows platform")
			
			//________________________________________
		: ($entryPoint="xcode")\
			 | ($entryPoint="xcodeProj")\
			 | ($entryPoint="plist")\
			 | ($entryPoint="asset")\
			 | ($entryPoint="colors")\
			 | ($entryPoint="provisioningProfiles")\
			 | ($entryPoint="simulator")\
			 | ($entryPoint="dataSet")\
			 | ($entryPoint="dataModel")\
			 | ($entryPoint="storyboard")\
			 | ($entryPoint="TEMPLATE")\
			 | ($entryPoint="sdk")\
			 | ($entryPoint="git")\
			 | ($entryPoint="itunes_lookup")\
			 | ($entryPoint="xloc")\
			 | ($entryPoint="formatters")\
			 | ($entryPoint="PROJECT_HANDLER")\
			 | ($entryPoint="project_Audit")\
			 | ($entryPoint="device")\
			 | ($entryPoint="checkQueryFilter")\
			 | ($entryPoint="teamId")\
			 | ($entryPoint="swiftPM")\
			 | ($entryPoint="certificate")
			
			If ($entryPoint="simulator")
				
				$entryPoint:="_o_simulator"
				
			End if 
			
			If ($entryPoint="plist")
				
				$entryPoint:="_o_plist"
				
			End if 
			
			EXECUTE METHOD:C1007($entryPoint; $response; $parameters)
			
			//______________________________________________________
		: ($entryPoint="project")
			
			EXECUTE METHOD:C1007("mobile_Project"; $response; $parameters)
			
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
						
						EXECUTE METHOD:C1007("Process_tags"; $t; $parameters.text; $parameters.tags; $parameters.types)
						
						//……………………………………………………………………………………………………………………………
					: ($parameters.tags#Null:C1517)
						
						EXECUTE METHOD:C1007("Process_tags"; $t; $parameters.text; $parameters.tags)
						
						//……………………………………………………………………………………………………………………………
					Else 
						
						EXECUTE METHOD:C1007("Process_tags"; $t; $parameters.text)
						
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
						
						EXECUTE METHOD:C1007("Process_tags_on_file"; *; $parameters.file; $parameters.tags; $parameters.types)
						
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