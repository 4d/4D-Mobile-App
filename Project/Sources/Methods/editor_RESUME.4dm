//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_RESUME
  // ID[ED02AB7186F243EC934AAF4A70A66505]
  // Created 4-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_http;$Lon_https;$Lon_parameters;$Win_me)
C_TEXT:C284($Dir_database;$kTxt_callbackMethod;$Txt_message;$Txt_selector)
C_OBJECT:C1216($Obj_buffer;$Obj_cancel;$Obj_in;$Obj_ok;$Obj_params;$Obj_xcode)

If (False:C215)
	C_TEXT:C284(editor_RESUME ;$1)
	C_OBJECT:C1216(editor_RESUME ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_selector:=$1
		
		  //#ACI0098517
		  //If ($Txt_selector="{@}")
		If (Match regex:C1019("(?m-si)^\\{.*\\}$";$Txt_selector;1))
			
			$Obj_in:=JSON Parse:C1218($Txt_selector)
			
			$Txt_selector:=String:C10($Obj_in.action)
			
		End if 
		
		If ($Lon_parameters>=2)
			
			$Obj_params:=$2
			
		End if 
	End if 
	
	$Win_me:=Current form window:C827
	$kTxt_callbackMethod:="editor_CALLBACK"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Length:C16($Txt_selector)=0)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: ($Txt_selector="page_@")
		
		If ($Obj_in#Null:C1517)
			
			$Obj_in.action:="goToPage"
			$Obj_in.page:=Delete string:C232($Txt_selector;1;5)
			
			CALL FORM:C1391($Win_me;$kTxt_callbackMethod;"goToPage";$Obj_in)
			
		Else 
			
			CALL FORM:C1391($Win_me;$kTxt_callbackMethod;"goToPage";New object:C1471(\
				"page";Delete string:C232($Txt_selector;\
				1;5)))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="installXcode")
		
		$Obj_xcode:=Xcode (New object:C1471(\
			"action";"appStore"))
		
		  //______________________________________________________
	: ($Txt_selector="openXcode")
		
		$Obj_xcode:=Xcode (New object:C1471(\
			"action";"open"))
		
		  //______________________________________________________
	: ($Txt_selector="setToolPath")
		
		$Obj_xcode:=Xcode (New object:C1471(\
			"action";"set-tool-path";\
			"posix";String:C10($Obj_in.posix)))
		
		If ($Obj_xcode.success)
			
			  // Relaunch checking the development environment
			CALL WORKER:C1389("4D Mobile ("+String:C10($Win_me)+")";"mobile_Check_installation";New object:C1471(\
				"caller";$Win_me))
			
		Else 
			
			If (Position:C15("User canceled. (-128)";$Obj_xcode.error)>0)
				
				  // NOTHING MORE TO DO
				
			Else 
				
				POST_FORM_MESSAGE (New object:C1471(\
					"target";$Win_me;\
					"action";"show";\
					"type";"alert";\
					"title";"failedToRepairThePathOfTheDevelopmentTools";\
					"additional";"tryDoingThisFromTheXcodeApplication"))
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="build_stop")  // #MARK_TO_REMOVE
		
		CALL FORM:C1391($Win_me;$kTxt_callbackMethod;$Txt_selector)
		
		  //______________________________________________________
	: ($Txt_selector="build_run")
		
		  //CALL FORM($Win_me;"project_BUILD";$Obj_in.project)
		CALL FORM:C1391($Win_me;"project_BUILD";$Obj_params)
		
		  //______________________________________________________
	: ($Txt_selector="build_deleteProductFolder")
		
		If (Asserted:C1132($Obj_in.build#Null:C1517))
			
			If (Asserted:C1132(Test path name:C476($Obj_in.build.path)=Is a folder:K24:2))
				
				Xcode (New object:C1471(\
					"action";"safeDelete";\
					"path";$Obj_in.build.path))
				
				BUILD ($Obj_in.build)  // Relaunch the build process
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="build_ignoreServer")
		
		$Obj_in.build.ignoreServer:=True:C214
		
		BUILD ($Obj_in.build)  // Relaunch the build process
		
		  //______________________________________________________
	: ($Txt_selector="build_startWebServer")\
		 | ($Txt_selector="startWebServer")
		
		CLEAR VARIABLE:C89(err)
		ON ERR CALL:C155("keepError")
		WEB START SERVER:C617
		ON ERR CALL:C155("")
		
		If (OK=1)
			
			If ($Txt_selector="build_startWebServer")
				
				BUILD ($Obj_in.build)  // Relaunch the build process
				
			End if 
			
		Else 
			
			$Obj_buffer:=WEB Get server info:C1531
			
			WEB GET OPTION:C1209(Web HTTP enabled:K73:28;$Lon_http)
			WEB GET OPTION:C1209(Web HTTPS enabled:K73:29;$Lon_https)
			
			Case of 
					
					  //______________________________________________________
				: ($Lon_http=1)
					
					  // Port conflict?
					If (Num:C11(err.error)=-1)
						
						$Txt_message:=str .setText("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($Obj_buffer.options.webPortID);String:C10($Obj_buffer.options.webHTTPSPortID)))
						
					Else 
						
						  // Display error number
						$Txt_message:=Get localized string:C991("error:")+String:C10(err.error)
						
					End if 
					
					  //______________________________________________________
				: ($Lon_https=1)
					
					  // Port conflict? or certificates are missing?
					$Dir_database:=Get 4D folder:C485(Database folder:K5:14;*)
					
					If (Test path name:C476($Dir_database+"cert.pem")#Is a document:K24:1)\
						 | (Test path name:C476($Dir_database+"key.pem")#Is a document:K24:1)
						
						$Txt_message:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
						
					Else 
						
						If (Num:C11(err.error)=-1)
							
							$Txt_message:=str .setText("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($Obj_buffer.options.webPortID);String:C10($Obj_buffer.options.webHTTPSPortID)))
							
						Else 
							
							  // Display error number
							$Txt_message:=Get localized string:C991("error:")+String:C10(err.error)
							
						End if 
					End if 
					
					  //______________________________________________________
				Else 
					
					$Txt_message:=Get localized string:C991("httpsServerIsNotEnabledInWebConfigurationSettings")
					
					  //______________________________________________________
			End case 
			
			  //If ($Lon_https=1)
			  //  // Port conflict? or certificates are missing?
			  //$Dir_database:=Get 4D folder(Database folder;*)
			  //If (Test path name($Dir_database+"cert.pem")#Is a document)\
																				| (Test path name($Dir_database+"key.pem")#Is a document)
			
			  //$Txt_message:=Get localized string("checkThatTheCertificatesAreProperlyInstalled")
			  // Else
			  // If (Num(obj_error.error)=-1)
			  //$Txt_message:=str_localized (New collection("someListeningPortsAreAlreadyUsed";String($Obj_buffer.options.webPortID);String($Obj_buffer.options.webHTTPSPortID)))
			  // Else
			  //  // Display error number
			  //$Txt_message:=Get localized string("error:")+String(obj_error.error)
			  // End if
			  // End if
			  // Else
			  //$Txt_message:=Get localized string("httpsServerIsNotEnabledInWebConfigurationSettings")
			  // End if
			
			POST_FORM_MESSAGE (New object:C1471(\
				"target";$Win_me;\
				"action";"show";\
				"type";"alert";\
				"title";Get localized string:C991("failedToStartTheWebServer");\
				"additional";$Txt_message))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="build_waitingForConfigurator")
		
		  // Open App Store
		device (New object:C1471(\
			"action";"appStore"))
		
		  // Warning build is into in.build
		$Obj_ok:=New object:C1471(\
			"action";"build_configuratorInstalled";\
			"build";$Obj_in.build)
		
		$Obj_cancel:=New object:C1471(\
			"action";"build_manualInstallation";\
			"build";$Obj_in.build)
		
		POST_FORM_MESSAGE (New object:C1471(\
			"target";$Win_me;\
			"action";"show";\
			"type";"confirm";\
			"title";Get localized string:C991("appleConfigurator2Installation");\
			"additional";Get localized string:C991("clicContinueWhenAppleConfigurator2IsInstalledOnYourMac");\
			"ok";Get localized string:C991("continue");\
			"okAction";JSON Stringify:C1217($Obj_ok);\
			"cancelAction";JSON Stringify:C1217($Obj_cancel)))
		
		  //______________________________________________________
	: ($Txt_selector="build_deviceOnline")
		
		CALL FORM:C1391($Win_me;"BUILD";$Obj_in.build)  // Relaunch the build process
		
		  //______________________________________________________
	: ($Txt_selector="build_configuratorInstalled")\
		 | ($Txt_selector="build_manualInstallation")
		
		$Obj_in.build.manualInstallation:=($Txt_selector="build_manualInstallation")
		
		CALL FORM:C1391($Win_me;"BUILD";$Obj_in.build)  // Relaunch the build process
		
		  //______________________________________________________
	: ($Txt_selector="projectFixErrors")
		
		CALL FORM:C1391($Win_me;$kTxt_callbackMethod;$Txt_selector;$Obj_in)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End