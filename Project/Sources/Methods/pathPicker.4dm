//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : pathPicker
  // ID[812130820250490A94BEE49CF68B0828]
  // Created 5-11-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($bottom;$left;$right;$top)
C_TEXT:C284($popup;$t;$Txt_path;$Txt_Separator)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_volumes;0)

If (False:C215)
	C_OBJECT:C1216(pathPicker ;$0)
	C_TEXT:C284(pathPicker ;$1)
	C_OBJECT:C1216(pathPicker ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		"";New object:C1471;\
		"platformPath";"";\
		"type";Null:C1517;\
		"options";Null:C1517;\
		"browse";Null:C1517;\
		"showOnDisk";Null:C1517;\
		"copyPath";Null:C1517;\
		"openItem";Null:C1517;\
		"directory";Null:C1517;\
		"fileTypes";"";\
		"message";"";\
		"placeHolder";"";\
		"target";Null:C1517;\
		"setPlatformPath";Formula:C1597(pathPicker ("setPlatformPath";New object:C1471("platformPath";String:C10($1))));\
		"setTarget";Formula:C1597(pathPicker ("setTarget";$1));\
		"setOption";Formula:C1597(pathPicker ("setOption";New object:C1471("enable";Bool:C1537($1);"option";String:C10($2))));\
		"setType";Formula:C1597(pathPicker ("setType";New object:C1471("type";$1)));\
		"setMessage";Formula:C1597(pathPicker ("setMessage";New object:C1471("message";$1)));\
		"setPlaceholder";Formula:C1597(pathPicker ("setPlaceholder";New object:C1471("placeHolder";$1)));\
		"updateLabel";Formula:C1597(pathPicker ("updateLabel";New object:C1471("value";String:C10($1))));\
		"displayMenu";Formula:C1597(pathPicker ("displayMenu"));\
		"reset";Formula:C1597(pathPicker ("reset"))\
		)
	
	  // Default values
	$o.type:=Is a document:K24:1
	
	$o.options:=Package selection:K24:9+Use sheet window:K24:11
	
	$o.browse:=True:C214
	$o.showOnDisk:=True:C214
	$o.copyPath:=True:C214
	$o.openItem:=True:C214
	$o.directory:=""
	$o.fileTypes:=""
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259=2)
			
			For each ($t;$2)
				
				$o[$t]:=$2[$t]
				
			End for each 
		End if 
		
		If (Length:C16($1)#0)
			
			$o.setPlatformPath($1)
			
		End if 
	End if 
	
	  // Keep initial values to allow a reset
	$o.initial:=New object:C1471(\
		"type";$o.type;\
		"options";$o.options;\
		"browse";$o.browse;\
		"showOnDisk";$o.showOnDisk;\
		"copyPath";$o.copyPath;\
		"openItem";$o.openItem;\
		"directory";$o.directory;\
		"fileTypes";$o.fileTypes;\
		"message";$o.message;\
		"placeHolder";$o.placeHolder;\
		"platformPath";$o.platformPath;\
		"target";$o.target)
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="setOption")
			
			$c:=New collection:C1472("";"browse";"showOnDisk";"copyPath";"openItem")
			
			Case of 
					
					  //……………………………………………………………………………………………
				: ($2.option="all")\
					 | (Length:C16($2.option)=0)
					
					For each ($t;$c)
						
						If (Length:C16($t)>0)
							
							$o[$t]:=$2.enable
							
						End if 
					End for each 
					
					  //……………………………………………………………………………………………
				Else 
					
					$o[$2.option]:=$2.enable
					
					  //……………………………………………………………………………………………
			End case 
			
			  //______________________________________________________
		: ($1="setTarget")
			
			If ($2#Null:C1517)
				
				$o.platformPath:=$2.platformPath
				$o.updateLabel($o.platformPath)
				
			End if 
			
			  //______________________________________________________
		: ($1="setPlatformPath")
			
			$o.platformPath:=$2.platformPath
			$o.updateLabel($o.platformPath)
			
			  //______________________________________________________
		: ($1="setType")
			
			$o.type:=Num:C11($2.type)
			
			  //______________________________________________________
		: ($1="setMessage")
			
			$o.message:=String:C10($2.message)
			
			  //______________________________________________________
		: ($1="setPlaceholder")
			
			$o.placeHolder:=String:C10($2.placeHolder)
			
			  //______________________________________________________
		: ($1="reset")
			
			For each ($t;$o.initial)
				
				$o[$t]:=$o.initial[$t]
				
			End for each 
			
			$o.updateLabel($o.platformPath)
			
			  //______________________________________________________
		: ($1="updateLabel")
			
			If ($2.value#Null:C1517)
				
				$o.platformPath:=$2.value
				
			End if 
			
			If (Length:C16($o.platformPath)>0)
				
				  // In remote mode, the path can be in the server system format
				Case of 
						
						  //……………………………………………………………………………………………
					: (Application type:C494=4D Remote mode:K5:5)\
						 & (Is macOS:C1572)\
						 & (Position:C15("\\";$o.platformPath)>0)
						
						  // macOS client with server on Windows
						$Txt_Separator:="\\"
						
						  //……………………………………………………………………………………………
					: (Application type:C494=4D Remote mode:K5:5)\
						 & (Is Windows:C1573)\
						 & (Position:C15(":";Replace string:C233($o.platformPath;":";"";1))>0)
						
						  // Windows client with server on macOS
						$Txt_Separator:=":"
						
						  //……………………………………………………………………………………………
					Else 
						
						$Txt_Separator:=Folder separator:K24:12
						
						  //……………………………………………………………………………………………
				End case 
				
				VOLUME LIST:C471($tTxt_volumes)
				$c:=Split string:C1554($o.platformPath;$Txt_separator;sk ignore empty strings:K86:1)
				
				$o.label:=Choose:C955($c[$c.length-1]#$c[0];\
					Replace string:C233(Replace string:C233(Get localized string:C991("FileInVolume");"{file}";$c[$c.length-1]);"{volume}";$c[0]);\
					"\""+$c[$c.length-1]+"\"")
				
				If (Test path name:C476($o.platformPath)=Is a document:K24:1)
					
					  //
					$o.target:=File:C1566($o.platformPath;fk platform path:K87:2)
					
				Else 
					
					$o.target:=Folder:C1567($o.platformPath;fk platform path:K87:2)
					
				End if 
				
				OBJECT SET VISIBLE:C603(*;"menu@";True:C214)
				
			Else 
				
				$o.label:=""
				$o.target:=Null:C1517
				OBJECT SET VISIBLE:C603(*;"menu@";False:C215)
				
			End if 
			
			  //______________________________________________________
		: ($1="displayMenu")
			
			  // In remote mode, the path can be in the server system format
			Case of 
					
					  //……………………………………………………………………………………………
				: (Application type:C494=4D Remote mode:K5:5)\
					 & (Is macOS:C1572)\
					 & (Position:C15("\\";$o.platformPath)>0)
					
					  // macOS client with server on Windows
					$Txt_separator:="\\"
					
					  //……………………………………………………………………………………………
				: (Application type:C494=4D Remote mode:K5:5)\
					 & (Is Windows:C1573)\
					 & (Position:C15(":";Replace string:C233($o.platformPath;":";"";1))>0)
					
					  // Windows client with server on macOS
					$Txt_separator:=":"
					
					  //……………………………………………………………………………………………
				Else 
					
					$Txt_separator:=Folder separator:K24:12
					
					  //……………………………………………………………………………………………
			End case 
			
			VOLUME LIST:C471($tTxt_volumes)
			
			$c:=Split string:C1554($o.platformPath;$Txt_separator)
			
			$popup:=Create menu:C408
			
			For each ($t;$c)
				
				If (Is Windows:C1573)
					
					APPEND MENU ITEM:C411($popup;$t)
					
				Else 
					
					INSERT MENU ITEM:C412($popup;0;$t)
					
				End if 
				
				  // Keep the item path
				$Txt_path:=$Txt_path+(Folder separator:K24:12*Num:C11(Length:C16($Txt_path)>0))+$t
				
				  // Case of
				Case of 
						
						  //……………………………………………………………………………………………
					: (Find in array:C230($tTxt_volumes;$t)>0)
						
						SET MENU ITEM ICON:C984($popup;-1;"#pathPicker/drive.png")
						
						  //……………………………………………………………………………………………
					: (Test path name:C476($Txt_path)=Is a folder:K24:2)
						
						SET MENU ITEM ICON:C984($popup;-1;"#pathPicker/folder.png")
						
						  //……………………………………………………………………………………………
					: (Test path name:C476($Txt_path)=Is a document:K24:1)
						
						SET MENU ITEM ICON:C984($popup;-1;"#pathPicker/file.png")
						
						  //……………………………………………………………………………………………
				End case 
			End for each 
			
			If (Count menu items:C405($popup)>0)
				
				If (Bool:C1537($o.showOnDisk))\
					 | (Bool:C1537($o.copyPath))
					
					APPEND MENU ITEM:C411($popup;"-")
					
				End if 
				
				If (Bool:C1537($o.showOnDisk))
					
					APPEND MENU ITEM:C411($popup;Get localized string:C991("ShowOnDisk"))
					SET MENU ITEM PARAMETER:C1004($popup;-1;"show")
					
				End if 
				
				If (Bool:C1537($o.copyPath))
					
					APPEND MENU ITEM:C411($popup;Get localized string:C991("CopyPath"))
					SET MENU ITEM PARAMETER:C1004($popup;-1;"copy")
					
				End if 
				
				OBJECT GET COORDINATES:C663(*;"border";$left;$top;$right;$bottom)
				CONVERT COORDINATES:C1365($left;$bottom;1;2)
				
				$t:=Dynamic pop up menu:C1006($popup;"";$left;$bottom-5)
				RELEASE MENU:C978($popup)
				
				Case of 
						
						  //……………………………………………………………………………………………
					: (Length:C16($t)=0)
						
						  //……………………………………………………………………………………………
					: ($t="copy")
						
						SET TEXT TO PASTEBOARD:C523($Txt_path)
						
						  //……………………………………………………………………………………………
					: ($t="show")
						
						SHOW ON DISK:C922($Txt_path)
						
						  //……………………………………………………………………………………………
					: (Not:C34(Bool:C1537($o.openItem)))
						
						  // NOTHING MORE TO DO
						
						  //……………………………………………………………………………………………
					Else 
						
						SHOW ON DISK:C922($t)
						
						  //……………………………………………………………………………………………
				End case 
			End if 
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End