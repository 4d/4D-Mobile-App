//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_Form_common
  // ID[5F674D01A17C4030B5D09AE0352A3681]
  // Created 12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_LONGINT:C283($0)
C_LONGINT:C283(${1})

C_LONGINT:C283($height;$i;$l;$width)
C_TEXT:C284($t)
C_OBJECT:C1216($e)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_entryOrder;0)
ARRAY TEXT:C222($tTxt_widgets;0)

If (False:C215)
	C_LONGINT:C283(_o_panel_Form_common ;$0)
	C_LONGINT:C283(_o_panel_Form_common ;${1})
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

$c:=New collection:C1472

  // Optional parameters
If (Count parameters:C259>=1)
	
	For ($i;1;Count parameters:C259;1)
		
		$c.push(${$i})
		
	End for 
End if 

$e:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($e.code=On Load:K2:1)
		
		  // Place the background & the bottom line {
		FORM GET PROPERTIES:C674(Current form name:C1298;$width;$height)
		
		  //OBJECT SET COORDINATES(*;"_background";0;0;$Lon_width;$Lon_height)
		OBJECT SET COORDINATES:C1248(*;"bottom.line";16;$height-1;$width-16;$height-1)
		
		  //OBJECT GET COORDINATES(*;"viewport";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		  //OBJECT SET COORDINATES(*;"viewport";$Lon_left;0;$Lon_right;$Lon_height)
		  //}
		
		  // ENTRY ORDER IS BASED UPON THE OBJECT NAMES {
		FORM GET OBJECTS:C898($tTxt_widgets)
		SORT ARRAY:C229($tTxt_widgets)
		
		For ($i;1;Size of array:C274($tTxt_widgets);1)
			
			$l:=OBJECT Get type:C1300(*;$tTxt_widgets{$i})
			
			If (OBJECT Get enterable:C1067(*;$tTxt_widgets{$i}))\
				 | ($l=Object type listbox:K79:8)
				
				APPEND TO ARRAY:C911($tTxt_entryOrder;$tTxt_widgets{$i})
				
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
	: ($e.code=On Activate:K2:9)
		
		If (OBJECT Get name:C1087(Object with focus:K67:3)="")
			
			FORM GET ENTRY ORDER:C1469($tTxt_widgets)
			
			If (Size of array:C274($tTxt_widgets)>0)
				
				GOTO OBJECT:C206(*;$tTxt_widgets{1})
				
			Else 
				
				GOTO OBJECT:C206(*;"")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($e.code=On Getting Focus:K2:7)
		
		  // Show help button if any
		$t:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*;$t+".help")#Object type unknown:K79:1)
			
			OBJECT SET VISIBLE:C603(*;$t+".help";True:C214)
			
		End if 
		
		  //______________________________________________________
	: ($e.code=On Losing Focus:K2:8)
		
		  // Hide help button if any
		$t:=OBJECT Get name:C1087(Object with focus:K67:3)
		
		If (OBJECT Get type:C1300(*;$t+".help")#Object type unknown:K79:1)
			
			OBJECT SET VISIBLE:C603(*;$t+".help";False:C215)
			
		End if 
		
		  //______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		  //
		
		  //______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
End case 

If ($c.indexOf($e.code)=-1)
	
	$e.code:=0
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$e.code

  // ----------------------------------------------------
  // End