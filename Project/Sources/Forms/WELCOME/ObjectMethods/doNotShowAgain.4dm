// ----------------------------------------------------
// Object method : WELCOME.doNotShowAgain - (4D Mobile App)
// ID[C75C8BBECA364D18A37DFE4903C37FDF]
// Created 5-2-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (True:C214)
		
		// REMOVE THE SECOND PAGE OF HE FORM WHEN FEATURE WILL BE DELIVERED
		
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		$Ptr_me->:=Num:C11(Bool:C1537(cs:C1710.preferences.new().user("4D Mobile App.preferences").get("doNotShowGreetingMessage")))
		
		//______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		cs:C1710.preferences.new().user("4D Mobile App.preferences").set("doNotShowGreetingMessage"; $Ptr_me->=1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 