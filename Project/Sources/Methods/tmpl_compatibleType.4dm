//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_compatibleType
  // Database: 4D Mobile App
  // ID[65F3645D18C04D849BF87223A26F3364]
  // Created #12-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_COLLECTION:C1488($1)
C_LONGINT:C283($2)

C_BOOLEAN:C305($Boo_accepted)
C_LONGINT:C283($Lon_parameters;$Lon_type)
C_COLLECTION:C1488($Col_types)

If (False:C215)
	C_BOOLEAN:C305(tmpl_compatibleType ;$0)
	C_COLLECTION:C1488(tmpl_compatibleType ;$1)
	C_LONGINT:C283(tmpl_compatibleType ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Col_types:=$1  //Collection des types
	$Lon_type:=$2  //type à tester
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Col_types.every("col_formula";"$1.result:=($1.value>=0)"))
	  //If ($Col_types.every("col_method";Formula($1.result:=($1.value>=0))))
	
	  // One of them
	$Boo_accepted:=($Col_types.indexOf($Lon_type)#-1)
	
Else 
	
	  // None of them
	$Boo_accepted:=($Col_types.filter("col_formula";"$1.result:=($1.value="+String:C10(-$Lon_type)+")").length=0)
	  //$Boo_accepted:=($Col_types.filter("col_method";Formula($1.result:=($1.value=+String(-$Lon_type)))).length=0)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Boo_accepted  //vrai si compatible

  // ----------------------------------------------------
  // End