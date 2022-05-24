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

var $entryPoint; $methodName; $t : Text
var $withDebuglog : Boolean
var $file : 4D:C1709.File
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$entryPoint:=$1
	
End if 

$withDebuglog:=True:C214  // Activate or not debug log for performance tests

// ----------------------------------------------------
If (Length:C16($entryPoint)=0)
	
	$methodName:=Current method name:C684
	
	Case of 
			
			//……………………………………………………………………
		: (Method called on error:C704=$methodName)
			
			// Error handling manager
			
			//……………………………………………………………………
		Else 
			
			// This method must be executed in a unique new process
			BRING TO FRONT:C326(New process:C317($methodName; 0; "$"+$methodName; "*"; *))
			
			//……………………………………………………………………
	End case 
	
Else 
	
	// First launch of this method executed in a new process
	COMPILER_COMPONENT
	
	$menu:=cs:C1710.menu.new().defaultMinimalMenuBar()
	
	If (Component.isMatrix)
		
		file_Menu($menu.submenus[0])
		dev_Menu($menu)
		
	End if 
	
	$menu.setBar()
	
	If (Shift down:C543)  // Select project
		
		// C_OPEN_MOBILE_PROJECT
		EXECUTE METHOD:C1007("C_OPEN_MOBILE_PROJECT")
		
	Else   // Open project created by 00_New
		
		$file:=cs:C1710.path.new().projects().folder(Choose:C955(Macintosh option down:C545; "test"; "New Project")).file("project.4dmobileapp")
		
		If (Asserted:C1132($file.exists; "File not found"))
			
			If ($withDebuglog)
				
				For each ($t; Folder:C1567(Logs folder:K5:19).files().query("name = '4DDebugLog_@'").extract("platformPath"))
					
					DELETE DOCUMENT:C159($t)
					
				End for each 
				
				SET DATABASE PARAMETER:C642(Log command list:K37:70; "")
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 4+8)
				
			End if 
			
			//C_OPEN_MOBILE_PROJECT($file.platformPath)
			EXECUTE METHOD:C1007("C_OPEN_MOBILE_PROJECT"; *; $file.platformPath)
			
			If ($withDebuglog)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 0)
				
			End if 
		End if 
	End if 
End if 