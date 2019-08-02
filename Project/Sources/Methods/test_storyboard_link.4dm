//%attributes = {"invisible":true,"preemptive":"capable"}


C_OBJECT:C1216($Obj_in;$Obj_out;$File_)
C_TEXT:C284($Txt_buffer)


  // Get a dom for a scene
$Obj_in:=New object:C1471("action";"addScene";"name";"DestinationNameForm";"connection";True:C214)
$File_:=COMPONENT_Pathname ("templates").folder("form").folder("detail").folder("Simple List").folder\
("Sources").folder("Forms").folder("Tables").folder("___TABLE___").file("___TABLE___DetailsForm.storyboard")

$Obj_in.dom:=DOM Parse XML source:C719($File_.platformPath)
$Obj_out:=storyboard ($Obj_in)
ASSERT:C1129($Obj_out.success;JSON Stringify:C1217($Obj_out))

DOM EXPORT TO VAR:C863($Obj_out.dom;$Txt_buffer)
ASSERT:C1129(Length:C16($Txt_buffer)>0)

If (Shift down:C543)
	$File_:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file("test_storyboard"+Generate UUID:C1066+".xml")
	DOM EXPORT TO FILE:C862($Obj_out.dom;$File_.platformPath)
	SHOW ON DISK:C922($File_.platformPath)
	
End if 

DOM CLOSE XML:C722($Obj_in.dom)