//%attributes = {}
#DECLARE($platformPath : Text)->$result : Object

var $isFolder : Boolean
If (Is macOS:C1572 || Is Windows:C1573)
	$isFolder:=Path to object:C1547($platformPath).isFolder  // XXX check if TestPathName or test path name if more efficiant
Else 
	$isFolder:=TestPathName($platformPath)=Is a folder:K24:2  // not very efficiant on L, Folder and File already created, so we could return it
End if 
If ($isFolder)
	
	$result:=Folder:C1567($platformPath; fk platform path:K87:2)
	
Else 
	
	$result:=File:C1566($platformPath; fk platform path:K87:2)
	
End if 