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

C_BOOLEAN:C305($Boo_first;$Boo_multivalued;$Boo_OK)
C_LONGINT:C283($i;$Lon_index;$Lon_parameters;$Lon_width;$Lon_y;$Lon_yOffset)
C_TEXT:C284($Dom_field;$Dom_multivalued;$Dom_new;$Dom_template;$Dom_use;$t)
C_TEXT:C284($tt;$Txt_field;$Txt_in;$Txt_index;$Txt_name;$Txt_out)
C_TEXT:C284($Txt_typeForm)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_target;$Path_root;$svg)
C_COLLECTION:C1488($c)

If (False:C215)
	C_TEXT:C284(views_preview ;$0)
	C_TEXT:C284(views_preview ;$1)
	C_OBJECT:C1216(views_preview ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_in:=$1
		
		If ($Lon_parameters>=2)
			
			$Obj_form:=$2
			
		End if 
	End if 
	
	$Obj_context:=$Obj_form.$
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_in="draw")  // Uppdate preview
		
		$Txt_typeForm:=$Obj_context.typeForm()
		
		If (Length:C16($Obj_context.tableNum())>0)
			
			$t:=String:C10(Form:C1466[$Txt_typeForm][$Obj_context.tableNum()].form)  // Form name
			
			If (Length:C16($t)>0)\
				 & ($t#"null")
				
				If (Position:C15("/";$t)=1)
					
					  // Host database resources
					$t:=Delete string:C232($t;1;1)
					
					$Path_root:=COMPONENT_Pathname ("host_"+$Txt_typeForm+"Forms").folder($t)
					
					$Boo_OK:=$Path_root.exists
					
					If ($Boo_OK)
						
						  // Verify the structure validity
						$o:=JSON Parse:C1218(COMPONENT_Pathname ($Txt_typeForm+"Forms").file("manifest.json").getText())
						
						For each ($tt;$o.mandatory) While ($Boo_OK)
							
							$Boo_OK:=$Path_root.file($tt).exists
							
						End for each 
					End if 
					
				Else 
					
					$Path_root:=COMPONENT_Pathname ($Txt_typeForm+"Forms").folder($t)
					
					  // We assume that our templates are OK!
					$Boo_OK:=$Path_root.exists
					
				End if 
				
				OBJECT SET TITLE:C194(*;"preview.label";$t)
				
				If ($Boo_OK)
					
					  // Load the template
					PROCESS 4D TAGS:C816($Path_root.file("template.svg").getText();$t)
					
					$svg:=svg ("parse";New object:C1471(\
						"variable";$t)).setAttribute("transform";\
						"scale(0.95)")
					
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
							
							$Obj_target:=Choose:C955(Form:C1466[$Txt_typeForm][$Obj_context.tableNumber]=Null:C1517;New object:C1471;Form:C1466[$Txt_typeForm][$Obj_context.tableNumber])
							
							  // Get the template for multivalued fields reference, if exist
							$Dom_template:=$svg.findById("f")
							$Boo_multivalued:=($svg.success)
							
							If ($Boo_multivalued)
								
								  // Get the main group reference
								$Dom_multivalued:=$svg.findById("multivalued")
								
								  // Get the vertical offset
								$o:=xml_attributes ($Dom_template)
								
								If ($o["ios:dy"]#Null:C1517)
									
									$Lon_yOffset:=Num:C11($o["ios:dy"])
									DOM REMOVE XML ATTRIBUTE:C1084($Dom_template;"ios:dy")
									
								End if 
								
								For each ($Txt_field;$c)
									
									$t:=$svg.findById($Txt_field)
									
									If ($svg.success)
										
										  // Get position
										$tt:=DOM Get parent XML element:C923($t)
										
										If (Asserted:C1132(OK=1))
											
											DOM GET XML ATTRIBUTE BY NAME:C728($tt;"transform";$t)
											$Lon_y:=Num:C11(Replace string:C233($t;"translate(0,";""))
											
										End if 
										
									Else 
										
										  // Create an object from the template
										$Lon_y:=$Lon_y+$Lon_yOffset
										$Txt_index:=String:C10(Num:C11($Txt_field))
										
										$Dom_use:=DOM Create XML Ref:C861("root")
										
										If (Asserted:C1132(OK=1))
											
											$Dom_new:=DOM Append XML element:C1082($Dom_use;$Dom_template)
											
											  // Remove id
											DOM REMOVE XML ATTRIBUTE:C1084($Dom_new;"id")
											
											  // Set position
											DOM SET XML ATTRIBUTE:C866($Dom_new;\
												"transform";"translate(0,"+String:C10($Lon_y)+")")
											
											  // Set label
											$tt:=DOM Find XML element by ID:C1010($Dom_new;"f.label")
											DOM SET XML ATTRIBUTE:C866($tt;\
												"id";$Txt_field+".label")
											DOM GET XML ELEMENT VALUE:C731($tt;$t)
											DOM SET XML ELEMENT VALUE:C868($tt;Get localized string:C991($t)+$Txt_index)
											  //DOM SET XML ELEMENT VALUE($tt;".Drop a field here")
											
											  // Set id, bind & default label
											$tt:=DOM Find XML element by ID:C1010($Dom_new;"f")
											
											DOM SET XML ATTRIBUTE:C866($tt;\
												"id";$Txt_field;\
												"ios:bind";"fields["+String:C10(Num:C11($Txt_field)-1)+"]";\
												"ios:label";Get localized string:C991("field[n]")+" "+$Txt_index)
											
											  //DOM SET XML ATTRIBUTE($tt;\
												"id";$Txt_field;\
												"ios:bind";"fields["+String(Num($Txt_field)-1)+"]";\
												"ios:label";".Drop a field here")
											
											  // Set cancel id
											$tt:=DOM Find XML element by ID:C1010($Dom_new;"f.cancel")
											DOM SET XML ATTRIBUTE:C866($tt;\
												"id";$Txt_field+".cancel")
											
											  // Append object to the preview
											$Dom_new:=DOM Append XML element:C1082($Dom_multivalued;$Dom_new)
											
											DOM CLOSE XML:C722($Dom_use)
											
										End if 
									End if 
								End for each 
							End if 
							
							  // Valorize the fields
							For each ($t;$c)
								
								CLEAR VARIABLE:C89($Txt_name)
								
								  // Find the binded element
								$Dom_field:=$svg.findById($t)
								
								  // Get the field bind
								$o:=xml_attributes ($Dom_field)
								
								If (Asserted:C1132($o["ios:bind"]#Null:C1517))
									
									If (Rgx_MatchText ("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$";$o["ios:bind"])=-1)
										
										  // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
										If ($Obj_target[$o["ios:bind"]]#Null:C1517)
											
											If (Value type:C1509($Obj_target[$o["ios:bind"]])=Is collection:K8:32)
												
												If ($Obj_target[$o["ios:bind"]].length=1)
													
													$Txt_name:=$Obj_target[$o["ios:bind"]][0].name
													
												Else 
													
													  // Multi-criteria Search
													$Txt_name:=Get localized string:C991("multiCriteriaSearch")
													
												End if 
												
											Else 
												
												$Txt_name:=String:C10($Obj_target[$o["ios:bind"]].name)
												
											End if 
										End if 
										
										$Lon_index:=$Lon_index-1
										
									Else 
										
										If ($Lon_index<$Obj_target.fields.length)
											
											$o:=$Obj_target.fields[$Lon_index]
											
											If ($o#Null:C1517)
												
												  // Keep the field  description for the needs of UI
												$svg.setAttribute("ios:data";JSON Stringify:C1217($o);$Dom_field)
												
												$Txt_name:=$o.name
												
												If (Num:C11($o.fieldType)=8859)  // 1-N relation
													
													$tt:=$svg.findById($t+".label")
													
													$svg.setAttribute("font-style";"italic";$tt)
													
													If (Form:C1466.dataModel[String:C10($o.relatedTableNumber)]=Null:C1517)  // Error
														
														$svg.setAttribute("class";String:C10(xml_attributes ($tt).class)+" error";$tt)
														
													End if 
												End if 
											End if 
										End if 
									End if 
								End if 
								
								If (Length:C16($Txt_name)>0)
									
									If (Asserted:C1132(OK=1))
										
										$svg.setAttribute("stroke-dasharray";"none";$Dom_field)
										
										If ($Boo_multivalued)
											
											  // Make it visible & mark as affected
											$svg.setAttributes(New object:C1471("target";DOM Get parent XML element:C923($Dom_field);\
												"visibility";"visible";\
												"class";"affected"))
											
										End if 
										
										$tt:=$svg.findById($t+".label")
										
										If (Asserted:C1132($svg.success))
											
											  // Truncate & set tips if necessary
											$Lon_width:=Num:C11(xml_attributes ($tt).width)
											
											If ($Lon_width>0)
												
												$Lon_width:=$Lon_width/10
												
												If (Length:C16($Txt_name)>($Lon_width))
													
													$svg.setAttribute("tips";$Txt_name;$tt)
													$Txt_name:=Substring:C12($Txt_name;1;$Lon_width)+"…"
													
												End if 
											End if 
											
											DOM SET XML ELEMENT VALUE:C868($tt;$Txt_name)
											
										End if 
										
										$tt:=$svg.findById($t+".cancel")
										
										If ($svg.success)
											
											$svg.setVisible(True:C214;$tt)
											
										End if 
									End if 
								End if 
								
								$Lon_index:=$Lon_index+1
								
							End for each 
							
							If ($Boo_multivalued)
								
								  // Hide unassigned multivalued fields (except the first)
								ARRAY TEXT:C222($tDom_;0x0000)
								$tDom_{0}:=DOM Find XML element:C864($Dom_multivalued;"g/g";$tDom_)
								
								For ($i;1;Size of array:C274($tDom_);1)
									
									If (String:C10(xml_attributes ($tDom_{$i}).class)="")  // Not affected
										
										If (Not:C34($Boo_first))
											
											  // We have found the first non affected field
											$Boo_first:=True:C214
											
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
								
								CLEAR VARIABLE:C89($Lon_index)
								
								Repeat 
									
									$tt:=$svg.findById("tab-"+String:C10($Lon_index))
									
									If ($svg.success)
										
										$svg.setVisible(Num:C11($Obj_context.tabIndex)=$Lon_index;$tt)
										
									End if 
									
									$Lon_index:=$Lon_index+1
									
								Until (OK=0)
							End if 
						End if 
						
						If (featuresFlags.with("_8858"))
							
							$svg.saveText(Folder:C1567(fk desktop folder:K87:19).file("DEV/preview.svg");True:C214)
							
						End if 
						
						($Obj_form.preview.pointer())->:=$svg.getPicture()
						
					End if 
					
				Else 
					
					$Obj_form.form.call("pickerHide")
					
					$Obj_form.preview.getCoordinates()
					
					($Obj_form.preview.pointer())->:=svg .setDimensions($Obj_form.preview.coordinates.width-20;$Obj_form.preview.coordinates.height)\
						.textArea(Replace string:C233(Get localized string:C991("theTemplateIsMissingOrInvalid");"{tmpl}";$Path_root.name);0;200)\
						.setDimensions($Obj_form.preview.coordinates.width-20)\
						.setFill(ui.colors.errorColor.hex)\
						.setAttributes(New object:C1471("font-size";14;"text-align";"center"))\
						.getPicture()
					
				End if 
				
			Else 
				
				  // Display the template picker
				$Obj_form.fieldGroup.hide()
				$Obj_form.previewGroup.hide()
				
				views_LAYOUT_PICKER ($Txt_typeForm)
				
			End if 
			
		Else 
			
			  // NOTHING MORE TO DO
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="cancel")  // Return cancel button as Base64 data
		
		  //#KEEP FOR COMPATIBILITY WITH OLD TEMPLATES
		
		  //READ PICTURE FILE(Get 4D folder(Current resources folder)+Convert path POSIX to system("images/Buttons/LightGrey/Cancel.png");$Pic_cancel)
		  //TRANSFORM PICTURE($Pic_cancel;Crop;1;1;48;48)
		  //CREATE THUMBNAIL($Pic_cancel;$Pic_cancel;30;30)
		  //PICTURE TO BLOB($Pic_cancel;$Blb_;".png")
		  //BASE64 ENCODE($Blb_;$Txt_out)
		  //$Txt_out:="data:;base64,"+$Txt_out
		
		$Txt_out:="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAAAXNSR0IArs4c6QAAAuJJREFUSA3tlEtoU1EQhptHI4lp8FUMlIIPpH"+\
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
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_in+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End