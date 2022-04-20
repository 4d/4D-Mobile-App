
Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $o : Object
		$o:=New object:C1471(\
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; "someStructuralAdjustmentsAreNeeded"; \
			"additional"; "doYouAllow4dToModifyStructure"; \
			"ok"; "allow"; \
			"option"; New object:C1471("title"; "rememberMyChoice"; "value"; False:C215); \
			"target"; Current form window:C827)
		
		UI.postMessage($o)
		
		//______________________________________________________
	: (True:C214)
		
		UI.doCancelableProgress(New object:C1471(\
			"title"; "dataSetGeneration"; \
			"cancelMessage"; "Z'ETES CERTAINS?"))
		
		//______________________________________________________
End case 