// #DEPENDENCIES : [{"method":"noError"}]

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($content)
	
	This:C1470.success:=True:C214
	This:C1470.content:=Null:C1517
	This:C1470.prettyPrint:=True:C214
	This:C1470.tidyJson:=False:C215
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		This:C1470.setContent($content)
		
	Else 
		
		This:C1470.setContent()
		
	End if 
	
	//MARK:- 📌 COMPUTED ATTRIBUTES
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get type()->$att : Integer
	
	$att:=Value type:C1509(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get isObject()->$att : Boolean
	
	$att:=This:C1470.content#Null:C1517\
		 ? (Value type:C1509(This:C1470.content)=Is object:K8:27)\
		 : True:C214
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get isCollection()->$att : Boolean
	
	$att:=This:C1470.content#Null:C1517\
		 ? (Value type:C1509(This:C1470.content)=Is collection:K8:32)\
		 : False:C215
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get isEmpty()->$att : Boolean
	
	$att:=This:C1470.content#Null:C1517\
		 ? (Value type:C1509(This:C1470.content)=Is object:K8:27) ? OB Is empty:C1297(This:C1470.content) : (This:C1470.content.length=0)\
		 : True:C214
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get isShared()->$att : Boolean
	
	$att:=This:C1470.content#Null:C1517\
		 ? (OB Is shared:C1759(This:C1470.content))\
		 : False:C215
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// The count of first level keys
Function get count()->$att : Integer
	
	$att:=This:C1470.content#Null:C1517\
		 ? (OB Keys:C1719(This:C1470.content).length)\
		 : 0
	
	//MARK:- 📌 FUNCTIONS
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set the root content
Function setContent($content) : Object
	
	var $key : Text
	
	This:C1470.success:=True:C214
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($content)=Is object:K8:27)
				
				If (OB Instance of:C1731($content; 4D:C1709.File))
					
					This:C1470.load($content)
					
				Else 
					
					This:C1470.content:=$content
					
				End if 
				
				//______________________________________________________
			: (Value type:C1509($content)=Is text:K8:3)
				
				This:C1470.content:=New object:C1471
				This:C1470._path($content; True:C214)
				
				//______________________________________________________
			Else 
				
				This:C1470.content:=Null:C1517
				This:C1470._pushError("The content parameter must be an object, a 4D.File or a text")
				
				//______________________________________________________
		End case 
		
	Else 
		
		// Create if any
		This:C1470.content:=This:C1470.content || New object:C1471
		
		//
		For each ($key; This:C1470.content)
			
			OB REMOVE:C1226(This:C1470.content; $key)
			
		End for each 
	End if 
	
	return This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Load from a json file
Function load($file : 4D:C1709.File)->$object : Object
	
	var $methodCalledOnError : Text
	
	This:C1470.success:=OB Instance of:C1731($file; 4D:C1709.File)
	
	If (This:C1470.success)
		
		This:C1470.success:=$file.exists
		
		If (This:C1470.success)
			
			This:C1470._catchError(True:C214)
			$object:=JSON Parse:C1218($file.getText())
			This:C1470._catchError()
			
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
Function save($file : 4D:C1709.File; $prettyPrint : Boolean)
	
	ASSERT:C1129($file#Null:C1517 ? OB Instance of:C1731($file; 4D:C1709.File) : True:C214)
	
	$file:=$file=Null:C1517 ? This:C1470.file : $file
	
	This:C1470._catchError(True:C214)
	$file.setText(This:C1470.stringify(Count parameters:C259>=2 ? $prettyPrint : This:C1470.prettyPrint))
	This:C1470._catchError()
	
	If (ERROR#0)
		
		This:C1470._pushError("The file wasn't saved: error "+String:C10(ERROR))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deletes the content of the container
Function clear()
	
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	This:C1470.setContent()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the container content
	// equivalent to get() without parameter
Function getContent()->$content
	
	$content:=This:C1470.content
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Converts the container content into a JSON string
Function stringify($prettyPrint : Boolean)->$json : Text
	
	var $content : Object
	
	$content:=This:C1470.tidyJson ? This:C1470.tidy() : This:C1470.content
	$prettyPrint:=Count parameters:C259=0 ? This:C1470.prettyPrint : $prettyPrint
	$json:=$prettyPrint ? JSON Stringify:C1217($content; *) : JSON Stringify:C1217($content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Tests the equality against passed object
Function isEqual($object : Object)->$equal : Boolean
	
	$equal:=New collection:C1472(This:C1470.content).equal(New collection:C1472($object))
	
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
/** Checks if the path exists and return True if so,
even if not contain any contents (not same result as comparison to Null)
*/
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
				
				$members:=Value type:C1509($path)=Is collection:K8:32 ? $path : Split string:C1554(String:C10($path); ".")
				
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
						This:C1470._pushError($members.join(".")+": checkPath() is not yet available with collections")
						
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
				This:C1470._pushError("exists() is not yet available for collections")
				
			End if 
			
		Else 
			
			This:C1470._pushError("path must be a text or a collection")
			
		End if 
		
	Else 
		
		This:C1470._pushError("Missing path parameter")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deletes all intances of a property in the hierarchy (Deep mode)
Function remove($property : Text; $object : Object)->$result : Object
	
	var $key : Text
	var $intra : Boolean
	var $i : Integer
	var $v
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259<2
	$object:=$intra ? This:C1470.content : $object
	
	$result:=OB Copy:C1225($object)
	
	For each ($key; $result)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($result[$key])=Is object:K8:27)
				
				$result[$key]:=This:C1470.remove($property; $result[$key])
				
				//______________________________________________________
			: (Value type:C1509($result[$key])=Is collection:K8:32)
				
				$i:=0
				
				For each ($v; $result[$key])
					
					If (Value type:C1509($v)=Is object:K8:27)
						
						$result[$key][$i]:=This:C1470.remove($property; $v)
						
					End if 
					
					$i+=1
					
				End for each 
				
				//______________________________________________________
		End case 
	End for each 
	
	OB REMOVE:C1226($result; $property)
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns an object as a collection (does not explore in depth)
Function toCollection($target : Object)->$c : Collection
	
	var $key : Text
	
	$target:=$target=Null:C1517 ? This:C1470.content : $target
	
	$c:=New collection:C1472
	
	For each ($key; $target)
		
		$c.push($target[$key])
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Create a path in the object if it not exist
Function createPath($path; $type : Integer) : Object
	
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
	
	return This:C1470.content
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Sorts the properties of the object in alphabetical order (like in the debugger)
Function tidy($target : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259=0
	$target:=$intra ? This:C1470.content : $target
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($target).orderBy("key"))
		
		If (Value type:C1509($o.value)=Is object:K8:27)
			
			$result[$o.key]:=This:C1470.tidy($o.value)
			
		Else 
			
			$result[$o.key]:=$o.value
			
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Removes all Null entries fom an object, except for the collections
Function coalescence($target : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259=0
	$target:=$intra ? This:C1470.content : $target
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($target))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				$result[$o.key]:=This:C1470.coalescence($o.value)
				
			Else 
				
				$result[$o.key]:=$o.value
				
			End if 
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the first non NULL element
Function coalesce($target : Object)->$element
	
	var $key : Text
	
	$target:=Count parameters:C259=0 ? This:C1470.content : $target
	
	For each ($key; $target) Until ($element#Null:C1517)
		
		If ($target[$key]#Null:C1517)
			
			$element:=$target[$key]
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Removes all empty object entries, except for the collections
Function removeEmptyValues($target : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259=0
	$target:=$intra ? This:C1470.content : $target
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($target))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				$result[$o.key]:=This:C1470.removeEmptyValues($o.value)
				
				If (OB Is empty:C1297($result[$o.key]))
					
					OB REMOVE:C1226($result; $o.key)
					
				End if 
				
			Else 
				
				$result[$o.key]:=$o.value
				
			End if 
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Clone the content
Function clone($target : Object)->$result : Object
	
	$target:=Count parameters:C259=0 ? This:C1470.content : $target
	$result:=OB Copy:C1225($target)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
/** Copies the values ​​of all first level properties of the passed object.
- The common properties are overloaded
**/
Function assign($object : Object; $target : Object)->$result : Object
	
	var $key : Text
	var $intra : Boolean
	
	$intra:=Count parameters:C259<2
	$target:=$intra ? This:C1470.content : $target
	$result:=$target
	
	If ($object=Null:C1517)
		
		$result:=Null:C1517
		
	Else 
		
		$result:=$result=Null:C1517 ? New object:C1471 : $result
		
		For each ($key; $object)
			
			$result[$key]:=$object[$key]
			
		End for each 
	End if 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Adds the missing properties of the passed objects.
Function merge($object : Object; $target : Object)
	
	var $intra : Boolean
	var $key : Text
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259<2
	$target:=$intra ? This:C1470.content : $target
	
	For each ($key; $object)
		
		If ($target[$key]=Null:C1517)
			
			$target[$key]:=$object[$key]
			
		Else 
			
			If (Value type:C1509($object[$key])=Is object:K8:27)
				
				This:C1470.merge($object[$key]; $target[$key])
				
			End if 
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$target
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Copy object properties from source to target [NOT FINALIZED]
Function deepMerge($object : Object; $target : Object)->$result : Object
	
	var $key : Text
	var $intra : Boolean
	var $i : Integer
	var $v
	
	// MARK: ♻️ RECURSIVE
	
	$intra:=Count parameters:C259<2
	$target:=$intra ? This:C1470.content : $target
	$result:=$target=Null:C1517 ? New object:C1471 : $target
	
	If ($object#Null:C1517)
		
		For each ($key; $object)
			
			Case of 
					
					//……………………………………………………………………………………………………………………………
				: (Value type:C1509($object[$key])=Is object:K8:27)
					
					If ($result[$key]=Null:C1517)
						
						$result[$key]:=OB Copy:C1225($object[$key])
						
					Else 
						
						If (Value type:C1509($result[$key])#Is object:K8:27)
							
							$result[$key]:=New object:C1471
							
						End if 
						
						$result[$key]:=This:C1470.deepMerge(OB Copy:C1225($object[$key]); $result[$key])
						
					End if 
					
					//……………………………………………………………………………………………………………………………
				: (Value type:C1509($object[$key])=Is collection:K8:32)
					
					If ($result[$key]=Null:C1517)
						
						$result[$key]:=$object[$key].copy()
						
					Else 
						
						$result[$key]:=New collection:C1472.resize($object[$key].length)
						
						$i:=0
						
						For each ($v; $object[$key])
							
							Case of 
									
									//_________________________________
								: (Value type:C1509($v)=Is object:K8:27)
									
									Case of 
											
											//..........................
										: ($result[$key][$i]=Null:C1517)
											
											$result[$key][$i]:=OB Copy:C1225($v)
											
											//..........................
										: (Value type:C1509($result[$key][$i])=Is object:K8:27)
											
											$result[$key][$i]:=This:C1470.deepMerge(OB Copy:C1225($v); $result[$key][$i])
											
											//..........................
										: (Value type:C1509($result[$key][$i])=Is collection:K8:32)
											
											If (Not:C34($result[$key][$i].equal($result[$key][$i]; ck diacritical:K85:3)))
												
												// TODO:🚧 NOT FINALIZED
												TRACE:C157
												
											End if 
											
											//..........................
										Else 
											
											$result[$key][$i]:=$v
											
											//..........................
									End case 
									
									//_________________________________
								: (Value type:C1509($v)=Is collection:K8:32)
									
									// TODO:🚧 NOT FINALIZED
									TRACE:C157
									
									//_________________________________
								Else 
									
									$result[$key]:=$object[$key]
									
									//_________________________________
							End case 
							
							$i+=1
							
						End for each 
					End if 
					
					//……………………………………………………………………………………………………………………………
				Else 
					
					$result[$key]:=$object[$key]
					
					//……………………………………………………………………………………………………………………………
			End case 
		End for each 
	End if 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Finds one or more properties and returns its value (s), if found
Function findPropertyValues($property : Text; $target : Object)->$values : Collection
	
	var $key : Text
	var $v
	
	// MARK: ♻️ RECURSIVE
	
	$target:=Count parameters:C259<2 ? This:C1470.content : $target
	$values:=New collection:C1472
	
	For each ($key; $target)
		
		If ($key=$property)
			
			$values.push($target[$key])
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($target[$key])=Is object:K8:27)
				
				$values.combine(This:C1470.findPropertyValues($property; $target[$key]))
				
				//______________________________________________________
			: (Value type:C1509($target[$key])=Is collection:K8:32)
				
				For each ($v; $target[$key])
					
					If (Value type:C1509($v)=Is object:K8:27)
						
						$values.combine(This:C1470.findPropertyValues($property; $v))
						
					End if 
				End for each 
				
				//______________________________________________________
		End case 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the first object found with a given property
Function inHierarchy($property : Text; $target : Object)->$object : Object
	
	var $key : Text
	
	// MARK: ♻️ RECURSIVE
	
	$target:=(Count parameters:C259<2) ? This:C1470.content : $target
	
	Case of 
			
			//________________________________________
		: ($target=Null:C1517)
			
			$object:=Null:C1517
			
			//________________________________________
		: ($target[$property]#Null:C1517)
			
			$object:=$target
			
			//________________________________________
		Else 
			
			For each ($key; $target) Until ($object#Null:C1517)
				
				If (Value type:C1509($target[$key])=Is object:K8:27)
					
					$object:=This:C1470.inHierarchy($property; $target[$key])
					
				End if 
			End for each 
			
			//________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function entries($target : Object)->$entries : Collection
	
	$target:=(Count parameters:C259<1) ? This:C1470.content : $target
	$entries:=OB Entries:C1720($target)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function keys($target : Object)->$keys : Collection
	
	$target:=(Count parameters:C259<1) ? This:C1470.content : $target
	$keys:=OB Keys:C1719($target)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function values($target : Object)->$values : Collection
	
	$target:=(Count parameters:C259<1) ? This:C1470.content : $target
	$values:=OB Values:C1718($target)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the content is of the given class
Function instanceOf($class : Object)->$success : Boolean
	
	$success:=OB Instance of:C1731(This:C1470.content; $class)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function cleanup($pattern : Text; $target : Object)->$result : Object
	
	var $key : Text
	var $intra : Boolean
	var $c : Collection
	
	$intra:=Count parameters:C259<2
	$target:=$intra ? This:C1470.content : $target
	$result:=$target
	
	If (Count parameters:C259=0)
		
		$c:=New collection:C1472("_"; "$")
		
	Else 
		
		$c:=Split string:C1554($pattern; ",")
		
	End if 
	
	$result:=OB Copy:C1225($target)
	
	For each ($key; $result)
		
		If ($c.indexOf($key[[1]])#-1)
			
			OB REMOVE:C1226($result; $key)
			
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$result
		
	End if 
	
	//MARK:- 📌 PRIVATES
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Compute the target path, Create and Set value if any
Function _path($path : Text; $set : Boolean; $value)->$result
	
	var $lastMember; $member : Text
	var $last : Boolean
	var $indx : Integer
	var $content : Object
	var $members : Collection
	
	ARRAY LONGINT:C221($len; 0)
	ARRAY LONGINT:C221($pos; 0)
	
	$set:=Count parameters:C259>=2 ? $set : False:C215
	
	$members:=Split string:C1554($path; ".")
	This:C1470.success:=True:C214
	
	If (($members.length=1))
		
		If ($set)
			
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
							
							If ($set)
								
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
					
					If ($set)
						
						$content[$member]:=Null:C1517
						
					End if 
				End if 
				
				$result:=$content[$member]
				
			End if 
		End if 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns an empty value according to the desired type
Function _emptyValue($type : Integer)->$value
	
	$value:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		Case of 
				
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
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _catchError($catch : Boolean)
	
	If (Bool:C1537($catch))
		
		This:C1470._methodCalledOnError:=Method called on error:C704
		CLEAR VARIABLE:C89(ERROR)
		ON ERR CALL:C155("noError")
		
	Else 
		
		ON ERR CALL:C155(String:C10(This:C1470._methodCalledOnError))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($message : Text)
	
	var $current : Object
	var $c : Collection
	
	This:C1470.success:=False:C215
	
	$c:=Get call chain:C1662
	
	$current:=$c.query("name != 'ob.@'").pop()
	
	If ($current#Null:C1517)
		
		If (Length:C16($message)>0)
			
			This:C1470.lastError:=$current.name+" - line "+String:C10($current.line)+" - "+$message
			
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
			
			This:C1470.lastError:="Unknown but irritating error"
			
		End if 
	End if 
	
	This:C1470.errors.push(This:C1470.lastError)