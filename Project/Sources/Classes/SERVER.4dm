Class extends form

//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
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
	
	This:C1470.input("productionURL"; "02_prodURL")
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("webSettingsGroup")
	This:C1470.formObject("webSettingsLabel"; "webSettings.label").addToGroup($group)
	This:C1470.button("webSettings").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== Form method
		
		$e:=panel_Common(On Load:K2:1)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
		End case 
		
	Else   // <== Widgets method
		
		Case of 
				
				//==================================================
			: (This:C1470.productionURL.catch($e; On Data Change:K2:15))
				
				// Verify the web server configuration
				EDITOR.callMeBack("checkingServerConfiguration")
				
				//==================================================
			: (This:C1470.webSettings.catch($e; On Clicked:K2:4))
				
				OPEN SETTINGS WINDOW:C903("/Database/Web/Config")
				
				//==================================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.webSettings.bestSize()
	This:C1470.webSettingsGroup.distributeLeftToRight()
	
	var $o : Object
	$o:=New object:C1471(\
		"buffer"; New object:C1471(\
		"deepLinking"; New object:C1471(); \
		"server"; New object:C1471(\
		"authentication"; New object:C1471; \
		"urls"; New object:C1471)))
	
	ob_MERGE(Form:C1466; $o.buffer)