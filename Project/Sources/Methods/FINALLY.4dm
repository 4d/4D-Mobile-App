//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FINALLY
  // ID[60889CD973B541919706019315ECEAA7]
  // Created 18-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
C_TEXT:C284($1)

C_TEXT:C284($t)

If (False:C215)
	C_TEXT:C284(FINALLY ;$1)
End if 

COMPILER_err 

  // ----------------------------------------------------
If (Count parameters:C259>=1)
	
	ON ERR CALL:C155($1)
	
Else 
	
	Use (errStack)
		
		$t:=errStack.errorStack.pop()
		
	End use 
	
	ON ERR CALL:C155(Choose:C955(Length:C16(String:C10($t))>0;$t;"NO_ERROR"))
	
End if 

SET ASSERT ENABLED:C1131(Bool:C1537(errStack.assertEnabled);*)

  // ----------------------------------------------------