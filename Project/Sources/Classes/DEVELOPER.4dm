/*===============================================
DEVELOPER pannel Class
*/

//Class extends panel

Class constructor
	
	//Super()
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.window:=Current form window:C827
		
		This:C1470.name:=cs:C1710.widget.new("01_name")
		This:C1470.team:=cs:C1710.widget.new("02_team")
		This:C1470.teamBorder:=cs:C1710.static.new("02_team.border")
		This:C1470.teamMenu:=cs:C1710.button.new("teamPopup")
		This:C1470.teamHelp:=cs:C1710.button.new("02_team.help")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//====================================================================
Function setTeamID
	var $1 : Text
	var $2 : Text
	
	var $t; $teamId : Text
	var $o : Object
	
	$o:=This:C1470.context.team.query("id = :1"; $1).pop()
	
	If ($o#Null:C1517)
		
		$t:=$o.menu
		$teamId:=$o.id
		
	Else 
		
		If (Count parameters:C259>=2)
			
			$t:=$2
			
		End if 
	End if 
	
	This:C1470.team.setValue($t)
	Form:C1466.organization.teamId:=$teamId
	
	PROJECT.save()
	
	// Update UI
	CALL FORM:C1391(This:C1470.window; "editor_CALLBACK"; "updateRibbon")