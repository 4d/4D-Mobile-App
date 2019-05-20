  // ----------------------------------------------------
  // Form method : TITLE - (4D Mobile App)
  // ID[92DED2A5CB2248A3AA5B14A594D33CFF]
  // Created #31-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_;$Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left;$Lon_right)
C_LONGINT:C283($Lon_top;$Lon_width)
C_TEXT:C284($Txt_page)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388

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
		
		$Txt_page:=(OBJECT Get pointer:C1124(Object subform container:K67:4))->
		
		OBJECT SET FORMAT:C236(*;"icon";"#images/toolbar/"+$Txt_page+".png")
		OBJECT SET TITLE:C194(*;"title";Get localized string:C991("page_"+$Txt_page))
		OBJECT SET TITLE:C194(*;"comment";Get localized string:C991("comment_"+$Txt_page))
		
		OBJECT GET BEST SIZE:C717(*;"title";$Lon_width;$Lon_height)
		
		OBJECT GET COORDINATES:C663(*;"title";$Lon_left;$Lon_top;$Lon_;$Lon_bottom)
		$Lon_right:=$Lon_left+$Lon_width
		OBJECT SET COORDINATES:C1248(*;"title";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		$Lon_left:=$Lon_right+20
		OBJECT GET COORDINATES:C663(*;"comment";$Lon_;$Lon_top;$Lon_right;$Lon_bottom)
		OBJECT SET COORDINATES:C1248(*;"comment";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 