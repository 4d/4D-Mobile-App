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
C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)
C_OBJECT:C1216($Obj_form)

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=_o_SERVER_Handler (New object:C1471(\
		"action";"init"))
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.productionURL)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Verify the web server configuration
				CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"checkingServerConfiguration")
				ui.saveProject()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //  //==================================================
	: ($Txt_me=$Obj_form.email)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				$Ptr_me->:=Num:C11(Bool:C1537(Form:C1466.server.authentication.email))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				Form:C1466.server.authentication.email:=Bool:C1537($Ptr_me->)
				ui.saveProject()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //  //==================================================
	: ($Txt_me=$Obj_form.method)
		
		_o_SERVER_Handler (New object:C1471(\
			"action";"editAuthenticationMethod"))
		
		  //  //==================================================
	: ($Txt_me=$Obj_form.pushNotifications)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				$Ptr_me->:=Num:C11(Bool:C1537(Form:C1466.server.pushNotification))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				Form:C1466.server.pushNotification:=Bool:C1537($Ptr_me->)
				ui.saveProject()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		
		  //==================================================
	: ($Txt_me="webSettings")
		
		OPEN SETTINGS WINDOW:C903("/Database/Web/Config")
		
		  //  //==================================================
		  //: ($Txt_me="01_testURL")
		  // Case of
		  //  //______________________________________________________
		  //: ($Lon_formEvent=On Load)
		  //$Txt_buffer:=Form.server.urls.test+
		  //  // Check for listen port
		  //If (Not(Match regex("(?m-si).*:\\d*$";$Txt_buffer)))
		  //  // Append the current port
		  //WEB GET OPTION(Web Port ID;$Lon_port)
		  //$Lon_error:=Rgx_SubstituteText ("(?m-si)^([^:]*)(:[^$]*)?$";"\\1:"+String($Lon_port)+"";->$Txt_buffer)
		  //Form.server.urls.test:=$Txt_buffer
		  // End if
		  //  //______________________________________________________
		  //: ($Lon_formEvent=On Data Change)
		  //$Txt_buffer:=Get edited text
		  //$Boo_OK:=(Length($Txt_buffer)=0)
		  //If (Not($Boo_OK))
		  //$Boo_OK:=Check_entry (New object("type";"url";"value";$Txt_buffer)).success
		  // End if
		  //project_UI_ALERT (New object("target";"test.alert";"reset";$Boo_OK;"type";"alert";"tips";"Invalid URL"))
		  //  // SERVER_HANDLER (New object("action";"ui"))
		  //  //______________________________________________________
		  // Else
		  //ASSERT(False;"Form event activated unnecessarily ("+String($Lon_formEvent)+")")
		  //  //______________________________________________________
		  // End case
		  //==================================================
		  //: ($Txt_me="testUrl.status")
		  // If (WEB Is server running)
		  // WEB STOP SERVER
		  // End if
		  // WEB START SERVER
		  // If (OK=1)
		  // SERVER_HANDLER (New object("action";"ui"))
		  // End if
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End