//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_LoadIcons
// ID[482D2AD637B84EE9914C2AD94C7E8F93]
// Created 12-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(editor_LoadIcons; $0)
	C_OBJECT:C1216(editor_LoadIcons; $1)
End if 

var $path : Text
var $p : Picture
var $i; $iconHeight; $iconWidth; $length : Integer
var $params : Object
var $host; $icons; $pathnames : Collection
var $folder : 4D:C1709.Folder

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$params:=$1
	
	// Default values
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
	$iconWidth:=50
	$iconHeight:=50
	
	If ($params.sort=Null:C1517)
		
		$params.sort:=True:C214  // default value if not defined
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//                INTERNAL RESOURCES
// ----------------------------------------------------
$folder:=cs:C1710.path.new($params.target).target
$length:=Length:C16($folder.platformPath)
$pathnames:=$folder.files(fk recursive:K87:7).query("hidden = false & name != '.@'").extract("platformPath")

If (Bool:C1537($params.sort))
	
	$pathnames:=$pathnames.sort()
	
End if 

$icons:=New collection:C1472.resize($pathnames.length)

For each ($path; $pathnames)
	
	If (UI.darkScheme) && ($path="@.svg")
		
		var $svg : cs:C1710.svg
		$svg:=cs:C1710.svg.new(File:C1566($path; fk platform path:K87:2))
		
		If ($svg.success)
			
			$svg.styleSheet(File:C1566("/RESOURCES/css/icon_dark.css"))
			$p:=$svg.picture()
			
		Else 
			
			READ PICTURE FILE:C678($path; $p)
			
		End if 
		
	Else 
		
		READ PICTURE FILE:C678($path; $p)
		
	End if 
	
	CREATE THUMBNAIL:C679($p; $p; $iconWidth; $iconHeight; Scaled to fit:K6:2)
	$icons[$i]:=$p
	$pathnames[$i]:=Replace string:C233(Delete string:C232($path; 1; $length); Folder separator:K24:12; "/")  // Keep relative posix path
	$i:=$i+1
	
End for each 

// ----------------------------------------------------
//                  USER RESOURCES
// ----------------------------------------------------
$folder:=cs:C1710.path.new("hostIcons").target

If ($folder.exists)
	
	$length:=Length:C16($folder.platformPath)
	$host:=$folder.files(fk recursive:K87:7).query("hidden = false & name != '.@'").extract("platformPath")
	
	If (Bool:C1537($params.sort))
		
		$host:=$host.sort()
		
	End if 
	
	For each ($path; $host)
		
		If (UI.darkScheme) && ($path="@.svg")
			
			var $svg : cs:C1710.svg
			$svg:=cs:C1710.svg.new(File:C1566($path; fk platform path:K87:2))
			
			If ($svg.success)
				
				$svg.styleSheet(File:C1566("/RESOURCES/css/icon_dark.css"))
				$p:=$svg.picture()
				
			Else 
				
				READ PICTURE FILE:C678($path; $p)
				
			End if 
			
		Else 
			
			READ PICTURE FILE:C678($path; $p)
			
		End if 
		
		CREATE THUMBNAIL:C679($p; $p; $iconWidth; $iconHeight; Scaled to fit:K6:2)
		$icons.push($p)
		$pathnames.push("/"+Replace string:C233(Delete string:C232($path; 1; $length); Folder separator:K24:12; "/"))  // Keep relative posix path
		
	End for each 
End if 

// ----------------------------------------------------
//                 Insert blank icon
// ----------------------------------------------------
If (UI.darkScheme) && (UI.noIcon="@.svg")
	
	var $svg : cs:C1710.svg
	$svg:=cs:C1710.svg.new(File:C1566(UI.noIcon; fk platform path:K87:2))
	
	If ($svg.success)
		
		$svg.styleSheet(File:C1566("/RESOURCES/css/icon_dark.css"))
		$p:=$svg.picture()
		
	Else 
		
		READ PICTURE FILE:C678(UI.noIcon; $p)
		
	End if 
	
Else 
	
	READ PICTURE FILE:C678(UI.noIcon; $p)
	
End if 

CREATE THUMBNAIL:C679($p; $p; $iconWidth-8; $iconHeight; Scaled to fit prop centered:K6:6)
$pathnames.insert(0; "")
$icons.insert(0; $p)

// ----------------------------------------------------
// Return
$0:=New object:C1471(\
"celluleWidth"; $iconWidth; \
"maxColumns"; 40; \
"offset"; 4; \
"thumbnailWidth"; $iconWidth; \
"noPicture"; Get localized string:C991("noMedia"); \
"pictures"; $icons; \
"pathnames"; $pathnames)