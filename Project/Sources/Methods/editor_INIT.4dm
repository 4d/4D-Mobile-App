//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_INIT
  // ID[F59AB4219B794E8E94DDB5849F25D76D]
  // Created 21-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_TEXT:C284($t)

If (False:C215)
	C_OBJECT:C1216(editor_INIT ;$0)
	C_TEXT:C284(editor_INIT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$t:=$1
	
End if 

If (Length:C16($t)=0)
	
	$t:=Current form name:C1298
	
End if 

  // ----------------------------------------------------
If (Form:C1466.$dialog=Null:C1517)
	
	Form:C1466.$dialog:=New object:C1471(\
		$t;New object:C1471)
	
Else 
	
	If (Form:C1466.$dialog[$t]=Null:C1517)
		
		Form:C1466.$dialog[$t]:=New object:C1471
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=Form:C1466.$dialog[$t]

  // ----------------------------------------------------
  // End