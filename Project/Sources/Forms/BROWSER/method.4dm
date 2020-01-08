  // ----------------------------------------------------
  // Form method : BROWSER
  // ID[289F30E589094B4086AED5E346A66A4D]
  // Created 8-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		SET TIMER:C645(-1)
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		SET TIMER:C645(0)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Bound Variable Change:K2:52)
		
		WA OPEN URL:C1020(*;"webArea";Form:C1466.url)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 