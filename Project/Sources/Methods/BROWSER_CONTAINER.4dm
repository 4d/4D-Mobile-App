//%attributes = {"invisible":true}
var $data; $e; $widget : Object

$e:=FORM Event:C1606

If ($e.code=-1)  // Close
	
	EDITOR.hideBrowser()
	
	$widget:=EDITOR.browser
	$data:=$widget.getValue()
	
	If ($data.form#Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($data.selector="form-list")\
				 | ($data.selector="form-detail")  // Forms
				
				$data.action:="forms"
				$data.selector:=Replace string:C233($data.selector; "form-"; "")
				
				EDITOR.callMeBack("setForm"; $data)
				
				//______________________________________________________
			: ($data.selector="form-formatter")
				
				//
				
				//______________________________________________________
			: ($data.selector="form-login")
				
				//
				
				//______________________________________________________
			Else 
				
				TRACE:C157
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Close box
		
	End if 
End if 