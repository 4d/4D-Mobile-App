//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Definition

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form_common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			androidLimitations(True:C214)
			
			// This trick remove the horizontal gap
			$ƒ.parameters.setScrollbars(0; 2)
			
			// Set the initial display
			If ($ƒ.action#Null:C1517)
				
				$ƒ.add.enable()
				
				If (_and(Formula:C1597(Form:C1466.actions.parameters#Null:C1517); Formula:C1597(Form:C1466.actions.parameters.length>0)))
					
					// Select last used action (or the first one)
					If ($ƒ.$current#Null:C1517)
						
						var $indx : Integer
						$indx:=Form:C1466.actions.parameters.indexOf($ƒ.$current)
						$ƒ.parameters.select($indx+1)
						
					Else 
						
						$ƒ.parameters.select(1)
						
					End if 
					
					//$ƒ.callMeBack("selectParameters")
					//$ƒ.updateParameters()
					
					//$ƒ.actions.focus()
					
				End if 
				
			Else 
				
				$ƒ.noSelection.show()
				$ƒ.noTable.hide()
				$ƒ.withSelection.hide()
				$ƒ.noParameters.hide()
				
			End if 
			
			// Add the events that we cannot select in the form properties 😇
			$ƒ.appendEvents(New collection:C1472(On Alternative Click:K2:36))
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.parameters.catch())
			
			Case of 
					
					//_____________________________________
				: ($e.code=On Getting Focus:K2:7)
					
					$ƒ.parameters.setColors(Foreground color:K23:1)
					$ƒ.parametersBorder.setColors(EDITOR.selectedColor)
					
					//_____________________________________
				: ($e.code=On Losing Focus:K2:8)
					
					$ƒ.parameters.setColors(Foreground color:K23:1)
					$ƒ.parametersBorder.setColors(EDITOR.backgroundUnselectedColor)
					
					//_____________________________________
				: ($e.code=On Selection Change:K2:29)
					
					$ƒ.$current:=$ƒ.current
					
					// Update UI
					$ƒ.refresh()
					
					//_____________________________________
				: (editor_Locked)\
					 | (Num:C11($e.row)=0)
					
					// <NOTHING MORE TO DO>
					
					//_____________________________________
				: ($e.code=On Begin Drag Over:K2:44)
					
					$ƒ.doBeginDrag()
					
					//_____________________________________
				: ($e.code=On Drop:K2:12)
					
					$ƒ.doOnDrop()
					
					//_____________________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					$ƒ.dropCursor.hide()
					
					//_____________________________________
			End case 
			
			//==============================================
		: ($ƒ.add.catch($e; On Clicked:K2:4))
			
			$ƒ.doNewParameter()
			
			//==============================================
		: ($ƒ.add.catch($e; On Alternative Click:K2:36))
			
			$ƒ.doAddParameterMenu()
			
			//==============================================
		: ($ƒ.remove.catch($e; On Clicked:K2:4))
			
			$ƒ.doRemoveParameter()
			
			//==============================================
		: ($ƒ.mandatory.catch($e; On Clicked:K2:4))
			
			$ƒ.doMandatory()
			
			//==============================================
		: ($ƒ.formatPopup.catch($e; On Clicked:K2:4))
			
			$ƒ.doFormatMenu()
			
			//==============================================
		: ($ƒ.min.catch($e; On Data Change:K2:15))
			
			$ƒ.doRule("min")
			
			//==============================================
		: ($ƒ.max.catch($e; On Data Change:K2:15))
			
			$ƒ.doRule("max")
			
			//==============================================
		: ($ƒ.defaultValue.catch($e; On After Edit:K2:43))
			
			If (Length:C16(Get edited text:C655)=0)
				
				OB REMOVE:C1226($ƒ.current; "default")
				
			End if 
			
			//==============================================
		: ($ƒ.defaultValue.catch($e; On Data Change:K2:15))
			
			$ƒ.doDefaultValue()
			
			//==================================================
		: ($e.code=On Data Change:K2:15)\
			 & ($ƒ.linked.belongsTo($e.objectName))  // Linked widgets
			
			PROJECT.save()
			
			//==============================================
	End case 
End if 
