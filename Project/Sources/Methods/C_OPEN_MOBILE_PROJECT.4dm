//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : C_OPEN_MOBILE_PROJECT
// ID[E0BBE7A463F54391B61C51274CA84C45]
// Created 13-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// OPEN A PROJECT
// ----------------------------------------------------
// Declarations
#DECLARE($platformPath : Text)

var $key : Text
var $android; $blank; $icon; $iOS : Picture
var $data; $o; $manifest : Object
var $c : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $projects : cs:C1710.path
var $template : cs:C1710.str

If (False:C215)
	C_TEXT:C284(C_OPEN_MOBILE_PROJECT; $1)
End if 

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

// ----------------------------------------------------

If (FEATURE.with("wizards"))
	
	$data:=New object:C1471(\
		"$callback"; "editor_CALLBACK"; \
		"$mainWindow"; Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *))
	
	If (Count parameters:C259>=1)
		
		$file:=File:C1566($platformPath; fk platform path:K87:2)
		OK:=Num:C11($file.exists)
		
		If (Bool:C1537(OK))
			
			$data.file:=$file
			$data.folder:=$data.file.parent
			
			$data.project:=$platformPath
			
		End if 
		
	Else 
		
		// Prepare the project list
		$template:=cs:C1710.str.new("<span style='color:dimgray'><span style='font-size: 14pt;font-weight: bold'>"\
			+"{title}"\
			+"</span>"\
			+"<br/>"\
			+"<span style='font-size: 13pt;font-weight: normal'>"\
			+"{description}"\
			+"</span></span>")
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/os/iOS-32.png").platformPath; $iOS)
		TRANSFORM PICTURE:C988($iOS; Crop:K61:7; 0; 32; 32; 32)
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/os/Android-32.png").platformPath; $android)
		TRANSFORM PICTURE:C988($android; Crop:K61:7; 0; 32; 32; 32)
		
		CREATE THUMBNAIL:C679($blank; $blank; 32; 32)
		
		$data._projects:=New collection:C1472
		
		$c:=New collection:C1472
		
		For each ($folder; cs:C1710.path.new().projects().folders())
			
			$c.push($folder.file("project.4dmobileapp"))
			
		End for each 
		
		For each ($file; $c.orderBy("modificationDate desc, modificationTime desc"))
			
			If ($file.exists)
				
				$manifest:=JSON Parse:C1218($file.getText())
				
				If (Value type:C1509($manifest.info.target)=Is collection:K8:32)
					
					COMBINE PICTURES:C987($icon; $iOS; Horizontal concatenation:K61:8; $android)
					
				Else 
					
					COMBINE PICTURES:C987($icon; $blank; Horizontal concatenation:K61:8; Choose:C955($manifest.info.target="iOS"; $iOS; $android))
					
				End if 
				
				$data._projects.push(New object:C1471(\
					"icon"; $icon; \
					"project"; $template.localized(New collection:C1472($file.parent.name; $manifest.product.name+" - v"+$manifest.product.version)); \
					"file"; $file))
				
			End if 
		End for each 
		
		DIALOG:C40("WIZARD_OPEN_PROJECT"; $data)
		
	End if 
	
	If (Bool:C1537(OK))
		
		If ($data.folder=Null:C1517)  // Double clic or shortcut
			
			$data.file:=$data._current.file
			$data.folder:=$data.file.parent
			$data.$name:=$data.folder.fullName
			
			$data.project:=$data.file.platformPath
			
		End if 
		
		// Cleaning inner objects
		For each ($o; OB Entries:C1720($data).query("key =:1"; "_@"))
			
			OB REMOVE:C1226($data; $o.key)
			
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
	
	var $directory; $pathName; $projectName : Text
	var $window : Integer
	var $formData : Object
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		$pathName:=$1  // {project file path}
		
		OK:=Num:C11(Test path name:C476($pathName)=Is a document:K24:1)
		
	Else 
		
		$directory:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects").platformPath
		
		$projectName:=Select document:C905($directory; SHARED.extension; Get localized string:C991("selectTheProjectToOpen"); Package open:K24:8+Use sheet window:K24:11)
		
		If (OK=1)
			
			$pathName:=DOCUMENT
			
		End if 
	End if 
	
	// ----------------------------------------------------
	If (OK=1)
		
		// Open the project editor
		$window:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *)
		
		$formData:=New object:C1471(\
			"project"; $pathName; \
			"file"; File:C1566($pathName; fk platform path:K87:2))
		
		If (DATABASE.isMatrix)
			
			DIALOG:C40("EDITOR"; $formData)
			CLOSE WINDOW:C154($window)
			
		Else 
			
			DIALOG:C40("EDITOR"; $formData; *)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// End