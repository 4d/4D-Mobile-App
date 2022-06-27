//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : col_formula
// Created 27-7-2018 by Eric Marchand
// ----------------------------------------------------
// Description:
// Use formula on each element.
// To be use with `.map` or other collection member functions.
// ----------------------------------------------------
#DECLARE($this : Object; $formula)

If (False:C215)
	C_OBJECT:C1216(col_formula; $1)
	C_VARIANT:C1683(col_formula; $2)
End if 

Case of 
		
		//______________________________________________________
	: (Value type:C1509($formula)=Is text:K8:3)  // Text formula
		
		EXECUTE FORMULA:C63($formula)
		
		//______________________________________________________
	: (Value type:C1509($formula)=Is object:K8:27)
		
		ASSERT:C1129(OB Instance of:C1731($formula; 4D:C1709.Function))
		
		$formula.call(Null:C1517; $this)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "col_formula not correct type: "+String:C10(Value type:C1509($formula)))
		
		//______________________________________________________
End case 