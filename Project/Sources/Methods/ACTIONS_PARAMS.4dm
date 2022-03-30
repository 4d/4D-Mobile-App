//%attributes = {"invisible":true}
var $e; $ƒ : Object

$ƒ:=panel_Load

If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			If (Not:C34(Feature.with("androidActions")))
				
				androidLimitations(True:C214)
				
			End if 
			
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
				: ($e.code=On Mouse Move:K2:35)
					SET CURSOR:C469()
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
			
			$ƒ.doAddParameter($ƒ.add)
			
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
			
			If (Shift down:C543)
				
				$ƒ.showFormatOnDisk()
				
			Else 
				
				$ƒ.doFormatMenu()
				
			End if 
			
			//==============================================
		: ($ƒ.dataSourcePopup.catch($e; On Clicked:K2:4))
			
			$ƒ.doDataSourceMenu()
			
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
			
			//==============================================
		: ($ƒ.predicting.catch())\
			 & ($e.code<0)
			
			var $o : Object
			$o:=$ƒ.predicting.getValue()
			
			Case of 
					
					//_________________________
				: ($e.code=-1)  // Validate
					
					$ƒ.updateParamater($o.choice.value)
					$ƒ.postKeyDown(Tab:K15:37)
					$ƒ.refresh()
					
					//_________________________
				: ($e.code=-2)  // Show
					
					$ƒ.predicting.show()
					
					var $height : Integer
					$height:=$o.ƒ.bestSize()
					
					If (($ƒ.predicting.coordinates.top+$height)>$ƒ.dimensions().height)
						
						$height:=$ƒ.dimensions().height-$ƒ.predicting.coordinates.top
						
					End if 
					
					$ƒ.predicting.setHeight($height)
					
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
		: ($ƒ.revealFormat.catch($e; On Clicked:K2:4))
			
			SHOW ON DISK:C922($ƒ.sourceFolder(Delete string:C232($ƒ.current.format; 1; 1)).platformPath)
			
			//==================================================
		: ($ƒ.revealDatasource.catch($e; On Clicked:K2:4))
			
			SHOW ON DISK:C922($ƒ.sourceFolder(Delete string:C232($ƒ.current.source; 1; 1); True:C214).platformPath)
			
			//==================================================
		: ($e.code=On Data Change:K2:15)\
			 & ($ƒ.linked.belongsTo($e.objectName))  // Linked widgets
			
			PROJECT.save()
			
			//==============================================
	End case 
End if 
