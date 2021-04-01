//%attributes = {"invisible":true}
#DECLARE($disable : Boolean; $message : Text)

If (FEATURE.with("android"))
	
	If (PROJECT.$android)
		
		If (Count parameters:C259>=1)
			
			If ($disable)
				
				OBJECT SET ENABLED:C1123(*; "@"; Is macOS:C1572 & PROJECT.$ios)
				
			End if 
			
			If (Count parameters:C259>=2)
				
				CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "footer"; New object:C1471(\
					"message"; $message; \
					"type"; "android"))
				
			End if 
		End if 
	End if 
End if 