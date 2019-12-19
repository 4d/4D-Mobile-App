//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : views_OBJECTS_HANDLER
  // ID[D7D3A572E98F4D8BBDDCE96E1A322DAC]
  // Created 18-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_BLOB:C604($x)
C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($Txt_tableNumber;$Txt_template;$Txt_typeForm)
C_OBJECT:C1216($context;$form;$Obj_current)

If (False:C215)
	C_LONGINT:C283(views_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$form:=VIEWS_Handler (New object:C1471(\
		"action";"init"))
	
	$context:=$form.$
	
	$0:=-1  // Reject drop
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($form.form.current=$form.tableWidget.name)
		
		$Txt_typeForm:=$context.typeForm()
		
		Case of 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)
				
				OB REMOVE:C1226($context;"picker")
				
				$Txt_tableNumber:=SVG Find element ID by coordinates:C1054(*;$form.form.current;MOUSEX;MOUSEY)
				$Txt_template:=String:C10(Form:C1466[$Txt_typeForm][$Txt_tableNumber].form)
				
				Case of 
						
						  //______________________________________________________
					: (Length:C16($Txt_tableNumber)=0)  // Outside click
						
						If (Form:C1466[$Txt_typeForm][$context.tableNum()].form#Null:C1517)
							
							$form.fieldGroup.show()
							$form.previewGroup.show()
							
							$form.form.call("pickerHide")
							
						End if 
						
						  //______________________________________________________
					: ($Txt_tableNumber=$context.tableNum())
						
						If (Bool:C1537(Form:C1466.$dialog.picker))
							
							If (Length:C16($Txt_template)#0)
								
								$form.form.call("pickerHide")
								
							End if 
							
						Else 
							
							  // Display the template picker
							$form.fieldGroup.hide()
							$form.previewGroup.hide()
							
							views_LAYOUT_PICKER ($Txt_typeForm)
							
							CLEAR VARIABLE:C89($Txt_tableNumber)  // To avoid redrawing the preview
							
						End if 
						
						  //______________________________________________________
					: ($Txt_tableNumber#$context.tableNum())\
						 | (Length:C16($Txt_template)=0)\
						 | (Test path name:C476(COMPONENT_Pathname ("listforms").platformPath+$Txt_template+Folder separator:K24:12)#Is a folder:K24:2)
						
						If ($Txt_tableNumber#$context.tableNum())
							
							$form.form.call("pickerHide")
							
							$context.tableNumber:=$Txt_tableNumber
							
						End if 
						
						If (Length:C16($context.tableNum())>0)
							
							  // Restore current selected background
							SVG SET ATTRIBUTE:C1055(*;$form.form.current;$context.tableNumber;\
								"fill";ui.unselectedFillColor)
							
						End if 
						
						  // Select the item
						SVG SET ATTRIBUTE:C1055(*;$form.form.current;$Txt_tableNumber;\
							"fill";ui.selectedColorFill)
						
						$context.draw:=True:C214
						$context.update:=True:C214
						$context.picker:=(Length:C16($Txt_template)=0)
						
						  //______________________________________________________
					Else 
						
						$form.form.call("pickerHide")
						
						  // Outside click
						If (Length:C16($context.tableNum())>0)
							
							  // Unselect
							SVG SET ATTRIBUTE:C1055(*;$form.form.current;$context.tableNumber;\
								"fill";ui.unselectedFillColor)
							
						End if 
						
						$context.tableNumber:=""
						
						  //______________________________________________________
				End case 
				
				  // Update UI
				If (Length:C16($Txt_tableNumber)#0)
					
					OB REMOVE:C1226($context;"manifest")
					
					  // Redraw
					$form.form.refresh()
					
				End if 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Scroll:K2:57)
				
				  // Update geometry
				$context.setGeometry()
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
				  //______________________________________________________
		End case 
		
		editor_ui_LISTBOX ($form.fieldList.name)
		
		  //==================================================
	: ($form.form.current=$form.fieldList.name)
		
		Case of 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)\
				 | ($form.form.eventCode=On Selection Change:K2:29)
				
				editor_ui_LISTBOX ($form.form.current)
				
				  //______________________________________________________
			: ($form.form.eventCode=On Begin Drag Over:K2:44)
				
				$form.fieldList.cellPosition()
				
				  // Get the dragged field
				  //%W-533.3
				$Obj_current:=($form.fields.pointer())->{$form.fieldList.row}
				  //%W+533.3
				
				$b:=($Obj_current.fieldType#8859)  // Not 1-N relation
				
				If (Not:C34($b))
					
					  // 1-N relation with published related data class
					$b:=(Form:C1466.dataModel[String:C10($Obj_current.relatedTableNumber)]#Null:C1517)
					
				End if 
				
				If ($b)
					
					  // Put into the container
					VARIABLE TO BLOB:C532($Obj_current;$x)
					APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.field";$x)
					SET BLOB SIZE:C606($x;0)
					
					  // Create the drag icon
					$p:=svg .embedPicture(ui.fieldIcons[$Obj_current.fieldType];2;2).textArea($Obj_current.path+" ";20;2).setAttribute("font-size";13).getPicture()
					
					SET DRAG ICON:C1272($p)
					
				End if 
				
				editor_ui_LISTBOX ($form.form.current)
				
				  //______________________________________________________
			: ($form.form.eventCode=On Getting Focus:K2:7)
				
				editor_ui_LISTBOX ($form.form.current;True:C214)
				
				  //______________________________________________________
			: ($form.form.eventCode=On Losing Focus:K2:8)
				
				editor_ui_LISTBOX ($form.form.current;False:C215)
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
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
	: ($form.form.current=$form.preview.name)
		
		$context.current:=SVG Find element ID by coordinates:C1054(*;$form.form.current;MOUSEX;MOUSEY)
		
		Case of 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)
				
				Case of 
						
						  //………………………………………………………………………………………………………………
					: ($context.current="tab_@")
						
						  // Keep the clicked tab index
						$context.tabIndex:=Replace string:C233($context.current;"tab_";"")
						
						  // Update preview
						views_preview ("draw";$form)
						
						  //………………………………………………………………………………………………………………
					: ($context.current="@.cancel")
						
						$form.cancel()
						
						  //………………………………………………………………………………………………………………
					Else 
						
						  // NOT A CLICKABLE OBJECT
						
						  //………………………………………………………………………………………………………………
				End case 
				
				$form.fieldList.focus()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Drag Over:K2:13)
				
				$0:=$form.drag()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Mouse Enter:K2:33)
				
				ui.tips.enable()
				ui.tips.setDuration(ui.tips.delay*2)
				ui.tips.instantly()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Mouse Leave:K2:34)
				
				ui.tips.defaultDelay()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Mouse Move:K2:35)
				
				$form.tips()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Drop:K2:12)
				
				$form.drop()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Scroll:K2:57)
				
				OBJECT GET SCROLL POSITION:C1114(*;$form.preview.name;$l)
				$context.scroll:=450-$l
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($form.form.current=$form.selectorList.name)\
		 | ($form.form.current=$form.selectorDetail.name)
		
		Case of 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)
				
				  // Hide picker if any
				$form.form.call("pickerHide")
				
				  // Update tab detail/list
				$context.selector:=1+Num:C11($form.form.current=$form.selectorDetail.name)
				$context.setTab()
				
				  // Update field list
				$context.update:=True:C214
				
				  //$Obj_context.actions:=_w_actions ("getList";$Obj_context).actions
				
				OB REMOVE:C1226($context;"manifest")
				
				  // Redraw
				$context.draw:=True:C214
				$form.form.refresh()
				
				  //______________________________________________________
			: ($form.form.eventCode=On Mouse Enter:K2:33)
				
				If ($context.selector#(1+Num:C11($form.form.current=$form.selectorDetail.name)))
					
					  // Highlights
					$Obj_current:=Choose:C955($form.form.current=$form.selectorList.name;$form.selectorList;$form.selectorDetail)
					$Obj_current.setColors(ui.selectedColor;Background color none:K23:10)
					
				End if 
				
				  //______________________________________________________
			: ($form.form.eventCode=On Mouse Leave:K2:34)
				
				$Obj_current:=Choose:C955($form.form.current=$form.selectorList.name;$form.selectorList;$form.selectorDetail)
				$Obj_current.setColors(Foreground color:K23:1;Background color none:K23:10)
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($form.form.current=$form.tableButtonNext.name)\
		 | ($form.form.current=$form.tableButtonPrevious.name)
		
		VIEWS_Handler (New object:C1471(\
			"action";"scroll-table";\
			"direction";Choose:C955($form.form.current=$form.tableButtonPrevious.name;"previous";"next")))
		
		  //==================================================
	: ($form.form.current=$form.resources.name)
		
		If ($context.selector=1)
			
			OPEN URL:C673(Get localized string:C991("doc_listForm");*)
			
		Else 
			
			OPEN URL:C673(Get localized string:C991("doc_detailForm");*)
			
		End if 
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown object: \""+$form.form.current+"\"")
		
		  //==================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End