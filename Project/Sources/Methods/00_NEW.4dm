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

var $entryPoint; $methodName : Text
var $data : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$entryPoint:=$1
	
End if 

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
	
	If (Shift down:C543)
		
		// C_NEW_MOBILE_PROJECT
		EXECUTE METHOD:C1007("C_NEW_MOBILE_PROJECT")
		
	Else 
		
		$data:=New object:C1471(\
			"$name"; Get localized string:C991("newProject"); \
			"$ios"; Is macOS:C1572; \
			"$android"; Is Windows:C1573; \
			"_window"; Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *))
		
		editor_CREATE_PROJECT($data)
		
		If (Bool:C1537($data.file.exists))
			
			// Open the project editor
			If (Component.isMatrix)
				
				DIALOG:C40("EDITOR"; $data)
				CLOSE WINDOW:C154(UI.window)
				
			Else 
				
				DIALOG:C40("EDITOR"; $data; *)
				
			End if 
			
		Else 
			
			CLOSE WINDOW:C154(UI.window)
			
		End if 
	End if 
End if 