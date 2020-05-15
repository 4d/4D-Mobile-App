//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FEATURES
  // ID[CA478BCE7E114BD7B13F6A623C605879]
  // Created 29-4-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // FEATURES pannel management
  // ----------------------------------------------------
  // Declarations
  // var $1
var $f;$e : Object

  // ----------------------------------------------------
  // Initialisations
$f:=panel_Definition 

  // ----------------------------------------------------
If ($e.objectName=Null:C1517)  // <== Form method
	
	$e:=panel_Form (On Load:K2:1;On Timer:K2:25)
	
	Case of 
			
			  //______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$f.loginRequired.bestSize()
			$f.pushNotification.bestSize()
			$f.authenticationGroup.distributeHorizontally()
			
			  //______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$f.checkAuthenticationMethod()
			
			  //______________________________________________________
	End case 
	
Else   // <== Widgets method
	
	$e:=$f.event
	
	Case of 
			
			  //==================================================
		: ($f.loginRequired.catch($e))
			
			Case of 
					
					  //_____________________________________
				: ($e.code=On Load:K2:1)
					
					Self:C308->:=Num:C11(Bool:C1537(Form:C1466.server.authentication.email))
					
					  //_____________________________________
				: ($e.code=On Clicked:K2:4)
					
					Form:C1466.server.authentication.email:=Bool:C1537(Self:C308->)
					ui.saveProject()
					
					  //_____________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
					
					  //_____________________________________
			End case 
			
			  //==================================================
		: ($f.authenticationButton.catch($e))
			
			$f.editAuthenticationMethod()
			
			  //  //==================================================
		: ($f.pushNotification.catch($e))
			
			Case of 
					
					  //_____________________________________
				: ($e.code=On Load:K2:1)
					
					Self:C308->:=Num:C11(Bool:C1537(Form:C1466.server.pushNotification))
					
					  //_____________________________________
				: ($e.code=On Clicked:K2:4)
					
					Form:C1466.server.pushNotification:=Bool:C1537(Self:C308->)
					ui.saveProject()
					
					  //_____________________________________
				Else 
					
					ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.description+")")
					
					  //_____________________________________
			End case 
			
			  //==================================================
	End case 
End if 