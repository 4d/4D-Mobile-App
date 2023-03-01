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
			
			var $status : Object
			var $web : 4D:C1709.WebServer
			
			$web:=WEB Server:C1674(Web server host database:K73:31)
			
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
				
				UI.runBuild($1.build)  // Relaunch the build process
				
			Else 
				
				$t:=$status.errors[0].message
				
				UI.postMessage(New object:C1471(\
					"action"; "show"; \
					"type"; "alert"; \
					"title"; Get localized string:C991("failedToStartTheWebServer"); \
					"additional"; $t))
				
			End if 
			
		Else 
			
			// Cancel build process
			UI.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	: ($description="someStructuralAdjustmentsAreNeeded")
		
		If ($validated)
			
			// Set and continue
			UI.callMeBack("allowStructureModification"; Form:C1466.option)
			
		Else 
			
			// Cancel build process
			UI.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	: ($description="productFolderAlreadyExist")
		
		If ($validated)  // Delete product folder
			
			If (Asserted:C1132($1.build#Null:C1517))
				
				If (Asserted:C1132(Test path name:C476($1.build.path)=Is a folder:K24:2))
					
					Xcode(New object:C1471(\
						"action"; "safeDelete"; \
						"path"; $1.build.path))
					
					UI.runBuild($1.build)  // Relaunch the build process
					
				End if 
			End if 
			
		Else 
			
			// Cancel build process
			UI.callMeBack("build_stop")
			
		End if 
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End