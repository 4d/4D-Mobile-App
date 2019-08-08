//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : col_valueToObject
  // Database: 4D Mobile App
  // Created 26-7-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Convert value to object with value as attribute, and second parameter as key.
  // To be use with `.map`.
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($1)
C_TEXT:C284($2)

If (False:C215)
	C_OBJECT:C1216(col_valueToObject ;$1)
	C_TEXT:C284(col_valueToObject ;$2)
End if 

  // ----------------------------------------------------

$1.result:=New object:C1471($2;$1.value)