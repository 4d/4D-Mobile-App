//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_COLLAPSE_EXPAND
  // Database: 4D Mobile Express
  // ID[52BEDFA602124A318595C4062F3E7CC0]
  // Created #10-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_LONGINT:C283($1)

C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_i;$Lon_index;$Lon_j;$Lon_panelNumber)
C_LONGINT:C283($Lon_parameters;$Lon_state;$Lon_top;$Lon_vOffset)
C_POINTER:C301($Ptr_button)
C_TEXT:C284($Txt_me;$Txt_panel)

If (False:C215)
	C_LONGINT:C283(panel_COLLAPSE_EXPAND ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Lon_state:=Self:C308->
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Lon_index:=$1
		
	Else 
		
		$Lon_index:=Num:C11(Replace string:C233($Txt_me;"title.button.";""))
		
	End if 
	
	$Lon_panelNumber:=panel_Count 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Shift down:C543)\
		 & ($Lon_state=1)  // Open me and closes all others
		
		  // Open current {
		$Txt_panel:="panel."+String:C10($Lon_index)
		
		OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
		
		If ($Lon_state=1)
			
			OBJECT SET VISIBLE:C603(*;$Txt_panel;True:C214)
			$Lon_vOffset:=$Lon_bottom-$Lon_top
			
			GOTO OBJECT:C206(*;$Txt_panel)
			
			  // Give the focus to the firts object
			EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"panel_SET_FOCUS")
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;$Txt_panel;False:C215)
			$Lon_vOffset:=-($Lon_bottom-$Lon_top)
			
			  // Find for the next opened panel and selects it if any
			panel_GOTO ($Lon_index)
			
		End if 
		
		For ($Lon_i;$Lon_index+1;$Lon_panelNumber;1)
			
			OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_i);0;$Lon_vOffset)
			OBJECT MOVE:C664(*;"panel."+String:C10($Lon_i);0;$Lon_vOffset)
			
		End for 
		  //}
		
		  // Close all others {
		For ($Lon_i;1;$Lon_panelNumber;1)
			
			If ($Lon_i#$Lon_index)
				
				$Ptr_button:=OBJECT Get pointer:C1124(Object named:K67:5;"title.button."+String:C10($Lon_i))
				
				If ($Ptr_button->=1)  // Opened
					
					$Txt_panel:="panel."+String:C10($Lon_i)
					
					OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
					
					OBJECT SET VISIBLE:C603(*;$Txt_panel;False:C215)
					$Lon_vOffset:=-($Lon_bottom-$Lon_top)
					
					For ($Lon_j;$Lon_i+1;$Lon_panelNumber;1)
						
						OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_j);0;$Lon_vOffset)
						OBJECT MOVE:C664(*;"panel."+String:C10($Lon_j);0;$Lon_vOffset)
						
					End for 
					
					$Ptr_button->:=0
					
				End if 
			End if 
		End for 
		  //}
		
		  //______________________________________________________
	: (Macintosh option down:C545)  //open/close all panels
		
		For ($Lon_i;1;$Lon_panelNumber;1)
			
			$Ptr_button:=OBJECT Get pointer:C1124(Object named:K67:5;"title.button."+String:C10($Lon_i))
			
			If ($Ptr_button->#$Lon_state)\
				 | ($Lon_i=$Lon_index)
				
				$Txt_panel:="panel."+String:C10($Lon_i)
				
				OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
				
				If ($Lon_state=1)
					
					OBJECT SET VISIBLE:C603(*;$Txt_panel;True:C214)
					$Lon_vOffset:=$Lon_bottom-$Lon_top
					
				Else 
					
					OBJECT SET VISIBLE:C603(*;$Txt_panel;False:C215)
					$Lon_vOffset:=-($Lon_bottom-$Lon_top)
					
				End if 
				
				For ($Lon_j;$Lon_i+1;$Lon_panelNumber;1)
					
					OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_j);0;$Lon_vOffset)
					OBJECT MOVE:C664(*;"panel."+String:C10($Lon_j);0;$Lon_vOffset)
					
				End for 
				
				$Ptr_button->:=$Lon_state
				
			End if 
		End for 
		
		If ($Lon_state=0)
			
			CALL SUBFORM CONTAINER:C1086(-1)
			
		End if 
		
		  //______________________________________________________
	Else 
		
		$Txt_panel:="panel."+String:C10($Lon_index)
		
		OBJECT GET COORDINATES:C663(*;$Txt_panel;$Lon_;$Lon_top;$Lon_;$Lon_bottom)
		
		If ($Lon_state=1)
			
			OBJECT SET VISIBLE:C603(*;$Txt_panel;True:C214)
			$Lon_vOffset:=$Lon_bottom-$Lon_top
			
			GOTO OBJECT:C206(*;$Txt_panel)
			
			  // Give the focus to the firts object
			EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"panel_SET_FOCUS")
			
		Else 
			
			OBJECT SET VISIBLE:C603(*;$Txt_panel;False:C215)
			$Lon_vOffset:=-($Lon_bottom-$Lon_top)
			
			  // Find for the next opened panel and selects it if any
			panel_GOTO ($Lon_index)
			
		End if 
		
		For ($Lon_i;$Lon_index+1;$Lon_panelNumber;1)
			
			OBJECT MOVE:C664(*;"title.@."+String:C10($Lon_i);0;$Lon_vOffset)
			OBJECT MOVE:C664(*;"panel."+String:C10($Lon_i);0;$Lon_vOffset)
			
		End for 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End