Class constructor
	
	C_VARIANT:C1683($1)
	C_OBJECT:C1216($2)
	
	This:C1470.root:=Null:C1517
	This:C1470.autoClose:=True:C214
	This:C1470.success:=False:C215
	This:C1470.errors:=New collection:C1472
	This:C1470.latest:=Null:C1517
	This:C1470.picture:=Null:C1517
	This:C1470.xml:=Null:C1517
	This:C1470.origin:=Null:C1517
	This:C1470.file:=Null:C1517
	This:C1470.store:=New collection:C1472
	This:C1470[""]:=New object:C1471("_attributes";New collection:C1472("target";"left";"top";"width";"height";"codec"))
	  //This.target:=Formula(Choose($1.target=Null;Choose(This.latest#Null;This.latest;This.root);String($1.target)))
	
	If (Count parameters:C259>0)
		
		This:C1470.load($1)
		
	Else 
		
		This:C1470.new()
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function target
	
	C_TEXT:C284($0)
	C_VARIANT:C1683($1)
	
	C_OBJECT:C1216($o)
	
	This:C1470.success:=True:C214
	
	Case of 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is undefined:K8:13)
			
			$0:=Choose:C955(This:C1470.latest#Null:C1517;This:C1470.latest;This:C1470.root)
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			Case of 
					
					  //_______________________________
				: ($1="root")
					
					$0:=This:C1470.root
					
					  //_______________________________
				: ($1="latest")
					
					$0:=Choose:C955(This:C1470.latest#Null:C1517;This:C1470.latest;This:C1470.root)
					
					  //_______________________________
				Else 
					
					$o:=This:C1470.store.query("id=:1";$1).pop()
					
					If ($o#Null:C1517)
						
						$0:=$o.dom
						
					Else 
						
						This:C1470.success:=False:C215
						This:C1470.errors.push("The element \""+$1+"\" doesn't exists")
						
					End if 
					
					  //_______________________________
			End case 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			If ($1.target#Null:C1517)
				
				$0:=String:C10($1.target)
				
			Else 
				
				This:C1470.target("latest")
				
			End if 
			
			  //______________________________________________________
			
		Else 
			
			This:C1470.success:=False:C215
			This:C1470.errors.push("Unmanaged type")
			
			  //______________________________________________________
	End case 
	
/*———————————————————————————————————————————————————————————*/
Function push  // Keep dom reference for futur
	
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	
	This:C1470.success:=(This:C1470.store.query("id=:1";$1).pop()=Null:C1517)
	
	If (This:C1470.success)
		
		This:C1470.store.push(New object:C1471(\
			"id";$1;\
			"dom";This:C1470.latest))
		
	Else 
		
		This:C1470.errors.push("The element \""+$1+"\" already exists")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function fetch  // Retrive a stored dom reference
	
	C_TEXT:C284($0)
	C_TEXT:C284($1)
	
	C_OBJECT:C1216($o)
	
	$o:=This:C1470.store.query("id=:1";$1).pop()
	This:C1470.success:=($o#Null:C1517)
	
	If (This:C1470.success)
		
		$0:=$o.dom
		
	Else 
		
		This:C1470.errors.push("The element \""+$1+"\" doesn't exists")
		
	End if 
	
/*———————————————————————————————————————————————————————————*/
Function new  // Create a default SVG structure
	
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($1)
	
	C_TEXT:C284($node;$t)
	
	This:C1470.close()  // Release memory
	
	$node:=DOM Create XML Ref:C861("svg";"http://www.w3.org/2000/svg")
	This:C1470.success:=Bool:C1537(OK)
	
	If (This:C1470.success)
		
		This:C1470.root:=$node
		
		DOM SET XML ATTRIBUTE:C866($node;\
			"xmlns:xlink";"http://www.w3.org/1999/xlink")
		
		DOM SET XML DECLARATION:C859($node;"UTF-8";True:C214)
		XML SET OPTIONS:C1090($node;XML indentation:K45:34;Choose:C955(Is compiled mode:C492;XML no indentation:K45:36;XML with indentation:K45:35))
		
		$node:=DOM Create XML element:C865(This:C1470.root;"def")
		This:C1470.success:=Bool:C1537(OK)
		
		If (This:C1470.success)
			
			  // Default values
			DOM SET XML ATTRIBUTE:C866(This:C1470.root;\
				"viewport-fill";"none";\
				"fill";"none";\
				"stroke";"black";\
				"font-family";"'lucida grande','segoe UI',sans-serif";\
				"font-size";12;\
				"text-rendering";"geometricPrecision";\
				"shape-rendering";"crispEdges";\
				"preserveAspectRatio";"none")
			
		End if 
	End if 
	
	This:C1470.success:=Bool:C1537(OK) & (This:C1470.root#Null:C1517)
	
	If (This:C1470.success)
		
		If (Count parameters:C259>=1)
			
			If ($1#Null:C1517)
				
				For each ($t;$1)
					
					Case of 
							
							  //_______________________
						: ($t="keepReference")
							
							This:C1470.autoClose:=Bool:C1537($1[$t])
							
							  //_______________________
						Else 
							
							DOM SET XML ATTRIBUTE:C866(This:C1470.root;\
								$t;$1[$t])
							
							  //______________________
					End case 
				End for each 
				
			Else 
				
				  // <NOTHING MORE TO DO>
				
			End if 
			
		Else 
			
			  // <NOTHING MORE TO DO>
			
		End if 
		
	Else 
		
		This:C1470.errors.push("Failed to create SVG structure.")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function load  // Load a variable or a file
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1)
	
	C_TEXT:C284($node)
	
	This:C1470.close()  // Release memory
	
	Case of 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)\
			 | (Value type:C1509($1)=Is BLOB:K8:12)  // Parse a given variable
			
			$node:=DOM Parse XML variable:C720($1)
			This:C1470.success:=Bool:C1537(OK)
			
			CLEAR VARIABLE:C89($1)
			
			If (This:C1470.success)
				
				This:C1470.root:=$node
				
			Else 
				
				This:C1470.errors.push("Failed to parse the given variable")
				
			End if 
			
			  //______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)  // File to load
			
			This:C1470.success:=($1#Null:C1517)
			
			If (This:C1470.success)
				
				This:C1470.success:=Bool:C1537($1.isFile) & Bool:C1537($1.exists)
				
				If (This:C1470.success)
					
					$node:=DOM Parse XML source:C719($1.platformPath)
					This:C1470.success:=Bool:C1537(OK)
					
					If (This:C1470.success)
						
						This:C1470.root:=$node
						This:C1470.origin:=$1
						
					End if 
					
				Else 
					
					This:C1470.errors.push("File doesn't exists: "+String:C10($1.platformPath))
					
				End if 
				
			Else 
				
				This:C1470.errors.push("Missing File obkect to load")
				
			End if 
			
			  //______________________________________________________
		Else 
			
			This:C1470.errors.push("Unmanaged type: "+String:C10(Value type:C1509($1)))
			
			  //________________________________________
	End case 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function close  // Close XML tree
	
	C_OBJECT:C1216($0)
	
	If (This:C1470.root#Null:C1517)
		
		DOM CLOSE XML:C722(This:C1470.root)
		This:C1470.root:=Null:C1517
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function show  // Show in 4D SVG Viewer
	
	C_OBJECT:C1216($0)
	
	  //#TO_DO: Should test if the component is available
	EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER";*;This:C1470.root)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function rect
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1;$2)
	C_VARIANT:C1683($3)
	
	C_VARIANT:C1683($vWidth)
	C_TEXT:C284($node)
	
	If (Count parameters:C259>1)
		
		$vWidth:=Choose:C955($2#Null:C1517;$2;$1)
		
	Else 
		
		  // Square
		$vWidth:=$1
		
	End if 
	
	$node:=This:C1470.target($3)
	
	If (This:C1470.success)
		
		This:C1470.latest:=DOM Create XML element:C865($node;"rect";\
			"width";$1;\
			"height";$vWidth)
		
		This:C1470.success:=Bool:C1537(OK)
		
		If (Count parameters:C259>2)\
			 & (This:C1470.success)
			
			This:C1470.attributes($3)
			
		End if 
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function square
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1)
	C_VARIANT:C1683($2)
	
	This:C1470.rect($1;Null:C1517;$2)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function group
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1)  // text | object
	
	C_TEXT:C284($node)
	
	If (Count parameters:C259>=1)
		
		$node:=This:C1470.target($1)
		
	Else 
		
		$node:=This:C1470.target()
		
	End if 
	
	This:C1470.latest:=DOM Create XML element:C865($node;"g")
	This:C1470.success:=Bool:C1537(OK)
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function position
	
	C_OBJECT:C1216($0)
	C_LONGINT:C283($1)  // x
	C_VARIANT:C1683($2)  // {y | unit}
	C_TEXT:C284($3)  //    {unit}
	
	C_TEXT:C284($node)
	
	$node:=This:C1470.target()
	This:C1470.success:=($node#This:C1470.root)
	
	If (This:C1470.success)
		
		If (Value type:C1509($2)=Is text:K8:3)
			
			DOM SET XML ATTRIBUTE:C866($node;\
				"x";String:C10($1;"&xml")+String:C10($2))
			
		Else 
			
			If (Count parameters:C259>2)
				
				DOM SET XML ATTRIBUTE:C866($node;\
					"x";String:C10($1;"&xml")+String:C10($3);\
					"y";String:C10($2;"&xml")+String:C10($3))
				
			Else 
				
				DOM SET XML ATTRIBUTE:C866($node;\
					"x";$1;\
					"y";$2)
				
			End if 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	Else 
		
		This:C1470.errors.push("You can't set position for the canvas!")
		
	End if 
	
	$0:=This:C1470
	
/*———————————————————————————————————————————————————————————*/
Function attributes
	
	C_OBJECT:C1216($0)
	C_VARIANT:C1683($1)  // object | attribute
	C_VARIANT:C1683($2)  // Value
	
	C_TEXT:C284($key;$node)
	C_COLLECTION:C1488($c)
	
	If (Value type:C1509($1)=Is object:K8:27)
		
		If ($1#Null:C1517)
			
			$node:=This:C1470.target($1)
			$c:=This:C1470[""]._attributes
			
			For each ($key;$1)
				
				If ($c.indexOf($key)=-1)
					
					If (Length:C16($key)#0)\
						 & ($1[$key]#Null:C1517)
						
						DOM SET XML ATTRIBUTE:C866($node;\
							$key;$1[$key])
						
					Else 
						
						  //This.success:=False
						  //This.errors.push("Invalid values pair for an attribute.")
						
					End if 
				End if 
			End for each 
		End if 
		
	Else 
		
		If (Count parameters:C259>1)
			
			DOM SET XML ATTRIBUTE:C866(This:C1470.latest;\
				String:C10($1);$2)
			
		Else 
			
			  //If (Value type($1)=Is text)
			
			  //  // Remove
			  //DOM REMOVE XML ATTRIBUTE(This.latest;$1)
			
			  //End if 
		End if 
		
		This:C1470.success:=Bool:C1537(OK)
		
	End if 
	
	$0:=This:C1470