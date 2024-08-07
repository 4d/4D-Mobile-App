Class extends panel

//=== === === === === === === === === === === === === === === === === === === === ===
Class constructor($form : Object)
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	//MARK:TEMPO 🚧
	If (Count parameters:C259>=1)
		
		This:C1470.form:=$form  // #TEMPO
		
	End if 
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
		This:C1470.context.constraints.rules.push(New object:C1471(\
			"formula"; Formula:C1597(views_Handler(New object:C1471(\
			"action"; "geometry")))))
		
		This:C1470.context.constraints.rules.push(New object:C1471(\
			"object"; New collection:C1472("preview"; "preview.label"; "preview.back"; "Preview.border"); \
			"reference"; "viewport.preview"; \
			"type"; "horizontal alignment"; \
			"value"; "center"))
		
		This:C1470.context.constraints.rules.push(New object:C1471(\
			"object"; "preview.scrollBar"; \
			"reference"; "preview"; \
			"type"; "margin-left"; \
			"value"; 20))
		
	End if 
	
	This:C1470.scroll:=450
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	var $group : cs:C1710.group
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.button("noDataModel")
	
	This:C1470.picture("tableWidget")
	
	$group:=This:C1470.group("tableNext")
	This:C1470.button("next").addToGroup($group)
	This:C1470.formObject("next.limit").addToGroup($group)
	
	$group:=This:C1470.group("tablePrevious")
	This:C1470.button("previous").addToGroup($group)
	This:C1470.formObject("previous.limit").addToGroup($group)
	
	$group:=This:C1470.group("selectors")
	This:C1470.button("tablist"; "tab.list").addToGroup($group)
	This:C1470.button("tabdetail"; "tab.detail").addToGroup($group)
	This:C1470.formObject("tabSelector"; "tab.selector")
	
	This:C1470.listbox("fieldList"; "01_fields")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	var $offset : Integer
	
	// This trick remove the horizontal gap
	This:C1470.fieldList.setScrollbar(0; 2)
	
	$offset:=This:C1470.tablist.bestSize(Align left:K42:2).coordinates.right+10
	This:C1470.tabdetail.bestSize(Align left:K42:2).setCoordinates($offset)
	
	This:C1470.tabSelector.getCoordinates()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function _update()
	
	This:C1470.template:=Form:C1466.$dialog[Current form name:C1298].template
	This:C1470.manifest:=This:C1470.manifest#Null:C1517 ? This:C1470.template.manifest : Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function setTab()
	
	var $ref; $tgt : Object
	
	This:C1470.selectors.setFontStyle(Plain:K14:1)
	$ref:=This:C1470["tab"+This:C1470.typeForm()].setFontStyle(Bold:K14:2).coordinates
	$tgt:=This:C1470.tabSelector.coordinates
	This:C1470.tabSelector.setCoordinates($ref.left; $tgt.top; $ref.right; $tgt.bottom)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Redraw the preview
Function draw()
	
	tmpl_DRAW(This:C1470.form)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Define a field in the form
Function addField($field : cs:C1710.field; $fields : Collection)
	
	var $index : Integer
	
	If ($field.kind="alias")
		
		$field.name:=$field.$level>0 ? $field.path : $field.name
		
	Else 
		
		$field.name:=$field.path
		
	End if 
	
	//MARK:Cleanup
	PROJECT.minimumField($field)
	
	If ($field.kind="relatedEntities")  // 1-N relation with published related data class
		
		If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]#Null:C1517)
			
			// Append
			$fields.push($field)
			
		End if 
		
	Else 
		
		$index:=$fields.indexOf(Null:C1517)
		
		If (($index#-1))
			
			// Set
			$fields[$index]:=$field
			
		Else 
			
			// Append
			$fields.push($field)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Delete a field from the form
Function removeField()
	
	var $binding; $targetField; $testClass : Text
	var $indx : Integer
	var $form; $target : Object
	var $c : Collection
	var $field : cs:C1710.field
	var $menu : cs:C1710.menu
	
	//FIXME:Tempo
	$form:=This:C1470.form
	
	$targetField:=Replace string:C233(This:C1470.context.current; ".cancel"; "")
	SVG GET ATTRIBUTE:C1056(*; $form.preview.name; $targetField; "ios:bind"; $binding)
	
	$target:=Form:C1466[This:C1470.typeForm()][This:C1470.context.tableNumber]
	SVG GET ATTRIBUTE:C1056(*; $form.preview.name; $targetField; "4D-isOfClass-multi-criteria"; $testClass)
	
	If ($testClass="true")\
		 & (Value type:C1509($target[$binding])=Is collection:K8:32)
		
		$menu:=cs:C1710.menu.new()
		
		For each ($field; $target[$binding])
			
			If ($field=Null:C1517)
				
				continue
				
			End if 
			
			$menu.append(UI.str.localize("removeField"; $field.name); $field.name)
			
		End for each 
		
		$menu.line()
		$menu.append("removeAllFields"; "all")
		
		$menu.popup()
		
		If ($menu.selected)
			
			If ($menu.choice="all")
				
				$target[$binding]:=Null:C1517
				
			Else 
				
				// Delete one
				$c:=$target[$binding].indices("name = :1"; $menu.choice)
				
				If ($c.length>0)
					
					$target[$binding].remove($c[0])
					
					If ($target[$binding].length=1)
						
						// Convert to object
						$target[$binding]:=$target[$binding][0]
						
					End if 
					
				Else 
					
					oops
					
				End if 
			End if 
		End if 
		
	Else 
		
		If (Asserted:C1132(Length:C16($binding)>0))
			
			$c:=cs:C1710.regex.new($binding; "(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$").extract("1 2")
			
			If ($c.length=2)  // List of fields
				
				If ($target[$c[0]]#Null:C1517)
					
					$indx:=Num:C11($c[1])
					
					If ($target[$c[0]].length>$indx)
						
						SVG GET ATTRIBUTE:C1056(*; $form.preview.name; $targetField; "4D-isOfClass-multivalued"; $testClass)
						
						If ($testClass="true")
							
							$target[$c[0]].remove($indx)
							
						Else 
							
							// Empty
							$target[$c[0]][$indx]:=Null:C1517
							
						End if 
					End if 
				End if 
				
			Else 
				
				$target[$binding]:=Null:C1517
				
			End if 
		End if 
	End if 
	
	PROJECT.save()
	
	// Update preview
	This:C1470.draw()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Construct the table's field list
Function fieldList($table)->$result : Object
	
	var $attribute; $key; $linkPrefix; $sub; $tableID : Text
	var $subLevel : Integer
	var $tableModel : Object
	var $field; $subfield; $subfield2 : cs:C1710.field
	
	$linkPrefix:=Is macOS:C1572 ? "└ " : "└ "  //"├ " //" ┊"
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing parameter")
	
	$tableID:=Value type:C1509($table)=Is text:K8:3 ? $table : String:C10($table)
	
	$result:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	If ($result.success)
		
		// ⚠️ Make a copy so as not to modify the original
		$tableModel:=OB Copy:C1225(Form:C1466.dataModel[$tableID])
		
		$result.success:=($tableModel#Null:C1517)
		
		If ($result.success)
			
			$result.fields:=New collection:C1472
			
			For each ($key; $tableModel)
				
				
				If (Length:C16($key)=0)\
					 || (Value type:C1509($tableModel[$key])#Is object:K8:27)
					
					continue
					
				End if 
				
				$field:=$tableModel[$key]
				
				If ($field.kind="alias")
					
					$field.$target:=PROJECT.$project.ExposedStructure.aliasTarget($tableModel[""].name; $field).target
					
				End if 
				
				Case of 
						
						//……………………………………………………………………………………………………………
					: ($field.kind="storage")
						
						$field.path:=$field.name
						$field.fieldNumber:=Num:C11($key)
						
						$field.$label:=$field.name
						$field.$level:=0
						
						$result.fields.push($field)
						
						//……………………………………………………………………………………………………………
					: ($field.kind="alias") & ($field.relatedDataClass=Null:C1517)
						
						$field.name:=$key
						
						$field.$label:=$key
						$field.$level:=0
						
						$result.fields.push($field)
						
						//……………………………………………………………………………………………………………
					: ($field.kind="calculated")
						
						$field.name:=$key
						$field.path:=$field.name
						
						$field.$label:=$key
						$field.$level:=0
						
						$result.fields.push($field)
						
						//……………………………………………………………………………………………………………
					: ($field.kind="relatedEntity")\
						 || (($field.kind="alias") & (Bool:C1537($field.isToOne)))
						
						$subLevel+=10
						
						var $relation : Object
						$relation:=New object:C1471(\
							"kind"; "relatedEntity"; \
							"name"; $key; \
							"path"; $key; \
							"relatedDataClass"; $tableModel[$key].relatedDataClass; \
							"relatedTableNumber"; $tableModel[$key].relatedTableNumber; \
							"inverseName"; $tableModel[$key].inverseName; \
							"label"; PROJECT.label($key); \
							"shortLabel"; PROJECT.shortLabel($key); \
							"$added"; True:C214; \
							"$label"; $key; \
							"$level"; $subLevel)
						
						//FIXME:Tempo
						$relation.fieldType:=8858
						
						$result.fields.push($relation)
						
						// Add the entity's fields
						For each ($attribute; $field)
							
							
							If (Length:C16($attribute)=0)\
								 || (Value type:C1509($field[$attribute])#Is object:K8:27)
								
								continue
								
							End if 
							
							$subfield:=$field[$attribute]
							
							Case of 
									
									//……………………………………………………………………………………………………………
								: ($subfield.kind="storage")
									
									$subfield.$level:=$subLevel+1
									$subfield.$label:=$linkPrefix+$subfield.name
									
									$subfield.name:=$key+"."+$subfield.name
									$subfield.path:=$subfield.name
									
									$subfield.fieldNumber:=Num:C11($attribute)
									
									$result.fields.push($subfield)
									
									//……………………………………………………………………………………………………………
								: ($subfield.kind="alias")
									
									$subfield.$level:=$subLevel+1
									$subfield.$label:=$linkPrefix+$attribute
									
									$subfield.name:=$key+"."+$attribute
									$subfield.path:=$subfield.name
									
									$result.fields.push($subfield)
									
									//……………………………………………………………………………………………………………
								: ($subfield.kind="calculated")
									
									$subfield.$level:=$subLevel+1
									$subfield.$label:=$linkPrefix+$attribute
									
									$subfield.name:=$key+"."+$attribute
									$subfield.path:=$subfield.name
									
									$result.fields.push($subfield)
									
									//______________________________________________________
								: ($subfield.kind="relatedEntities")
									
									$subfield.$level:=$subLevel+2
									$subfield.$label:=$linkPrefix+$attribute
									
									$subfield.name:=$attribute
									
									//FIXME:Tempo
									$subfield.fieldType:=8859
									
									$result.fields.push($subfield)
									
									//______________________________________________________
								: ($subfield.kind="relatedEntity")
									
									For each ($sub; $subfield)
										
										
										If (Value type:C1509($subfield[$sub])#Is object:K8:27)
											
											continue
											
										End if 
										
										$subfield2:=$subfield[$sub]
										
										Case of 
											: ($subfield2.kind="alias")
												
												$subfield2.name:=$attribute+"."+$sub
												$subfield2.path:=$key+"."+$attribute+"."+$sub
												
											: ($subfield2.kind="storage")
												
												$subfield2.fieldNumber:=Num:C11($sub)
												$subfield2.name:=$subfield2.path
												$subfield2.path:=$key+"."+$subfield2.name
												
											Else 
												
												$subfield2.fieldNumber:=Num:C11($sub)
												$subfield2.name:=$key+"."+$sub
												$subfield2.path:=$key+"."+$subfield2.name
												
										End case 
										
										$subfield2.$label:=$linkPrefix+$subfield2.name
										$subfield2.$level:=$subLevel+2
										
										$result.fields.push($subfield2)
										
									End for each 
									
									//______________________________________________________
								Else 
									
									oops
									
									//______________________________________________________
							End case 
						End for each 
						
						//……………………………………………………………………………………………………………
					: ($field.kind="relatedEntities")
						
						$field.name:=$key
						$field.path:=$key
						
						$field.$name:=$key
						$field.$label:=$key
						$field.$level:=0
						
						//FIXME:Tempo
						$field.fieldType:=8859
						
						$result.fields.push($field)
						
						//……………………………………………………………………………………………………………
				End case 
			End for each 
			
			$result.fields:=$result.fields.orderBy("$level, $label")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Attach a form (Call back from widget)
Function setTemplate($browser : Object)
	
	var $currentTemplate; $newTemplate; $selector; $tableID; $url : Text
	var $update : Boolean
	var $context; $o; $target : Object
	var $c : Collection
	var $template : cs:C1710.tmpl
	
	$context:=This:C1470.form.$
	
	This:C1470.form.fieldGroup.show()
	This:C1470.form.previewGroup.show()
	This:C1470.form.scrollBar.hide()
	
	If ($browser.form#Null:C1517)  // Browser auto close
		
		$newTemplate:=$browser.form
		$update:=True:C214
		
	Else 
		
		If ($browser.item>0)\
			 & ($browser.item<=$browser.pathnames.length)
			
			If ($browser.pathnames[$browser.item-1]#Null:C1517)
				
				// The selected form
				$newTemplate:=$browser.pathnames[$browser.item-1]
				$update:=True:C214
				
			Else 
				
				// * SHOW BROWSER
				$url:="https://4d-go-mobile.github.io/gallery/"
				
				If (Feature.with("devGallery"))
					
					$url:="http://localhost:8080/"
					
				End if 
				
				Case of 
						//______________________________________________________
					: (PROJECT.$android & PROJECT.$ios)
						
						$url:=$url+"#/type/form-"+This:C1470.typeForm()+"/picker/1/target/ios,android"
						
						//______________________________________________________
					: (PROJECT.$android)
						
						$url:=$url+"#/type/form-"+This:C1470.typeForm()+"/picker/1/target/android"
						
						//______________________________________________________
					: (PROJECT.$ios)
						
						$url:=$url+"#/type/form-"+This:C1470.typeForm()+"/picker/1/target/ios"
						
						//______________________________________________________
				End case 
				
				$o:=New object:C1471(\
					"url"; $url)
				
				This:C1470.form.form.call(New collection:C1472("initBrowser"; $o))
				
			End if 
		End if 
	End if 
	
	If ($update)
		
		// Table number as string
		$tableID:=$context.tableNum()
		
		// Current selector (list | detail)
		$selector:=$browser.selector
		
		// The current table form
		$currentTemplate:=String:C10(Form:C1466[$selector][$tableID].form)
		
		If ($newTemplate#$currentTemplate)
			
			Logger.info("Selected template: "+$newTemplate)
			
			$template:=cs:C1710.tmpl.new($newTemplate; $selector).update()
			
			$target:=Form:C1466[$selector][$tableID]
			
			$browser.target:=OB Copy:C1225($target)
			OB REMOVE:C1226($browser.target; "form")
			
			If (Length:C16($currentTemplate)#0)
				
				// Save a snapshot of the current form definition
				Case of 
						
						//______________________________________________________
					: ($context[$tableID]=Null:C1517)
						
						$context[$tableID]:=New object:C1471(\
							$selector; New object:C1471($currentTemplate; \
							$browser.target))
						
						//______________________________________________________
					: ($context[$tableID][$selector]=Null:C1517)
						
						$context[$tableID][$selector]:=New object:C1471(\
							$currentTemplate; $browser.target)
						
						//______________________________________________________
					Else 
						
						$context[$tableID][$selector][$currentTemplate]:=$browser.target
						
						//______________________________________________________
				End case 
			End if 
			
			// Update project & save
			$target.form:=$newTemplate
			
			If ($target.fields=Null:C1517)
				
				$target.fields:=New collection:C1472
				
				If (Num:C11($template.manifest.fields.count)>0)
					
					$target.fields.resize($template.manifest.fields.count)
					
				End if 
			End if 
			
			PROJECT.save()
			
			If (ob_testPath(Form:C1466.$project; "status"; "project"))
				
				If (Not:C34(Form:C1466.$project.status.project))
					
					// Launch project verifications
					This:C1470.callMeBack("projectAudit")
					
				End if 
			End if 
			
			If ($context[$tableID][$selector][$newTemplate]=Null:C1517)
				
				If ($target.fields=Null:C1517)
					
					// Create a new binding
					$c:=New collection:C1472
					
				Else 
					
					// Use current
					$c:=$target.fields.copy()
					
				End if 
				
				If ($context[$tableID]#Null:C1517)
					
					If ($context[$tableID][$selector]#Null:C1517)
						
						$template.enrich($c; $context[$tableID][$selector])
						
					End if 
				End if 
				
			Else 
				
				// Reuse the last snapshot
				$c:=$context[$tableID][$selector][$newTemplate].fields
				$template.enrich($c; $context[$tableID][$selector]; $newTemplate)
				
			End if 
			
			$browser.form:=$newTemplate
			$browser.tableNumber:=$tableID
			$browser.manifest:=$template.manifest
			
			If (False:C215)  //#WIP
				
				$template.reorder($tableID)
				
			Else 
				
				$browser.template:=$template
				tmpl_REORDER($browser)
				
			End if 
		End if 
		
		// Redraw
		$context.draw:=True:C214
		UI.refresh()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Open the template selector
Function templatePicker($formType : Text)
	
	views_LAYOUT_PICKER($formType)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Building the table selector
Function buildTableWidget($dataModel : Object; $options : Object)->$widget : Picture
	
	var $name; $table; $typeForm : Text
	var $picture : Picture
	var $isSelected : Boolean
	var $x : Blob
	var $params; $str : Object
	var $color : Variant
	var $icon : 4D:C1709.File
	var $error : cs:C1710.error
	var $tmpl : cs:C1710.tmpl
	var $svg : cs:C1710.svg
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		$params:=$options
		
	Else 
		
		// No options
		$params:=New object:C1471
		
	End if 
	
	$params.x:=0  // Start x
	$params.y:=0  // Start y
	
	$params.cell:=New object:C1471(\
		"width"; 115; \
		"height"; 110)
	
	$params.icon:=New object:C1471(\
		"width"; 80; \
		"height"; 110)
	
	$params.hOffset:=5
	$params.maxChar:=Choose:C955(Get database localization:C1009="ja"; 7; 15)
	
	If (UI.darkScheme)
		
		$params.selectedFill:="#0E2732"
		$params.selectedStroke:="#48a7ee"
		
	Else 
		
		$params.selectedFill:=UI.colors.backgroundSelectedColor.css.hexLong
		$params.selectedStroke:=UI.colors.strokeColor.css.hexLong
		
	End if 
	
	
	$str:=cs:C1710.str.new()
	$error:=cs:C1710.error.new()
	$svg:=cs:C1710.svg.new()
	
	If ($dataModel#Null:C1517)
		
		$typeForm:=This:C1470.typeForm()
		
		$error.hide()  // START HIDING ERRORS
		
		For each ($table; $dataModel)
			
			$isSelected:=($table=String:C10($params.tableNumber))
			
			// Create a table group filled according to selected status
			
			If (UI.darkScheme)
				
				$svg.layer($table).fill(Choose:C955($isSelected; $params.selectedFill; "none"))
				
			Else 
				
				$svg.layer($table).fill(Choose:C955($isSelected; $params.selectedFill; "none"))
				
			End if 
			
			If ($svg.with($table))
				
				// Background
				$svg.rect($params.cell.width; $params.cell.height)\
					.position($params.x+0.5; $params.y+0.5)\
					.stroke(Choose:C955($isSelected; $params.selectedStroke; "none"))
				
				// Put the icon [
				If (Form:C1466[$typeForm][$table].form=Null:C1517)
					
					// No form selected
					$icon:=File:C1566("/RESOURCES/templates/form/"+$typeForm+"/defaultLayoutIcon.png")
					$color:=Choose:C955($isSelected; $params.selectedStroke; Choose:C955(UI.darkScheme; "white"; "dimgray"))
					
				Else 
					
					$tmpl:=cs:C1710.tmpl.new(String:C10(Form:C1466[$typeForm][$table].form); $typeForm)
					
					If ($tmpl.sources.exists)
						
						$icon:=$tmpl.sources.file("layoutIconx2.png")
						
						If ($icon.exists)
							
							Case of 
									
									//______________________________________________________
								: (Form:C1466.$android & Not:C34($tmpl.android))
									
									$color:=UI.colors.warningColor.css.hexLong
									$svg.setAttribute("tips"; Replace string:C233(Get localized string:C991("thisModelIsNotApplicableForthisPlatform"); "{platform}"; "Android"); $svg.fetch($table))
									
									//______________________________________________________
								: (Form:C1466.$ios & Not:C34($tmpl.ios))
									
									$color:=UI.colors.warningColor.css.hexLong
									$svg.setAttribute("tips"; Replace string:C233(Get localized string:C991("thisModelIsNotApplicableForthisPlatform"); "{platform}"; "iOS"); $svg.fetch($table))
									
									//________________________________________
								Else 
									
									$color:=Choose:C955($isSelected; $params.selectedStroke; Choose:C955(UI.darkScheme; "white"; "dimgray"))
									
									//______________________________________________________
							End case 
							
						Else 
							
							$icon:=File:C1566("/RESOURCES/images/noIcon.svg")
							$color:=Choose:C955($isSelected; $params.selectedStroke; Choose:C955(UI.darkScheme; "white"; "dimgray"))
							$svg.setAttribute("tips"; Replace string:C233($tmpl.name; "/"; ""); $svg.fetch($table))
							
						End if 
						
					Else 
						
						// Error
						$icon:=File:C1566("/RESOURCES/images/errorIcon.svg")
						
						$color:=UI.errorRGB
						$svg.setAttribute("tips"; Replace string:C233(Get localized string:C991("theModelIsNoLongerAvailable"); "{model}"; $tmpl.name); $svg.fetch($table))
						
					End if 
				End if 
				
				If ($tmpl.sources.extension=SHARED.archiveExtension)  // Archive
					
					$x:=$icon.getContent()
					BLOB TO PICTURE:C682($x; $picture)
					CLEAR VARIABLE:C89($x)
					
					CREATE THUMBNAIL:C679($picture; $picture; $params.icon.width; $params.icon.width)
					$svg.image($picture).position($params.x+18; 5)
					CLEAR VARIABLE:C89($picture)
					
				Else 
					
					$svg.image($icon)\
						.position($params.x+($params.cell.width/2)-($params.icon.width/2); $params.y+5)\
						.size($params.icon.width; $params.icon.width)
					
				End if 
				
				// Avoid too long name
				$name:=$str.setText($dataModel[$table][""].name).truncate($params.maxChar)
				
				$svg.textArea($name)\
					.position($params.x; $params.cell.height-18)\
					.width($params.cell.width)\
					.fill($color)\
					.alignment(Align center:K42:3)\
					.fontStyle(Choose:C955($isSelected; Bold:K14:2; Normal:K14:15))
				
				// Border & reactive 'button'
				If (UI.darkScheme)
					
					$svg.rect(Num:C11($params.cell.width); Num:C11($params.cell.height))\
						.position(Num:C11($params.x)+1; Num:C11($params.y)+1)\
						.stroke(Choose:C955($isSelected; "slategray"; "none"))\
						.fill("white")\
						.fillOpacity(0.01)
					
				Else 
					
					$svg.rect(Num:C11($params.cell.width); Num:C11($params.cell.height))\
						.position(Num:C11($params.x)+1; Num:C11($params.y)+1)\
						.stroke(Choose:C955($isSelected; $params.selectedStroke; "none"))\
						.fill("white")\
						.fillOpacity(0.01)
					
				End if 
				
				If ($name#$dataModel[$table][""].name)  // Set a tips
					
					$svg.setAttribute("tips"; $dataModel[$table][""].name; $svg.fetch($table))
					
				End if 
			End if 
			
			$params.x:=$params.x+$params.cell.width+$params.hOffset
			
		End for each 
		
		$error.show()  // STOP HIDING ERRORS
		
	End if 
	
	If (Feature.with("debug"))
		
		Folder:C1567(fk desktop folder:K87:19).file("DEV/table.svg").setText($svg.getText(True:C214))
		
	End if 
	
	$widget:=$svg.picture()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Return the selected form type as text ("list" | "detail")
Function typeForm()->$formType : Text
	
	$formType:=Choose:C955(Num:C11(Form:C1466.$dialog[Current form name:C1298].selector)=2; "detail"; "list")
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Ensure that there is an entry in "list" and "detail" for each table in the data model
Function createFormObjects($datamodel : Object)
	
	var $tableID : Text
	
	If ($datamodel#Null:C1517)
		
		PROJECT.list:=PROJECT.list=Null:C1517 ? New object:C1471 : PROJECT.list
		PROJECT.detail:=PROJECT.detail=Null:C1517 ? New object:C1471 : PROJECT.detail
		
		// Add mising table if any
		For each ($tableID; $datamodel)
			
			PROJECT.list[$tableID]:=PROJECT.list[$tableID]=Null:C1517 ? New object:C1471 : PROJECT.list[$tableID]
			PROJECT.detail[$tableID]:=PROJECT.detail[$tableID]=Null:C1517 ? New object:C1471 : PROJECT.detail[$tableID]
			
		End for each 
		
		// Delete unpublished table entries
		For each ($tableID; PROJECT.list)
			
			If ($datamodel[$tableID]=Null:C1517)
				
				OB REMOVE:C1226(PROJECT.list; $tableID)
				
			End if 
		End for each 
		
		For each ($tableID; PROJECT.detail)
			
			If ($datamodel[$tableID]=Null:C1517)
				
				OB REMOVE:C1226(PROJECT.detail; $tableID)
				
			End if 
		End for each 
	End if 