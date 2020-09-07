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
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i; $kLon_iconWidth; $l; $Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($folder; $o; $Obj_in)
C_COLLECTION:C1488($Col_hostpathnames; $Col_pathnames; $Col_pictures)

ARRAY TEXT:C222($tFile_icons; 0)

If (False:C215)
	C_OBJECT:C1216(editor_LoadIcons; $0)
	C_OBJECT:C1216(editor_LoadIcons; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Default values
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$kLon_iconWidth:=50
	
	If ($Obj_in.sort=Null:C1517)
		
		$Obj_in.sort:=True:C214  // default value if not defined
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//                INTERNAL RESOURCES
// ----------------------------------------------------
$folder:=COMPONENT_Pathname($Obj_in.target)
$l:=Length:C16($folder.platformPath)

If (True:C214)
	
	$Col_pathnames:=$folder.files(fk recursive:K87:7).query("hidden = false & name != '.@'").extract("platformPath")
	
	If (Bool:C1537($Obj_in.sort))
		
		$Col_pathnames:=$Col_pathnames.sort()
		
	End if 
	
	$Col_pictures:=New collection:C1472.resize($Col_pathnames.length)
	
	For each ($t; $Col_pathnames)
		
		READ PICTURE FILE:C678($t; $p)
		CREATE THUMBNAIL:C679($p; $p; $kLon_iconWidth; $kLon_iconWidth; Scaled to fit:K6:2)
		$Col_pictures[$i]:=$p
		$Col_pathnames[$i]:=Replace string:C233(Delete string:C232($t; 1; $l); Folder separator:K24:12; "/")  // Keep relative posix path
		$i:=$i+1
		
	End for each 
	
Else 
	
	//$Col_pathnames:=$folder.files(fk recursive).query("hidden = false & name != '.@'")
	
	//  //If (Bool($Obj_in.sort))
	
	//  //$Col_pathnames:=$c$Col_pathnamessort()
	
	//  //End if
	
	//$Col_pictures:=New collection.resize($Col_pathnames.length)
	
	//For each ($o;$Col_pathnames)
	
	//If ($o.extension=".zip")
	
	//For each ($oo;ZIP Read archive($o).root.files())
	
	//READ PICTURE FILE($o.platformPath;$p)
	//CREATE THUMBNAIL($p;$p;$kLon_iconWidth;$kLon_iconWidth;Scaled to fit)
	//$Col_pictures[$i]:=$p
	//$Col_pathnames[$i]:=Delete string($oo.path;1;$l)  // Keep relative posix path
	//$i:=$i+1
	
	//End for each
	
	//Else
	
	//READ PICTURE FILE($t;$p)
	//CREATE THUMBNAIL($p;$p;$kLon_iconWidth;$kLon_iconWidth;Scaled to fit)
	//$Col_pictures[$i]:=$p
	//$Col_pathnames[$i]:=Replace string(Delete string($t;1;$l);Folder separator;"/")  // Keep relative posix path
	//$i:=$i+1
	
	//End if
	
	//$i:=$i+1
	
	//End for each
	
	
	
	
End if 

// ----------------------------------------------------
//                  USER RESOURCES
// ----------------------------------------------------
$folder:=COMPONENT_Pathname("host_"+$Obj_in.target)

If ($folder.exists)
	
	$l:=Length:C16($folder.platformPath)
	
	$Col_hostpathnames:=$folder.files(fk recursive:K87:7).query("hidden = false & name != '.@'").extract("platformPath")
	
	If (Bool:C1537($Obj_in.sort))
		
		$Col_hostpathnames:=$Col_hostpathnames.sort()
		
	End if 
	
	For each ($t; $Col_hostpathnames)
		
		READ PICTURE FILE:C678($t; $p)
		CREATE THUMBNAIL:C679($p; $p; $kLon_iconWidth; $kLon_iconWidth; Scaled to fit:K6:2)
		$Col_pictures.push($p)
		$Col_pathnames.push("/"+Replace string:C233(Delete string:C232($t; 1; $l); Folder separator:K24:12; "/"))  // Keep relative posix path
		
	End for each 
End if 

// ----------------------------------------------------
//                 Insert blank icon
// ----------------------------------------------------
READ PICTURE FILE:C678(UI.noIcon; $p)
CREATE THUMBNAIL:C679($p; $p; $kLon_iconWidth-8; $kLon_iconWidth-8; Scaled to fit:K6:2)
$Col_pathnames.insert(0; "")
$Col_pictures.insert(0; $p)

$o:=New object:C1471(\
"celluleWidth"; $kLon_iconWidth; \
"maxColumns"; 40; \
"offset"; 5; \
"thumbnailWidth"; $kLon_iconWidth; \
"noPicture"; Get localized string:C991("noMedia"); \
"pictures"; $Col_pictures; \
"pathnames"; $Col_pathnames)

// ----------------------------------------------------
// Return
$0:=$o

// ----------------------------------------------------
// End