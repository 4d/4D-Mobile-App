Class constructor
	
	var $1
	
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
	
	var $1;$2;${3} : Text
	var $l : Integer
	$l:=Count parameters:C259
	
	If ($l>=1)
		
		If ($l>=2)
			
			Case of 
					
					//……………………………………………………………………………………………
				: (($l%2)#0)
					
					This:C1470.errors.push("Unbalanced key/value pairs")
					OK:=0
					
					//……………………………………………………………………………………………
				: ($l=2)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2)
					
					//……………………………………………………………………………………………
				: ($l=4)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2;$3;$4)
					
					//……………………………………………………………………………………………
				: ($l=6)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2;$3;$4;$5;$6)
					
					//……………………………………………………………………………………………
				: ($l=8)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2;$3;$4;$5;$6;$7;$8)
					
					//……………………………………………………………………………………………
				: ($l=10)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2;$3;$4;$5;$6;$7;$8;$9;$10)
					
					//……………………………………………………………………………………………
				: ($l=12)
					
					This:C1470.root:=DOM Create XML Ref:C861($1;$2;$3;$4;$5;$6;$7;$8;$9;$10;$11;$12)
					
					//______________________________________________________
				Else 
					
					This:C1470.errors.push("Unmanaged number of  key/value structures (max = 5)")
					OK:=0
					
					//______________________________________________________
			End case 
			
			This:C1470.success:=Bool:C1537(OK)
			
		Else 
			
			This:C1470.root:=DOM Create XML Ref:C861($1)
			
		End if 
		
	Else 
		
		This:C1470.root:=DOM Create XML Ref:C861("root")
		
	End if 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setOption
	
	var $1;$2 : Integer
	var $0 : Object
	
	This:C1470.success:=(Count parameters:C259=2)
	
	If (This:C1470.success)
		
		XML SET OPTIONS:C1090(This:C1470.root;$1;$2)
		
	Else 
		
		This:C1470.errors.push("Unbalanced selector/value pairs")
		
	End if 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function setOptions
	
	var $1;$2;${3};$i : Integer
	
	This:C1470.success:=((Count parameters:C259%2)=0)
	
	If (This:C1470.success)
		
		For ($i;1;Count parameters:C259;2)
			
			XML SET OPTIONS:C1090(This:C1470.root;${$i};${$i+1})
			
		End for 
		
	Else 
		
		This:C1470.errors.push("Unbalanced selector/value pairs")
		
	End if 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function parse  // Parse a variable (TEXT or BLOB) 
	
	var $0 : Object
	var $1
	var $2 : Boolean
	var $3 : Text
	
	Case of 
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=0)
			
			$0:=This:C1470.load()
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=1)
			
			$0:=This:C1470.load($1)
			
			//……………………………………………………………………………………………
		: (Count parameters:C259=2)
			
			$0:=This:C1470.load($1;$2)
			
			//……………………………………………………………………………………………
		Else 
			
			$0:=This:C1470.load($1;$2;$3)
			
			//……………………………………………………………………………………………
	End case 
	
/*———————————————————————————————————————————————————————————*/
Function load  // Load a variable (TEXT or BLOB) or a file
	
	var $1
	var $2 : Boolean
	var $3;$node : Text
	var $l : Integer
	
	This:C1470.close()  // Release memory
	
	$l:=Count parameters:C259
	
	Case of 
			
			//______________________________________________________
		: ($l=0)
			
			This:C1470.success:=False:C215
			This:C1470.errors.push("Missing the target to load")
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)\
			 | (Value type:C1509($1)=Is BLOB:K8:12)  // Parse a given variable
			
			Case of 
					
					//……………………………………………………………………………………………
				: ($l=1)
					
					$node:=DOM Parse XML variable:C720($1)
					
					//……………………………………………………………………………………………
				: ($l=2)
					
					$node:=DOM Parse XML variable:C720($1;$2)
					
					//……………………………………………………………………………………………
				Else 
					
					$node:=DOM Parse XML variable:C720($1;$2;$3)
					
					//……………………………………………………………………………………………
			End case 
			
			This:C1470.success:=Bool:C1537(OK)
			CLEAR VARIABLE:C89($1)
			
			If (This:C1470.success)
				
				This:C1470.root:=$node
				
			Else 
				
				This:C1470.errors.push("Failed to parse the "+Choose:C955(Value type:C1509($1)=Is text:K8:3;"text";"blob")+" variable")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)  // File to load
			
			This:C1470.success:=OB Instance of:C1731($1;4D:C1709.File)
			
			If (This:C1470.success)
				
				This:C1470.success:=Bool:C1537($1.isFile) & Bool:C1537($1.exists)
				
				If (This:C1470.success)
					
					Case of 
							
							//……………………………………………………………………………………………
						: ($l=1)
							
							$node:=DOM Parse XML source:C719($1.platformPath)
							
							//……………………………………………………………………………………………
						: ($l=2)
							
							$node:=DOM Parse XML source:C719($1.platformPath;$2)
							
							//……………………………………………………………………………………………
						Else 
							
							$node:=DOM Parse XML source:C719($1.platformPath;$2;$3)
							
							//……………………………………………………………………………………………
					End case 
					
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						This:C1470.root:=$node
						This:C1470.file:=$1
						
					End if 
					
				Else 
					
					This:C1470.errors.push("File not found: "+String:C10($1.platformPath))
					
				End if 
				
			Else 
				
				This:C1470.errors.push("The parameter is not a File object")
				
			End if 
			
			//______________________________________________________
		Else 
			
			This:C1470.errors.push("Unmanaged type: "+String:C10(Value type:C1509($1)))
			
			//________________________________________
	End case 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function save
	
	var $1
	var $2;$b : Boolean
	var $file : Object
	
	If (Count parameters:C259>=2)
		
		$file:=$1
		$b:=$2
		
	Else 
		
		If (Count parameters:C259>=1)
			
			If (Value type:C1509($1)=Is object:K8:27)
				
				$file:=$1
				
			Else 
				
				$file:=This:C1470.file
				$b:=Bool:C1537($1)
				
			End if 
			
		Else 
			
			$file:=This:C1470.file
			
		End if 
	End if 
	
	This:C1470.success:=OB Instance of:C1731($file;4D:C1709.File)
	
	If (This:C1470.success)
		
		DOM EXPORT TO FILE:C862(This:C1470.root;$file.platformPath)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push("File is not defined")
		
	End if 
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($1)
			
		Else 
			
			This:C1470.__close()
			
		End if 
	End if 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function close  // Close the XML tree
	
	If (This:C1470.root#Null:C1517)
		
		DOM CLOSE XML:C722(This:C1470.root)
		This:C1470.root:=Null:C1517
		
	End if 
	
	var $0 : Object
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function getText  //return the  XML tree as text
	
	var $0;$t : Text
	var $1 : Boolean
	
	DOM EXPORT TO VAR:C863(This:C1470.root;$t)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($1)
			
		Else 
			
			This:C1470.__close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Failed to export XML to text.")
		
	End if 
	
	$0:=$t
	
/*———————————————————————————————————————————————————————————*/
Function getBlob  // Return the  XML tree as BLOB
	
	var $0;$x : Blob
	var $1 : Boolean
	
	DOM EXPORT TO VAR:C863(This:C1470.root;$x)
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			This:C1470.__close($1)
			
		Else 
			
			This:C1470.__close()
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Failed to export XML to text.")
		
	End if 
	
	$0:=$x
	
/*———————————————————————————————————————————————————————————*/
Function toObject
	
	var $0 : Object
	var $1 : Boolean
	
	If (Count parameters:C259=2)
		
		$0:=xml_elementToObject(This:C1470.root;$1)
		
	Else 
		
		$0:=xml_elementToObject(This:C1470.root)
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function findById
	
	var $0;$1 : Text
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (This:C1470.success)
		
		$0:=DOM Find XML element by ID:C1010(This:C1470.root;$1)
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push("Missing ID parameter")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getAttribute  // Return a node attribute value if exists
	
	var $0;$1;$2 : Text
	var $o : Object
	
	$o:=OB Entries:C1720(This:C1470.getAttributes($1)).query("key=:1";$2).pop()
	This:C1470.success:=($o#Null:C1517)
	
	If (This:C1470.success)
		
		$0:=$o.value
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function getAttributes  // Return a node attributes as object
	
	var $0 : Object
	var $1;$key;$value : Text
	var $i : Integer
	
	This:C1470.success:=(Count parameters:C259>=1)
	
	If (Asserted:C1132(This:C1470.success;"Missing node reference"))
		
		$0:=New object:C1471
		
		For ($i;1;DOM Count XML attributes:C727($1);1)
			
			DOM GET XML ATTRIBUTE BY INDEX:C729($1;$i;$key;$value)
			
			$0[$key]:=$value
			
		End for 
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function setAttribute
	
	var $1;$2 : Text
	var $3
	
	DOM SET XML ATTRIBUTE:C866($1;$2;$3)
	This:C1470.success:=Bool:C1537(OK)
	
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