/* ============================================================================*/
Class constructor
	var $1 : Text
	var $2 : Text
	
	var $file : Object
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$1
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
			
			This:C1470.type:=$2
			
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
					
					This:C1470.template:=$file.getText()
					
				Else 
					
					RECORD.warning("Missing svg for the template "+This:C1470.title)
					
				End if 
			End if 
			
		Else 
			
			// Call from PROCESS 4D TAGS
			
		End if 
	End if 
	
/* ============================================================================*/
Function load  // Load and update the template if any
	var $0 : Object
	
	var $dom; $node; $root; $t : Text
	var $succes : Boolean
	var $count; $i : Integer
	var $o : Object
	var $c : Collection
	
	ASSERT:C1129(Not:C34(Shift down:C543))
	
	If (Num:C11(This:C1470.manifest.renderer)<2)
		
		$t:=This:C1470.template
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
			This:C1470.template:=$t
			
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
					: (This:C1470.listform) & (feature.with("moreRelations"))
						
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
							This:C1470.template:=$t
							
						Else 
							
							This:C1470.warning:="Obsolete template"
							
						End if 
						
						//______________________________________________________
					: (Not:C34(feature.with("moreRelations")))
						
						//
						
						//______________________________________________________
					: (This:C1470.listform)
						
						// Update the manifest
						This:C1470.manifest.renderer:=2
						
						// Keep the updated template
						DOM EXPORT TO VAR:C863($root; $t)
						This:C1470.template:=$t
						
						//______________________________________________________
					Else 
						
						This:C1470.warning:="Missing template type"
						
						//______________________________________________________
				End case 
				
				DOM CLOSE XML:C722($root)
				
			End if 
		End if 
	End if 
	
	$0:=This:C1470
	
/* ============================================================================*/
Function getBinding
	var $0 : Text
	var $1 : Text
	
	var $o : Object
	
	$o:=xml_attributes($1)
	
	If ($o["ios:type"]#Null:C1517)
		
		$0:=$o["ios:type"]
		
	End if 
	
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
		
		If (feature.with("resourcesBrowser"))
			
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
	
/* ============================================================================*/