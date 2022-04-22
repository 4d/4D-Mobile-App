//%attributes = {"invisible":true}
var $e; $o : Object

$e:=FORM Event:C1606

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			var UI : cs:C1710.EDITOR
			
			If (UI#Null:C1517)
				
				// We come from a wizard,
				// so we need to update the form name
				UI.currentForm:=Current form name:C1298
				
			Else 
				
				// Direct launch (dev mode)
				UI:=cs:C1710.EDITOR.new()
				
			End if 
			
			UI.onLoad()
			
			// Load the project
			PROJECT:=cs:C1710.project.new().load(Form:C1466.file)
			
			UI.android:=PROJECT.$android
			UI.ios:=PROJECT.$ios
			
			UI.windowTitle:=UI.str.localize("editorWindowTitle"; PROJECT._name)
			UI.context.ribbon:=New object:C1471(\
				"state"; "open"; \
				"tab"; "section"; \
				"page"; UI.currentPage; \
				"editor"; Form:C1466)
			
			UI.ribbon.setValue(UI.context.ribbon)
			
			// Update the description
			UI.setHeader()
			
			// Initialize the project subform
			UI.project.setValue(PROJECT)
			
			UI.ribbon.show()
			UI.description.show()
			
			// Launch project verifications
			UI.checkProject()
			
			// Audit of development tools
			UI.checkDevTools()
			
			UI.refresh()
			
			//______________________________________________________
		: ($e.code=On Close Box:K2:21)
			
			ACCEPT:C269
			
			//______________________________________________________
		: ($e.code=On Data Change:K2:15)
			
			If (Not:C34(OB Is empty:C1297(PROJECT)))
				
				PROJECT.save()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Deactivate:K2:10)
			
			UI.tips.restore()
			
			//______________________________________________________
		: ($e.code=On Activate:K2:9)
			
			// Update of values that may have changed
			Env.update()
			
			// Update color scheme if any
			UI.updateColorScheme()
			
			// Restore local tips properties
			UI.tips.set()
			
			// Verify the web server configuration
			UI.callMeBack("checkingServerConfiguration")
			
			// Launch project verifications
			UI.checkProject()
			
			// Update the displayed panels
			UI.refreshPanels()
			
			//______________________________________________________
		: ($e.code=On Unload:K2:2)
			
			UI.tips.restore()
			UI.callWorker(Formula:C1597(killWorker).source)
			
			//______________________________________________________
		: ($e.code=On Resize:K2:27)
			
			// Mask picker during resizing
			$o:=New object:C1471(\
				"action"; "forms"; \
				"onResize"; True:C214)
			
			UI.callChild(UI.project; UI.callback; "pickerHide"; $o)
			
			// Footer
			$o:=UI.footer.updateCoordinates().coordinates
			UI.footer.setCoordinates($o.left; $o.top; $o.left+UI.width; $o.bottom)
			
			// Center message
			UI.message.alignHorizontally(Align center:K42:3)
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			UI.project.show()
			
			// Footer
			$o:=UI.footer.updateCoordinates().coordinates
			UI.footer.setCoordinates($o.left; $o.top; $o.left+UI.width; $o.bottom)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: (UI.message.catch())\
			 & ($e.code<0)
			
			UI.messageContainer($e)
			
			//==============================================
		: (UI.ribbon.catch())\
			 & ($e.code<0)
			
			UI.ribbonContainer($e)
			
			//==============================================
	End case 
End if 