//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : CATCH
// ID[0B2F351611D34984A8FCDB08E2E5F5A4]
// Created 10-3-2017 by Vincent de Lachaux
// ----------------------------------------------------
C_COLLECTION:C1488($1)

C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_COLLECTION:C1488(err_CATCH; $1)
End if 

COMPILER_err

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
	
	Use (errStack)
		
		errStack.errors.push($o)
		
	End use 
	
	_4D THROW ERROR:C1520
	
Else   // Populate
	
	$c:=$1
	
	If ($c#Null:C1517)
		
		Use (errStack)
			
			For each ($o; $c)
				
				errStack.errors.push(OB Copy:C1225($o))
				
			End for each 
		End use 
	End if 
End if 

// ----------------------------------------------------