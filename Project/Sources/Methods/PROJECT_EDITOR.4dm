//%attributes = {"invisible":true}
var $e; $o : Object

$e:=FORM Event:C1606

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			var EDITOR : cs:C1710.PROJECT_EDITOR
			
			If (EDITOR#Null:C1517)
				
				// We come from a wizard,
				// so we need to update the form name
				EDITOR.name:=Current form name:C1298
				
			Else 
				
				// Direct launch (dev mode)
				EDITOR:=cs:C1710.PROJECT_EDITOR.new()
				
			End if 
			
			EDITOR.onLoad()
			
			// Load the project
			PROJECT:=cs:C1710.project.new().load(Form:C1466.file)
			
			EDITOR.android:=PROJECT.$android
			EDITOR.ios:=PROJECT.$ios
			
			EDITOR.setTitle(EDITOR.str.setText("editorWindowTitle").localized(PROJECT._name))
			
			EDITOR.context.ribbon:=New object:C1471(\
				"state"; "open"; \
				"tab"; "section"; \
				"page"; EDITOR.currentPage; \
				"editor"; Form:C1466)
			
			EDITOR.ribbon.setValue(EDITOR.context.ribbon)
			
			// Update the description
			EDITOR.setHeader()
			
			// Initialize the project subform
			EDITOR.project.setValue(PROJECT)
			
			EDITOR.ribbon.show()
			EDITOR.description.show()
			
			// Launch project verifications
			EDITOR.checkProject()
			
			// Audit of development tools
			EDITOR.checkDevTools()
			
			EDITOR.refresh()
			
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
			
			EDITOR.tips.restore()
			
			//______________________________________________________
		: ($e.code=On Activate:K2:9)
			
			// Update of values that may have changed
			ENV.update()
			
			// Update color scheme if any
			EDITOR.updateColorScheme()
			
			// Restore local tips properties
			EDITOR.tips.set()
			
			// Verify the web server configuration
			EDITOR.callMeBack("checkingServerConfiguration")
			EDITOR.callMeBack("refreshServer")
			
			// Launch project verifications
			EDITOR.checkProject()
			
			// Update the displayed panels
			EDITOR.refreshPanels()
			
			//______________________________________________________
		: ($e.code=On Unload:K2:2)
			
			EDITOR.tips.restore()
			EDITOR.callWorker("killWorker")
			
			//______________________________________________________
		: ($e.code=On Resize:K2:27)
			
			// Mask picker during resizing
			$o:=New object:C1471(\
				"action"; "forms"; \
				"onResize"; True:C214)
			
			EDITOR.callChild(EDITOR.project; EDITOR.callback; "pickerHide"; $o)
			
			// Footer
			$o:=EDITOR.footer.updateCoordinates().coordinates
			EDITOR.footer.setCoordinates($o.left; $o.top; $o.left+EDITOR.width(); $o.bottom)
			
			// Center message
			EDITOR.message.alignHorizontally(Align center:K42:3)
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			EDITOR.project.show()
			
			// Footer
			$o:=EDITOR.footer.updateCoordinates().coordinates
			EDITOR.footer.setCoordinates($o.left; $o.top; $o.left+EDITOR.width(); $o.bottom)
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//==============================================
		: (EDITOR.message.catch())\
			 & ($e.code<0)
			
			EDITOR.messageContainer($e)
			
			//==============================================
		: (EDITOR.ribbon.catch())\
			 & ($e.code<0)
			
			EDITOR.ribbonContainer($e)
			
			//==============================================
	End case 
End if 