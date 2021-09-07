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
	var $formator; $resources : 4D:C1709.Folder
	
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
	
	//============================================================================
	// Create a formatter with text choiceList
Function create($type : Variant; $data : Collection)->$file : 4D:C1709.File
	
	var $name : Text
	$name:=This:C1470.name
	If (Bool:C1537(This:C1470.host))
		$name:=Substring:C12($name; 2)  // remove slash
	Else 
		// Assert?
		$name:=""
	End if 
	
	var $typeString : Text
	Case of 
		: (Value type:C1509($type)=Is real:K8:4)
			
			var $c : Collection
			$c:=New collection:C1472  // CLEAN , factorize this code?
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
			
			$typeString:=$c[$type]
		: (Value type:C1509($type)=Is text:K8:3)
			$typeString:=$type
		Else 
			ASSERT:C1129(dev_Matrix; "Unknown type type "+String:C10(Value type:C1509($type)))
	End case 
	
	If (Length:C16($name)>0)
		
		var $formatFolder : 4D:C1709.Folder
		$formatFolder:=cs:C1710.path.new().hostFormatters(True:C214).folder($name)
		
		$file:=$formatFolder.file("manifest.json")
		
		If (Not:C34($file.exists))  // else could assert if exists but ..
			
			$formatFolder.create()
			
			var $manifest : Object
			$manifest:=New object:C1471(\
				"name"; $name; \
				"$comment"; "Map database values to some display values using choiceList"; \
				"binding"; "localizedText")
			
			$manifest.choiceList:=This:C1470.defaultChoiceList($typeString; True:C214)
			Case of 
				: (($typeString="bool") | ($typeString="boolean"))
					$manifest.type:=New collection:C1472("boolean")
					$manifest.$doc:="https://developer.4d.com/4d-for-ios/docs/en/creating-data-formatter.html#integer-to-string"
				: (($typeString="number") | ($typeString="integer") | ($typeString="real"))
					If (Count parameters:C259>1)
						$manifest.choiceList:=New object:C1471()
						var $datum : Variant
						For each ($datum; $data)
							$manifest.choiceList[String:C10($datum)]:=String:C10($datum)
						End for each 
					End if 
					$manifest.type:=New collection:C1472("real"; "integer")
					$manifest.$doc:="https://developer.4d.com/4d-for-ios/docs/en/creating-data-formatter.html#integer-to-string"
				: (($typeString="string") | ($typeString="text"))
					If (Count parameters:C259>1)
						$manifest.choiceList:=New object:C1471()
						var $datum : Variant
						For each ($datum; $data)
							$manifest.choiceList[String:C10($datum)]:=String:C10($datum)
						End for each 
					End if 
					$manifest.type:=New collection:C1472("text")
					$manifest.$doc:="https://developer.4d.com/4d-for-ios/docs/en/creating-data-formatter.html#text-formatters"
				Else 
					ASSERT:C1129(dev_Matrix; "Missing binding for type "+String:C10($typeString)+" to create formatter")
			End case 
			
			$file.setText(JSON Stringify:C1217($manifest; *))
			This:C1470.sources()
			
		End if 
	End if 
	
	//============================================================================
	// Return a default choice list according to type and wanted return type
Function defaultChoiceList($typeString : Text; $isObject : Boolean)->$choiceList : Variant
	Case of 
		: (($typeString="bool") | ($typeString="boolean"))
			If ($isObject)
				$choiceList:=New object:C1471("0"; "False"; "1"; "True")
			Else 
				$choiceList:=New collection:C1472("False"; "True")
			End if 
		: (($typeString="number") | ($typeString="integer") | ($typeString="real"))
			If ($isObject)
				$choiceList:=New object:C1471("0"; "zero"; "1"; "one"; "2"; "two")
			Else 
				$choiceList:=New collection:C1472("zero"; "one"; "two")
			End if 
		: (($typeString="string") | ($typeString="text"))
			If ($isObject)
				$choiceList:=New object:C1471("value1"; "Displayed value1"; "value2"; "Displayed value2")
			Else 
				$choiceList:=New collection:C1472("Choice 1"; "Choice 2"; "Choice 3")
			End if 
		Else 
			If ($isObject)
				$choiceList:=New object:C1471()
			Else 
				$choiceList:=New collection:C1472()
			End if 
	End case 
	
	//============================================================================
	// Return toolTip for custom format
Function toolTip($target)->$tip : Text
	
	var $bind; $o : Object
	var $file : 4D:C1709.File
	
	If (PROJECT.isCustomResource(This:C1470.name))
		
		$file:=EDITOR.path[$target]().folder(Delete string:C232(This:C1470.name; 1; 1)).file("manifest.json")
		
		// #MARK_TODO : If zip formatter, fix file path (read in zip SHARED.archiveExtension)
		
		If ($file.exists)
			
			$o:=JSON Parse:C1218($file.getText())
			
			If ($o.choiceList#Null:C1517)
				
				$tip:=cs:C1710.str.new(JSON Stringify:C1217($o.choiceList; *)).jsonSimplify()
				
			End if 
		End if 
		
	Else 
		
		// #MARK_TODO : edit resources.json to add "tips" to formatters in fieldBindingTypes
		
		If (SHARED.resources.formattersByName=Null:C1517)
			
			SHARED.resources.formattersByName:=New object:C1471
			
			For each ($bind; SHARED.resources.fieldBindingTypes\
				.reduce("col_formula"; New collection:C1472(); Formula:C1597($1.accumulator.combine(Choose:C955($1.value=Null:C1517; New collection:C1472(); $1.value)))))
				
				SHARED.resources.formattersByName[$bind.name]:=$bind
				
			End for each 
		End if 
		
		$tip:=String:C10(SHARED.resources.formattersByName[This:C1470.name].tips)
		
	End if 