  // ----------------------------------------------------
  // Object method : NO_PUBLISHED_TABLES.3D Button - (4D Mobile App)
  // ID[7A86CE71B87543D2B34CEB786B737641]
  // Created 2-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left;$Lon_right;$Lon_top)
C_LONGINT:C283($Lon_width)
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
	: ($Lon_formEvent=On Load:K2:1)
		
		OBJECT GET BEST SIZE:C717(*;$Txt_me;$Lon_width;$Lon_height)
		OBJECT GET COORDINATES:C663(*;$Txt_me;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT SET COORDINATES:C1248(*;$Txt_me;$Lon_left;$Lon_top;$Lon_left+$Lon_width;$Lon_top+$Lon_height)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Enter:K2:33)
		
		OBJECT SET FONT STYLE:C166(*;$Txt_me;Underline:K14:4)
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Move:K2:35)
		
		OBJECT SET FONT STYLE:C166(*;$Txt_me;Underline:K14:4)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		OBJECT SET FONT STYLE:C166(*;$Txt_me;Plain:K14:1)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"goToPage";New object:C1471(\
			"page";"structure"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 