//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : search_OBJECTS_HANDLER
  // ID[1F44951160F643B993A29A321D239EEE]
  // Created 11-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me="box")
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)\
				 | ($Lon_formEvent=On Unload:K2:2)
				
				  // Restore default properties & positions
				  //OBJECT SET RGB COLORS(*;"border";0x00E5E5E5;Background color) #MOJAVE_TURN_AROUND
				OBJECT SET RGB COLORS:C628(*;"border";0x00E5E5E5;0x00FFFFFF)
				
				search_HANDLER (New object:C1471(\
					"action";"collapse"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Getting Focus:K2:7)
				
				  //OBJECT SET RGB COLORS(*;"border";Highlight menu background color;Background color) #MOJAVE_TURN_AROUND
				OBJECT SET RGB COLORS:C628(*;"border";Highlight menu background color:K23:7;0x00FFFFFF)
				
				search_HANDLER (New object:C1471(\
					"action";"expand"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Losing Focus:K2:8)
				
				If (Length:C16(Get edited text:C655)=0)
					
					search_HANDLER (New object:C1471(\
						"action";"collapse"))
					
				End if 
				
				  //OBJECT SET RGB COLORS(*;"border";0x00E5E5E5;Background color) #MOJAVE_TURN_AROUND
				OBJECT SET RGB COLORS:C628(*;"border";0x00E5E5E5;0x00FFFFFF)
				
				  //______________________________________________________
			: ($Lon_formEvent=On After Edit:K2:43)
				
				  // Restore default colors
				  //OBJECT SET RGB COLORS(*;"box";Foreground color;Background color) #MOJAVE_TURN_AROUND
				OBJECT SET RGB COLORS:C628(*;"box";Foreground color:K23:1;0x00FFFFFF)
				
				Form:C1466.value:=Get edited text:C655
				
				CALL SUBFORM CONTAINER:C1086(-1)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessary ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		OBJECT SET VISIBLE:C603(*;"close";Length:C16(String:C10(Form:C1466.value))#0)
		
		  //==================================================
	: ($Txt_me="close")
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5;"box")->)
				OBJECT SET VISIBLE:C603(*;$Txt_me;False:C215)
				
				Form:C1466.value:=""
				
				CALL SUBFORM CONTAINER:C1086(-1)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Txt_me="button")
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				GOTO OBJECT:C206(*;"box")
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End