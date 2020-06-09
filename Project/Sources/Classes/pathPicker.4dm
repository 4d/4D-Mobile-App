Class constructor
	
	var $1
	var $2 : Object
	
	This:C1470.type:=Is a document:K24:1
	
	This:C1470.options:=Package selection:K24:9+Use sheet window:K24:11
	
	This:C1470.browse:=True:C214
	This:C1470.showOnDisk:=True:C214
	This:C1470.copyPath:=True:C214
	This:C1470.openItem:=True:C214
	This:C1470.directory:=""
	This:C1470.fileTypes:=""
	
	This:C1470.target:=Null:C1517
	This:C1470.platformPath:=""
	This:C1470.path:=""
	This:C1470.label:=""
	This:C1470.message:=""
	This:C1470.placeHolder:=""
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			var $t : Text
			
			For each ($t;$2)
				
				This:C1470[$t]:=$2[$t]
				
			End for each 
		End if 
		
		If (Value type:C1509($1)=Is object:K8:27)
			
			  // File or Folder
			This:C1470.setTarget($1)
			
		Else 
			
			If ((Position:C15(":";String:C10($1))>0))
				
				  // Platform path
				This:C1470.setPlatformPath(String:C10($1))
				
			Else 
				
				  // POSIX
				This:C1470.setPath(String:C10($1))
				
			End if 
		End if 
	End if 
	
	This:C1470.geometry()
	This:C1470._updateLabel()
	
	  //===================================================
Function setType
	
	var $1 : Integer
	
	If (Count parameters:C259>=1)
		
		This:C1470.type:=$1
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the type (integer) parameter")
		
	End if 
	
	  //===================================================
Function setMessage
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.message:=$1
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the message (text) parameter")
		
	End if 
	
	  //===================================================
Function setPlaceholder
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.placeHolder:=$1
		OBJECT SET PLACEHOLDER:C1295(*;"label";This:C1470.placeHolder)
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the placeHolder (text) parameter")
		
	End if 
	
	  //===================================================
Function setTarget
	
	var $1 : Object
	
	If (Count parameters:C259>=1)
		
		If ($1#Null:C1517)
			
			If (OB Instance of:C1731($1;4D:C1709.Folder))\
				 | (OB Instance of:C1731($1;4D:C1709.File))
				
				This:C1470.target:=$1
				This:C1470.path:=$1.path
				This:C1470.platformPath:=$1.platformPath
				
				This:C1470._updateLabel()
				
			Else 
				
				ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): The passed object must be a File or a Folder")
				
			End if 
			
		Else 
			
			This:C1470.target:=Null:C1517
			This:C1470.path:=""
			This:C1470.platformPath:=""
			
			This:C1470._updateLabel()
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the target (File or Folder object) parameter")
		
	End if 
	
	  //===================================================
Function setPlatformPath
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.platformPath:=$1
		
		If (Length:C16($1)>0)
			
			This:C1470.path:=Convert path system to POSIX:C1106($1)
			
			If (Path to object:C1547(This:C1470.platformPath).isFolder)
				
				  // Folder
				This:C1470.target:=Folder:C1567(This:C1470.platformPath;fk platform path:K87:2)
				
			Else 
				
				  // File
				This:C1470.target:=File:C1566(This:C1470.platformPath;fk platform path:K87:2)
				
			End if 
			
		Else 
			
			This:C1470.platformPath:=""
			This:C1470.target:=Null:C1517
			
		End if 
		
		This:C1470._updateLabel()
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the PlatformPath (text) parameter")
		
	End if 
	
	  //===================================================
Function setPath
	
	var $1 : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.path:=$1
		
		If (Length:C16($1)>0)
			
			This:C1470.platformPath:=Convert path POSIX to system:C1107($1)
			
			If (Path to object:C1547(This:C1470.platformPath).isFolder)
				
				  // Folder
				This:C1470.target:=Folder:C1567(This:C1470.platformPath;fk platform path:K87:2)
				
			Else 
				
				  // File
				This:C1470.target:=File:C1566(This:C1470.platformPath;fk platform path:K87:2)
				
			End if 
			
		Else 
			
			This:C1470.platformPath:=""
			This:C1470.target:=Null:C1517
			
		End if 
		
		This:C1470._updateLabel()
		
	Else 
		
		ASSERT:C1129(False:C215;Current method name:C684+".setTarget(): Missing the Path (text) parameter")
		
	End if 
	
	  //===================================================
Function select
	
	var $t
	
	Case of 
			
			  //………………………………………………………………
		: (This:C1470.type=Is a document:K24:1)\
			 | (Is macOS:C1572 & (Position:C15(".app";String:C10(This:C1470.fileTypes))>0))
			
			If (Value type:C1509(This:C1470.directory)=Is text:K8:3)
				
				$t:=Select document:C905(This:C1470.directory;This:C1470.fileTypes;This:C1470.message;This:C1470.options)
				
			Else 
				
				  // Use a memorized access path
				$t:=Select document:C905(Num:C11(This:C1470.directory);This:C1470.fileTypes;This:C1470.message;This:C1470.options)
				
			End if 
			
			  //………………………………………………………………
		: (This:C1470.type=Is a folder:K24:2)
			
			If (Value type:C1509(This:C1470.directory)=Is text:K8:3)
				
				$t:=Select folder:C670(This:C1470.message;This:C1470.directory;This:C1470.options)
				
			Else 
				
				  // Use a memorized access path
				$t:=Select folder:C670(This:C1470.message;Num:C11(This:C1470.directory);This:C1470.options)
				
			End if 
			
			  //………………………………………………………………
	End case 
	
	If (Bool:C1537(OK))
		
		This:C1470.setPlatformPath(DOCUMENT)
		This:C1470._resume()
		
	End if 
	
	  //===================================================
Function displayMenu
	
	  // In remote mode, the path can be in the server system format
	var $sep : Text
	
	Case of 
			
			  //……………………………………………………………………………………………
		: (Application type:C494=4D Remote mode:K5:5)\
			 & (Is macOS:C1572)\
			 & (Position:C15("\\";This:C1470.platformPath)>0)
			
			  // macOS client with server on Windows
			$sep:="\\"
			
			  //……………………………………………………………………………………………
		: (Application type:C494=4D Remote mode:K5:5)\
			 & (Is Windows:C1573)\
			 & (Position:C15(":";Replace string:C233(This:C1470.platformPath;":";"";1))>0)
			
			  // Windows client with server on macOS
			$sep:=":"
			
			  //……………………………………………………………………………………………
		Else 
			
			$sep:=Folder separator:K24:12
			
			  //……………………………………………………………………………………………
	End case 
	
	ARRAY TEXT:C222($aVol;0x0000)
	VOLUME LIST:C471($aVol)
	
	var $c : Collection
	$c:=Split string:C1554(This:C1470.platformPath;$sep)
	
	var $pop : Text
	$pop:=Create menu:C408
	
	CLEAR VARIABLE:C89(DOCUMENT)
	
	var $t : Text
	
	For each ($t;$c)
		
		If (Is Windows:C1573)
			
			APPEND MENU ITEM:C411($pop;$t)
			
		Else 
			
			INSERT MENU ITEM:C412($pop;0;$t)
			
		End if 
		
		  // Keep the item path
		DOCUMENT:=DOCUMENT+(Folder separator:K24:12*Num:C11(Length:C16(DOCUMENT)>0))+$t
		
		  // Case of
		Case of 
				
				  //……………………………………………………………………………………………
			: (Find in array:C230($aVol;$t)>0)
				
				SET MENU ITEM ICON:C984($pop;-1;"#pathPicker/drive.png")
				
				  //……………………………………………………………………………………………
			: (Test path name:C476(DOCUMENT)=Is a folder:K24:2)
				
				SET MENU ITEM ICON:C984($pop;-1;"#pathPicker/folder.png")
				
				  //……………………………………………………………………………………………
			: (Test path name:C476(DOCUMENT)=Is a document:K24:1)
				
				SET MENU ITEM ICON:C984($pop;-1;"#pathPicker/file.png")
				
			Else 
				
				SET MENU ITEM STYLE:C425($pop;-1;Italic:K14:3)
				DISABLE MENU ITEM:C150($pop;-1)
				
				  //……………………………………………………………………………………………
		End case 
		
		
	End for each 
	
	If (Count menu items:C405($pop)>0)
		
		If (Bool:C1537(This:C1470.showOnDisk))\
			 | (Bool:C1537(This:C1470.copyPath))
			
			APPEND MENU ITEM:C411($pop;"-")
			
		End if 
		
		If (Bool:C1537(This:C1470.showOnDisk))
			
			APPEND MENU ITEM:C411($pop;Get localized string:C991("ShowOnDisk"))
			SET MENU ITEM PARAMETER:C1004($pop;-1;"show")
			
		End if 
		
		If (Bool:C1537(This:C1470.copyPath))
			
			APPEND MENU ITEM:C411($pop;Get localized string:C991("CopyPath"))
			SET MENU ITEM PARAMETER:C1004($pop;-1;"copy")
			
		End if 
		
		var $left;$top;$right;$bottom : Integer
		OBJECT GET COORDINATES:C663(*;"border";$left;$top;$right;$bottom)
		CONVERT COORDINATES:C1365($left;$bottom;1;2)
		
		$t:=Dynamic pop up menu:C1006($pop;"";$left;$bottom-5)
		RELEASE MENU:C978($pop)
		
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
			: (Not:C34(Bool:C1537(This:C1470.openItem)))
				
				  // NOTHING MORE TO DO
				
				  //……………………………………………………………………………………………
			Else 
				
				SHOW ON DISK:C922($t)
				
				  //……………………………………………………………………………………………
		End case 
	End if 
	
	  //===================================================
Function onDrag
	
	var $0 : Integer
	
	$0:=-1+Num:C11(Test path name:C476(Get file from pasteboard:C976(1))=Num:C11(This:C1470.type))
	
	  //===================================================
Function onDrop
	
	DOCUMENT:=Get file from pasteboard:C976(1)
	
	If (Test path name:C476(DOCUMENT)=Num:C11(This:C1470.type))
		
		If (Position:C15(Path to object:C1547(DOCUMENT).extension;This:C1470.fileTypes)>0)
			
			This:C1470.setPlatformPath(DOCUMENT)
			This:C1470._resume()
			
		End if 
	End if 
	
	  //===================================================
Function _updateLabel
	
	If (Length:C16(This:C1470.platformPath)>0)
		
		
		  // In remote mode, the path can be in the server system format
		Case of 
				
				  //……………………………………………………………………………………………
			: (Application type:C494=4D Remote mode:K5:5)\
				 & (Is macOS:C1572)\
				 & (Position:C15("\\";This:C1470.platformPath)>0)
				
				  // macOS client with server on Windows
				This:C1470.separator:="\\"
				
				  //……………………………………………………………………………………………
			: (Application type:C494=4D Remote mode:K5:5)\
				 & (Is Windows:C1573)\
				 & (Position:C15(":";Replace string:C233(This:C1470.platformPath;":";"";1))>0)
				
				  // Windows client with server on macOS
				This:C1470.separator:=":"
				
				  //……………………………………………………………………………………………
			Else 
				
				This:C1470.separator:=Folder separator:K24:12
				
				  //……………………………………………………………………………………………
		End case 
		
		var $c : Collection
		$c:=Split string:C1554(This:C1470.platformPath;This:C1470.separator;sk ignore empty strings:K86:1)
		
		This:C1470.label:=Choose:C955($c[$c.length-1]#$c[0];\
			Replace string:C233(Replace string:C233(Get localized string:C991("FileInVolume");"{file}";$c[$c.length-1]);"{volume}";$c[0]);\
			"\""+$c[$c.length-1]+"\"")
		
		OBJECT SET VISIBLE:C603(*;"menu@";True:C214)
		OBJECT SET RGB COLORS:C628(*;"label";Choose:C955(Bool:C1537(This:C1470.target.exists);Foreground color:K23:1;"red"))
		
	Else 
		
		This:C1470.label:=""
		OBJECT SET VISIBLE:C603(*;"menu@";False:C215)
		
	End if 
	
	  //===================================================
Function _resume
	
	If (Form:C1466.callback#Null:C1517)
		
		Form:C1466.callback.call(Form:C1466.target)
		
	Else 
		
		CALL SUBFORM CONTAINER:C1086(On Data Change:K2:15)
		
	End if 
	
	  //===================================================
Function geometry
	
	var $bottom;$l;$left;$Lon_width;$offset;$right;$top;$width : Integer
	
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width;$l)
	FORM GET PROPERTIES:C674(Current form name:C1298;$Lon_width;$l)
	
	$offset:=$width-$Lon_width-8
	OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
	OBJECT SET COORDINATES:C1248(*;"browse";$left+$offset;$top;$right+$offset;$bottom)
	
	$right:=$left+$offset-5
	OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
	OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
	OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
	OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
	OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
	OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
	
	This:C1470.ui()
	
	  //===================================================
Function ui
	
	var $bottom;$l;$left;$Lon_width;$offset;$right;$top;$width : Integer
	
	If (This:C1470.browse)
		
		If (Not:C34(OBJECT Get visible:C1075(*;"browse")))
			
			OBJECT SET VISIBLE:C603(*;"browse";True:C214)
			OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
			
			$right:=$left-5
			OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
			OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
			OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
			
		End if 
		
	Else 
		
		If (OBJECT Get visible:C1075(*;"browse"))
			
			OBJECT SET VISIBLE:C603(*;"browse";False:C215)
			OBJECT GET COORDINATES:C663(*;"browse";$left;$top;$right;$bottom)
			OBJECT GET COORDINATES:C663(*;"label";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"label";$left;$top;$right;$bottom)
			OBJECT GET COORDINATES:C663(*;"menu.expand";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"menu.expand";$left;$top;$right;$bottom)
			OBJECT GET COORDINATES:C663(*;"border";$left;$top;$l;$bottom)
			OBJECT SET COORDINATES:C1248(*;"border";$left;$top;$right;$bottom)
			
		End if 
	End if 
	
	OBJECT SET VISIBLE:C603(*;"menu@";Length:C16(This:C1470.label)>0)
	OBJECT SET PLACEHOLDER:C1295(*;"label";This:C1470.placeHolder)
	OBJECT SET RGB COLORS:C628(*;"label";Choose:C955(Bool:C1537(This:C1470.target.exists);Foreground color:K23:1;"red"))
	
	  //===================================================