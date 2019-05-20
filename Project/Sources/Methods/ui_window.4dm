//%attributes = {"invisible":true}
/*
Object := ***ui_window*** ( action )
 -> action (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : ui_window
  // Database: 4D Mobile App
  // ID[7E05BC0459A1470590F0929CD0EA5238]
  // Created #12-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_bottom;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top)
C_TEXT:C284($Txt_action)

If (False:C215)
	C_OBJECT:C1216(ui_window ;$0)
	C_TEXT:C284(ui_window ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (This:C1470=Null:C1517)
		
		ASSERT:C1129(False:C215;"This method must be called from an member method")
		
		  //______________________________________________________
	: (Length:C16($Txt_action)=0)
		
		This:C1470.title:=This:C1470.getTitle()
		This:C1470.type:=This:C1470.getType()
		This:C1470.frontmost:=This:C1470.isFrontmost()
		This:C1470.next:=This:C1470.getNext()
		This:C1470._coordinates()
		
		  //______________________________________________________
	: ($Txt_action="coordinates")
		
		GET WINDOW RECT:C443($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;This:C1470.reference)
		
		This:C1470.coordinates:=New object:C1471(\
			"left";$Lon_left;\
			"top";$Lon_top;\
			"right";$Lon_right;\
			"bottom";$Lon_bottom;\
			"width";$Lon_right-$Lon_left;\
			"height";$Lon_bottom-$Lon_top)
		
		This:C1470.screen:=New object:C1471(\
			"number";0)
		
		Repeat 
			
			This:C1470.screen.number:=This:C1470.screen.number+1
			
			SCREEN COORDINATES:C438($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;This:C1470.screen.number)
			
			This:C1470.screen.left:=$Lon_left
			This:C1470.screen.right:=$Lon_right
			This:C1470.screen.width:=$Lon_right-$Lon_left
			This:C1470.screen.height:=$Lon_bottom-$Lon_top
			
		Until ((This:C1470.screen.left<=$Lon_right)\
			 | (This:C1470.screen.number=Count screens:C437))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=This:C1470
  // ----------------------------------------------------
  // End