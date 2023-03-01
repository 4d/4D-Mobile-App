//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_compatibleType
// ID[65F3645D18C04D849BF87223A26F3364]
// Created 12-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($0)
C_VARIANT:C1683($1)
C_LONGINT:C283($2)

C_LONGINT:C283($l)
C_COLLECTION:C1488($c)

If (False:C215)
	C_BOOLEAN:C305(tmpl_compatibleType; $0)
	C_VARIANT:C1683(tmpl_compatibleType; $1)
	C_LONGINT:C283(tmpl_compatibleType; $2)
End if 

// ----------------------------------------------------
// Initialisations

If (Asserted:C1132(Count parameters:C259>=2; "Missing parameter"))
	
	// Required parameters
	Case of 
			
			//___________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$c:=Split string:C1554($1; ","; sk trim spaces:K86:2).map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=Num:C11($1.value)))
			
			//___________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			$c:=$1  // Type Collection
			
			//___________________________
		Else 
			
			TRACE:C157
			
			//___________________________
	End case 
	
	$l:=$2  // Type to test
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($c.every(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value>=0))))
	
	// One of them
	$0:=($c.indexOf($l)#-1)
	
Else 
	
	// None of them
	$0:=($c.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value=-$l))).length=0)
	
End if 