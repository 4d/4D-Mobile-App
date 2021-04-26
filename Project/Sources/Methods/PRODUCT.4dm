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
	
	$e:=panel_Form(On Load:K2:1; On Timer:K2:25; On Bound Variable Change:K2:52)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			If (FEATURE.with("androidBeta"))\
				 | (Bool:C1537(PROJECT.$android))  // 🚧
				
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
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.checkName(Form:C1466.product.name)
			
			If (FEATURE.with("android"))
				
				$ƒ.displayIcon()
				
			Else 
				
				// Obsolete
				$ƒ.loadIcon()
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			PROJECT.setTarget()
			
			// Update UI
			$ƒ.displayTarget()
			$ƒ.displayIcon()
			
			SET TIMER:C645(-1)
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
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
						
						PROJECT.setTarget(True:C214; "ios")
						
					Else 
						
						PROJECT.setTarget(OBJECT Get value:C1743($e.objectName); $e.objectName)
						
					End if 
					
					// Update UI
					$ƒ.displayTarget()
					$ƒ.displayIcon()
					$ƒ.call("updateRibbon")
					
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