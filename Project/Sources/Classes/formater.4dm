//============================================================================
// Management of data formatters
//============================================================================
Class constructor($format : Text)
	
	This:C1470.name:=""
	This:C1470.label:=""
	This:C1470.host:=False:C215
	This:C1470.source:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		This:C1470.name:=$format
		
		If (Length:C16($format)>0)
			
			This:C1470.host:=($format[[1]]="/")  // Host database resources
			
			If (This:C1470.host)
				
				// Remove initial slash
				This:C1470.label:=Delete string:C232($format; 1; 1)
				
			End if 
			
			// Remove extension if any
			This:C1470.label:=Replace string:C233(This:C1470.label; SHARED.archiveExtension; "")
			
			This:C1470.sources()
			
		End if 
	End if 
	
	//============================================================================
	// Returns a collection of formaters for a field type
Function getByType($type : Integer; $host : Boolean)->$formatters : Collection
	
	var $hostƒ : Boolean
	var $archive; $errors; $manifest; $o : Object
	var $c : Collection
	var $resources : cs:C1710.path
	var $formator : 4D:C1709.Folder
	
	If (Count parameters:C259>=2)
		
		$hostƒ:=$host
		
	End if 
	
	If ($hostƒ)
		
		$formatters:=New collection:C1472
		$resources:=cs:C1710.path.new().hostFormatters()
		
		If ($resources.exists)
			
			$c:=New collection:C1472
			$c[Is alpha field:K8:1]:="text"
			$c[Is boolean:K8:9]:="boolean"
			$c[Is integer:K8:5]:="integer"
			$c[Is longint:K8:6]:="integer"
			$c[Is integer 64 bits:K8:25]:="integer"
			$c[Is real:K8:4]:="real"
			$c[_o_Is float:K8:26]:="float"
			$c[Is date:K8:7]:="date"
			$c[Is time:K8:8]:="time"
			$c[Is text:K8:3]:="text"
			$c[Is picture:K8:10]:="picture"
			
			For each ($formator; $resources.folders())
				
				$o:=cs:C1710.formater.new("/"+$formator.fullName)
				
				If ($o.isValid())
					
					$manifest:=JSON Parse:C1218($o.source.file("manifest.json").getText())
					
					If (Value type:C1509($manifest.type)=Is collection:K8:32)
						
						If ($manifest.type.indexOf($c[$type])#-1)
							
							$formatters.push(New object:C1471(\
								"name"; $o.label; \
								"source"; $o))
							
						End if 
						
					Else 
						
						If ($manifest.type=$c[$type])
							
							$formatters.push(New object:C1471(\
								"name"; $o.label; \
								"source"; $o))
							
						End if 
					End if 
				End if 
			End for each 
			
			$errors:=cs:C1710.error.new().hide()
			
			For each ($formator; $resources.files().query("extension = :1"; SHARED.archiveExtension))
				
				$o:=cs:C1710.formater.new("/"+$formator.fullName)
				
				If ($o.isValid())
					
					$manifest:=JSON Parse:C1218($o.source.file("manifest.json").getText())
					
					If (Value type:C1509($manifest.type)=Is collection:K8:32)
						
						If ($manifest.type.indexOf($c[$type])#-1)
							
							$formatters.push(New object:C1471(\
								"name"; $o.label; \
								"source"; $o))
							
						End if 
						
					Else 
						
						If ($manifest.type=$c[$type])
							
							$formatters.push(New object:C1471(\
								"name"; $o.label; \
								"source"; $o))
							
						End if 
					End if 
				End if 
			End for each 
			
			$errors.show()
			
		End if 
		
	Else 
		
		$formatters:=SHARED.resources.fieldBindingTypes[$type]
		
	End if 
	
	//============================================================================
	// Returns the source folder (may be a zip)
Function sources($format : Text)->$sources : 4D:C1709.Folder
	
	var $formatName; $formType; $item : Text
	var $success : Boolean
	var $o : Object
	var $folder; $path : 4D:C1709.Folder
	var $manifest : 4D:C1709.File
	var $archive : 4D:C1709.ZipArchive
	var $error : cs:C1710.error
	
	If (Count parameters:C259>=1)
		
		$formatName:=$format
		
	Else 
		
		// Interbnal
		$formatName:=This:C1470.name
		
	End if 
	
	$sources:=Folder:C1567("😱")
	
	If ($formatName[[1]]="/")  // Host database resources
		
		$formatName:=Delete string:C232($formatName; 1; 1)  // Remove initial slash
		
		If (Path to object:C1547($formatName).extension=SHARED.archiveExtension)  // Archive
			
			$error:=cs:C1710.error.new().hide()
			$archive:=ZIP Read archive:C1637(cs:C1710.path.new().hostFormatters().file($formatName))
			$error.show()
			
			If ($archive#Null:C1517)
				
				$sources:=$archive.root
				
			End if 
			
		Else 
			
			$sources:=Folder:C1567(cs:C1710.path.new().hostFormatters().folder($formatName).platformPath; fk platform path:K87:2)
			
		End if 
		
		This:C1470.source:=$sources
		
	Else 
		
		// 👅 We assume that the integrated templates are well-formed!
		
	End if 
	
	//============================================================================
	// Tests if the formatter exists and is well-formed
Function isValid($format : Variant)->$valid : Boolean
	
	var $o : Object
	var $manifest : 4D:C1709.File
	var $sources : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		$sources:=This:C1470.sources($format)
		
	Else 
		
		If (Asserted:C1132(This:C1470.source#Null:C1517; "Missing format parameter"))
			
			$sources:=This:C1470.source
			
		End if 
	End if 
	
	$valid:=Bool:C1537($sources.exists)
	
	If ($valid)  // Verify the structure validity
		
		// A manifest is mandatory
		$manifest:=$sources.file("manifest.json")
		$valid:=$manifest.exists
		
		If ($valid)
			
			$o:=JSON Parse:C1218($manifest.getText())
			$valid:=($o.type#Null:C1517) & ($o.binding#Null:C1517)
			
		End if 
	End if 