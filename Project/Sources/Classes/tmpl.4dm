
/* ============================================================================*/
Class constructor
	
	C_TEXT:C284($1)
	C_TEXT:C284($2)
	
	C_OBJECT:C1216($file)
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$1
		This:C1470.title:=This:C1470.name
		
		  //%W-533.1
		If (This:C1470.name[[1]]="/")
			
			This:C1470.title:=Delete string:C232(This:C1470.title;1;1)
			
		End if 
		  //%W+533.1
		
		  // Set the display name
		This:C1470.title:=Replace string:C233(This:C1470.title;"form-detail-";"")
		This:C1470.title:=Replace string:C233(This:C1470.title;"form-list-";"")
		This:C1470.title:=Replace string:C233(This:C1470.title;SHARED.archiveExtension;"")
		
		If (Count parameters:C259>=2)
			
			This:C1470.type:=$2
			
			This:C1470.path:=This:C1470.path()
			
			If (Bool:C1537(This:C1470.path.exists))
				
				  // Load the manifest
				$file:=This:C1470.path.file("manifest.json")
				
				If ($file.exists)
					
					This:C1470.manifest:=JSON Parse:C1218($file.getText())
					
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
	
	C_OBJECT:C1216($0)
	
	C_TEXT:C284($t;$root;$node;$dom)
	
	ASSERT:C1129(Not:C34(Shift down:C543))
	
	If (Num:C11(This:C1470.manifest.renderer)<2)
		
		$t:=This:C1470.template
		$root:=DOM Parse XML variable:C720($t)
		
		If (Bool:C1537(OK))
			
			  // Remove mobile picture
			$node:=DOM Find XML element:C864($root;"/"+"/rect[contains(@class,'container')")
			
			If (Bool:C1537(OK))
				
				DOM REMOVE XML ELEMENT:C869($node)
				
			End if 
			
			  // Adjustments
			$node:=DOM Find XML element by ID:C1010($root;"bgcontainer")
			
			If (Bool:C1537(OK))
				
				DOM SET XML ATTRIBUTE:C866($node;\
					"transform";"translate(0,-50)")
				
			End if 
			
			DOM EXPORT TO VAR:C863($root;$t)
			DOM CLOSE XML:C722($root)
			
			  // Keep the modified template
			This:C1470.template:=$t
			
			  // Try to adapt the old template to the renderer v2
			$root:=DOM Parse XML variable:C720($t)
			
			If (Bool:C1537(OK))
				
				  // Remove cookery
				$node:=DOM Find XML element by ID:C1010($root;"cookery")
				
				If (Bool:C1537(OK))
					
					DOM REMOVE XML ELEMENT:C869($node)
					
				End if 
				
				  // Remove template for additional fields
				$node:=DOM Find XML element by ID:C1010($root;"f")
				
				If (Bool:C1537(OK))
					
					DOM REMOVE XML ELEMENT:C869($node)
					
				End if 
				
				  // Remove the fisrt multivalued field
				$node:=DOM Find XML element by ID:C1010($root;"multivalued")
				
				If (Bool:C1537(OK))
					
					DOM REMOVE XML ELEMENT:C869($node)
					
					$node:=DOM Find XML element:C864($root;"/"+"/rect[contains(@class,'bgcontainer')")
					
					If (Bool:C1537(OK))
						
						DOM REMOVE XML ELEMENT:C869($node)
						
						$node:=DOM Find XML element by ID:C1010($root;"bgcontainer")
						
						If (Bool:C1537(OK))
							
							DOM SET XML ATTRIBUTE:C866($node;\
								"id";"background";\
								"class";"background";\
								"ios:type";"all")
							
							If (Bool:C1537(OK))
								
								$dom:=DOM Create XML element:C865($node;"rect";\
									"class";"bgcontainer_v2";\
									"x";0;\
									"y";0)
								
								If (Bool:C1537(OK))
									
									$node:=DOM Insert XML element:C1083($node;$dom;0)
									
									If (Bool:C1537(OK))
										
										DOM REMOVE XML ELEMENT:C869($dom)
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End if 
				
				If (Bool:C1537(OK))
					
					Case of 
							
							  //____________________________
						: (This:C1470.title="parallaxHeader")\
							 | (This:C1470.title="Numbers")
							
							This:C1470.manifest.hOffset:=254
							
							  //____________________________
						: (This:C1470.title="cards")\
							 | (This:C1470.title="ClientDetail")
							
							This:C1470.manifest.hOffset:=136
							
							  //____________________________
						: (This:C1470.title="Circle")
							
							This:C1470.manifest.hOffset:=253
							
							  //____________________________
						: (This:C1470.title="dashboard")
							
							This:C1470.manifest.hOffset:=262
							
							  //____________________________
						: (This:C1470.title="InvoiceDetail")
							
							This:C1470.manifest.hOffset:=136
							
							  //____________________________
						: (This:C1470.title="LeftCutHeader")
							
							This:C1470.manifest.hOffset:=234
							
							  //____________________________
						: (This:C1470.title="ParallaxDetail")
							
							This:C1470.manifest.hOffset:=223
							
							  //____________________________
						: (This:C1470.title="RightCutHeader")
							
							This:C1470.manifest.hOffset:=273
							
							  //____________________________
						: (This:C1470.title="SimpleContact")
							
							This:C1470.manifest.hOffset:=118
							
							  //____________________________
						: (This:C1470.title="SimpleHeader")
							
							This:C1470.manifest.hOffset:=161
							
							
							  //____________________________
						Else 
							
							OK:=0
							
							  //____________________________
					End case 
					
					If (Bool:C1537(OK))
						
						  // Update the manifest
						This:C1470.manifest.renderer:=2
						This:C1470.manifest.fields.max:=0
						
						DOM EXPORT TO VAR:C863($root;$t)
						DOM CLOSE XML:C722($root)
						
						  // Keep the updated template
						This:C1470.template:=$t
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	$0:=This:C1470
	
/* ============================================================================*/
Function cancel  // Return the embedded cancel button used into the templates
	
	C_TEXT:C284($0)
	
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
	
	C_OBJECT:C1216($0)
	
	C_BOOLEAN:C305($success)
	C_TEXT:C284($t)
	C_OBJECT:C1216($archive;$error;$fileManifest;$o;$path)
	
	$t:=This:C1470.name
	
	If ($t[[1]]="/")  // Host database resources
		
		$t:=Delete string:C232($t;1;1)  // Remove initial slash
		
		If (feature.with("resourcesBrowser"))
			
			If (Path to object:C1547($t).extension=SHARED.archiveExtension)  // Archive
				
				$error:=err .hide()/* START HIDING ERRORS */
				$archive:=ZIP Read archive:C1637(path ["host"+This:C1470.type+"Forms"]().file($t))
				$error.show()/* STOP HIDING ERRORS */
				
				If ($archive#Null:C1517)
					
					$path:=$archive.root
					
				End if 
				
			Else 
				
				$path:=Folder:C1567(path ["host"+This:C1470.type+"Forms"]().folder($t).platformPath;fk platform path:K87:2)
				
			End if 
			
		Else 
			
			$path:=Folder:C1567(path ["host"+This:C1470.type+"Forms"]().folder($t).platformPath;fk platform path:K87:2)
			
		End if 
		
		$success:=Bool:C1537($path.exists)
		
		If ($success)
			
			  // Verify the structure validity
			$o:=path [This:C1470.type+"Forms"]()
			
			If ($o#Null:C1517)
				
				$fileManifest:=$o.file("manifest.json")
				
				If ($fileManifest.exists)
					
					$o:=JSON Parse:C1218($fileManifest.getText())
					
					If ($o.mandatory#Null:C1517)
						
						For each ($t;$o.mandatory) While ($success)
							
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
		
		$path:=Folder:C1567(path [This:C1470.type+"Forms"]().folder($t).platformPath;fk platform path:K87:2)
		
		  // We assume that our templates are OK!
		$success:=$path.exists
		
	End if 
	
	If ($success)
		
		$0:=$path
		
	Else 
		
		$0:=New object:C1471(\
			"exists";False:C215)
		
	End if 
	
/* ============================================================================*/
Function css
	
	C_OBJECT:C1216($0)
	
	$0:=path .templates().file("template.css")
	
/* ============================================================================*/
Function label
	
	C_TEXT:C284($0;$1)
	
	$0:=Get localized string:C991($1)
	
/* ============================================================================*/