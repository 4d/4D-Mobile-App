Class extends panel

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.input("name"; "01_name")
	This:C1470.button("nameHelp")
	
	This:C1470.input("identifier"; "02_identifier")
	This:C1470.button("identifierHelp")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents()
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.name.catch())
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.nameHelp.show()
						
						//______________________________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470.nameHelp.hide()
						
						//______________________________________________________
				End case 
				
				//==============================================
			: (This:C1470.nameHelp.catch($e; On Clicked:K2:4))
				
				OPEN URL:C673(Get localized string:C991("doc_orgName"); *)
				
				//==============================================
			: (This:C1470.identifier.catch())
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On Getting Focus:K2:7)
						
						This:C1470.identifierHelp.show()
						
						//______________________________________________________
					: ($e.code=On Losing Focus:K2:8)
						
						This:C1470.identifierHelp.hide()
						
						//______________________________________________________
					: ($e.code=On Data Change:K2:15)
						
						// Update bundleIdentifier
						Form:C1466.product.bundleIdentifier:=Form:C1466.organization.id+"."+formatString("bundleApp"; Form:C1466.product.name)
						
						//______________________________________________________
				End case 
				
				//==============================================
			: (This:C1470.identifierHelp.catch($e; On Clicked:K2:4))
				
				OPEN URL:C673(Get localized string:C991("doc_orgIdentifier"); *)
				
				//________________________________________
		End case 
	End if 