//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : DEVELOPER_Handler
// ID[AAB1AC4E2B2345C18EA043C15D33DF82]
// Created 21-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent; $Lon_indx; $Lon_parameters)
C_OBJECT:C1216($o; $Obj_context; $Obj_form; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(DEVELOPER_Handler; $0)
	C_OBJECT:C1216(DEVELOPER_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window"; Current form window:C827; \
		"form"; editor_INIT; \
		"name"; "01_name"; \
		"identifier"; "30_identifier"; \
		"team"; "02_team"; \
		"teamMenu"; "teamPopup")
	
	$Obj_context:=$Obj_form.form
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1)
		
		// ----------------------------------------------------
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				$Obj_context.constraints:=New object:C1471
				
				// Team
				(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.team))->:=Choose:C955(\
					Length:C16(String:C10(Form:C1466.organization.teamId))=0; \
					""; \
					Form:C1466.organization.teamId)
				
				OBJECT SET ENABLED:C1123(*; $Obj_form.teamMenu; False:C215)
				
				If (Is macOS:C1572)
					
					// Launch getting team IDs
					CALL WORKER:C1389("4D Mobile ("+String:C10($Obj_form.window)+")"; "teamId"; New object:C1471(\
						"action"; "list"; \
						"provisioningProfiles"; True:C214; \
						"certificate"; True:C214; \
						"caller"; $Obj_form.window; \
						"callerMethod"; "editor_CALLBACK"; \
						"callerReturn"; "teamId"))
					
					
				Else 
					
					// #TO_DO
					
				End if 
				
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		//=========================================================
	: ($Obj_in.action="teamID")  // Call back from provisioningProfiles
		
		$Obj_context.team:=New collection:C1472
		
		For each ($o; $Obj_in.value)
			
			If ($Obj_context.team.extract("teamId").indexOf($o.id)=-1)  // XXX why?
				
				If ($o.id#Null:C1517)\
					 & ($Obj_context.team.extract("id").indexOf($o.id)=-1)
					
					$Obj_context.team.push(New object:C1471(\
						"id"; $o.id))
					
					If (Length:C16(String:C10($o.name))>0)
						
						$Obj_context.team[$Obj_context.team.length-1].name:=$o.name
						$Obj_context.team[$Obj_context.team.length-1].menu:=$o.name+" ("+$o.id+")"
						
					Else 
						
						$Obj_context.team[$Obj_context.team.length-1].name:=""
						$Obj_context.team[$Obj_context.team.length-1].menu:=$o.id
						
					End if 
				End if 
			End if 
		End for each 
		
		If (Length:C16(Form:C1466.organization.teamId)=0)
			
			// No team : Affect the first one if any
			If ($Obj_context.team.length>0)
				
				Form:C1466.organization.teamId:=$Obj_context.team[0].id
				
				(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.team))->:=$Obj_context.team[0].menu
				
				// Save project
				UI.saveProject()
				
			End if 
			
		Else 
			
			// Restore the current value
			$Lon_indx:=$Obj_context.team.extract("id").indexOf(Form:C1466.organization.teamId)
			
			If ($Lon_indx#-1)
				
				(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.team))->:=$Obj_context.team[$Lon_indx].menu
				
			Else 
				
				// Keep the saved value
				(OBJECT Get pointer:C1124(Object named:K67:5; $Obj_form.team))->:=Form:C1466.organization.teamId
				
			End if 
		End if 
		
		OBJECT SET ENABLED:C1123(*; $Obj_form.teamMenu; True:C214)
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($Obj_in.action)+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End