//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_removeFormula
  // Created 14-8-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Remove object formula from object. Only first level.
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($object;$1)

If (False:C215)
	C_OBJECT:C1216(ob_removeFormula ;$1)
End if 

$object:=$1

C_TEXT:C284($key)
For each ($key;$object)
	If (Value type:C1509($object[$key])=Is object:K8:27)
		  // I find this only way to identify formula (but any object with call attribut will be removed too...), there is no Is Formula or Native Function
		If ($object[$key].call#Null:C1517)
			OB REMOVE:C1226($object;$key)
		End if 
	End if 
End for each 
