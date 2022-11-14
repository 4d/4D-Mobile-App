Class extends FormTemplate

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="login")
	
Function doRun
	C_OBJECT:C1216($0)
	This:C1470.template.inject:=True:C214  // request always to inject files
	
	If (FolderFrom(This:C1470.template.source).folder("ios").exists)
		This:C1470.template.source:=FolderFrom(This:C1470.template.source).folder("ios").platformPath
	End if 
	
	$0:=Super:C1706.doRun()  // copy files
	