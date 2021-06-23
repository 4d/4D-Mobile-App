var $name : Text

//$name:=Select document(cs.path.new().projects().platformPath; SHARED.extension; Get localized string("selectTheProjectToOpen"); Package open+Use sheet window)

$name:=Select document:C905(EDITOR.path.projects().platformPath; SHARED.extension; Get localized string:C991("selectTheProjectToOpen"); Package open:K24:8+Use sheet window:K24:11)

If (OK=1)
	
	If (FEATURE.with("android"))
		
		Form:C1466.file:=File:C1566(DOCUMENT; fk platform path:K87:2)
		Form:C1466.folder:=Form:C1466.file.parent
		Form:C1466.$name:=Form:C1466.folder.fullName
		
		Form:C1466.project:=DOCUMENT
		
		ACCEPT:C269
		
	Else 
		
		var $file : 4D:C1709.File
		$file:=File:C1566(DOCUMENT; fk platform path:K87:2)
		
		var $project : Object
		$project:=JSON Parse:C1218($file.getText())
		
		var $success : Boolean
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($project.info.target)=Is collection:K8:32)
				
				$success:=($project.info.target.indexOf("android")=-1)
				
				//______________________________________________________
			: (Value type:C1509($project.info.target)=Is text:K8:3)
				
				$success:=($project.info.target#"android")
				
				//______________________________________________________
		End case 
		
		If ($success)
			
			Form:C1466.file:=File:C1566(DOCUMENT; fk platform path:K87:2)
			Form:C1466.folder:=Form:C1466.file.parent
			Form:C1466.$name:=Form:C1466.folder.fullName
			
			Form:C1466.project:=DOCUMENT
			
			ACCEPT:C269
			
		Else 
			
			DO_MESSAGE(New object:C1471(\
				"action"; "show"; \
				"type"; "alert"; \
				"title"; "invalidProject"; \
				"additional"; "This project cannot be loaded with 4D v19"))
			
		End if 
	End if 
	
End if 