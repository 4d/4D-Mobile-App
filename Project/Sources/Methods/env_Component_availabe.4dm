//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : env_Component_availabe
  // ID[C4414C778CDC47BBAF0CB743AC14E013]
  // Created 21/01/11 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_component)

ARRAY TEXT:C222($tTxt_Components;0)

If (False:C215)
	C_BOOLEAN:C305(env_Component_availabe ;$0)
	C_TEXT:C284(env_Component_availabe ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_component:=$1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
COMPONENT LIST:C1001($tTxt_Components)

$0:=(Find in array:C230($tTxt_Components;$Txt_component)>0)

  // ----------------------------------------------------
  // End