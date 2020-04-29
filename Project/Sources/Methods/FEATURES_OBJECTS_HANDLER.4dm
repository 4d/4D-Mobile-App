//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : SERVER_OBJECTS_HANDLER
  // ID[BC4F7ABBBE3E4D58A8E7DA4D98B71B51]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($f)

  // ----------------------------------------------------
  // Initialisations

$f:=panel_Form_definition ("FEATURES")

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($f.loginRequired.catch($f.event))
		
		Case of 
				
				  //______________________________________________________
			: ($f.event.code=On Load:K2:1)
				
				$f.loginRequired.pointer->:=Num:C11(Bool:C1537(Form:C1466.server.authentication.email))
				
				  //______________________________________________________
			: ($f.event.code=On Clicked:K2:4)
				
				Form:C1466.server.authentication.email:=Bool:C1537($f.loginRequired.pointer->)
				ui.saveProject()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$f.event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($f.authenticationButton.catch($f.event))
		
		$f.editAuthenticationMethod()
		
		  //  //==================================================
	: ($f.pushNotification.catch($f.event))
		
		Case of 
				
				  //______________________________________________________
			: ($f.event.code=On Load:K2:1)
				
				$f.pushNotification.pointer->:=Num:C11(Bool:C1537(Form:C1466.server.pushNotification))
				
				  //______________________________________________________
			: ($f.event.code=On Clicked:K2:4)
				
				Form:C1466.server.pushNotification:=Bool:C1537($f.pushNotification.pointer->)
				ui.saveProject()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$f.event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+OBJECT Get name:C1087(Object current:K67:2)+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End