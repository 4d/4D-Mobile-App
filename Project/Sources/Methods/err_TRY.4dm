//%attributes = {"invisible":true,"preemptive":"capable"}
// Project method : TRY
// ID[0D905E8F790C46B59B505B1A340AB759]
// Created 18-5-2017 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($signature : Text)

If (False:C215)
	C_TEXT:C284(err_TRY; $1)
End if 

COMPILER_err

CLEAR VARIABLE:C89(ERROR)
CLEAR VARIABLE:C89(ERROR METHOD)
CLEAR VARIABLE:C89(ERROR LINE)
CLEAR VARIABLE:C89(ERROR FORMULA)

If (errStack=Null:C1517)
	
	errStack:=New shared object:C1526
	
	Use (errStack)
		
		errStack.errors:=New shared collection:C1527
		errStack.errorStack:=New shared collection:C1527
		
	End use 
End if 

Use (errStack)
	
	If (Count parameters:C259>=1)
		
		errStack.signature:=$signature
		
	End if 
	
	// Keep the assertions status
	errStack.assertEnabled:=Get assert enabled:C1130
	
	// Keep the current method called on error
	errStack.errorStack.push(Method called on error:C704)
	
End use 

SET ASSERT ENABLED:C1131(True:C214; *)

If (Structure file:C489=Structure file:C489(*))\
 & Not:C34(Is compiled mode:C492)
	
	// Don't catch errors in dev mode
	ON ERR CALL:C155("")
	
Else 
	
	ON ERR CALL:C155("err_CATCH")
	
End if 