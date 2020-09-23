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
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(DEVELOPER_Handler; $0)
	C_OBJECT:C1216(DEVELOPER_Handler; $1)
End if 

var $eventCode; $indx : Integer
var $context; $formData; $in; $o : Object

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$in:=$1
	
End if 

$formData:=New object:C1471(\
"window"; Current form window:C827; \
"form"; editor_INIT; \
"name"; "01_name"; \
"identifier"; "30_identifier"; \
"team"; "02_team"; \
"teamMenu"; "teamPopup")

$context:=$formData.form

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($in=Null:C1517)  // Form method
		
		$eventCode:=_o_panel_Form_common(On Load:K2:1)
		
		// ----------------------------------------------------
		Case of 
				
				//______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				$context.constraints:=New object:C1471
				
				// Team
				(OBJECT Get pointer:C1124(Object named:K67:5; $formData.team))->:=Choose:C955(\
					Length:C16(String:C10(Form:C1466.organization.teamId))=0; \
					""; \
					Form:C1466.organization.teamId)
				
				OBJECT SET ENABLED:C1123(*; $formData.teamMenu; False:C215)
				
				If (Is macOS:C1572)
					
					// Launch getting team IDs
					CALL WORKER:C1389("4D Mobile ("+String:C10($formData.window)+")"; "teamId"; New object:C1471(\
						"action"; "list"; \
						"provisioningProfiles"; True:C214; \
						"certificate"; True:C214; \
						"caller"; $formData.window; \
						"callerMethod"; "editor_CALLBACK"; \
						"callerReturn"; "teamId"))
					
				Else 
					
					// #TO_DO
					
				End if 
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($in.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($in.action="init")  // Return the form objects definition
		
		$0:=$formData
		
		//=========================================================
	: ($in.action="teamID")  // Call back from provisioningProfiles
		
		$context.team:=New collection:C1472
		
		For each ($o; $in.value)
			
			If ($context.team.extract("teamId").indexOf($o.id)=-1)  // XXX why?
				
				If ($o.id#Null:C1517)\
					 & ($context.team.extract("id").indexOf($o.id)=-1)
					
					$context.team.push(New object:C1471(\
						"id"; $o.id))
					
					If (Length:C16(String:C10($o.name))>0)
						
						$context.team[$context.team.length-1].name:=$o.name
						$context.team[$context.team.length-1].menu:=$o.name+" ("+$o.id+")"
						
					Else 
						
						$context.team[$context.team.length-1].name:=""
						$context.team[$context.team.length-1].menu:=$o.id
						
					End if 
				End if 
			End if 
		End for each 
		
		If (Length:C16(Form:C1466.organization.teamId)=0)
			
			// No team : Affect the first one if any
			If ($context.team.length>0)
				
				Form:C1466.organization.teamId:=$context.team[0].id
				
				(OBJECT Get pointer:C1124(Object named:K67:5; $formData.team))->:=$context.team[0].menu
				
				PROJECT.save()
				
			End if 
			
		Else 
			
			// Restore the current value
			$indx:=$context.team.extract("id").indexOf(Form:C1466.organization.teamId)
			
			If ($indx#-1)
				
				(OBJECT Get pointer:C1124(Object named:K67:5; $formData.team))->:=$context.team[$indx].menu
				
			Else 
				
				// Keep the saved value
				(OBJECT Get pointer:C1124(Object named:K67:5; $formData.team))->:=Form:C1466.organization.teamId
				
			End if 
		End if 
		
		OBJECT SET ENABLED:C1123(*; $formData.teamMenu; True:C214)
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($in.action)+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// End