// ----------------------------------------------------
// Object method : RIBBON.152 (Product button)
// ID[184E0B1B3EEB4632986423D2310524F0]
// Created 19-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $path; $t; $UDID : Text
var $isBooted; $isDebug; $success; $withMoreItems : Boolean
var $bottom; $left; $right; $top : Integer
var $could; $e; $menu; $menuApp; $o; $project; $result; $simulator : Object
var $build; $product : 4D:C1709.Folder
var $Xcode : cs:C1710.Xcode

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		$withMoreItems:=Macintosh option down:C545
		$isDebug:=Macintosh command down:C546 & DATABASE.isMatrix
		
		// Autosave
		PROJECT.save()
		
		$product:=path.products().folder(PROJECT.product.name)
		$build:=$product.folder("build")
		
		$could:=New object:C1471(\
			"openProductFolder"; ($product.exists & (Length:C16(PROJECT.product.name)#0)))
		
		$could.openWithXcode:=$could.openProductFolder & Bool:C1537(PROJECT.$project.xCode.XcodeAvailable)
		
		If ($could.openWithXcode)
			
			$could.openWithXcode:=Xcode(New object:C1471(\
				"action"; "couldOpen"; \
				"path"; $product.platformPath)).success
			
		End if 
		
		$menu:=cs:C1710.menu.new()
		
		If (editor_Locked)
			
			$menu.append("syncDataModel"; "syncDataModel").line()
			
		End if 
		
		// Project folder
		$menu.append("mnuProjectFolder"; "project").line()
		
		// Product folder, disabled if the product folder doesn't exist
		$menu.append("mnuProductFolder"; "product").enable($could.openProductFolder)
		
		// Open project, disabled if Xcode isn't installed
		$menu.append("mnuOpenTheProjectWithXcode"; "xCode").enable($could.openWithXcode)
		
		// =================== DEVELOPMENT ITEMS ===================== [
		If ($withMoreItems)
			
			If (Num:C11(PROJECT.$project.xCode.platform)=Mac OS:K25:2)
				
				$menu.line()
				
				$menu.append("openSimulatorLogs"; "_openLogs")\
					.append("openSimulatorDiagnosticReports"; "_openDiagnosticReports")
				
				$UDID:=String:C10(simulator(New object:C1471(\
					"action"; "default")).udid)
				
				If (Length:C16($UDID)#0)
					
					$menu.append("openCurrentSimulatorFolder"; "_openSimuPath")
					
					If ($isDebug)
						
						$menu.append(".Close simulators"; "_killSimulators")\
							.append(".Erase Current Simulator"; "_eraseCurrentSimulator")
						
					End if 
					
					$simulator:=simulator(\
						New object:C1471("action"; "deviceApp"; \
						"device"; $UDID; \
						"data"; True:C214))
					
					If ($simulator.success)
						
						$menuApp:=cs:C1710.menu.new()
						
						For each ($o; $simulator.apps)
							
							If (String:C10($o.metaData.path)#"")
								
								$t:=String:C10($o.CFBundleExecutable)
								
								If (Length:C16(String:C10($o.AppIdentifierPrefix))>0)
									
									$t:=$t+" - "+String:C10($o.AppIdentifierPrefix)
									
								End if 
								
								$menuApp.append($t; "_app"+JSON Stringify:C1217($o))
								
								//If (DATABASE.isMatrix) & False
								//// provoque une erreur si mobile est un alias
								//// XXX Could not do that in real app, resource folder must not be modified
								//// ASK for SET MENU ITEM ICON with absolute path
								//$t:="mobile"+Folder separator+"cache"+Folder separator+"icon"+Folder separator
								//If (Length(String($o.AppIdentifierPrefix))>0)
								//$t:=$t+$o.AppIdentifierPrefix+Folder separator
								//End if
								//$t:=$t+$o.CFBundleIdentifier+".png"
								//$path:=Get 4D folder(Current resources folder; *)+$t  // Copy into resource folder, because menu item allow only iconRef from here
								//CREATE FOLDER($path; *)
								//$path:=$o.appPath+Folder separator+$o.CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles[0]+"@2x.png"
								//If (Test path name($path)=Is a document)
								//READ PICTURE FILE($path; $p)
								//If (OK=1)
								//CREATE THUMBNAIL($p; $p; 48; 48; Scaled to fit)
								//If (OK=1)
								//WRITE PICTURE FILE(Get 4D folder(Current resources folder; *)+$t; $p; ".png")
								//$menuApp.icon("File:"+Convert path system to POSIX($t))
								//End if
								//End if
								//End if
								//End if
								
							End if 
						End for each 
						
						$menu.append("openApplicationSimulatorFolder"; $menuApp)\
							.line()
						
					End if 
				End if 
				
				If ($isDebug)
					
					$menu.append(".Clear Xcode Build And Derived Data"; "_removeDerivedData")
					
				Else 
					
					$menu.append("clearXcodeBuild"; "_removeBuild").enable($build.exists)
					
				End if 
				
				$menu.line()
				$menu.append("openTheCacheFolder"; "_openCache")
				
				If ($isDebug)
					
					$menu.append(". Open the SDK Cache Folder"; "_openSDKCache")
					
					$menu.append(".🗑 Clear Cache folder"; "_clearCache")
					
					If (Not:C34(Is compiled mode:C492))
						
						$menu.append(".💣 Remove SDK"; "_removeSDK")\
							.line()\
							.append(".💣 Clear Mobiles projects"; "_removeMobilesProjects")\
							.line()\
							.append(".⚙️ Show config file "; "_showConfigFile")\
							.append(".Add sources to Xcode Project"; "_addSources")\
							.line()
						
						$menu.append(".Reveal 4D template folder"; "_openTemplateFolder")\
							.append(".🚧 Reveal custom form folder"; "_openHostFormFolder")\
							.append(".🍪 Generate data model"; "_generateDataModel")
						
					End if 
					
					$menu.line()
					$menu.append(".Open Component Log"; "_openCompoentLog")
					
				End if 
			End if 
			
			$menu.line()
			$menu.append("verbose"; "_verbose").mark(PROJECT.$project.verbose)
			
		End if 
		
		OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
		$menu.popup($left; $bottom)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($menu.selected))
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($menu.choice="product")
				
				SHOW ON DISK:C922($product.platformPath; *)
				
				//______________________________________________________
			: ($menu.choice="project")
				
				SHOW ON DISK:C922(PROJECT.$project.file.parent.platformPath; *)
				
				//______________________________________________________
			: ($menu.choice="xCode")
				
				$Xcode:=cs:C1710.Xcode.new()
				$Xcode.open($product)
				
				If ($Xcode.success)
					
					// Open a file of project in xcode
					If (String:C10(SHARED.xCode.fileFocus)#"")
						
						IDLE:C311
						DELAY PROCESS:C323(Current process:C322; 60*3)  // Wait xcode open
						
						$Xcode.reveal($product.platformPath+Convert path POSIX to system:C1107(SHARED.xCode.fileFocus))
						
					End if 
					
				Else 
					
					// XXX maybe alert...or make action unavailable...
					// SHOW ON DISK($Dir_product)
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="syncDataModel")
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; "updateTheProject"; \
					"additional"; "aBackupWillBeCreatedIntoTheProjectFolder"; \
					"ok"; "update"; \
					"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "syncDataModel"))))
				
				//______________________________________________________
			: ($menu.choice="_installCertificats")
				
				$t:=HTTP Get certificates folder:C1307
				CREATE FOLDER:C475($t; *)
				COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"cert.pem"; $t+"cert.pem"; *)
				COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"key.pem"; $t+"key.pem"; *)
				
				// Verify the web server configuration
				CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "checkingServerConfiguration")
				
				//______________________________________________________
			: ($menu.choice="_openDiagnosticReports")
				
				SHOW ON DISK:C922(ENV.logs("DiagnosticReports").platformPath)
				
				//______________________________________________________
			: ($menu.choice="_openLogs")
				
				$o:=ENV.logs("CoreSimulator/")
				
				$simulator:=simulator(New object:C1471(\
					"action"; "default"))
				
				If (String:C10($simulator.udid)#"")
					
					$o:=$o.folder($simulator.udid)
					
				End if 
				
				If ($o.exists)
					
					SHOW ON DISK:C922($o.platformPath)
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="_openSimuPath")
				
				$simulator:=simulator(New object:C1471(\
					"action"; "default"))
				
				If (String:C10($simulator.udid)#"")
					
					$result:=simulator(New object:C1471(\
						"action"; "devicePath"; \
						"device"; $simulator.udid))
					
					If (String:C10($result.path)#"")
						
						SHOW ON DISK:C922($result.path)
						
					End if 
				End if 
				
				//______________________________________________________
			: ($menu.choice="_killSimulators")
				
				$result:=simulator(New object:C1471(\
					"action"; "kill"))
				
				//______________________________________________________
			: ($menu.choice="_eraseCurrentSimulator")
				
				$simulator:=simulator(New object:C1471(\
					"action"; "default"))
				
				If (String:C10($simulator.udid)#"")
					
					$result:=simulator(New object:C1471(\
						"action"; "isBooted"; \
						"device"; $simulator.udid))
					
					$isBooted:=Bool:C1537($result.booted)
					
					If ($isBooted)
						
						If (simulator(New object:C1471(\
							"action"; "kill")).success)
							
							Repeat 
								
								$result:=simulator(New object:C1471(\
									"action"; "device"; \
									"udid"; $simulator.udid))
								
								$success:=$result.success
								
								If ($success)
									
									$success:=(String:C10($result.device.state)#"Shutdown")
									
								End if 
								
								IDLE:C311
								
							Until (Not:C34($success))
						End if 
					End if 
					
					$result:=simulator(New object:C1471(\
						"action"; "erase"; \
						"device"; $simulator.udid))
					
					If ($isBooted)  // relaunch
						
						$result:=simulator(New object:C1471(\
							"action"; "open"; \
							"device"; $simulator.udid))
						
					End if 
				End if 
				
				//______________________________________________________
			: ($menu.choice="_openCache")
				
				SHOW ON DISK:C922(ENV.caches().platformPath)
				
				//______________________________________________________
			: ($menu.choice="_openSDKCache")
				
				SHOW ON DISK:C922(sdk(New object:C1471("action"; "cacheFolder")).platformPath)
				
				//______________________________________________________
			: ($menu.choice="_clearCache")
				
				ENV.caches().delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeSDK")
				
				path.sdk().delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeMobilesProjects")
				
				path.projects().delete(fk recursive:K87:7)
				path.products().delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeBuild")
				
				$build.delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeDerivedData")
				
				ENV.derivedData().delete(fk recursive:K87:7)
				$build.delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_showConfigFile")
				
				SHOW ON DISK:C922(Get 4D folder:C485(Active 4D Folder:K5:10)+"4d.mobile")
				
				//______________________________________________________
			: ($menu.choice="_openCompoentLog")
				
				RECORD.open()
				
				//______________________________________________________
			: ($menu.choice="_generateDataModel")
				
				$project:=New object:C1471
				$project.product:=PROJECT.product
				$project.dataModel:=PROJECT.dataModel
				
				$path:=Temporary folder:C486+Folder separator:K24:12+"Structures.xcdatamodeld"
				
				dataModel(New object:C1471(\
					"action"; "xcdatamodel"; \
					"dataModel"; PROJECT.dataModel; \
					"flat"; False:C215; \
					"relationship"; True:C214; \
					"dataSet"; dataSet(New object:C1471("action"; "readCatalog"; "project"; $project)).catalog; \
					"path"; $path))
				
				SHOW ON DISK:C922($path)
				
				//______________________________________________________
			: ($menu.choice="_addSources")
				
				Xcode(New object:C1471(\
					"action"; "workspace-addsources"; \
					"path"; $product.platformPath))
				
				//______________________________________________________
			: ($menu.choice="_openTemplateFolder")
				
				SHOW ON DISK:C922(path.templates().platformPath)
				
				//______________________________________________________
			: ($menu.choice="_openHostFormFolder")
				
				$o:=path.hostlistForms(True:C214)
				$o:=path.hostdetailForms(True:C214)
				SHOW ON DISK:C922(path.hostForms().platformPath)
				
				//______________________________________________________
			: ($menu.choice="_verbose")
				
				PROJECT.$project.verbose:=Not:C34(Bool:C1537(PROJECT.$project.verbose))
				
				//______________________________________________________
			: (Position:C15("_app{"; $menu.choice)=1)
				
				SHOW ON DISK:C922(JSON Parse:C1218(Substring:C12($menu.choice; Length:C16("_app")+1)).metaData.path)
				
				//______________________________________________________
			Else 
				
				If (Length:C16($menu.choice)#0)
					
					ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
					
				End if 
				
				//______________________________________________________
		End case 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 