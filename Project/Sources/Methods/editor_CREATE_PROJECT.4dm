//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $json; $name; $t : Text
var $index : Integer
var $data; $project : Object
var $file : 4D:C1709.File
var $folder; $mobileProjects : 4D:C1709.Folder
var $error : cs:C1710.error

// Check if the database folder is writable
$error:=cs:C1710.error.new().hide()/* START HIDING ERRORS */
$file:=Folder:C1567(Database folder:K5:14; *).file("._")
OK:=Num:C11($file.create())
$file.delete()
$error.show()/* STOP HIDING ERRORS */

If (Bool:C1537(OK))
	
	// Get the folder "Mobile Projects" and make sure it exists
	$mobileProjects:=cs:C1710.path.new().projects(True:C214)
	
	// Create the project from the default
	$folder:=Folder:C1567("/RESOURCES/default project").copyTo($mobileProjects; $data.$name; fk overwrite:K87:5)
	
	// Init default values
	$file:=$folder.files().query("name = 'project'").pop()
	
	If ($file#Null:C1517)
		
		$json:=$file.getText()
		
		PROCESS 4D TAGS:C816($json; $json)
		
		$data.file:=$file
		$data.project:=$file.platformPath
		
		// Ensure that the name of the application is unique
		$project:=JSON Parse:C1218($json)
		
		If (Is macOS:C1572)
			
			If (FEATURE.with("android"))  //🚧
				
				If ($data.$apple & $data.$android)
					
					$project.info.target:=New collection:C1472("iOS"; "android")
					
				Else 
					
					// Default is iOS
					$project.info.target:=Choose:C955($data.$android; "android"; "iOS")
					
				End if 
			End if 
			
		Else 
			
			$project.info.target:="android"
			
		End if 
		
		If ($project.product.name#Null:C1517)
			
			$name:=$project.product.name
			$t:=$project.product.name
			
			// Get the folder "4D Mobile App - Mobile" and make sure it exists
			$folder:=cs:C1710.path.new().products(True:C214)
			
			While ($folder.folder($t).exists)
				
				$index:=$index+1
				$t:=$name+String:C10($index; " #####0")
				
			End while 
			
			If ($t#$name)
				
				$project.product.name:=$t
				$json:=JSON Stringify:C1217($project; *)
				
			End if 
		End if 
		
		$file.setText($json)
		
	Else 
		
		ASSERT:C1129(DATABASE.isMatrix; "The default project content is not the expected one")
		
	End if 
	
Else 
	
	ALERT:C41(Get localized string:C991("theDirectoryIsLockedOrTheDiskIsFull"))
	
End if 