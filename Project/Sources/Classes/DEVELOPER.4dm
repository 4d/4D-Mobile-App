/*===============================================
DEVELOPER pannel Class
===============================================*/
Class extends form

//________________________________________________________________ 
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.name:=cs:C1710.widget.new("01_name")
		This:C1470.team:=cs:C1710.widget.new("02_team").enable(Is macOS:C1572)
		This:C1470.teamBorder:=cs:C1710.static.new("02_team.border")
		This:C1470.teamMenu:=cs:C1710.button.new("teamPopup").enable(Is macOS:C1572)
		This:C1470.teamHelp:=cs:C1710.button.new("02_team.help")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//====================================================================
Function setTeamID($id : Text; $item : Text)
	var $label; $teamId : Text
	var $team : Object
	
	$team:=This:C1470.context.team.query("id = :1"; $id).pop()
	
	If ($team#Null:C1517)
		
		$label:=$team.menu
		$teamId:=$team.id
		
	Else 
		
		If (Count parameters:C259>=2)
			
			$label:=$item
			$teamId:=$label
			
		End if 
	End if 
	
	This:C1470.team.setValue($label)
	Form:C1466.organization.teamId:=$teamId
	
	PROJECT.save()
	
	// Update UI
	CALL FORM:C1391(This:C1470.window; "editor_CALLBACK"; "updateRibbon")