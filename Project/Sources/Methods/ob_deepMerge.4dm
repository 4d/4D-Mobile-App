//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : ob_deepMerge
// ----------------------------------------------------
// Description:
// Copy object properties from source to target
// ----------------------------------------------------
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!! NOT FINALIZED !!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)
C_BOOLEAN:C305($3)

C_LONGINT:C283($Lon_parameters; $Lon_sourceType)
C_TEXT:C284($Txt_property)
C_OBJECT:C1216($Obj_source; $Obj_target)
var $overwrite : Boolean

If (False:C215)
	C_OBJECT:C1216(ob_deepMerge; $0)
	C_OBJECT:C1216(ob_deepMerge; $1)
	C_OBJECT:C1216(ob_deepMerge; $2)
	C_BOOLEAN:C305(ob_deepMerge; $3)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	// Required parameters
	$Obj_target:=$1
	$Obj_source:=$2
	
	If ($Obj_target=Null:C1517)
		
		$Obj_target:=New object:C1471
		
	End if 
	
	If (Count parameters:C259>2)
		$overwrite:=$3
	Else 
		$overwrite:=True:C214
	End if 
	
Else 
	
	ABORT:C156
	
End if 

//TRACE

// ----------------------------------------------------
For each ($Txt_property; $Obj_source)
	
	$Lon_sourceType:=Value type:C1509($Obj_source[$Txt_property])
	
	Case of 
			
			//________________________________________
		: ($Lon_sourceType=Is object:K8:27)
			
			Case of 
				: ($Obj_target[$Txt_property]=Null:C1517)
					
					$Obj_target[$Txt_property]:=OB Copy:C1225($Obj_source[$Txt_property])
					
				: ($overwrite)
					If (Value type:C1509($Obj_target[$Txt_property])#Is object:K8:27)
						
						$Obj_target[$Txt_property]:=New object:C1471
						
					End if 
					
					$Obj_target[$Txt_property]:=ob_deepMerge(\
						$Obj_target[$Txt_property]; \
						OB Copy:C1225($Obj_source[$Txt_property]); \
						$overwrite)
					
					// Else ignore, 
			End case 
			
			//________________________________________
		: ($Lon_sourceType=Is collection:K8:32)
			
			Case of 
				: ($Obj_target[$Txt_property]=Null:C1517)
					
					$Obj_target[$Txt_property]:=$Obj_source[$Txt_property].copy()
					
				: ($overwrite)
					
					If (Value type:C1509($Obj_target[$Txt_property])#Is collection:K8:32)
						
						$Obj_target[$Txt_property]:=New collection:C1472
						
					End if 
					
					$Obj_target[$Txt_property]:=$Obj_target[$Txt_property].concat($Obj_source[$Txt_property].copy())
					
					// Else ignore, do not overwrite
			End case 
			
			//________________________________________
		Else 
			
			Case of 
				: ($overwrite)
					$Obj_target[$Txt_property]:=$Obj_source[$Txt_property]
				: ($Obj_target[$Txt_property]=Null:C1517)
					$Obj_target[$Txt_property]:=$Obj_source[$Txt_property]
					// Else ignore, do not override
			End case 
			//________________________________________
	End case 
End for each 

// ----------------------------------------------------
// Return
$0:=$Obj_target

// ----------------------------------------------------
// End