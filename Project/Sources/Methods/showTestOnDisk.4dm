//%attributes = {"invisible":true,"preemptive":"capable"}


var $dimFolder : 4D:C1709.Folder
$dimFolder:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2).parent.parent.parent

var $testProjFile : 4D:C1709.File
$testProjFile:=$dimFolder.folder("4D/Tests/_Mobile").file("Project/_Mobile.4DProject")

If (Shift down:C543)
	OPEN URL:C673("file://"+$testProjFile.path)
Else 
	SHOW ON DISK:C922($testProjFile.platformPath)
End if 