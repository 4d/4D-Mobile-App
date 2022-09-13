//%attributes = {}
var $test : 4D:C1709.Function

For each ($test; mobileUnit("testSuites").tests)
	
	$test.call()
	
End for each 