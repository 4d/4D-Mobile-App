var $name : Text

$name:=Select document:C905(EDITOR.path.projects().platformPath; SHARED.extension; Get localized string:C991("selectTheProjectToOpen"); Package open:K24:8+Use sheet window:K24:11)

If (OK=1)
	
	Form:C1466.file:=File:C1566(DOCUMENT; fk platform path:K87:2)
	Form:C1466.folder:=Form:C1466.file.parent
	Form:C1466.$name:=Form:C1466.folder.fullName
	
	Form:C1466.project:=DOCUMENT
	
	ACCEPT:C269
	
End if 