//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ob_getByPath
  // Database: 4D Mobile App
  // ID[A2EADCB4EFCC42108E9199B5663F22F5]
  // Created #25-4-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Acces a property using its path in dot notation as a string
  // usage: $value:=ob_getByPath ($o;"a.b").value
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters;$Lon_x)
C_TEXT:C284($Txt_indx;$Txt_path;$Txt_propety)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(ob_getByPath ;$0)
	C_OBJECT:C1216(ob_getByPath ;$1)
	C_TEXT:C284(ob_getByPath ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Txt_path:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_out:=New object:C1471(\
"value";$Obj_in)

For each ($Txt_propety;Split string:C1554($Txt_path;"."))
	
	$Lon_x:=Position:C15("[";$Txt_propety)
	
	If ($Lon_x>0)
		
		$Txt_indx:=Substring:C12($Txt_propety;$Lon_x+1;Position:C15("]";$Txt_propety)-1)
		$Txt_propety:=Delete string:C232($Txt_propety;$Lon_x;Length:C16($Txt_propety))
		
		If (Asserted:C1132(Value type:C1509($Obj_out.value[$Txt_propety])=Is collection:K8:32))
			
			$Obj_out.value:=$Obj_out.value[$Txt_propety][Num:C11($Txt_indx)]
			
		End if 
		
	Else 
		
		If (Asserted:C1132(Value type:C1509($Obj_out.value[$Txt_propety])#Is collection:K8:32))
			
			  // Get the property
			$Obj_out.value:=$Obj_out.value[$Txt_propety]
			
		End if 
	End if 
End for each 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End