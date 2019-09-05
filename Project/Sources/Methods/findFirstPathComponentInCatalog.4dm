//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : doc_catalogFirstPath
  // ID[8328FC3981DB45DC9CFEF6A39E8F4473]
  // Created 04-06-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Find the first path in collection returned by
  // doc_catalog
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)
C_COLLECTION:C1488($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_property)
C_COLLECTION:C1488($Col_catalog;$Col_result)

If (False:C215)
	C_COLLECTION:C1488(findFirstPathComponentInCatalog ;$0)
	C_COLLECTION:C1488(findFirstPathComponentInCatalog ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Col_catalog:=$1
	
	$Col_result:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;0;$Col_catalog.length-1;1)
	
	If ((Value type:C1509($Col_catalog[$Lon_i]))=Is object:K8:27)
		
		For each ($Txt_property;$Col_catalog[$Lon_i])
			
			$Col_result.push($Txt_property)
			
			$Col_result:=$Col_result.combine(findFirstPathComponentInCatalog ($Col_catalog[$Lon_i][$Txt_property]))  // <=========== RECURSIVE
			
		End for each 
		
		$Lon_i:=MAXLONG:K35:2-1  // Break
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
$0:=$Col_result

  // ----------------------------------------------------
  // End