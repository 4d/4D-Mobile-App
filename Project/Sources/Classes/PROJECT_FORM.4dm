Class extends form

Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=_o_editor_Panel_init(This:C1470.currentForm)
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.isSubform:=True:C214
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	//This.formObject("background")
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	//This.background.hide()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	var $data : Object
	$data:=OBJECT Get value:C1743("UI")
	
	var $panel : Text
	
	For each ($panel; panels)
		
		This:C1470.callChild($panel; Formula:C1597(panel_UI).source; $data)
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Performs the project audit
	//TODO: remove $project.status.project
Function audit($whatToCheck : Object)->$audit : Object
	
	If (Count parameters:C259>=1)
		
		UI.projectAudit:=project_Audit($whatToCheck)
		
	Else 
		
		UI.projectAudit:=project_Audit
		
	End if 
	
	cs:C1710.ob.new(This:C1470).set("$project.status.project"; UI.projectAudit.success)  // #TO_REMOVE