
/* ============================================================================*/
Class constructor
	
	C_TEXT:C284($1)
	C_TEXT:C284($2)
	
	If (Count parameters:C259>0)
		
		This:C1470.name:=$1
		
		If (Count parameters:C259>1)
			
			This:C1470.type:=$2
			
		End if 
	End if 
	
/* ============================================================================*/
Function cancel
	
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
Function path
	
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
					
					RECORD.warning("Missing manifest: "+$fileManifest.path)
					
				End if 
				
			Else 
				
				RECORD.warning("Unmanaged form type: "+This:C1470.type)
				
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