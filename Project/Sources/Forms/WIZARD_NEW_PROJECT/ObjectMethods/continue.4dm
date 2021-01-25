If (Length:C16(Form:C1466.$name)=0)
	
	DO_MESSAGE(New object:C1471(\
		"action"; "show"; \
		"type"; "alert"; \
		"title"; "theProjectNameCanNotBeEmpty"))
	
	Form:C1466._new.focus()
	
Else 
	
	Form:C1466.folder:=cs:C1710.path.new().projects(True:C214).folder(Form:C1466.$name)
	
	If (Not:C34(Form:C1466.folder.exists))
		
		ACCEPT:C269
		
	Else 
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "confirm"; \
			"title"; "thisProjectAlreadyExist"))
		
	End if 
End if 