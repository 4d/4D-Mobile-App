//%attributes = {}
/*
***unitTestSuites*** ( Param_1 )
 -> Param_1 (Object)
________________________________________________________

*/
C_OBJECT:C1216($1)

ARRAY TEXT:C222($tTxt_tests;0)

If (False:C215)
	C_OBJECT:C1216(unitTestSuites ;$1)
End if 

METHOD GET NAMES:C1166($tTxt_tests;"test_@")

Use ($1)
	
	$1.result:=New shared collection:C1527
	
	ARRAY TO COLLECTION:C1563($1.result;$tTxt_tests)
	
End use 

$1.trigger()