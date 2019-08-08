//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PRODUCT_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[E7502D1D082344F79071FA4C79EAAC92]
  // Created 11-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_PICTURE:C286($Pic_buffer)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($File_;$Mnu_main;$Txt_choice;$Txt_me)
C_OBJECT:C1216($Obj_form)

If (False:C215)
	C_LONGINT:C283(PRODUCT_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Lon_formEvent:=Form event code:C388
	$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
	$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)
	
	$Obj_form:=PRODUCT_Handler (New object:C1471("action";"init"))
	
	$0:=-1
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Txt_me=$Obj_form.productName)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On After Edit:K2:43) | ($Lon_formEvent=On Data Change:K2:15)
				
				PRODUCT_Handler (New object:C1471("action";"checkName";"value";Get edited text:C655))
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
		  //: ($Txt_me="icons.help")
		  // Case of
		  //  //______________________________________________________
		  //: ($Lon_formEvent=On Clicked)
		  // OPEN URL(Get localized string("appIconsHelp");*)
		  //  //______________________________________________________
		  // Else
		  //ASSERT(False;"Form event activated unnecessarily ("+String($Lon_formEvent)+")")
		  //  //______________________________________________________
		  // End case
		
		  //==================================================
	: ($Txt_me=$Obj_form.icon)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Mouse Enter:K2:33)  //#TURN_AROUND_ACI0097903
				
				OBJECT SET HELP TIP:C1181(*;$Txt_me;Get localized string:C991("appIconsTip"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Double Clicked:K2:5)
				
				PRODUCT_Handler (New object:C1471("action";"browseIcon"))
				
				  //______________________________________________________
			: ($Lon_formEvent=On Clicked:K2:4)
				
				$Mnu_main:=Create menu:C408
				
				  //#96711 - Allow to paste an icon from pasteboard
				APPEND MENU ITEM:C411($Mnu_main;":xliff:CommonMenuItemPaste")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"setIcon")
				
				GET PICTURE FROM PASTEBOARD:C522($Pic_buffer)
				
				If (OK=0)
					
					DISABLE MENU ITEM:C150($Mnu_main;-1)
					
				End if 
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:browse")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"browseIcon")
				
				APPEND MENU ITEM:C411($Mnu_main;"-")
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:showIconsFolder")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"openIconFolder")
				
				$Txt_choice:=Dynamic pop up menu:C1006($Mnu_main)
				RELEASE MENU:C978($Mnu_main)
				
				If (Length:C16($Txt_choice)>0)
					
					PRODUCT_Handler (New object:C1471("action";$Txt_choice;"image";$Pic_buffer))
					
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Drag Over:K2:13)
				
				GET PICTURE FROM PASTEBOARD:C522($Pic_buffer)
				
				If (OK=1)
					
					$0:=0
					
				Else 
					
					  //#96614 - Allow an application for setting the product icon
					DOCUMENT:=Get file from pasteboard:C976(1)
					
					If (Length:C16(DOCUMENT)>0) & (Is picture file:C1113(DOCUMENT))
						
						$0:=0
						
					End if 
				End if 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Drop:K2:12)
				
				GET PICTURE FROM PASTEBOARD:C522($Pic_buffer)
				
				If (OK=1)
					
					PRODUCT_Handler (New object:C1471("action";"setIcon";"image";$Pic_buffer))
					
				Else 
					
					  //#96614 - Allow an application for setting the product icon
					$File_:=Get file from pasteboard:C976(1)
					
					If (Length:C16($File_)>0)
						
						PRODUCT_Handler (New object:C1471("action";"getIcon";"path";$File_))
						
					End if 
				End if 
				
				  //______________________________________________________
				
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$Txt_me+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End