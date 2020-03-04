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
C_TEXT:C284($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($bFirst;$bMultivalued)
C_LONGINT:C283($i;$indx;$Lon_y;$Lon_yOffset;$width)
C_TEXT:C284($dom;$domField;$domMultivalued;$domNew;$domTemplate;$domUse)
C_TEXT:C284($t;$tField;$tFormName;$tIN;$tIndex;$tName)
C_TEXT:C284($tOUT;$tTypeForm)
C_OBJECT:C1216($archive;$context;$form;$o;$oManifest;$oTarget)
C_OBJECT:C1216($pathForm;$svg)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(views_preview ;$0)
	C_TEXT:C284(views_preview ;$1)
	C_OBJECT:C1216(views_preview ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations

  // NO PARAMETERS REQUIRED

  // Optional parameters
If (Count parameters:C259>=1)
	
	$tIN:=$1
	
	If (Count parameters:C259>=2)
		
		$form:=$2
		
	End if 
End if 

$context:=$form.$

TRY 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($tIN="draw")  // Uppdate preview
		
		$tTypeForm:=$context.typeForm()
		
		If (Length:C16($context.tableNum())>0)
			
			  // Form name
			$tFormName:=String:C10(Form:C1466[$tTypeForm][$context.tableNum()].form)
			$tFormName:=$tFormName*Num:C11($tFormName#"null")  // Reject null value
			
			If (Length:C16($tFormName)>0)
				
				$pathForm:=tmpl_form ($tFormName;$tTypeForm)
				
				If ($pathForm.exists)
					
					If (feature.with("resourcesBrowser"))
						
						If ($pathForm.extension=SHARED.archiveExtension)  // Archive
							
							$archive:=ZIP Read archive:C1637(path ["host"+$tTypeForm+"Forms"]().file(Delete string:C232($tFormName;1;1)))
							$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
							OBJECT SET TITLE:C194(*;"preview.label";String:C10($o.name))
							
						Else 
							
							OBJECT SET TITLE:C194(*;"preview.label";String:C10($pathForm.fullName))
							
						End if 
						
					Else 
						
						OBJECT SET TITLE:C194(*;"preview.label";String:C10($pathForm.fullName))
						
					End if 
					
					  //If ($pathForm.exists)
					
					  // Load the template
					PROCESS 4D TAGS:C816($pathForm.file("template.svg").getText();$t)
					
					If (feature.with("newViewUI"))
						
						If (Num:C11($oManifest.version)<2)  // COMPATIBILITY MODE
							
							  // Remove mobile picture
							$t:=Replace string:C233($t;"<rect class=\"container\"/>";"")
							
							If ($tTypeForm="detail")
								
								  // Make background droppable
								$t:=Replace string:C233($t;"<rect class=\"bgcontainer\"/>";"<rect id=\"background\" class=\"bgcontainer_v2 droppable\" ios:type=\"all\"/>")
								
							Else 
								
								$t:=Replace string:C233($t;"<rect class=\"bgcontainer\"/>";"<rect class=\"bgcontainer_v2\"/>")
								
							End if 
							
							  // Adjustments
							$t:=Replace string:C233($t;"<g id=\"bgcontainer\">";"<g id=\"bgcontainer\" transform=\"translate(0,-40)\">")
							
							$svg:=svg ("parse";New object:C1471(\
								"variable";$t)).setAttribute("transform";\
								"scale(0.97)")
							
						Else 
							
							  //#TO_DO - A new format for the template
							
						End if 
						
					Else 
						
						$svg:=svg ("parse";New object:C1471(\
							"variable";$t)).setAttribute("transform";\
							"scale(0.95)")
						
					End if 
					
					If (Asserted:C1132($svg.success;"Failed to parse template \""+$t+"\""))
						
						  // Add the style sheet
						$svg.styleSheet(COMPONENT_Pathname ("templates").file("template.css"))
						
						  // Update values if any
						$t:=$svg.findById("cookery")
						
						If (Asserted:C1132($svg.success;"Missing cookery element"))
							
							$o:=xml_attributes ($t)
							
							  // Get the bindind definition
							If (Asserted:C1132($o["ios:values"]#Null:C1517))
								
								$c:=Split string:C1554(String:C10($o["ios:values"]);",";sk trim spaces:K86:2)
								
							End if 
							
							$oTarget:=Choose:C955(Form:C1466[$tTypeForm][$context.tableNumber]=Null:C1517;New object:C1471;Form:C1466[$tTypeForm][$context.tableNumber])
							
							  // Get the template for multivalued fields reference, if exist
							$domTemplate:=$svg.findById("f")
							$bMultivalued:=($svg.success)
							
							If ($bMultivalued)
								
								  // Get the main group reference
								$domMultivalued:=$svg.findById("multivalued")
								
								  // Get the vertical offset
								$o:=xml_attributes ($domTemplate)
								
								If ($o["ios:dy"]#Null:C1517)
									
									$Lon_yOffset:=Num:C11($o["ios:dy"])
									DOM REMOVE XML ATTRIBUTE:C1084($domTemplate;"ios:dy")
									
								End if 
								
								For each ($tField;$c)
									
									$t:=$svg.findById($tField)
									
									If ($svg.success)
										
										If (feature.with("newViewUI"))
											
											$dom:=$svg.findById($tField+".label")
											
											If ($svg.success)
												
												DOM SET XML ELEMENT VALUE:C868($dom;Get localized string:C991("dropAFieldHere"))
												
											End if 
										End if 
										
										  // Get position
										$dom:=DOM Get parent XML element:C923($t)
										
										If (Asserted:C1132(OK=1))
											
											DOM GET XML ATTRIBUTE BY NAME:C728($dom;"transform";$t)
											$Lon_y:=Num:C11(Replace string:C233($t;"translate(0,";""))
											
										End if 
										
									Else 
										
										  // Create an object from the template
										$Lon_y:=$Lon_y+$Lon_yOffset
										$tIndex:=String:C10(Num:C11($tField))
										
										$domUse:=DOM Create XML Ref:C861("root")
										
										If (Asserted:C1132(OK=1))
											
											$domNew:=DOM Append XML element:C1082($domUse;$domTemplate)
											
											  // Remove id
											DOM REMOVE XML ATTRIBUTE:C1084($domNew;"id")
											
											  // Set position
											DOM SET XML ATTRIBUTE:C866($domNew;\
												"transform";"translate(0,"+String:C10($Lon_y)+")")
											
											  // Set label
											$dom:=DOM Find XML element by ID:C1010($domNew;"f.label")
											DOM SET XML ATTRIBUTE:C866($dom;\
												"id";$tField+".label")
											
											If (feature.with("newViewUI"))
												
												DOM SET XML ELEMENT VALUE:C868($dom;Get localized string:C991("dropAFieldHere"))
												
											Else 
												
												DOM GET XML ELEMENT VALUE:C731($dom;$t)
												DOM SET XML ELEMENT VALUE:C868($dom;Get localized string:C991($t)+$tIndex)
												
											End if 
											
											  // Set id, bind & default label
											$dom:=DOM Find XML element by ID:C1010($domNew;"f")
											
											If (feature.with("newViewUI")) & False:C215
												
												DOM SET XML ATTRIBUTE:C866($dom;\
													"id";$tField;\
													"ios:bind";"fields["+String:C10(Num:C11($tField)-1)+"]")
												
											Else 
												
												DOM SET XML ATTRIBUTE:C866($dom;\
													"id";$tField;\
													"ios:bind";"fields["+String:C10(Num:C11($tField)-1)+"]";\
													"ios:label";Get localized string:C991("field[n]")+" "+$tIndex)
												
											End if 
											
											  // Set cancel id
											$dom:=DOM Find XML element by ID:C1010($domNew;"f.cancel")
											DOM SET XML ATTRIBUTE:C866($dom;\
												"id";$tField+".cancel")
											
											  // Append object to the preview
											$domNew:=DOM Append XML element:C1082($domMultivalued;$domNew)
											
											DOM CLOSE XML:C722($domUse)
											
										End if 
									End if 
								End for each 
							End if 
							
							  // Valorize the fields
							For each ($t;$c)
								
								CLEAR VARIABLE:C89($tName)
								
								  // Find the binded element
								$domField:=$svg.findById($t)
								
								  // Get the field bind
								$o:=xml_attributes ($domField)
								
								If (Asserted:C1132($o["ios:bind"]#Null:C1517))
									
									If (Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$o["ios:bind"])=-1)
										
										  // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
										If ($oTarget[$o["ios:bind"]]#Null:C1517)
											
											If (Value type:C1509($oTarget[$o["ios:bind"]])=Is collection:K8:32)
												
												If ($oTarget[$o["ios:bind"]].length=1)
													
													$tName:=$oTarget[$o["ios:bind"]][0].name
													
												Else 
													
													  // Multi-criteria Search
													$tName:=Get localized string:C991("multiCriteriaSearch")
													
												End if 
												
											Else 
												
												$tName:=String:C10($oTarget[$o["ios:bind"]].name)
												
											End if 
										End if 
										
										$indx:=$indx-1
										
									Else 
										
										If ($indx<$oTarget.fields.length)
											
											$o:=$oTarget.fields[$indx]
											
											If ($o#Null:C1517)
												
												  // Keep the field  description for the needs of UI
												$svg.setAttribute("ios:data";JSON Stringify:C1217($o);$domField)
												
												$tName:=$o.name
												
												If (Num:C11($o.fieldType)=8859)  // 1-N relation
													
													$dom:=$svg.findById($t+".label")
													
													$svg.setAttribute("font-style";"italic";$dom)
													
													If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
														
														$svg.setAttribute("class";String:C10(xml_attributes ($dom).class)+" error";$dom)
														
													End if 
												End if 
												
												  // Keep the nex available index
												$context.lastMultivaluedField:=$indx+1
												
											End if 
										End if 
									End if 
								End if 
								
								If (Length:C16($tName)>0)
									
									If (Asserted:C1132(OK=1))
										
										$svg.setAttribute("stroke-dasharray";"none";$domField)
										
										If ($bMultivalued)
											
											  // Make it visible & mark as affected
											$svg.setAttributes(New object:C1471("target";DOM Get parent XML element:C923($domField);\
												"visibility";"visible";\
												"class";"affected"))
											
										End if 
										
										$dom:=$svg.findById($t+".label")
										
										If (Asserted:C1132($svg.success))
											
											  // Truncate & set tips if necessary
											$width:=Num:C11(xml_attributes ($dom).width)
											
											If ($width>0)
												
												$width:=$width/10
												
												If (Length:C16($tName)>($width))
													
													$svg.setAttribute("tips";$tName;$dom)
													$tName:=Substring:C12($tName;1;$width)+"…"
													
												End if 
											End if 
											
											DOM SET XML ELEMENT VALUE:C868($dom;$tName)
											
										End if 
										
										$dom:=$svg.findById($t+".cancel")
										
										If ($svg.success)
											
											$svg.setVisible(True:C214;$dom)
											
										End if 
									End if 
								End if 
								
								$indx:=$indx+1
								
							End for each 
							
							If ($bMultivalued)
								
								  // Hide unassigned multivalued fields (except the first)
								ARRAY TEXT:C222($tDom_;0x0000)
								$tDom_{0}:=DOM Find XML element:C864($domMultivalued;"g/g";$tDom_)
								
								For ($i;1;Size of array:C274($tDom_);1)
									
									If (String:C10(xml_attributes ($tDom_{$i}).class)="")  // Not affected
										
										If (Not:C34($bFirst))
											
											  // We have found the first non affected field
											$bFirst:=True:C214
											
											  // Make it visible to allow drag and drop
											$svg.setVisible(True:C214;$tDom_{$i})
											
										Else 
											
											  // Hide the other ones
											$svg.setVisible(False:C215;$tDom_{$i})
											
										End if 
									End if 
								End for 
							End if 
							
							  // Tabs
							$t:=$svg.findById("tabs")
							
							If ($svg.success)
								
								CLEAR VARIABLE:C89($indx)
								
								Repeat 
									
									$dom:=$svg.findById("tab-"+String:C10($indx))
									
									If ($svg.success)
										
										$svg.setVisible(Num:C11($context.tabIndex)=$indx;$dom)
										
									End if 
									
									$indx:=$indx+1
									
								Until (OK=0)
							End if 
						End if 
						
						If (feature.with("_8858"))
							
							$svg.saveText(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.svg");True:C214)
							
						End if 
						
						If (feature.with("newViewUI"))
							
							$form.preview.getCoordinates()
							
							If ($tTypeForm="detail")
								
								$svg.setDimensions($form.preview.coordinates.width;770)
								
							Else 
								
								$svg.setDimensions($form.preview.coordinates.width;440)
								
							End if 
						End if 
						
						($form.preview.pointer())->:=$svg.getPicture()
						
					End if 
					
				Else 
					
					$form.form.call("pickerHide")
					
					  // Put an error message
					$form.preview.getCoordinates()
					
					($form.preview.pointer())->:=svg .setDimensions($form.preview.coordinates.width-20;$form.preview.coordinates.height)\
						.textArea(str ("theTemplateIsMissingOrInvalid").localized(Replace string:C233($tFormName;"/";""));20;180)\
						.setDimensions($form.preview.coordinates.width-20)\
						.setFill(ui.colors.errorColor.hex)\
						.setAttributes(New object:C1471("font-size";14;"text-align";"center"))\
						.getPicture()
					
					OBJECT SET TITLE:C194(*;"preview.label";"")
					
				End if 
				
			Else 
				
				  // Display the template picker
				$form.fieldGroup.hide()
				$form.previewGroup.hide()
				
				views_LAYOUT_PICKER ($tTypeForm)
				
			End if 
			
		Else 
			
			  // NOTHING MORE TO DO
			
		End if 
		
		  //______________________________________________________
	: ($tIN="cancel")  // Return cancel button as Base64 data
		
		  //#KEEP FOR COMPATIBILITY WITH OLD TEMPLATES
		
		  //READ PICTURE FILE(Get 4D folder(Current resources folder)+Convert path POSIX to system("images/Buttons/LightGrey/Cancel.png");$Pic_cancel)
		  //TRANSFORM PICTURE($Pic_cancel;Crop;1;1;48;48)
		  //CREATE THUMBNAIL($Pic_cancel;$Pic_cancel;30;30)
		  //PICTURE TO BLOB($Pic_cancel;$Blb_;".png")
		  //BASE64 ENCODE($Blb_;$Txt_out)
		  //$Txt_out:="data:;base64,"+$Txt_out
		
		$tOUT:="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAAAXNSR0IArs4c6QAAAuJJREFUSA3tlEtoU1EQhptHI4lp8FUMlIIPpH"+\
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
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$tIN+"\"")
		
		  //______________________________________________________
End case 

FINALLY 

  // ----------------------------------------------------
  // Return
$0:=$tOUT

  // ----------------------------------------------------
  // End