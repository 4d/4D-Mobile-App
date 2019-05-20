//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : col_formula
  // Database: 4D Mobile App
  // Created #27-7-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Use formula on each element.
  // To be use with `.map` or other collection member functions.
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($1)
C_TEXT:C284($2)

If (False:C215)
	C_OBJECT:C1216(col_formula ;$1)
	C_TEXT:C284(col_formula ;$2)
End if 

  // ----------------------------------------------------

EXECUTE FORMULA:C63($2)