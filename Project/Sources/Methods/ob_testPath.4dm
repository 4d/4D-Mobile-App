//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ob_testPath
  // Database: 4D Mobile App
  // ID[0891820C25E74BAFB812771534BE392B]
  // Created #15-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Checks if the path exists and return True if so,
  // even if not contain any values (not same result as comparison to Null)
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_TEXT:C284(${3})

C_BOOLEAN:C305($Boo_pathExist)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_POINTER:C301($Ptr_schem)
C_TEXT:C284($Txt_property)
C_OBJECT:C1216($Obj_buffer;$Obj_in;$Obj_schem;$Obj_sub)

If (False:C215)
	C_BOOLEAN:C305(ob_testPath ;$0)
	C_OBJECT:C1216(ob_testPath ;$1)
	C_TEXT:C284(ob_testPath ;$2)
	C_TEXT:C284(ob_testPath ;${3})
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Txt_property:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
	$Obj_buffer:=New object:C1471
	$Obj_schem:=$Obj_buffer
	$Ptr_schem:=->$Obj_schem
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;2;$Lon_parameters;1)
	
	$Ptr_schem->type:="object"
	$Ptr_schem->required:=New collection:C1472
	$Ptr_schem->required[0]:=${$Lon_i}
	
	If ($Lon_i<$Lon_parameters)
		
		$Obj_sub:=New object:C1471
		
		$Ptr_schem->properties:=New object:C1471
		$Ptr_schem->properties[${$Lon_i}]:=$Obj_sub
		
		$Obj_buffer:=$Obj_sub
		
		$Ptr_schem:=->$Obj_buffer
		
	End if 
End for 

$Boo_pathExist:=JSON Validate:C1456($Obj_in;$Obj_schem).success

  // ----------------------------------------------------
  // Return
$0:=$Boo_pathExist

  // ----------------------------------------------------
  // End