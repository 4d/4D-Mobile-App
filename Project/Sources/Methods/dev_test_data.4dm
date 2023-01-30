//%attributes = {"invisible":true}


ARRAY TEXT:C222($anames; 0)
ARRAY TEXT:C222($avalues; 0)
WEB GET VARIABLES:C683($anames; $avalues)


If (Size of array:C274($anames)=0)
	
	WEB Server:C1674(Web server host database:K73:31).start()
	
	// normal code, run the test
	<>testData:=cs:C1710.DevTestData.new(New object:C1471("Employes"; ds:C1482.Employes; "Service"; ds:C1482.Service))
	<>testData.run()
	
Else 
	var $info : Object
	$info:=New object:C1471()
	var $i : Integer
	For ($i; 1; Size of array:C274($avalues); 1)
		$info[$anames{$i}]:=$avalues{$i}
	End for 
	
	<>testData.xCallback($info)
	
End if 

