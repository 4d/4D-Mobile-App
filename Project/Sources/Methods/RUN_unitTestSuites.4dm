//%attributes = {"preemptive":"incapable"}
var $o; $response : Object

$response:=mobileUnit("testSuites")

If ($response.success)
	
	SET ASSERT ENABLED:C1131(True:C214; *)
	
	For each ($o; $response.tests)
		
		$o.call()
		
	End for each 
End if 

TRACE:C157