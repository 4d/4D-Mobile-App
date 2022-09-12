var $icon : Picture
var $o : Object

ARRAY TEXT:C222($componentsArray; 0)

If (Not:C34(Is compiled mode:C492))
	
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
		// Add custom actions
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/phone-blue.png").platformPath; $icon)
		$o:=New object:C1471(\
			"name"; "Open Mobile Project"; \
			"formula"; Formula:C1597(_OPEN_MOBILE_PROJECT); \
			"icon"; $icon)
		EXECUTE METHOD:C1007("quickOpenPushAction"; *; $o)
		
		$o:=New object:C1471(\
			"name"; "New Mobile Project"; \
			"formula"; Formula:C1597(_NEW_MOBILE_PROJECT); \
			"icon"; $icon)
		EXECUTE METHOD:C1007("quickOpenPushAction"; *; $o)
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/phone-orange.png").platformPath; $icon)
		$o:=New object:C1471(\
			"name"; "Mobile Project folder"; \
			"formula"; Formula:C1597(SHOW ON DISK:C922(Folder:C1567(fk database folder:K87:14).folder("Mobile Projects").platformPath; *)); \
			"icon"; $icon)
		EXECUTE METHOD:C1007("quickOpenPushAction"; *; $o)
		
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/phone-red.png").platformPath; $icon)
		$o:=New object:C1471(\
			"name"; "Test"; \
			"formula"; Formula:C1597(00_TESTS); \
			"icon"; $icon; \
			"shortcut"; "mobile")
		EXECUTE METHOD:C1007("quickOpenPushAction"; *; $o)
		
	End if 
	
	checkGitBranch
	
End if 