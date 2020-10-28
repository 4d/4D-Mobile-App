// ============================================================================
Class extends svg  // xml -> svg -> tmpl
// ============================================================================

// ============================================================================
Class constructor($name : Text; $type : Text)
	
	Super:C1705()
	
	var $file : Object
	
	
	This:C1470.upToDate:=False:C215
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$name
		This:C1470.title:=This:C1470.name
		This:C1470.type:=Null:C1517
		
		//%W-533.1
		If (This:C1470.name[[1]]="/")
			
			This:C1470.title:=Delete string:C232(This:C1470.title; 1; 1)
			
		End if 
		//%W+533.1
		
		// Set the display name
		This:C1470.title:=Replace string:C233(This:C1470.title; "form-detail-"; "")
		This:C1470.title:=Replace string:C233(This:C1470.title; "form-list-"; "")
		This:C1470.title:=Replace string:C233(This:C1470.title; SHARED.archiveExtension; "")
		
		If (Count parameters:C259>=2)
			
			This:C1470.type:=$type
			
			This:C1470.path:=This:C1470.path()
			
			If (Bool:C1537(This:C1470.path.exists))
				
				// Load the manifest
				$file:=This:C1470.path.file("manifest.json")
				
				If ($file.exists)
					
					This:C1470.manifest:=JSON Parse:C1218($file.getText())
					This:C1470.listform:=(String:C10(This:C1470.manifest.type)="listform")
					This:C1470.detailform:=(String:C10(This:C1470.manifest.type)="detailform")
					
				Else 
					
					RECORD.warning("Missing manifest for the template "+This:C1470.title)
					
				End if 
				
				// Load the svg template
				$file:=This:C1470.path.file("template.svg")
				
				If ($file.exists)
					
					This:C1470.svg:=$file.getText()
					This:C1470.update()
					
				Else 
					
					RECORD.warning("Missing svg for the template "+This:C1470.title)
					
				End if 
			End if 
			
			// Defining widgets
			This:C1470.oneField:=New object:C1471(\
				"manifest"; JSON Parse:C1218(File:C1566("/RESOURCES/templates/form/objects/oneField/manifest.json").getText()); \
				"definition"; File:C1566("/RESOURCES/templates/form/objects/oneField/widget.svg").getText())
			
		Else 
			
			// Call from PROCESS 4D TAGS
			
		End if 
	End if 
	
/* ============================================================================*/
	//Function load  // Load and update the template if any
Function update  // Load and update the template if any
	var $0 : Object
	
	var $dom; $node; $root; $t : Text
	var $succes : Boolean
	var $count; $i : Integer
	var $o : Object
	var $c : Collection
	
	If (Not:C34(This:C1470.upToDate))
		
		This:C1470.upToDate:=True:C214
		
		If (Num:C11(This:C1470.manifest.renderer)<2)
			
			$t:=This:C1470.svg
			$root:=DOM Parse XML variable:C720($t)
			
			If (Bool:C1537(OK))
				
				// Remove mobile picture
				$node:=DOM Find XML element:C864($root; "/"+"/rect[contains(@class,'container')")
				
				If (Bool:C1537(OK))
					
					DOM REMOVE XML ELEMENT:C869($node)
					
				End if 
				
				// Adjustments
				$node:=DOM Find XML element by ID:C1010($root; "bgcontainer")
				
				If (Bool:C1537(OK))
					
					DOM SET XML ATTRIBUTE:C866($node; \
						"transform"; "translate(0,-50)")
					
				End if 
				
				DOM EXPORT TO VAR:C863($root; $t)
				DOM CLOSE XML:C722($root)
				
				// Keep the modified template
				This:C1470.svg:=$t
				
				// Try to adapt the old template to the renderer v2
				$root:=DOM Parse XML variable:C720($t)
				
				If (Bool:C1537(OK))
					
					// Change the background
					$node:=DOM Find XML element:C864($root; "/"+"/rect[contains(@class,'bgcontainer')")
					
					If (Bool:C1537(OK))
						
						DOM REMOVE XML ELEMENT:C869($node)
						
						$node:=DOM Find XML element by ID:C1010($root; "bgcontainer")
						
						If (Bool:C1537(OK))
							
							DOM SET XML ATTRIBUTE:C866($node; \
								"id"; "background"; \
								"class"; "background"; \
								"ios:type"; "all")
							
							If (Bool:C1537(OK))
								
								$dom:=DOM Create XML element:C865($node; "rect"; \
									"class"; "bgcontainer_v2"; \
									"x"; 0; \
									"y"; 0)
								
								If (Bool:C1537(OK))
									
									$node:=DOM Insert XML element:C1083($node; $dom; 0)
									
									If (Bool:C1537(OK))
										
										DOM REMOVE XML ELEMENT:C869($dom)
										
									End if 
								End if 
							End if 
						End if 
					End if 
					
					Case of 
							
							//______________________________________________________
						: (This:C1470.detailform)
							
							// Remove cookery
							$node:=DOM Find XML element by ID:C1010($root; "cookery")
							
							If (Bool:C1537(OK))
								
								DOM REMOVE XML ELEMENT:C869($node)
								
							End if 
							
							// Remove template for additional fields
							$node:=DOM Find XML element by ID:C1010($root; "f")
							
							If (Bool:C1537(OK))
								
								DOM REMOVE XML ELEMENT:C869($node)
								
							End if 
							
							// Remove the fisrt multivalued field
							$node:=DOM Find XML element by ID:C1010($root; "multivalued")
							
							If (Bool:C1537(OK))
								
								DOM REMOVE XML ELEMENT:C869($node)
								
							End if 
							
							
							
							
							
							
							
							
							//______________________________________________________
						: (This:C1470.listform) & (FEATURE.with("moreRelations"))
							
							// Add the types -8858 & -8859 to forbid the deposit of a relation
							// on the"searchableField" & "sectionField fields"
							
							$succes:=Bool:C1537(OK)
							
							$node:=DOM Find XML element:C864($root; "/"+"/rect[@ios:bind='searchableField']")
							
							If (Bool:C1537(OK))
								
								DOM SET XML ATTRIBUTE:C866($node; "ios:type"; "-3,-6,-8858,-8859")
								
							End if 
							
							$node:=DOM Find XML element:C864($root; "/"+"/rect[@ios:bind='sectionField']")
							
							If (Bool:C1537(OK))
								
								DOM SET XML ATTRIBUTE:C866($node; "ios:type"; "-3,-6,-8858,-8859")
								
							End if 
							
							OK:=Num:C11($succes)
							
							If (False:C215)  //#WIP - Set to true to don't allow drop of relation on fixed fields
								
								// Don't allows deposit of a relation on the fixed fields
								// if it's not explicity allowed
								
								$count:=Num:C11(This:C1470.manifest.fields.count)
								
								For ($i; 1; $count; 1)
									
									$node:=DOM Find XML element by ID:C1010($root; "f"+String:C10($i))
									
									If (Bool:C1537(OK))
										
										$c:=Split string:C1554(This:C1470.getBinding($node); ",")
										
										Case of 
												
												//____________________________
											: ($c.length=0)  // Should not but…
												
												$c:=New collection:C1472(-8858; -8859)
												
												//____________________________
											: ($c[0]="all")
												
												// Don't modify
												
												//____________________________
											: ($c[0]="-@")
												
												If ($c.indexOf(-8858)=-1)
													
													$c.push(-8858)
													
												End if 
												
												If ($c.indexOf(-8859)=-1)
													
													$c.push(-8859)
													
												End if 
												
												//____________________________
											Else 
												
												// Don't modify
												
												//____________________________
										End case 
										
										DOM SET XML ATTRIBUTE:C866($node; "ios:type"; $c.join(","))
										
									End if 
								End for 
							End if 
							
							//______________________________________________________
					End case 
					
					Case of 
							
							//______________________________________________________
						: (Not:C34(Bool:C1537(OK)))
							
							This:C1470.warning:="Something failed when updating the template"
							
							//______________________________________________________
						: (This:C1470.detailform)
							
							// Fix hOffset
							$o:=JSON Parse:C1218(File:C1566("/RESOURCES/templates/v2Conversion.json").getText())
							
							If ($o[This:C1470.title]#Null:C1517)
								
								This:C1470.manifest.hOffset:=$o[This:C1470.title]
								
								// Update the manifest
								This:C1470.manifest.renderer:=2
								This:C1470.manifest.fields.max:=0
								
								// Keep the updated template
								DOM EXPORT TO VAR:C863($root; $t)
								This:C1470.svg:=$t
								//This.svg:=This.getText(False)
								
							Else 
								
								This:C1470.warning:="Obsolete template"
								
							End if 
							
							//______________________________________________________
						: (Not:C34(FEATURE.with("moreRelations")))
							
							//
							
							//______________________________________________________
						: (This:C1470.listform)
							
							// Update the manifest
							This:C1470.manifest.renderer:=2
							
							
							This:C1470.svg:=This:C1470.getText(False:C215)
							
							// Keep the updated template
							DOM EXPORT TO VAR:C863($root; $t)
							This:C1470.svg:=$t
							//
							
							//______________________________________________________
						Else 
							
							This:C1470.warning:="Missing template type"
							
							//______________________________________________________
					End case 
					
					DOM CLOSE XML:C722($root)
					
				End if 
			End if 
		End if 
		
		If (FEATURE.with("moreRelations"))  // Mark static fields & refuse 1 to N relation into static field for detail forms
			
			This:C1470.load(This:C1470.svg)
			
			If (This:C1470.success)
				
				$count:=Num:C11(This:C1470.manifest.fields.count)
				
				For ($i; 1; $count; 1)
					
					$node:=This:C1470.findById("f"+String:C10($i))
					
					If (This:C1470.success)
						
						This:C1470.addClass("static"; $node)
						
					End if 
					
					If (This:C1470.detailform)
						
						$t:=This:C1470.getBinding($node)
						
						If ($t="all")
							
							This:C1470.setAttribute("ios:type"; "-8859"; $node)
							
						Else 
							
							$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
							
							If ($c.every("col_formula"; Formula:C1597($1.result:=($1.value<0))))
								
								$c.push(-8859)
								This:C1470.setAttribute("ios:type"; $c.join(","); $node)
								
							Else 
								
								// <NOTHING MORE TO DO>
								
							End if 
						End if 
					End if 
				End for 
				
				This:C1470.svg:=This:C1470.getText()
				
			End if 
		End if 
	End if 
	
	$0:=This:C1470
	
/* ============================================================================*/
Function getBinding($node : Text)->$binding : Text
	
	$binding:=String:C10(This:C1470.getAttribute($node; "ios:type"))
	
/* ============================================================================*/
Function cancel  // Return the embedded cancel button used into the templates
	var $0 : Text
	
	$0:="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAAAXNSR0IArs4c6QAAAuJJREFUSA3tlEtoU1EQhptHI4lp8FUMlIIPpH"+\
		"ZRixTdFYIIUrCBkJTQlCpEjFJw4UYRFaObVnEjWbhQqRgLtiG6koAiIiiKG0UkiRXrShHbQtNiJEnT+E3hykFyb+LGheTAMOf8Z2b+mblzT1NTYzU68L91wPS3Bfn9/l1ms7nf"+\
		"ZDLtxHcN8oX9E5vN9jQej/+oN17dxAMDAx0Qnl9ZWfESfBr5ipSQDRB3oOeR6NTUVBJdc9VFDOk+gscrlcoMEc9R3ZuJiYlFie7xeKytra1bSOoIxxFsriNnE4lEWe71Vk1"+\
		"iqRTnZ0gCOUXAn3rBAoHAQRK8y/0YdmN6doJbjC6lGqfTeY1gQnaIYAUj+3Q6Pd3V1TVHxRc6OzsfZjKZWT17s96F4LSwmyD95XL5DKRFwaLRqHl4eHit7GXREVtfX58M2ep"+\
		"iBu6Q6LTFYoloWDVtSEyAfpyy+Xz+reaczWbbCoXCA6b7QCgUWg9+z+VyhbR7SZBkE0hvOBxu0fA/tSExzrtxyKRSqd8tzuVy38HeMUy3lpeXH2PTjn6uBqbqF5y3Li0tuVRc3d"+\
		"cidlF1XnWQJEql0hUwk9Vq7UHHksnkR9WGqc9xtvOJrCqu7g2JqWqWitapDkNDQy4Ib4PPkUCcxC4zzb2qDbib86LD4VidC/VO2xsSE1Ra1s0AOTWHYrHoAJ+BOMhjcRh9g/Mm7V"+\
		"405/2oD8zCgoqre8P/mAHaRtWvCXSs3hfJ5/NtpCMv8RnHZ1QlU/eGFfPtpLKbyOjg4OBm1VFvz/c9zZ0Nn3E9G8ENicWAB0ReoAUm9z4d2CFYtRWJRJr5JBeZ6BGqPcFv9a2anYY"+\
		"ZtlozCgaD26lAnsJ2Al8l8CO32/0pFosVIZNO7OWTHEfvwe4kLRZbw1UXsUTwer0tdrv9KMRCYEMqgpPEqkD4iv2lycnJjOC1Vt3EWiBJgO/Yw5PYRhLNkM1D+p7WftZsGrrRgUYH/"+\
		"mkHfgG6PCOSHCtXRwAAAABJRU5ErkJggg=="
	
/* ============================================================================*/
Function path  // Return the path of the file/folder
	var $0 : Object
	
	var $t : Text
	var $success : Boolean
	var $archive; $error; $fileManifest; $o; $path : Object
	
	$t:=This:C1470.name
	
	If ($t[[1]]="/")  // Host database resources
		
		$t:=Delete string:C232($t; 1; 1)  // Remove initial slash
		
		If (Path to object:C1547($t).extension=SHARED.archiveExtension)  // Archive
			
			$error:=err.hide()
			$archive:=ZIP Read archive:C1637(path["host"+This:C1470.type+"Forms"]().file($t))
			$error.show()
			
			If ($archive#Null:C1517)
				
				$path:=$archive.root
				
			End if 
			
		Else 
			
			$path:=Folder:C1567(path["host"+This:C1470.type+"Forms"]().folder($t).platformPath; fk platform path:K87:2)
			
		End if 
		
		$success:=Bool:C1537($path.exists)
		
		If ($success)
			
			// Verify the structure validity
			$o:=path[This:C1470.type+"Forms"]()
			
			If ($o#Null:C1517)
				
				$fileManifest:=$o.file("manifest.json")
				
				If ($fileManifest.exists)
					
					$o:=JSON Parse:C1218($fileManifest.getText())
					
					If ($o.mandatory#Null:C1517)
						
						For each ($t; $o.mandatory) While ($success)
							
							$success:=$path.file($t).exists
							
						End for each 
						
					Else 
						
						RECORD.warning("No mandatory for: "+$fileManifest.path)
						
					End if 
					
				Else 
					
					RECORD.error("Missing manifest: "+$fileManifest.path)
					
				End if 
				
			Else 
				
				RECORD.error("Unmanaged form type: "+This:C1470.type)
				
			End if 
		End if 
		
	Else 
		
		$path:=Folder:C1567(path[This:C1470.type+"Forms"]().folder($t).platformPath; fk platform path:K87:2)
		
		// We assume that our templates are OK!
		$success:=$path.exists
		
	End if 
	
	If ($success)
		
		$0:=$path
		
	Else 
		
		$0:=New object:C1471(\
			"exists"; False:C215)
		
	End if 
	
/* ============================================================================*/
Function css
	var $0 : Object
	
	$0:=path.templates().file("template.css")
	
/* ============================================================================*/
Function label
	var $0 : Text
	var $1 : Text
	
	$0:=Get localized string:C991($1)
	
	//============================================================================
	// Check that a field type is validated against the bind attribute
Function isTypeAccepted($constraint : Variant; $type : Integer)->$accepted : Boolean
	var $c : Collection
	
	If (Asserted:C1132(Count parameters:C259>=2; "Missing parameter"))
		
		Case of 
				
				//___________________________
			: (Value type:C1509($constraint)=Is text:K8:3)
				
				If ($constraint="all")
					
					$accepted:=True:C214
					
				Else 
					
					$c:=Split string:C1554($constraint; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
					
				End if 
				
				//___________________________
			: (Value type:C1509($constraint)=Is collection:K8:32)
				
				$c:=$constraint
				
				//___________________________
			Else 
				
				ASSERT:C1129(False:C215; "$1 must be a text or a collection")
				
				//___________________________
		End case 
		
		If ($c#Null:C1517)
			
			If ($c.every("col_formula"; Formula:C1597($1.result:=($1.value>=0))))
				
				// One of them
				$accepted:=($c.indexOf(Num:C11($type))#-1)
				
			Else 
				
				// None of them
				$accepted:=($c.filter("col_formula"; Formula:C1597($1.result:=($1.value=-Num:C11($type)))).length=0)
				
			End if 
		End if 
	End if 
	
	//============================================================================
	// Add a "one field" widget to the template
Function appendOneField($index : Integer; $field : Object; $context : Object; $background : Text; $offset : Integer)->$height
	var $class; $key; $label; $name; $node; $style; $t; $tips : Text
	var $found; $isToMany; $isToOne : Boolean
	var $relation : Object
	var $xml : cs:C1710.xml
	
	$isToOne:=($field.fieldType=8858)
	$isToMany:=($field.fieldType=8859)
	
	If ($isToOne | $isToMany)  // Relation
		
		$style:="italic"
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($isToOne)
			
			$tips:=Form:C1466.dataModel[$context.tableNum()][$field.name].label
			
			$relation:=Form:C1466.dataModel[$context.tableNumber]
			
			If ($relation[$field.name].format=Null:C1517)
				
				$label:=$field.name
				
			Else 
				
				If (Match regex:C1019("(?m-si)^%.*%$"; String:C10($relation[$field.name].format); 1))
					
					$name:=Substring:C12($relation[$field.name].format; 2; Length:C16($relation[$field.name].format)-2)
					$label:=$field.name+" ("+$name+")"
					
				End if 
				
				// Check that the discriminant field is published
				For each ($key; $relation[$field.name]) Until ($found)
					
					If (Value type:C1509($relation[$field.name][$key])=Is object:K8:27)
						
						$found:=String:C10($relation[$field.name][$key].name)=$name
						
					End if 
				End for each 
				
				If (Not:C34($found))
					
					$class:="error"
					$tips:=cs:C1710.str.new(ui.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
					
				End if 
			End if 
			
			$label:=cs:C1710.str.new(UI.toOne).concat($label)
			
			//______________________________________________________
		: ($isToMany)
			
			$tips:=$field.label
			$label:=cs:C1710.str.new(UI.toMany).concat($field.name)
			
			//______________________________________________________
		Else 
			
			$label:=$field.name
			
			//______________________________________________________
	End case 
	
	// Set ids, label & position
	PROCESS 4D TAGS:C816(This:C1470.oneField.definition; $t; New object:C1471(\
		"index"; $index; \
		"name"; cs:C1710.str.new($label).xmlSafe(); \
		"offset"; 5+$offset; \
		"style"; $style; \
		"class"; $class; \
		"tips"; cs:C1710.str.new($tips).xmlSafe()))
	
	// Append the widget
	$xml:=cs:C1710.xml.new($t)
	
	If (let(->$node; Formula:C1597($xml.findByXPath("/svg/g")); Formula:C1597($xml.success)))
		
		$node:=DOM Append XML element:C1082($background; $node)
		
	End if 
	
	$xml.close()
	
	$height:=Num:C11(This:C1470.oneField.manifest.height)  // Returns the widget height
	
	//============================================================================
	// 
Function getCookery->$cookery : Text
	var $node : Text
	
	$node:=This:C1470.findById("cookery")
	
	If (This:C1470.success)
		
		$cookery:=This:C1470.getAttribute($node; "ios:values")
		
	End if 
	
	//============================================================================
	// Reorder the fields used when the user changes model (alias tmpl_REORDER)
Function reorder($tableID : Text)  //#WIP
	
	var $node; $t; $element : Text
	var $isCompatible; $isMultiCriteria : Boolean
	var $indx; $Lon_keyType : Integer
	var $attributes; $cache; $field; $o; $oIN : Object
	var $affected; $bind; $c : Collection
	
	If (This:C1470.root=Null:C1517)
		
		This:C1470.load(This:C1470.svg)
		
	End if 
	
	$t:=This:C1470.getCookery()
	
	If (Length:C16($t)>0)
		
		$cache:=PROJECT[This:C1470.type][$tableID]
		$bind:=Split string:C1554($t; ","; sk trim spaces:K86:2)
		
		// Create binding collection sized according to bind attribute length
		If (FEATURE.with("newViewUI"))\
			 & (This:C1470.detailform)
			
			$bind.resize(This:C1470.manifest.fields.count)
			
			// No limit
			$affected:=New collection:C1472
			
		Else 
			
			$affected:=New collection:C1472.resize($bind.length)
			
		End if 
		
		//**********************************************************
		// Reorganize the binded fields
		For each ($element; $bind)
			
			CLEAR VARIABLE:C89($isCompatible)
			CLEAR VARIABLE:C89($field)
			
			// Find the binded element
			$node:=This:C1470.findById($element)
			
			If (This:C1470.success)
				
				$attributes:=This:C1470.getAttributes($node)
				ASSERT:C1129($attributes["ios:bind"]#Null:C1517)
				
			Else 
				
				// The multivalued fields share the same attributes
				// as the last field defined in the template
				
			End if 
			
			If (Match regex:C1019("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $attributes["ios:bind"]; 1))
				
				// Recognizes the "field [n]" and not the "searchableField"
				
				If ($attributes["ios:type"]="all")
					
					$isCompatible:=True:C214
					
				Else 
					
					// Check if the type is compatible
					$c:=Split string:C1554($attributes["ios:type"]; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
					
					If ($oIN.target.fields#Null:C1517)
						
						For each ($field; $oIN.target.fields) Until ($isCompatible)
							
							If ($field#Null:C1517)
								
								$o:=_o_structure(New object:C1471(\
									"action"; "fieldDefinition"; \
									"path"; $field.name; \
									"tableNumber"; Num:C11($oIN.tableNumber); \
									"catalog"; PROJECT.$project.$catalog))
								
								If ($o.success)
									
									If ($o.type=-2)  // 1-N relation
										
										$isCompatible:=This:C1470.isOfClass("multivalued"; $node)
										
									Else 
										
										$isCompatible:=This:C1470.isTypeAccepted($c; $o.fieldType)
										
									End if 
								End if 
							End if 
						End for each 
					End if 
				End if 
				
				If ($isCompatible)\
					 & ($field#Null:C1517)
					
					// Keep the field…
					$affected[$indx]:=$field
					
					// …& remove it to don't use again
					$oIN.target.fields.remove($oIN.target.fields.indexOf($field))
					
				End if 
				
				$indx:=$indx+1
				
			Else 
				
				// #SPECIAL FIELD ie 'searchableField' or 'sectionField'
				
				Case of 
						
						//______________________________________________________
					: ($attributes["ios:bind"]="searchableField")
						
						$isMultiCriteria:=(Split string:C1554($attributes.class; " ").indexOf("multi-criteria")#-1)
						
						$Lon_keyType:=Value type:C1509($oIN.target.searchableField)
						
						If ($Lon_keyType#Is undefined:K8:13)\
							 & ($Lon_keyType#Is null:K8:31)
							
							If ($Lon_keyType=Is collection:K8:32)
								
								// SOURCE IS MULTICRITERIA
								
								If ($oIN.target.searchableField.length>0)
									
									If ($isMultiCriteria)
										
										// Target is multi-criteria
										
										//#MARK_TODO Verify the type & remove incompatible if any
										For each ($o; $oIN.target.searchableField)
											
											// #MARK_TODO
											
										End for each 
										
										$cache.searchableField:=$oIN.target.searchableField
										
									Else 
										
										// Target is mono value -> keep the first compatible type
										$cache.searchableField:=$oIN.target.searchableField[0]
										
									End if 
								End if 
								
							Else 
								
								// SOURCE IS MONO VALUE
								
								If ($isMultiCriteria)
									
									// Target is multi-criteria -> don't modify if exist
									If ($Lon_keyType=Is null:K8:31)
										
										// #MARK_TODO Verify the type
										
										$cache.searchableField:=$oIN.target.searchableField
										
									End if 
									
								Else 
									
									// Target is mono value
									$cache.searchableField:=$oIN.target.searchableField
									
								End if 
							End if 
						End if 
						
						//______________________________________________________
					: ($attributes["ios:bind"]="sectionField")
						
						If ($oIN.target.sectionField#Null:C1517)
							
							$cache.sectionField:=$oIN.target.sectionField
							
						End if 
						
						//______________________________________________________
					Else 
						
						// #98417 - Remove in excess item from collection
						$affected.resize($affected.length-1)
						
						//______________________________________________________
				End case 
			End if 
		End for each 
		
		If (FEATURE.with("newViewUI"))\
			 & (This:C1470.manifest#Null:C1517)\
			 & (This:C1470.type="detail")\
			 & ($oIN.target.fields#Null:C1517)
			
			// Append the non affected fields
			$affected.combine($oIN.target.fields)
			
		End if 
		
		// Keep the field binding definition
		$cache.fields:=$affected
		//**********************************************************
		
	Else 
		
		// A "If" statement should never omit "Else"
		
	End if 
	
	This:C1470.close()
	
	//============================================================================
	// Enrich a binding with the fields already used during the session
Function enrich($fields : Collection; $previouslyUsedForms : Object)
	var $3 : Text
	var $form; $formNotToUse : Text
	var $use : Boolean
	var $o : Object
	
	If (Count parameters:C259>=3)
		
		$formNotToUse:=$3  // Default is empty
		
	End if 
	
	For each ($form; $previouslyUsedForms)
		
		If ($form#$formNotToUse)
			
			For each ($o; $previouslyUsedForms[$form].fields.filter("col_formula"; Formula:C1597($1.result:=($1.value#Null:C1517))))
				
				If ($fields.query("name = :1"; $o.name).pop()=Null:C1517)
					
					$fields.push($o)
					
				End if 
			End for each 
		End if 
	End for each 