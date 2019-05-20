  // ----------------------------------------------------
  // Object method : PRODUCT.icon.action - (4D Mobile Express)
  // ID[FC490923A2D04B2CA229058157C7460D]
  // Created #24-5-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Mnu_main;$Txt_choice;$Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		$Mnu_main:=Create menu:C408
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:browse")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"browse")
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:showIconsFolder")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"openFolder")
		
		$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
		RELEASE MENU:C978($Mnu_main)
		
		Case of 
				  //………………………………………………………………………………………
			: (Length:C16($Txt_choice)=0)
				
				  // nothing selected
				
				  //………………………………………………………………………………………
			: ($Txt_choice="browse")
				
				  //appiconSet (New object("do";"browse"))
				
				  //………………………………………………………………………………………
			: ($Txt_choice="openFolder")
				
				  //appiconSet (New object("do";"openFolder"))
				
				  //………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215;"Unknown menu action ("+$Txt_choice+")")
				
				  //………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 