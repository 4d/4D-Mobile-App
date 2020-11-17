//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : col_formula
// Created 27-7-2018 by Eric Marchand
// ----------------------------------------------------
// Description:
// Use formula on each element.
// To be use with `.map` or other collection member functions.
// ----------------------------------------------------
// Declarations
If (False:C215)
	C_OBJECT:C1216(col_formula; $1)
	C_VARIANT:C1683(col_formula; $2)
End if 

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: (Value type:C1509($2)=Is text:K8:3)  // Text formula
		
		EXECUTE FORMULA:C63($2)
		
		//______________________________________________________
	: (Value type:C1509($2)=Is object:K8:27)
		
		ASSERT:C1129(OB Instance of:C1731($2; 4D:C1709.Function))
		
		$2.call(Null:C1517; $1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "col_formula not correct type: "+String:C10(Value type:C1509($2)))
		
		//______________________________________________________
End case 