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
C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($File_key;$Txt_buffer;$Txt_me;$Txt_url)
C_OBJECT:C1216($Obj_context;$Obj_form;$Obj_project;$Obj_server;$Obj_tags)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=SOURCE_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.ui
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.generate)
		
		$Obj_project:=New object:C1471(\
			)
		$Obj_project.product:=Form:C1466.product
		$Obj_project.dataModel:=Form:C1466.dataModel
		$Obj_project.$project:=Form:C1466.$project
		$Obj_project.dataSource:=Form:C1466.dataSource
		$Obj_project.server:=Form:C1466.server
		
		If (Form:C1466.dataSource.source="server")
			
			$File_key:=doc_Absolute_path (Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath))
			
			  //===============================================================
			  //#RUSTINE: ne devrait plus être nécessaire
			If (Test path name:C476($File_key)#Is a document:K24:1)
				
				LOG_EVENT (New object:C1471(\
					"message";Form:C1466.dataSource.keyPath+" ->"+$File_key))
				
				$File_key:=Convert path POSIX to system:C1107(Form:C1466.dataSource.keyPath)
				
			End if 
			
			  //===============================================================
			
		Else 
			
			  // Default location
			$File_key:=COMPONENT_Pathname ("key").platformPath
			
		End if 
		
		(OBJECT Get pointer:C1124(Object named:K67:5;"dataGeneration"))->:=1
		OBJECT SET VISIBLE:C603(*;"dataGeneration@";True:C214)
		
		Form:C1466.$project.dataSetGeneration:=True:C214
		
		If (featuresFlags.with("setImageDump"))
			
			CALL WORKER:C1389(Form:C1466.$worker;"dataSet";New object:C1471(\
				"caller";$Obj_form.window;\
				"action";"create";\
				"eraseIfExists";True:C214;\
				"project";$Obj_project;\
				"digest";True:C214;\
				"coreDataSet";Bool:C1537(featuresFlags._110882);\
				"key";$File_key;\
				"dataSet";True:C214))
			
		Else 
			
			CALL WORKER:C1389(Form:C1466.$worker;"dataSet";New object:C1471(\
				"caller";$Obj_form.window;\
				"action";"create";\
				"eraseIfExists";True:C214;\
				"project";$Obj_project;\
				"digest";True:C214;\
				"coreDataSet";Bool:C1537(featuresFlags._110882);\
				"key";$File_key;\
				"dataSet";True:C214;\
				"picture";Not:C34(Bool:C1537(featuresFlags._97117))))
			
		End if 
		
		  // If (Shift down)
		  //SHOW ON DISK(dataSet (New object(\
			"action";"path";\
			"project";New object(\
			"product";Form.product;\
			"$project";Form.$project))).path)
		  // End if
		
		  //==================================================
	: ($Txt_me=$Obj_form.doNotGenerate)\
		 | ($Txt_me=$Obj_form.doNotExportImages)
		
		ui.saveProject()
		ui.refresh()
		
		  //==================================================
	: ($Txt_me=$Obj_form.local)
		
		Form:C1466.dataSource.source:="local"
		
		ui.saveProject()
		$Obj_context.testServer()
		
		  //==================================================
	: ($Txt_me=$Obj_form.server)
		
		Form:C1466.dataSource.source:="server"
		
		ui.saveProject()
		$Obj_context.testServer()
		
		  //==================================================
	: ($Txt_me=$Obj_form.serverStatus)
		
		If (Length:C16(String:C10($Obj_context.serverStatus.action))>0)
			
			Case of 
					
					  //______________________________________________________
				: ($Obj_context.serverStatus.action="localizeKeyFile")
					
					$Txt_buffer:=Select document:C905(Get 4D folder:C485(MobileApps folder:K5:47;*);commonValues.keyExtension;Get localized string:C991("selectTheKeyFile");Use sheet window:K24:11+Package open:K24:8)
					
					If (Bool:C1537(OK))
						
						Form:C1466.dataSource.keyPath:=Replace string:C233(doc_Relative_path (DOCUMENT);Folder separator:K24:12;"/")
						
						ui.saveProject()
						$Obj_context.testServer()
						
					End if 
					
					  //______________________________________________________
				: ($Obj_context.serverStatus.action="goToProductionURL")
					
					CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"goToPage";New object:C1471(\
						"page";"deployment";\
						"panel";"SERVER";\
						"object";"02_prodURL"))
					
					  //______________________________________________________
				: ($Obj_context.serverStatus.action="startWebServer")
					
					CLEAR VARIABLE:C89(err)
					ON ERR CALL:C155("keepError")
					WEB START SERVER:C617
					ON ERR CALL:C155("")
					
					If (Bool:C1537(OK))
						
						$Obj_context.testServer()
						
					Else 
						
						$Obj_server:=WEB Get server info:C1531
						
						If (Num:C11(err.error)=-1)
							
							  // Port conflict ?
							$Obj_server.message:=str ("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($Obj_server.options.webPortID);String:C10($Obj_server.options.webHTTPSPortID)))
							
						Else 
							
							$Obj_server.message:=Get localized string:C991("error:")+String:C10(err.error)
							
						End if 
					End if 
					
					If (String:C10($Obj_server.message)#"")
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";$Obj_form.window;\
							"action";"show";\
							"type";"alert";\
							"title";Get localized string:C991("theServerIsNotReady");\
							"additional";$Obj_server.message))
						
					End if 
					
					  //______________________________________________________
					
				Else 
					
					ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_context.serverStatus.action+"\"")
					
					  //______________________________________________________
			End case 
		End if 
		
		  //  //==================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End