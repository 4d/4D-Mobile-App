//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : views_preview
// ID[C76CC05CD44641EC92AE0C413664247C]
// Created 5-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Text
var $1 : Text
var $2 : Object

If (False:C215)
	C_TEXT:C284(views_preview; $0)
	C_TEXT:C284(views_preview; $1)
	C_OBJECT:C1216(views_preview; $2)
End if 

var $buffer; $class; $container; $dialog; $domField; $domTemplate; $domUse; $formName; $formType; $IN : Text
var $index; $key; $name; $new; $node; $OUT; $searchableFieldName; $style; $t; $tips : Text
var $widgetField : Text
var $b; $first; $found; $isToMany; $isToOne; $multivalued : Boolean
var $count; $dy; $height; $i; $id; $indx; $width; $y : Integer
var $attributes; $context; $form; $manifest; $o; $relation; $target; $widgetManifest : Object
var $c : Collection
var $svg : cs:C1710.svg
var $template : cs:C1710.Template
var $xml : cs:C1710.xml

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
	If (Count parameters:C259>=2)
		
		$form:=$2
		
	End if 
End if 

$context:=$form.$

TRY

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($IN="draw")  // Uppdate preview
		
		If (Length:C16($context.tableNum())>0)
			
			// Form name
			$formType:=$context.typeForm()
			$formName:=String:C10(Form:C1466[$formType][$context.tableNum()].form)
			
			If (Length:C16($formName)>0)
				
				$dialog:=Choose:C955(FEATURE.with("newViewUI"); "VIEWS"; "_o_VIEWS")
				
				If (String:C10(Form:C1466.$dialog[$dialog].template.name)#$formName)
					
					Form:C1466.$dialog[$dialog].template:=cs:C1710.tmpl.new($formName; $formType)
					
				End if 
				
				$template:=Form:C1466.$dialog[$dialog].template
				
				If ($template.path.exists)
					
					$manifest:=$template.manifest
					
					// Load the template
					If (FEATURE.with("newViewUI"))
						
						$t:=$template.load().template
						$t:=Replace string:C233($t; "&quot;"; "\"")
						PROCESS 4D TAGS:C816($t; $t; $template.title; $template.cancel())
						$svg:=cs:C1710.svg.new().parse($t).setAttribute("transform"; "scale(0.97)")
						
						If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
							
							// Define the deletion image
							If (let(->$node; Formula:C1597($svg.findById("cancel")); Formula:C1597($svg.success)))
								
								$svg.setAttribute("xlink:href"; $template.cancel(); DOM Find XML element:C864($node; "image"))
								
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
							
						End if 
						
					Else 
						
						PROCESS 4D TAGS:C816($template.template; $t)
						$svg:=cs:C1710.svg.new().parse($t).setAttribute("transform"; "scale(0.95)")
						
					End if 
					
					OBJECT SET TITLE:C194(*; "preview.label"; String:C10($template.title))
					
					If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
						
						// Add the style sheet
						$svg.styleSheet($template.css())
						
						// Get the definition or create it
						$target:=Choose:C955(Form:C1466[$formType][$context.tableNumber]=Null:C1517; Formula:C1597(New object:C1471); Formula:C1597(Form:C1466[$formType][$context.tableNumber])).call()
						
						$form.preview.getCoordinates()
						
						If (Num:C11($manifest.renderer)>=2)
							
							// UPDATE THE SEARCH WIDGET
							If ($target.searchableField#Null:C1517)
								
								If (let(->$node; Formula:C1597($svg.findById("search.label")); Formula:C1597($svg.success)))
									
									If (Value type:C1509($target.searchableField)=Is collection:K8:32)
										
										If ($target.searchableField.length>1)
											
											$svg.setValue(Get localized string:C991("multiCriteriaSearch"); $node)
											
											For each ($o; $target.searchableField)
												
												If (Form:C1466.dataModel[$context.tableNumber][String:C10($o.id)]=Null:C1517)
													
													$svg.addClass("error"; $node)\
														.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("oneOrMoreFieldsAreNoLongerPublished").localized()); $node)
													
												End if 
											End for each 
											
										Else 
											
											$searchableFieldName:=$target.searchableField[0].name
											$id:=$target.searchableField[0].id
											
										End if 
										
									Else 
										
										$searchableFieldName:=$target.searchableField.name
										$id:=$target.searchableField.id
										
									End if 
									
									If (Length:C16($searchableFieldName)>0)
										
										$svg.setValue($searchableFieldName; $node)
										
										If (Form:C1466.dataModel[$context.tableNumber][String:C10($id)]=Null:C1517)
											
											$svg.addClass("error"; $node)\
												.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($searchableFieldName)); $node)
											
										End if 
									End if 
									
									$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
									$svg.visible(True:C214; $svg.findById("search.cancel"))
									
								End if 
							End if 
							
							// UPDATE THE SECTION WIDGET
							If ($target.sectionField#Null:C1517)
								
								If (let(->$node; Formula:C1597($svg.findById("section.label")); Formula:C1597($svg.success)))
									
									$svg.setValue($target.sectionField.name; $node)
									$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
									$svg.visible(True:C214; $svg.findById("section.cancel"))
									
									If (Form:C1466.dataModel[$context.tableNumber][String:C10($target.sectionField.id)]=Null:C1517)
										
										$svg.addClass("error"; $node)\
											.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($target.sectionField.name)); $node)
										
									End if 
								End if 
							End if 
							
							// UPDATE FIELDS
							$widgetManifest:=JSON Parse:C1218(File:C1566("/RESOURCES/templates/form/objects/oneField/manifest.json").getText())
							$widgetField:=File:C1566("/RESOURCES/templates/form/objects/oneField/widget.svg").getText()
							
							$count:=Num:C11($manifest.fields.count)
							
							// Mark static fields & refuse 1 to N relation into static field for detail forms
							If (FEATURE.with("moreRelations"))
								
								For ($i; 1; $count; 1)
									
									If (let(->$node; Formula:C1597($svg.findById("f"+String:C10($i))); Formula:C1597($svg.success)))
										
										$svg.addClass("static"; $node)
										
										If ($formType="detail")
											
											$attributes:=$svg.getAttributes($node)
											
											If ($attributes["ios:type"]#Null:C1517)
												
												If (String:C10($attributes["ios:type"])="all")
													
													$svg.setAttribute("ios:type"; "-8859"; $node)
													
												Else 
													
													$c:=Split string:C1554(String:C10($attributes["ios:type"]); ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
													
													If ($c.every("col_formula"; Formula:C1597($1.result:=($1.value<0))))
														
														$c.push(-8859)
														$svg.setAttribute("ios:type"; $c.join(","); $node)
														
													Else 
														
														// <NOTHING MORE TO DO>
														
													End if 
												End if 
												
											Else 
												
												$svg.setAttribute("ios:type"; "-8859"; $node)
												
											End if 
										End if 
									End if 
								End for 
							End if 
							
							$container:=$svg.findById("background")
							$height:=Num:C11($manifest.hOffset)
							
							For each ($o; $target.fields)
								
								$indx:=$indx+1
								
								If ($o#Null:C1517)
									
									CLEAR VARIABLE:C89($style)
									CLEAR VARIABLE:C89($class)
									CLEAR VARIABLE:C89($found)
									CLEAR VARIABLE:C89($tips)
									
									$isToOne:=($o.fieldType=8858)
									$isToMany:=($o.fieldType=8859)
									
									If ($indx>$count)  // Dynamic
										
										If ($isToOne | $isToMany)  // Relation
											
											$style:="italic"
											
										End if 
										
										Case of 
												
												//______________________________________________________
											: ($isToOne)
												
												$tips:=Form:C1466.dataModel[$context.tableNum()][$o.name].label
												
												$relation:=Form:C1466.dataModel[$context.tableNumber]
												
												If ($relation[$o.name].format=Null:C1517)
													
													$buffer:=$o.name
													
												Else 
													
													If (Match regex:C1019("(?m-si)^%.*%$"; String:C10($relation[$o.name].format); 1))
														
														$name:=Substring:C12($relation[$o.name].format; 2; Length:C16($relation[$o.name].format)-2)
														$buffer:=$o.name+" ("+$name+")"
														
													End if 
													
													// Check that the discriminant field is published
													For each ($key; $relation[$o.name]) Until ($found)
														
														If (Value type:C1509($relation[$o.name][$key])=Is object:K8:27)
															
															$found:=String:C10($relation[$o.name][$key].name)=$name
															
														End if 
													End for each 
													
													If (Not:C34($found))
														
														$class:="error"
														$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
														
													End if 
												End if 
												
												$buffer:=cs:C1710.str.new(UI.toOne).concat($buffer)
												
												//______________________________________________________
											: ($isToMany)
												
												$tips:=$o.label
												$buffer:=cs:C1710.str.new(UI.toMany).concat($o.name)
												
												//______________________________________________________
											Else 
												
												$buffer:=$o.name
												
												//______________________________________________________
										End case 
										
										// Set ids, label & position
										PROCESS 4D TAGS:C816($widgetField; $t; New object:C1471(\
											"index"; $indx; \
											"name"; cs:C1710.str.new($buffer).xmlSafe(); \
											"offset"; 5+$height; \
											"style"; $style; \
											"class"; $class; \
											"tips"; cs:C1710.str.new($tips).xmlSafe()))
										
										// Append the widget
										$xml:=cs:C1710.xml.new($t)
										
										If (let(->$node; Formula:C1597($xml.findByXPath("/svg/g")); Formula:C1597($xml.success)))
											
											$node:=DOM Append XML element:C1082($container; $node)
											$height:=$height+Num:C11($widgetManifest.height)
											
										End if 
										
										$xml.close()
										
									Else   // Static
										
										$t:=String:C10($indx)
										$class:="label"
										
										// Get the bindind definition
										If (let(->$node; Formula:C1597($svg.findById("f"+$t)); Formula:C1597($svg.success)))
											
											$attributes:=$svg.getAttributes($node)
											
											If ($attributes["ios:type"]#Null:C1517)
												
												$b:=(String:C10($attributes["ios:type"])="all")
												
												If (Not:C34($b))
													
													$b:=tmpl_compatibleType(String:C10($attributes["ios:type"]); $o.fieldType)
													
												End if 
												
												If ($b)
													
													If (let(->$node; Formula:C1597($svg.findById("f"+$t+".label")); Formula:C1597($svg.success)))
														
														If ($isToOne | $isToMany)  // Relation
															
															$svg.fontStyle(Italic:K14:3; $node)
															
														End if 
														
														Case of 
																
																//______________________________________________________
															: ($isToOne)
																
																$tips:=Form:C1466.dataModel[$context.tableNum()][$o.name].label
																$buffer:=cs:C1710.str.new(UI.toOne).concat($o.name)
																
																$relation:=Form:C1466.dataModel[$context.tableNumber]
																
																If (Match regex:C1019("(?m-si)^%.*%$"; String:C10($relation[$o.name].format); 1))
																	
																	$name:=Substring:C12($relation[$o.name].format; 2; Length:C16($relation[$o.name].format)-2)
																	$buffer:=$buffer+" ("+$name+")"
																	
																End if 
																
																If (Length:C16($name)>0)
																	
																	// Check that the discriminant field is published
																	For each ($key; $relation[$o.name]) Until ($found)
																		
																		If (Value type:C1509($relation[$o.name][$key])=Is object:K8:27)
																			
																			$found:=String:C10($relation[$o.name][$key].name)=$name
																			
																		End if 
																	End for each 
																	
																	If (Not:C34($found))
																		
																		$svg.addClass("error"; $node)
																		$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
																		
																	End if 
																End if 
																
																//______________________________________________________
															: ($isToMany)  // Only available on list form
																
																$tips:=$o.label
																$buffer:=cs:C1710.str.new(UI.toMany).concat($o.name)
																
																//______________________________________________________
															Else 
																
																$buffer:=$o.name
																
																//______________________________________________________
														End case 
														
														$svg.setValue($buffer; $node)
														
														If ($isToOne | $isToMany)  // Relation
															
															If (Split string:C1554($o.path; ".").length=1)
																
																If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
																	
																	If ($relation[$o.name].format=Null:C1517)
																		
																		$class:="label error"
																		$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theLinkedTableIsNotPublished").localized($relation[$o.name].relatedEntities))
																		
																	End if 
																End if 
															End if 
														End if 
														
														$svg.class($class; $node)\
															.setAttribute("tips"; $tips; $node)
														
														$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
														
														$svg.visible(True:C214; $svg.findById("f"+$t+".cancel"))
														
													Else 
														
														// ERROR
														
													End if 
												End if 
												
											Else 
												
												// ERROR
												
											End if 
											
										Else 
											
											// ERROR
											
										End if 
									End if 
								End if 
							End for each 
							
							$height:=$height+40
							
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
							
							// Update values if any
							$t:=$svg.findById("cookery")
							
							If (Asserted:C1132($svg.success; "Missing cookery element"))
								
								$o:=xml_attributes($t)
								
								// Get the bindind definition
								If (Asserted:C1132($o["ios:values"]#Null:C1517))
									
									$c:=Split string:C1554(String:C10($o["ios:values"]); ","; sk trim spaces:K86:2)
									
								End if 
								
								// Get the template for multivalued fields reference, if exist
								$domTemplate:=$svg.findById("f")
								$multivalued:=($svg.success)
								
								If ($multivalued)
									
									// Get the main group reference
									$container:=$svg.findById("multivalued")
									
									// Get the vertical offset
									$o:=xml_attributes($domTemplate)
									
									If ($o["ios:dy"]#Null:C1517)
										
										$dy:=Num:C11($o["ios:dy"])
										DOM REMOVE XML ATTRIBUTE:C1084($domTemplate; "ios:dy")
										
									End if 
									
									For each ($widgetField; $c)
										
										$t:=$svg.findById($widgetField)
										
										If ($svg.success)
											
											If (FEATURE.with("newViewUI"))
												
												$node:=$svg.findById($widgetField+".label")
												
												If ($svg.success)
													
													$svg.setValue(Get localized string:C991("dropAFieldHere"); $node)
													
												End if 
											End if 
											
											// Get position
											$node:=$svg.parent($t)
											
											If (Asserted:C1132(OK=1))
												
												DOM GET XML ATTRIBUTE BY NAME:C728($node; "transform"; $t)
												$y:=Num:C11(Replace string:C233($t; "translate(0,"; ""))
												
											End if 
											
										Else 
											
											// Create an object from the template
											$y:=$y+$dy
											$index:=String:C10(Num:C11($widgetField))
											
											$domUse:=DOM Create XML Ref:C861("root")
											
											If (Asserted:C1132(OK=1))
												
												$new:=DOM Append XML element:C1082($domUse; $domTemplate)
												
												// Remove id
												DOM REMOVE XML ATTRIBUTE:C1084($new; "id")
												
												// Set position
												DOM SET XML ATTRIBUTE:C866($new; \
													"transform"; "translate(0,"+String:C10($y)+")")
												
												// Set label
												$node:=DOM Find XML element by ID:C1010($new; "f.label")
												DOM SET XML ATTRIBUTE:C866($node; \
													"id"; $widgetField+".label")
												
												If (FEATURE.with("newViewUI"))
													
													DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("dropAFieldHere"))
													
												Else 
													
													DOM GET XML ELEMENT VALUE:C731($node; $t)
													DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991($t)+$index)
													
												End if 
												
												// Set id, bind & default label
												$node:=DOM Find XML element by ID:C1010($new; "f")
												
												DOM SET XML ATTRIBUTE:C866($node; \
													"id"; $widgetField; \
													"ios:bind"; "fields["+String:C10(Num:C11($widgetField)-1)+"]"; \
													"ios:label"; Get localized string:C991("field[n]")+" "+$index)
												
												// Set cancel id
												$node:=DOM Find XML element by ID:C1010($new; "f.cancel")
												DOM SET XML ATTRIBUTE:C866($node; \
													"id"; $widgetField+".cancel")
												
												// Append object to the preview
												$new:=DOM Append XML element:C1082($container; $new)
												
												DOM CLOSE XML:C722($domUse)
												
											End if 
										End if 
									End for each 
								End if 
								
								// Valorize the fields
								For each ($t; $c)
									
									CLEAR VARIABLE:C89($name)
									
									// Find the binded element
									$domField:=$svg.findById($t)
									
									// Get the field bind
									$o:=xml_attributes($domField)
									
									If (Asserted:C1132($o["ios:bind"]#Null:C1517))
										
										If (Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $o["ios:bind"])=-1)
											
											// Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
											If ($target[$o["ios:bind"]]#Null:C1517)
												
												If (Value type:C1509($target[$o["ios:bind"]])=Is collection:K8:32)
													
													If ($target[$o["ios:bind"]].length=1)
														
														$name:=$target[$o["ios:bind"]][0].name
														
													Else 
														
														// Multi-criteria Search
														$name:=Get localized string:C991("multiCriteriaSearch")
														
													End if 
													
												Else 
													
													$name:=String:C10($target[$o["ios:bind"]].name)
													
												End if 
											End if 
											
											$indx:=$indx-1
											
										Else 
											
											If ($indx<$target.fields.length)
												
												$o:=$target.fields[$indx]
												
												If ($o#Null:C1517)
													
													// Keep the field  description for the needs of UI
													$svg.setAttribute("ios:data"; JSON Stringify:C1217($o); $domField)
													
													$name:=$o.name
													
													If (Num:C11($o.fieldType)=8859)  // 1-N relation
														
														$node:=$svg.findById($t+".label")
														$svg.setAttribute("font-style"; "italic"; $node)
														
														If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
															
															$svg.setAttribute("class"; String:C10(xml_attributes($node).class)+" error"; $node)
															
														End if 
													End if 
													
													// Keep the nex available index
													$context.lastMultivaluedField:=$indx+1
													
												End if 
											End if 
										End if 
									End if 
									
									If (Length:C16($name)>0)
										
										If (Asserted:C1132(OK=1))
											
											$svg.setAttribute("stroke-dasharray"; "none"; $domField)
											
											If ($multivalued)
												
												// Make it visible & mark as affected
												$svg.setAttributes(New object:C1471("target"; DOM Get parent XML element:C923($domField); \
													"visibility"; "visible"; \
													"class"; "affected"))
												
											End if 
											
											$node:=$svg.findById($t+".label")
											
											If (Asserted:C1132($svg.success))
												
												// Truncate & set tips if necessary
												$width:=Num:C11(xml_attributes($node).width)
												
												If ($width>0)
													
													$width:=$width/10
													
													If (Length:C16($name)>($width))
														
														$svg.setAttribute("tips"; $name; $node)
														$name:=Substring:C12($name; 1; $width)+"…"
														
													End if 
												End if 
												
												DOM SET XML ELEMENT VALUE:C868($node; $name)
												
											End if 
											
											$node:=$svg.findById($t+".cancel")
											
											If ($svg.success)
												
												$svg.visible(True:C214; $node)
												
											End if 
										End if 
									End if 
									
									$indx:=$indx+1
									
								End for each 
								
								If ($multivalued)
									
									// Hide unassigned multivalued fields (except the first)
									ARRAY TEXT:C222($tDom_; 0x0000)
									$tDom_{0}:=DOM Find XML element:C864($container; "g"; $tDom_)
									
									For ($i; 1; Size of array:C274($tDom_); 1)
										
										If (String:C10(xml_attributes($tDom_{$i}).class)="")  // Not affected
											
											If (Not:C34($first))
												
												// We have found the first non affected field
												$first:=True:C214
												
												// Make it visible to allow drag and drop
												$svg.visible(True:C214; $tDom_{$i})
												
											Else 
												
												// Hide the other ones
												$svg.visible(False:C215; $tDom_{$i})
												
											End if 
										End if 
									End for 
								End if 
								
								// Tabs
								$t:=$svg.findById("tabs")
								
								If ($svg.success)
									
									CLEAR VARIABLE:C89($indx)
									
									Repeat 
										
										$node:=$svg.findById("tab-"+String:C10($indx))
										
										If ($svg.success)
											
											$svg.visible(Num:C11($context.tabIndex)=$indx; $node)
											
										End if 
										
										$indx:=$indx+1
										
									Until (OK=0)
								End if 
							End if 
							
							$context.previewHeight:=440
							
						End if 
						
						If (FEATURE.with("newViewUI"))
							
							$svg.dimensions($form.preview.coordinates.width; $context.previewHeight)
							
						End if 
						
						If (FEATURE.with("_8858"))
							
							$svg.saveText(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.svg"); True:C214)
							$svg.savePicture(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.png"); True:C214)
							
						End if 
						
						OBJECT SET VALUE:C1742("preview"; $svg.getPicture())
						
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
							"alignment"; Align center:K42:3)).getPicture())
						
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
		
		//________________________________________
	: ($IN="cancel")  // Return cancel button as Base64 data
		
		//READ PICTURE FILE(Get 4D folder(Current resources folder)+Convert path POSIX to system("images/Buttons/LightGrey/Cancel.png");$Pic_cancel)
		//TRANSFORM PICTURE($Pic_cancel;Crop;1;1;48;48)
		//CREATE THUMBNAIL($Pic_cancel;$Pic_cancel;30;30)
		//PICTURE TO BLOB($Pic_cancel;$Blb_;".png")
		//BASE64 ENCODE($Blb_;$Txt_out)
		//$Txt_out:="data:;base64,"+$Txt_out
		
		$OUT:="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAAAXNSR0IArs4c6QAAAuJJREFUSA3tlEtoU1EQhptHI4lp8FUMlIIPpH"+\
			"ZRixTdFYIIUrCBkJTQlCpEjFJw4UYRFaObVnEjWbhQqRgLtiG6koAiIiiKG0UkiRXrShHbQtNiJEnT+E3hykFyb+LGheTAMOf8Z2b+mblzT1NTYzU68L91wPS3Bfn9/l1ms7nf"+\
			"ZDLtxHcN8oX9E5vN9jQej/+oN17dxAMDAx0Qnl9ZWfESfBr5ipSQDRB3oOeR6NTUVBJdc9VFDOk+gscrlcoMEc9R3ZuJiYlFie7xeKytra1bSOoIxxFsriNnE4lEWe71Vk1"+\
			"iqRTnZ0gCOUXAn3rBAoHAQRK8y/0YdmN6doJbjC6lGqfTeY1gQnaIYAUj+3Q6Pd3V1TVHxRc6OzsfZjKZWT17s96F4LSwmyD95XL5DKRFwaLRqHl4eHit7GXREVtfX58M2ep"+\
			"iBu6Q6LTFYoloWDVtSEyAfpyy+Xz+reaczWbbCoXCA6b7QCgUWg9+z+VyhbR7SZBkE0hvOBxu0fA/tSExzrtxyKRSqd8tzuVy38HeMUy3lpeXH2PTjn6uBqbqF5y3Li0tuVRc3d"+\
			"cidlF1XnWQJEql0hUwk9Vq7UHHksnkR9WGqc9xtvOJrCqu7g2JqWqWitapDkNDQy4Ib4PPkUCcxC4zzb2qDbib86LD4VidC/VO2xsSE1Ra1s0AOTWHYrHoAJ+BOMhjcRh9g/Mm7V"+\
			"405/2oD8zCgoqre8P/mAHaRtWvCXSs3hfJ5/NtpCMv8RnHZ1QlU/eGFfPtpLKbyOjg4OBm1VFvz/c9zZ0Nn3E9G8ENicWAB0ReoAUm9z4d2CFYtRWJRJr5JBeZ6BGqPcFv9a2anYY"+\
			"ZtlozCgaD26lAnsJ2Al8l8CO32/0pFosVIZNO7OWTHEfvwe4kLRZbw1UXsUTwer0tdrv9KMRCYEMqgpPEqkD4iv2lycnJjOC1Vt3EWiBJgO/Yw5PYRhLNkM1D+p7WftZsGrrRgUYH/"+\
			"mkHfgG6PCOSHCtXRwAAAABJRU5ErkJggg=="
		
		//______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN+"\"")
		
		//______________________________________________________
End case 

FINALLY

// ----------------------------------------------------
// Return
$0:=$OUT

// ----------------------------------------------------
// End