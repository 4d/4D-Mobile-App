//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_error_has
  // Created 02-08-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Return if there is an error
  // ----------------------------------------------------
#DECLARE($Obj_in: Object): Boolean

Case of 
	: ($Obj_in.error#Null:C1517)
		return True:C214
	: ($Obj_in.errors#Null:C1517)
		return True:C214
End case 

return False:C215