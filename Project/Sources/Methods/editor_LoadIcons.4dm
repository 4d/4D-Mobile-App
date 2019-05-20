//%attributes = {"invisible":true}
/*
o := ***editor_LoadIcons*** ( in )
 -> in (Object)
 <- o (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : editor_LoadIcons
  // Database: 4D Mobile App
  // ID[482D2AD637B84EE9914C2AD94C7E8F93]
  // Created #12-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($kLon_iconWidth;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($Dir_root;$File_)
C_OBJECT:C1216($o;$Obj_in)
C_COLLECTION:C1488($Col_hostpathnames;$Col_pathnames;$Col_pictures)

ARRAY TEXT:C222($tFile_icons;0)

If (False:C215)
	C_OBJECT:C1216(editor_LoadIcons ;$0)
	C_OBJECT:C1216(editor_LoadIcons ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
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
  // INTERNAL RESOURCES ------------------------------ [
$Col_pathnames:=New collection:C1472()
$Col_pictures:=New collection:C1472()

$Dir_root:=_o_Pathname ($Obj_in.target)+Folder separator:K24:12
DOCUMENT LIST:C474($Dir_root;$tFile_icons;Absolute path:K24:14+Recursive parsing:K24:13+Ignore invisible:K24:16)
ARRAY TO COLLECTION:C1563($Col_pathnames;$tFile_icons)

If (Bool:C1537($Obj_in.sort))
	
	$Col_pathnames:=$Col_pathnames.sort()
	
End if 

For each ($File_;$Col_pathnames)
	
	  // Get the picture
	READ PICTURE FILE:C678($File_;$p)
	
	CREATE THUMBNAIL:C679($p;$p;$kLon_iconWidth;$kLon_iconWidth;Scaled to fit:K6:2)
	
	$Col_pictures.push($p)
	
End for each 

  // Store relative path
$Col_pathnames:=$Col_pathnames.map("col_replaceString";$Dir_root;"")

  // -------------------------------------------------- ]

  // USER RESOURCES ----------------------------------- [
$Dir_root:=_o_Pathname ("host_"+$Obj_in.target)+Folder separator:K24:12

If (Test path name:C476($Dir_root)=Is a folder:K24:2)
	
	DOCUMENT LIST:C474($Dir_root;$tFile_icons;Absolute path:K24:14+Recursive parsing:K24:13+Ignore invisible:K24:16)
	
	$Col_hostpathnames:=New collection:C1472()
	ARRAY TO COLLECTION:C1563($Col_hostpathnames;$tFile_icons)
	
	If (Bool:C1537($Obj_in.sort))
		
		$Col_hostpathnames:=$Col_hostpathnames.sort()
		
	End if 
	
	For each ($File_;$Col_hostpathnames)
		
		  // Get the picture
		READ PICTURE FILE:C678($File_;$p)
		CREATE THUMBNAIL:C679($p;$p;$kLon_iconWidth;$kLon_iconWidth;Scaled to fit:K6:2)
		$Col_pictures.push($p)
		
	End for each 
	
	  // Store relative path with a separator at begining for host icones
	$Col_hostpathnames:=$Col_hostpathnames.map("col_replaceString";$Dir_root;Folder separator:K24:12)
	
	  // Then add
	$Col_pathnames:=$Col_pathnames.concat($Col_hostpathnames)
	
End if 

  // Keep posix path
$Col_pathnames:=$Col_pathnames.map("col_replaceString";Folder separator:K24:12;"/")  // Manage ourselve the conversion #100589

  // -------------------------------------------------- ]

  // Insert blank icon -------------------------------- [
READ PICTURE FILE:C678(ui.noIcon;$p)
CREATE THUMBNAIL:C679($p;$p;$kLon_iconWidth-8;$kLon_iconWidth-8;Scaled to fit:K6:2)
$Col_pathnames.insert(0;"")
$Col_pictures.insert(0;$p)

  // -------------------------------------------------- ]

$o:=New object:C1471(\
"celluleWidth";$kLon_iconWidth;\
"maxColumns";40;\
"offset";5;\
"thumbnailWidth";$kLon_iconWidth;\
"noPicture";Get localized string:C991("noMedia"))

$o.pictures:=$Col_pictures
$o.pathnames:=$Col_pathnames

  // ----------------------------------------------------
  // Return
$0:=$o
  // ----------------------------------------------------
  // End