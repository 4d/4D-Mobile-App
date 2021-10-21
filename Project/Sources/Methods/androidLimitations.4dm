//%attributes = {"invisible":true}
#DECLARE($disable : Boolean; $message : Text)

If (EDITOR.android)
	
	If (Count parameters:C259>=1)
		
		If ($disable)
			
			OBJECT SET ENABLED:C1123(*; "@"; Is macOS:C1572 & EDITOR.ios)
			
		End if 
		
		If (Count parameters:C259>=2)
			
			EDITOR.callMeBack("footer"; New object:C1471(\
				"message"; $message; \
				"type"; "android"))
			
		End if 
	End if 
End if 