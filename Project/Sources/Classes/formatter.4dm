/**
Management of dat a formatters
*/
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
	
	This:C1470.typeBinding:=New collection:C1472
	This:C1470.typeBinding[Is alpha field:K8:1]:="text"
	This:C1470.typeBinding[Is boolean:K8:9]:="boolean"
	This:C1470.typeBinding[Is integer:K8:5]:="integer"
	This:C1470.typeBinding[Is longint:K8:6]:="integer"
	This:C1470.typeBinding[Is integer 64 bits:K8:25]:="integer"
	This:C1470.typeBinding[Is real:K8:4]:="real"
	This:C1470.typeBinding[_o_Is float:K8:26]:="float"
	This:C1470.typeBinding[Is date:K8:7]:="date"
	This:C1470.typeBinding[Is time:K8:8]:="time"
	This:C1470.typeBinding[Is text:K8:3]:="text"
	This:C1470.typeBinding[Is picture:K8:10]:="picture"
	This:C1470.typeBinding[Is object:K8:27]:="object"
	
	//============================================================================
	/// Returns the embedded or host formatters available for a given field type.
Function getByType($type : Integer; $host : Boolean)->$formatters : Collection
	
	var $errors; $manifest : Object
	var $target : Collection
	var $formator; $resources : 4D:C1709.Folder
	var $o : cs:C1710.formatter
	
	$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
	
	If ($host)
		
		$formatters:=New collection:C1472
		$resources:=cs:C1710.path.new().hostFormatters()
		
		If ($resources.exists)
			
			$errors:=cs:C1710.error.new().hide()
			
			For each ($formator; $resources.folders().combine($resources.files().query("extension = :1"; SHARED.archiveExtension)))
				
				$o:=cs:C1710.formatter.new("/"+$formator.fullName)
				
				If ($o.isValid())
					
					$manifest:=JSON Parse:C1218($o.source.file("manifest.json").getText())
					$manifest.type:=(Value type:C1509($manifest.type)=Is collection:K8:32) ? $manifest.type : New collection:C1472(String:C10($manifest.type))
					
					If ($manifest.type.indexOf(This:C1470.typeBinding[$type])#-1)
						
						If ($manifest.target#Null:C1517)
							
							$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
							
						Else 
							
							This:C1470._createTarget($manifest; $o)
							
						End if 
						
						If (($manifest.target.length=2) & ($target.length=2))\
							 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))
							
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
Function sources($name : Text)->$sources : 4D:C1709.Folder
	
	var $archive : 4D:C1709.ZipArchive
	var $error : cs:C1710.error
	
	$name:=(Count parameters:C259>=1) ? $name : This:C1470.name
	
	$sources:=Folder:C1567("📁")
	
	If ($name[[1]]="/")  // Host database resources
		
		$name:=Delete string:C232($name; 1; 1)  // Remove initial slash
		
		If (Path to object:C1547($name).extension=SHARED.archiveExtension)  // Archive
			
			$error:=cs:C1710.error.new().hide()
			$archive:=ZIP Read archive:C1637(cs:C1710.path.new().hostFormatters().file($name))
			$error.show()
			
			If ($archive#Null:C1517)
				
				$sources:=$archive.root
				
				// Deal with archives that have an additional folder in the root
				// of the same name as the archive
				$name:=Path to object:C1547($name).name  // Remove the extension
				
				If ($sources.folder($name).exists)
					
					$sources:=$sources.folder($name)
					
				End if 
			End if 
			
		Else 
			
			$sources:=Folder:C1567(cs:C1710.path.new().hostFormatters().folder($name).platformPath; fk platform path:K87:2)
			
		End if 
		
		This:C1470.source:=$sources
		
	Else 
		
		// 👅 We assume that the integrated templates are well-formed!
		
	End if 
	
	//============================================================================
	/// Tests if the formatter exists and is well-formed
Function isValid($format)->$valid : Boolean
	
	var $sources : Object
	
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
		$valid:=$sources.file("manifest.json").exists
		
	End if 
	
	//============================================================================
	/// Create a formatter with text choiceList
Function create($type : Variant; $data : Collection)->$file : 4D:C1709.File
	
	//todo:Obsolete?
	ASSERT:C1129(False:C215)
	
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
	/// Return a default choice list according to type and wanted return type
Function defaultChoiceList($typeString : Text; $isObject : Boolean)->$choiceList : Variant
	
	//todo:Obsolete?
	ASSERT:C1129(False:C215)
	
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
	/// Return toolTip for custom format
Function toolTip($target)->$tip : Text
	
	// Fixme: UI function, so class is UI dependant
	
	var $bind; $o : Object
	var $file : 4D:C1709.File
	
	If (PROJECT.isCustomResource(This:C1470.name))
		
		$file:=EDITOR.path[$target]().folder(Delete string:C232(This:C1470.name; 1; 1)).file("manifest.json")
		
		// TODO: If zip formatter, fix file path (read in zip SHARED.archiveExtension)
		
		If ($file.exists)
			
			$o:=JSON Parse:C1218($file.getText())
			
			If ($o.choiceList#Null:C1517)
				
				$tip:=cs:C1710.str.new(JSON Stringify:C1217($o.choiceList; *)).jsonSimplify()
				
			End if 
		End if 
		
	Else 
		
		// TODO: Edit resources.json to add "tips" to formatters in fieldBindingTypes
		
		If (SHARED.resources.formattersByName=Null:C1517)
			
			SHARED.resources.formattersByName:=New object:C1471
			
			For each ($bind; SHARED.resources.fieldBindingTypes\
				.reduce("col_formula"; New collection:C1472(); Formula:C1597($1.accumulator.combine(Choose:C955($1.value=Null:C1517; New collection:C1472(); $1.value)))))
				
				SHARED.resources.formattersByName[$bind.name]:=$bind
				
			End for each 
		End if 
		
		$tip:=String:C10(SHARED.resources.formattersByName[This:C1470.name].tips)
		
	End if 
	
	// MARK:-[PRIVATE]
	//============================================================================
	/// Create the "target" property according to the folders found
Function _createTarget($manifest : Object; $formater : cs:C1710.formatter)
	
	var $android; $ios : Boolean
	var $c : Collection
	
	$manifest.target:=New collection:C1472
	
	$c:=$formater.source.folders()
	$android:=($c.query("name = android").pop()#Null:C1517)
	$ios:=($c.query("name = ios").pop()#Null:C1517)
	
	Case of 
			
			//_______________________________________
		: ($android & $ios)
			
			$manifest.target.push("ios")
			$manifest.target.push("android")
			
			//_______________________________________
		: ($android)
			
			$manifest.target.push("android")
			
			//_______________________________________
		: ($ios)
			
			$manifest.target.push("ios")
			
			//_______________________________________
		Else 
			
			If ($c.query("name = Sources").pop()#Null:C1517)
				
				// Old formatter structure
				$manifest.target.push("ios")
				
			Else 
				
				// For all targets if format without code
				$manifest.target.push("ios")
				$manifest.target.push("android")
				
			End if 
			
			//_______________________________________
	End case 