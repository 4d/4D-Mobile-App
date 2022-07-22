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
			
			//MARK:-[ACTIONS]
		: ($entryPoint="actions")
			
			If ($parameters.project=Null:C1517)\
				 || (Not:C34(OB Instance of:C1731($parameters.project; 4D:C1709.File)))
				
				return New object:C1471(\
					"success"; False:C215; \
					"error"; "Missing project file or bad type")
				
			End if 
			
			If ($parameters.test=Null:C1517)\
				 || (Value type:C1509($parameters.test)#Is text:K8:3)
				
				return New object:C1471(\
					"success"; False:C215; \
					"error"; "Missing test key or bad type")
				
			End if 
			
			var $project : cs:C1710.project
			$project:=cs:C1710.project.new().load($parameters.project)
			
			Case of 
					
					//______________________________________________________
				: ($parameters.test="new")
					
					// Create a new default action
					$project.actionNew($parameters.table)
					
					//______________________________________________________
				: ($parameters.test="add")
					
					If ($parameters.action#Null:C1517)
						
						// Add the specified action
						If (Value type:C1509($parameters.action)#Is object:K8:27)
							
							return New object:C1471(\
								"success"; False:C215; \
								"error"; "action must be an object")
							
						End if 
						
						$project.addAction($parameters.action)
						
					Else 
						
						// Create an "add" default action
						$project.actionAdd($parameters.table)
						
					End if 
					
					//______________________________________________________
				: ($parameters.test="edit")
					
					// Create an "edit" default action
					$project.actionEdit($parameters.table)
					
					//______________________________________________________
				: ($parameters.test="delete")
					
					// Create a "delete" default action
					$project.actionDelete($parameters.table)
					
					//______________________________________________________
				: ($parameters.test="sort")
					
					// Create a "sort" default action
					If ($parameters.field=Null:C1517)
						
						return New object:C1471(\
							"success"; False:C215; \
							"error"; "Missing field identifier")
						
					End if 
					
					$project.actionSort($parameters.table; $parameters.field)
					
					//______________________________________________________
				: ($parameters.test="share")
					
					// Create a "share" default action
					$project.actionShare($parameters.table)
					
					//______________________________________________________
				: ($parameters.test="url")
					
					// Create a "openURL" default action
					$project.actionURL($parameters.table)
					
					//______________________________________________________
				Else 
					
					return New object:C1471(\
						"success"; False:C215; \
						"error"; "Unknown entry point \""+String:C10($parameters.test)+"\"")
					
					//______________________________________________________
			End case 
			
			If (Not:C34($project.$success))
				
				return New object:C1471(\
					"success"; False:C215; \
					"error"; $project.$lastError; \
					"errors"; $project.$errors; \
					"project"; $project.cleaned())
				
			Else 
				
				return New object:C1471(\
					"success"; True:C214; \
					"project"; $project.cleaned())
				
			End if 
			
			//MARK:- uninstallAndroidStudio
		: ($entryPoint="uninstallAndroidStudio")
			
			cs:C1710.studio.new().uninstall()
			
			//MARK:- testSuites
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
			
			//MARK:- featuresFlags
		: ($entryPoint="featuresFlags")
			
			$response:=New object:C1471(\
				"features"; Formula:C1597(Feature))
			
			//MARK:- loadProject
		: ($entryPoint="loadProject")
			
			If (Asserted:C1132($parameters.project#Null:C1517; "Expected 'project' key into object parameter"))
				
				EXECUTE METHOD:C1007(Formula:C1597(project_Upgrade).source; $b; $parameters.project)
				
				$response:=New object:C1471(\
					"upgraded"; $b)
				
			End if 
			
			//MARK:- checkRest
		: ($entryPoint="checkRest")
			
			EXECUTE METHOD:C1007(Formula:C1597(databaseSettings).source; $response; "rest")
			
			//MARK:- checkInstall
		: ($entryPoint="checkInstall")
			
			// Check without message
			EXECUTE METHOD:C1007(Formula:C1597(Xcode_CheckInstall).source; $response; New object:C1471("silent"; True:C214))
			
			//MARK:- error: Missing object parameter
		: (Not:C34(Count parameters:C259=2))
			
			// ALL SUBSEQUENT ENTRY POINTS REQUIRE AT LEAST 2 PARAMETERS
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "Missing object parameter")
			
			//MARK:- downloadSDK
		: ($entryPoint="downloadSDK")
			
			$t:=String:C10($parameters.target)
			
			Case of 
					
					//MARK: android
				: ($t="android")
					
					$o:=cs:C1710.path.new().cacheSdkAndroidUnzipped()
					
					//MARK: ios
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
			
			//MARK:- structure
		: ($entryPoint="structure")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_structure).source; $response; $parameters)
			
			//MARK:- templates
		: ($entryPoint="templates")
			
			$response:=TemplateInstanceFactory($parameters).run()
			
			//MARK:- device
		: ($entryPoint="device")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_device).source; $response; $parameters)
			
			//MARK:- rest
		: ($entryPoint="rest")
			
			EXECUTE METHOD:C1007(Formula:C1597(Rest).source; $response; $parameters)
			
			//MARK:- dump
		: ($entryPoint="dump")
			
			EXECUTE METHOD:C1007(Formula:C1597(dump).source; $response; $parameters)
			
			//MARK:- pathname
		: ($entryPoint="pathname")
			
			If (Asserted:C1132($parameters.target#Null:C1517; "Expected 'target' key into object parameter"))
				
				$path:=cs:C1710.path.new()
				
				If (Asserted:C1132($path[$parameters.target]#Null:C1517; "No function for path "+String:C10($parameters.target)))
					
					$response:=New object:C1471(\
						"success"; True:C214; \
						"value"; $path[$parameters.target]().platformPath)
					
				End if 
				
			End if 
			
			//MARK:- featuresFlags
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
			
			//MARK:- xcDataModel
		: ($entryPoint="dataModel")\
			 | ($entryPoint="xcDataModel")
			
			$response:=cs:C1710.xcDataModel.new($parameters).run(\
				$parameters.path; \
				$parameters)
			
			//________________________________________
		: ($entryPoint="simulator")
			
			ASSERT:C1129(False:C215; "Deprecated endpoint")
			
			//MARK:- xcode
		: ($entryPoint="xcode")
			
			EXECUTE METHOD:C1007(Formula:C1597(Xcode).source; $response; $parameters)
			
			//MARK:- xcodeProj
		: ($entryPoint="xcodeProj")
			
			EXECUTE METHOD:C1007(Formula:C1597(XcodeProj).source; $response; $parameters)
			
			//MARK:- plist
		: ($entryPoint="plist")
			
			EXECUTE METHOD:C1007(Formula:C1597(_o_plist).source; $response; $parameters)
			
			//MARK:- asset
		: ($entryPoint="asset")
			
			EXECUTE METHOD:C1007(Formula:C1597(asset).source; $response; $parameters)
			
			//MARK:- colors
		: ($entryPoint="colors")
			
			EXECUTE METHOD:C1007(Formula:C1597(colors).source; $response; $parameters)
			
			//MARK:- provisioningProfiles
		: ($entryPoint="provisioningProfiles")
			
			EXECUTE METHOD:C1007(Formula:C1597(provisioningProfiles).source; $response; $parameters)
			
			//MARK:- dataSet
		: ($entryPoint="dataSet")
			
			EXECUTE METHOD:C1007(Formula:C1597(dataSet).source; $response; $parameters)
			
			//MARK:- storyboard
		: ($entryPoint="storyboard")
			
			//EXECUTE METHOD(Formula(_o_storyboard).source; $response; $parameters)
			$response:=New object:C1471(\
				"success"; False:C215; \
				"error"; "OBSOLETE CALL SINCE 18R6")
			
			//MARK:- TEMPLATE
		: ($entryPoint="TEMPLATE")
			
			EXECUTE METHOD:C1007(Formula:C1597(template).source; $response; $parameters)
			
			//MARK:- sdk
		: ($entryPoint="sdk")
			
			EXECUTE METHOD:C1007(Formula:C1597(sdk).source; $response; $parameters)
			
			//MARK:- git
		: ($entryPoint="git")
			
			EXECUTE METHOD:C1007(Formula:C1597(git).source; $response; $parameters)
			
			//MARK:- itunes_lookup
		: ($entryPoint="itunes_lookup")
			
			EXECUTE METHOD:C1007(Formula:C1597(itunes_lookup).source; $response; $parameters)
			
			//MARK:- xloc
		: ($entryPoint="xloc")
			
			EXECUTE METHOD:C1007(Formula:C1597(xloc).source; $response; $parameters)
			
			//MARK:- formatters
		: ($entryPoint="formatters")
			
			EXECUTE METHOD:C1007(Formula:C1597(formatters).source; $response; $parameters)
			
			//MARK:- PROJECT_HANDLER
		: ($entryPoint="PROJECT_HANDLER")
			
			EXECUTE METHOD:C1007(Formula:C1597(PROJECT_Handler).source; $response; $parameters)
			
			//MARK:- project_Audit
		: ($entryPoint="project_Audit")
			
			EXECUTE METHOD:C1007(Formula:C1597(project_Audit).source; $response; $parameters)
/*
// MARK:- _o_device
: ($entryPoint="project_Audit")
			
EXECUTE METHOD(Formula(_o_device).source; $response; $parameters)
*/
			
			//MARK:- teamId
		: ($entryPoint="teamId")
			
			EXECUTE METHOD:C1007(Formula:C1597(teamId).source; $response; $parameters)
			
			//MARK:- swiftPM
		: ($entryPoint="swiftPM")
			
			EXECUTE METHOD:C1007(Formula:C1597(swiftPM).source; $response; $parameters)
			
			//MARK:- certificate
		: ($entryPoint="certificate")
			
			EXECUTE METHOD:C1007(Formula:C1597(certificate).source; $response; $parameters)
			
			//MARK:- project
		: ($entryPoint="project")
			
			EXECUTE METHOD:C1007(Formula:C1597(mobile_Project).source; $response; $parameters)
			
			//MARK:- _internalWebser
		: ($entryPoint="_internalWebser")
			
			$response:=WEB Server:C1674().start($parameters)
			
			//MARK:- Process_tags
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
			
			//MARK:- Process_tags_on_file
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
			
			//MARK:- Unknown entry point
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