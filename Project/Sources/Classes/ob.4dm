// #DEPENDENCIES : [{"method":"noError"}]

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($content)
	
	This:C1470.success:=True:C214
	This:C1470.content:=Null:C1517
	This:C1470.type:=Is object:K8:27
	This:C1470.class:=4D:C1709.Class
	This:C1470.prettyPrint:=True:C214
	This:C1470.tidyJson:=True:C214
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		This:C1470.setContent($content)
		
	Else 
		
		This:C1470.setContent()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set the container content
Function setContent($content)->$object : Object
	
	This:C1470.success:=True:C214
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($content)=Is object:K8:27)
				
				This:C1470.content:=$content
				
				//______________________________________________________
			: (Value type:C1509($content)=Is text:K8:3)
				
				This:C1470.content:=New object:C1471
				This:C1470._path($content; True:C214)
				
				//______________________________________________________
			Else 
				
				This:C1470.content:=Null:C1517
				This:C1470._pushError("The passed parameter must be an object or a text")
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Create an empty object
		This:C1470.content:=New object:C1471
		
	End if 
	
	This:C1470.type:=Value type:C1509(This:C1470.content)
	This:C1470.class:=OB Class:C1730(This:C1470.content)
	
	$object:=This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Load from a json file
Function load($file : 4D:C1709.file)->$object : Object
	
	var $methodCalledOnError : Text
	
	This:C1470.success:=OB Instance of:C1731($file; 4D:C1709.File)
	
	If (This:C1470.success)
		
		This:C1470.success:=$file.exists
		
		If (This:C1470.success)
			
			$methodCalledOnError:=Method called on error:C704
			ON ERR CALL:C155("noError")
			$object:=JSON Parse:C1218($file.getText())
			ON ERR CALL:C155($methodCalledOnError)
			
			This:C1470.success:=($object#Null:C1517)
			
			If (This:C1470.success)
				
				This:C1470.file:=$file
				This:C1470.content:=$object
				
			Else 
				
				This:C1470._pushError("Failed to parse json file ("+String:C10(ERROR)+"): "+$file.path)
				
			End if 
			
		Else 
			
			This:C1470._pushError("File not found: "+$file.path)
			
		End if 
		
	Else 
		
		This:C1470._pushError("The passed parameter is not a 4D File object")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Save to json file
Function save($file : 4D:C1709.file)
	
	//#MARK_TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deletes the content of the container
Function clear()
	
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	This:C1470.setContent()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the container content
Function getContent()->$content
	
	$content:=This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the object or the collection is empty 
Function isEmpty()->$empty : Boolean
	
	If (This:C1470.type=Is object:K8:27)
		
		$empty:=OB Is empty:C1297(This:C1470.content)
		
	Else 
		
		// Test collection length
		$empty:=(This:C1470.content.length=0)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Converts the container content into a JSON string
Function stringify($prettyPrint : Boolean)->$json : Text
	
	var $formatting : Boolean
	var $content : Object
	
	$formatting:=This:C1470.prettyPrint
	
	If (Count parameters:C259>=1)
		
		$formatting:=$prettyPrint
		
	End if 
	
	$content:=This:C1470.content
	
	If (This:C1470.tidyJson)
		
		$content:=This:C1470.tidy()
		
	End if 
	
	If ($formatting)
		
		// Improves the presentation
		$json:=JSON Stringify:C1217($content; *)
		
	Else 
		
		$json:=JSON Stringify:C1217($content)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isObject()->$is : Boolean
	
	$is:=This:C1470.type=Is object:K8:27
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isCollection()->$is : Boolean
	
	$is:=This:C1470.type=Is collection:K8:32
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests the equality against passed object
Function isEqual($object : Object)->$equal : Boolean
	
	$equal:=New collection:C1472(This:C1470.content).equal(New collection:C1472($object))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compare teh passed object to the embedded one
Function isShared()->$shared : Boolean
	
	$shared:=OB Is shared:C1759(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Defines the $path entry value
Function set($path; $value)->$object : Object
	
	If (Asserted:C1132(Count parameters:C259>=1; "Missing parameters"))
		
		If (Count parameters:C259>=2)
			
			If (Value type:C1509($path)=Is collection:K8:32)
				
				This:C1470._path($path.join("."); True:C214; $value)
				
			Else 
				
				This:C1470._path(String:C10($path); True:C214; $value)
				
			End if 
			
		Else 
			
			If (Value type:C1509($path)=Is collection:K8:32)
				
				This:C1470._path(String:C10($path); True:C214)
				
			Else 
				
				This:C1470._path(String:C10($path); True:C214)
				
			End if 
		End if 
	End if 
	
	$object:=This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the value of the element if the path exists, Null otherwise
	// If the path parameter is omitted, returns the content of the root object
Function get($path)->$value
	
	If (Count parameters:C259>=1)
		
		$value:=This:C1470._path($path)
		
	Else 
		
		// Returns the container content
		$value:=This:C1470.content
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Checks if the path exists and return True if so,
	// even if not contain any contents (not same result as comparison to Null)
Function exists($path)->$exists : Boolean
	
	var $i : Integer
	var $schemPtr : Pointer
	var $o; $schem; $sub : Object
	var $members : Collection
	var $member : Text
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		This:C1470.success:=(Value type:C1509($path)=Is collection:K8:32) | (Value type:C1509($path)=Is text:K8:3)
		
		If (This:C1470.success)
			
			If (This:C1470.type=Is object:K8:27)
				
				$members:=Choose:C955(Value type:C1509($path)=Is collection:K8:32; $path; Split string:C1554($path; "."))
				
				$o:=New object:C1471
				$schem:=$o
				$schemPtr:=->$schem
				
				For each ($member; $members)
					
					$schemPtr->type:="object"
					$schemPtr->required:=New collection:C1472
					$schemPtr->required[0]:=$member
					
					$i:=$i+1
					
					If (Match regex:C1019("(?m-si)^([^\\[]*)\\[(\\d*)]$"; $member; 1; $pos; $len))
						
						This:C1470.success:=False:C215
						This:C1470._pushError($members.join(".")+": checkPath() is not yet with collections")
						
					Else 
						
						If ($i<$members.length)
							
							$sub:=New object:C1471
							
							$schemPtr->properties:=New object:C1471
							$schemPtr->properties[$member]:=$sub
							
							$o:=$sub
							
							$schemPtr:=->$o
							
						End if 
					End if 
				End for each 
				
				$exists:=JSON Validate:C1456(This:C1470.content; $schem).success
				
			Else 
				
				This:C1470.success:=False:C215
				This:C1470._pushError("checkPath() is not yet available for collections")
				
			End if 
			
		Else 
			
			This:C1470._pushError("path must be a text or a collection")
			
		End if 
		
	Else 
		
		This:C1470._pushError("Missing path parameter")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Removes given key(s)
Function remove
	
	//#MARK_TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a path in the object if it not exist
Function createPath($path; $type : Integer)->$object : Object
	
	var $valueType : Integer
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing path parameter")
	
	$valueType:=Is object:K8:27
	
	If (Count parameters:C259>=2)
		
		$valueType:=$type
		
	End if 
	
	If (Value type:C1509($path)=Is collection:K8:32)
		
		This:C1470._path($path.join("."); True:C214; This:C1470._emptyValue($valueType))
		
	Else 
		
		This:C1470._path(String:C10($path); True:C214; This:C1470._emptyValue($valueType))
		
	End if 
	
	$object:=This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sorts the properties of the object in alphabetical order (like in the debugger)
Function tidy($object : Object)->$tidyObject : Object
	
	var $content; $o : Object
	var $c : Collection
	
	If (Count parameters:C259>=1)
		
		$content:=$object
		
	Else 
		
		// First internal call
		$content:=This:C1470.content
		
	End if 
	
	$tidyObject:=New object:C1471
	
	For each ($o; OB Entries:C1720($content).orderBy("key"))
		
		If (Value type:C1509($o.value)=Is object:K8:27)
			
			// --> RECURSIVE
			$tidyObject[$o.key]:=This:C1470.tidy($o.value)
			
		Else 
			
			$tidyObject[$o.key]:=$o.value
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Removes all Null entries fom an object, except for the collections
Function coalescence($object : Object)->$filtered : Object
	
	var $content; $o : Object
	
	If (Count parameters:C259>=1)
		
		$content:=$object
		
	Else 
		
		// First internal call
		$content:=This:C1470.content
		
	End if 
	
	$filtered:=New object:C1471
	
	For each ($o; OB Entries:C1720($content))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				// --> RECURSIVE
				$filtered[$o.key]:=This:C1470.coalescence($o.value)
				
			Else 
				
				$filtered[$o.key]:=$o.value
				
			End if 
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the first non NULL element
Function coalesce($object : Object)->$element
	
	var $key : Text
	var $content : Object
	
	If (Count parameters:C259>=1)
		
		$content:=$object
		
	Else 
		
		// Default
		$content:=This:C1470.content
		
	End if 
	
	For each ($key; $content) Until ($element#Null:C1517)
		
		If ($content[$key]#Null:C1517)
			
			$element:=$content[$key]
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Removes all empty object entries, except for the collections
Function removeEmptyValues($object : Object)->$filtered : Object
	
	var $content; $o : Object
	
	If (Count parameters:C259>=1)
		
		$content:=$object
		
	Else 
		
		// First internal call
		$content:=This:C1470.content
		
	End if 
	
	$filtered:=New object:C1471
	
	For each ($o; OB Entries:C1720($content))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				// --> RECURSIVE
				$filtered[$o.key]:=This:C1470.removeEmptyValues($o.value)
				
				If (OB Is empty:C1297($filtered[$o.key]))
					
					OB REMOVE:C1226($filtered; $o.key)
					
				End if 
				
			Else 
				
				$filtered[$o.key]:=$o.value
				
			End if 
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Clone the content
Function clone()->$clone : Object
	
	$clone:=OB Copy:C1225(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Copies the values ​​of all first level properties of the passed objects.
	// The common properties are overloaded according to the order of the parameters.
	// The Null values are ignored
Function assign
	
	//#MARK_TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Adds the missing properties of the passed objects.
Function merge($object : Object; $target : Object)
	
	var $key : Text
	var $content : Object
	
	If (Count parameters:C259=1)
		
		// First call
		$content:=This:C1470.content
		
	Else 
		
		$content:=$target
		
	End if 
	
	For each ($key; $object)
		
		If ($content[$key]=Null:C1517)
			
			$content[$key]:=$object[$key]
			
		Else 
			
			If (Value type:C1509($object[$key])=Is object:K8:27)
				
				// --> RECURSIVE
				This:C1470.merge($object[$key]; $content[$key])
				
			End if 
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Copy object properties from source to target [#WIP]
Function deepMerge
	
	//#MARK_TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Finds one or more properties and returns its value (s), if found
Function findPropertyValues
	
	//#MARK_TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Look in object hierarchy an object with a specific property
Function inHierarchy($property : Text; $parent : Text; $target : Object)->$object : Object
	
	var $content : Object
	
	If (Count parameters:C259<3)
		
		$content:=This:C1470.content
		
	Else 
		
		$content:=$target
		
	End if 
	
	
	Case of 
			
			//________________________________________
		: ($content=Null:C1517)
			
			$object:=Null:C1517
			
			//________________________________________
		: ($content[$property]#Null:C1517)
			
			$object:=$content
			
			//________________________________________
		Else 
			
			If (Count parameters:C259>1)
				
				// --> RECURSIVE
				$object:=This:C1470.inHierarchy($property; $parent; $content[$parent])
				
			Else 
				
				// --> RECURSIVE
				$object:=This:C1470.inHierarchy($property; "parent"; $content["parent"])
				
			End if 
			
			//________________________________________
	End case 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the count of first level keys
Function count()->$count : Integer
	
	$count:=OB Keys:C1719(This:C1470.content).length
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function entries()->$entries : Collection
	
	$entries:=OB Entries:C1720(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function keys()->$keys : Collection
	
	$keys:=OB Keys:C1719(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function values()->$values : Collection
	
	$values:=OB Values:C1718(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function instanceOf($class : Object)->$success : Boolean
	
	$success:=OB Instance of:C1731(This:C1470.content; $class)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] Compute the target path, Create and Set value if any
Function _path($path : Text; $set : Boolean; $value)->$result
	
	var $lastMember; $member : Text
	var $create; $last : Boolean
	var $indx : Integer
	var $content : Object
	var $members : Collection
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	If (Count parameters:C259>=2)
		
		$create:=$set
		
	End if 
	
	$members:=Split string:C1554($path; ".")
	This:C1470.success:=True:C214
	
	If (($members.length=1))
		
		If ($create)
			
			This:C1470.content[$path]:=Choose:C955(Count parameters:C259>=3; $value; Null:C1517)
			
		End if 
		
		$result:=This:C1470.content[$path]
		
	Else 
		
		$content:=This:C1470.content
		$lastMember:=$members[$members.length-1]
		
		For each ($member; $members) Until ($content=Null:C1517)
			
			If ($content[$member]=Null:C1517)
				
				$last:=($member=$lastMember)
				
				If (Not:C34($last))
					
					If (Match regex:C1019("(?m-si)^([^\\[]*)\\[(\\d*)]$"; $member; 1; $pos; $len))
						
						$indx:=Choose:C955(Size of array:C274($pos)>1; Num:C11(Substring:C12($member; $pos{2}; $len{2})); 0)
						$member:=Substring:C12($member; $pos{1}; $len{1})
						
						If ($content[$member]=Null:C1517)
							
							$content[$member]:=New collection:C1472
							
						End if 
						
						If ($indx>=$content[$member].length)
							
							If ($create)
								
								$content[$member][$indx]:=Null:C1517
								
								If (Count parameters:C259>=3)
									
									$content[$member][$indx]:=New object:C1471
									
								End if 
							End if 
						End if 
						
						$content:=$content[$member][$indx]
						
					Else 
						
						$content[$member]:=New object:C1471
						$content:=$content[$member]
						
					End if 
				End if 
				
			Else 
				
				$last:=($member=$lastMember)
				
				If (Not:C34($last))
					
					If (Value type:C1509($content[$member])#Is object:K8:27)
						
						$content[$member]:=New object:C1471
						
					End if 
					
					$content:=$content[$member]
					
				End if 
				
			End if 
		End for each 
		
		If ($last)
			
			If (Match regex:C1019("(?m-si)^([^\\[]*)\\[(\\d*)]$"; $member; 1; $pos; $len))
				
				$indx:=-1
				
				If (Size of array:C274($pos)>1)
					
					If (Length:C16(Substring:C12($member; $pos{2}; $len{2}))>0)
						
						$indx:=Num:C11(Substring:C12($member; $pos{2}; $len{2}))
						
					End if 
				End if 
				
				$member:=Substring:C12($member; $pos{1}; $len{1})
				
				If ($content[$member]=Null:C1517)
					
					$content[$member]:=New collection:C1472
					
				End if 
				
				If ($indx#-1)
					
					If (Count parameters:C259>=3)
						
						$content[$member][$indx]:=$value
						
					End if 
					
					$result:=$content[$member][$indx]
					
				End if 
				
			Else 
				
				If (Count parameters:C259>=3)
					
					$content[$member]:=$value
					
				Else 
					
					If ($create)
						
						$content[$member]:=Null:C1517
						
					End if 
				End if 
				
				$result:=$content[$member]
				
			End if 
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] Returns an empty value according to the desired type
Function _emptyValue($type : Integer)->$value
	
	Case of 
			
			//______________________________________________________
		: (Count parameters:C259<1)
			
			
			//______________________________________________________
		: ($type=Is object:K8:27)
			
			$value:=New object:C1471
			
			//______________________________________________________
		: ($type=Is collection:K8:32)
			
			$value:=New collection:C1472
			
			//______________________________________________________
		: ($type=Is text:K8:3)
			
			$value:=""
			
			//______________________________________________________
		: ($type=Is longint:K8:6)\
			 | ($type=Is real:K8:4)
			
			$value:=0
			
			//______________________________________________________
		: ($type=Is date:K8:7)
			
			$value:=!00-00-00!
			
			//______________________________________________________
		: ($type=Is time:K8:8)
			
			$value:=?00:00:00?
			
			//______________________________________________________
		: ($type=Is picture:K8:10)
			
			var $p : Picture
			$value:=$p
			
			//______________________________________________________
		Else 
			
			$value:=Null:C1517
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE]
Function _pushError($message : Text)
	
	This:C1470.success:=False:C215
	
	var $c : Collection
	$c:=Get call chain:C1662
	
	var $current; $o : Object
	
	For each ($o; $c) While ($current=Null:C1517)
		
		If (Position:C15("ob."; $o.name)#1)
			
			$current:=$o
			
		End if 
	End for each 
	
	If ($current#Null:C1517)
		
		If (Length:C16($message)>0)
			
			This:C1470.lastError:=$current.name+" - "+$message
			
		Else 
			
			// Unknown error
			This:C1470.lastError:=$current.name+" - Unknown error at line "+String:C10($current.line)
			
		End if 
		
	Else 
		
		If ($c.length>0)
			
			If (Length:C16($message)>0)
				
				This:C1470.lastError:=$c[1].name+" - "+$message
				
			Else 
				
				// Unknown error
				This:C1470.lastError:=$c[1].name+" - Unknown error at line "+String:C10($c[1].line)
				
			End if 
			
		Else 
			
			This:C1470.lastError:="Unknown but annoying error"
			
		End if 
	End if 
	
	This:C1470.errors.push(This:C1470.lastError)