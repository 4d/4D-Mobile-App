//%attributes = {}
// ----------------------------------------------------
// Project method: 00_OPEN
// ID[2A0199468FC24025903500DE13DD6E63]
// Created 11-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
var $1 : Text

If (False:C215)
	C_TEXT:C284(00_OPEN; $1)
End if 

var $directory; $entryPoint; $methodName; $pathName; $projectName; $t : Text
var $withDebuglog : Boolean
var $menu; $menuFile : Object

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$entryPoint:=$1
	
End if 

$withDebuglog:=True:C214  // Activate or not debug log for performance tests

// ----------------------------------------------------
Case of 
		
		//___________________________________________________________
	: (Length:C16($entryPoint)=0)
		
		$methodName:=Current method name:C684
		
		Case of 
				
				//……………………………………………………………………
			: (Method called on error:C704=$methodName)
				
				// Error handling manager
				
				//……………………………………………………………………
			Else 
				
				// This method must be executed in a unique new process
				BRING TO FRONT:C326(New process:C317($methodName; 0; "$"+$methodName; "_run"; *))
				
				//……………………………………………………………………
		End case 
		
		//___________________________________________________________
	: ($entryPoint="_run")
		
		// First launch of this method executed in a new process
		00_OPEN("_declarations")
		00_OPEN("_init")
		
		If (Shift down:C543)  // Select project
			
			$directory:=Folder:C1567("/PACKAGE/Mobile Projects").platformPath
			$entryPoint:=Select document:C905($directory; ".4dmobileapp"; ""; Package open:K24:8+Alias selection:K24:10)
			
			If (Bool:C1537(OK))
				
				$pathName:=DOCUMENT
				RESOLVE ALIAS:C695($pathName; $pathName)
				
			End if 
			
		Else   // Open project created by 00_New
			
			$projectName:=Choose:C955(Macintosh option down:C545; "test"; "New Project")
			$pathName:=Folder:C1567("/PACKAGE/Mobile Projects").platformPath+Convert path POSIX to system:C1107($projectName+"/project.4dmobileapp")
			
		End if 
		
		If (Length:C16($pathName)>0)
			
			If ($withDebuglog)
				
				For each ($t; Folder:C1567(Logs folder:K5:19).files().query("name = '4DDebugLog_@'").extract("platformPath"))
					
					DELETE DOCUMENT:C159($t)
					
				End for each 
				
				SET DATABASE PARAMETER:C642(Log command list:K37:70; "")
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 4+8)
				
			End if 
			
			C_OPEN_MOBILE_PROJECT($pathName)
			
			If ($withDebuglog)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 0)
				
			End if 
		End if 
		
		00_OPEN("_deinit")
		
		//___________________________________________________________
	: ($entryPoint="_declarations")
		
		//COMPILER_COMPONENT
		
		//___________________________________________________________
	: ($entryPoint="_init")
		
		$menuFile:=cs:C1710.menu.new().file()
		
		$menu:=cs:C1710.menu.new()\
			.append("CommonMenuFile"; $menuFile)\
			.append("CommonMenuEdit"; cs:C1710.menu.new().edit())
		
		If (DATABASE.isMatrix)
			
			file_Menu($menuFile)
			dev_Menu($menu)
			
		End if 
		
		$menu.setBar()
		
		//___________________________________________________________
	: ($entryPoint="_deinit")
		
		//
		
		//___________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point ("+$entryPoint+")")
		
		//___________________________________________________________
End case 