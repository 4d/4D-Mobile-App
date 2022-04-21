//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ob_MERGE
// ID[30A5CD6BFBC3423AAFBF097521C3A034]
// Created 23-5-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Add the missing properties of the model to the target
// ----------------------------------------------------
// Declarations
#DECLARE($target : Object; $model : Object)

If (False:C215)
	C_OBJECT:C1216(ob_MERGE; $1)
	C_OBJECT:C1216(ob_MERGE; $2)
End if 

var $key : Text

ASSERT:C1129(($target#Null:C1517) & ($model#Null:C1517); "Missing parameter")

// ----------------------------------------------------
For each ($key; $model)
	
	If ($target[$key]=Null:C1517)
		
		$target[$key]:=$model[$key]
		
	Else 
		
		If (Value type:C1509($model[$key])=Is object:K8:27)
			
			ob_MERGE($target[$key]; $model[$key])  // <=========== RECURSIVE
			
		End if 
	End if 
End for each 