//%attributes = {}
// ----------------------------------------------------
// Project method: 00_NEW
// ID[2A0199468FC24025903500DE13DD6E63]
// Created 11-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
var $1 : Text

If (False:C215)
	C_TEXT:C284(00_NEW; $1)
End if 

var $entryPoint; $methodName; $projectName; $t; $worker : Text
var $window : Integer
var $formData; $menu; $menuFile; $mobileProjects; $project : Object

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$entryPoint:=$1
	
End if 

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
		00_NEW("_declarations")
		00_NEW("_init")
		
		// C_NEW_MOBILE_PROJECT
		
		$mobileProjects:=Folder:C1567("/PACKAGE/Mobile Projects")
		$mobileProjects.create()
		
		If (Shift down:C543)
			
			$projectName:=Request:C163(Get localized string:C991("mess_nameoftheproject"); \
				"test"; \
				Get localized string:C991("mess_create"))
			
			$projectName:=Choose:C955(Length:C16($projectName)=0; "test"; $projectName)
			
		Else 
			
			$projectName:="test"
			
		End if 
		
		// Create the project {
		$project:=Folder:C1567("/RESOURCES/default project").copyTo($mobileProjects; $projectName; fk overwrite:K87:5).file("project.4dmobileapp")
		$t:=$project.getText()
		PROCESS 4D TAGS:C816($t; $t)
		
		Case of 
				
				//______________________________________________________
			: (Is macOS:C1572)
				
				//
				
				//______________________________________________________
			: (Is Windows:C1573)
				
				$project.info.target:="Android"
				$t:=JSON Stringify:C1217($project; *)
				
				//______________________________________________________
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//______________________________________________________
		End case 
		
		$project.setText($t)
		
		// Open the project editor
		$window:=Open form window:C675("EDITOR"; Plain form window:K39:10; *)
		
		$worker:="4D Mobile ("+String:C10($window)+")"
		CALL WORKER:C1389($worker; "COMPILER_COMPONENT")
		
		$formData:=New object:C1471(\
			"$worker"; $worker; \
			"project"; $project.platformPath; \
			"file"; $project)
		
		If (DATABASE.isMatrix)
			
			DIALOG:C40("EDITOR"; $formData)
			
			CLOSE WINDOW:C154($window)
			
		Else 
			
			DIALOG:C40("EDITOR"; $formData; *)
			
		End if 
		
		00_NEW("_deinit")
		
		//___________________________________________________________
	: ($entryPoint="_declarations")
		
		COMPILER_COMPONENT
		
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