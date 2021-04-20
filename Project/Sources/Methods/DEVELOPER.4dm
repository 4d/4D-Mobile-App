//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : DEVELOPER
// Created 30-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// DEVELOPER pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ; $o : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form(On Load:K2:1)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.team.setValue(String:C10(Form:C1466.organization.teamId))
			
			If (Is macOS:C1572)
				
				$ƒ.teamMenu.disable()
				
				// *LAUNCH GETTING TEAM IDS
				$ƒ.callWorker("teamId"; New object:C1471(\
					"action"; "list"; \
					"provisioningProfiles"; True:C214; \
					"certificate"; True:C214; \
					"caller"; $ƒ.window; \
					"callerMethod"; $ƒ.callback; \
					"callerReturn"; "teamId"))
				
			End if 
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.team.catch())
			
			Case of 
					
					//______________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.teamHelp.show()
					
					//______________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					$ƒ.teamHelp.hide()
					
					//______________________________________
				: ($e.code=On Data Change:K2:15)
					
					$ƒ.setTeamID($ƒ.team.getValue())
					
					//______________________________________
			End case 
			
			//==============================================
		: ($ƒ.teamMenu.catch())
			
			$menu:=cs:C1710.menu.new()\
				.append("none"; "none").mark(Length:C16(String:C10(Form:C1466.organization.teamId))=0)
			
			If ($ƒ.context.team.length>0)
				
				$menu.line()
				
				For each ($o; $ƒ.context.team)
					
					$menu.append($o.menu; $o.id).mark(Form:C1466.organization.teamId=$o.id)
					
				End for each 
			End if 
			
			$menu.popup($ƒ.teamBorder)
			
			If ($menu.selected)
				
				$ƒ.setTeamID($menu.choice)
				
			End if 
			
			//==============================================
		: ($ƒ.teamHelp.catch())
			
			OPEN URL:C673(Get localized string:C991("doc_team"); *)
			
			//________________________________________
	End case 
End if 