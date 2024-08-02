Class extends FormTemplate

Class constructor($in : Object)
	Super:C1705($in)
	ASSERT:C1129(This:C1470.template.type="login")
	
Function doRun() : Object
	This:C1470.template.inject:=True:C214  // request always to inject files
	
	If (FolderFrom(This:C1470.template.source).folder("ios").exists)
		This:C1470.template.source:=FolderFrom(This:C1470.template.source).folder("ios").platformPath
	End if 
	
	return Super:C1706.doRun()  // copy files
	