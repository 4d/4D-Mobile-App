//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : FIELDS
// Created 30-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// FIELDS pannel management
// ----------------------------------------------------
// Declarations
var $e; $field; $ƒ; $o : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Definition

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Form(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			// This trick remove the horizontal gap
			$ƒ.fieldList.setScrollbars(False:C215; 2)
			
			// Place the tabs according to the localization
			$ƒ.selectors.distributeHorizontally()
			
			// Place the download button
			$ƒ.resources.setTitle(cs:C1710.str.new("downloadMoreResources").localized(Lowercase:C14(Get localized string:C991("formatters"))))
			$ƒ.resources.bestSize(Align right:K42:4)
			
			// Update widget pointers after a reload
			$ƒ.ids.updatePointer()
			$ƒ.names.updatePointer()
			$ƒ.icons.updatePointer()
			$ƒ.labels.updatePointer()
			$ƒ.shortLabels.updatePointer()
			$ƒ.formats.updatePointer()
			$ƒ.titles.updatePointer()
			
			// Initialize the Fields/Relations tab
			$ƒ.setTab()
			
			// Preload the icons
			//$ƒ.loadIcons()
			
			$ƒ.tableNumber:=Num:C11(Form:C1466.$dialog.TABLES.currentTableNumber)
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.updateFieldList()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.fieldList.catch())
			
			Case of 
					
					//_______________________________
				: ($e.code=On Selection Change:K2:29)
					
					editor_ui_LISTBOX($e.objectName)
					
					//_______________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					UI.tips.instantly()
					
					//_______________________________
				: ($e.code=On Mouse Move:K2:35)
					
					$ƒ.setHelpTip($e)
					
					//_______________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					UI.tips.default()
					
					//_______________________________
				: ($e.code=On Getting Focus:K2:7)
					
					editor_ui_LISTBOX($e.name; True:C214)
					
					$ƒ.setHelpTip($e)
					
					//_______________________________
				: ($e.code=On Losing Focus:K2:8)
					
					editor_ui_LISTBOX($e.name; False:C215)
					
					//_______________________________
				: (editor_Locked)
					
					// <NOTHING MORE TO DO>
					
					//_______________________________
				: ($e.code=On Double Clicked:K2:5)
					
					editor_ui_LISTBOX($e.objectName)
					
					If ($e.columnName=$ƒ.labels.name)\
						 | ($e.columnName=$ƒ.shortLabels.name)\
						 | ($e.columnName=$ƒ.titles.name)
						
						EDIT ITEM:C870(Self:C308->; Self:C308->)
						
					End if 
					
					//_______________________________
				: ($e.code=On Clicked:K2:4)
					
					$ƒ.fieldList.updateDefinition()
					
					Case of 
							
							//______________________________________________________
						: ($e.row=Null:C1517)
							
							// NO SELECTION
							//........................................
						: ($e.columnName=$ƒ.icons.name)  // Open the fields icons picker
							
							$ƒ.iconPicker($e)
							
							//______________________________________________________
					End case 
					
					//_______________________________
				: ($e.code=On Data Change:K2:15)
					
					// Get the edited field definition
					$field:=$ƒ.field($e.row)
					
					// Update data model
					//%W-533.3
					$field[Choose:C955($e.columnName="title"; "format"; $e.columnName)]:=Self:C308->{$e.row}
					//%W+533.3
					
					$ƒ.updateForms($field; $e.row)
					
					// PROJECT IS ALWAYS SAVED ON DATA CHANGE
					
					//_______________________________
				: ($e.code=On Before Data Entry:K2:39)
					
					If ($e.columnName=$ƒ.formats.name)
						
						$ƒ.format($e)
						
					End if 
					
					$ƒ.inEdition:=$ƒ.fieldList
					
					//_______________________________
			End case 
			
			//==============================================
		: ($ƒ.selectorFields.catch())\
			 | ($ƒ.selectorRelations.catch())
			
			Case of 
					
					//_______________________________
				: ($e.code=On Clicked:K2:4)
					
					$ƒ.current:=$e.objectName
					$ƒ.selector:=Num:C11($ƒ.current=$ƒ.selectorRelations.name)
					
					// Update
					$ƒ.setTab()
					
					//_______________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					If ($ƒ.current#$e.objectName)
						
						// Highlights
						Choose:C955($e.objectName=$ƒ.selectorFields.name; $ƒ.selectorFields; $ƒ.selectorRelations)\
							.setColors(UI.selectedColor; Background color none:K23:10)
						
					End if 
					
					//_______________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					Choose:C955($e.objectName=$ƒ.selectorFields.name; $ƒ.selectorFields; $ƒ.selectorRelations)\
						.setColors(Foreground color:K23:1; Background color none:K23:10)
					
					//_______________________________
			End case 
			
			//==============================================
		: ($ƒ.resources.catch())
			
			If (FEATURE.with("formatMarketPlace"))
				
				// Show browser
				$ƒ.call("initBrowser"; New object:C1471(\
					"url"; Get localized string:C991("res_formatters")))
				
				//$ƒ.call(New collection("initBrowser"; New object(\
					"url"; Get localized string("res_formatters"))))
				
			Else 
				
				OPEN URL:C673(Get localized string:C991("res_formatters"); *)
				
			End if 
			
			//________________________________________
	End case 
End if 