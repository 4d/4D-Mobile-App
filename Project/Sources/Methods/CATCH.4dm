//%attributes = {"invisible":true}
/*
***CATCH*** ( errors )
 -> errors (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : CATCH
  // ID[0B2F351611D34984A8FCDB08E2E5F5A4]
  // Created #10-3-2017 by Vincent de Lachaux
  // ----------------------------------------------------
C_COLLECTION:C1488($1)

C_OBJECT:C1216($o)
C_COLLECTION:C1488($Col_unitErrors)

If (False:C215)
	C_COLLECTION:C1488(CATCH ;$1)
End if 

C_OBJECT:C1216(unitErr)

  // ----------------------------------------------------
If (Count parameters:C259=0)  // Catching
	
	$o:=New shared object:C1526
	
	Use ($o)
		
		$o.code:=ERROR
		$o.method:=ERROR METHOD
		$o.line:=ERROR LINE
		$o.formula:=ERROR FORMULA
		$o.time:=Milliseconds:C459
		$o.processName:=Current process name:C1392
		$o.processNumber:=Process number:C372($o.processName)
		
	End use 
	
	Use (unitErr)
		
		unitErr.unitErrors.push($o)
		
	End use 
	
	_4D THROW ERROR:C1520
	
Else   // Populate
	
	$Col_unitErrors:=$1
	
	If ($Col_unitErrors#Null:C1517)
		
		Use (unitErr)
			
			For each ($o;$Col_unitErrors)
				
				unitErr.unitErrors.push(OB Copy:C1225($o))
				
			End for each 
		End use 
	End if 
End if 

  // ----------------------------------------------------