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
var $data : Object
var $key : Text

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

// ----------------------------------------------------
If (FEATURE.with("wizards"))
	
	// Display the wizard
	$data:=New object:C1471(\
		"name"; Get localized string:C991("newProject"); \
		"$name"; Get localized string:C991("newProject"); \
		"$apple"; Is macOS:C1572; \
		"$android"; Is Windows:C1573; \
		"$callback"; "editor_CALLBACK"; \
		"$mainWindow"; Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *))
	
	DIALOG:C40("WIZARD_NEW_PROJECT"; $data)
	
	If (Bool:C1537(OK))
		
		editor_CREATE_PROJECT($data)
		
		If (Bool:C1537($data.file.exists))
			
			For each ($key; $data)
				
				If ($key[[1]]="_")
					
					OB REMOVE:C1226($data; $key)
					
				End if 
			End for each 
			
			// Open the project editor
			If (DATABASE.isMatrix)
				
				DIALOG:C40("EDITOR"; $data)
				
			Else 
				
				DIALOG:C40("EDITOR"; $data; *)
				
			End if 
			
		Else 
			
			CLOSE WINDOW:C154($data.$mainWindow)
			
		End if 
		
	Else 
		
		CLOSE WINDOW:C154($data.$mainWindow)
		
	End if 
	
Else 
	
	var $json; $name; $t : Text
	var $isEmpty : Boolean
	var $index; $w : Integer
	var $formData; $path; $project : Object
	var $file : 4D:C1709.File
	var $folder; $mobileProjects : 4D:C1709.Folder
	var $error : cs:C1710.error
	
	OK:=1
	
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
		
		$formData:=New object:C1471
		
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
			
			If (Is macOS:C1572)
				
				If (FEATURE.with("android"))  //🚧
					
					If ($formdata.$apple & $formdata.$android)
						
						$project.info.target:=New collection:C1472("iOS"; "android")
						
					Else 
						
						// Default is iOS
						$project.info.target:=Choose:C955($formdata.$android; "android"; "iOS")
						
					End if 
				End if 
				
			Else 
				
				$project.info.target:="android"
				
			End if 
			
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
			
			$file.setText($json)
			
			// Open the project editor
			$w:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *)
			
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
End if 

// ----------------------------------------------------
// End