//%attributes = {"invisible":true,"publishedWeb":true}


ARRAY TEXT:C222($anames; 0)
ARRAY TEXT:C222($avalues; 0)
WEB GET VARIABLES:C683($anames; $avalues)


If (Size of array:C274($anames)=0)
	
	If (Not:C34(WEB Server:C1674(Web server host database:K73:31).isRunning))
		WEB Server:C1674(Web server host database:K73:31).start()
	End if 
	// normal code, run the test
	Use (Storage:C1525)
		Storage:C1525.test:=New shared object:C1526()
		Use (Storage:C1525.test)
			Storage:C1525.test.data:=OB Copy:C1225(cs:C1710.DevTestData.new(New object:C1471("Employes"; ds:C1482.Employes; "Service"; ds:C1482.Service)); ck shared:K85:29; Storage:C1525.test)
			Storage:C1525.test.data.run()
		End use 
	End use 
	
Else 
	var $info : Object
	$info:=New object:C1471()
	var $i : Integer
	For ($i; 1; Size of array:C274($avalues); 1)
		$info[$anames{$i}]:=$avalues{$i}
	End for 
	Use (Storage:C1525.test)
		Storage:C1525.test.data.xCallback($info)
	End use 
End if 

