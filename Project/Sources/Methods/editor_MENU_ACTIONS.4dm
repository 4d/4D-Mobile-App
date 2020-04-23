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

C_BOOLEAN:C305($Boo_;$Boo_booted;$Boo_dev;$Boo_plus)
C_LONGINT:C283($Lon_parameters)
C_PICTURE:C286($Pic_buffer;$Pic_icon)
C_TEXT:C284($Dir_root;$Mnu_app;$Mnu_choice;$Mnu_pop;$Txt_buffer;$Txt_path)
C_TEXT:C284($Txt_UDID)
C_OBJECT:C1216($o;$Obj_app;$Obj_could;$Obj_in;$Obj_project;$Obj_result)
C_OBJECT:C1216($Obj_simulator;$Path_build;$Path_product)

If (False:C215)
	C_OBJECT:C1216(editor_MENU_ACTIONS ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Boo_plus:=Macintosh option down:C545
	$Boo_dev:=Macintosh command down:C546 & Storage:C1525.database.isMatrix
	
	  // Autosave
	project_SAVE 
	
	$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
	
	$Path_product:=path .products().folder($Obj_project.product.name)
	$Path_build:=$Path_product.folder("build")
	
	$Obj_could:=New object:C1471(\
		"openProductFolder";($Path_product.exists & (Length:C16($Obj_project.product.name)#0)))
	
	$Obj_could.openWithXcode:=$Obj_could.openProductFolder & Bool:C1537(Form:C1466.xCode.XcodeAvailable)
	
	If ($Obj_could.openWithXcode)
		
		$Obj_could.openWithXcode:=Xcode (New object:C1471(\
			"action";"couldOpen";\
			"path";$Path_product.platformPath)).success
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Mnu_pop:=Create menu:C408

If (editor_Locked )
	
	APPEND MENU ITEM:C411($Mnu_pop;":xliff:syncDataModel")
	SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"syncDataModel")
	
	APPEND MENU ITEM:C411($Mnu_pop;"-")
	
End if 

APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuProjectFolder")
SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"project")

APPEND MENU ITEM:C411($Mnu_pop;"-")

APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuProductFolder")
SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"product")

  // Disable if the product folder doesn't exist
If (Not:C34($Obj_could.openProductFolder))
	
	DISABLE MENU ITEM:C150($Mnu_pop;-1)
	
End if 

APPEND MENU ITEM:C411($Mnu_pop;":xliff:mnuOpenTheProjectWithXcode")
SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"xCode")

  // Disable if Xcode isn't installed
If (Not:C34($Obj_could.openWithXcode))
	
	DISABLE MENU ITEM:C150($Mnu_pop;-1)
	
End if 

  // =================== DEVELOPMENT ITEMS ===================== [
If ($Boo_plus)
	
	  // If (Test path name(Get 4D folder(Database folder;*)+"cert.pem")#Is a document)| (Test path name(Get 4D folder(Database folder;*)+"key.pem")#Is a document)
	  //APPEND MENU ITEM($Mnu_pop;"-")
	  //APPEND MENU ITEM($Mnu_pop;":xliff:installTestCertificates")
	  //SET MENU ITEM PARAMETER($Mnu_pop;-1;"_installCertificats")
	  // End if
	
	If (Num:C11(Form:C1466.xCode.platform)=Mac OS:K25:2)
		
		APPEND MENU ITEM:C411($Mnu_pop;"-")
		
		$Obj_simulator:=simulator (New object:C1471(\
			"action";"default"))
		$Txt_UDID:=String:C10($Obj_simulator.udid)
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:openSimulatorLogs")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openLogs")
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:openSimulatorDiagnosticReports")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openDiagnosticReports")
		
		If (Length:C16($Txt_UDID)#0)
			
			APPEND MENU ITEM:C411($Mnu_pop;":xliff:openCurrentSimulatorFolder")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openSimuPath")
			
			If ($Boo_dev)
				
				APPEND MENU ITEM:C411($Mnu_pop;".Close simulators")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_killSimulators")
				
				APPEND MENU ITEM:C411($Mnu_pop;".Erase Current Simulator")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_eraseCurrentSimulator")
				
			End if 
			
			$Obj_simulator:=simulator (\
				New object:C1471("action";"deviceApp";\
				"device";$Txt_UDID;\
				"data";True:C214))
			
			If ($Obj_simulator.success)
				
				$Mnu_app:=Create menu:C408
				
				For each ($Obj_app;$Obj_simulator.apps)
					
					If (String:C10($Obj_app.metaData.path)#"")
						
						$Txt_buffer:=String:C10($Obj_app.CFBundleExecutable)
						
						If (Length:C16(String:C10($Obj_app.AppIdentifierPrefix))>0)
							
							$Txt_buffer:=$Txt_buffer+" - "+String:C10($Obj_app.AppIdentifierPrefix)
							
						End if 
						
						APPEND MENU ITEM:C411($Mnu_app;$Txt_buffer)
						SET MENU ITEM PARAMETER:C1004($Mnu_app;-1;"_app"+JSON Stringify:C1217($Obj_app))
						
						If (Storage:C1525.database.isMatrix) & False:C215
							
							  // provoque une erreur si mobile est un alias
							
							  // XXX Could not do that in real app, resource folder must not be modified
							  // ASK for SET MENU ITEM ICON with absolute path
							$Txt_buffer:="mobile"+Folder separator:K24:12+"cache"+Folder separator:K24:12+"icon"+Folder separator:K24:12
							
							If (Length:C16(String:C10($Obj_app.AppIdentifierPrefix))>0)
								
								$Txt_buffer:=$Txt_buffer+$Obj_app.AppIdentifierPrefix+Folder separator:K24:12
								
							End if 
							
							$Txt_buffer:=$Txt_buffer+$Obj_app.CFBundleIdentifier+".png"
							$Txt_path:=Get 4D folder:C485(Current resources folder:K5:16;*)+$Txt_buffer  // Copy into resource folder, because menu item allow only iconRef from here
							CREATE FOLDER:C475($Txt_path;*)
							
							$Txt_path:=$Obj_app.appPath+Folder separator:K24:12+$Obj_app.CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles[0]+"@2x.png"
							
							If (Test path name:C476($Txt_path)=Is a document:K24:1)
								
								READ PICTURE FILE:C678($Txt_path;$Pic_buffer)
								
								If (OK=1)
									
									CREATE THUMBNAIL:C679($Pic_buffer;$Pic_icon;48;48;Scaled to fit:K6:2)
									
									If (OK=1)
										
										WRITE PICTURE FILE:C680(Get 4D folder:C485(Current resources folder:K5:16;*)+$Txt_buffer;$Pic_icon;".png")
										SET MENU ITEM ICON:C984($Mnu_app;-1;"File:"+Convert path system to POSIX:C1106($Txt_buffer))
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End for each 
				
				APPEND MENU ITEM:C411($Mnu_pop;":xliff:openApplicationSimulatorFolder";$Mnu_app)
				
			End if 
		End if 
		
		APPEND MENU ITEM:C411($Mnu_pop;"-")
		
		If ($Boo_dev)
			
			APPEND MENU ITEM:C411($Mnu_pop;".Clear Xcode Build And Derived Data")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_removeDerivedData")
			
		Else 
			
			APPEND MENU ITEM:C411($Mnu_pop;":xliff:clearXcodeBuild")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_removeBuild")
			
			If (Not:C34($Path_build.exists))
				
				DISABLE MENU ITEM:C150($Mnu_pop;-1)
				
			End if 
		End if 
		
		APPEND MENU ITEM:C411($Mnu_pop;"-")
		
		APPEND MENU ITEM:C411($Mnu_pop;":xliff:openTheCacheFolder")
		SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openCache")
		
		If ($Boo_dev)
			
			APPEND MENU ITEM:C411($Mnu_pop;".🗑 Clear Cache folder")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_clearCache")
			
			If (Not:C34(Is compiled mode:C492))
				
				APPEND MENU ITEM:C411($Mnu_pop;".💣 Remove SDK")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_removeSDK")
				
				APPEND MENU ITEM:C411($Mnu_pop;"-")
				
				APPEND MENU ITEM:C411($Mnu_pop;".💣 Clear Mobiles projects")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_removeMobilesProjects")
				
				APPEND MENU ITEM:C411($Mnu_pop;"-")
				
				APPEND MENU ITEM:C411($Mnu_pop;".⚙️ Show config file ")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_showConfigFile")
				
				APPEND MENU ITEM:C411($Mnu_pop;".Add sources to Xcode Project")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_addSources")
				
				APPEND MENU ITEM:C411($Mnu_pop;"-")
				
				APPEND MENU ITEM:C411($Mnu_pop;".Reveal 4D template folder")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openTemplateFolder")
				
				APPEND MENU ITEM:C411($Mnu_pop;".🚧 Reveal custom form folder")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openHostFormFolder")
				
				APPEND MENU ITEM:C411($Mnu_pop;".🍪 Generate data model")
				SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_generateDataModel")
				
			End if 
			
			APPEND MENU ITEM:C411($Mnu_pop;"-")
			APPEND MENU ITEM:C411($Mnu_pop;".Open Commponent Log")
			SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_openCompoentLog")
		End if 
	End if 
	
	APPEND MENU ITEM:C411($Mnu_pop;"-")
	
	APPEND MENU ITEM:C411($Mnu_pop;":xliff:verbose")
	SET MENU ITEM PARAMETER:C1004($Mnu_pop;-1;"_verbose")
	SET MENU ITEM MARK:C208($Mnu_pop;-1;Char:C90(18)*Num:C11(Form:C1466.verbose))
	
End if 

  // =========================================================== ]

If ($Obj_in.x#Null:C1517)\
 & ($Obj_in.y#Null:C1517)
	
	  // Place the contextual menu
	$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop;"";$Obj_in.x;$Obj_in.y)
	
Else 
	
	$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop)
	
End if 

RELEASE MENU:C978($Mnu_pop)

Case of 
		
		  //______________________________________________________
	: ($Mnu_choice="product")
		
		SHOW ON DISK:C922($Path_product.platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="project")
		
		SHOW ON DISK:C922(Form:C1466.root)
		
		  //______________________________________________________
	: ($Mnu_choice="xCode")
		
		$Obj_result:=Xcode (New object:C1471(\
			"action";"open";\
			"path";$Path_product.platformPath))
		
		If ($Obj_result.success)
			
			  // Open a file of project in xcode
			If (String:C10(SHARED.xCode.fileFocus)#"")
				
				IDLE:C311
				DELAY PROCESS:C323(Current process:C322;60*3)  // wait xcode open
				
				$Obj_result:=Xcode (New object:C1471(\
					"action";"reveal";\
					"path";$Path_product.platformPath+Convert path POSIX to system:C1107(SHARED.xCode.fileFocus)))
				
			End if 
			
		Else 
			
			  // XXX maybe alert...or make action unavailable...
			  // SHOW ON DISK($Dir_product)
			
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="syncDataModel")
		
		POST_FORM_MESSAGE (New object:C1471(\
			"target";Current form window:C827;\
			"action";"show";\
			"type";"confirm";\
			"title";"updateTheProject";\
			"additional";"aBackupWillBeCreatedIntoTheProjectFolder";\
			"ok";"update";\
			"okFormula";Formula:C1597(CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"syncDataModel"))))
		
		  //______________________________________________________
	: ($Mnu_choice="_installCertificats")
		
		$Dir_root:=HTTP Get certificates folder:C1307
		CREATE FOLDER:C475($Dir_root;*)
		COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"cert.pem";$Dir_root+"cert.pem";*)
		COPY DOCUMENT:C541(Get 4D folder:C485(-1)+"key.pem";$Dir_root+"key.pem";*)
		
		  // Verify the web server configuration
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"checkingServerConfiguration")
		
		  //______________________________________________________
	: ($Mnu_choice="_openDiagnosticReports")
		
		SHOW ON DISK:C922(env_userPathname ("logs";"DiagnosticReports").platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="_openLogs")
		
		$o:=env_userPathname ("logs";"CoreSimulator/")
		
		$Obj_simulator:=simulator (New object:C1471(\
			"action";"default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$o:=$o.folder($Obj_simulator.udid)
			
		End if 
		
		If ($o.exists)
			
			SHOW ON DISK:C922($o.platformPath)
			
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="_openSimuPath")
		
		$Obj_simulator:=simulator (New object:C1471(\
			"action";"default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$Obj_result:=simulator (New object:C1471(\
				"action";"devicePath";\
				"device";$Obj_simulator.udid))
			
			If (String:C10($Obj_result.path)#"")
				
				SHOW ON DISK:C922($Obj_result.path)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="_killSimulators")
		
		$Obj_result:=simulator (New object:C1471(\
			"action";"kill"))
		
		  //______________________________________________________
	: ($Mnu_choice="_eraseCurrentSimulator")
		
		$Obj_simulator:=simulator (New object:C1471(\
			"action";"default"))
		
		If (String:C10($Obj_simulator.udid)#"")
			
			$Obj_result:=simulator (New object:C1471(\
				"action";"isBooted";\
				"device";$Obj_simulator.udid))
			
			$Boo_booted:=Bool:C1537($Obj_result.booted)
			
			If ($Boo_booted)
				
				If (simulator (New object:C1471(\
					"action";"kill")).success)
					
					Repeat 
						
						$Obj_result:=simulator (New object:C1471(\
							"action";"device";\
							"udid";$Obj_simulator.udid))
						
						$Boo_:=$Obj_result.success
						
						If ($Boo_)
							
							$Boo_:=(String:C10($Obj_result.device.state)#"Shutdown")
							
						End if 
						
						IDLE:C311
						
					Until (Not:C34($Boo_))
				End if 
			End if 
			
			$Obj_result:=simulator (New object:C1471(\
				"action";"erase";\
				"device";$Obj_simulator.udid))
			
			If ($Boo_booted)  // relaunch
				
				$Obj_result:=simulator (New object:C1471(\
					"action";"open";\
					"device";$Obj_simulator.udid))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Mnu_choice="_openCache")
		
		SHOW ON DISK:C922(env_userPathname ("cache").platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="_clearCache")
		
		env_userPathname ("cache").delete(fk recursive:K87:7)
		
		  //______________________________________________________
	: ($Mnu_choice="_removeSDK")
		
		env_userPathname ("sdk").delete(fk recursive:K87:7)
		
		  //______________________________________________________
	: ($Mnu_choice="_removeMobilesProjects")
		
		path .projects().delete(fk recursive:K87:7)
		path .products().delete(fk recursive:K87:7)
		
		  //______________________________________________________
	: ($Mnu_choice="_removeBuild")
		
		$Path_build.delete(fk recursive:K87:7)
		
		  //______________________________________________________
	: ($Mnu_choice="_removeDerivedData")
		
		env_userPathname ("derivedData").delete(fk recursive:K87:7)
		$Path_build.delete(fk recursive:K87:7)
		
		  //______________________________________________________
	: ($Mnu_choice="_showConfigFile")
		
		SHOW ON DISK:C922(Get 4D folder:C485(Active 4D Folder:K5:10)+"4d.mobile")
		
		  //______________________________________________________
	: ($Mnu_choice="_openCompoentLog")
		
		RECORD.open()
		
		  //______________________________________________________
	: ($Mnu_choice="_generateDataModel")
		
		$Obj_project:=New object:C1471(\
			)  ///  XXX find a way to ge data model
		$Obj_project.product:=Form:C1466.product
		$Obj_project.dataModel:=Form:C1466.dataModel
		
		$Txt_path:=Temporary folder:C486+Folder separator:K24:12+"Structures.xcdatamodeld"
		
		  //dataModel (New object(\
																								//"action";"xcdatamodel";\
																								//"dataModel";$Obj_project.dataModel;\
																								//"flat";False;\
																								//"relationship";Bool(featuresFlags._103850);\
																								//"dataSet";dataSet (New object("action";"readCatalog";"project";$Obj_project)).catalog;\
																								//"path";$Txt_path))
		dataModel (New object:C1471(\
			"action";"xcdatamodel";\
			"dataModel";$Obj_project.dataModel;\
			"flat";False:C215;\
			"relationship";True:C214;\
			"dataSet";dataSet (New object:C1471("action";"readCatalog";"project";$Obj_project)).catalog;\
			"path";$Txt_path))
		
		SHOW ON DISK:C922($Txt_path)
		
		  //______________________________________________________
	: ($Mnu_choice="_addSources")
		
		Xcode (New object:C1471(\
			"action";"workspace-addsources";\
			"path";$Path_product.platformPath))
		
		  //______________________________________________________
	: ($Mnu_choice="_openTemplateFolder")
		
		SHOW ON DISK:C922(path .templates().platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="_openHostFormFolder")
		
		$o:=path .hostlistForms(True:C214)
		$o:=path .hostdetailForms(True:C214)
		SHOW ON DISK:C922(path .hostForms().platformPath)
		
		  //______________________________________________________
	: ($Mnu_choice="_verbose")
		
		Form:C1466.verbose:=Not:C34(Bool:C1537(Form:C1466.verbose))
		
		  //______________________________________________________
	: (Position:C15("_app{";$Mnu_choice)=1)
		
		SHOW ON DISK:C922(JSON Parse:C1218(Substring:C12($Mnu_choice;Length:C16("_app")+1)).metaData.path)
		
		  //______________________________________________________
	Else 
		
		If (Length:C16($Mnu_choice)#0)
			
			ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
			
		End if 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End