// #DEPENDENCIES : [{"method":"noError"}]

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($content)
	
	This:C1470.success:=True:C214
	This:C1470.content:=Null:C1517
	This:C1470.prettyPrint:=True:C214
	This:C1470.tidyJson:=True:C214
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		This:C1470.setContent($content)
		
	Else 
		
		This:C1470.setContent()
		
	End if 
	
	//MARK:- COMPUTED ATTRIBUTES
	
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
	
	//MARK:- FUNCTIONS
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Set the root content
Function setContent($content)->$object : Object
	
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
		
		// Create an empty object
		This:C1470.content:=New object:C1471
		
	End if 
	
	//This.type:=Value type(This.content)
	//This.class:=OB Class(This.content)
	
	$object:=This:C1470.content
	
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
Function save($file : 4D:C1709.File)
	
	ASSERT:C1129($file#Null:C1517 ? OB Instance of:C1731($file; 4D:C1709.File) : True:C214)
	
	$file:=$file=Null:C1517 ? This:C1470.file : $file
	
	This:C1470._catchError(True:C214)
	$file.setText(This:C1470.stringify())
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
				This:C1470._pushError("checkPath() is not yet available for collections")
				
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
	
	$intra:=Count parameters:C259<2
	$object:=$intra ? This:C1470.content : $object
	
	$result:=OB Copy:C1225($object)
	
	For each ($key; $result)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($result[$key])=Is object:K8:27)
				
				// --> RECURSIVE
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
	// Return as a collection
Function toCollection($target : Object)->$c : Collection
	
	var $key : Text
	
	$target:=$target=Null:C1517 ? This:C1470.content : $target
	
	$c:=New collection:C1472
	
	For each ($key; $target)
		
		$c.push($target[$key])
		
	End for each 
	
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
Function tidy($object : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	$intra:=Count parameters:C259=0
	$object:=$intra ? This:C1470.content : $object
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($object).orderBy("key"))
		
		If (Value type:C1509($o.value)=Is object:K8:27)
			
			// --> RECURSIVE
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
Function coalescence($object : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	$intra:=Count parameters:C259=0
	$object:=$intra ? This:C1470.content : $object
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($object))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				// --> RECURSIVE
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
Function coalesce($object : Object)->$element
	
	var $key : Text
	
	$object:=Count parameters:C259=0 ? This:C1470.content : $object
	
	For each ($key; $object) Until ($element#Null:C1517)
		
		If ($object[$key]#Null:C1517)
			
			$element:=$object[$key]
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Removes all empty object entries, except for the collections
Function removeEmptyValues($object : Object)->$result : Object
	
	var $intra : Boolean
	var $o : Object
	
	$intra:=Count parameters:C259=0
	$object:=$intra ? This:C1470.content : $object
	
	$result:=New object:C1471
	
	For each ($o; OB Entries:C1720($object))
		
		If ($o.value#Null:C1517)
			
			If (Value type:C1509($o.value)=Is object:K8:27)
				
				// --> RECURSIVE
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
Function clone()->$clone : Object
	
	$clone:=OB Copy:C1225(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
/** Copies the values ​​of all first level properties of the passed objects.
- The common properties are overloaded according to the order of the parameters.
- The Null values are ignored
**/
Function assign
	
	/// TODO:TO BE DONE
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Adds the missing properties of the passed objects.
Function merge($object : Object; $target : Object)
	
	var $intra : Boolean
	var $key : Text
	
	$intra:=Count parameters:C259<2
	$target:=$intra ? This:C1470.content : $target
	
	For each ($key; $object)
		
		If ($target[$key]=Null:C1517)
			
			$target[$key]:=$object[$key]
			
		Else 
			
			If (Value type:C1509($object[$key])=Is object:K8:27)
				
				// --> RECURSIVE
				This:C1470.merge($object[$key]; $target[$key])
				
			End if 
		End if 
	End for each 
	
	If ($intra)
		
		This:C1470.content:=$target
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Copy object properties from source to target [#WIP]
Function deepMerge
	
	// TODO:TO BE DONE
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Finds one or more properties and returns its value (s), if found
Function findPropertyValues
	
	// TODO:TO BE DONE
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Look in object hierarchy an object with a specific property
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
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function entries()->$entries : Collection
	
	$entries:=OB Entries:C1720(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function keys()->$keys : Collection
	
	$keys:=OB Keys:C1719(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of objects containing the contents of the object as key / value property pairs.
Function values()->$values : Collection
	
	$values:=OB Values:C1718(This:C1470.content)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the content is of the given class
Function instanceOf($class : Object)->$success : Boolean
	
	$success:=OB Instance of:C1731(This:C1470.content; $class)
	
	//MARK:-PRIVATES
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// [PRIVATE] Compute the target path, Create and Set value if any
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
	// [PRIVATE] Returns an empty value according to the desired type
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
	// [PRIVATE]
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