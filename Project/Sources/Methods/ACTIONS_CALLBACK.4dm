//%attributes = {"invisible":true}
#DECLARE($action : Text; $params : Object)

var $ƒ : Object

$ƒ:=panel

Case of 
		
		//=========================================================
	: ($action="loadActionIcons")  // Preload the icons
		
		$ƒ.loadIcons()
		
		//=========================================================
	: ($action="IconPickerResume")  // Return from the icons' picker
		
		$ƒ.current.icon:=$params.pathnames[$params.item-1]
		PROJECT.save()
		
		var $p : Picture
		$p:=$params.pictures[$params.item-1]
		CREATE THUMBNAIL:C679($p; $p; 24; 24; Scaled to fit:K6:2)
		
		$ƒ.current.$icon:=$p
		
		GOTO OBJECT:C206(*; "")  // Force redraw of the collection !
		Form:C1466.actions:=Form:C1466.actions
		
		$ƒ.refresh()
		
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$action+"\"")
		
		//=========================================================
End case 