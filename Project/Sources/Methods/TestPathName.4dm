//%attributes = {}
#DECLARE($path : Text)->$res : Integer

If (Is macOS:C1572 || Is Windows:C1573)
	$res:=Test path name:C476($path)
Else 
	$res:=-43
	If (Position:C15(Folder separator:K24:12; $path)=0)
		$path:=Folder:C1567(fk database folder:K87:14).platformPath+$path
	End if 
	If (Substring:C12($path; Length:C16($path))#Folder separator:K24:12)
		If (File:C1566($path; fk platform path:K87:2).exists)
			$res:=1
		End if 
	End if 
	If (Folder:C1567($path; fk platform path:K87:2).exists)
		$res:=0
	End if 
End if 