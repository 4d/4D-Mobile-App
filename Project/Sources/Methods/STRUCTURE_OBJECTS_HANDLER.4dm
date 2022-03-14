//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : STRUCTURE_OBJECTS_HANDLER
// ID[EA07A8F4BE0F4D3CB64A774D158FC5F1]
// Created 25-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $fieldID; $t : Text
var $b : Boolean
var $bottom; $column; $count; $height; $i; $indx; $l; $left; $Lon_button; $Lon_targetBottom : Integer
var $Lon_targetTop; $Lon_unpublished; $Lon_vOffset; $right; $row; $top; $width : Integer
var $Ptr_; $Ptr_me; $Ptr_published : Pointer
var $context; $e; $form; $linkDataModel; $menu; $o; $relatedCatalog; $tableDataModel : Object
var $c : Collection
var $field : cs:C1710.field

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

$Ptr_me:=OBJECT Get pointer:C1124(Object current:K67:2)

$form:=STRUCTURE_Handler(New object:C1471(\
"action"; "init"))

var $class : cs:C1710.STRUCTURE
$class:=cs:C1710.STRUCTURE.new($form)

$context:=$form.form

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($e.objectName=$form.allow)
		
		PROJECT.save()
		
		//==================================================
	: ($e.objectName=$form.allowHelp)
		
		OPEN URL:C673(Get localized string:C991("doc_incremental"); *)
		
		//==================================================
	: ($e.objectName=$form.tableList)
		
		LISTBOX GET CELL POSITION:C971(*; $e.objectName; $column; $row)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)
				
				editor_ui_LISTBOX($e.objectName)
				
				If ($row=0)
					
					OB REMOVE:C1226($context; "currentTable")
					
				Else 
					
					// Keep the current selected table
					$t:=(OBJECT Get pointer:C1124(Object named:K67:5; $form.tables))->{$row}
					$context.currentTable:=PROJECT.getCatalog().query("name = :1"; $t).pop()
					
				End if 
				
				// Update field list
				$class.fieldList()
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				If (Right click:C712)
					
					If ($row=0)
						
						OB REMOVE:C1226($context; "currentTable")
						
					Else 
						
						LISTBOX SELECT ROW:C912(*; $e.objectName; $row; lk replace selection:K53:1)
						
						$t:=(OBJECT Get pointer:C1124(Object named:K67:5; $form.tables))->{$row}
						$o:=PROJECT.getCatalog().query("name = :1"; $t).pop()
						
						If (Not:C34(ob_equal($o; $context.currentTable)))
							
							// Update the current selected table
							$context.currentTable:=$o
							
							// Update field list
							$class.fieldList()
							
						End if 
						
						$Ptr_published:=OBJECT Get pointer:C1124(Object named:K67:5; $form.published)
						$Lon_unpublished:=Count in array:C907($Ptr_published->; 0)
						
						$menu:=cs:C1710.menu.new()
						
						If ($Lon_unpublished>0)
							
							$menu.append("publishAll"; "publishAll")
							
						End if 
						
						If ($Lon_unpublished#Size of array:C274($Ptr_published->))
							
							$menu.append("unpublishAll"; "unpublishAll")
							
						End if 
						
						$menu.popup()
						
						If ($menu.selected)
							
							Case of 
									
									//………………………………………………………………………………………
								: ($menu.choice="publishAll")\
									 | ($menu.choice="unpublishAll")
									
									$b:=($menu.choice="publishAll")
									
									For ($i; 1; Size of array:C274($Ptr_published->); 1)
										
										$Ptr_published->{$i}:=Num:C11($b)
										
									End for 
									
									$class.updateProject()
									
									//………………………………………………………………………………………
								Else 
									
									ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
									
									//………………………………………………………………………………………
							End case 
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				EDITOR.tips.instantly(100)
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$context.setHelpTip($e.objectName; $form)
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				EDITOR.tips.restore()
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				$context.focus:=$form.tables
				
				If (LISTBOX Get number of rows:C915(*; $e.objectName)>0)
					
					LISTBOX GET CELL POSITION:C971(*; $e.objectName; $l; $row)
					
					If ($row=0)
						
						LISTBOX SELECT ROW:C912(*; $e.objectName; 1; lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1; EDITOR.highlightColor; EDITOR.highlightColor)
				
				$class.fieldList()
				
				ui_MOVE($form.search; $e.objectName; Align right:K42:4; 30)
				ui_MOVE($form.action; $e.objectName; Align right:K42:4; 0)
				
				OBJECT SET VISIBLE:C603(*; $form.tables+".filter"; False:C215)
				OBJECT SET VISIBLE:C603(*; $form.search; True:C214)
				OBJECT SET VISIBLE:C603(*; $form.action; True:C214)
				//]
				
				var $o : Object
				$o:=OBJECT Get value:C1743($form.search)
				
				If ($o=Null:C1517)
					
					$o:=New object:C1471
					
				End if 
				
				If ($context.tableFilter#Null:C1517)
					
					$o.value:=String:C10($context.tableFilter)
					
				Else 
					
					$o.value:=""
					
				End if 
				
				OBJECT SET VALUE:C1742($form.search; $o)
				
				$t:=$class.fieldFilterLabel()
				ST SET TEXT:C1115(*; $form.fieldFilter; $t; ST Start text:K78:15; ST End text:K78:16)
				OBJECT SET VISIBLE:C603(*; $form.fieldFilter; Length:C16($t)>0)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				ST SET TEXT:C1115(*; $form.tableFilter; $class.tableFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
				
				OBJECT SET VISIBLE:C603(*; $form.tableFilter; True:C214)
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1; 0x00FFFFFF; 0x00FFFFFF)
				SET TIMER:C645(-1)  // Restore visual selection
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.tableFilter)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Get the content type
				If (ST Get content type:C1286(*; $e.objectName; ST Start highlight:K78:13; ST End highlight:K78:14)=ST User type:K78:12)  // This is a user link
					
					$menu:=cs:C1710.menu.new()
					
					If (Length:C16(String:C10($context.tableFilter))>0)
						
						$menu.append(Get localized string:C991("structName")+" : ("+$context.tableFilter+")"; "name").mark()
						
					Else 
						
						$menu.append("structName"; "name").disable()
						
					End if 
					
					$menu.append("onlyPublishedTables"; "published").mark(Bool:C1537($context.tableFilterPublished))
					
					$menu.popup()
					
					Case of 
							
							//………………………………………………………………………………………
						: (Not:C34($menu.selected))
							
							// Nothing selected
							
							//………………………………………………………………………………………
						: ($menu.choice="name")  // Remove name filter
							
							$context.tableFilter:=""
							
							$class.tableList()
							
							//………………………………………………………………………………………
						: ($menu.choice="published")  // Add-remove published filter
							
							$context.tableFilterPublished:=Not:C34(Bool:C1537($context.tableFilterPublished))
							
							$class.tableList()
							
							//………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
							
							//………………………………………………………………………………………
					End case 
					
					ST SET TEXT:C1115(*; $form.tableFilter; $class.tableFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.fieldList)
		
		LISTBOX GET CELL POSITION:C971(*; $e.objectName; $column; $row)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Selection Change:K2:29)\
				 | ($e.code=On Clicked:K2:4)
				
				editor_ui_LISTBOX($e.objectName)
				
				If ($row=0)
					
					OB REMOVE:C1226($context; "fieldName")
					
				Else 
					
					// Keep the current field name
					$context.fieldName:=(OBJECT Get pointer:C1124(Object named:K67:5; $form.fields))->{$row}
					
					If ($e.code=On Clicked:K2:4)\
						 && (PROJECT.isNotLocked())
						
						If (Right click:C712)
							
							// TODO: Contextual menu [un]publish all
							
						Else 
							
							If ($row>0)\
								 && ($column=3)
								
								$field:=PROJECT.getCatalog().query("name = :1"; $context.currentTable.name).pop().fields.query("name = :1"; $context.fieldName).pop()
								
								If ($field.kind="relatedEntity")\
									 || (($field.kind="alias") & ($field.fieldType=Is object:K8:27))
									
									//TODO: Manage alias to entity
									
									OBJECT Get pointer:C1124(Object named:K67:5; $form.published)->{$row}:=$class.doFieldPicker()
									
								Else 
									
									If (Macintosh command down:C546 | Shift down:C543)
										
										// TODO: Invert/propage ?
										
									Else 
										
										// Invert published status
										($form.publishedPtr)->{$row}:=1-($form.publishedPtr)->{$row}
										$class.updateProject()
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Data Change:K2:15)
				
				LISTBOX GET CELL POSITION:C971(*; $e.objectName; $column; $row)
				
				If ($column=1)
					
					// Keep current
					$context.fieldName:=(OBJECT Get pointer:C1124(Object named:K67:5; $form.fields))->{$row}
					
					// Three-state checkbox
					If ($Ptr_me->{$row}=2)
						
						$Ptr_me->{$row}:=0
						
					End if 
					
					If (Macintosh command down:C546)  // Apply the value to all items
						
						For ($i; 1; LISTBOX Get number of rows:C915(*; $e.objectName); 1)
							
							$Ptr_me->{$i}:=$Ptr_me->{$row}
							
						End for 
					End if 
					
					//#MARK_TODO - use CALL FORM to avoid three-state display
					$class.updateProject()
					
					If ($Ptr_me->{$row}=0)
						
						PROJECT.updateActions()
						
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				EDITOR.tips.instantly(100)
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$context.setHelpTip($e.objectName; $form)
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				OBJECT SET HELP TIP:C1181(*; $e.objectName; "")
				
				EDITOR.tips.restore()
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				$context.focus:=$form.fields
				
				LISTBOX GET CELL POSITION:C971(*; $e.objectName; $l; $row)
				
				If ($row=0)
					
					If (LISTBOX Get number of rows:C915(*; $e.objectName)>0)
						
						LISTBOX SELECT ROW:C912(*; $e.objectName; 1; lk replace selection:K53:1)
						
					End if 
				End if 
				
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1; EDITOR.highlightColor; EDITOR.highlightColor)
				
				// Move search & action [
				ui_MOVE($form.search; $e.objectName; Align right:K42:4; 30)
				ui_MOVE($form.action; $e.objectName; Align right:K42:4; 0)
				
				OBJECT SET VISIBLE:C603(*; $form.fields+".filter"; False:C215)
				OBJECT SET VISIBLE:C603(*; $form.search; True:C214)
				OBJECT SET VISIBLE:C603(*; $form.action; True:C214)
				//]
				
				var $o : Object
				$o:=OBJECT Get value:C1743($form.search)
				
				If ($o=Null:C1517)
					
					$o:=New object:C1471("value"; "")
					
				Else 
					
					$o.value:=String:C10($context.fieldFilter)
					
				End if 
				
				OBJECT SET VALUE:C1742($form.search; $o)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				ST SET TEXT:C1115(*; $form.fieldFilter; $class.fieldFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
				
				OBJECT SET VISIBLE:C603(*; $form.fields+".filter"; True:C214)
				OBJECT SET RGB COLORS:C628(*; $e.objectName; Foreground color:K23:1; 0x00FFFFFF; 0x00FFFFFF)
				SET TIMER:C645(-1)  // Restore visual selection
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.fieldFilter)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Get the content type
				If (ST Get content type:C1286(*; $e.objectName; ST Start highlight:K78:13; ST End highlight:K78:14)=ST User type:K78:12)  // This is a user link
					
					$menu:=cs:C1710.menu.new()
					
					If (Length:C16(String:C10($context.fieldFilter))>0)
						
						$menu.append(Get localized string:C991("structName")+" : ("+$context.fieldFilter+")"; "name").mark()
						
					Else 
						
						$menu.append("structName"; "name").disable()
						
					End if 
					
					$menu.append("onlyPublishedFields"; "published").mark(Bool:C1537($context.fieldFilterPublished))
					$menu.popup()
					
					Case of 
							
							//………………………………………………………………………………………
						: (Not:C34($menu.selected))
							
							// Nothing selected
							
							//………………………………………………………………………………………
						: ($menu.choice="name")  // Remove name filter
							
							$context.fieldFilter:=""
							$class.fieldList()
							ST SET TEXT:C1115(*; $form.fieldFilter; $class.fieldFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
							
							//………………………………………………………………………………………
						: ($menu.choice="published")  // Add-remove published filter
							
							$context.fieldFilterPublished:=Not:C34(Bool:C1537($context.fieldFilterPublished))
							$class.fieldList()
							ST SET TEXT:C1115(*; $form.fieldFilter; $class.fieldFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
							
							//………………………………………………………………………………………
						Else 
							
							ASSERT:C1129(False:C215; "Unknown menu action ("+$menu.choice+")")
							
							//………………………………………………………………………………………
					End case 
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.search)
		
		Case of 
				
				//______________________________________________________
			: ($e.code<0)  // <SUBFORM EVENTS>
				
				Case of 
						
						//…………………………………………………………………………………………………
					: ($e.code=-1)
						
						// Filter the vue by name
						If (Not:C34(OB Is empty:C1297($Ptr_me->)))
							
							If ($context.focus=$form.tables)
								
								$context.tableFilter:=$Ptr_me->value
								
								$class.tableList()
								ST SET TEXT:C1115(*; $form.tableFilter; $class.tableFilterLabel(); ST Start text:K78:15; ST End text:K78:16)
								
							Else   // Fields
								
								$context.fieldFilter:=$Ptr_me->value
								
								$class.fieldList()
								
								If (Length:C16(String:C10($context.fieldFilter))>0)
									
									// Create a styled text with a User Link
									$t:=Get localized string:C991("filteredBy")+Char:C90(Space:K15:42)+"<span style=\"-d4-ref-user:'filter'\">"+Get localized string:C991("structName")+"</span>"
									
									ST SET TEXT:C1115(*; $form.fieldFilter; $t; ST Start text:K78:15; ST End text:K78:16)
									
								Else 
									
									ST SET TEXT:C1115(*; $form.fieldFilter; ""; ST Start text:K78:15; ST End text:K78:16)
									
								End if 
							End if 
						End if 
						
						//…………………………………………………………………………………………………
					Else 
						
						ASSERT:C1129(False:C215; "Unknown call from subform ("+$e.description+")")
						
						//…………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				OBJECT SET VISIBLE:C603(*; Choose:C955($context.focus=$form.tables; $form.tableFilter; $form.fieldFilter); False:C215)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				OBJECT SET VISIBLE:C603(*; Choose:C955($context.focus=$form.tables; $form.tableFilter; $form.fieldFilter); True:C214)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.action)
		
		$class.doActionMenu()
		
		//==================================================
	: ($e.objectName="space.shortcut")
		
		If (PROJECT.isNotLocked())
			
			// Check/uncheck the selection
			If (OBJECT Get name:C1087(Object with focus:K67:3)=$form.fieldList)
				
				// Check the selection
				$Ptr_me:=OBJECT Get pointer:C1124(Object named:K67:5; $form.fieldList)
				$row:=Find in array:C230($Ptr_me->; True:C214)
				
				If ($row>0)
					
					// Get the value of the first selected item
					$Ptr_published:=OBJECT Get pointer:C1124(Object named:K67:5; $form.published)
					$b:=Bool:C1537($Ptr_published->{$row})
					
					// Apply to all selected items
					
					Repeat 
						
						$indx:=Find in array:C230($Ptr_me->; True:C214; $indx+1)
						
						If ($indx>0)
							
							$Ptr_published->{$indx}:=Num:C11(Not:C34($b))
							
						End if 
					Until ($indx=-1)
				End if 
			End if 
			
			$class.updateProject()
			
		End if 
		
		//==================================================
	: ($e.objectName="search.shortcut")
		
		EXECUTE METHOD IN SUBFORM:C1085("search"; "Search_HANDLER"; *; New object:C1471(\
			"action"; "search"))
		
		//==================================================
		//: ($e.objectName="splitter")  // **********************************************
		//Case of 
		////______________________________________________________
		//: ($e.code=On Clicked)
		//// Determine the offset
		//OBJECT GET COORDINATES(*; $e.objectName; $left; $top; $right; $bottom)
		//OBJECT GET COORDINATES(*; "_viewport"; $l; $Lon_targetTop; $l; $Lon_targetBottom)
		//$Lon_vOffset:=$bottom-$Lon_targetBottom
		//If (($Lon_targetBottom+$Lon_vOffset-$Lon_targetTop)<=200)
		//// < Minimum height
		//CLEAR VARIABLE($Lon_vOffset)
		//OBJECT GET SUBFORM CONTAINER SIZE($width; $height)
		//$bottom:=$height-10
		//OBJECT SET COORDINATES(*; "splitter"; 0; $bottom; $width; $bottom+1)
		//Else 
		//// Hide the bottom line
		//OBJECT SET VISIBLE(*; "bottom.line"; False)
		//CALL FORM(Current form window; "editor_CALLBACK"; "resizePanel"; New object(\
																																																															"panel"; Current form name; \
																																																															"offset"; $Lon_vOffset))
		//End if 
		////______________________________________________________
		//: ($e.code=On Mouse Leave)
		//GET MOUSE($l; $l; $Lon_button)
		//If ($Lon_button#1)
		//OBJECT GET SUBFORM CONTAINER SIZE($width; $height)
		//$bottom:=$height-10
		//OBJECT SET COORDINATES(*; "splitter"; 0; $bottom; $width; $bottom+1)
		//End if 
		//If ($Lon_button=0)
		////  // Place and show the bottom line
		////OBJECT GET COORDINATES(*;"bottom.line";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		////$Lon_top:=$Lon_top+$Lon_vOffset
		////$Lon_bottom:=$Lon_top
		////OBJECT SET COORDINATES(*;"bottom.line";$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		//// OBJECT SET VISIBLE(*;"bottom.line";True)
		////  // Force redraw of the window
		////$Lon_windowRef:=Current form window
		////GET WINDOW RECT($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_windowRef)
		////SET WINDOW RECT($Lon_left;$Lon_top;$Lon_right+1;$Lon_bottom;$Lon_windowRef)
		////SET WINDOW RECT($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_windowRef)
		//End if 
		////______________________________________________________
		//Else 
		//ASSERT(False; "Form event activated unnecessarily ("+$e.description+")")
		////______________________________________________________
		//End case 
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$e.objectName+"\"")
		
		//==================================================
End case 