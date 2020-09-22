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

var $buffer; $class; $container; $domField; $domTemplate; $domUse; $formName; $formType; $IN; $name : Text
var $new; $node; $OUT; $root; $style; $t; $index; $widgetField : Text
var $b; $first; $multivalued : Boolean
var $count; $height; $i; $indx; $dy; $width; $y : Integer
var $context; $form; $manifest; $o; $attributes; $widgetManifest; $relation; $svg; $target; $template : Object
var $c : Collection

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
		
		//ASSERT(Not(Shift down))
		
		If (Length:C16($context.tableNum())>0)
			
			// Form name
			$formType:=$context.typeForm()
			$formName:=String:C10(Form:C1466[$formType][$context.tableNum()].form)
			
			If (Length:C16($formName)>0)
				
				If (String:C10(Form:C1466.$dialog.VIEWS.template.name)#$formName)
					
					If (FEATURE.with("newViewUI"))
						
						Form:C1466.$dialog.VIEWS.template:=cs:C1710.tmpl.new($formName; $formType)
						
					Else 
						
						Form:C1466.$dialog._o_VIEWS.template:=cs:C1710.tmpl.new($formName; $formType)
						
					End if 
				End if 
				
				$template:=Form:C1466.$dialog.VIEWS.template
				$manifest:=$template.manifest
				
				If ($template.path.exists)
					
					If (FEATURE.with("newViewUI"))
						
						// Load the template
						$t:=$template.load().template
						$t:=Replace string:C233($t; "&quot;"; "\"")
						PROCESS 4D TAGS:C816($t; $t; $template.title; $template.cancel())
						
						$svg:=svg("parse"; New object:C1471(\
							"variable"; $t)).setAttribute("transform"; \
							"scale(0.97)")
						
						If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
							
							$node:=$svg.findById("cancel")
							
							If ($svg.success)
								
								$node:=DOM Find XML element:C864($node; "image")
								$svg.setAttribute("xlink:href"; $template.cancel(); $node)
								
							End if 
							
							$node:=$svg.findById("search.label")
							
							If ($svg.success)
								
								$svg.setAttribute("ios:tips"; Get localized string:C991("searchBoxTips"); $node)
								DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("fieldToUseForSearch"))
								
							End if 
							
							$node:=$svg.findById("section.label")
							
							If ($svg.success)
								
								$svg.setAttribute("ios:tips"; Get localized string:C991("sectionTips"); $node)
								DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("fieldToUseAsSection"))
								
							End if 
							
							$svg.success:=True:C214
							
						End if 
						
					Else 
						
						// Load the template
						PROCESS 4D TAGS:C816($template.template; $t)
						
						$svg:=svg("parse"; New object:C1471(\
							"variable"; $t)).setAttribute("transform"; \
							"scale(0.95)")
						
					End if 
					
					OBJECT SET TITLE:C194(*; "preview.label"; String:C10($template.title))
					
					If (Asserted:C1132($svg.success; "Failed to parse template \""+$t+"\""))
						
						// Add the style sheet
						$svg.styleSheet($template.css())
						
						$target:=Choose:C955(Form:C1466[$formType][$context.tableNumber]=Null:C1517; New object:C1471; Form:C1466[$formType][$context.tableNumber])
						
						$form.preview.getCoordinates()
						
						If (Num:C11($manifest.renderer)>=2)
							
							If ($target.searchableField#Null:C1517)
								
								$node:=$svg.findById("search.label")
								
								If ($svg.success)
									
									If (Value type:C1509($target.searchableField)=Is collection:K8:32)
										
										If ($target.searchableField.length>1)
											
											DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("multiCriteriaSearch"))
											
										Else 
											
											DOM SET XML ELEMENT VALUE:C868($node; $target.searchableField[0].name)
											
										End if 
										
									Else 
										
										DOM SET XML ELEMENT VALUE:C868($node; $target.searchableField.name)
										
									End if 
									
									$node:=DOM Get next sibling XML element:C724($node)
									$svg.setAttribute("stroke-dasharray"; "none"; $node)
									$svg.setVisible(True:C214; $svg.findById("search.cancel"))
									
								End if 
							End if 
							
							If ($target.sectionField#Null:C1517)
								
								$node:=$svg.findById("section.label")
								
								If ($svg.success)
									
									DOM SET XML ELEMENT VALUE:C868($node; $target.sectionField.name)
									
									$node:=DOM Get next sibling XML element:C724($node)
									$svg.setAttribute("stroke-dasharray"; "none"; $node)
									$svg.setVisible(True:C214; $svg.findById("section.cancel"))
									
								End if 
							End if 
							
							$container:=$svg.findById("background")
							
							$height:=Num:C11($manifest.hOffset)
							
							$widgetManifest:=JSON Parse:C1218(File:C1566("/RESOURCES/templates/form/objects/oneField/manifest.json").getText())
							$widgetField:=File:C1566("/RESOURCES/templates/form/objects/oneField/widget.svg").getText()
							
							$count:=Num:C11($manifest.fields.count)
							
							For each ($o; $target.fields)
								
								$indx:=$indx+1
								
								If ($o#Null:C1517)
									//#117298 - [BUG] Missing relation italic style
									CLEAR VARIABLE:C89($style)
									CLEAR VARIABLE:C89($class)
									
									If ($indx>$count)  // Dynamic
										
										If ($o.fieldType=8858)\
											 | ($o.fieldType=8859)  // Relation
											
											$style:="italic"
											
											If ($o.fieldType=8858)  // Relation
												
												$relation:=Form:C1466.dataModel[$context.tableNumber]
												
												If ($relation[$o.name].format=Null:C1517)
													
													$class:=" error"
													
												End if 
												
											Else 
												
												If (Split string:C1554($o.path; ".").length=1)
													
													If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
														
														$class:=" error"
														
													End if 
													
												Else 
													
													//DOM SET XML ATTRIBUTE($node; \
																																																																																				"tips"; $o.label)
													
												End if 
											End if 
										End if 
										
										If ($o.fieldType=8858)
											
											$relation:=Form:C1466.dataModel[$context.tableNumber]
											
											If ($relation[$o.name].format#Null:C1517)
												
												$c:=Split string:C1554($relation[$o.name].format; "%"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
												$buffer:=$o.name+" ("+$c[0]+")"
												
											Else 
												
												$buffer:=$o.name
												
											End if 
											
										Else 
											
											$buffer:=$o.name
											
										End if 
										
										// Set ids, label & position
										PROCESS 4D TAGS:C816($widgetField; $t; New object:C1471(\
											"index"; $indx; \
											"name"; $buffer; \
											"offset"; 5+$height; \
											"style"; $style; \
											"class"; $class))
										
										$root:=DOM Parse XML variable:C720($t)
										
										If (Bool:C1537(OK))
											
											$node:=DOM Find XML element:C864($root; "/svg/g")
											
											If (Bool:C1537(OK))
												
												$node:=DOM Append XML element:C1082($container; $node)
												$height:=$height+Num:C11($widgetManifest.height)
												
											End if 
											
											DOM CLOSE XML:C722($root)
											
										End if 
										
									Else   // Static
										
										$t:=String:C10($indx)
										
										// Get the bindind definition
										$node:=$svg.findById("f"+$t)
										
										If ($svg.success)
											
											$attributes:=xml_attributes($node)
											
											// Get the bindind definition
											If ($attributes["ios:type"]#Null:C1517)
												
												$b:=($attributes["ios:type"]="all")
												
												If (Not:C34($b))
													
													$b:=tmpl_compatibleType($attributes["ios:type"]; $o.fieldType)
													
												End if 
												
												If ($b)
													
													$node:=$svg.findById("f"+$t+".label")
													
													If ($svg.success)
														
														If ($o.fieldType=8858)
															
															$relation:=Form:C1466.dataModel[$context.tableNumber]
															
															If ($relation[$o.name].format#Null:C1517)
																
																$c:=Split string:C1554($relation[$o.name].format; "%"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
																$buffer:=$o.name+" ("+$c[0]+")"
																
															Else 
																
																$buffer:=$o.name
																
															End if 
															
														Else 
															
															$buffer:=$o.name
															
														End if 
														
														DOM SET XML ELEMENT VALUE:C868($node; $buffer)
														
														If ($o.fieldType=8858)\
															 | ($o.fieldType=8859)  // Relation
															
															DOM SET XML ATTRIBUTE:C866($node; \
																"font-style"; "italic")
															
															If (Split string:C1554($o.path; ".").length=1)
																
																If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
																	
																	If ($relation[$o.name].format=Null:C1517)
																		
																		DOM SET XML ATTRIBUTE:C866($node; \
																			"class"; "label error")
																		
																	End if 
																End if 
																
															Else 
																
																DOM SET XML ATTRIBUTE:C866($node; \
																	"class"; "label")
																
																DOM SET XML ATTRIBUTE:C866($node; \
																	"tips"; $o.label)
																
															End if 
														End if 
														
														//#117302 - [BUG] Fixed dropped field style
														$node:=DOM Get next sibling XML element:C724($node)
														$svg.setAttribute("stroke-dasharray"; "none"; $node)
														$svg.setVisible(True:C214; $svg.findById("f"+$t+".cancel"))
														
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
							
							//ASSERT(Not(Shift down))
							
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
													
													DOM SET XML ELEMENT VALUE:C868($node; Get localized string:C991("dropAFieldHere"))
													
												End if 
											End if 
											
											// Get position
											$node:=DOM Get parent XML element:C923($t)
											
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
												
												$svg.setVisible(True:C214; $node)
												
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
												$svg.setVisible(True:C214; $tDom_{$i})
												
											Else 
												
												// Hide the other ones
												$svg.setVisible(False:C215; $tDom_{$i})
												
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
											
											$svg.setVisible(Num:C11($context.tabIndex)=$indx; $node)
											
										End if 
										
										$indx:=$indx+1
										
									Until (OK=0)
								End if 
							End if 
							
							$context.previewHeight:=440
							
						End if 
						
						If (FEATURE.with("newViewUI"))
							
							$svg.setDimensions($form.preview.coordinates.width; $context.previewHeight)
							
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
						
						OBJECT SET VALUE:C1742("preview"; svg.setDimensions($form.preview.coordinates.width-20; $form.preview.coordinates.height)\
							.textArea(str("theTemplateIsMissingOrInvalid").localized($template.title); 20; 180)\
							.setDimensions($form.preview.coordinates.width-20)\
							.setFill(UI.colors.errorColor.hex)\
							.setAttributes(New object:C1471("font-size"; 14; "text-align"; "center"))\
							.textArea(str("theTemplateIsMissingOrInvalid").localized(Replace string:C233($formName; "/"; "")); 20; 180))
						
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