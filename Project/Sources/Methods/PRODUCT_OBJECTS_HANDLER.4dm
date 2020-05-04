//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PRODUCT_OBJECTS_HANDLER
  // ID[E7502D1D082344F79071FA4C79EAAC92]
  // Created 11-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_PICTURE:C286($p)
C_OBJECT:C1216($e;$form;$menu)

If (False:C215)
	C_LONGINT:C283(PRODUCT_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

$e:=FORM Event:C1606

$form:=PRODUCT_Handler (New object:C1471(\
"action";"init"))

$0:=-1

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($e.objectName=$form.productName)
		
		Case of 
				
				  //______________________________________________________
			: ($e.code=On After Edit:K2:43)\
				 | ($e.code=On Data Change:K2:15)
				
				PRODUCT_Handler (New object:C1471(\
					"action";"checkName";\
					"value";Get edited text:C655))
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.objectName+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
		  //: ($e.objectName="icons.help")
		  // Case of
		  //  //______________________________________________________
		  //: ($e.code=On Clicked)
		  // OPEN URL(Get localized string("appIconsHelp");*)
		  //  //______________________________________________________
		  // Else
		  //ASSERT(False;"Form event activated unnecessarily ("+String($e.code)+")")
		  //  //______________________________________________________
		  // End case
		
		  //==================================================
	: ($e.objectName=$form.icon)
		
		Case of 
				
				  //______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)  //#TURN_AROUND_ACI0097903
				
				OBJECT SET HELP TIP:C1181(*;$e.objectName;Get localized string:C991("appIconsTip"))
				
				  //______________________________________________________
			: ($e.code=On Double Clicked:K2:5)
				
				PRODUCT_Handler (New object:C1471(\
					"action";"browseIcon"))
				
				  //______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				$menu:=cs:C1710.menu.new()
				
				$menu.append("CommonMenuItemPaste";"setIcon")
				GET PICTURE FROM PASTEBOARD:C522($p)
				$menu.enable(OK=1)
				
				$menu.line()
				$menu.append("browse";"browseIcon")
				$menu.line()
				$menu.append("showIconsFolder";"openIconFolder")
				
				$menu.popup()
				
				If ($menu.selected)
					
					PRODUCT_Handler (New object:C1471(\
						"action";$menu.choice;\
						"image";$p))
					
				End if 
				
				  //______________________________________________________
			: ($e.code=On Drag Over:K2:13)
				
				GET PICTURE FROM PASTEBOARD:C522($p)
				
				If (OK=1)
					
					$0:=0
					
				Else 
					
					  //#96614 - Allow an application for setting the product icon
					DOCUMENT:=Get file from pasteboard:C976(1)
					
					If (Length:C16(DOCUMENT)>0)\
						 & (Is picture file:C1113(DOCUMENT))
						
						$0:=0
						
					End if 
				End if 
				
				  //______________________________________________________
			: ($e.code=On Drop:K2:12)
				
				GET PICTURE FROM PASTEBOARD:C522($p)
				
				If (OK=1)
					
					PRODUCT_Handler (New object:C1471(\
						"action";"setIcon";\
						"image";$p))
					
				Else 
					
					  //#96614 - Allow an application for setting the product icon
					DOCUMENT:=Get file from pasteboard:C976(1)
					
					If (Length:C16(DOCUMENT)>0)
						
						PRODUCT_Handler (New object:C1471(\
							"action";"getIcon";\
							"path";DOCUMENT))
						
					End if 
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+$e.objectName+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$e.objectName+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End