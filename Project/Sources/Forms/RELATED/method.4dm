  // ----------------------------------------------------
  // Form method : RELATED - (4D Mobile App)
  // ID[FC51239B819F405287A5D751167C2CE3]
  // Created #12-12-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388

  // ----------------------------------------------------

Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		ui_BEST_SIZE (New object:C1471(\
			"widgets";New collection:C1472("ok";"cancel");\
			"alignment";Align right:K42:4))
		
		OBJECT SET TITLE:C194(*;"title";Replace string:C233(Get localized string:C991("relatedTable");"{entity}";String:C10(Form:C1466.relatedDataClass)))
		
		SET TIMER:C645(-1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 