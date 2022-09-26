Class extends panel

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("os")
	This:C1470.button("ios").addToGroup($group)
	This:C1470.button("android").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Bound Variable Change:K2:52)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Bound Variable Change:K2:52)
				
				UI.setTarget()
				
				// Update UI
				This:C1470.displayTarget()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.ios.catch())\
				 | (This:C1470.android.catch())
				
				Case of 
						
						//______________________________________________________
					: (Is Windows:C1573)
						
						// <NOTHING MORE TO DO>
						
						//______________________________________________________
					: ($e.code=On Clicked:K2:4)
						
						// Keep current status
						var $o : Object
						$o:=New object:C1471(\
							"before"; New object:C1471(\
							"ios"; PROJECT.iOS(); \
							"android"; PROJECT.android()))
						
						If (Is macOS:C1572)\
							 & ($e.objectName=This:C1470.android.name)\
							 & Not:C34(Form:C1466.$ios)\
							 & Not:C34(Form:C1466.$android)
							
							// Force iOS
							UI.setTarget("ios"; True:C214)
							
						Else 
							
							UI.setTarget($e.objectName; OBJECT Get value:C1743($e.objectName))
							
						End if 
						
						// Invalidate dataset if target was modified
						// But don't delete the db files
						$o.after:=New object:C1471(\
							"ios"; PROJECT.iOS(); \
							"android"; PROJECT.android())
						
						If (Not:C34(New collection:C1472($o.before).equal(New collection:C1472($o.after))))
							
							var $data : cs:C1710.DATA
							$data:=panel("DATA")
							
							If ($data#Null:C1517)
								
								If ($o.before.ios#$o.after.ios)
									
									OB REMOVE:C1226($data; "sqlite")
									
								End if 
								
								If ($o.before.android#$o.after.android)
									
									OB REMOVE:C1226($data; "datasetAndroid")
									
								End if 
							End if 
						End if 
						
						// Update UI
						This:C1470.displayTarget()
						UI.updateRibbon()
						
						//______________________________________________________
					: ($e.code=On Mouse Enter:K2:33)
						
						// Highlights
						This:C1470[$e.objectName].foregroundColor:=UI.selectedColor
						
						//______________________________________________________
					: ($e.code=On Mouse Leave:K2:34)
						
						// Restore
						This:C1470[$e.objectName].foregroundColor:=Foreground color:K23:1
						
						//______________________________________________________
				End case 
				
				//________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	If (Is Windows:C1573)
		
		This:C1470.android.setPicture("#images/os/Android-32.png")\
			.setBackgroundPicture()\
			.setNumStates(1)
		
		If (Form:C1466.$ios)
			
			This:C1470.ios.setPicture("#images/os/iOS-32.png")
			
		Else 
			
			This:C1470.ios.setPicture("#images/os/iOS-24.png")
			
		End if 
		
		This:C1470.ios.disable()\
			.setBackgroundPicture()\
			.setNumStates(1)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Manage UI for the target
Function displayTarget()
	
	This:C1470.ios.setValue(UI.ios)
	This:C1470.android.setValue(UI.android)