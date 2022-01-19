//%attributes = {"invisible":true}
var $parameter : Text

$parameter:=Get selected menu item parameter:C1005

If (Length:C16($parameter)>0)
	
	CALL FORM:C1391(Current form window:C827; Formula:C1597(editor_CALLBACK).source; "goToPage"; New object:C1471(\
		"page"; $parameter))
	
End if 