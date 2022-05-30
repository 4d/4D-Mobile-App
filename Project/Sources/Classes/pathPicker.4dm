Class constructor($target; $options : Object)
	
	var $t : Text
	
	This:C1470[""]:=New object:C1471
	This:C1470[""].target:=Null:C1517
	This:C1470[""].type:=Is a document:K24:1
	This:C1470[""].options:=Package selection:K24:9+Use sheet window:K24:11
	This:C1470[""].message:=""
	This:C1470[""].placeHolder:=""
	This:C1470[""].browse:=True:C214
	This:C1470[""].showOnDisk:=True:C214
	This:C1470[""].copyPath:=True:C214
	This:C1470[""].openItem:=True:C214
	This:C1470[""].directory:=""
	This:C1470[""].fileTypes:=""
	This:C1470[""].label:=""
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			For each ($t; $options)
				
				This:C1470[$t]:=$options[$t]
				
			End for each 
		End if 
		
		If (Value type:C1509($target)=Is object:K8:27)
			
			// File or Folder
			This:C1470.target:=$target
			
		Else 
			
			If ((Position:C15(":"; String:C10($target))>0))
				
				// Platform path
				This:C1470._setPlatformPath(String:C10($target))
				
			Else 
				
				// POSIX
				This:C1470._setPath(String:C10($target))
				
			End if 
		End if 
	End if 
	
	This:C1470.__geometry()
	This:C1470.__updateLabel()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get target() : Object
	
	return This:C1470[""].target
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set target($target)
	
	If ($target#Null:C1517)\
		 && (OB Instance of:C1731($target; 4D:C1709.Folder) | OB Instance of:C1731($target; 4D:C1709.File))
		
		This:C1470[""].target:=$target
		
	Else 
		
		This:C1470[""].target:=Null:C1517
		
	End if 
	
	This:C1470.__updateLabel()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get placeHolder() : Text
	
	return This:C1470[""].placeHolder
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set placeHolder($placeholder : Text)
	
	var $t : Text
	
	$t:=Get localized string:C991($placeholder)
	$t:=Length:C16($t)>0 ? $t : $placeholder  // Revert if no localization
	This:C1470[""].placeHolder:=$t
	OBJECT SET PLACEHOLDER:C1295(*; "text"; $t+"…")
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get type() : Integer
	
	return This:C1470[""].type
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set type($type : Integer)
	
	This:C1470[""].type:=$type>1 ? Is a document:K24:1 : $type
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get options() : Integer
	
	return This:C1470[""].options
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set options($options : Integer)
	
	This:C1470[""].options:=$options
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get message() : Text
	
	return This:C1470[""].message
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set message($message : Text)
	
	var $t : Text
	
	$t:=Get localized string:C991($message)
	$t:=Length:C16($t)>0 ? $t : $message  // Revert if no localization
	This:C1470[""].message:=$t
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get browse() : Boolean
	
	return This:C1470[""].browse
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set browse($enabled : Boolean)
	
	This:C1470[""].browse:=$enabled
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get showOnDisk() : Boolean
	
	return This:C1470[""].showOnDisk
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set showOnDisk($enabled : Boolean)
	
	This:C1470[""].showOnDisk:=$enabled
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get copyPath() : Boolean
	
	return This:C1470[""].copyPath
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set copyPath($enabled : Boolean)
	
	This:C1470[""].copyPath:=$enabled
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get openItem() : Boolean
	
	return This:C1470[""].openItem
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set openItem($enabled : Boolean)
	
	This:C1470[""].openItem:=$enabled
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get directory() : Variant
	
	return This:C1470[""].directory
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set directory($directory)
	
	This:C1470[""].directory:=$directory
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get fileTypes() : Collection
	
	return This:C1470[""].fileTypes
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set fileTypes($types)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($types)=Is text:K8:3)
			
			This:C1470[""].fileTypes:=Split string:C1554($types; ";")
			
			//______________________________________________________
		: (Value type:C1509($types)=Is collection:K8:32)
			
			This:C1470[""].fileTypes:=$types
			
			//______________________________________________________
		Else 
			
			// #ERROR
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get platformPath() : Text
	
	return This:C1470[""].target#Null:C1517 ? This:C1470[""].target.platformPath : ""
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set platformPath($pathname : Text)
	
	This:C1470._setPlatformPath($pathname)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get path() : Text
	
	return This:C1470[""].target.path
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function set path($path : Text)
	
	This:C1470._setPath($path)
	
	// Mark:-
	// === === === === === === === === === === === === === === === === === === === === ===
Function _setPlatformPath($pathname : Text)
	
	If (Count parameters:C259>=1)
		
		If (Length:C16($pathname)>0)
			
			If (Path to object:C1547($pathname).isFolder)
				
				// Folder
				This:C1470[""].target:=Folder:C1567($pathname; fk platform path:K87:2)
				
			Else 
				
				// File
				This:C1470[""].target:=File:C1566($pathname; fk platform path:K87:2)
				
			End if 
			
		Else 
			
			This:C1470[""].target:=Null:C1517
			
		End if 
		
		This:C1470.__updateLabel()
		
	Else 
		
		ASSERT:C1129(False:C215; Current method name:C684+"._setPlatformPath(): Missing the PlatformPath (text) parameter")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _setPath($path : Text)
	
	If (Length:C16($path)>0)
		
		$path:=Convert path POSIX to system:C1107($path)
		
		If (Path to object:C1547($path).isFolder)
			
			// Folder
			This:C1470[""].target:=Folder:C1567($path; fk platform path:K87:2)
			
		Else 
			
			// File
			This:C1470[""].target:=File:C1566($path; fk platform path:K87:2)
			
		End if 
		
	Else 
		
		This:C1470[""].target:=Null:C1517
		
	End if 
	
	This:C1470.__updateLabel()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __select()
	
	var $t : Text
	
	$t:=This:C1470[""].fileTypes.join(";")
	
	Case of 
			
			//………………………………………………………………
		: (This:C1470[""].type=Is a document:K24:1)\
			 | (Is macOS:C1572 & (Position:C15(".app"; $t)>0))
			
			If (Value type:C1509(This:C1470[""].directory)=Is text:K8:3)
				
				$t:=Select document:C905(This:C1470[""].directory; $t; This:C1470[""].message; This:C1470[""].options)
				
			Else 
				
				// Use a memorized access path
				$t:=Select document:C905(Num:C11(This:C1470[""].directory); $t; This:C1470[""].message; This:C1470[""].options)
				
			End if 
			
			//………………………………………………………………
		: (This:C1470[""].type=Is a folder:K24:2)
			
			If (Value type:C1509(This:C1470[""].directory)=Is text:K8:3)
				
				DOCUMENT:=Select folder:C670(This:C1470[""].message; This:C1470[""].directory; This:C1470[""].options)
				
			Else 
				
				// Use a memorized access path
				DOCUMENT:=Select folder:C670(This:C1470[""].message; Num:C11(This:C1470[""].directory); This:C1470[""].options)
				
			End if 
			
			//………………………………………………………………
	End case 
	
	If (Bool:C1537(OK))
		
		This:C1470._setPlatformPath(DOCUMENT)
		This:C1470.__resume()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __displayMenu()
	
	var $menu; $folderSeparator; $t : Text
	var $bottom; $left; $right; $top : Integer
	var $c : Collection
	
	// In remote mode, the path can be in the server system format
	
	Case of 
			
			//……………………………………………………………………………………………
		: (Application type:C494=4D Remote mode:K5:5)\
			 & (Is macOS:C1572)\
			 & (Position:C15("\\"; This:C1470.platformPath)>0)
			
			// MacOS client with server on Windows
			$folderSeparator:="\\"
			
			//……………………………………………………………………………………………
		: (Application type:C494=4D Remote mode:K5:5)\
			 & (Is Windows:C1573)\
			 & (Position:C15(":"; Replace string:C233(This:C1470.platformPath; ":"; ""; 1))>0)
			
			// Windows client with server on macOS
			$folderSeparator:=":"
			
			//……………………………………………………………………………………………
		Else 
			
			$folderSeparator:=Folder separator:K24:12
			
			//……………………………………………………………………………………………
	End case 
	
	ARRAY TEXT:C222($volumes; 0x0000)
	VOLUME LIST:C471($volumes)
	
	$c:=Split string:C1554(This:C1470.platformPath; $folderSeparator)
	
	$menu:=Create menu:C408
	
	CLEAR VARIABLE:C89(DOCUMENT)
	
	For each ($t; $c)
		
		If (Is Windows:C1573)
			
			APPEND MENU ITEM:C411($menu; $t)
			
		Else 
			
			INSERT MENU ITEM:C412($menu; 0; $t)
			
		End if 
		
		// Keep the item path
		DOCUMENT:=DOCUMENT+(Folder separator:K24:12*Num:C11(Length:C16(DOCUMENT)>0))+$t
		
		// Case of
		Case of 
				
				//……………………………………………………………………………………………
			: (Find in array:C230($volumes; $t)>0)
				
				SET MENU ITEM ICON:C984($menu; -1; "path:/RESOURCES/pathPicker/drive.png")
				
				//……………………………………………………………………………………………
			: (Test path name:C476(DOCUMENT)=Is a folder:K24:2)
				
				SET MENU ITEM ICON:C984($menu; -1; "path:/RESOURCES/pathPicker/folder.png")
				
				//……………………………………………………………………………………………
			: (Test path name:C476(DOCUMENT)=Is a document:K24:1)
				
				SET MENU ITEM ICON:C984($menu; -1; "path:/RESOURCES/pathPicker/file.png")
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				SET MENU ITEM STYLE:C425($menu; -1; Italic:K14:3)
				DISABLE MENU ITEM:C150($menu; -1)
				
				//……………………………………………………………………………………………
		End case 
		
		SET MENU ITEM PARAMETER:C1004($menu; -1; DOCUMENT)
		
	End for each 
	
	If (Count menu items:C405($menu)>0)
		
		If (Bool:C1537(This:C1470[""].showOnDisk))\
			 | (Bool:C1537(This:C1470[""].copyPath))
			
			APPEND MENU ITEM:C411($menu; "-")
			
		End if 
		
		If (Bool:C1537(This:C1470[""].showOnDisk))
			
			APPEND MENU ITEM:C411($menu; Get localized string:C991("ShowOnDisk"))
			SET MENU ITEM PARAMETER:C1004($menu; -1; "show")
			
		End if 
		
		If (Bool:C1537(This:C1470[""].copyPath))
			
			APPEND MENU ITEM:C411($menu; Get localized string:C991("CopyPath"))
			SET MENU ITEM PARAMETER:C1004($menu; -1; "copy")
			
		End if 
		
		OBJECT GET COORDINATES:C663(*; "border"; $left; $top; $right; $bottom)
		CONVERT COORDINATES:C1365($left; $bottom; 1; 2)
		
		$t:=Dynamic pop up menu:C1006($menu; ""; $left; $bottom-5)
		RELEASE MENU:C978($menu)
		
		Case of 
				
				//……………………………………………………………………………………………
			: (Length:C16($t)=0)
				
				//……………………………………………………………………………………………
			: ($t="copy")
				
				SET TEXT TO PASTEBOARD:C523(DOCUMENT)
				
				//……………………………………………………………………………………………
			: ($t="show")
				
				SHOW ON DISK:C922(DOCUMENT)
				
				//……………………………………………………………………………………………
			: (Not:C34(Bool:C1537(This:C1470[""].openItem)))
				
				// NOTHING MORE TO DO
				
				//……………………………………………………………………………………………
			Else 
				
				SHOW ON DISK:C922($t)
				
				//……………………………………………………………………………………………
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __onDrag() : Integer
	
	return (-1+Num:C11(Test path name:C476(Get file from pasteboard:C976(1))=Num:C11(This:C1470[""].type)))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __onDrop
	
	DOCUMENT:=Get file from pasteboard:C976(1)
	
	If (Test path name:C476(DOCUMENT)=Num:C11(This:C1470[""].type))
		
		If (Position:C15(Path to object:C1547(DOCUMENT).extension; This:C1470[""].fileTypes.join(";"))>0)
			
			This:C1470._setPlatformPath(DOCUMENT)
			This:C1470.__resume()
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __updateLabel()
	
	var $folderSeparator : Text
	var $bottom; $height; $left; $right; $top; $width : Integer
	var $c : Collection
	
	If (Length:C16(This:C1470.platformPath)>0)
		
		// In remote mode, the path can be in the server system format
		Case of 
				
				//……………………………………………………………………………………………
			: (Application type:C494=4D Remote mode:K5:5)\
				 & (Is macOS:C1572)\
				 & (Position:C15("\\"; This:C1470.platformPath)>0)
				
				// MacOS client with server on Windows
				$folderSeparator:="\\"
				
				//……………………………………………………………………………………………
			: (Application type:C494=4D Remote mode:K5:5)\
				 & (Is Windows:C1573)\
				 & (Position:C15(":"; Replace string:C233(This:C1470.platformPath; ":"; ""; 1))>0)
				
				// Windows client with server on macOS
				$folderSeparator:=":"
				
				//……………………………………………………………………………………………
			Else 
				
				$folderSeparator:=Folder separator:K24:12
				
				//……………………………………………………………………………………………
		End case 
		
		$c:=Split string:C1554(This:C1470.platformPath; $folderSeparator; sk ignore empty strings:K86:1)
		
		This:C1470[""].label:=Choose:C955($c[$c.length-1]#$c[0]; \
			Replace string:C233(Replace string:C233(Get localized string:C991("FileInVolume"); "{file}"; $c[$c.length-1]); "{volume}"; $c[0]); \
			"\""+$c[$c.length-1]+"\"")
		
		OBJECT SET VISIBLE:C603(*; "menu@"; True:C214)
		OBJECT SET RGB COLORS:C628(*; "text"; Choose:C955(Bool:C1537(This:C1470[""].target.exists); Foreground color:K23:1; "red"))
		
	Else 
		
		This:C1470[""].label:=""
		OBJECT SET VISIBLE:C603(*; "menu@"; False:C215)
		
	End if 
	
	OBJECT GET COORDINATES:C663(*; "menu.expand"; $left; $top; $right; $bottom)
	OBJECT GET BEST SIZE:C717(*; "text"; $width; $height)
	
	If ($width>($right-$left))
		
		OBJECT SET HELP TIP:C1181(*; "menu.expand"; This:C1470[""].label)
		
	Else 
		
		OBJECT SET HELP TIP:C1181(*; "menu.expand"; "")
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __resume
	
	If (This:C1470.callback#Null:C1517)
		
		This:C1470.callback.call()
		
	Else 
		
		CALL SUBFORM CONTAINER:C1086(On Data Change:K2:15)
		
		OBJECT SET SUBFORM CONTAINER VALUE:C1784(OBJECT Get subform container value:C1785)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __geometry()
	
	var $bottom; $containerWidth; $formWidth; $l; $left; $offset : Integer
	var $right; $top : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($containerWidth; $l)
	FORM GET PROPERTIES:C674(Current form name:C1298; $formWidth; $l)
	
	$offset:=$containerWidth-$formWidth-8
	OBJECT GET COORDINATES:C663(*; "browse"; $left; $top; $right; $bottom)
	OBJECT SET COORDINATES:C1248(*; "browse"; $left+$offset; $top; $right+$offset; $bottom)
	
	$right:=$left+$offset-5
	OBJECT GET COORDINATES:C663(*; "text"; $left; $top; $l; $bottom)
	OBJECT SET COORDINATES:C1248(*; "text"; $left; $top; $right; $bottom)
	OBJECT GET COORDINATES:C663(*; "menu.expand"; $left; $top; $l; $bottom)
	OBJECT SET COORDINATES:C1248(*; "menu.expand"; $left; $top; $right; $bottom)
	OBJECT GET COORDINATES:C663(*; "border"; $left; $top; $l; $bottom)
	OBJECT SET COORDINATES:C1248(*; "border"; $left; $top; $right; $bottom)
	
	This:C1470.__ui()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function __ui()
	
	var $bottom; $l; $left; $right; $top : Integer
	
	If (This:C1470[""].browse)
		
		If (Not:C34(OBJECT Get visible:C1075(*; "browse")))
			
			OBJECT SET VISIBLE:C603(*; "browse"; True:C214)
			OBJECT GET COORDINATES:C663(*; "browse"; $left; $top; $right; $bottom)
			
			$right:=$left-5
			OBJECT GET COORDINATES:C663(*; "text"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "text"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "menu.expand"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "menu.expand"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "border"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "border"; $left; $top; $right; $bottom)
			
		End if 
		
	Else 
		
		If (OBJECT Get visible:C1075(*; "browse"))
			
			OBJECT SET VISIBLE:C603(*; "browse"; False:C215)
			OBJECT GET COORDINATES:C663(*; "browse"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "text"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "text"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "menu.expand"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "menu.expand"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "border"; $left; $top; $l; $bottom)
			OBJECT SET COORDINATES:C1248(*; "border"; $left; $top; $right; $bottom)
			
		End if 
	End if 
	
	OBJECT SET VISIBLE:C603(*; "menu@"; Length:C16(This:C1470[""].label)>0)
	OBJECT SET PLACEHOLDER:C1295(*; "text"; This:C1470[""].placeHolder+"…")
	
	If (This:C1470[""].target#Null:C1517)
		
		If (Bool:C1537(This:C1470[""].target.exists))
			
			OBJECT SET RGB COLORS:C628(*; "text"; Foreground color:K23:1)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; "text"; "red")
			
		End if 
	End if 