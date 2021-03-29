// ----------------------------------------------------
// Object method : RIBBON.152 (Product button)
// ID[184E0B1B3EEB4632986423D2310524F0]
// Created 19-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $pathName; $t : Text
var $bottom; $left; $right; $top : Integer
var $could; $device; $e; $menu; $menuApp; $o; $project : Object
var $folder; $sdkCacheFolder : 4D:C1709.Folder
var $path : cs:C1710.path
var $simctl : cs:C1710.simctl
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
		
		// Autosave
		PROJECT.save()
		
		$path:=cs:C1710.path.new()
		
		$folder:=$path.products().folder(PROJECT.product.name)
		
		$could:=New object:C1471(\
			"isDebug"; DATABASE.isMatrix; \
			"isMain"; (Application version:C493(*)="A@"); \
			"withMoreItems"; Macintosh option down:C545 | Windows Alt down:C563; \
			"productFolder"; $folder; \
			"xCodeAvailable"; Bool:C1537(Form:C1466.editor.$xCode.applicationAvailable); \
			"studioAvailable"; Bool:C1537(Form:C1466.editor.$studio.applicationAvailable); \
			"iOSFolder"; $folder.folder("iOS"); \
			"androidFolder"; $folder.folder("android"); \
			"isLocked"; editor_Locked; \
			"openWithXcode"; False:C215; \
			"openWithStudio"; False:C215)
		
		If ($could.productFolder.exists)
			
			If (Is macOS:C1572)
				
				If ($could.xCodeAvailable)
					
					If ($could.iOSFolder.exists)
						
						$could.openWithXcode:=(($could.iOSFolder.folders().query("extension IN :1"; New collection:C1472(".xcworkspace"; ".xcodeproj"))).length>0)
						
					End if 
				End if 
			End if 
			
			If ($could.studioAvailable)
				
				If ($could.androidFolder.exists)
					
					$could.openWithStudio:=(($could.androidFolder.files().query("fullName :1"; "gradle.properties")).pop()#Null:C1517)
					
				End if 
			End if 
		End if 
		
		$menu:=cs:C1710.menu.new()
		
		If ($could.isLocked)
			
			$menu.append("syncDataModel"; "syncDataModel").line()
			
		End if 
		
		// PROJECT FOLDER
		$menu.append("mnuProjectFolder"; "openProjectFolder")
		
		// PRODUCT FOLDER: disabled if the product folder doesn't exist
		$menu.append("mnuProductFolder"; "openProductFolder").enable($could.productFolder.exists).line()
		
		// OPEN PROJECT WITH…
		If (Is macOS:C1572)
			
			$simctl:=cs:C1710.simctl.new(SHARED.iosDeploymentTarget)
			
			$menu.append("mnuOpenTheProjectWithXcode"; "openWithXcode").enable($could.openWithXcode)
			
			// MORE ITEMS FOR XCODE
			If ($could.withMoreItems)
				
				$menu.line()
				
				If ($could.isDebug)
					
					$menu.append("🗑 Clear Xcode Build And Derived Data"; "_removeDerivedData").enable($could.xCodeAvailable)
					
				Else 
					
					$menu.append("clearXcodeBuild"; "clearXcodeBuild").enable($could.iOSFolder.folder("build").exists).enable($could.xCodeAvailable)
					
				End if 
				
				$menu.append("showCurrentSimulatorFolder"; "_openSimuPath").enable($could.xCodeAvailable)\
					.append("showTheCurrentSimulatorLogsFolder"; "_openLogs").enable($simctl.deviceLog(Form:C1466.currentDevice).exists)\
					.line()
				
				$menu.append("showDiagnosticReportsFolder"; "_openDiagnosticReports")
				
				If ($could.isDebug)
					
					$device:=$simctl.device(Form:C1466.currentDevice)
					
					
					$menu.append("❌ Close simulators"; "_killSimulators")\
						.append("🗑 Erase Current Simulator"; "_eraseCurrentSimulator")
					
					$device:=_o_simulator(\
						New object:C1471("action"; "deviceApp"; \
						"device"; Form:C1466.currentDevice; \
						"data"; True:C214))
					
					If ($device.success)
						
						$menuApp:=cs:C1710.menu.new()
						
						For each ($o; $device.apps)
							
							If (String:C10($o.metaData.path)#"")
								
								$t:=String:C10($o.CFBundleExecutable)
								
								If (Length:C16(String:C10($o.AppIdentifierPrefix))>0)
									
									$t:=$t+" - "+String:C10($o.AppIdentifierPrefix)
									
								End if 
								
								$menuApp.append($t; "_app"+JSON Stringify:C1217($o))
								
							End if 
						End for each 
						
						$menu.append("showApplicationSimulatorFolder"; $menuApp)\
							.line()
						
					End if 
				End if 
			End if 
		End if 
		
		If ($could.studioAvailable)
			
			$menu.append("mnuOpenTheProjectWithAndroidStudio"; "openWithStudio").enable($could.openWithStudio)
			
		End if 
		
		If ($could.withMoreItems)
			
			$menu.line()
			
			If ($could.isMain)
				
				$menu.append(Replace string:C233(Get localized string:C991("downloadTheSDK"); "{os}"; "Android"); "downloadAndroidSdk")
				
				If (Is macOS:C1572)
					
					$menu.append(Replace string:C233(Get localized string:C991("downloadTheSDK"); "{os}"; "iOS"); "downloadIosSdk")
					
				End if 
			End if 
			
		End if 
		
		// =================== DEVELOPMENT ITEMS ===================== [
		If ($could.withMoreItems)
			
			$sdkCacheFolder:=$path.cacheSDK().folder(Application version:C493)
			
			If ($could.isDebug)
				
				//
				
			End if 
			
			$menu.line()
			$menu.append("showTheCacheFolder"; "showTheCacheFolder").enable($path.userCache().exists)
			$menu.append("showTheSdkCacheFolder"; "showTheSdkCacheFolder").enable($sdkCacheFolder.exists)
			
			If (Is macOS:C1572)
				
				If ($could.isDebug)
					
					$menu.line()
					$menu.append("🗑 Clear Cache folder"; "_clearCache")
					
					If (Not:C34(Is compiled mode:C492))
						
						$menu.append("🔑 Install certificates"; "_installCertificats")\
							.line()
						
						$menu.append("💣 Remove SDK"; "_removeSDK")\
							.line()\
							.append("💣 Clear Mobiles projects"; "_removeMobilesProjects")\
							.line()\
							.append("⚙️ Show config file "; "_showConfigFile")\
							.append("➕ Add sources to Xcode Project"; "_addSources")\
							.line()
						
						$menu.append("👀 Show 4D template folder"; "_openTemplateFolder")\
							.append("🚧 Show custom form folder"; "_openHostFormFolder")\
							.append("🍪 Generate data model"; "_generateDataModel")
						
					End if 
				End if 
				
			Else 
				
				//
				
			End if 
			
			$menu.line()\
				.append("openThe4dMobileAppLog"; "openThe4dMobileAppLog")\
				.append("verbose"; "_verbose").mark(PROJECT.$project.verbose)
			
			If ($could.isDebug)
				
				$menu.line()
				$menu.append("❌ Uninstall Android Studio"; "_removeAndoidStudio")
				
			End if 
		End if 
		
		OBJECT GET COORDINATES:C663(*; $e.objectName; $left; $top; $right; $bottom)
		$menu.popup($left; $bottom)
		
		Case of 
				
				//______________________________________________________
			: (Not:C34($menu.selected))
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($menu.choice="openProductFolder")
				
				Case of 
						
						//……………………………………………………………………………
					: (PROJECT._buildTarget="ios")
						
						SHOW ON DISK:C922($could.productFolder.folder("ios").platformPath)
						
						//……………………………………………………………………………
					: (PROJECT._buildTarget="android")
						
						SHOW ON DISK:C922($could.productFolder.folder("android").platformPath)
						
						//……………………………………………………………………………
					Else 
						
						SHOW ON DISK:C922($could.productFolder.platformPath)
						
						//……………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($menu.choice="openProjectFolder")
				
				SHOW ON DISK:C922(PROJECT._folder.platformPath)
				
				//______________________________________________________
			: ($menu.choice="downloadAndroidSdk")\
				 | ($menu.choice="downloadIosSdk")
				
				$t:=Choose:C955($menu.choice="downloadAndroidSdk"; "android"; "ios")
				
				If ((Application version:C493(*)="A@") & Shift down:C543)
					
					CALL WORKER:C1389(Form:C1466.editor.$worker; "downloadSDKFromTeamCity"; $t; False:C215; Form:C1466.editor.$mainWindow)  //; True)
					
				Else 
					
					CALL WORKER:C1389(Form:C1466.editor.$worker; "downloadSDK"; $t; False:C215; Form:C1466.editor.$mainWindow; Shift down:C543)
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="downloadAndroidSdkFromTeamCity")
				
				CALL WORKER:C1389(Form:C1466.editor.$worker; "downloadSDKFromTeamCity"; "android"; False:C215; Form:C1466.editor.$mainWindow; True:C214)
				
				//______________________________________________________
			: ($menu.choice="openWithXcode")  // Open a file of project in xcode
				
				$Xcode:=cs:C1710.Xcode.new()
				$Xcode.open($could.iOSFolder)
				
				If ($Xcode.success)
					
					If (String:C10(SHARED.xCode.fileFocus)#"")
						
						IDLE:C311
						DELAY PROCESS:C323(Current process:C322; 60*3)  // Wait xcode open
						
						$Xcode.reveal($could.iOSFolder.platformPath+Convert path POSIX to system:C1107(SHARED.xCode.fileFocus))
						
					End if 
					
				Else 
					
					// XXX maybe alert...or make action unavailable...
					// SHOW ON DISK($Dir_product)
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="openWithStudio")
				
				cs:C1710.studio.new().open($could.androidFolder)
				
				//______________________________________________________
			: ($menu.choice="showTheCacheFolder")
				
				SHOW ON DISK:C922($path.userCache().platformPath)
				
				//______________________________________________________
			: ($menu.choice="showTheSdkCacheFolder")
				
				SHOW ON DISK:C922($path.cacheSDK().folder(Application version:C493).platformPath)
				
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
			: ($menu.choice="openThe4dMobileAppLog")
				
				RECORD.open()
				
				//______________________________________________________
			: ($menu.choice="clearXcodeBuild")
				
				$could.iOSFolder.folder("build").delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_installCertificats")
				
				$folder:=Folder:C1567(HTTP Get certificates folder:C1307; fk platform path:K87:2)
				$folder.create()
				
				Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("cert.pem").copyTo($folder; fk overwrite:K87:5)
				Folder:C1567(Get 4D folder:C485(-1); fk platform path:K87:2).file("key.pem").copyTo($folder; fk overwrite:K87:5)
				
				// Verify the web server configuration
				CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "checkingServerConfiguration")
				
				//______________________________________________________
			: ($menu.choice="_openDiagnosticReports")
				
				SHOW ON DISK:C922(ENV.logs("DiagnosticReports").platformPath)
				
				//______________________________________________________
			: ($menu.choice="_openLogs")
				
				$simctl.showDeviceLog(Form:C1466.currentDevice)
				
				//______________________________________________________
			: ($menu.choice="_openSimuPath")
				
				$o:=$simctl.deviceFolder(Form:C1466.currentDevice)
				
				If ($o.exists)
					
					SHOW ON DISK:C922($o.platformPath)
					
				End if 
				
				//______________________________________________________
			: ($menu.choice="_killSimulators")
				
				$simctl.shutdownAllDevices()
				
				//______________________________________________________
			: ($menu.choice="_eraseCurrentSimulator")
				
				$simctl.eraseDevice(Form:C1466.currentDevice)
				
				//______________________________________________________
			: ($menu.choice="_clearCache")
				
				$path.cacheSdkAppleUnzipped().delete(fk recursive:K87:7)
				$path.cacheSdkAndroidUnzipped().delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeSDK")
				
				Folder:C1567("/RESOURCES/sdk/").file("ios.zip").delete()
				
				//______________________________________________________
			: ($menu.choice="_removeMobilesProjects")
				
				$path.projects().delete(fk recursive:K87:7)
				$path.products().delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_removeDerivedData")
				
				ENV.derivedData().delete(fk recursive:K87:7)
				$could.iOSFolder.folder("build").delete(fk recursive:K87:7)
				
				//______________________________________________________
			: ($menu.choice="_showConfigFile")
				
				SHOW ON DISK:C922(Get 4D folder:C485(Active 4D Folder:K5:10)+"4d.mobile")
				
				//______________________________________________________
			: ($menu.choice="_generateDataModel")
				
				$project:=New object:C1471
				$project.product:=PROJECT.product
				$project.dataModel:=PROJECT.dataModel
				
				$pathName:=Temporary folder:C486+Folder separator:K24:12+"Structures.xcdatamodeld"
				
				dataModel(New object:C1471(\
					"action"; "xcdatamodel"; \
					"dataModel"; PROJECT.dataModel; \
					"flat"; False:C215; \
					"relationship"; True:C214; \
					"dataSet"; dataSet(New object:C1471("action"; "readCatalog"; "project"; $project)).catalog; \
					"path"; $pathName))
				
				SHOW ON DISK:C922($pathName)
				
				//______________________________________________________
			: ($menu.choice="_addSources")
				
				Xcode(New object:C1471(\
					"action"; "workspace-addsources"; \
					"path"; $could.iOSFolder.platformPath))
				
				//______________________________________________________
			: ($menu.choice="_openTemplateFolder")
				
				SHOW ON DISK:C922(path.templates().platformPath)
				
				//______________________________________________________
			: ($menu.choice="_openHostFormFolder")
				
				SHOW ON DISK:C922($path.hostForms().platformPath)
				
				//______________________________________________________
			: ($menu.choice="_verbose")
				
				PROJECT.$project.verbose:=Not:C34(Bool:C1537(PROJECT.$project.verbose))
				
				//______________________________________________________
			: ($menu.choice="_removeAndoidStudio")
				
				resetAndroidStudio
				ALERT:C41("Android Studio has been removed")
				
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