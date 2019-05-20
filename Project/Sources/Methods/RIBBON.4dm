//%attributes = {"invisible":true}
/*
***RIBBON*** ( button )
 -> button (Long Integer)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : RIBBON
  // Database: 4D Mobile App
  // ID[C18FAF21205D45159B317262630D79D2]
  // Created #30-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_bottom;$Lon_button;$Lon_formEvent;$Lon_left;$Lon_parameters;$Lon_right)
C_LONGINT:C283($Lon_top)
C_TEXT:C284($Txt_me)

If (False:C215)
	C_LONGINT:C283(RIBBON ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Lon_button:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		If ($Lon_button<100)  // Tabs
			
			If (Form:C1466.tab=$Txt_me)
				
				  // Highlights
				OBJECT SET RGB COLORS:C628(*;$Txt_me;ui.selectedColor;Background color none:K23:10)
				
			Else 
				
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;Background color none:K23:10)
				
			End if 
			
		Else 
			
			If (OBJECT Get enabled:C1079(*;$Txt_me))
				
				  // Highlights
				OBJECT SET RGB COLORS:C628(*;$Txt_me;ui.selectedColor;Background color none:K23:10)
				
				Case of 
						
						  //__________________________________
					: ($Txt_me="151")  // Build & run
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("bRunTip"))
						
						  //__________________________________
					: ($Txt_me="153")  // Install
						
						OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("bInstallTip"))
						
						  //__________________________________
				End case 
				
			Else 
				
				Case of 
						
						  //__________________________________
					: ($Txt_me="151")  // Build & run
						
						Case of 
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.project)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("someResourcesAreMissingOrInvalid"))
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.xCode)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("youNeedXcodeToPerformThisOperation"))
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.dataModel)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("youMustPublishAtLeastOneFieldToPerformThisOperation"))
								
								  //…………………………………………………………………………………
						End case 
						
						  //__________________________________
					: ($Txt_me="153")  // Install
						
						Case of 
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.xCode)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("youNeedXcodeToPerformThisOperation"))
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.dataModel)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("youMustPublishAtLeastOneFieldToPerformThisOperation"))
								
								  //…………………………………………………………………………………
							: (Not:C34(Bool:C1537(Form:C1466.status.teamId)))
								
								OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("defineYourYourTeamIdToPerformThisOperation"))
								
								  //…………………………………………………………………………………
						End case 
						
						  //__________________________________
				End case 
			End if 
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		If ($Lon_button<100)  // Tabs
			
			If (Form:C1466.tab=$Txt_me)
				
				OBJECT SET RGB COLORS:C628(*;$Txt_me;Foreground color:K23:1;Background color none:K23:10)
				
			Else 
				
				  // Inverts
				OBJECT SET RGB COLORS:C628(*;$Txt_me;0x00FFFFFF;Background color none:K23:10)
				
			End if 
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Txt_me;0x00696969;Background color none:K23:10)
			
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)\
		 | ($Lon_formEvent=On Long Click:K2:37)
		
		Case of 
				
				  //……………………………………………………………………………………………………………………
			: ($Lon_button=8858)  // Switch
				
				CALL SUBFORM CONTAINER:C1086(-1)
				
				  //……………………………………………………………………………………………………………………
			: ($Lon_button<100)  // Tabs
				
				  // Move the tab background
				OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				OBJECT SET COORDINATES:C1248(*;"tab";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				  // Deselects the previous tab
				OBJECT SET RGB COLORS:C628(*;Form:C1466.tab;0x00FFFFFF;Background color none:K23:10)
				
				  // Selects the current tab
				OBJECT SET RGB COLORS:C628(*;$Txt_me;ui.selectedColor;Background color none:K23:10)
				
				If (Form:C1466.tab=$Txt_me)
					
					  // Switching
					CALL SUBFORM CONTAINER:C1086(-1)
					
				Else 
					
					Form:C1466.tab:=$Txt_me
					
					If (Form:C1466.state#"open")
						
						  // Open
						CALL SUBFORM CONTAINER:C1086(-1)
						
					End if 
				End if 
				
				  // Display the tab page
				FORM GOTO PAGE:C247($Lon_button;*)
				
				  //……………………………………………………………………………………………………………………
			Else 
				
				  // Pass to the parent
				CALL SUBFORM CONTAINER:C1086(-$Lon_button)
				
				  //……………………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End