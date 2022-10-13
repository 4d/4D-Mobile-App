Class constructor($project : Object)
	This:C1470.input:=$project
	
	This:C1470.paths:=cs:C1710.path.new()
	This:C1470.logFolder:=This:C1470.paths.userCache()
	
	This:C1470.success:=True:C214
	This:C1470.errors:=New collection:C1472
	This:C1470.lastError:=""
	
	This:C1470.debug:=Not:C34(Is compiled mode:C492)
	
	This:C1470.caller:=This:C1470.input.caller
	This:C1470.withUI:=(This:C1470.caller#Null:C1517)
	This:C1470.verbose:=Bool:C1537(This:C1470.input.verbose) & This:C1470.withUI
	
	// MARK:-[STEPS]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Build and …
Function main()->$result : Object
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; New collection:C1472)
	
	If (Feature.with("buildWithCmd"))
		This:C1470._main($result)
		
		If (This:C1470.withUI)
			
			POST_MESSAGE(New object:C1471(\
				"target"; This:C1470.input.caller; \
				"action"; "hide"))
			
		End if 
		
		return 
	End if 
	
	$result.create:=This:C1470.create()
	ob_error_combine($result; $result.create)
	
	If ($result.create.success)
		
		If (Bool:C1537(This:C1470.input.build))
			
			$result.build:=This:C1470.build()
			ob_error_combine($result; $result.build)
			
			If ($result.build.success)
				
				Case of 
						//______________________________________________________
					: (Bool:C1537(This:C1470.input.run))
						
						$result.run:=This:C1470.run()
						ob_error_combine($result; $result.run)
						
						If ($result.run.success)
							
							$result.success:=True:C214
							This:C1470.notification()
							
						Else 
							
							Logger.error("❌ ERROR OCCURRED WHILE RUNNING PROJECT")
							
						End if 
						
						//______________________________________________________
					: (Bool:C1537(This:C1470.input.archive))
						
						$result.install:=This:C1470.install()
						ob_error_combine($result; $result.install)
						
						If ($result.install.success)
							
							$result.success:=True:C214
							This:C1470.notification()
							
						Else 
							
							Logger.error("❌ ERROR OCCURRED WHILE INSTALLING APP")
							
						End if 
						
						//______________________________________________________
					Else 
						
						// * NO EXECUTION OR INSTALLATION HAS BEEN REQUESTED
						$result.success:=True:C214
						
						//______________________________________________________
				End case 
				
			Else 
				
				Logger.error("❌ ERROR OCCURRED WHILE BUILDING PROJECT")
				
			End if 
			
		Else 
			
			// No build requested
			$result.success:=True:C214
			
		End if 
		
	Else 
		
		Logger.error("❌ ERROR OCCURRED WHILE CREATING PROJECT")
		
	End if 
	
	If (This:C1470.withUI)
		
		POST_MESSAGE(New object:C1471(\
			"target"; This:C1470.input.caller; \
			"action"; "hide"))
		
	End if 
	
Function _main($result : Object)
	If (Bool:C1537(This:C1470.input.create))
		$result.create:=This:C1470.create()
	Else 
		$result.create:=This:C1470.alreadyCreated()
	End if 
	ob_error_combine($result; $result.create)
	
	If (Not:C34($result.create.success))
		Logger.error("❌ ERROR OCCURRED WHILE CREATING PROJECT")
		return 
	End if 
	
	If (Not:C34(Bool:C1537(This:C1470.input.build)))
		$result.success:=True:C214
		return 
	End if 
	
	$result.build:=This:C1470.build()
	ob_error_combine($result; $result.build)
	
	If (Not:C34($result.build.success))
		Logger.error("❌ ERROR OCCURRED WHILE BUILDING PROJECT")
		return 
	End if 
	
	Case of 
			//______________________________________________________
		: (Bool:C1537(This:C1470.input.run))
			
			$result.run:=This:C1470.run()
			ob_error_combine($result; $result.run)
			
			If ($result.run.success)
				
				$result.success:=True:C214
				This:C1470.notification()
				
			Else 
				
				Logger.error("❌ ERROR OCCURRED WHILE RUNNING PROJECT")
				
			End if 
			
			//______________________________________________________
		: (Bool:C1537(This:C1470.input.archive))
			
			$result.install:=This:C1470.install()
			ob_error_combine($result; $result.install)
			
			If ($result.install.success)
				
				$result.success:=True:C214
				This:C1470.notification()
				
			Else 
				
				Logger.error("❌ ERROR OCCURRED WHILE INSTALLING APP")
				
			End if 
			
			//______________________________________________________
		Else 
			
			// * NO EXECUTION OR INSTALLATION HAS BEEN REQUESTED
			$result.success:=True:C214
			
			//______________________________________________________
	End case 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ MUST BE OVERRIDEN
Function create()
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ MUST BE OVERRIDEN
Function alreadyCreated()
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ MUST BE OVERRIDEN
Function build
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ MUST BE OVERRIDEN
Function run()
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ⚠️ MUST BE OVERRIDEN
Function install()
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	// MARK:-[TOOLS]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display a system notification
Function notification()
	
	Logger.info("🏁  End build")
	
	If (This:C1470.withUI)
		
		// Send result
		var $param : Object
		$param:=New object:C1471(\
			"create"; This:C1470.input.create; \
			"build"; This:C1470.input.build; \
			"run"; This:C1470.input.run; \
			"archive"; This:C1470.input.archive; \
			"project"; This:C1470.input.project)
		
		CALL FORM:C1391(This:C1470.input.caller; "editor_CALLBACK"; "build"; New object:C1471(\
			"success"; True:C214; \
			"param"; $param))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// log info
Function logInfo($message : Text)
	
	If (This:C1470.verbose)
		
		LOG_EVENT(New object:C1471(\
			"message"; $message; \
			"importance"; Information message:K38:1))
		
	Else 
		
		// <NOTHING MORE TO DO>
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// log error
Function logError($message : Text)
	
	If (This:C1470.verbose)
		
		LOG_EVENT(New object:C1471(\
			"message"; $message; \
			"importance"; Error message:K38:3))
		
	Else 
		
		// <NOTHING MORE TO DO>
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display a build step message into the editor
Function postStep($message : Text)
	
	If (This:C1470.withUI)
		
		POST_MESSAGE(New object:C1471(\
			"target"; This:C1470.input.caller; \
			"additional"; $message))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Display error message into the editor
Function postError($message : Text)
	
	If (This:C1470.withUI)
		
		POST_MESSAGE(New object:C1471(\
			"type"; "alert"; \
			"target"; This:C1470.input.caller; \
			"additional"; $message))
		
	Else 
		
		This:C1470.lastError:=$message
		This:C1470.errors.push(This:C1470.lastError)
		This:C1470.success:=False:C215
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function fullVersion($wantedVersion : Text)->$fullVersion : Text
	
	var $separator : Text
	var $components; $finalComponents : Collection
	
	$separator:="."
	$components:=Split string:C1554($wantedVersion; $separator)
	$finalComponents:=New collection:C1472()
	
	var $i : Integer
	
	For ($i; 0; 2; 1)
		
		If ($i<$components.length)
			
			$finalComponents.push(Num:C11($components[$i]))  // Only number
			
		Else 
			
			$finalComponents.push(0)  // Padding with 0
			
		End if 
	End for 
	
	$fullVersion:=$finalComponents.join(".")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Transform a collection of errors (text, number, object or collection) into a formatted text
Function postErrors($errors : Collection)
	
	var $error : Variant
	var $c : Collection
	
	$c:=New collection:C1472
	
	For each ($error; $errors)
		
		Case of 
				
				//________________________________________
			: (Value type:C1509($error)=Is text:K8:3)
				
				$c.push($error)
				
				//________________________________________
			: (Value type:C1509($error)=Is object:K8:27)
				
				$c.push(JSON Stringify:C1217($error))  // XXX maybe extract message key, but do we loose info?
				
				//________________________________________
			: (Value type:C1509($error)=Is collection:K8:32)
				
				$c.push(JSON Stringify:C1217($error))
				
				//________________________________________
			Else 
				
				$c.push(String:C10($error))
				
				//________________________________________
		End case 
	End for each 
	
	This:C1470.postError($c.join("\r"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a dump of the data made with the REST API,  and create android db now
Function dataSetLegacy()->$dump : Object  // TODO: to remove with Not(FEATURE.with("androidDataSet"))
	
	var $pathname : Text
	var $project : Object
	
	$project:=This:C1470.input.project  // to check
	
	// Erase if needed (data has changed, or must be generated at each build)
	$dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; True:C214; \
		"androidDataSet"; True:C214; \
		"project"; $project))
	
	If (Bool:C1537($dump.exists))
		
		If (Not:C34($dump.valid) | Not:C34(Bool:C1537($project.dataSource.doNotGenerateDataAtEachBuild)))
			
			$dump:=dataSet(New object:C1471(\
				"action"; "erase"; \
				"project"; $project))
			
		End if 
	End if 
	
	// Recheck to see if dump is here (but we do not check digest)
	$dump:=dataSet(New object:C1471(\
		"action"; "check"; \
		"digest"; False:C215; \
		"project"; $project))
	
	// We will make a dump, but for local dump we need a key
	If (Not:C34(Bool:C1537($dump.exists)))
		
		If (String:C10(This:C1470.input.project.dataSource.source)="server")
			
			// Ping the server to ensure the key is created?
			// or get local file path?
			
		Else 
			
			$pathname:=This:C1470.paths.key().platformPath
			
			If (Not:C34(This:C1470.paths.key().exists))
				
				This:C1470.keyPing:=Rest(New object:C1471(\
					"action"; "status"; \
					"handler"; "mobileapp"))
				
				This:C1470.keyPing.file:=New object:C1471(\
					"path"; $pathname; \
					"exists"; This:C1470.paths.key().exists)
				
				If (Not:C34(This:C1470.keyPing.file.exists))
					
					// TODO manage error
					// ob_error_add($out; "Local server key file do not exists and cannot be created")
					
				End if 
			End if 
		End if 
		
		$dump:=dataSet(New object:C1471(\
			"action"; "create"; \
			"project"; $project; \
			"digest"; True:C214; \
			"dataSet"; True:C214; \
			"key"; $pathname; \
			"androidDataSet"; True:C214; \
			"caller"; This:C1470.input.caller; \
			"verbose"; This:C1470.input.verbose; \
			"keepUI"; True:C214; \
			"method"; "editor_CALLBACK"; \
			"message"; "endOfDatasetGeneration"))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a dump of the data made with the REST API,  and create android db now
Function dataSet()->$dump : Object
	
	var $pathname : Text
	var $project : Object
	
	$project:=This:C1470.input.project  // to check
	
	If (String:C10(This:C1470.input.project.dataSource.source)="server")
		
		// Ping the server to ensure the key is created?
		// or get local file path?
		
	Else 
		
		$pathname:=This:C1470.paths.key().platformPath
		
		If (Not:C34(This:C1470.paths.key().exists))
			
			This:C1470.keyPing:=Rest(New object:C1471(\
				"action"; "status"; \
				"handler"; "mobileapp"))
			
			This:C1470.keyPing.file:=New object:C1471(\
				"path"; $pathname; \
				"exists"; This:C1470.paths.key().exists)
			
			If (Not:C34(This:C1470.keyPing.file.exists))
				
				// TODO manage error
				// ob_error_add($out; "Local server key file do not exists and cannot be created")
				
			End if 
		End if 
	End if 
	
	$dump:=dataSet(New object:C1471(\
		"action"; "create"; \
		"project"; $project; \
		"digest"; True:C214; \
		"dataSet"; True:C214; \
		"key"; $pathname; \
		"androidDataSet"; True:C214; \
		"caller"; This:C1470.input.caller; \
		"verbose"; This:C1470.input.verbose; \
		"keepUI"; True:C214; \
		"method"; "editor_CALLBACK"; \
		"message"; "endOfDatasetGeneration"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Return true if must be generated each time or data set not valid (according to project checksum)
Function mustDoDataSet()->$doIt : Boolean
	$doIt:=Not:C34(Bool:C1537(This:C1470.project.project.dataSource.doNotGenerateDataAtEachBuild))
	
	If (Not:C34($doIt))
		
		var $project; $dump : Object
		$project:=This:C1470.input.project  // to check
		
		// Erase if needed (data has changed, or must be generated at each build)
		$dump:=dataSet(New object:C1471(\
			"action"; "check"; \
			"digest"; True:C214; \
			"androidDataSet"; True:C214; \
			"project"; $project))
		
		If (Bool:C1537($dump.exists))
			
			If (Not:C34($dump.valid))
				
				$dump:=dataSet(New object:C1471(\
					"action"; "erase"; \
					"project"; $project))
				
				$doIt:=True:C214  // not valid dump do it
				
			End if 
			
		Else 
			
			$doIt:=True:C214  // no dump do it
			
		End if 
		
	End if 
	
	// MARK:-[PRIVATES]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _createManifest($project : Object; $noWrite : Boolean) : Object
	
	var $manifest : Object
	
	$manifest:=New object:C1471(\
		"application"; New object:C1471(\
		"id"; $project.product.bundleIdentifier; \
		"name"; $project.product.name); \
		"team"; New object:C1471("id"; $project.organization.teamId); \
		"info"; $project.info)
	
	// • Deep linking
	If (Bool:C1537($project.deepLinking.enabled))
		
		If (Length:C16(String:C10($project.deepLinking.urlScheme))>0)
			
			$manifest.urlScheme:=String:C10($project.deepLinking.urlScheme)
			$manifest.urlScheme:=Replace string:C233($manifest.urlScheme; "://"; "")
			
		End if 
		
		If (Length:C16(String:C10($project.deepLinking.associatedDomain))>0)
			
			$manifest.associatedDomain:=String:C10($project.deepLinking.associatedDomain)
			
		End if 
	End if 
	
	// Write to app data (to use with 4D Mobile App Server)
	If (Not:C34(Bool:C1537($noWrite)))
		This:C1470._getAppDataFolder($project).file("manifest.json").setText(JSON Stringify:C1217($manifest; *))
	End if 
	
	return $manifest
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _getAppDataFolder($project : Object) : 4D:C1709.Folder
	
	var $folder : 4D:C1709.Folder
	$folder:=This:C1470.This.paths.mobileApps().folder(This:C1470._getAppId($project))
	$folder.create()
	
	return $folder
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _getAppId($project : Object) : Text
	
	return String:C10($project.organization.teamId)+"."+String:C10($project.product.bundleIdentifier)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _o_themeImageFile()->$theme : 4D:C1709.File
	
	ASSERT:C1129(False:C215; "👀 Must be overriden")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _o_themeFromImageFile()->$theme : Object
	
	var $mustScal : Boolean
	var $l : Integer
	var $color : Object
	var $file : 4D:C1709.File
	
	$theme:=New object:C1471(\
		"success"; False:C215)
	
	$file:=This:C1470._o_themeFromImageFile()
	
	// To have better result scale image
	$l:=SHARED.theme.colorjuicer.scale
	
	$mustScal:=($l#1024) & ($l>0)
	
	If ($mustScal)
		
		$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066)
		
	End if 
	
	$color:=colors(New object:C1471(\
		"action"; "juicer"; \
		"posix"; $file.path))
	
	If ($color.success)
		
		$theme.BackgroundColor:=$color.value
		$theme.BackgroundColor.name:="BackgroundColor"
		
		$color:=colors(New object:C1471(\
			"action"; "contrast"; \
			"color"; $theme.BackgroundColor))
		
		If ($color.success)
			
			$theme.ForegroundColor:=$color.value
			$theme.ForegroundColor.name:="ForegroundColor"
			
			$theme.success:=True:C214
			
		End if 
	End if 
	
	If ($mustScal)
		
		$file.delete()  // Delete scaled files
		
	End if 
	