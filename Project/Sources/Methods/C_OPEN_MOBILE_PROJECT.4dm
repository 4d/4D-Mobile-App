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

If (False:C215)
	C_TEXT:C284(C_OPEN_MOBILE_PROJECT; $1)
End if 

var $android; $blank; $icon; $iOS : Picture
var $data; $manifest; $o; $project : Object
var $c : Collection
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $template : cs:C1710.str

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

// ----------------------------------------------------
$data:=New object:C1471(\
"_window"; Open form window:C675("PROJECT_EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *))

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
		+"  {title}</span><br/>"\
		+"<span style='font-size: 13pt;font-weight: normal'>"\
		+"  {description}</span></span>")
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/os/iOS.png").platformPath; $iOS)
	TRANSFORM PICTURE:C988($iOS; Crop:K61:7; 0; 0; 32; 32)  // Keep the grey one
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/os/Android-32.png").platformPath; $android)
	
	CREATE THUMBNAIL:C679($blank; $blank; 32; 32)
	
	$data._projects:=New collection:C1472
	
	$c:=New collection:C1472
	
	For each ($folder; cs:C1710.path.new().projects().folders())
		
		$file:=$folder.file("project.4dmobileapp")
		
		If ($file.exists)
			
			$project:=JSON Parse:C1218($file.getText())
			
			If (FEATURE.with("android"))
				
				If ($project.info.target#Null:C1517)
					
					$c.push($file)
					
				End if 
				
			Else 
				
				Case of 
						
						//______________________________________________________
					: (Value type:C1509($project.info.target)=Is collection:K8:32)
						
						If ($project.info.target.indexOf("android")=-1)
							
							$c.push($file)
							
						End if 
						
						//______________________________________________________
					: (Value type:C1509($project.info.target)=Is text:K8:3)
						
						If ($project.info.target#"android")
							
							$c.push($file)
							
						End if 
						
						//______________________________________________________
				End case 
			End if 
		End if 
	End for each 
	
	For each ($file; $c.orderBy("modificationDate desc, modificationTime desc"))
		
		If ($file.exists)
			
			$manifest:=JSON Parse:C1218($file.getText())
			
			If (Value type:C1509($manifest.info.target)=Is collection:K8:32)
				
				COMBINE PICTURES:C987($icon; $android; Horizontal concatenation:K61:8; $iOS)
				
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
		
		DIALOG:C40("PROJECT_EDITOR"; $data)
		CLOSE WINDOW:C154(EDITOR.window)
		
	Else 
		
		DIALOG:C40("PROJECT_EDITOR"; $data; *)
		
	End if 
	
Else 
	
	CLOSE WINDOW:C154(EDITOR.window)
	
End if 