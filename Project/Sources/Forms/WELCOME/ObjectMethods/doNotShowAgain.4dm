  // ----------------------------------------------------
  // Object method : WELCOME.doNotShowAgain - (4D Mobile App)
  // ID[C75C8BBECA364D18A37DFE4903C37FDF]
  // Created 5-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me;$Ptr_me->)
C_TEXT:C284($Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		$Ptr_me->:=Num:C11(Bool:C1537(editor_Preferences .doNotShowGreetingMessage))
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		editor_Preferences (New object:C1471(\
			"key";"doNotShowGreetingMessage";\
			"value";$Ptr_me->=1))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 