//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DEVELOPER_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[9FD07CDE398243019D754AD0569D3546]
  // Created #21-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_left;$Lon_parameters;$Lon_right;$Lon_top;$Lon_x)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_main;$Txt_choice;$Txt_me)
C_OBJECT:C1216($Obj_form;$Obj_team)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=DEVELOPER_Handler (New object:C1471(\
		"action";"init"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.team)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				Form:C1466.organization.teamId:=$Ptr_me->
				
				  // Save project
				ui.saveProject()
				
				$Lon_x:=$Obj_form.form.team.extract("id").indexOf($Ptr_me->)
				
				If ($Lon_x#-1)
					
					(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.team))->:=$Obj_form.form.team[$Lon_x].menu
					
				Else 
					
					  // Keep the user entry
					
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  // Update UI
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"updateRibbon")
		
		  //==================================================
	: ($Txt_me=$Obj_form.teamMenu)
		
		$Mnu_main:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_main;Get localized string:C991("none"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"none")
		
		If (String:C10(Form:C1466.organization.teamId)="")
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		If ($Obj_form.form.team.length>0)
			
			APPEND MENU ITEM:C411($Mnu_main;"-")
			
			For each ($Obj_team;$Obj_form.form.team)
				
				APPEND MENU ITEM:C411($Mnu_main;$Obj_team.menu;*)
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;$Obj_team.id)
				
				If (Form:C1466.organization.teamId=$Obj_team.id)
					
					SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
					
				End if 
			End for each 
		End if 
		
		OBJECT GET COORDINATES:C663(*;$Obj_form.team+".border";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		CONVERT COORDINATES:C1365($Lon_left;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
		$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main;"";$Lon_left;$Lon_bottom)
		RELEASE MENU:C978($Mnu_main)
		
		If (Length:C16($Txt_choice)>0)
			
			If ($Txt_choice#Form:C1466.organization.teamId)
				
				Form:C1466.organization.teamId:=Choose:C955($Txt_choice="none";"";$Txt_choice)
				
				  // Save project
				ui.saveProject()
				
				  // UI
				$Lon_x:=$Obj_form.form.team.extract("id").indexOf($Txt_choice)
				
				If ($Lon_x=-1)
					
					  // None
					(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.team))->:=""
					
				Else 
					
					(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.team))->:=$Obj_form.form.team[$Lon_x].menu
					
				End if 
			End if 
		End if 
		
		  // Update UI
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"updateRibbon")
		
		  //==================================================
	: ($Txt_me=($Obj_form.team+".help"))
		
		OPEN URL:C673(Get localized string:C991("doc_team");*)
		
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