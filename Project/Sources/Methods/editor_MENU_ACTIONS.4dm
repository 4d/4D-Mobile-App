//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_MENU_ACTIONS
// ID[33355C53F50040DCBCA10F30344DB3E7]
// Created 6-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_; $Boo_booted; $Boo_dev; $Boo_plus)
C_LONGINT:C283($Lon_parameters)
C_PICTURE:C286($Pic_buffer; $Pic_icon)
C_TEXT:C284($Dir_root; $t; $Txt_path; $Txt_UDID)
C_OBJECT:C1216($menu; $menuApp; $o; $Obj_could; $Obj_in; $Obj_project)
C_OBJECT:C1216($Obj_result; $Obj_simulator; $Path_build; $Path_product)

If (False:C215)
	C_OBJECT:C1216(editor_MENU_ACTIONS; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Boo_plus:=Macintosh option down:C545
	$Boo_dev:=Macintosh command down:C546 & DATABASE.isMatrix
	
	// Autosave
	_o_project_SAVE
	
	$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5; "project"))->
	
	$Path_product:=path.products().folder($Obj_project.product.name)
	$Path_build:=$Path_product.folder("build")
	
	$Obj_could:=New object:C1471(\
		"openProductFolder"; ($Path_product.exists & (Length:C16($Obj_project.product.name)#0)))
	
	$Obj_could.openWithXcode:=$Obj_could.openProductFolder & Bool:C1537(Form:C1466.xCode.XcodeAvailable)
	
	If ($Obj_could.openWithXcode)
		
		$Obj_could.openWithXcode:=Xcode(New object:C1471(\
			"action"; "couldOpen"; \
			"path"; $Path_product.platformPath)).success
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$menu:=cs:C1710.menu.new()

If (editor_Locked)
	
	$menu.append("syncDataModel"; "syncDataModel").line()
	
End if 

// Project folder
$menu.append("mnuProjectFolder"; "project").line()

// Product folder, disabled if the product folder doesn't exist
$menu.append("mnuProductFolder"; "product").enable($Obj_could.openProductFolder)

// Open project, disabled if Xcode isn't installed
$menu.append("mnuOpenTheProjectWithXcode"; "xCode").enable($Obj_could.openWithXcode)

// =================== DEVELOPMENT ITEMS ===================== [
If ($Boo_plus)
	
	// If (Test path name(Get 4D folder(Database folder;*)+"cert.pem")#Is a document)| (Test path name(Get 4D folder(Database folder;*)+"key.pem")#Is a document)
	//APPEND MENU ITEM($Mnu_pop;"-")
	//APPEND MENU ITEM($Mnu_pop;":xliff:installTestCertificates")
	//SET MENU ITEM PARAMETER($Mnu_pop;-1;"_installCertificats")
	// End if
	
	If (Num:C11(Form:C1466.xCode.platform)=Mac OS:K25:2)
		
		$menu.line()
		
		$menu.append("openSimulatorLogs"; "_openLogs")\
			.append("openSimulatorDiagnosticReports"; "_openDiagnosticReports")
		
		$Txt_UDID:=String:C10(simulator(New object:C1471(\
			"action"; "default")).udid)
		
		If (Length:C16($Txt_UDID)#0)
			
			$menu.append("openCurrentSimulatorFolder"; "_openSimuPath")
			
			If ($Boo_dev)
				
				$menu.append(".Close simulators"; "_killSimulators")\
					.append(".Erase Current Simulator"; "_eraseCurrentSimulator")
				
			End if 
			
			$Obj_simulator:=simulator(\
				New object:C1471("action"; "deviceApp"; \
				"device"; $Txt_UDID; \
				"data"; True:C214))
			
			If ($Obj_simulator.success)
				
				$menuApp:=cs:C1710.menu.new()
				
				For each ($o; $Obj_simulator.apps)
					
					If (String:C10($o.metaData.path)#"")
						
						$t:=String:C10($o.CFBundleExecutable)
						
						If (Length:C16(String:C10($o.AppIdentifierPrefix))>0)
							
							$t:=$t+" - "+String:C10($o.AppIdentifierPrefix)
							
						End if 
						
						$menuApp.append($t; "_app"+JSON Stringify:C1217($o))
						
						If (DATABASE.isMatrix) & False:C215
							
							// provoque une erreur si mobile est un alias
							
							// XXX Could not do that in real app, resource folder must not be modified
							// ASK for SET MENU ITEM ICON with absolute path
							$t:="mobile"+Folder separator:K24:12+"cache"+Folder separator:K24:12+"icon"+Folder separator:K24:12
							
							If (Length:C16(String:C10($o.AppIdentifierPrefix))>0)
								
								$t:=$t+$o.AppIdentifierPrefix+Folder separator:K24:12
								
							End if 
							
							$t:=$t+$o.CFBundleIdentifier+".png"
							$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16; *)+$t  // Copy into resource folder, because menu item allow only iconRef from here
							CREATE FOLDER:C475($Txt_path; *)
							
							$Txt_path:=$o.appPath+Folder separator:K24:12+$o.CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles[0]+"@2x.png"
							
							If (Test path name:C476($Txt_path)=Is a document:K24:1)
								
								READ PICTURE FILE:C678($Txt_path; $Pic_buffer)
								
								If (OK=1)
									
									CREATE THUMBNAIL:C679($Pic_buffer; $Pic_icon; 48; 48; Scaled to fit:K6:2)
									
									If (OK=1)
										
										WRITE PICTURE FILE:C680(Get 4D folder:C485(Current resources folder:K5:16; *)+$t; $Pic_icon; ".png")
										$menuApp.icon("File:"+Convert path system to POSIX:C1106($t))
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End for each 
				
				$menu.append("openApplicationSimulatorFolder"; $menuApp)\
					.line()
				
			End if 
		End if 
		
		If ($Boo_dev)
			
			$menu.append(".Clear Xcode Build And Derived Data"; "_removeDerivedData")
			
		Else 
			
			$menu.append("clearXcodeBuild"; "_removeBuild").enable($Path_build.exists)
			
		End if 
		
		$menu.line()
		$menu.append("openTheCacheFolder"; "_openCache")
		
		If ($Boo_dev)
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
	$menu.append("verbose"; "_verbose").mark(Form:C1466.verbose)
	
End if 

If ($Obj_in.x#Null:C1517)\
 & ($Obj_in.y#Null:C1517)
	
	$menu.popup($Obj_in.x; $Obj_in.y)
	
Else 
	
	$menu.popup()
	
End if 

Case of 
		
		//______________________________________________________
	: (Not:C34($menu.selected))
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: ($menu.choice="product")
		
		SHOW ON DISK:C922($Path_product.platformPath; *)
		
		//______________________________________________________
	: ($menu.choice="project")
		
		SHOW ON DISK:C922(Form:C1466.file.parent.platformPath; *)
		
		//______________________________________________________
	: ($menu.choice="xCode")
		
		var $Xcode : cs:C1710.Xcode
		$Xcode:=cs:C1710.Xcode.new()
		$Xcode.open($Path_product)
		
		If ($Xcode.success)
			
			// Open a file of project in xcode
			If (String:C10(SHARED.xCode.fileFocus)#"")
				
				IDLE:C311
				DELAY PROCESS:C323(Current process:C322; 60*3)  // Wait xcode open
				
				$Xcode.reveal($Path_product.platformPath+Convert path POSIX to system:C1107(SHARED.xCode.fileFocus))
				
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
		
		$Dir_root:=HTTP Get certificates folder:C1307
		CREATE FOLDER:C475($Dir_root; *)
		COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"cert.pem"; $Dir_root+"cert.pem"; *)
		COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"key.pem"; $Dir_root+"key.pem"; *)
		
		// Verify the web server configuration
		CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "checkingServerConfiguration")
		
		//______________________________________________________
	: ($menu.choice="_openDiagnosticReports")
		
		SHOW ON DISK:C922(env_userPathname("logs"; "DiagnosticReports").platformPath)
		
		//______________________________________________________
	: ($menu.choice="_openLogs")
		
		$o:=env_userPathname("logs"; "CoreSimulator/")
		
		$Obj_simulator:=simulator(New object:C1471(\
			"action"; "default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$o:=$o.folder($Obj_simulator.udid)
			
		End if 
		
		If ($o.exists)
			
			SHOW ON DISK:C922($o.platformPath)
			
		End if 
		
		//______________________________________________________
	: ($menu.choice="_openSimuPath")
		
		$Obj_simulator:=simulator(New object:C1471(\
			"action"; "default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$Obj_result:=simulator(New object:C1471(\
				"action"; "devicePath"; \
				"device"; $Obj_simulator.udid))
			
			If (String:C10($Obj_result.path)#"")
				
				SHOW ON DISK:C922($Obj_result.path)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($menu.choice="_killSimulators")
		
		$Obj_result:=simulator(New object:C1471(\
			"action"; "kill"))
		
		//______________________________________________________
	: ($menu.choice="_eraseCurrentSimulator")
		
		$Obj_simulator:=simulator(New object:C1471(\
			"action"; "default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$Obj_result:=simulator(New object:C1471(\
				"action"; "isBooted"; \
				"device"; $Obj_simulator.udid))
			
			$Boo_booted:=Bool:C1537($Obj_result.booted)
			
			If ($Boo_booted)
				
				If (simulator(New object:C1471(\
					"action"; "kill")).success)
					
					Repeat 
						
						$Obj_result:=simulator(New object:C1471(\
							"action"; "device"; \
							"udid"; $Obj_simulator.udid))
						
						$Boo_:=$Obj_result.success
						
						If ($Boo_)
							
							$Boo_:=(String:C10($Obj_result.device.state)#"Shutdown")
							
						End if 
						
						IDLE:C311
						
					Until (Not:C34($Boo_))
				End if 
			End if 
			
			$Obj_result:=simulator(New object:C1471(\
				"action"; "erase"; \
				"device"; $Obj_simulator.udid))
			
			If ($Boo_booted)  // relaunch
				
				$Obj_result:=simulator(New object:C1471(\
					"action"; "open"; \
					"device"; $Obj_simulator.udid))
				
			End if 
		End if 
		
		//______________________________________________________
	: ($menu.choice="_openCache")
		
		SHOW ON DISK:C922(env_userPathname("cache").platformPath)
		
		//______________________________________________________
	: ($menu.choice="_openSDKCache")
		
		SHOW ON DISK:C922(sdk(New object:C1471("action"; "cacheFolder")).platformPath)
		
		//______________________________________________________
	: ($menu.choice="_clearCache")
		
		env_userPathname("cache").delete(fk recursive:K87:7)
		
		//______________________________________________________
	: ($menu.choice="_removeSDK")
		
		env_userPathname("sdk").delete(fk recursive:K87:7)
		
		//______________________________________________________
	: ($menu.choice="_removeMobilesProjects")
		
		path.projects().delete(fk recursive:K87:7)
		path.products().delete(fk recursive:K87:7)
		
		//______________________________________________________
	: ($menu.choice="_removeBuild")
		
		$Path_build.delete(fk recursive:K87:7)
		
		//______________________________________________________
	: ($menu.choice="_removeDerivedData")
		
		env_userPathname("derivedData").delete(fk recursive:K87:7)
		$Path_build.delete(fk recursive:K87:7)
		
		//______________________________________________________
	: ($menu.choice="_showConfigFile")
		
		SHOW ON DISK:C922(Get 4D folder:C485(Active 4D Folder:K5:10)+"4d.mobile")
		
		//______________________________________________________
	: ($menu.choice="_openCompoentLog")
		
		RECORD.open()
		
		//______________________________________________________
	: ($menu.choice="_generateDataModel")
		
		$Obj_project:=New object:C1471(\
			)  ///  XXX find a way to ge data model
		$Obj_project.product:=Form:C1466.product
		$Obj_project.dataModel:=Form:C1466.dataModel
		
		$Txt_path:=Temporary folder:C486+Folder separator:K24:12+"Structures.xcdatamodeld"
		
		dataModel(New object:C1471(\
			"action"; "xcdatamodel"; \
			"dataModel"; $Obj_project.dataModel; \
			"flat"; False:C215; \
			"relationship"; True:C214; \
			"dataSet"; dataSet(New object:C1471("action"; "readCatalog"; "project"; $Obj_project)).catalog; \
			"path"; $Txt_path))
		
		SHOW ON DISK:C922($Txt_path)
		
		//______________________________________________________
	: ($menu.choice="_addSources")
		
		Xcode(New object:C1471(\
			"action"; "workspace-addsources"; \
			"path"; $Path_product.platformPath))
		
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
		
		Form:C1466.verbose:=Not:C34(Bool:C1537(Form:C1466.verbose))
		
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