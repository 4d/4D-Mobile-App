//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FINALLY
  // ID[60889CD973B541919706019315ECEAA7]
  // Created #18-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284($1)

C_TEXT:C284($t)

If (False:C215)
	C_TEXT:C284(FINALLY ;$1)
End if 

C_OBJECT:C1216(unitErr)

  // ----------------------------------------------------
If (Count parameters:C259>=1)
	
	ON ERR CALL:C155($1)
	
Else 
	
	Use (unitErr)
		
		$t:=unitErr.unitErrorStack.pop()
		
	End use 
	
	ON ERR CALL:C155(Choose:C955(Length:C16(String:C10($t))>0;$t;"noError"))
	
End if 

SET ASSERT ENABLED:C1131(Bool:C1537(unitErr.assertEnabled);*)

  // ----------------------------------------------------

If (Storage:C1525.database.isMatrix)
	
	ALERT:C41("Done")
	
End if 