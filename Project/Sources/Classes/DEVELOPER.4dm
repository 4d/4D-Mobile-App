Class extends form

//=== === === === === === === === === === === === === === === === === === === === === 
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_Panel_init(This:C1470.name)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	// Widgets definition
	This:C1470.name:=cs:C1710.widget.new("01_name")
	This:C1470.team:=cs:C1710.widget.new("02_team").enable(Is macOS:C1572)
	This:C1470.teamBorder:=cs:C1710.static.new("02_team.border")
	This:C1470.teamMenu:=cs:C1710.button.new("teamPopup").enable(Is macOS:C1572)
	This:C1470.teamHelp:=cs:C1710.button.new("02_team.help")
	
	//=== === === === === === === === === === === === === === === === === === === === === 
Function setTeamID($id : Text; $item : Text)
	var $label; $teamId : Text
	var $team : Object
	
	$team:=EDITOR.teams.query("id = :1"; $id).pop()
	
	If ($team#Null:C1517)
		
		$label:=$team.menu
		$teamId:=$team.id
		
	Else 
		
		$teamId:=$id
		$label:=$id
		
		If (Count parameters:C259>=2)
			
			$teamId:=$item
			
		End if 
	End if 
	
	This:C1470.team.setValue($label)
	PROJECT.organization.teamId:=$teamId
	
	PROJECT.save()
	
	// *UPDATE RIBBON'S BUTTONS
	EDITOR.updateRibbon()
	
	//=== === === === === === === === === === === === === === === === === === === === === 
	// Call back from provisioningProfiles
Function updateTeamID($response : Object)
	var $o; $team : Object
	
	EDITOR.teams:=New collection:C1472
	
	If ($response.value#Null:C1517)
		
		For each ($o; $response.value.query("id != null"))
			
			If (EDITOR.teams.query("id = :1"; String:C10($o.id)).pop()=Null:C1517)
				
				$team:=New object:C1471(\
					"id"; $o.id; \
					"name"; ""; \
					"menu"; $o.id)
				
				If (Length:C16(String:C10($o.name))>0)
					
					$team.name:=$o.name
					$team.menu:=$o.name+" ("+$o.id+")"
					
				End if 
				
				EDITOR.teams.push($team)
				
			End if 
		End for each 
		
		If (Length:C16(String:C10(PROJECT.organization.teamId))=0)
			
			// No team: Assign the first one if there is one.
			
			If (EDITOR.teams.length>0)
				
				This:C1470.setTeamID(EDITOR.teams[0].id)
				
			End if 
			
		Else 
			
			This:C1470.setTeamID(PROJECT.organization.teamId; PROJECT.organization.teamId)
			
		End if 
		
		This:C1470.teamMenu.enable(EDITOR.teams.length>0)
		
	Else 
		
		This:C1470.teamMenu.disable()
		
	End if 
	