//%attributes = {"invisible":true}
#DECLARE($data : Object)

If (False:C215)
	C_OBJECT:C1216(editor_CREATE_PROJECT; $1)
End if 

var $json; $name; $newName : Text
var $index : Integer
var $project : Object
var $file : 4D:C1709.File
var $folder; $mobileProjects : 4D:C1709.Folder

If (Database.isWritable())
	
/*
Xcode automatically creates a "Test" target for each iOS project.
So we have to rename the project to avoid any conflict.
*/
	
	$data.$name:=$data.$name="test" ? $data.$name+" App" : $data.$name
	
	// Get the folder "Mobile Projects" and make sure it exists
	$mobileProjects:=cs:C1710.path.new().projects(True:C214)
	
	// Create the project from the default
	$folder:=Folder:C1567("/RESOURCES/default project").copyTo($mobileProjects; $data.$name; fk overwrite:K87:5)
	
	// Init default values
	$file:=$folder.files().query("name = 'project'").pop()
	
	If ($file#Null:C1517)
		
		$json:=$file.getText()
		
		PROCESS 4D TAGS:C816($json; $json; New object:C1471(\
			"ideVersion"; Motor._version; \
			"ideBuildVersion"; String:C10(Motor.buildNumber); \
			"componentBuild"; String:C10(Component.buildNumber); \
			"organizationName"; Get localized string:C991("companyName"); \
			"organization"; UI.str.setText(Get localized string:C991("companyName")).lowerCamelCase(); \
			"productName"; Get localized string:C991("newApplication"); \
			"year"; String:C10(Year of:C25(Current date:C33)); \
			"reserved"; Get localized string:C991("allRightsReserved"); \
			"bundle"; formatString("bundleApp"; Get localized string:C991("newApplication")); \
			"developerName"; Current system user:C484))
		
		$data.folder:=$folder
		$data.file:=$file
		
		$data.project:=$file.platformPath
		
		$project:=JSON Parse:C1218($json)
		
		If (Is macOS:C1572)
			
			$project.info.target:=(Bool:C1537($data.$ios) & Bool:C1537($data.$android))\
				 ? New collection:C1472("iOS"; "android")\
				 : Bool:C1537($data.$android) ? "android" : "iOS"  // Default is iOS
			
		Else 
			
			$project.info.target:="android"
			
		End if 
		
		// Ensure that the name of the application is unique
		If ($project.product.name#Null:C1517)
			
			$name:=$project.product.name
			$newName:=$name
			
			// Get the folder "4D Mobile App - Mobile" and make sure it exists
			$folder:=cs:C1710.path.new().products(True:C214)
			
			While ($folder.folder($newName).exists)
				
				$index:=$index+1
				$newName:=$name+String:C10($index; " #####0")
				
			End while 
			
			$project.product.name:=$newName#$name ? $newName : $name
			
		End if 
		
		$file.setText(JSON Stringify:C1217($project; *))
		
	Else 
		
		ASSERT:C1129(Database.isComponent; "The default project content is not the expected one")
		
	End if 
	
Else 
	
	ALERT:C41(Get localized string:C991("theDirectoryIsLockedOrTheDiskIsFull"))
	
End if 