// ----------------------------------------------------
// Object method : SERVER.prodURL.alert - (4D Mobile App)
// ID[8EB2EE27AC7E4317B1346F9C7C899CC5]
// Created 29-5-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_me)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		UI.tips.enable()
		UI.tips.instantly()
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		UI.tips.defaultDelay()
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		//______________________________________________________
End case 