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
var $http; $https : Integer
var $o : Object
var $c; $errors : Collection

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
			
			$errors.release()
/* STOP TRAPPING ERRORS */
			
			If (Bool:C1537(OK))
				
				BUILD($1.build)  // Relaunch the build process
				
			Else 
				
				$o:=WEB Get server info:C1531
				
				WEB GET OPTION:C1209(Web HTTP enabled:K73:28; $http)
				WEB GET OPTION:C1209(Web HTTPS enabled:K73:29; $https)
				
				Case of 
						
						//______________________________________________________
					: (Bool:C1537($http))
						
						// Port conflict?
						If (Num:C11($errors.lastError().error)=-1)
							
							$t:=str.setText("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($o.options.webPortID); String:C10($o.options.webHTTPSPortID)))
							
						Else 
							
							// Display error number
							$t:=Get localized string:C991("error:")+String:C10($errors.lastError().error)
							
						End if 
						
						//______________________________________________________
					: (Bool:C1537($https))
						
						// Port conflict? or certificates are missing?
						
						$c:=Folder:C1567(fk database folder:K87:14; *).files()
						
						If ($c.query("fullName = :1"; "cert.pem").pop()=Null:C1517)\
							 | ($c.query("fullName = :1"; "key.pem").pop()=Null:C1517)
							
							$t:=Get localized string:C991("checkThatTheCertificatesAreProperlyInstalled")
							
						Else 
							
							If (Num:C11($errors.lastError().error)=-1)
								
								$t:=str.setText("someListeningPortsAreAlreadyUsed").localized(New collection:C1472(String:C10($o.options.webPortID); String:C10($o.options.webHTTPSPortID)))
								
							Else 
								
								// Display error number
								$t:=Get localized string:C991("error:")+String:C10($errors.lastError().error)
								
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
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "build_stop")
			
		End if 
		
		//______________________________________________________
	: ($description="someStructuralAdjustmentsAreNeeded")
		
		If ($validated)
			
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "allowStructureModification"; Form:C1466.option)
			
		Else 
			
			// Cancel build process
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "build_stop")
			
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
			CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "build_stop")
			
		End if 
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End

