//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : panel_SET_FOCUS
  // ID[E4416EA7A7C542C391AB613FAB3A67BF]
  // Created 12-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_object)

If (False:C215)
	C_TEXT:C284(panel_SET_FOCUS ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  //NO PARAMETERS REQUIRED
	
	  //Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_object:=$1
		
	End if 
	
	ARRAY TEXT:C222($tTxt_objectNames;0x0000)
	FORM GET ENTRY ORDER:C1469($tTxt_objectNames)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Find in array:C230($tTxt_objectNames;$Txt_object)>0)
	
	GOTO OBJECT:C206(*;$Txt_object)
	
Else 
	
	If (Size of array:C274($tTxt_objectNames)>0)
		
		GOTO OBJECT:C206(*;$tTxt_objectNames{1})
		
	Else 
		
		GOTO OBJECT:C206(*;"")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End