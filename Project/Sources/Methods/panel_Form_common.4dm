//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_Form_common
  // Database: 4D Mobile Express
  // ID[5F674D01A17C4030B5D09AE0352A3681]
  // Created 12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_LONGINT:C283($0)
C_LONGINT:C283(${1})

C_LONGINT:C283($Lon_formEvent;$Lon_height;$Lon_i;$Lon_parameters;$Lon_type;$Lon_width)
C_TEXT:C284($Txt_object)

ARRAY LONGINT:C221($tLon_notCaptured;0)
ARRAY TEXT:C222($tTxt_entryOrder;0)
ARRAY TEXT:C222($tTxt_widgets;0)

If (False:C215)
	C_LONGINT:C283(panel_Form_common ;$0)
	C_LONGINT:C283(panel_Form_common ;${1})
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		For ($Lon_i;1;$Lon_parameters;1)
			
			APPEND TO ARRAY:C911($tLon_notCaptured;${$Lon_i})
			
		End for 
	End if 
	
	$Lon_formEvent:=Form event code:C388
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		  // Place the background & the bottom line {
		FORM GET PROPERTIES:C674(Current form name:C1298;$Lon_width;$Lon_height)
		
		  //OBJECT SET COORDINATES(*;"_background";0;0;$Lon_width;$Lon_height)
		OBJECT SET COORDINATES:C1248(*;"bottom.line";16;$Lon_height-1;$Lon_width-16;$Lon_height-1)
		
		  //OBJECT GET COORDINATES(*;"viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		  //OBJECT SET COORDINATES(*;"viewport";$Lon_left;0;$Lon_right;$Lon_height)
		  //}
		
		  // ENTRY ORDER IS BASED UPON THE OBJECT NAMES {
		FORM GET OBJECTS:C898($tTxt_widgets)
		SORT ARRAY:C229($tTxt_widgets)
		
		For ($Lon_i;1;Size of array:C274($tTxt_widgets);1)
			
			$Lon_type:=OBJECT Get type:C1300(*;$tTxt_widgets{$Lon_i})
			
			If (OBJECT Get enterable:C1067(*;$tTxt_widgets{$Lon_i}))\
				 | ($Lon_type=Object type listbox:K79:8)
				
				APPEND TO ARRAY:C911($tTxt_entryOrder;$tTxt_widgets{$Lon_i})
				
			End if 
		End for 
		
		FORM SET ENTRY ORDER:C1468($tTxt_entryOrder)
		  //}
		
		  // Activate essential events to the form {
		ARRAY LONGINT:C221($tLon_events;0x0000)
		APPEND TO ARRAY:C911($tLon_events;On Load:K2:1)
		APPEND TO ARRAY:C911($tLon_events;On Unload:K2:2)
		APPEND TO ARRAY:C911($tLon_events;On Timer:K2:25)
		APPEND TO ARRAY:C911($tLon_events;On Activate:K2:9)
		APPEND TO ARRAY:C911($tLon_events;On Getting Focus:K2:7)
		APPEND TO ARRAY:C911($tLon_events;On Losing Focus:K2:8)
		
		OBJECT SET EVENTS:C1239(*;"";$tLon_events;Enable events others unchanged:K42:38)
		  //}
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Activate:K2:9)
		
		If (OBJECT Get name:C1087(Object with focus:K67:3)="")
			
			FORM GET ENTRY ORDER:C1469($tTxt_widgets)
			
			If (Size of array:C274($tTxt_widgets)>0)
				
				GOTO OBJECT:C206(*;$tTxt_widgets{1})
				
			Else 
				
				GOTO OBJECT:C206(*;"")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Getting Focus:K2:7)
		
		$Txt_object:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*;$Txt_object+".help")#Object type unknown:K79:1)
			
			  // Show help button
			OBJECT SET VISIBLE:C603(*;$Txt_object+".help";True:C214)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Losing Focus:K2:8)
		
		$Txt_object:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*;$Txt_object+".help")#Object type unknown:K79:1)
			
			  // Hide help button
			OBJECT SET VISIBLE:C603(*;$Txt_object+".help";False:C215)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
End case 

If (Find in array:C230($tLon_notCaptured;$Lon_formEvent)=-1)
	
	$Lon_formEvent:=0
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Lon_formEvent

  // ----------------------------------------------------
  // End