//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : VIEWS_Objects_handler
// ID[D7D3A572E98F4D8BBDDCE96E1A322DAC]
// Created 18-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Integer

If (False:C215)
	C_LONGINT:C283(VIEWS_OBJECTS_HANDLER; $0)
End if 

var $t; $tableID; $template; $typeForm : Text
var $p : Picture
var $isAvailable; $ok : Boolean
var $count; $i; $indx; $l : Integer
var $x : Blob
var $context; $e; $form; $menu; $o : Object
var $fieldList : Collection
var $view : cs:C1710.VIEWS

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If (Count parameters:C259>=1)
		
		// <NONE>
		
	End if 
	
	$e:=FORM Event:C1606
	
	$form:=VIEWS_Handler(New object:C1471("action"; "init"))
	$context:=$form.$
	
	$0:=-1  // Reject drop
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($e.objectName=$form.tableWidget.name)
		
		$typeForm:=$context.typeForm()
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				OB REMOVE:C1226($context; "picker")
				
				$tableID:=SVG Find element ID by coordinates:C1054(*; $e.objectName; MOUSEX; MOUSEY)
				$template:=String:C10(Form:C1466[$typeForm][$tableID].form)
				
				If (Length:C16($template)>0)
					
					If ($template[[1]]="/")
						
						$isAvailable:=path["host"+$typeForm+"Forms"]().file(Substring:C12($template; 2)).exists\
							 | path["host"+$typeForm+"Forms"]().folder(Substring:C12($template; 2)).exists
						
					Else 
						
						$isAvailable:=path[$typeForm+"Forms"]().folder($template).exists
						
					End if 
				End if 
				
				Case of 
						
						//______________________________________________________
					: (Length:C16($tableID)=0)  // Outside click
						
						If (Form:C1466[$typeForm][$context.tableNum()].form#Null:C1517)
							
							$form.form.call("pickerHide")
							
							If (Bool:C1537(Form:C1466.$dialog.picker))
								
								$form.fieldGroup.show()
								$form.previewGroup.show()
								$form.scrollBar.hide()
								
								$form.form.refresh()
								
							End if 
						End if 
						
						//______________________________________________________
					: ($tableID=$context.tableNum())
						
						If (Bool:C1537(Form:C1466.$dialog.picker))
							
							If (Length:C16($template)#0)
								
								$form.form.call("pickerHide")
								
							End if 
							
						Else 
							
							// Display the template picker
							$form.fieldGroup.hide()
							$form.previewGroup.hide()
							
							views_LAYOUT_PICKER($typeForm)
							
							CLEAR VARIABLE:C89($tableID)  // To avoid redrawing the preview
							
						End if 
						
						//______________________________________________________
					: ($tableID#$context.tableNum())\
						 | (Length:C16($template)=0)\
						 | Not:C34($isAvailable)
						
						If ($tableID#$context.tableNum()) & $isAvailable
							
							$form.form.call("pickerHide")
							
						End if 
						
						If (Length:C16($context.tableNum())>0)
							
							// Restore current selected background
							SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.tableNumber; \
								"fill"; UI.unselectedFillColor)
							
						End if 
						
						// Select the item
						SVG SET ATTRIBUTE:C1055(*; $e.objectName; $tableID; \
							"fill"; UI.selectedColorFill)
						
						$context.draw:=True:C214
						$context.update:=True:C214
						$context.picker:=(Length:C16($template)=0)
						
						$context.tableNumber:=$tableID
						
						//______________________________________________________
					Else 
						
						$form.form.call("pickerHide")
						
						// Outside click
						If (Length:C16($context.tableNum())>0)
							
							// Unselect
							SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.tableNumber; \
								"fill"; UI.unselectedFillColor)
							
						End if 
						
						$context.tableNumber:=""
						
						//______________________________________________________
				End case 
				
				// Update UI
				If (Length:C16($tableID)#0)
					
					//OB REMOVE($context; "manifest")
					
					// Redraw
					$form.form.refresh()
					
				End if 
				
				//______________________________________________________
			: ($e.code=On Scroll:K2:57)
				
				// Update geometry
				$context.setGeometry()
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				UI.tips.enable()
				UI.tips.setDuration(UI.tips.delay*2)
				UI.tips.instantly()
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				UI.tips.defaultDelay()
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$tableID:=SVG Find element ID by coordinates:C1054(*; $e.objectName; MOUSEX; MOUSEY)
				SVG GET ATTRIBUTE:C1056(*; $e.objectName; $tableID; "tips"; $t)
				OBJECT SET HELP TIP:C1181(*; $e.objectName; $t)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		editor_ui_LISTBOX($form.fieldList.name)
		
		//==================================================
	: ($e.objectName=$form.fieldList.name)
		
		$view:=cs:C1710.VIEWS.new($form)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Double Clicked:K2:5)
				
				If (FEATURE.with("newViewUI"))\
					 & (Num:C11($context.template.manifest.renderer)>=2)
					
					$typeForm:=Choose:C955(Num:C11($context.selector)=2; "detail"; "list")
					
					If ($typeForm="detail")
						
						$form.fieldList.cellPosition()
						
						// Get the current field
						//%W-533.3
						$o:=($form.fields.pointer())->{$form.fieldList.row}
						$o.name:=$o.path
						//%W+533.3
						
						$view.addField($o; Form:C1466[$typeForm][$context.tableNumber].fields)
						
						// Update preview
						$view.draw()
						
						// Save project
						PROJECT.save()
						
					Else 
						
						// Not for a list form
						
					End if 
				End if 
				
				editor_ui_LISTBOX($e.objectName)
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)\
				 | ($e.code=On Selection Change:K2:29)
				
				editor_ui_LISTBOX($e.objectName)
				
				If (FEATURE.with("newViewUI"))\
					 & (Num:C11($context.template.manifest.renderer)>=2)
					
					$typeForm:=Choose:C955(Num:C11($context.selector)=2; "detail"; "list")
					
					If (Contextual click:C713) & ($typeForm="detail")
						
						$fieldList:=Form:C1466[$typeForm][$context.tableNumber].fields
						
						$count:=Size of array:C274(($form.fields.pointer())->)
						
						If ($count>$fieldList.length)
							
							$menu:=cs:C1710.menu.new()
							
							If ($fieldList.length=0)
								
								$menu.append("addAllFields"; "all")
								
							Else 
								
								$menu.append("addMissingFields"; "missing")
								
							End if 
							
							$menu.popup()
							
							If ($menu.selected)
								
								Case of 
										
										//______________________________________________________
									: ($menu.choice="all")
										
										For ($i; 1; $count; 1)
											
											$o:=($form.fields.pointer())->{$i}
											$o.name:=$o.path
											
											$view.addField($o; $fieldList)
											
										End for 
										
										//______________________________________________________
									: ($menu.choice="missing")
										
										For ($i; 1; $count; 1)
											
											$o:=($form.fields.pointer())->{$i}
											
											If ($fieldList.query("path = :1"; $o.path).pop()=Null:C1517)
												
												If (Num:C11($o.fieldNumber)=0)\
													 | ($fieldList.query("fieldNumber = :1"; Num:C11($o.fieldNumber)).pop()=Null:C1517)
													
													// Add the field
													$o.name:=$o.path
													$view.addField($o; $fieldList)
													
												End if 
											End if 
										End for 
										
										//______________________________________________________
									Else 
										
										// A "Case of" statement should never omit "Else
										TRACE:C157
										
										//______________________________________________________
								End case 
								
								// Update preview
								$view.draw()
								
								// Save project
								PROJECT.save()
								
							End if 
						End if 
					End if 
				End if 
				
				//______________________________________________________
			: ($e.code=On Begin Drag Over:K2:44)
				
				$form.fieldList.cellPosition()
				
				// Get the dragged field
				//%W-533.3
				$o:=($form.fields.pointer())->{$form.fieldList.row}
				//%W+533.3
				
				$ok:=($o.fieldType#8858) & ($o.fieldType#8859)  // Not a relation
				
				If (Not:C34($ok))
					
					// 1-N relation with published related data class
					$ok:=(Form:C1466.dataModel[String:C10($o.relatedTableNumber)]#Null:C1517)\
						 | (Bool:C1537($o.$added))
					
				End if 
				
				If ($ok)
					
					// Put into the container
					VARIABLE TO BLOB:C532($o; $x)
					APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.field"; $x)
					SET BLOB SIZE:C606($x; 0)
					
					// Set the drag icon
					$p:=cs:C1710.svg.new()\
						.embedPicture(UI.fieldIcons[$o.fieldType]).position(2; 2)\
						.textArea($o.path+" "; "append").fontSize(13).position(20; 2)\
						.getPicture()
					
					SET DRAG ICON:C1272($p)
					
					$0:=0
					
				End if 
				
				editor_ui_LISTBOX($e.objectName)
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX($e.objectName; True:C214)
				
				//______________________________________________________
			: ($e.code=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX($e.objectName; False:C215)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
		//: ($Obj_form.form.currentWidget=$Obj_form.actionList)
		// Case of
		//  //______________________________________________________
		//: ($Obj_form.form.eventCode=On Begin Drag Over)
		//$o:=$Obj_context.currentAction
		//  // Put into the conatianer
		//VARIABLE TO BLOB($o;$x)
		//APPEND DATA TO PASTEBOARD("com.4d.private.ios.action";$x)
		//SET BLOB SIZE($x;0)
		//  // Create the drag icon
		// SVG_SET_OPTIONS (SVG_Get_options  ?+ 12)
		//$t:=SVG_New
		//SVG_SET_TEXT_RENDERING ($t;"geometricPrecision")
		//SVG_SET_SHAPE_RENDERING ($t;"crispEdges")
		//SVG_SET_VIEWPORT_FILL ($t;SVG_Color_RGB_from_long (UI.backgroundSelectedColor))
		//SVG_New_rect ($t;0.5;0;20;20;0;0;"none";SVG_Color_RGB_from_long (UI.backgroundSelectedColor))
		//SVG_New_embedded_image ($t;$o.$icon;2;2)
		//SVG_New_text ($t;$o.name+" ";26;4;"Sans-serif";13)
		//SVG EXPORT TO PICTURE($t;$p;Own XML data source)
		//SET DRAG ICON($p)
		// Else
		//ASSERT(False;"Form event activated unnecessarily ("+String($Obj_form.form.eventCode)+")")
		//  //______________________________________________________
		// End case
		//==================================================
		//: ($Obj_form.form.currentWidget=$Obj_form.actionDrop)
		// Case of
		//  //______________________________________________________
		//: ($Obj_form.form.eventCode=On Drag Over)
		//  // Accept drag if a field is drag over
		//GET PASTEBOARD DATA("com.4d.private.ios.action";$x)
		// If (Bool(OK))
		//BLOB TO VARIABLE($x;$o)
		//SET BLOB SIZE($x;0)
		//If (String($o.target)#"widget")
		//$Obj_target:=Form[$Obj_context.typeForm()][$Obj_context.tableNum()]
		//If (_or (New formula($Obj_target.actions=Null);New formula($Obj_target.actions.extract("name").indexOf(String($o.name))=-1)))
		//$0:=0  //    Accept drop
		// End if
		// End if
		// End if
		//  //______________________________________________________
		//: ($Obj_form.form.eventCode=On Drop)
		//  // Get the pastboard
		//GET PASTEBOARD DATA("com.4d.private.ios.action";$x)
		// If (Bool(OK))
		//BLOB TO VARIABLE($x;$o)
		//SET BLOB SIZE($x;0)
		//$Obj_target:=Form[$Obj_context.typeForm()][$Obj_context.tableNum()]
		//ob_createPath (Form[$Obj_context.typeForm()][$Obj_context.tableNum()];"actions";Is collection)
		//If ($Obj_target.actions.extract("name").indexOf(String($o.name))=-1)  //    Don't add action twice
		//$Ptr_me:=OBJECT Get pointer(Object current)
		//$Ptr_me->:=$Ptr_me->+$o.$icon
		//  // Update project
		//OB REMOVE($o;"target")
		//For each ($t;$o)
		//If ($t[[1]]="$")
		//OB REMOVE($o;$t)
		// End if
		// End for each
		//$Obj_target.actions.push($o)
		// End if
		//  // Save project
		// project.save()
		// End if
		// Else
		//ASSERT(False;"Form event activated unnecessarily ("+String($Obj_form.form.eventCode)+")")
		//  //______________________________________________________
		// End case
		
		//==================================================
	: ($e.objectName=$form.preview.name)
		
		$context.current:=SVG Find element ID by coordinates:C1054(*; $e.objectName; MOUSEX; MOUSEY)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				Case of 
						
						//………………………………………………………………………………………………………………
					: ($context.current="tab_@")
						
						// Keep the clicked tab index
						$context.tabIndex:=Replace string:C233($context.current; "tab_"; "")
						
						// Update preview
						VIEWS_DRAW_FORM($form)
						
						//………………………………………………………………………………………………………………
					: ($context.current="@.cancel")
						
						$form.cancel()
						
						//………………………………………………………………………………………………………………
					: ($context.current="f@")
						
						//
						
						//………………………………………………………………………………………………………………
					Else 
						
						// NOT A CLICKABLE OBJECT
						
						//………………………………………………………………………………………………………………
				End case 
				
				$form.fieldList.focus()
				
				//______________________________________________________
			: ($e.code=On Begin Drag Over:K2:44)
				
				Case of 
						
						//………………………………………………………………………………………………………………
					: ($context.typeForm()="list")
						
						// DISABLE DRAG AND DROP
						
						//………………………………………………………………………………………………………………
					: ($context.current="tab_@")
						
						// NOT A DRAGGABLE OBJECT
						
						//………………………………………………………………………………………………………………
					: ($context.current="@.cancel")
						
						// NOT A DRAGGABLE OBJECT
						//………………………………………………………………………………………………………………
					: ($context.current="f@")
						
						SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.current+".cancel"; "visibility"; "hidden")
						SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.current+".g"; "fill-opacity"; 0.2; "stroke-opacity"; 0.5)
						
						// Get the dragged field
						$indx:=Num:C11($context.current)-1
						$o:=Form:C1466.detail[Form:C1466.$dialog.VIEWS.tableNumber].fields[$indx]
						$o.fromIndex:=$indx
						
						// Put into the container
						VARIABLE TO BLOB:C532($o; $x)
						APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.field"; $x)
						SET BLOB SIZE:C606($x; 0)
						
						// Create the drag icon
						$p:=cs:C1710.svg.new()\
							.embedPicture(UI.fieldIcons[$o.fieldType]).position(2; 2)\
							.textArea($o.path+" "; "append").fontSize(13).position(20; 2)\
							.getPicture()
						
						SET DRAG ICON:C1272($p)
						
						$0:=0
						
						//………………………………………………………………………………………………………………
					Else 
						
						// NOT A DRAGGABLE OBJECT
						
						//………………………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
			: ($e.code=On Drag Over:K2:13)
				
				$0:=$form.drag()
				
				//______________________________________________________
			: ($e.code=On Mouse Up:K2:58)
				
				//
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				UI.tips.enable()
				UI.tips.setDuration(UI.tips.delay*2)
				UI.tips.instantly()
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				GET PASTEBOARD DATA:C401("com.4d.private.ios.field"; $x)
				
				If (Bool:C1537(OK))
					
					//#redmine:117297 - [BUG] Move field out of the svg area
					SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.current+".cancel"; "visibility"; "visible")
					SVG SET ATTRIBUTE:C1055(*; $e.objectName; $context.current+".g"; "fill-opacity"; 1; "stroke-opacity"; 1)
					REDRAW WINDOW:C456
					
				End if 
				
				UI.tips.defaultDelay()
				
				//______________________________________________________
			: ($e.code=On Mouse Move:K2:35)
				
				$form.tips()
				
				//______________________________________________________
			: ($e.code=On Drop:K2:12)
				
				$form.drop()
				
				//______________________________________________________
			: ($e.code=On Scroll:K2:57)
				
				OBJECT GET SCROLL POSITION:C1114(*; $form.preview.name; $l)
				$context.scroll:=$context.previewHeight-$l
				
				vThermo:=$context.scroll
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.selectorList.name)\
		 | ($e.objectName=$form.selectorDetail.name)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Clicked:K2:4)
				
				// Hide picker if any
				$form.form.call("pickerHide")
				
				// Update tab detail/list
				$context.selector:=1+Num:C11($e.objectName=$form.selectorDetail.name)
				$context.setTab()
				
				// Update field list
				$context.update:=True:C214
				
				//$Obj_context.actions:=_w_actions ("getList";$Obj_context).actions
				
				OB REMOVE:C1226($context; "manifest")
				
				If (FEATURE.with("newViewUI"))
					
					OB REMOVE:C1226($context; "scrollPosition")
					$context.scroll:=0
					
				End if 
				
				// Redraw
				$context.draw:=True:C214
				$form.form.refresh()
				
				//______________________________________________________
			: ($e.code=On Mouse Enter:K2:33)
				
				If ($context.selector#(1+Num:C11($e.objectName=$form.selectorDetail.name)))
					
					// Highlights
					$o:=Choose:C955($e.objectName=$form.selectorList.name; $form.selectorList; $form.selectorDetail)
					$o.setColors(UI.selectedColor; Background color none:K23:10)
					
				End if 
				
				//______________________________________________________
			: ($e.code=On Mouse Leave:K2:34)
				
				$o:=Choose:C955($e.objectName=$form.selectorList.name; $form.selectorList; $form.selectorDetail)
				$o.setColors(Foreground color:K23:1; Background color none:K23:10)
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($e.objectName=$form.tableButtonNext.name)\
		 | ($e.objectName=$form.tableButtonPrevious.name)
		
		VIEWS_Handler(New object:C1471(\
			"action"; "scroll-table"; \
			"direction"; Choose:C955($e.objectName=$form.tableButtonPrevious.name; "previous"; "next")))
		//==================================================
	: ($e.objectName=$form.scrollBar.name)
		
		$context.scroll:=vThermo
		OBJECT SET SCROLL POSITION:C906(*; "preview"; -($context.scroll-$context.previewHeight); 0; *)
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown object: \""+$e.objectName+"\"")
		
		//==================================================
End case 