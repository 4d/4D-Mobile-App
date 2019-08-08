//%attributes = {"invisible":true}
  // Project method : TRY
  // ID[0D905E8F790C46B59B505B1A340AB759]
  // Created 18-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284($1)

If (False:C215)
	C_TEXT:C284(TRY ;$1)
End if 

C_OBJECT:C1216(unitErr)

CLEAR VARIABLE:C89(ERROR)
CLEAR VARIABLE:C89(ERROR METHOD)
CLEAR VARIABLE:C89(ERROR LINE)
CLEAR VARIABLE:C89(ERROR FORMULA)

If (unitErr=Null:C1517)
	
	unitErr:=New shared object:C1526
	
	Use (unitErr)
		
		unitErr.unitErrors:=New shared collection:C1527
		unitErr.unitErrorStack:=New shared collection:C1527
		
	End use 
End if 

Use (unitErr)
	
	If (Count parameters:C259>=1)
		
		unitErr.signature:=$1
		
	End if 
	
	unitErr.assertEnabled:=Get assert enabled:C1130
	
	unitErr.unitErrorStack.push(Method called on error:C704)
	
End use 

SET ASSERT ENABLED:C1131(True:C214;*)

  // Don't catch unitErrors in dev mode
ON ERR CALL:C155(Choose:C955(Bool:C1537(Storage:C1525.database.isMatrix);"";"CATCH"))

  // ----------------------------------------------------