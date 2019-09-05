//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_OBJECTS_HANDLER
  // ID[52D7D7A0793F480ABC65C764E08F0C31]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left;$Lon_parameters;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_width)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($o)

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
	: ($Txt_me="message")
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						  //…………………………………………………………………………………………………
					: ($Lon_formEvent=-2)\
						 | ($Lon_formEvent=-1)  // Close
						
						OBJECT SET VISIBLE:C603(*;"message@";False:C215)
						
						If ($Ptr_me->tips.enabled)
							
							  // Restore help tips status
							$o:=ui.tips
							$o.enable()
							$o.setDuration($Ptr_me->tips.delay)
							
						End if 
						
						$Ptr_me->:=New object:C1471
						
						  //…………………………………………………………………………………………………
					Else 
						
						  // Resizing
						OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
						
						$Lon_bottom:=$Lon_top+Abs:C99($Lon_formEvent)
						
						  // Limit to the window's height [
						OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
						
						If ($Lon_bottom>($Lon_height-20))
							
							$Lon_bottom:=$Lon_height-20
							
							$Ptr_me->scrollbar:=True:C214
							$Ptr_me->:=$Ptr_me->  // Touch
							
						End if 
						  //]
						
						OBJECT SET COORDINATES:C1248(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
						
						  //…………………………………………………………………………………………………
				End case 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End