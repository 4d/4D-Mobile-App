Class extends panel

//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.input("name"; "01_name")
	This:C1470.input("team"; "02_team")
	This:C1470.formObject("teamBorder"; "02_team.border")
	This:C1470.button("teamMenu")
	This:C1470.button("teamHelp")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	var $o : Object
	var $menu : cs:C1710.menu
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.team.catch())
				
				Case of 
						
						//______________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.teamHelp.show()
						
						//______________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470.teamHelp.hide()
						
						//______________________________________
					: ($e.code=On Data Change:K2:15)
						
						This:C1470.setTeamID(This:C1470.team.getValue())
						
						//______________________________________
				End case 
				
				//==============================================
			: (This:C1470.teamMenu.catch())
				
				$menu:=cs:C1710.menu.new()\
					.append("none"; "none").mark(Length:C16(String:C10(PROJECT.organization.teamId))=0)
				
				If (UI.teams.length>0)
					
					$menu.line()
					
					For each ($o; UI.teams)
						
						$menu.append($o.menu; $o.id).mark(PROJECT.organization.teamId=$o.id)
						
					End for each 
				End if 
				
				$menu.popup(This:C1470.teamBorder)
				
				If ($menu.selected)
					
					This:C1470.setTeamID($menu.choice)
					
				End if 
				
				//==============================================
			: (This:C1470.teamHelp.catch())
				
				OPEN URL:C673(Get localized string:C991("doc_team"); *)
				
				//________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.team.setValue(String:C10(PROJECT.organization.teamId))
	
	Case of 
			
			//…………………………………………………………………………………………
		: (Is macOS:C1572)
			
			This:C1470.teamMenu.disable()
			
			// *LAUNCH GETTING TEAM IDS
			This:C1470.callWorker(Formula:C1597(teamId).source; New object:C1471(\
				"action"; "list"; \
				"provisioningProfiles"; True:C214; \
				"certificate"; True:C214; \
				"caller"; This:C1470.window; \
				"callerMethod"; This:C1470.callback; \
				"callerReturn"; "teamId"))
			
			//…………………………………………………………………………………………
		: (Is Windows:C1573)
			
			This:C1470.team.disable()
			This:C1470.teamMenu.disable()
			
			//…………………………………………………………………………………………
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function setTeamID($id : Text; $item : Text)
	var $label; $teamId : Text
	var $team : Object
	
	$team:=UI.teams.query("id = :1"; $id).pop()
	
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
	UI.updateRibbon()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Call back from provisioningProfiles
Function updateTeamID($response : Object)
	var $o; $team : Object
	
	UI.teams:=New collection:C1472
	
	If ($response.value#Null:C1517)
		
		For each ($o; $response.value.query("id != null"))
			
			If (UI.teams.query("id = :1"; String:C10($o.id)).pop()=Null:C1517)
				
				$team:=New object:C1471(\
					"id"; $o.id; \
					"name"; ""; \
					"menu"; $o.id)
				
				If (Length:C16(String:C10($o.name))>0)
					
					$team.name:=$o.name
					$team.menu:=$o.name+" ("+$o.id+")"
					
				End if 
				
				UI.teams.push($team)
				
			End if 
		End for each 
		
		If (Length:C16(String:C10(PROJECT.organization.teamId))=0)
			
			// No team: Assign the first one if there is one.
			
			If (UI.teams.length>0)
				
				This:C1470.setTeamID(UI.teams[0].id)
				
			End if 
			
		Else 
			
			This:C1470.setTeamID(PROJECT.organization.teamId; PROJECT.organization.teamId)
			
		End if 
		
		This:C1470.teamMenu.enable(UI.teams.length>0)
		
	Else 
		
		This:C1470.teamMenu.disable()
		
	End if 
	