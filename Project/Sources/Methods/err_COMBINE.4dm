//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : err_COMBINE
  // ID[72334FE6E087403FBAA9FA33B053101E]
  // Created 7-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)
C_LONGINT:C283($3)

C_LONGINT:C283($Lon_parameters;$Lon_type)
C_OBJECT:C1216($Obj_source;$Obj_target)

If (False:C215)
	C_OBJECT:C1216(err_COMBINE ;$1)
	C_OBJECT:C1216(err_COMBINE ;$2)
	C_LONGINT:C283(err_COMBINE ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_source:=$1
	$Obj_target:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Lon_type:=$3  // errors by default
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Lon_type=0)\
 | ($Lon_type=Information message:K38:1)
	
	If ($Obj_source["infos"]#Null:C1517)
		
		If ($Obj_target["infos"]=Null:C1517)
			
			$Obj_target["infos"]:=New collection:C1472
			
		End if 
		
		$Obj_target["infos"].combine($Obj_source["infos"])
		
	End if 
End if 

If ($Lon_type=0)\
 | ($Lon_type=Error message:K38:3)
	
	If ($Obj_source["errors"]#Null:C1517)
		
		If ($Obj_target["errors"]=Null:C1517)
			
			$Obj_target["errors"]:=New collection:C1472
			
		End if 
		
		$Obj_target["errors"].combine($Obj_source["errors"])
		
	End if 
End if 

If ($Lon_type=0)\
 | ($Lon_type=Warning message:K38:2)
	
	If ($Obj_source["warnings"]#Null:C1517)
		
		If ($Obj_target["warnings"]=Null:C1517)
			
			$Obj_target["warnings"]:=New collection:C1472
			
		End if 
		
		$Obj_target["warnings"].combine($Obj_source["warnings"])
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End