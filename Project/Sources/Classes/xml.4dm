Class constructor
	var $1 : Variant
	
	This:C1470.root:=Null:C1517
	This:C1470.autoClose:=True:C214
	This:C1470.success:=False:C215
	This:C1470.file:=Null:C1517
	This:C1470.errors:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		This:C1470.load($1)
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function new
	var $0 : Object
	var ${1} : Text
	
	var $t : Text
	var $i; $countParam : Integer
	
	$countParam:=Count parameters:C259
	
	OK:=0
	
	If ($countParam>=1)
		
		If ($countParam>=2)
			
			If (($countParam%2)#0)
				
				This:C1470.errors.push(Current method name:C684+" -  Unbalanced key/value pairs")
				
			Else 
				
				$t:=":C861("
				
				For ($i; 1; $countParam; 2)
					
					$t:=$t+(";"*Num:C11($i>1))+"\""+${$i}+"\";\""+${$i+1}+"\""
					
				End for 
				
				$t:=$t+")"
				
			End if 
			
			This:C1470.root:=Formula from string:C1601($t).call()
			
		Else 
			
			This:C1470.root:=DOM Create XML Ref:C861(${1})
			
		End if 
		
	Else 
		
		This:C1470.root:=DOM Create XML Ref:C861("root")
		
	End if 
	
	This:C1470.success:=Bool:C1537(OK)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setOption
	var $0 : Object
	var $1 : Integer
	var $2 : Integer
	
	This:C1470.success:=(Count parameters:C259=2)
	
	If (This:C1470.success)
		
		XML SET OPTIONS:C1090(This:C1470.root; $1; $2)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Unbalanced selector/value pairs")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setOptions
	var $0 : Object
	var $1 : Integer
	var $2 : Integer
	var ${3} : Integer
	
	var $i : Integer
	
	This:C1470.success:=((Count parameters:C259%2)=0)
	
	If (This:C1470.success)
		
		For ($i; 1; Count parameters:C259; 2)
			
			XML SET OPTIONS:C1090(This:C1470.root; ${$i}; ${$i+1})
			
		End for 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Unbalanced selector/value pairs")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function parse  // Parse a variable (TEXT or BLOB)
	var $0 : Object
	var $1 : Variant
	var $2 : Boolean
	var $3 : Text
	
	var $countParam : Integer
	
	$countParam:=Count parameters:C259
	
	Case of 
			
			//……………………………………………………………………………………………
		: ($countParam=0)
			
			$0:=This:C1470.load()
			
			//……………………………………………………………………………………………
		: ($countParam=1)
			
			$0:=This:C1470.load($1)
			
			//……………………………………………………………………………………………
		: ($countParam=2)
			
			$0:=This:C1470.load($1; $2)
			
			//……………………………………………………………………………………………
		Else 
			
			$0:=This:C1470.load($1; $2; $3)
			
			//……………………………………………………………………………………………
	End case 
	
/*———————————————————————————————————————————————————————————*/
Function load  // Load a variable (TEXT or BLOB) or a file
	var $0 : Object
	var $1 : Variant
	var $2 : Boolean
	var $3 : Text
	
	var $node : Text
	var $countParam : Integer
	
	This:C1470.close()  // Release memory
	
	$countParam:=Count parameters:C259
	
	Case of 
			
			//______________________________________________________
		: ($countParam=0)
			
			This:C1470.success:=False:C215
			This:C1470.errors.push(Current method name:C684+" -  Missing the target to load")
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)\
			 | (Value type:C1509($1)=Is BLOB:K8:12)  // Parse a given variable
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($countParam=1)
					
					$node:=DOM Parse XML variable:C720($1)
					
					//……………………………………………………………………………………………
				: ($countParam=2)
					
					$node:=DOM Parse XML variable:C720($1; $2)
					
					//……………………………………………………………………………………………
				Else 
					
					$node:=DOM Parse XML variable:C720($1; $2; $3)
					
					//……………………………………………………………………………………………
			End case 
			
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				This:C1470.root:=$node
				
			Else 
				
				This:C1470.errors.push(Current method name:C684+" -  Failed to parse the "+Choose:C955(Value type:C1509($1)=Is text:K8:3; "text"; "blob")+" variable")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)  // File to load
			
			This:C1470.success:=OB Instance of:C1731($1; 4D:C1709.File)
			
			If (This:C1470.success)
				
				This:C1470.success:=Bool:C1537($1.isFile) & Bool:C1537($1.exists)
				
				If (This:C1470.success)
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($countParam=1)
							
							$node:=DOM Parse XML source:C719($1.platformPath)
							
							//……………………………………………………………………………………………
						: ($countParam=2)
							
							$node:=DOM Parse XML source:C719($1.platformPath; $2)
							
							//……………………………………………………………………………………………
						Else 
							
							$node:=DOM Parse XML source:C719($1.platformPath; $2; $3)
							
							//……………………………………………………………………………………………
					End case 
					
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						This:C1470.root:=$node
						This:C1470.file:=$1
						
					End if 
					
				Else 
					
					This:C1470.errors.push(Current method name:C684+" -  File not found: "+String:C10($1.platformPath))
					
				End if 
				
			Else 
				
				This:C1470.errors.push(Current method name:C684+" -  The parameter is not a File object")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Unmanaged type: "+String:C10(Value type:C1509($1)))
			
			//________________________________________
	End case 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function save
	var $0 : Object
	var $1 : Variant
	var $2 : Boolean
	
	var $close : Boolean
	var $file : 4D:C1709.File
	
	If (Count parameters:C259>=2)
		
		$file:=$1
		$close:=$2
		
	Else 
		
		If (Count parameters:C259>=1)
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				$file:=$1
				
			Else 
				
				$file:=This:C1470.file
				$close:=Bool:C1537($1)
				
			End if 
			
		Else 
			
			$file:=This:C1470.file
			
		End if 
	End if 
	
	This:C1470.success:=OB Instance of:C1731($file; 4D:C1709.File)
	
	If (This:C1470.success)
		
		DOM EXPORT TO FILE:C862(This:C1470.root; $file.platformPath)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  File is not defined")
		
	End if 
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($close)
			
		Else 
			
			This:C1470.__close()
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function close  // Close the XML tree
	var $0 : Object
	
	This:C1470.success:=(This:C1470.root#Null:C1517)
	
	If (This:C1470.success)
		
		DOM CLOSE XML:C722(This:C1470.root)
		This:C1470.success:=Bool:C1537(OK)
		This:C1470.root:=Null:C1517
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function create
	var $0 : Text
	var $1 : Text
	var $2 : Variant
	var $3 : Variant
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		If (This:C1470.__isReference($1))
			
			$0:=DOM Create XML element:C865($1; $2)
			
			If (Count parameters:C259=3)
				
				This:C1470.setAttributes($0; $3)
				
			End if 
			
		Else 
			
			$0:=DOM Create XML element:C865(This:C1470.root; $1)
			
			If (Count parameters:C259=2)
				
				This:C1470.setAttributes($0; $2)
				
			End if 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getText  // Return the  XML tree as text
	var $0 : Text
	var $1 : Boolean
	
	var $t : Text
	
	DOM EXPORT TO VAR:C863(This:C1470.root; $t)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($1)
			
		Else 
			
			This:C1470.__close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Failed to export XML to text.")
		
	End if 
	
	$0:=$t
	
/*———————————————————————————————————————————————————————————*/
Function getContent  // Return the  XML tree as BLOB
	var $0 : Blob
	var $1 : Boolean
	
	var $x : Blob
	
	DOM EXPORT TO VAR:C863(This:C1470.root; $x)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($1)
			
		Else 
			
			This:C1470.__close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Failed to export XML to BLOB.")
		
	End if 
	
	$0:=$x
	
/*———————————————————————————————————————————————————————————*/
Function toObject
	var $0 : Object
	var $1 : Boolean
	
	If (Count parameters:C259=2)
		
		$0:=xml_elementToObject(This:C1470.root; $1)
		
	Else 
		
		$0:=xml_elementToObject(This:C1470.root)
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findById
	var $0 : Text
	var $1 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		$0:=DOM Find XML element by ID:C1010(This:C1470.root; $1)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing ID parameter")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findByXPath
	var $0 : Text
	var $1 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		$0:=DOM Find XML element:C864(This:C1470.root; $1)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing path parameter")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findByName
	var $0 : Collection
	var $1 : Text
	var $2 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		ARRAY TEXT:C222($nodes; 0x0000)
		
		If (Count parameters:C259>=2)
			
			If (This:C1470.__isReference($1))
				
				$nodes{0}:=DOM Find XML element:C864($1; $2; $nodes)
				
			Else 
				
				$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$1; $nodes)
				
			End if 
			
		Else 
			
			$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$1; $nodes)
			
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		$0:=New collection:C1472
		ARRAY TO COLLECTION:C1563($0; $nodes)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findByAttribute
	var $0 : Collection
	var $1 : Text
	var $2 : Text
	var $3 : Text
	var $4 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		ARRAY TEXT:C222($nodes; 0x0000)
		
		If (This:C1470.__isReference($1))
			
			Case of 
					
					//______________________________________________________
				: (Count parameters:C259=2)  // Elements with the attribute $2
					
					$nodes{0}:=DOM Find XML element:C864($1; "//@"+$2; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259=3)  // Elements with the attribute $2 equal to $3
					
					$nodes{0}:=DOM Find XML element:C864($1; "//[@"+$2+"=\""+$3+"\"]"; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259>=4)  // Elements $2 with the attribute $3 equal to $4
					
					$nodes{0}:=DOM Find XML element:C864($1; "//"+$2+"[@"+$3+"=\""+$4+"\"]"; $nodes)
					
					//______________________________________________________
				Else 
					
					OK:=0
					
					//______________________________________________________
			End case 
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Count parameters:C259=1)  // Elements with the attribute $1
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//@"+$1; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259=2)  // Elements with the attribute $1 equal to $2
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//*[@"+$1+"=\""+$2+"\"]"; $nodes)
					
					//______________________________________________________
				: (Count parameters:C259>=3)  // Elements $2 with the attribute $3 equal to $4
					
					$nodes{0}:=DOM Find XML element:C864(This:C1470.root; "//"+$1+"[@"+$2+"=\""+$3+"\"]"; $nodes)
					
					//______________________________________________________
				Else 
					
					OK:=0
					
					//______________________________________________________
			End case 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		$0:=New collection:C1472
		ARRAY TO COLLECTION:C1563($0; $nodes)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findOrCreate
	var $0 : Text
	var $1 : Text
	var $2 : Text
	
	var $c : Collection
	
	If (This:C1470.__isReference($1))
		
		$c:=This:C1470.findByName($1; $2)
		
		If (This:C1470.success)
			
			$0:=$c[0]
			
		Else 
			
			// Create
			$0:=DOM Create XML element:C865($1; $2)
			
		End if 
		
	Else 
		
		$c:=This:C1470.findByName($1)
		
		If (This:C1470.success)
			
			$0:=$c[0]
			
		Else 
			
			// Create
			$0:=DOM Create XML element:C865(This:C1470.root; $1)
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK)
	
/*———————————————————————————————————————————————————————————*/
Function parent
	var $0 : Text
	var $1 : Text
	
	This:C1470.success:=This:C1470.__isReference($1)
	
	If (This:C1470.success)
		
		$0:=DOM Get parent XML element:C923($1)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function childrens  // Returns the childs of a node
	var $0 : Collection
	var $1 : Text
	
	var $i : Integer
	
	$0:=New collection:C1472
	
	ARRAY LONGINT:C221($types; 0x0000)
	ARRAY TEXT:C222($nodes; 0x0000)
	
	If (Count parameters:C259>=1)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM GET XML CHILD NODES:C1081($1; $types; $nodes)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
		
	Else 
		
		DOM GET XML CHILD NODES:C1081(This:C1470.root; $types; $nodes)
		
	End if 
	
	For ($i; 1; Size of array:C274($types); 1)
		
		If ($types{$i}=XML ELEMENT:K45:20)
			
			$0.push($nodes{$i})
			
		End if 
	End for 
	
/*———————————————————————————————————————————————————————————*/
Function descendants  // Returns the descendants of a node
	var $0 : Collection
	var $1 : Text
	
	var $i : Integer
	
	$0:=New collection:C1472
	
	ARRAY LONGINT:C221($types; 0x0000)
	ARRAY TEXT:C222($nodes; 0x0000)
	
	If (Count parameters:C259>=1)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM GET XML CHILD NODES:C1081($1; $types; $nodes)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
		
	Else 
		
		DOM GET XML CHILD NODES:C1081(This:C1470.root; $types; $nodes)
		
	End if 
	
	For ($i; 1; Size of array:C274($types); 1)
		
		If ($types{$i}=XML ELEMENT:K45:20)
			
			$0.push($nodes{$i})
			$0.combine(This:C1470.descendants($nodes{$i}))
			
		End if 
	End for 
	
/*———————————————————————————————————————————————————————————*/
Function nextSibling
	var $0; $1 : Text
	
	$0:=DOM Get next sibling XML element:C724($1)
	
/*———————————————————————————————————————————————————————————*/
Function previousSibling
	var $0; $1 : Text
	
	$0:=DOM Get previous sibling XML element:C924($1)
	
/*———————————————————————————————————————————————————————————*/
Function getName
	var $0 : Text
	var $1 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM GET XML ELEMENT NAME:C730($1; $0)
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function setName
	var $1 : Text
	var $2 : Text
	
	This:C1470.success:=(Count parameters:C259>=2)
	
	If (This:C1470.success)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM SET XML ELEMENT NAME:C867($1; $2)
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function remove
	var $1 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM REMOVE XML ELEMENT:C869($1)
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getValue
	var $0 : Variant
	var $1 : Text
	
	var $tCDATA; $value : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		This:C1470.success:=This:C1470.__isReference($1)
		
		If (This:C1470.success)
			
			DOM GET XML ELEMENT VALUE:C731($1; $value; $tCDATA)
			This:C1470.success:=Bool:C1537(OK)
			
			If (This:C1470.success)
				
				If (Length:C16($value)=0)
					
					// Try CDATA
					$0:=This:C1470.__convert($tCDATA)
					
				Else 
					
					$0:=This:C1470.__convert($value)
					
				End if 
			End if 
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Invalid XML element reference")
			
		End if 
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getAttribute  // Returns a node attribute value if exists
	var $0 : Variant
	var $1 : Text
	var $2 : Text
	
	var $o : Object
	
	This:C1470.success:=(Count parameters:C259=2)
	
	If (This:C1470.success)
		
		$o:=OB Entries:C1720(This:C1470.getAttributes($1)).query("key=:1"; $2).pop()
		This:C1470.success:=($o#Null:C1517)
		
		If (This:C1470.success)
			
			$0:=$o.value
			
		Else 
			
			This:C1470.errors.push(Current method name:C684+" -  Attribute \""+$1+"\" not found")
			
		End if 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getAttributes  // Returns a node attributes as object
	var $0 : Object
	var $1 : Text
	
	var $key; $t; $value : Text
	var $i : Integer
	
	This:C1470.success:=(Count parameters:C259=1)
	
	If (This:C1470.success)
		
		$0:=New object:C1471
		
		GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
		
		For ($i; 1; DOM Count XML attributes:C727($1); 1)
			
			DOM GET XML ATTRIBUTE BY INDEX:C729($1; $i; $key; $value)
			
			$0[$key]:=This:C1470.__convert($value)
			
		End for 
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing node reference")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getAttributesCollection  // Returns a node attributes as collection
	var $0 : Collection
	var $1 : Text
	
	This:C1470.success:=(Count parameters:C259=1)
	
	If (This:C1470.success)
		
		$0:=OB Entries:C1720(This:C1470.getAttributes($1))
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing node reference")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function setAttribute  // Set a node attribute
	var $0 : Object
	var $1 : Text
	var $2 : Text
	var $3 : Variant
	
	This:C1470.success:=(Count parameters:C259=3)
	
	If (This:C1470.success)
		
		DOM SET XML ATTRIBUTE:C866($1; $2; $3)
		
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setAttributes  // Set a node attributes from an object or a collection (key/value pairs)
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	var $3 : Variant
	
	var $t : Text
	var $o : Object
	
	This:C1470.success:=(Count parameters:C259>=2)
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(This:C1470.success))
			
			This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
			
			//______________________________________________________
		: (Value type:C1509($2)=Is text:K8:3)
			
			This:C1470.success:=(Count parameters:C259=3)
			
			If (This:C1470.success)
				
				This:C1470.setAttribute($1; $2; $3)
				
			Else 
				
				This:C1470.errors.push(Current method name:C684+" -  Missing parameters")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($2)=Is object:K8:27)
			
			For each ($t; $2) While (This:C1470.success)
				
				DOM SET XML ATTRIBUTE:C866($1; \
					$t; $2[$t])
				This:C1470.success:=Bool:C1537(OK)
				
			End for each 
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push(Current method name:C684+" -  Failed to set attribute \""+$t+"\"")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($2)=Is collection:K8:32)
			
			For each ($o; $2) While (This:C1470.success)
				
				DOM SET XML ATTRIBUTE:C866($1; \
					String:C10($o.key); $o.value)
				This:C1470.success:=Bool:C1537(OK)
				
			End for each 
			
			If (Not:C34(This:C1470.success))
				
				This:C1470.errors.push(Current method name:C684+" -  Failed to set attribute \""+String:C10($o.key)+"\"")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push(Current method name:C684+" -  Unmanaged type: "+String:C10(Value type:C1509($1)))
			
			//______________________________________________________
	End case 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setValue
	var $1 : Text
	var $2 : Variant
	var $3 : Boolean
	
	If (Count parameters:C259=3)
		
		If ($3)
			
			DOM SET XML ELEMENT VALUE:C868($1; $2; *)
			
		Else 
			
			DOM SET XML ELEMENT VALUE:C868($1; $2)
			
		End if 
		
	Else 
		
		DOM SET XML ELEMENT VALUE:C868($1; $2)
		
	End if 
	
	This:C1470.success:=Bool:C1537(OK)
	
/*———————————————————————————————————————————————————————————*/
Function __isReference
	var $0 : Boolean
	var $1 : Text
	
	$0:=Match regex:C1019("[[:xdigit:]]{32}"; $1; 1)
	
/*———————————————————————————————————————————————————————————*/
Function __convert
	var $0 : Variant
	var $1 : Text
	
	Case of 
			
			//______________________________________________________
		: (Match regex:C1019("(?m-is)^(?:[tT]rue|[fF]alse)$"; $1; 1))
			
			$0:=($1="true")
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)^(?:\\+|-)?\\d+(?:\\.|"+$1+"\\d+)?$"; $1; 1))
			
			$0:=Num:C11($1)
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)^\\d+-\\d+-\\d+$"; $1; 1))
			
			$0:=Date:C102($1+"T00:00:00")
			
			//______________________________________________________
		Else 
			
			$0:=$1
			
			//______________________________________________________
	End case 
	
/*———————————————————————————————————————————————————————————*/
Function __close
	var $1 : Boolean
	
	If (This:C1470.autoClose)
		
		If (Count parameters:C259>=1)
			
			If (Not:C34($1))
				
				This:C1470.close()
				
			Else 
				
				// ⚠️ XML tree is not closed
				
			End if 
			
		Else 
			
			This:C1470.close()
			
		End if 
		
	Else 
		
		// ⚠️ XML tree is not closed
		
	End if 