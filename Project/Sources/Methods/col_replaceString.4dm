//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : col_replaceString
  // Created 26-7-2018 by Eric Marchabd
  // ----------------------------------------------------
  // Description:
  // Convert replace string.
  // To be use with `.map`.
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_TEXT:C284($3)

If (False:C215)
	C_OBJECT:C1216(col_replaceString ;$1)
	C_TEXT:C284(col_replaceString ;$2)
	C_TEXT:C284(col_replaceString ;$3)
End if 

  // ----------------------------------------------------

$1.result:=Replace string:C233($1.value;$2;$3)
