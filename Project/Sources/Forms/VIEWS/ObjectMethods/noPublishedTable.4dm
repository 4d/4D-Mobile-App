  // ----------------------------------------------------
  // Object method : NO_PUBLISHED_TABLES.3D Button - (4D Mobile App)
  // ID[7A86CE71B87543D2B34CEB786B737641]
  // Created 2-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($bottom;$eventCode;$height;$left;$right;$top)
C_LONGINT:C283($width)
C_TEXT:C284($me)

  // ----------------------------------------------------
  // Initialisations
$eventCode:=Form event code:C388
$me:=OBJECT Get name:C1087(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($eventCode=On Load:K2:1)
		
		OBJECT GET BEST SIZE:C717(*;$me;$width;$height)
		OBJECT GET COORDINATES:C663(*;$me;$left;$top;$right;$bottom)
		OBJECT SET COORDINATES:C1248(*;$me;$left;$top;$left+$width;$top+$height)
		
		  //______________________________________________________
	: ($eventCode=On Mouse Enter:K2:33)
		
		OBJECT SET FONT STYLE:C166(*;$me;Underline:K14:4)
		
		  //______________________________________________________
	: ($eventCode=On Mouse Leave:K2:34)
		
		OBJECT SET FONT STYLE:C166(*;$me;Plain:K14:1)
		
		  //______________________________________________________
	: ($eventCode=On Clicked:K2:4)
		
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"goToPage";New object:C1471(\
			"page";"structure"))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($eventCode)+")")
		
		  //______________________________________________________
End case 