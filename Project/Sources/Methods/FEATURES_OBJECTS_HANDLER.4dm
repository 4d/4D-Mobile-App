//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : FEATURES_OBJECTS_HANDLER
  // ID[18D1402F352E45689C460CD90E64A32D]
  // Created 29-4-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // FEATURES pannel widgets management
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
				
				Self:C308->:=Num:C11(Bool:C1537(Form:C1466.server.authentication.email))
				
				  //______________________________________________________
			: ($f.event.code=On Clicked:K2:4)
				
				Form:C1466.server.authentication.email:=Bool:C1537(Self:C308->)
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
				
				Self:C308->:=Num:C11(Bool:C1537(Form:C1466.server.pushNotification))
				
				  //______________________________________________________
			: ($f.event.code=On Clicked:K2:4)
				
				Form:C1466.server.pushNotification:=Bool:C1537(Self:C308->)
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