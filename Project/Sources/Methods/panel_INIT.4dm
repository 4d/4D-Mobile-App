//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_INIT
  // ID[6C4D51233CB94D1790FD39B385FB494F]
  // Created 11-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_height;$Lon_index;$Lon_left;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_vOffset;$Lon_width)
C_POINTER:C301($Ptr_nil)
C_TEXT:C284($Txt_form;$Txt_help;$Txt_index;$Txt_key;$Txt_panel;$Txt_title)
C_OBJECT:C1216($Obj_definition;$Obj_panel)

If (False:C215)
	C_OBJECT:C1216(panel_INIT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_definition:=$1  // Definition of the panels
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Set UI {
If ($Obj_definition.ui#Null:C1517)
	
	For each ($Txt_key;$Obj_definition.ui)
		
		Case of 
				
				  //______________________________________________________
			: ($Txt_key="background")  // Background color
				
				OBJECT SET RGB COLORS:C628(*;"_background";Background color none:K23:10;$Obj_definition.ui.background)
				
				  //______________________________________________________
			: ($Txt_key="line")  // Lines color
				
				OBJECT SET RGB COLORS:C628(*;"title.line.1";$Obj_definition.ui.line;Background color:K23:2)
				
				  //______________________________________________________
			: ($Txt_key="labels")  // Labels color
				
				OBJECT SET RGB COLORS:C628(*;"title.label.1";$Obj_definition.ui.labels;Background color:K23:2)
				
				  //________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Unknown key: \""+$Txt_key+"\"")
				
				  //______________________________________________________
		End case 
	End for each 
End if 
  //}

  // Hide all dynamique objects
OBJECT SET VISIBLE:C603(*;"title.@";False:C215)
OBJECT SET VISIBLE:C603(*;"panel.@";False:C215)
OBJECT SET VISIBLE:C603(*;"help.@";False:C215)

For each ($Obj_panel;$Obj_definition.panels)
	
	$Lon_index:=$Lon_index+1
	$Txt_index:=String:C10($Lon_index)
	$Txt_panel:="panel."+$Txt_index
	$Txt_title:="title.label."+$Txt_index
	$Txt_help:="help."+$Txt_index
	
	If (Is nil pointer:C315(OBJECT Get pointer:C1124(Object named:K67:5;$Txt_panel)))  // Duplicate
		
		  // Title
		OBJECT DUPLICATE:C1111(*;"title.label.1";$Txt_title;$Ptr_nil;"";0;$Lon_vOffset;0;0)
		
		  // help
		OBJECT DUPLICATE:C1111(*;"help.1";$Txt_help;$Ptr_nil;"";0;$Lon_vOffset;0;0)
		
		  // Panel (bound to the previous panel)
		OBJECT DUPLICATE:C1111(*;"panel.1";$Txt_panel;$Ptr_nil;"panel."+String:C10($Lon_index-1);0;$Lon_vOffset;0;0)
		
	Else   // Reuse
		
		OBJECT GET COORDINATES:C663(*;$Txt_title;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		$Lon_height:=$Lon_bottom-$Lon_top
		
		$Lon_top:=$Lon_vOffset+30
		
		$Lon_bottom:=$Lon_top+$Lon_height
		OBJECT SET COORDINATES:C1248(*;$Txt_title;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		OBJECT GET COORDINATES:C663(*;$Txt_help;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		$Lon_height:=$Lon_bottom-$Lon_top
		$Lon_top:=$Lon_vOffset+30
		$Lon_bottom:=$Lon_top+$Lon_height
		OBJECT SET COORDINATES:C1248(*;$Txt_help;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
	End if 
	
	  // Set the panel form [
	$Txt_form:=$Obj_panel.form
	FORM GET PROPERTIES:C674($Txt_form;$Lon_width;$Lon_height)
	
	OBJECT SET SUBFORM:C1138(*;$Txt_panel;$Txt_form)
	
	OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_left;$Lon_;$Lon_right;$Lon_)
	
	If (Bool:C1537($Obj_panel.noTitle))
		
		OBJECT SET VISIBLE:C603(*;$Txt_title;False:C215)
		
		$Lon_top:=$Lon_vOffset
		
	Else 
		
		  // Set the title
		OBJECT SET TITLE:C194(*;$Txt_title;$Obj_panel.title)
		
		OBJECT SET VISIBLE:C603(*;$Txt_title;True:C214)
		OBJECT SET VISIBLE:C603(*;$Txt_help;Bool:C1537($Obj_panel.help))
		
		ui_ALIGN_ON_BEST_SIZE (Align left:K42:2;$Txt_title;$Txt_help)
		
		$Lon_top:=$Lon_vOffset+60
		
	End if 
	
	$Lon_bottom:=$Lon_top+$Lon_height
	OBJECT SET COORDINATES:C1248(*;$Txt_panel;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
	  //]
	
	OBJECT SET VISIBLE:C603(*;$Txt_panel;True:C214)
	
	If ($Lon_index<$Obj_definition.panels.length)
		
		  //OBJECT SET RESIZING OPTIONS(*;$Txt_panel;Resize horizontal none;Resize vertical none)
		
		$Lon_vOffset:=$Lon_bottom
		
	Else 
		
		  // Make last panel resizable
		  //OBJECT SET RESIZING OPTIONS(*;$Txt_panel;Resize horizontal none;Resize vertical grow)
		
	End if 
End for each 

  // Finally place the background
OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
OBJECT SET COORDINATES:C1248(*;"_background";0;0;$Lon_width;$Lon_bottom)

CALL FORM:C1391(Current form window:C827;"project_SKIN";$Obj_definition)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End