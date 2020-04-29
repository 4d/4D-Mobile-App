//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : SERVER_Handler
  // ID[75B0A66E1CF34B9282671E12991D64C9]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_VARIANT:C1683($1)

C_LONGINT:C283($lEventCode)
C_TEXT:C284($tAction)
C_OBJECT:C1216($f;$o)

If (False:C215)
	C_VARIANT:C1683(FEATURES_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

$f:=panel_Form_definition ("FEATURES")

  // ----------------------------------------------------
If (Count parameters:C259=0)  // Form method
	
	$lEventCode:=panel_Form_common (On Load:K2:1)
	
	Case of 
			
			  //______________________________________________________
		: ($lEventCode=On Load:K2:1)
			
			$f.loginRequired.bestSize()
			$f.pushNotification.bestSize()
			$f.authenticationGroup.distributeHorizontally()
			$f.checkAuthenticationMethod()
			
			  //______________________________________________________
	End case 
	
Else 
	
	If (Value type:C1509($1)=Is text:K8:3)
		
		$tAction:=$1
		
	Else 
		
		$tAction:=$1.action
		
	End if 
	
	Case of 
			
			  //=========================================================
		: (Length:C16($tAction)=0)
			
			ASSERT:C1129(False:C215;"Missing parameter \"action\"")
			
			  //=========================================================
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$tAction+"\"")
			
			  //=========================================================
	End case 
End if 

  // ----------------------------------------------------
  // Return

  // ----------------------------------------------------
  // End