  // ----------------------------------------------------
  // Form method : NO_PUBLISHED_TABLES - (4D Mobile Express)
  // ID[1AECDC85637440138F487FA4FF795352]
  // Created 8-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_TEXT:C284($Txt_buffer)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event code:C388

  // ----------------------------------------------------

Case of 
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		SET TIMER:C645(0)
		
		$Txt_buffer:=\
			"<span style=\"-d4-ref-user:'link'\">"\
			+Get localized string:C991("noPublishedTable")\
			+"</span>"
		
		ST SET TEXT:C1115(*;"noPublishedTable";$Txt_buffer;ST Start text:K78:15;ST End text:K78:16)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 