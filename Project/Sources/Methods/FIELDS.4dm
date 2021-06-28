//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : FIELDS
// Created 30-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// FIELDS pannel management
// ----------------------------------------------------
// Declarations
var $e; $field; $ƒ : Object

// ----------------------------------------------------
// Initialisations
$ƒ:=panel_Load

// ----------------------------------------------------
If (FORM Event:C1606.objectName=Null:C1517)  // <== FORM METHOD
	
	$e:=panel_Common(On Load:K2:1; On Timer:K2:25)
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Load:K2:1)
			
			$ƒ.onLoad()
			
			//______________________________________________________
		: ($e.code=On Timer:K2:25)
			
			$ƒ.update()
			
			$ƒ.tableNumber:=$ƒ.tableLink.call()
			$ƒ.updateFieldList()
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	$e:=$ƒ.event
	
	Case of 
			
			//==============================================
		: ($ƒ.fieldList.catch())
			
			$ƒ.tableNumber:=$ƒ.tableLink.call()
			$ƒ.fieldList.updateDefinition()
			
			Case of 
					
					//_______________________________
				: ($e.code=On Selection Change:K2:29)
					
					editor_ui_LISTBOX($e.objectName)
					
					//_______________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					_o_UI.tips.instantly()
					
					//_______________________________
				: ($e.code=On Mouse Move:K2:35)
					
					$ƒ.setHelpTip($e)
					
					//_______________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					_o_UI.tips.default()
					
					//_______________________________
				: ($e.code=On Getting Focus:K2:7)
					
					editor_ui_LISTBOX($e.name; True:C214)
					
					$ƒ.setHelpTip($e)
					
					//_______________________________
				: ($e.code=On Losing Focus:K2:8)
					
					editor_ui_LISTBOX($e.name; False:C215)
					
					//_______________________________
				: (PROJECT.isLocked())
					
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
					
					Case of 
							
							//........................................
						: ($e.row=Null:C1517)
							
							// NO SELECTION
							
							//........................................
						: ($e.columnName=$ƒ.icons.name)
							
							$ƒ.doShowIconPicker($e)
							
							//........................................
						: ($e.columnName=$ƒ.shortLabels.name)\
							 | ($e.columnName=$ƒ.labels.name)
							
							If (Is editing text:C1744)
								
								If (Contextual click:C713)  // Propose the tags to be inserted
									
									If ($ƒ.popup=Null:C1517)  // Stop re-antrance
										
										$ƒ.popup:=True:C214
										$ƒ.tagMenu($e; New collection:C1472("length"))
										
									Else 
										
										OB REMOVE:C1226($ƒ; "popup")
										
									End if 
								End if 
							End if 
							
							//........................................
						: ($e.columnName=$ƒ.titles.name)
							
							If (Is editing text:C1744)
								If (Contextual click:C713)  // Propose the tags to be inserted
									
									If ($ƒ.popup=Null:C1517)  // Stop re-antrance
										
										$ƒ.popup:=True:C214
										$ƒ.tagMenu($e; New collection:C1472("name"))
										
									Else 
										
										OB REMOVE:C1226($ƒ; "popup")
										
									End if 
								End if 
							End if 
							
							//........................................
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
					
					//_______________________________
				: ($e.code=On Before Data Entry:K2:39)
					
					If ($e.columnName=$ƒ.formats.name)
						
						If (Shift down:C543)
							
							$ƒ.formatShowOnDisk($e)
							
						Else 
							
							$ƒ.formatMenu($e)
							
						End if 
					End if 
					
					$ƒ.inEdition:=$ƒ.fieldList
					
					//_______________________________
				: ($e.code=On Before Keystroke:K2:6)
					
					Case of 
							
							//........................................
						: ($e.row=Null:C1517)
							
							// NO SELECTION
							
							//........................................
						: ($e.columnName=$ƒ.shortLabels.name)\
							 | ($e.columnName=$ƒ.labels.name)
							
							If (Keystroke:C390="%")
								
								FILTER KEYSTROKE:C389("")
								
								$ƒ.tagMenu($e; New collection:C1472("length"))  // Propose the tags to be inserted
								
							End if 
							
							//........................................
						: ($e.columnName=$ƒ.titles.name)
							
							If (Keystroke:C390="%")
								
								FILTER KEYSTROKE:C389("")
								
								$ƒ.tagMenu($e; New collection:C1472("name"))  // Propose the tags to be inserted
								
							End if 
							
							//........................................
					End case 
					
					//_______________________________
			End case 
			
			//==============================================
		: ($ƒ.selectorFields.catch())\
			 | ($ƒ.selectorRelations.catch())
			
			Case of 
					
					//_______________________________
				: ($e.code=On Clicked:K2:4)
					
					// Update
					$ƒ.tabSelector.data:=Num:C11($e.objectName=$ƒ.selectorRelations.name)
					$ƒ.setTab()
					
					//_______________________________
				: ($e.code=On Mouse Enter:K2:33)
					
					If ($ƒ.current#$e.objectName)
						
						// Highlights
						Choose:C955($e.objectName=$ƒ.selectorFields.name; $ƒ.selectorFields; $ƒ.selectorRelations)\
							.setColors(EDITOR.selectedColor; Background color none:K23:10)
						
					End if 
					
					//_______________________________
				: ($e.code=On Mouse Leave:K2:34)
					
					Choose:C955($e.objectName=$ƒ.selectorFields.name; $ƒ.selectorFields; $ƒ.selectorRelations)\
						.setColors(Foreground color:K23:1; Background color none:K23:10)
					
					//_______________________________
			End case 
			
			//==============================================
		: ($ƒ.resources.catch($e; On Clicked:K2:4))
			
			$ƒ.doGetResources()
			
			//________________________________________
	End case 
End if 