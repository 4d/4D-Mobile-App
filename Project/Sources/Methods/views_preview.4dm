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

var $buffer; $class; $container; $currentForm; $domField; $domTemplate; $domUse; $formName; $formType; $IN : Text
var $index; $key; $name; $new; $node; $OUT; $style; $t; $tableID; $tips : Text
var $widgetField : Text
var $first; $found; $isToMany; $isToOne; $multivalued; $stop : Boolean
var $count; $dy; $height; $i; $indx; $width; $y : Integer
var $attributes; $context; $field; $form; $manifest; $o; $relation; $target : Object
var $c : Collection
var $svg : cs:C1710.svg
var $template : cs:C1710.Template

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
		
		$tableID:=$context.tableNum()
		
		If (Num:C11($tableID)>0)
			
			$formType:=$context.typeForm()
			$formName:=String:C10(Form:C1466[$formType][$tableID].form)
			
			If (Length:C16($formName)>0)
				
				$currentForm:=Current form name:C1298
				$template:=Form:C1466.$dialog[$currentForm].template
				
				If (String:C10($template.name)#$formName)
					
					$template:=cs:C1710.tmpl.new($formName; $formType)
					Form:C1466.$dialog[$currentForm].template:=$template
					
				End if 
				
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
							
						Else 
							
							RECORD.error("Failed to parse template \""+$template.name+"\"")
							
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
						$o:=Form:C1466[$formType][$tableID]
						$target:=Choose:C955($o=Null:C1517; Formula:C1597(New object:C1471); Formula:C1597($o)).call()
						
						$form.preview.getCoordinates()
						
						If (Num:C11($manifest.renderer)>=2)
							
							// UPDATE THE SEARCH WIDGET
							If ($target.searchableField#Null:C1517)
								
								If (let(->$node; Formula:C1597($svg.findById("search.label")); Formula:C1597($svg.success)))
									
									If (Value type:C1509($target.searchableField)=Is collection:K8:32)
										
										If ($target.searchableField.length>1)
											
											$svg.setValue(Get localized string:C991("multiCriteriaSearch"); $node)
											
											For each ($o; $target.searchableField) Until ($stop)
												
												$stop:=Not:C34(PROJECT.fieldAvailable($o; $tableID))
												
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
										
										If (Not:C34(PROJECT.fieldAvailable($field; $tableID)))
											
											$svg.addClass("error"; $node)\
												.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($field.name)); $node)
											
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
									
									If (Not:C34(PROJECT.fieldAvailable($target.sectionField; $tableID)))
										
										$svg.addClass("error"; $node)\
											.setAttribute("tips"; cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($target.sectionField.name)); $node)
										
									End if 
								End if 
							End if 
							
							// UPDATE FIELDS
							$count:=Num:C11($manifest.fields.count)
							
							If (FEATURE.with("moreRelations"))
								
								// Mark static fields & refuse 1 to N relation into static field for detail forms
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
										
										$height:=$height+$template.appendOneField($indx; $o; $context; $container; $height)
										
									Else   // Static
										
										$t:=String:C10($indx)
										$class:="label"
										
										// Get the bindind definition
										If (let(->$node; Formula:C1597($svg.findById("f"+$t)); Formula:C1597($svg.success)))
											
											$attributes:=$svg.getAttributes($node)
											
											If ($attributes["ios:type"]#Null:C1517)
												
												If ($template.isTypeAccepted(String:C10($attributes["ios:type"]); $o.fieldType))
													
													If (let(->$node; Formula:C1597($svg.findById("f"+$t+".label")); Formula:C1597($svg.success)))
														
														If ($isToOne | $isToMany)  // Relation
															
															$svg.fontStyle(Italic:K14:3; $node)
															
														End if 
														
														Case of 
																
																//______________________________________________________
															: ($isToOne)
																
																$tips:=PROJECT.dataModel[$tableID][$o.name].label
																$buffer:=cs:C1710.str.new(UI.toOne).concat($o.name)
																
																$relation:=PROJECT.dataModel[$tableID]
																
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
																
																If (PROJECT.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
																	
																	If ($relation[$o.name].format=Null:C1517)
																		
																		$class:="label error"
																		$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theLinkedTableIsNotPublished").localized($relation[$o.name].relatedEntities))
																		
																	End if 
																End if 
															End if 
														End if 
														
														// Set class & tips
														$svg.class($class; $node)\
															.setAttribute("tips"; $tips; $node)
														
														// Remove dotted lines
														$svg.setAttribute("stroke-dasharray"; "none"; $svg.nextSibling($node))
														
														// Show delete button
														$svg.visible(True:C214; $svg.findById("f"+$t+".cancel"))
														
													End if 
													
												Else 
													
													// For a detail form, treat as as a dynamic field ?
													$height:=$height+$template.appendOneField($indx; $o; $context; $container; $height)
													
												End if 
											End if 
										End if 
									End if 
									
								Else 
									
									// <NOTHING MORE TO DO>
									
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
							
							// #OLD RENDERER
							VIEW_RENDERER_v1($svg; $context)
							
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