  // ----------------------------------------------------
  // Object method : LOCALIZATION.languages - (4D Mobile App)
  // ID[C3077E92EBF34389A816518E40AEE8B1]
  // Created #17-10-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($Lon_formEvent)
C_TEXT:C284($Mnu_popup;$t;$Txt_me)

  // ----------------------------------------------------
  // Initialisations
$Lon_formEvent:=Form event:C388
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Structure file:C489#Structure file:C489(*))
		
		  // <NOTHING MORE TO DO>
		
		  //______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		  // Get isntalled languages
		Form:C1466.languages:=Folder:C1567("/RESOURCES").folders().query("extension = .lproj").extract("name").sort()
		
		  // Get the language set automatically by 4D on startup according to the Resources folder and the system environment
		Form:C1466.database:=Get database localization:C1009(Default localization:K5:21)
		
		Form:C1466.current:=Form:C1466.database
		OBJECT SET TITLE:C194(*;$Txt_me;Form:C1466.current)
		
		  //______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		  // Display installed languages choice menu
		$Mnu_popup:=Create menu:C408
		
		For each ($t;Form:C1466.languages)
			
			APPEND MENU ITEM:C411($Mnu_popup;$t)
			SET MENU ITEM PARAMETER:C1004($Mnu_popup;-1;$t)
			
			If ($t=Form:C1466.current)
				
				SET MENU ITEM MARK:C208($Mnu_popup;-1;Char:C90(19))
				
			End if 
		End for each 
		
		$t:=Dynamic pop up menu:C1006($Mnu_popup)
		RELEASE MENU:C978($Mnu_popup)
		
		If (Length:C16($t)#0)
			
			If ($t#Form:C1466.current)
				
				  // Change the current language
				Form:C1466.current:=$t
				SET DATABASE LOCALIZATION:C1104(Form:C1466.current;*)
				OBJECT SET TITLE:C194(*;$Txt_me;Form:C1466.current)
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		  // Restore the initial languages
		SET DATABASE LOCALIZATION:C1104(Form:C1466.database;*)
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
		
		  //______________________________________________________
End case 