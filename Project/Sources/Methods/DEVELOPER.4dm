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
$ƒ:=panel_Load

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
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
				.append("none"; "none").mark(Length:C16(String:C10(PROJECT.organization.teamId))=0)
			
			If (EDITOR.teams.length>0)
				
				$menu.line()
				
				For each ($o; EDITOR.teams)
					
					$menu.append($o.menu; $o.id).mark(PROJECT.organization.teamId=$o.id)
					
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