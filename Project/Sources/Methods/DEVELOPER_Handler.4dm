//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : DEVELOPER_Handler
// Created 21-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(DEVELOPER_Handler; $1)
End if 

var $context; $ƒ; $in; $o; $team : Object

$in:=$1

$ƒ:=panel_Definition("DEVELOPER")
$context:=$ƒ.context

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($in.action="teamID")  // Call back from provisioningProfiles
		
		$context.team:=New collection:C1472
		
		For each ($o; $in.value)
			
			If ($o.id#Null:C1517)\
				 & ($context.team.query("id = :1"; $o.id).pop()=Null:C1517)
				
				$team:=New object:C1471(\
					"id"; $o.id; \
					"name"; ""; \
					"menu"; $o.id)
				
				If (Length:C16(String:C10($o.name))>0)
					
					$team.name:=$o.name
					$team.menu:=$o.name+" ("+$o.id+")"
					
				End if 
				
				$context.team.push($team)
				
			End if 
		End for each 
		
		If (Length:C16(Form:C1466.organization.teamId)=0)  // No team : Affect the first one if any
			
			If ($context.team.length>0)
				
				$ƒ.setTeamID($context.team[0].id)
				
			End if 
			
		Else 
			
			$ƒ.setTeamID(Form:C1466.organization.teamId; Form:C1466.organization.teamId)
			
		End if 
		
		$ƒ.teamMenu.enable($context.team.length>0)
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+String:C10($in.action)+"\"")
		
		//=========================================================
End case 