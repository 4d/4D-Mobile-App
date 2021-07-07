//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Load

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			androidLimitations(True:C214)
			
			$ƒ.onLoad()
			
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
				: (PROJECT.isLocked())\
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
			
			$ƒ.doAddParameter()
			
			//==============================================
		: ($ƒ.add.catch($e; On Alternative Click:K2:36))
			
			$ƒ.doAddParameterMenu($ƒ.add)
			
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
		: ($ƒ.sortOrderPopup.catch($e; On Clicked:K2:4))
			
			$ƒ.doSortOrderMenu()
			
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
		: ($ƒ.format.catch())
			
			Case of 
					
					//_______________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					EDITOR.tips.instantly()
					
					//_______________________________
				: ($e.code=On Mouse Move:K2:35)
					
					$ƒ.setHelpTip()
					
					//_______________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					EDITOR.tips.restore()
					
					//________________________________________
			End case 
			
			//==================================================
		: (Not:C34(FEATURE.with("predictiveEntryInActionParam")))
			
			If ($e.code=On Data Change:K2:15)\
				 & ($ƒ.linked.belongsTo($e.objectName))  // Linked widgets
				
				PROJECT.save()
				
			End if 
			
			//==============================================
		: ($ƒ.predicting.catch())\
			 & ($e.code<0)
			
			Case of 
					
					//_________________________
				: ($e.code=-1)  // Validate
					
					$ƒ._updateParamater($ƒ.predicting.getValue().choice.value)
					$ƒ.postKeyDown(Tab:K15:37)
					$ƒ.refresh()
					
					//_________________________
				: ($e.code=-2)  // Show
					
					$ƒ.predicting.show()
					
					//_________________________
				: ($e.code=-3)  // Hide
					
					$ƒ.predicting.hide()
					
					//_________________________
			End case 
			
			//==================================================
		: ($ƒ.paramName.catch())
			
			$ƒ.doName($e)
			
			//==================================================
		: ($ƒ.namePopup.catch($e; On Clicked:K2:4))
			
			$ƒ.doAddParameterMenu($ƒ.namePopup; True:C214)
			
			//==================================================
		: ($e.code=On Data Change:K2:15)\
			 & ($ƒ.linked.belongsTo($e.objectName))  // Linked widgets
			
			PROJECT.save()
			
			//==============================================
	End case 
End if 
