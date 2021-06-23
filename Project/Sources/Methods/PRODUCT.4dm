//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : PRODUCT
// Created 16-9-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// PRODUCT pannel management
// ----------------------------------------------------
// Declarations
var $e; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form_common(On Load:K2:1; On Timer:K2:25; On Bound Variable Change:K2:52)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			If (FEATURE.with("targetPannel"))
				
				$ƒ.os.hide()
				$ƒ.preview.hide()
				$ƒ.dominantColor.moveVertically(-125)
				
			Else 
				
				If (Bool:C1537(PROJECT.$android))
					
					If (Is Windows:C1573)
						
						If (Form:C1466.$ios)
							
							$ƒ.android.setPicture("#images/os/Android-32.png")\
								.setBackgroundPicture()\
								.setNumStates(1)
							
							$ƒ.preview.show()
							
							$ƒ.ios.disable()
							
							$ƒ.ios.setPicture("#images/os/iOS-32.png")\
								.setBackgroundPicture()\
								.setNumStates(1)
							
						Else 
							
							$ƒ.os.hide()
							$ƒ.preview.hide()
							
						End if 
					End if 
					
				Else 
					
					$ƒ.target.hide()
					$ƒ.ios.hide()
					$ƒ.android.hide()
					
					$ƒ.preview.hide()
					
				End if 
			End if 
			
			If (FEATURE.with("dominantColor"))
				
				If (PROJECT.ui.dominantColor#Null:C1517)
					
					$ƒ.mainColor:=cs:C1710.color.new(PROJECT.ui.dominantColor).main
					
				End if 
				
			Else 
				
				$ƒ.dominantColor.hide()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.checkName(Form:C1466.product.name)
			$ƒ.displayIcon()
			
			If (FEATURE.with("dominantColor"))
				
				$ƒ.color.setColors($ƒ.mainColor; $ƒ.mainColor)
				
				If ($ƒ.iconColor=Null:C1517)
					
					$ƒ.iconColor:=cs:C1710.color.new(cs:C1710.bmp.new(OBJECT Get value:C1743("icon")).getDominantColor()).main
					
				End if 
			End if 
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			PROJECT.setTarget()
			
			// Update UI
			$ƒ.displayTarget()
			$ƒ.refresh()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.colorButton.catch($e; On Clicked:K2:4))
			
			var $menu : cs:C1710.menu
			
			$menu:=cs:C1710.menu.new()\
				.append("useTheSystemColorSelector"; "picker")\
				.append("useTheMainColorOfTheIcon"; "fromIcon").enable(cs:C1710.color.new($ƒ.mainColor).main#Num:C11($ƒ.iconColor))\
				.popup($ƒ.colorBorder)
			
			If ($menu.selected)
				
				var $color : cs:C1710.color
				
				Case of 
						
						//________________________
					: ($menu.choice="picker")
						
						$color:=cs:C1710.color.new(Select RGB color:C956($ƒ.mainColor))
						
						//________________________
					: ($menu.choice="fromIcon")
						
						$color:=cs:C1710.color.new(cs:C1710.bmp.new(OBJECT Get value:C1743("icon")).getDominantColor())
						$ƒ.iconColor:=$color.main
						
/*//________________________
// not validated by PO because new feature could add a more consequente panel
// with other ways to enter css color, maybe feature flag for dev, deactivate it
: ($menu.choice="_o_cssColor")
						
var $requested : Text
$requested:=Request(Get localized string("enterAWebColor"))
If (Length($requested)>0)
$color:=cs.color.new($requested)
If ($color.isValid())
$ƒ.iconColor:=$color.main
Else
ALERT(Get localized string("invalidWebColor"))
End if
End if
*/
						
						//________________________
				End case 
				
				If ($color#Null:C1517)
					If ($color.isValid())
						$ƒ.mainColor:=$color.main
						PROJECT.ui.dominantColor:=$color.css.components
						PROJECT.save()
						
						$ƒ.color.setColors($ƒ.mainColor; $ƒ.mainColor)
					End if 
				End if 
				
			End if 
			
			//==============================================
		: ($ƒ.productName.catch())
			
			Case of 
					
					//______________________________________________________
				: ($e.code=On After Edit:K2:43)
					
					$ƒ.checkName(Get edited text:C655)
					
					//______________________________________________________
				: ($e.code=On Data Change:K2:15)
					
					$ƒ.checkName(Form:C1466.product.name)
					
					// Update bundleIdentifier & navigationTitle
					Form:C1466.product.bundleIdentifier:=Form:C1466.organization.id+"."+formatString("bundleApp"; Form:C1466.product.name)
					Form:C1466.main.navigationTitle:=Form:C1466.product.name
					
					//______________________________________________________
			End case 
			
			//==============================================
		: ($ƒ.icon.catch())
			
			// ❗️MANAGED INTO OBJECT METHOD BECAUSE OF THE DRAG AND DROP
			
			//==============================================
		: ($ƒ.iconAction.catch($e; On Clicked:K2:4))\
			 & (FEATURE.with("iconActionMenu"))
			
			$ƒ.iconMenu()
			
			//==============================================
		: ($ƒ.ios.catch())\
			 | ($ƒ.android.catch())
			
			Case of 
					
					//______________________________________________________
				: (Is Windows:C1573)
					
					// <NOTHING MORE TO DO>
					
					//______________________________________________________
				: ($e.code=On Clicked:K2:4)
					
					If (Is macOS:C1572)\
						 & ($e.objectName=$ƒ.android.name)\
						 & Not:C34(Form:C1466.$ios)\
						 & Not:C34(Form:C1466.$android)
						
						// Force iOS
						PROJECT.setTarget(True:C214; "ios")
						
					Else 
						
						PROJECT.setTarget(OBJECT Get value:C1743($e.objectName); $e.objectName)
						
					End if 
					
					// Update UI
					$ƒ.displayTarget()
					$ƒ.displayIcon()
					EDITOR.updateRibbon()
					
					//______________________________________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					// Highlights
					OBJECT SET RGB COLORS:C628(*; $e.objectName; EDITOR.selectedColor)
					
					//______________________________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					// Restore
					OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1)
					
					//______________________________________________________
			End case 
			
			//________________________________________
	End case 
End if 