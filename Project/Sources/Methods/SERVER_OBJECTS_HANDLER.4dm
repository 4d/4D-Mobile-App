//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : SERVER_OBJECTS_HANDLER
  // ID[BC4F7ABBBE3E4D58A8E7DA4D98B71B51]
  // Created 17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // SERVER pannel widgets management
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($f)

  // ----------------------------------------------------
  // Initialisations

$f:=panel_Form_definition ("SERVER")

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($f.productionURL.catch($f.event))
		
		Case of 
				
				  //______________________________________________________
			: ($f.event.code=On Data Change:K2:15)
				
				ui.saveProject()
				
				  // Verify the web server configuration
				CALL FORM:C1391($f.window;"editor_CALLBACK";"checkingServerConfiguration")
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$f.event.description+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($f.webSettings.catch($f.event))
		
		$f.settings()
		
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