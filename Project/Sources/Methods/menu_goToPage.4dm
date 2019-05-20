//%attributes = {"invisible":true}
C_TEXT:C284($kTxt_callbackMethod;$Txt_parameter)
C_LONGINT:C283($Win_me)
$kTxt_callbackMethod:="editor_CALLBACK"

$Win_me:=Current form window:C827
$Txt_parameter:=Get selected menu item parameter:C1005

If (Length:C16($Txt_parameter)>0)
	
	CALL FORM:C1391($Win_me;$kTxt_callbackMethod;"goToPage";New object:C1471(\
		"page";$Txt_parameter))
	
End if 