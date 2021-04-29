//%attributes = {"invisible":true}
#DECLARE($disable : Boolean; $message : Text)

If (FEATURE.with("android"))
	
	If (EDITOR.android)
		
		If (Count parameters:C259>=1)
			
			If ($disable)
				
				OBJECT SET ENABLED:C1123(*; "@"; Is macOS:C1572 & EDITOR.ios)
				
			End if 
			
			If (Count parameters:C259>=2)
				
				var $o : Object
				$o:=New object:C1471
				$o.message:=$message
				$o.type:="android"
				EDITOR.call("footer"; $o)
				
			End if 
		End if 
	End if 
End if 