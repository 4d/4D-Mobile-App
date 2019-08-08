//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : col_distinctObject
  // Database: 4D Mobile App
  // Created 21-8-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Used with reduce to return only distinct objects.
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

If (False:C215)
	C_OBJECT:C1216(col_distinctObject ;$1)
	C_OBJECT:C1216(col_distinctObject ;$2)
End if 

  // ----------------------------------------------------
If (Value type:C1509($1.value)=Is object:K8:27)
	
	If ($1.accumulator.findIndex("col_findObject";$1.value)<0)
		
		$1.accumulator.push($1.value)
		
	End if 
	
End if 
