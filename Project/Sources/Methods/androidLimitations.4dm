//%attributes = {"invisible":true}
#DECLARE($disable : Boolean; $message : Text)

If (UI.android)
	
	If (Count parameters:C259>=1)
		
		If ($disable)
			
			OBJECT SET ENABLED:C1123(*; "@"; Is macOS:C1572 & UI.ios)
			
		End if 
		
		If (Count parameters:C259>=2)
			
			UI.callMeBack("footer"; New object:C1471(\
				"message"; $message; \
				"type"; "android"))
			
		End if 
	End if 
End if 