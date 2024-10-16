// ============================================================================
Class extends svg  // xml -> svg -> tmpl
// ============================================================================

// ============================================================================
Class constructor($name : Text; $type : Text)
	
	Super:C1705()
	
	var $file : 4D:C1709.File
	
	This:C1470.upToDate:=False:C215
	This:C1470.android:=False:C215
	This:C1470.ios:=False:C215
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$name
		This:C1470.title:=This:C1470.name
		This:C1470.type:=Null:C1517
		
		If (Length:C16(This:C1470.name)>0)
			
			//%W-533.1
			If (This:C1470.name[[1]]="/")
				
				This:C1470.title:=Delete string:C232(This:C1470.title; 1; 1)
				
			End if 
			//%W+533.1
			
		End if 
		
		// Set the display name
		This:C1470.title:=Replace string:C233(This:C1470.title; "form-detail-"; "")
		This:C1470.title:=Replace string:C233(This:C1470.title; "form-list-"; "")
		This:C1470.title:=Replace string:C233(This:C1470.title; SHARED.archiveExtension; "")
		
		If (Count parameters:C259>=2)
			
			This:C1470.type:=$type
			
			This:C1470.sources:=This:C1470.getSources()
			
			If (Bool:C1537(This:C1470.sources.exists))
				
				// Load the manifest
				$file:=This:C1470.sources.file("manifest.json")
				
				If ($file.exists)
					
					This:C1470.manifest:=JSON Parse:C1218($file.getText())
					This:C1470.listform:=(String:C10(This:C1470.manifest.type)="listform")
					This:C1470.detailform:=(String:C10(This:C1470.manifest.type)="detailform")
					
					If (This:C1470.manifest.target#Null:C1517)
						
						This:C1470.ios:=(This:C1470.manifest.target.query("iOS != null").pop()#Null:C1517)
						This:C1470.android:=(This:C1470.manifest.target.query("android != null").pop()#Null:C1517)
						
					Else 
						
						// Check the folder structure to identify an iOS or Android template
						This:C1470.ios:=This:C1470.sources.folder("Sources").exists | This:C1470.sources.folder("ios").exists
						This:C1470.android:=This:C1470.sources.folder("app").exists | This:C1470.sources.folder("android").exists
						
					End if 
					
				Else 
					
					Logger.warning("Missing manifest for the template "+This:C1470.title)
					
				End if 
				
				// Load the svg template
				$file:=This:C1470.sources.file("template.svg")
				
				If ($file.exists)
					
					This:C1470.svg:=$file.getText()
					This:C1470.update()
					
				Else 
					
					Logger.warning("Missing svg for the template "+This:C1470.title)
					
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
	// Update the template if any
Function update()->$this : cs:C1710.tmpl
	
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
			//OK:=(OK=0) ? Num(This.isNotNull($root)) : 1
			
			If (Bool:C1537(OK))
				
				// Remove mobile picture
				$node:=DOM Find XML element:C864($root; "/"+"/rect[contains(@class,'container')]")
				
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
				//OK:=(OK=0) ? Num(This.isNotNull($root)) : 1
				
				If (Bool:C1537(OK))
					
					// Change the background
					$node:=DOM Find XML element:C864($root; "/"+"/rect[contains(@class,'bgcontainer')]")
					//OK:=(OK=0) ? Num(This.isNotNull($node)) : 1
					
					If (Bool:C1537(OK))
						
						DOM REMOVE XML ELEMENT:C869($node)
						
						$node:=DOM Find XML element by ID:C1010($root; "bgcontainer")
						//OK:=(OK=0) ? Num(This.isNotNull($node)) : 1
						
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
									//OK:=(OK=0) ? Num(This.isNotNull($node)) : 1
									
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
						: (This:C1470.listform)
							
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
								
							Else 
								
								This:C1470.warning:="Obsolete template"
								
							End if 
							
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
		
		This:C1470.load(This:C1470.svg)
		
		If (This:C1470.success)
			
			// Mark static fields & refuse 1 to N relation into static field for detail forms
			$count:=Num:C11(This:C1470.manifest.fields.count)
			
			For ($i; 1; $count; 1)
				
				$node:=This:C1470.findById("f"+String:C10($i))
				
				If (This:C1470.success)
					
					This:C1470.addClass("static"; $node)
					
					If (This:C1470.detailform)
						
						$t:=This:C1470.getBinding($node)
						
						If ($t="all")
							
							This:C1470.setAttribute("ios:type"; "-8859"; $node)
							
						Else 
							
							$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=Num:C11($1.value)))
							
							If ($c.every(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value<0))))
								
								$c.push(-8859)
								This:C1470.setAttribute("ios:type"; $c.join(","); $node)
								
							Else 
								
								// <NOTHING MORE TO DO>
								
							End if 
						End if 
					End if 
				End if 
			End for 
			
			If (This:C1470.listform)
				
				// Move the magnifying glass to front to allow interaction.
				
				$c:=This:C1470.findByAttribute(This:C1470.root; "class"; "magnifyingGlass")
				
				If (This:C1470.success)
					
					$node:=This:C1470.append(This:C1470.parent($c[0]; "g"); $c[0])
					
					If (This:C1470.success)
						
						DOM SET XML ATTRIBUTE:C866($node; "id"; "magnifyingGlass")
						
						If (Bool:C1537(OK))
							
							This:C1470.remove($c[0])
							
						End if 
					End if 
				End if 
			End if 
			
			This:C1470.svg:=This:C1470.getText()
			
		End if 
	End if 
	
	$this:=This:C1470
	
/* ============================================================================*/
Function getBinding($node : Text)->$binding : Text
	
	$binding:=String:C10(This:C1470.getAttribute($node; "ios:type"))
	
	//============================================================================
	// Return the embedded cancel button used into the templates
Function cancel() : Text
	
	If (UI.darkScheme)
		
		return ("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAelJREFUeJzsmD9OwzAUxjMwghADLOxwAFjyB6l"+\
			"CHKCcghvkCJyAvSfokLQFoQi6cASW7NggiipEBzaKP9euQiAkjZImlt5PsmIl7718jp/9klgWQRAEQRBEO/BGkwMnYL4dsEgcYyfgs0VjsTrnw6Zpnb/whvzICdmdEDkv0mALn6"+\
			"Z1W53xfMMN2JUd8i8lbCpazx7wLp50Z/y6iYa+N+DnuAYbORDhA1/EaES8N3zfEelxr4R/CtGXZ9F0O88PNrCVPvAVMRBrHZqX4Klp8XbIntwRP141Bnzgqwex1pmQaaPEnw7e9"+\
			"svGga8eBGJWqTETLD7kL1KgzJNPgxgynUTMtSzs5W4j8riqmIild6eqYv6JezM51LtNkQVbFMTSu1OtdUIVKQygl2XjhvxCpEP/5Pp5V59DH+dwLTM2t"+\
			"l+5oJlfte4lqKYqfbqZNkLoYpD8EcLR0Fd7fz/LD3VCFbqoHvWWnIE4b5qTgnFM9pOzkgYx1QzE9ai3MAA+w01QXf+z+/HUC4gHiKlqwqxa1QnqHID7MNlSA/ioVnUC4"+\
			"1OozCJ2bl/22rSIzd5GjS9kwOhXCWD8y5y8qcmv08D4Dxpg9CelZpWPepxr1Ud9EmN/q6RBncj7sQWbpnUSBEEQBEEovgEAAP//AwDX7M3qHyPFyQAAAABJRU5E"+"rkJggg==")
		
	Else 
		
		return ("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAYAAAA7MK6iAAAAAXNSR0IArs4c6QAAAuJJREFUSA3tlEtoU1EQhptHI4lp8FUMlIIPpH"+\
			"ZRixTdFYIIUrCBkJTQlCpEjFJw4UYRFaObVnEjWbhQqRgLtiG6koAiIiiKG0UkiRXrShHbQtNiJEnT+E3hykFyb+LGheTAMOf8Z2b+mblzT1NTYzU68L91wPS3Bfn9/l1ms7nf"+\
			"ZDLtxHcN8oX9E5vN9jQej/+oN17dxAMDAx0Qnl9ZWfESfBr5ipSQDRB3oOeR6NTUVBJdc9VFDOk+gscrlcoMEc9R3ZuJiYlFie7xeKytra1bSOoIxxFsriNnE4lEWe71Vk1"+\
			"iqRTnZ0gCOUXAn3rBAoHAQRK8y/0YdmN6doJbjC6lGqfTeY1gQnaIYAUj+3Q6Pd3V1TVHxRc6OzsfZjKZWT17s96F4LSwmyD95XL5DKRFwaLRqHl4eHit7GXREVtfX58M2ep"+\
			"iBu6Q6LTFYoloWDVtSEyAfpyy+Xz+reaczWbbCoXCA6b7QCgUWg9+z+VyhbR7SZBkE0hvOBxu0fA/tSExzrtxyKRSqd8tzuVy38HeMUy3lpeXH2PTjn6uBqbqF5y3Li0tuVRc3d"+\
			"cidlF1XnWQJEql0hUwk9Vq7UHHksnkR9WGqc9xtvOJrCqu7g2JqWqWitapDkNDQy4Ib4PPkUCcxC4zzb2qDbib86LD4VidC/VO2xsSE1Ra1s0AOTWHYrHoAJ+BOMhjcRh9g/Mm7V"+\
			"405/2oD8zCgoqre8P/mAHaRtWvCXSs3hfJ5/NtpCMv8RnHZ1QlU/eGFfPtpLKbyOjg4OBm1VFvz/c9zZ0Nn3E9G8ENicWAB0ReoAUm9z4d2CFYtRWJRJr5JBeZ6BGqPcFv9a2anYY"+\
			"ZtlozCgaD26lAnsJ2Al8l8CO32/0pFosVIZNO7OWTHEfvwe4kLRZbw1UXsUTwer0tdrv9KMRCYEMqgpPEqkD4iv2lycnJjOC1Vt3EWiBJgO/Yw5PYRhLNkM1D+p7WftZsGrrRgUYH/"+\
			"mkHfgG6PCOSHCtXRwAAAABJRU5ErkJggg==")
		
	End if 
	
	
Function fieldDescription($field : Object; $target : Object; $tableID : Text) : cs:C1710.field
	
	var $relation; $table : Object
	var $current; $dropped : Collection
	
	// Splits path for later
	$current:=Split string:C1554(String:C10($target.path); ".")
	$dropped:=Split string:C1554($field.path; ".")
	
	// Get current table
	$table:=Form:C1466.dataModel[$tableID]
	
	Case of 
			
			//______________________________________________________
		: ($field.kind="alias")
			
			// Check for the same root
			Case of 
					
					//……………………………………………………………………………………………………
				: ($current.length=$dropped.length)
					
					$field:=New object:C1471(\
						"kind"; "alias"; \
						"fieldType"; $field.fieldType; \
						"path"; $field.path; \
						"name"; $field.name)
					
					//……………………………………………………………………………………………………
				: ($current.length=1)\
					 & ($dropped.length=2)  // A field droped on a relation
					
					If ($target.kind="relatedEntity") || ($target.fieldType=8858)  // 1 -> N relation
						
						If ($current[0]=$dropped[0])  // Same related table
							
							$relation:=$table[$target.name]
							
							// Switch to relation & update the long label
							$field:=New object:C1471(\
								"kind"; "relatedEntity"; \
								"name"; $dropped[0]; \
								"path"; $dropped[0]; \
								"relatedDataClass"; $relation.relatedDataClass; \
								"relatedTableNumber"; $relation.relatedTableNumber; \
								"inverseName"; $relation.inverseName)
							
							$relation.label:="%"+$dropped[1]+"%"
							
						End if 
					End if 
					
					//……………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
		: ($field.kind="relatedEntity")  // N -> 1 relation
			
			If (Bool:C1537($target.kind="relatedEntities"))
				
				// Replace
				OB REMOVE:C1226($field; "path")
				
			Else 
				
				If ($current.length=2)\
					 & ($dropped.length=1)  // Drop a relation on a field
					
					If ($current[0]=$dropped[0])  // Same related table
						
						// Keep the droped relation & update the long label
						$relation:=$table[$dropped[0]]
						$relation.label:="%"+$current[1]+"%"
						
					End if 
				End if 
			End if 
			
			//______________________________________________________
		: ($field.kind="relatedEntities")  // 1 -> N relation
			
			//TODO: Remove isToMany
			//OB REMOVE($dropped; "isToMany")
			
			//______________________________________________________
		: ($target=Null:C1517)  // Add
			
			// <NOTHING MORE TO DO>
			
			//______________________________________________________
		Else 
			
			// Check for the same root
			Case of 
					
					//……………………………………………………………………………………………………
				: ($current.length=$dropped.length)
					
					// Replace
					
					//……………………………………………………………………………………………………
				: ($current.length=1)\
					 & ($dropped.length=2)  // A field droped on a relation
					
					If ($target.kind="relatedEntity") || ($target.fieldType=8858)  // 1 -> N relation
						
						If ($current[0]=$dropped[0])  // Same related table
							
							$relation:=$table[$target.name]
							
							// Switch to relation & update the long label
							$field:=New object:C1471(\
								"kind"; "relatedEntity"; \
								"name"; $dropped[0]; \
								"path"; $dropped[0]; \
								"relatedDataClass"; $relation.relatedDataClass; \
								"relatedTableNumber"; $relation.relatedTableNumber; \
								"inverseName"; $relation.inverseName)
							
							$relation.label:="%"+$dropped[1]+"%"
							
						End if 
					End if 
					
					//……………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	return $field
	
	//============================================================================
/* Utility function to get the data:image/png;base64
	
Use it to populate the .cancel() values
	
cs.tmpl.new()._getPictureAsData()
	
will put the data into the pasteboard
	
*/
Function _getPictureAsData()
	
	var $picture : Picture
	var $c : Collection
	var $svg : cs:C1710.svg
	
	READ PICTURE FILE:C678(""; $picture)
	
	If (Bool:C1537(OK))
		
		$svg:=cs:C1710.svg.new().image($picture)
		$c:=$svg.findByName($svg.root; "image")
		
		If ($svg.success)
			
			SET TEXT TO PASTEBOARD:C523($svg.getAttribute($c[0]; "xlink:href"))
			
		End if 
		
		$svg.close()
		
	End if 
	
	//============================================================================
	// Return the source folder of the template (could be a zip)
Function getSources($name : Text; $type : Text)->$template : 4D:C1709.Folder
	
	var $formName; $formType; $item : Text
	var $success : Boolean
	var $o : Object
	var $folder : 4D:C1709.Folder
	var $manifest : 4D:C1709.File
	var $archive : 4D:C1709.ZipArchive
	var $error : cs:C1710.error
	
	If (Count parameters:C259>=2)
		
		$formName:=$name
		$formType:=$type
		
	Else 
		
		$formName:=This:C1470.name
		$formType:=This:C1470.type
		
	End if 
	
	$template:=DummyFile()  // folder
	
	If (Length:C16($formName)>0)
		
		If ($formName[[1]]="/")  // Host database resources
			
			$formName:=Delete string:C232($formName; 1; 1)  // Remove initial slash
			
			If (GetFileExtension($formName)=SHARED.archiveExtension)  // Archive
				
				$error:=cs:C1710.error.new().hide()
				$archive:=ZIP Read archive:C1637(cs:C1710.path.new()["host"+$formType+"Forms"]().file($formName))
				$error.show()
				
				If ($archive#Null:C1517)
					
					$template:=$archive.root
					
				End if 
				
			Else 
				
				$template:=Folder:C1567(cs:C1710.path.new()["host"+$formType+"Forms"]().folder($formName).platformPath; fk platform path:K87:2)
				
			End if 
			
			$success:=Bool:C1537($template.exists)
			
			If ($success)
				
				// Verify the structure validity
				$folder:=cs:C1710.path.new()[$formType+"Forms"]()
				
				If ($folder#Null:C1517)
					
					$manifest:=$folder.file("manifest.json")
					
					If ($manifest.exists)
						
						$o:=JSON Parse:C1218($manifest.getText())
						
						If ($o.mandatory#Null:C1517)
							
							For each ($item; $o.mandatory) While ($success)
								
								$success:=$template.file($item).exists | \
									$template.folder("ios").file($item).exists  // To support ios/Sources/...
								
							End for each 
							
						Else 
							
							Logger.warning("No mandatory for: "+$manifest.path)
							
						End if 
						
					Else 
						
						Logger.error("Missing manifest: "+$manifest.path)
						
					End if 
					
				Else 
					
					Logger.error("Unmanaged form type: "+$formType)
					
				End if 
			End if 
			
		Else 
			
			// 👅 We assume that the integrated templates are well-formed!
			$template:=Folder:C1567(cs:C1710.path.new()[$formType+"Forms"]().folder($formName).platformPath; fk platform path:K87:2)
			
		End if 
	End if 
	
	//============================================================================
	// Gives the path to the css file
Function css()->$file : 4D:C1709.File
	
	If (UI.darkScheme)
		
		$file:=File:C1566("/RESOURCES/css/template_dark.css")
		
	Else 
		
		$file:=File:C1566("/RESOURCES/css/template.css")
		
	End if 
	
/* ============================================================================*/
Function label($resname : Text)->$localized : Text
	
	$localized:=Get localized string:C991($resname)
	
	//============================================================================
	// Check that a field type is validated against the bind attribute
Function isTypeAccepted($bind : Variant; $type : Integer)->$accepted : Boolean
	var $c : Collection
	
	If (Asserted:C1132(Count parameters:C259>=2; "Missing parameter"))
		
		Case of 
				
				//___________________________
			: (Value type:C1509($bind)=Is text:K8:3)
				
				If ($bind="all")
					
					$accepted:=True:C214
					
				Else 
					
					$c:=Split string:C1554($bind; ","; sk trim spaces:K86:2).map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=Num:C11($1.value)))
					
				End if 
				
				//___________________________
			: (Value type:C1509($bind)=Is collection:K8:32)
				
				$c:=$bind
				
				//___________________________
			Else 
				
				ASSERT:C1129(False:C215; "$1 must be a text or a collection")
				
				//___________________________
		End case 
		
		If ($c#Null:C1517)
			
			If ($c.every(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value>=0))))
				
				// One of them
				$accepted:=($c.indexOf(Num:C11($type))#-1)
				
			Else 
				
				// None of them
				$accepted:=($c.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value=-Num:C11($type)))).length=0)
				
			End if 
		End if 
	End if 
	
	//============================================================================
Function truncateLabelIfTooBig($o : Object)
	
	var $buffer : Text
	var $width : Integer
	var $font : Object
	var $svg : cs:C1710.svg
	
	// Mark: Must be recovered from the css file
	$font:=New object:C1471(\
		"fontFamily"; "sans-serif"; \
		"size"; 12)
	
	$svg:=cs:C1710.svg.new()
	
	$width:=$svg.getTextWidth($o.label; $font)
	
	If ($o.avalaibleWidth>0)\
		 & ($width>$o.avalaibleWidth)
		
		$buffer:=$o.label
		
		While ($width>$o.avalaibleWidth)
			
			$buffer:=Delete string:C232($buffer; Length:C16($buffer)-1; 2)
			$width:=$svg.getTextWidth($buffer; $font)
			
		End while 
		
		$svg.close()
		
		// Add an ellipsis
		$buffer:=$buffer+"…"
		
		// And set the tips
		$o.tips:=$o.label
		$o.label:=$buffer
		
	End if 
	
	//============================================================================
	/// Add a "one field" widget to the template
Function appendOneField($index : Integer; $field : cs:C1710.field; $context : Object; $background : Text; $offset : Integer)->$height : Integer
	
	var $found : Boolean
	var $class; $label; $name; $node; $style; $t : Text
	var $tips : Text
	var $o; $relation : Object
	var $xml : cs:C1710.xml
	var $paths : Collection
	
	If ($field.kind="relatedEntity")\
		 || ($field.kind="relatedEntities")
		
		$style:="italic"
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($field.kind="storage")
			
			$label:=$field.name
			
			If (Position:C15("."; $label)>0)
				
				$paths:=Split string:C1554($label; ".")
				$paths.pop()
				$paths.push(String:C10($field.fieldNumber))
				
				If (Not:C34(cs:C1710.ob.new(PROJECT.dataModel[$context.tableNumber]).exists($paths)))
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
				
			Else 
				
				If (PROJECT.dataModel[$context.tableNumber][String:C10($field.fieldNumber)]=Null:C1517)
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
				
			End if 
			//______________________________________________________
		: ($field.kind="alias")
			
			$label:=$field.name
			$tips:=$field.path
			
			If (Not:C34(PROJECT.fieldAvailable($context.tableNumber; $field)))
				
				$class:="error"
				$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
				
			End if 
			
			//______________________________________________________
		: ($field.kind="calculated")
			
			$label:=$field.name
			
			If (Position:C15("."; $label)>0)
				
				$paths:=Split string:C1554($label; ".")
				
				If (Not:C34(cs:C1710.ob.new(PROJECT.dataModel[$context.tableNumber]).exists($paths)))
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
				
			Else 
				
				If (PROJECT.dataModel[$context.tableNumber][$field.name]=Null:C1517)
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
			End if 
			
			//______________________________________________________
		: ($field.kind="relatedEntity")
			
			$relation:=PROJECT.dataModel[$context.tableNumber][$field.name]
			
			$tips:=String:C10($relation.label)
			
			If (Match regex:C1019("(?m-si)^%.*%$"; $tips; 1))
				
				$name:=Substring:C12($tips; 2; Length:C16($tips)-2)
				$label:=$field.name+" ("+$name+")"
				$tips:=$field.name+"."+$name
				
				// Check that the discriminant field is published
				If ($relation#Null:C1517)
					
					For each ($t; $relation)
						
						If (Value type:C1509($relation[$t])#Is object:K8:27)
							
							continue
							
						End if 
						
						$o:=$relation[$t]
						
						If (String:C10($o.name)=$name) || (($o#Null:C1517)\
							 & ($t=$name))
							
							$found:=True:C214
							break
							
						End if 
					End for each 
					
					If (Not:C34($found))
						
						$class:="error"
						$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
						
					End if 
					
				Else 
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($name))
					
				End if 
				
			Else 
				
				$label:=$field.name
				
			End if 
			
			$label:=UI.str.setText(UI.toOne).concat($label)
			
			//______________________________________________________
		: ($field.kind="relatedEntities")
			
			$tips:=$field.label
			$label:=UI.str.setText(UI.toMany).concat($field.name)
			
			//mark:ACI0103031
			$paths:=Split string:C1554($field.name; ".")
			
			If ($paths.length>1)
				
				If (PROJECT.dataModel[$context.tableNumber][$paths[0]][$paths[1]]=Null:C1517)
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
				
			Else 
				
				If (PROJECT.dataModel[$context.tableNumber][$field.name]=Null:C1517)
					
					$class:="error"
					$tips:=UI.str.setText(UI.alert).concat(cs:C1710.str.new("theFieldIsNoMorePublished").localized($label))
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			oops
			
			//______________________________________________________
	End case 
	
	$o:=New object:C1471(\
		"label"; $label; \
		"tips"; $tips; \
		"avalaibleWidth"; 180)
	
	This:C1470.truncateLabelIfTooBig($o)
	
	// Set ids, label & position
	PROCESS 4D TAGS:C816(This:C1470.oneField.definition; $t; New object:C1471(\
		"index"; $index; \
		"name"; UI.str.setText($o.label).xmlSafe(); \
		"offset"; 5+$offset; \
		"style"; $style; \
		"class"; $class; \
		"tips"; cs:C1710.str.new($o.tips).xmlSafe()))
	
	// Append the widget
	$xml:=cs:C1710.xml.new($t)
	
	If (let(->$node; Formula:C1597($xml.findByXPath("/svg/g")); Formula:C1597($xml.success)))
		
		$node:=DOM Append XML element:C1082($background; $node)
		
	End if 
	
	$xml.close()
	
	$height:=Num:C11(This:C1470.oneField.manifest.height)  // Returns the widget height
	
	//============================================================================
	//
Function getCookery()->$cookery : Text
	var $node : Text
	
	$node:=This:C1470.findById("cookery")
	
	If (This:C1470.success)
		
		$cookery:=This:C1470.getAttribute($node; "ios:values")
		
	End if 
	
	//============================================================================
	// Reorder the fields used when the user changes model (alias tmpl_REORDER)
Function reorder($tableID : Text)  //#WIP
	
	var $element; $node; $t : Text
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
		If (This:C1470.detailform)
			
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
			
			Case of 
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $attributes["ios:bind"]; 1))
					
					// Recognizes the "field [n]" and not the "searchableField"
					
					If ($attributes["ios:type"]="all")
						
						$isCompatible:=True:C214
						
					Else 
						
						// Check if the type is compatible
						$c:=Split string:C1554($attributes["ios:type"]; ","; sk trim spaces:K86:2).map(Formula:C1597(col_formula).source; Formula:C1597($1.result:=Num:C11($1.value)))
						
						If ($oIN.target.fields#Null:C1517)
							
							For each ($field; $oIN.target.fields) Until ($isCompatible)
								
								If ($field#Null:C1517)
									
									$isCompatible:=This:C1470.isTypeAccepted($c; Form:C1466.$project.ExposedStructure.fieldDefinition(Num:C11($tableID); $field.path).fieldType)
									
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
					
					//______________________________________________________
				: ($attributes["ios:bind"]="searchableField")
					
					$isMultiCriteria:=(Split string:C1554($attributes.class; " ").indexOf("multi-criteria")#-1)
					
					$Lon_keyType:=Value type:C1509($oIN.target.searchableField)
					
					If ($Lon_keyType#Is undefined:K8:13)\
						 & ($Lon_keyType#Is null:K8:31)
						
						If ($Lon_keyType=Is collection:K8:32)  // SOURCE IS MULTICRITERIA
							
							If ($oIN.target.searchableField.length>0)
								
								If ($isMultiCriteria)
									
									// Target is multi-criteria
									
									// #MARK_TODO Verify the type & remove incompatible if any
									For each ($o; $oIN.target.searchableField)
										
										// #MARK_TODO
										
									End for each 
									
									$cache.searchableField:=$oIN.target.searchableField
									
								Else 
									
									// Target is mono value -> keep the first compatible type
									$cache.searchableField:=$oIN.target.searchableField[0]
									
								End if 
							End if 
							
						Else   // SOURCE IS MONO VALUE
							
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
			
		End for each 
		
		If (This:C1470.manifest#Null:C1517)\
			 & (This:C1470.type="detail")\
			 & ($oIN.target.fields#Null:C1517)
			
			// Append the non affected fields
			$affected.combine($oIN.target.fields)
			
		End if 
		
		// Keep the field binding definition
		$cache.fields:=$affected
		//**********************************************************
		
	Else 
		
		// Not a list form
		
	End if 
	
	This:C1470.close()
	
	//============================================================================
	// Enrich a binding with the fields already used during the session
Function enrich($fields : Collection; $previouslyUsedForms : Object; $formNotToUse : Text)
	
	var $form : Text
	var $o : Object
	
	
	For each ($form; $previouslyUsedForms)
		
		If ($form#$formNotToUse)
			
			For each ($o; $previouslyUsedForms[$form].fields.filter(Formula:C1597(col_formula).source; Formula:C1597($1.result:=($1.value#Null:C1517))))
				
				If ($fields.query("name = :1"; $o.name).pop()=Null:C1517)
					
					$fields.push($o)
					
				End if 
			End for each 
		End if 
	End for each 