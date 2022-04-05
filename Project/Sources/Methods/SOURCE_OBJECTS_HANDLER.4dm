//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : SOURCE_OBJECTS_HANDLER
// ID[DE1DC030CB2B497BA1A42C0D39E7CE09]
// Created 18-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $keyPathname; $Txt_buffer; $Txt_me : Text
var $o; $Obj_context; $Obj_form; $Obj_server; $status : Object
var $web : 4D:C1709.WebServer
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

$Obj_form:=SOURCE_Handler(New object:C1471(\
"action"; "init"))

$Obj_context:=$Obj_form.ui

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($Txt_me=$Obj_form.generate)
		
		If (Not:C34(Bool:C1537(Form:C1466.$project.dataSetGeneration)))  // No reentry
			
			Form:C1466.$project.dataSetGeneration:=True:C214
			
			If (Form:C1466.dataSource.source="server")
				
				// ACI0100868
				//$File_key:=doc_Absolute_path (Form.dataSource.keyPath;Get 4D folder(MobileApps folder;*))
				
				//===============================================================
				// #RUSTINE: ne devrait plus être nécessaire
				If (Test path name:C476($keyPathname)#Is a document:K24:1)
					
					LOG_EVENT(New object:C1471(\
						"message"; String:C10(Form:C1466.dataSource.keyPath)+" ->"+$keyPathname))
					
					$keyPathname:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
					
				End if 
				
				//===============================================================
				
			Else 
				
				// Default location
				$keyPathname:=EDITOR.path.key().platformPath
				
			End if 
			
			EDITOR.doGenerate($keyPathname)
			SET TIMER:C645(-1)
			
		Else   // A generation is already in works
			
			SET TIMER:C645(-1)
			
		End if 
		
		//==================================================
	: ($Txt_me=$Obj_form.doNotGenerate)\
		 | ($Txt_me=$Obj_form.doNotExportImages)
		
		PROJECT.save()
		SET TIMER:C645(-1)
		
		//==================================================
	: ($Txt_me=$Obj_form.local)
		
		Form:C1466.dataSource.source:="local"
		
		PROJECT.save()
		$Obj_context.testServer()
		
		//==================================================
	: ($Txt_me=$Obj_form.server)
		
		Form:C1466.dataSource.source:="server"
		
		PROJECT.save()
		
		//#ACI0100687
		If (Length:C16(String:C10(Form:C1466.server.urls.production))>0)
			
			// Generate the key
			$o:=Rest(New object:C1471(\
				"action"; "request"; \
				"handler"; "mobileapp"; \
				"url"; Form:C1466.server.urls.production))
			
		End if 
		
		$Obj_context.testServer()
		
		//==================================================
	: ($Txt_me=$Obj_form.serverStatus)
		
		If (Length:C16(String:C10($Obj_context.serverStatus.action))>0)
			
			Case of 
					
					//______________________________________________________
				: ($Obj_context.serverStatus.action="localizeKeyFile")
					
					$Txt_buffer:=Select document:C905(Get 4D folder:C485(MobileApps folder:K5:47; *); SHARED.keyExtension; Get localized string:C991("selectTheKeyFile"); Use sheet window:K24:11+Package open:K24:8)
					
					If (Bool:C1537(OK))
						
						Form:C1466.dataSource.keyPath:=cs:C1710.doc.new(DOCUMENT).relativePath
						
						PROJECT.save()
						$Obj_context.testServer()
						
					End if 
					
					//______________________________________________________
				: ($Obj_context.serverStatus.action="goToProductionURL")
					
					CALL FORM:C1391($Obj_form.window; Formula:C1597(editor_CALLBACK).source; "goToPage"; New object:C1471(\
						"page"; "deployment"; \
						"panel"; "SERVER"; \
						"object"; "02_prodURL"))
					
					//______________________________________________________
				: ($Obj_context.serverStatus.action="startWebServer")
					
					$web:=WEB Server:C1674
					ASSERT:C1129($web.isRunning=WEB Get server info:C1531.started)
					
					If (Not:C34($web.isRunning))
						
/* START TRAPPING ERRORS */$error:=cs:C1710.error.new("capture")
						$status:=$web.start()
/* STOP TRAPPING ERRORS */$error.release()
						
					Else 
						
						// Already started
						$status:=New object:C1471(\
							"success"; True:C214)
						
					End if 
					
					If ($status.success)
						
						$Obj_context.testServer()
						
					Else 
						
						$Obj_server:=WEB Get server info:C1531
						
						$Obj_server.message:=$status.errors[0].message
						
					End if 
					
					If (String:C10($Obj_server.message)#"")
						
						EDITOR.postMessage(New object:C1471(\
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "theServerIsNotReady"; \
							"additional"; $Obj_server.message))
						
					End if 
					
					//______________________________________________________
					
				Else 
					
					ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_context.serverStatus.action+"\"")
					
					//______________________________________________________
			End case 
		End if 
		
		//  //==================================================
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$Txt_me+"\"")
		
		//==================================================
End case 