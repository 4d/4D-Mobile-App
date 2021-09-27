//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_MESSAGE_CALLBACK
// ID[5E21F10B50124FF283B08FEB987EF183]
// Created 11-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(editor_MESSAGE_CALLBACK; $1)
End if 

var $description; $t : Text
var $validated : Boolean
var $webServerInfos : Object
var $c : Collection
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations
$description:=String:C10($1.signal.description)
$validated:=Bool:C1537($1.signal.validate)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($description="theWebServerIsNotStarted")
		
		If ($validated)
			
/* START TRAPPING ERRORS */
			$error:=cs:C1710.error.new("capture")
			
			WEB START SERVER:C617
			
			$error.release()
/* STOP TRAPPING ERRORS */
			
			If (Bool:C1537(OK))
				
				BUILD($1.build)  // Relaunch the build process
				
			Else 
				
				$webServerInfos:=WEB Get server info:C1531
				
				Case of 
						
						//______________________________________________________
					: ($webServerInfos.security.HTTPEnabled)
						
						// Port conflict?
						If (Num:C11($error.lastError().error)=-1)
							
							$t:=cs:C1710.str.new("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($webServerInfos.options.webPortID); String:C10($webServerInfos.options.webHTTPSPortID)))
							
						Else 
							
							// Display error number
							$t:=Get localized string:C991("error:")+String:C10($error.lastError().error)
							
						End if 
						
						//______________________________________________________
					: ($webServerInfos.security.HTTPSEnabled)
						
						// Port conflict? or certificates are missing?
						
						$c:=Folder:C1567(fk database folder:K87:14; *).files()
						
						If ($c.query("fullName = :1"; "cert.pem").pop()=Null:C1517)\
							 | ($c.query("fullName = :1"; "key.pem").pop()=Null:C1517)
							
							$t:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
							
						Else 
							
							If (Num:C11($error.lastError().error)=-1)
								
								$t:=cs:C1710.str.new.setText("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($webServerInfos.options.webPortID); String:C10($webServerInfos.options.webHTTPSPortID)))
								
							Else 
								
								// Display error number
								$t:=Get localized string:C991("error:")+String:C10($error.lastError().error)
								
							End if 
						End if 
						
						//______________________________________________________
					Else 
						
						$t:=Get localized string:C991("httpsServerIsNotEnabledInWebConfigurationSettings")
						
						//______________________________________________________
				End case 
				
				POST_MESSAGE(New object:C1471(\
					"target"; Current form window:C827; \
					"action"; "show"; \
					"type"; "alert"; \
					"title"; Get localized string:C991("failedToStartTheWebServer"); \
					"additional"; $t))
				
			End if 
			
		Else 
			
			// Cancel build process
			EDITOR.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	: ($description="someStructuralAdjustmentsAreNeeded")
		
		If ($validated)
			
			// Set and continue
			EDITOR.callMeBack("allowStructureModification"; Form:C1466.option)
			
		Else 
			
			// Cancel build process
			EDITOR.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	: ($description="productFolderAlreadyExist")
		
		If ($validated)  // Delete product folder
			
			If (Asserted:C1132($1.build#Null:C1517))
				
				If (Asserted:C1132(Test path name:C476($1.build.path)=Is a folder:K24:2))
					
					Xcode(New object:C1471(\
						"action"; "safeDelete"; \
						"path"; $1.build.path))
					
					BUILD($1.build)  // Relaunch the build process
					
				End if 
			End if 
			
		Else 
			
			// Cancel build process
			EDITOR.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End