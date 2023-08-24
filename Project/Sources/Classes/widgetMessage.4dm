//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.background:=cs:C1710.formObject.new("background")
	This:C1470.title:=cs:C1710.widget.new("title")
	This:C1470.additional:=cs:C1710.scrollable.new("additional")
	This:C1470.ok:=cs:C1710.button.new("ok").setTitle("ok")
	This:C1470.cancel:=cs:C1710.button.new("cancel").setTitle("cancel")
	This:C1470.optional:=cs:C1710.button.new("optional")
	This:C1470.helper:=cs:C1710.button.new("helper")
	This:C1470.progress:=cs:C1710.thermometer.new("progress").asynchronous()
	
	This:C1470.buttonGroup:=cs:C1710.group.new(This:C1470.ok; This:C1470.cancel).distributeRigthToLeft()
	
	This:C1470.cancelableGroup:=cs:C1710.group.new("cancelable")
	This:C1470.thermometer:=cs:C1710.thermometer.new("thermometer").barber().addToGroup(This:C1470.cancelableGroup)
	This:C1470.cancelable:=cs:C1710.button.new("cancelable").addToGroup(This:C1470.cancelableGroup)
	
	
	This:C1470.widgets:=New collection:C1472
	This:C1470.widgets.push(This:C1470.background)
	This:C1470.widgets.push(This:C1470.title)
	This:C1470.widgets.push(This:C1470.additional)
	This:C1470.widgets.push(This:C1470.ok)
	This:C1470.widgets.push(This:C1470.cancel)
	This:C1470.widgets.push(This:C1470.optional)
	This:C1470.widgets.push(This:C1470.helper)
	This:C1470.widgets.push(This:C1470.progress)
	This:C1470.widgets.push(This:C1470.thermometer)
	This:C1470.widgets.push(This:C1470.cancelable)
	
	This:C1470.backup:=New collection:C1472
	
	var $widget : Object
	For each ($widget; This:C1470.widgets)
		
		This:C1470.backup.push(New object:C1471(\
			"name"; $widget.name; \
			"coordinates"; OB Copy:C1225($widget.coordinates)))
		
	End for each 
	
	var $height; $width : Integer
	OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
	This:C1470.width:=$width
	This:C1470.height:=$height
	
	This:C1470.str:=cs:C1710.str.new()
	
	This:C1470.reset()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function reset()
	
	// Reset the values and visibility
	This:C1470.title.setValue("").hide()
	This:C1470.additional.setVerticalScrollbar(False:C215).setValue("").hide()
	This:C1470.ok.setTitle("ok").hide()
	This:C1470.cancel.setTitle("cancel").hide()
	This:C1470.progress.hide()
	This:C1470.optional.hide()
	This:C1470.helper.hide()
	
	This:C1470.cancelableGroup.hide()
	
	This:C1470.scrollbar:=False:C215
	This:C1470.offset:=0
	
	// Reset the dimensions
	var $widget : Object
	For each ($widget; This:C1470.widgets)
		
		This:C1470[$widget.name].setCoordinates(This:C1470.backup.query("name= :1"; $widget.name).pop().coordinates)
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function restore($data : Object)
	
	// Restore the tips
	$data.tips.restore()
	
	This:C1470.virginize()
	This:C1470.reset()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function virginize()
	
	var $key : Text
	For each ($key; New collection:C1472(\
		"cancel"; \
		"option"; \
		"help"; \
		"signal"; \
		"okFormula"; \
		"okAction"; \
		"cancelFormula"; \
		"cancelAction"; \
		"signal"; \
		"CALLBACK"; \
		"autostart"))
		
		OB REMOVE:C1226(Form:C1466; $key)
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function display()
	
	var $height; $offset; $width : Integer
	var $o; $widget : Object
	var $c : Collection
	
	This:C1470.reset()
	
	// Save the status of the tips and deactivate them
	Form:C1466.tips:=cs:C1710.tips.new()
	Form:C1466.tips.disable()
	
	For each ($o; OB Entries:C1720(Form:C1466).query("key != ƒ"))
		
		Case of 
				
				//……………………………………………………………………………………………………………………
			: ($o.key="title")
				
				$widget:=This:C1470[$o.key]
				
				If (Value type:C1509(Form:C1466[$o.key])=Is collection:K8:32)
					
					$c:=$o.value.copy()
					$widget.setValue(This:C1470.str.localize($c.shift(); $c))
					
				Else 
					
					$widget.setValue(This:C1470.str.localize($o.value))
					
				End if 
				
				OBJECT GET BEST SIZE:C717(*; $widget.name; $width; $height; $widget.dimensions.width)
				$offset:=Choose:C955($height<$widget.dimensions.height; $widget.dimensions.height; $height)-$widget.dimensions.height
				
				If ($offset#0)
					
					For each ($o; This:C1470.widgets)
						
						Case of 
								
								//______________________________________________________
							: ($o.name=$widget.name)\
								 | ($o.name="background")
								
								// Grow
								This:C1470[$o.name].coordinates.bottom:=This:C1470[$o.name].coordinates.bottom+$offset
								
								//______________________________________________________
							: ($o.name="additional")
								
								// Move
								This:C1470[$o.name].coordinates.top:=This:C1470[$o.name].coordinates.top+$offset
								This:C1470[$o.name].coordinates.bottom:=This:C1470[$o.name].coordinates.bottom+$offset
								
								//______________________________________________________
						End case 
					End for each 
					
					This:C1470.offset:=This:C1470.offset+$offset
					
				End if 
				
				$widget.show()
				
				//……………………………………………………………………………………………………………………
			: ($o.key="additional")
				
				$widget:=This:C1470[$o.key]
				
				If (Value type:C1509(Form:C1466[$o.key])=Is collection:K8:32)
					
					$c:=$o.value.copy()
					$widget.setValue(This:C1470.str.localize($c.shift(); $c))
					
				Else 
					
					$widget.setValue(This:C1470.str.localize($o.value))
					
				End if 
				
				OBJECT GET BEST SIZE:C717(*; $widget.name; $width; $height; $widget.dimensions.width)
				$offset:=Choose:C955($height<$widget.dimensions.height; $widget.dimensions.height; $height)-$widget.dimensions.height
				
				If ($offset#0)
					
					For each ($o; This:C1470.widgets)
						
						Case of 
								
								//______________________________________________________
							: ($o.name=$widget.name)\
								 | ($o.name="background")
								
								// Grow
								This:C1470[$o.name].newCoordinates:=OB Copy:C1225(This:C1470[$o.name].coordinates)
								This:C1470[$o.name].newCoordinates.bottom:=This:C1470[$o.name].newCoordinates.bottom+$offset
								
								//______________________________________________________
						End case 
					End for each 
					
					This:C1470.offset:=This:C1470.offset+$offset
					
				End if 
				
				$widget.show()
				
				//……………………………………………………………………………………………………………………
			: ($o.key="ok")
				
				This:C1470.ok.setTitle($o.value).show()
				
				//……………………………………………………………………………………………………………………
			: ($o.key="cancel")
				
				This:C1470.cancel.setTitle($o.value).show()
				
				//……………………………………………………………………………………………………………………
			: ($o.key="type")
				
				Form:C1466.type:=$o.value
				
				Case of 
						
						// ---------------------------------------
					: ($o.value="cancelableProgress")
						
						This:C1470.thermometer.start()
						This:C1470.cancelableGroup.show()
						
						// ---------------------------------------
					: ($o.value="progress")
						
						This:C1470.progress.show().start()
						
						// ---------------------------------------
					: ($o.value="alert")
						
						This:C1470.ok.show()
						
						// ---------------------------------------
					: ($o.value="confirm")
						
						This:C1470.ok.show()
						This:C1470.cancel.setTitle("cancel").show()
						
						// ---------------------------------------
				End case 
				
				//……………………………………………………………………………………………………………………
			: ($o.key="option")
				
				This:C1470.optional.setTitle($o.value.title).show()
				
				//……………………………………………………………………………………………………………………
			: ($o.key="help")
				
				This:C1470.helper.show()
				
				//……………………………………………………………………………………………………………………
		End case 
	End for each 
	
	SET TIMER:C645(-1)  // To update form geometry
	CALL SUBFORM CONTAINER:C1086(-8858)  // To update widget size
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function update($data : Object)
	
	var $o : Object
	For each ($o; This:C1470.widgets)
		
		Case of 
				
				// ---------------------------------------
			: ($o.name="title")\
				 | ($o.name="background")
				
				// Grow
				This:C1470[$o.name].setCoordinates(This:C1470[$o.name].coordinates)
				
				// ---------------------------------------
			: ($o.name="additional")
				
				This:C1470[$o.name].setCoordinates(This:C1470[$o.name].newCoordinates=Null:C1517 ? This:C1470[$o.name].coordinates : This:C1470[$o.name].newCoordinates)
				This:C1470[$o.name].setVerticalScrollbar(Bool:C1537(This:C1470.scrollbar))
				
				// ---------------------------------------
			Else 
				
				This:C1470[$o.name].moveVertically(This:C1470.offset)
				
				// ---------------------------------------
		End case 
	End for each 
	
	Case of 
			
			// ---------------------------------------
		: ($data.type=Null:C1517)
			
			// ---------------------------------------
		: ($data.type="cancelableProgress")
			
			This:C1470.thermometer.start()
			This:C1470.cancelableGroup.show()
			
			// ---------------------------------------
		: ($data.type="progress")
			
			This:C1470.ok.hide()
			This:C1470.cancel.hide()
			This:C1470.progress.show().start()
			
			// ---------------------------------------
		: ($data.type="alert")
			
			This:C1470.ok.show()
			This:C1470.cancel.hide()
			
			// ---------------------------------------
		: ($data.type="confirm")
			
			This:C1470.ok.show()
			This:C1470.cancel.show()
			
			// ---------------------------------------
	End case 
	
	This:C1470.buttonGroup.distributeRigthToLeft()
	
	// Auto-launch
	If (Form:C1466.autostart#Null:C1517)
		
		If (OB Instance of:C1731(Form:C1466.autostart; 4D:C1709.Function))
			
			Form:C1466.autostart.call()
			
		Else 
			
			Logger.warning(Current method name:C684+" : autostart #OLD_MECHANISM")
			CALL FORM:C1391(Current form window:C827; Form:C1466.autostart.method; Form:C1466.autostart.action; Form:C1466.autostart.project)
			
		End if 
		
		OB REMOVE:C1226(Form:C1466; "autostart")  // One shot
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doValidate()
	
	Form:C1466.accept:=(Form:C1466.type#"alert")
	
	Case of 
			
			//______________________________________________________
		: (Form:C1466.signal#Null:C1517)
			
			Use (Form:C1466.signal)
				
				Form:C1466.signal.validate:=True:C214
				
			End use 
			
			Form:C1466.signal.trigger()
			
			If (Form:C1466.signal.description#Null:C1517)
				
				If (Form:C1466.CALLBACK#Null:C1517)
					
					Case of 
							//______________________________________________________
						: (Value type:C1509(Form:C1466.CALLBACK)=Is text:K8:3)  // #OLD_MECHANISM
							
							EXECUTE METHOD:C1007(Form:C1466.CALLBACK; *; Form:C1466)
							
							//______________________________________________________
						: (OB Instance of:C1731(Form:C1466.CALLBACK; 4D:C1709.Function))
							
							Form:C1466.CALLBACK.call(Null:C1517; Form:C1466)
							
							//______________________________________________________
						Else 
							
							// #ERROR
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
			//______________________________________________________
		: (Form:C1466.okFormula#Null:C1517)
			
			Form:C1466.okFormula.call()
			
			//______________________________________________________
		: (Form:C1466.okAction#Null:C1517)  // #OLD_MECHANISM
			
			If (Form:C1466.option#Null:C1517)
				
				EXECUTE METHOD:C1007(Formula:C1597(editor_RESUME).source; *; String:C10(Form:C1466.okAction); Form:C1466.option.value)
				
			Else 
				
				EXECUTE METHOD:C1007(Formula:C1597(editor_RESUME).source; *; String:C10(Form:C1466.okAction))
				
			End if 
			
			//______________________________________________________
	End case 
	
	CALL SUBFORM CONTAINER:C1086(-1)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doCancel()
	
	Form:C1466.accept:=False:C215
	
	Case of 
			
			//______________________________________________________
		: (Form:C1466.signal#Null:C1517)
			
			Form:C1466.signal.trigger()
			
			If (Form:C1466.signal.description#Null:C1517)
				
				If (Form:C1466.CALLBACK#Null:C1517)
					
					Case of 
							//______________________________________________________
						: (Value type:C1509(Form:C1466.CALLBACK)=Is text:K8:3)  // #OLD_MECHANISM
							
							EXECUTE METHOD:C1007(Form:C1466.CALLBACK; *; Form:C1466)
							
							//______________________________________________________
						: (OB Instance of:C1731(Form:C1466.CALLBACK; 4D:C1709.Function))
							
							Form:C1466.CALLBACK.call(Null:C1517; Form:C1466)
							
							//______________________________________________________
						Else 
							
							// #ERROR
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
			//______________________________________________________
		: (Form:C1466.cancelFormula#Null:C1517)
			
			Form:C1466.cancelFormula.call()
			
			//______________________________________________________
		: (Form:C1466.cancelAction#Null:C1517)  // #OLD_MECHANISM
			
			EXECUTE METHOD:C1007(Formula:C1597(editor_RESUME).source; *; Form:C1466.cancelAction)
			
			//______________________________________________________
	End case 
	
	CALL SUBFORM CONTAINER:C1086(-2)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doHelp()
	
	If (Form:C1466.help#Null:C1517)
		
		Form:C1466.help.call()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doStop()
	
	If (Form:C1466.cancelMessage#Null:C1517)
		
		CONFIRM:C162(This:C1470.str.localize(Form:C1466.cancelMessage))
		
	Else 
		
		CONFIRM:C162(This:C1470.str.localize("areYouSure"); This:C1470.str.localize("stop"))
		
	End if 
	
	
	
	If (Bool:C1537(OK))
		
		Form:C1466.accept:=False:C215
		
		Case of 
				
				//______________________________________________________
			: (Form:C1466.signal#Null:C1517)
				
				Form:C1466.signal.trigger()
				
				If (Form:C1466.signal.description#Null:C1517)
					
					If (Form:C1466.CALLBACK#Null:C1517)
						
						Form:C1466.CALLBACK.call(Null:C1517; Form:C1466)
						
					End if 
				End if 
				
				//______________________________________________________
			: (Form:C1466.stopFormula#Null:C1517)
				
				Form:C1466.stopFormula.call()
				
			Else 
				
				CALL SUBFORM CONTAINER:C1086(-2)  //close
				
				//______________________________________________________
		End case 
		
	End if 