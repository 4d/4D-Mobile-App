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
			
			$ƒ.preview.show(Num:C11(Application version:C493)<1920)
			
			If (Is Windows:C1573)
				
				$ƒ.android.setPicture("#images/os/Android-32.png")\
					.setBackgroundPicture()\
					.setNumStates(1)
				
				If (Form:C1466.$ios)
					
					$ƒ.ios.setPicture("#images/os/iOS-32.png")
					
				Else 
					
					$ƒ.ios.setPicture("#images/os/iOS-24.png")
					
				End if 
				
				$ƒ.ios.disable()\
					.setBackgroundPicture()\
					.setNumStates(1)
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			//
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			PROJECT.setTarget()
			
			// Update UI
			$ƒ.displayTarget()
			
			SET TIMER:C645(-1)
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
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