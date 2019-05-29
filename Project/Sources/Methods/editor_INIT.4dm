//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_INIT
  // Database: 4D Mobile Express
  // ID[F59AB4219B794E8E94DDB5849F25D76D]
  // Created #21-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_form)

If (False:C215)
	C_OBJECT:C1216(editor_INIT ;$0)
	C_TEXT:C284(editor_INIT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	$Txt_form:=Current form name:C1298
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_form:=$1
		
	End if 
	
	If (Length:C16($Txt_form)=0)
		
		TRACE:C157
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Form:C1466.$dialog=Null:C1517)
	
	Form:C1466.$dialog:=New object:C1471(\
		$Txt_form;New object:C1471)
	
Else 
	
	If (Form:C1466.$dialog[$Txt_form]=Null:C1517)
		
		Form:C1466.$dialog[$Txt_form]:=New object:C1471
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=Form:C1466.$dialog[$Txt_form]

  // ----------------------------------------------------
  // End