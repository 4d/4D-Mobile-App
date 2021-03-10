//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_DRAW
// ID[C76CC05CD44641EC92AE0C413664247C]
// Created 5-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(tmpl_DRAW; $1)
End if 

var $background; $binding; $class; $formName; $formType; $key; $label; $name; $node; $parent : Text
var $style; $t; $tableID; $tips : Text
var $found; $isToMany; $isToOne; $stop : Boolean
var $avalaibleWidth; $count; $height; $indx : Integer
var $context; $field; $form; $manifest; $o; $relation; $target : Object
var $nodes : Collection
var $svg : cs:C1710.svg
var $template : cs:C1710.Template

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$form:=$1
	
	$context:=$form.$
	$tableID:=$context.tableNum()
	
End if 

// ----------------------------------------------------
TRY

If (Num:C11($tableID)>0)
	
	$formType:=$context.typeForm()
	$formName:=String:C10(Form:C1466[$formType][$tableID].form)
	
	If (Length:C16($formName)>0)
		
		$template:=Form:C1466.$dialog[Current form name:C1298].template
		
		If (String:C10($template.name)#$formName)
			
			$template:=cs:C1710.tmpl.new($formName; $formType)
			Form:C1466.$dialog[Current form name:C1298].template:=$template
			
		End if 
		
		If ($template.path.exists)
			
			$manifest:=$template.manifest
			
			// Load the template
			
			$t:=$template.update().svg
			$t:=Replace string:C233($t; "&quot;"; "\"")
			PROCESS 4D TAGS:C816($t; $t; $template.title; $template.cancel())
			
			$svg:=cs:C1710.svg.new().parse($t).scale(0.97)
			
			If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
				
				// Define the remove image
				If (let(->$node; Formula:C1597($svg.findById("cancel")); Formula:C1597($svg.success)))
					
					$svg.setAttribute("xlink:href"; $template.cancel(); $svg.firstChild($node; "image"))
					
				End if 
				
				// Update the search widget label & tips, if any
				If (let(->$node; Formula:C1597($svg.findById("search.label")); Formula:C1597($svg.success)))
					
					$svg.setAttribute("ios:tips"; Get localized string:C991("searchBoxTips"); $node)
					$svg.setValue(Get localized string:C991("fieldToUseForSearch"); $node)
					
				End if 
				
				// Update the section widget label & tips, if any
				If (let(->$node; Formula:C1597($svg.findById("section.label")); Formula:C1597($svg.success)))
					
					$svg.setAttribute("ios:tips"; Get localized string:C991("sectionTips"); $node)
					$svg.setValue(Get localized string:C991("fieldToUseAsSection"); $node)
					
				End if 
				
				$svg.success:=True:C214  // Don't forget to put "success" back to true if any
				
			Else 
				
				RECORD.error("Failed to parse template \""+$template.name+"\"")
				
			End if 
			
			cs:C1710.static.new("preview.label")\
				.setTitle(String:C10($template.title))\
				.setColors(Choose:C955((Form:C1466.$android & Not:C34($template.android)) | (Form:C1466.$ios & Not:C34($template.iOS)); "red"; UI.selectedColor))
			
			If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
				
				// Add the style sheet
				$svg.styleSheet($template.css())
				
				// Get the definition or create it
				$o:=Form:C1466[$formType][$tableID]
				$target:=Choose:C955($o=Null:C1517; Formula:C1597(New object:C1471); Formula:C1597($o)).call()
				
				$form.preview.getCoordinates()
				
				If (Num:C11($manifest.renderer)>=2)
					
					// 🔎 UPDATE THE SEARCH WIDGET
					If ($target.searchableField#Null:C1517)
						
						If (let(->$node; Formula:C1597($svg.findById("search.label")); Formula:C1597($svg.success)))
							
							If (Value type:C1509($target.searchableField)=Is collection:K8:32)
								
								If ($target.searchableField.length>1)
									
									$svg.setValue(Get localized string:C991("multiCriteriaSearch"); $node)
									
									For each ($o; $target.searchableField) Until ($stop)
										
										$stop:=Not:C34(PROJECT.fieldAvailable($tableID; $o))
										
										If ($stop)
											
											$svg.addClass("error"; $node)\
												.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("oneOrMoreFieldsAreNoLongerPublished").localized()); $node)
											
										End if 
									End for each 
									
								Else 
									
									$field:=$target.searchableField[0]
									
								End if 
								
							Else 
								
								$field:=$target.searchableField
								
							End if 
							
							If ($field#Null:C1517)
								
								$svg.setValue($field.name; $node)
								
								If (Not:C34(PROJECT.fieldAvailable($tableID; $field)))
									
									$svg.addClass("error"; $node)\
										.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($field.name)); $node)
									
								End if 
							End if 
							
							$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
							$svg.visible(True:C214; $svg.findById("search.cancel"))
							
						End if 
					End if 
					
					// 🗂 UPDATE THE SECTION WIDGET
					If ($target.sectionField#Null:C1517)
						
						If (let(->$node; Formula:C1597($svg.findById("section.label")); Formula:C1597($svg.success)))
							
							$svg.setValue($target.sectionField.name; $node)
							$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
							$svg.visible(True:C214; $svg.findById("section.cancel"))
							
							If (Not:C34(PROJECT.fieldAvailable($tableID; $target.sectionField)))
								
								$svg.addClass("error"; $node)\
									.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($target.sectionField.name)); $node)
								
							End if 
						End if 
					End if 
					
					$height:=Num:C11($manifest.hOffset)
					
					// 🗄 UPDATE FIELDS
					If ($target.fields#Null:C1517)
						
						$count:=Num:C11($manifest.fields.count)
						$background:=$svg.findById("background")
						
						For each ($field; $target.fields)
							
							$indx:=$indx+1
							
							If ($field#Null:C1517)
								
								CLEAR VARIABLE:C89($style)
								CLEAR VARIABLE:C89($class)
								CLEAR VARIABLE:C89($found)
								CLEAR VARIABLE:C89($tips)
								
								$isToOne:=($field.fieldType=8858)
								$isToMany:=($field.fieldType=8859)
								
								If ($indx>$count)
									
									// Dynamic
									$height:=$height+$template.appendOneField($indx; $field; $context; $background; $height)
									
								Else 
									
									// Static
									$t:=String:C10($indx)
									$class:="label"
									
									// Get the bindind definition
									If (let(->$node; Formula:C1597($svg.findById("f"+$t)); Formula:C1597($svg.success)))
										
										$binding:=$template.getBinding($node)
										
										If (Length:C16($binding)>0)
											
											If ($template.isTypeAccepted($binding; $field.fieldType))
												
												If (let(->$node; Formula:C1597($svg.findById("f"+$t+".label")); Formula:C1597($svg.success)))
													
													If ($isToOne | $isToMany)  // Relation
														
														$svg.fontStyle(Italic:K14:3; $node)
														
													End if 
													
													Case of 
															
															//______________________________________________________
														: ($isToOne)
															
															$tips:=PROJECT.dataModel[$tableID][$field.name].label
															$label:=cs:C1710.str.new(UI.toOne).concat($field.name)
															
															$relation:=PROJECT.dataModel[$tableID]
															
															If (Match regex:C1019("(?m-si)^%.*%$"; String:C10($relation[$field.name].format); 1))
																
																$name:=Substring:C12($relation[$field.name].format; 2; Length:C16($relation[$field.name].format)-2)
																$label:=$label+" ("+$name+")"
																
															End if 
															
															If (Length:C16($name)>0)
																
																// Check that the discriminant field is published
																For each ($key; $relation[$field.name]) Until ($found)
																	
																	If (Value type:C1509($relation[$field.name][$key])=Is object:K8:27)
																		
																		$found:=String:C10($relation[$field.name][$key].name)=$name
																		
																	End if 
																End for each 
																
																If (Not:C34($found))
																	
																	$svg.addClass("error"; $node)
																	$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
																	
																End if 
															End if 
															
															//______________________________________________________
														: ($isToMany)  // Only available on list form
															
															$tips:=$field.label
															$label:=cs:C1710.str.new(UI.toMany).concat($field.name)
															
															//______________________________________________________
														Else 
															
															$label:=$field.path
															
															//______________________________________________________
													End case 
													
													// Try to get the width of the container (#121515)
													$avalaibleWidth:=200
													
													$parent:=$svg.parent($node)
													
													If ($svg.getName($parent)="g")
														
														$nodes:=$svg.find($parent; "*[contains(@class,'bg field')]")
														
														Case of 
																
																//______________________________________________________
															: (Not:C34(Bool:C1537(OK)))\
																 | ($nodes.length=0)
																
																// Fails
																
																//______________________________________________________
															: ($svg.getName($nodes[0])="rect")
																
																$avalaibleWidth:=Num:C11($svg.getAttribute($nodes[0]; "width"))-38  // 38 for grip of the cancel button
																
																//______________________________________________________
															: ($svg.getName($nodes[0])="circle")
																
																$avalaibleWidth:=(Num:C11($svg.getAttribute($nodes[0]; "r"))*2)-10  // 10 for margins
																
																//______________________________________________________
															Else 
																
																// Not yet managed
																
																//______________________________________________________
														End case 
														
													Else 
														
														// Unknown structure
														
													End if 
													
													$o:=New object:C1471(\
														"label"; $label; \
														"avalaibleWidth"; $avalaibleWidth)
													
													$template.truncateLabelIfTooBig($o)
													
													$label:=$o.label
													$tips:=$o.tips
													
													$svg.setValue($label; $node)
													
													If ($isToOne | $isToMany)  // Relation
														
														If (Split string:C1554($field.path; ".").length=1)
															
															If (PROJECT.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)  // Error
																
																If ($relation[$field.name].format=Null:C1517)
																	
																	$class:="label error"
																	$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theLinkedTableIsNotPublished").localized($relation[$field.name].relatedEntities))
																	
																End if 
															End if 
														End if 
													End if 
													
													// Set class & tips
													$svg.class($class; $node)\
														.setAttribute("tips"; $tips; $node)
													
													// Remove dotted lines
													$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
													
													// Display delete button
													$svg.visible(True:C214; $svg.findById("f"+$t+".cancel"))
													
												End if 
												
											Else 
												
												// For a detail form, treat as as a dynamic field ?
												$height:=$height+$template.appendOneField($indx; $field; $context; $background; $height)
												
											End if 
										End if 
									End if 
								End if 
								
							Else 
								
								// <NOTHING MORE TO DO>
								
							End if 
							
						End for each 
						
						$height:=$height+40
						
					End if 
					
					If ($context.scrollPosition=Null:C1517)
						
						$context.scroll:=$height
						$context.scrollPosition:=0
						
						If ($height<460)
							
							$height:=443
							$form.scrollBar.hide()
							
						Else 
							
							$form.scrollBar.show()
							
						End if 
						
					Else 
						
						If ($height<450)
							
							$form.preview.setScrollPosition(0)
							$context.scroll:=0
							$context.scrollPosition:=0
							$height:=443
							
							$form.scrollBar.hide()
							
						Else 
							
							If ($context.scroll=Null:C1517)
								
								$context.scrollPosition:=443-$height
								$context.scroll:=443-$height
								$form.preview.setScrollPosition($height)
								
							End if 
							
							$form.scrollBar.show()
							
						End if 
					End if 
					
					OBJECT SET FORMAT:C236(*; "preview.scrollBar"; "443;"+String:C10($height)+";20;1;32;")
					$context.previewHeight:=$height
					
					vThermo:=$context.scroll
					
				Else 
					
					tmpl_RENDERER_v1($svg; $context; $target)  // #OLD RENDERER
					
					$context.previewHeight:=440
					
				End if 
				
				$svg.dimensions($form.preview.coordinates.width; $context.previewHeight)
				
				If (FEATURE.with("_8858"))
					
					$svg.exportText(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.svg"); True:C214)
					$svg.exportPicture(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.png"); True:C214)
					
				End if 
				
				OBJECT SET VALUE:C1742("preview"; $svg.picture())
				
			Else 
				
				$form.form.call("pickerHide")
				
				// Put an error message
				$form.preview.getCoordinates()
				
				OBJECT SET VALUE:C1742("preview"; cs:C1710.svg.new()\
					.dimensions($form.preview.coordinates.width-20; $form.preview.coordinates.height)\
					.textArea(cs:C1710.str.new("theTemplateIsMissingOrInvalid").localized(Replace string:C233($formName; "/"; ""))).dimensions($form.preview.coordinates.width-50)\
					.position(20; 180).font(New object:C1471(\
					"size"; 14; \
					"color"; UI.colors.errorColor.hex; \
					"alignment"; Align center:K42:3)).picture())
				
				OBJECT SET TITLE:C194(*; "preview.label"; "")
				
			End if 
			
		Else 
			
			// Display the template picker
			$form.fieldGroup.hide()
			$form.previewGroup.hide()
			
			views_LAYOUT_PICKER($formType)
			
		End if 
		
	Else 
		
		// Display the template picker
		$form.fieldGroup.hide()
		$form.previewGroup.hide()
		
		views_LAYOUT_PICKER($formType)
		
	End if 
End if 

FINALLY

// ----------------------------------------------------
// Return
//$0:=$OUT

// ----------------------------------------------------
// End