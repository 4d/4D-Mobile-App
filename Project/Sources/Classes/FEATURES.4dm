Class extends panel

//property certificateGroup : cs.group
//property configureFileGroup : cs.group

//=== === === === === === === === === === === === === === === === === === === === ===
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
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	// * LOGIN
	This:C1470.button("loginRequired"; "01_login")
	
	$group:=This:C1470.group("authentication")
	This:C1470.formObject("authenticationLabel"; "authentication.label").addToGroup($group)
	This:C1470.button("authenticationButton"; "authentication").addToGroup($group)
	
	If (Feature.with("customLoginForms"))
		
		$group:=This:C1470.group("authenticationGroup")
		This:C1470.input("loginFormValue").addToGroup($group)
		This:C1470.formObject("loginFormLabel").addToGroup($group)
		This:C1470.formObject("loginFormBorder").addToGroup($group)
		This:C1470.button("loginFormPopup").addToGroup($group)
		This:C1470.button("loginFormReveal").addToGroup($group)
		
	Else 
		
		This:C1470.group("authenticationGroup")
		
	End if 
	
	This:C1470.authenticationGroup.addMember(This:C1470.authentication)
	
	// * PUSH NOTIFICATION
	This:C1470.button("pushNotification"; "02_pushNotification")
	
	$group:=This:C1470.group("certificateGroup")
	This:C1470.formObject("certificateLabel").addToGroup($group)
	This:C1470.widget("certificate"; "certificatePicker").addToGroup($group)
	
	var $this : cs:C1710.FEATURES
	$this:=OB Copy:C1225(This:C1470)
	This:C1470.certificate.picker:=cs:C1710.pathPicker.new(String:C10(Form:C1466.server.pushCertificate); New object:C1471(\
		"fileTypes"; ".p8"; \
		"directory"; 8858; \
		"copyPath"; False:C215; \
		"openItem"; True:C214; \
		"message"; "selectACertificate"; \
		"placeHolder"; "selectACertificate"; \
		"callback"; Formula:C1597($this.certificateCallback($1))))
	
	If (Feature.with("androidPushNotifications"))
		
		$group:=This:C1470.group("configureFileGroup")
		This:C1470.formObject("configureFileLabel").addToGroup($group)
		This:C1470.widget("configureFile"; "configureFilePicker").addToGroup($group)
		
		This:C1470.configureFile.picker:=cs:C1710.pathPicker.new(cs:C1710.doc.new(String:C10(Form:C1466.server.configurationFile)).target; New object:C1471(\
			"fileTypes"; ".json"; \
			"directory"; 8858; \
			"copyPath"; False:C215; \
			"openItem"; True:C214; \
			"message"; "selectAConfigurationFile"; \
			"placeHolder"; "selectAConfigurationFile"; \
			"callback"; Formula:C1597($this.configureFileCallback($1))))
		
	End if 
	
	// * DEEP LINKING
	This:C1470.button("deepLinking"; "03_deepLinking")
	
	$group:=This:C1470.group("deepLinkingGroup")
	This:C1470.input("deepScheme"; "03_urlScheme.input").addToGroup($group)
	This:C1470.formObject("deepSchemeLabel"; "urlScheme.label").addToGroup($group)
	This:C1470.formObject("deepSchemeBorder"; "urlScheme.border").addToGroup($group)
	
	This:C1470.deepSchemeAlert:=cs:C1710.attention.new("urlScheme.alert")
	$group.addMember(This:C1470.deepSchemeAlert)
	
	This:C1470.input("deepLink"; "04_associatedDomain.input").addToGroup($group)
	This:C1470.formObject("deepLinkLabel"; "associatedDomain.label").addToGroup($group)
	This:C1470.formObject("deepLinkBorder"; "associatedDomain.border").addToGroup($group)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.loginRequired.catch($e; On Clicked:K2:4))
				
				Form:C1466.server.authentication.email:=Bool:C1537(Form:C1466.server.authentication.email)
				PROJECT.save()
				
				//This.authenticationGroup.show(Form.server.authentication.email)
				This:C1470.update()
				
				//==============================================
			: (This:C1470.authenticationButton.catch($e; On Clicked:K2:4))
				
				UI.editDatabaseMethod("onMobileAppAuthentication")
				This:C1470.checkAuthenticationMethod()
				
				//==============================================
			: (This:C1470.pushNotification.catch($e; On Clicked:K2:4))
				
				Form:C1466.server.pushNotification:=Bool:C1537(Form:C1466.server.pushNotification)
				PROJECT.save()
				
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.deepLinking.catch($e; On Clicked:K2:4))
				
				Form:C1466.deepLinking.enabled:=Bool:C1537(Form:C1466.deepLinking.enabled)
				
				If (Form:C1466.deepLinking.enabled)
					
					This:C1470.deepLinkingGroup.show()
					
					// Create scheme from application name if not defined
					This:C1470.initScheme()
					
					If (Form:C1466.deepLinking.associatedDomain=Null:C1517)
						
						Form:C1466.deepLinking.associatedDomain:=""
						This:C1470.deepLink.setHelpTip()
						
					Else 
						
						This:C1470.deepLink.setHelpTip("universalLinksTips")
						
					End if 
					
				Else 
					
					This:C1470.deepLinkingGroup.hide()
					
				End if 
				
				PROJECT.save()
				
				This:C1470.refresh()
				
				//==============================================
			: (This:C1470.deepScheme.catch($e; On Data Change:K2:15))
				
				If (This:C1470.validateScheme())
					
					PROJECT.save()
					
				End if 
				
				//==============================================
			: (This:C1470.deepSchemeAlert.catch())
				
				This:C1470.deepSchemeAlert.method($e)
				
				//==============================================
			: (This:C1470.deepLink.catch($e; On Data Change:K2:15))
				
				PROJECT.save()
				
				This:C1470.deepLink.setHelpTip(Choose:C955(Length:C16(Form:C1466.deepLinking.associatedDomain)>0; "universalLinksTips"; ""))
				
				//==============================================
			: (This:C1470.loginFormPopup.catch($e; On Clicked:K2:4))
				
				var $form : Object
				var $menu : cs:C1710.menu
				
				$menu:=cs:C1710.menu.new()\
					.append("default"; "default"; PROJECT.login=Null:C1517)\
					.line()
				
				// Append custom login forms, if any
				For each ($form; This:C1470.getUserLoginForms())
					
					$menu.append($form.name; $form.source; String:C10(PROJECT.login)=$form.source)
					
				End for each 
				
				If ($menu.popup(This:C1470.loginFormPopup).selected)
					
					If ($menu.choice="default")
						
						OB REMOVE:C1226(PROJECT; "login")
						
					Else 
						
						PROJECT.login:=$menu.choice
						
					End if 
					
					PROJECT.save()
					This:C1470.refresh()
					
				End if 
				
				//==============================================
			: (This:C1470.loginFormReveal.catch($e; On Clicked:K2:4))
				
				If (PROJECT.login="@.zip")
					
					SHOW ON DISK:C922(cs:C1710.path.new().hostloginForms().file(Delete string:C232(PROJECT.login; 1; 1)).platformPath)
					
				Else 
					
					SHOW ON DISK:C922(cs:C1710.path.new().hostloginForms().folder(Delete string:C232(PROJECT.login; 1; 1)).platformPath)
					
				End if 
				
				//==============================================
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	This:C1470.loginRequired.bestSize()
	This:C1470.authentication.distributeLeftToRight()
	This:C1470.pushNotification.bestSize()
	
	If (Not:C34(PROJECT.$ios))
		
		var $o : cs:C1710.coordinates
		$o:=This:C1470.certificateGroup.enclosingRect()
		This:C1470.configureFileGroup.moveVertically(-($o.bottom-$o.top)-7)
		
	End if 
	
	This:C1470.deepLinking.bestSize()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update UI
Function update()
	
	If (Feature.with("customLoginForms"))
		
		If (Form:C1466.server.authentication.email)
			
			This:C1470.authenticationGroup.show()
			
			If (PROJECT.login=Null:C1517)
				
				This:C1470.loginFormValue.foregroundColor:=Foreground color:K23:1
				This:C1470.loginFormReveal.hide()
				
			Else 
				
				If (This:C1470.getUserLoginForms().query("source = :1"; PROJECT.login).pop()=Null:C1517)
					
					This:C1470.loginFormValue.foregroundColor:=UI.errorColor
					This:C1470.loginFormReveal.hide()
					
				Else 
					
					This:C1470.loginFormValue.foregroundColor:=Foreground color:K23:1
					This:C1470.loginFormReveal.show()
					
				End if 
			End if 
			
			// TODO:Move expand ?
			
		Else 
			
			This:C1470.authenticationGroup.hide()
			
			// TODO:Move collapse ?
			
		End if 
		
	Else 
		
		This:C1470.authenticationGroup.hide()
		
	End if 
	
	If (Feature.with("androidPushNotifications"))
		
		This:C1470.certificateGroup.show(Form:C1466.server.pushNotification & PROJECT.$ios)
		This:C1470.certificateGroup.enable(Is macOS:C1572)
		This:C1470.certificate.picker.browse:=Is macOS:C1572
		This:C1470.certificate.touch()
		
		This:C1470.configureFileGroup.show(Form:C1466.server.pushNotification & PROJECT.$android)
		This:C1470.configureFile.touch()
		
	Else 
		
		This:C1470.certificateGroup.show(Form:C1466.server.pushNotification)
		This:C1470.pushNotification.enable(Is macOS:C1572 & PROJECT.$ios)
		This:C1470.certificateGroup.enable(Is macOS:C1572 & PROJECT.$ios)
		This:C1470.certificate.picker.browse:=(Is macOS:C1572 & PROJECT.$ios)
		This:C1470.certificate.touch()
		
	End if 
	
	This:C1470.deepLinkingGroup.show(Form:C1466.deepLinking.enabled)
	
	This:C1470.checkAuthenticationMethod()
	
	If (Form:C1466.deepLinking.enabled)
		
		This:C1470.validateScheme()
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.server.pushNotification))
			
			If (Feature.disabled("androidPushNotifications"))
				
				androidLimitations(False:C215; "Push notifications is coming soon for Android")
				
			End if 
			
			//______________________________________________________
		: (Feature.with("androidDeepLinking"))
			
			//
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.deepLinking.enabled))
			
			androidLimitations(False:C215; "Deep Linking is coming soon for Android")
			
			//______________________________________________________
		: (Bool:C1537(Form:C1466.server.pushNotification))\
			 & Bool:C1537(Form:C1466.deepLinking.enabled)
			
			androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
			
			//______________________________________________________
		Else 
			
			If (Feature.with("androidDeepLinking"))
				
				androidLimitations(False:C215; "Push notifications is coming soon for Android")
				
			Else 
				
				androidLimitations(False:C215; "Push notifications and Deep Linking are coming soon for Android")
				
			End if 
			
			//______________________________________________________
	End case 
	
	If (Not:C34(Feature.with("androidDeepLinking")))
		
		This:C1470.deepLinking.enable(Is macOS:C1572 & PROJECT.$ios)
		This:C1470.deepLinkingGroup.enable(Is macOS:C1572 & PROJECT.$ios)
		
	End if 
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get loginForm() : Text
	
	var $o : Object
	
	If (PROJECT.login=Null:C1517)
		
		return Get localized string:C991("default")
		
	Else 
		
		$o:=This:C1470.getUserLoginForms().query("source = :1"; PROJECT.login).pop()
		return $o=Null:C1517 ? PROJECT.login : $o.name
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function getUserLoginForms() : Collection
	
	var $loginForm; $manifest; $o : Object
	var $forms; $target : Collection
	var $resources; $sources : 4D:C1709.Folder
	var $errors : cs:C1710.error
	
	$forms:=New collection:C1472
	
	$resources:=cs:C1710.path.new().hostloginForms()
	
	If ($resources.exists)
		
		$errors:=cs:C1710.error.new().hide()
		
		// Transform the target into a collection, if necessary
		$target:=(Value type:C1509(PROJECT.info.target)=Is collection:K8:32) ? PROJECT.info.target : New collection:C1472(String:C10(PROJECT.info.target))
		
		For each ($loginForm; $resources.folders().combine($resources.files().query("extension = :1"; SHARED.archiveExtension)))
			
			$sources:=$loginForm.isFile ? ZIP Read archive:C1637($loginForm).root : $loginForm
			
			If ($sources.file("manifest.json").exists)
				
				$manifest:=JSON Parse:C1218($sources.file("manifest.json").getText())
				
				If ($manifest.target=Null:C1517)
					
					$manifest.target:=New collection:C1472
					
					If ($sources.folder("android").exists)
						
						$manifest.target.push("android")
						
					End if 
					
					If ($sources.folder("ios").exists) | ($sources.folder("Sources").exists)
						
						$manifest.target.push("iOS")
						
					End if 
					
				Else 
					
					// Transform the target into a collection, if necessary
					$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
					
				End if 
				
				If (($manifest.target.length=2) & ($target.length=2))\
					 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))
					
					If ($loginForm.isFolder)
						
						$forms.push(New object:C1471(\
							"name"; $manifest.name; \
							"source"; "/"+$loginForm.name))
						
						// Remove zip occurence, if any
						$o:=$forms.query("source = :1"; "/"+$loginForm.name+SHARED.archiveExtension).pop()
						
						If ($o#Null:C1517)
							
							$forms.remove($forms.indexOf($o))
							
						End if 
						
					Else 
						
						// Don't append if folder exists
						If ($forms.query("source = :1"; "/"+Replace string:C233($loginForm.fullName; SHARED.archiveExtension; "")).pop()=Null:C1517)
							
							$forms.push(New object:C1471(\
								"name"; $manifest.name; \
								"source"; "/"+$loginForm.fullName))
							
						End if 
					End if 
				End if 
			End if 
		End for each 
		
		$errors.show()
		
	End if 
	
	return $forms
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function checkAuthenticationMethod
	
	ARRAY TEXT:C222($methods; 0x0000)
	METHOD GET PATHS:C1163(Path database method:K72:2; $methods; *)
	$methods{0}:=METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAuthentication")
	
	This:C1470.authenticationButton\
		.setTitle(Choose:C955(Find in array:C230($methods; $methods{0})=-1; "create..."; "edit..."))\
		.bestSize()\
		.show(Form:C1466.server.authentication.email)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function initScheme
	
	If (Length:C16(String:C10(Form:C1466.deepLinking.urlScheme))=0)
		
		Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Form:C1466.product.name)+"://"
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function validateScheme
	var $0 : Boolean
	
	This:C1470.initScheme()
	
	$0:=Match regex:C1019("(?mi-s)^[[:alpha:]][-+\\.[:alpha:][:digit:]]+(?:://)?$"; Form:C1466.deepLinking.urlScheme; 1)
	
	If ($0)
		
		Form:C1466.deepLinking.urlScheme:=formatString("urlScheme"; Replace string:C233(Form:C1466.deepLinking.urlScheme; "://"; ""))+"://"
		This:C1470.deepSchemeAlert.reset()
		
	Else 
		
		This:C1470.deepSchemeAlert.alert("schemeFormat")
		This:C1470.deepScheme.focus()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Callback from pathPicker widget
Function certificateCallback($file : 4D:C1709.File)
	
	If ($file#Null:C1517)\
		 && ($file.exists)\
		 && ($file.path#String:C10(PROJECT.server.pushCertificate))
		
		PROJECT.server.pushCertificate:=cs:C1710.doc.new($file).relativePath
		PROJECT.save()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Callback from pathPicker widget
Function configureFileCallback($file : 4D:C1709.File)
	
	If ($file#Null:C1517)\
		 && ($file.exists)\
		 && ($file.path#String:C10(PROJECT.server.configurationFile))
		
		If ($file.name="google-services")
			
			$file:=$file.copyTo(PROJECT._folder; fk overwrite:K87:5)
			PROJECT.server.configurationFile:=cs:C1710.doc.new($file).relativePath
			PROJECT.save()
			
		Else 
			
			POST_MESSAGE(New object:C1471(\
				"target"; Current form window:C827; \
				"action"; "show"; \
				"type"; "alert"; \
				"title"; "wrongFileName"; \
				"additional"; "theFileNameMustBeExactlyGoogleServices"; \
				"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "resetGoogleCertificat"))))
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function resetGoogleCertificat()
	
	This:C1470.configureFile.picker.path:=String:C10(Form:C1466.server.configurationFile)
	This:C1470.configureFile.picker:=This:C1470.configureFile.picker