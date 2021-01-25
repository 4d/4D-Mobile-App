//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : C_NEW_MOBILE_PROJECT
// ID[574C8C3337AE4A1098BE3B5ACA721C48]
// Created 13-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $json; $name; $t : Text
var $isEmpty : Boolean
var $index; $w : Integer
var $formData; $path; $project : Object

var $folder; $mobileProjects : 4D:C1709.Folder
var $file : 4D:C1709.File
var $error : cs:C1710.error

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

OK:=1

// ----------------------------------------------------
Repeat 
	
	$name:=Request:C163(\
		Get localized string:C991("projectName"); \
		Get localized string:C991("newProject"); \
		Get localized string:C991("create"))
	
	$isEmpty:=(Length:C16($name)=0) & Bool:C1537(OK)
	
	If ($isEmpty)
		
		ALERT:C41(Get localized string:C991("theProjectNameCanNotBeEmpty"))
		
	End if 
	
Until (Not:C34($isEmpty))

If (Bool:C1537(OK))
	
	// Check if the database folder is writable
	
/* START HIDING ERRORS */
	$error:=cs:C1710.error.new()
	$error.hide()
	
	$file:=Folder:C1567(Database folder:K5:14; *).file("._")
	OK:=Num:C11($file.create())
	$file.delete()
	
/* STOP HIDING ERRORS */
	$error.show()
	
	If (Bool:C1537(OK))
		
		// Get the mobile project folder pathname
		$mobileProjects:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects")
		$mobileProjects.create()
		
		If ($mobileProjects.folder($name).exists)
			
			CONFIRM:C162(Get localized string:C991("thisProjectAlreadyExist"))
			
		End if 
		
	Else 
		
		ALERT:C41(Get localized string:C991("theDirectoryIsLockedOrTheDiskIsFull"))
		
	End if 
End if 

If (Bool:C1537(OK))
	
	If ($formData=Null:C1517)
		
		$formData:=New object:C1471
		
	End if 
	
	// Create the project
	$folder:=Folder:C1567("/RESOURCES/default project").copyTo($mobileProjects; $name; fk overwrite:K87:5)
	
	// Init default values
	$file:=$folder.files().query("name = 'project'").pop()
	
	If ($file#Null:C1517)
		
		$json:=$file.getText()
		
		PROCESS 4D TAGS:C816($json; $json)
		
		$formData.file:=$file
		$formData.project:=$file.platformPath
		
		// Ensure that the name of the application is unique
		$project:=JSON Parse:C1218($json)
		
		If ($project.product.name#Null:C1517)
			
			$t:=$project.product.name
			
			$path:=New object:C1471(\
				"parentFolder"; path.products().platformPath; \
				"isFolder"; True:C214; \
				"name"; $t)
			
			While (Test path name:C476(Object to path:C1548($path))=Is a folder:K24:2)
				
				$index:=$index+1
				$path.name:=$t+String:C10($index; " #####0")
				
			End while 
			
			If ($path.name#$project.product.name)
				
				$project.product.name:=$path.name
				$json:=JSON Stringify:C1217($project; *)
				
			End if 
		End if 
		
		Case of 
				
				//______________________________________________________
			: (Is macOS:C1572)
				
				//
				
				//______________________________________________________
			: (Is Windows:C1573)
				
				$project.info.target:="Android"
				$json:=JSON Stringify:C1217($project; *)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
		$file.setText($json)
		
		// Open the project editor
		$w:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *)
		
		// Launch the worker
		$formData.$worker:="4D Mobile ("+String:C10($w)+")"
		CALL WORKER:C1389(String:C10($formData.$worker); "COMPILER_COMPONENT")
		
		If (DATABASE.isMatrix)
			
			DIALOG:C40("EDITOR"; $formData)
			CLOSE WINDOW:C154($w)
			
		Else 
			
			DIALOG:C40("EDITOR"; $formData; *)
			
		End if 
		
	Else 
		
		ASSERT:C1129(DATABASE.isMatrix; "The default project content is not the expected one")
		
	End if 
End if 

// ----------------------------------------------------
// End