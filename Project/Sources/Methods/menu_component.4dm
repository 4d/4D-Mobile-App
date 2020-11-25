//%attributes = {"invisible":true}
var $Mnu_choice : Text
var $instance : Object

$Mnu_choice:=Get selected menu item parameter:C1005

$instance:=cs:C1710.menu_component_class.new()

Case of 
		
		//______________________________________________________
	: (Length:C16($Mnu_choice)=0)
		
		// NOTHING MORE TO DO
		
	: ($instance[$Mnu_choice]=Null:C1517)
		
		ASSERT:C1129(False:C215; "Unknown menu action ("+$Mnu_choice+")")
		
		//______________________________________________________
	Else 
		
		$instance[$Mnu_choice].call($instance)
		
		//______________________________________________________
End case 