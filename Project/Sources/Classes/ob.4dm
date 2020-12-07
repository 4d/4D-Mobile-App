Class constructor($object : Object)
	
	If (Count parameters:C259>=1)
		
		This:C1470.content:=$object
		
	Else 
		
		This:C1470.content:=New object:C1471
		
	End if 
	
	//================================================================================
	// Set the object content
Function setContent($content)
	
	If (Count parameters:C259>=1)
		
		This:C1470.content:=$content
		
	Else 
		
		This:C1470.content:=New object:C1471
		
	End if 
	
	//================================================================================
	// Checks if the path exists and return True if so,
	// even if not contain any contents (not same result as comparison to Null)
Function checkPath($path)->$exists : Boolean
	
	var $i : Integer
	var $schemPtr : Pointer
	var $o; $schem; $sub : Object
	var $pathƒ : Collection
	var $member : Text
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing path parameter")
	ASSERT:C1129((Value type:C1509($path)=Is collection:K8:32) | (Value type:C1509($path)=Is text:K8:3); "path must be a text or a collection")
	
	If (Value type:C1509($path)=Is collection:K8:32)
		
		$pathƒ:=$path
		
	Else 
		
		$pathƒ:=Split string:C1554($path; ".")
		
	End if 
	
	$o:=New object:C1471
	$schem:=$o
	$schemPtr:=->$schem
	
	For each ($member; $pathƒ)
		
		$schemPtr->type:="object"
		$schemPtr->required:=New collection:C1472
		$schemPtr->required[0]:=$member
		
		$i:=$i+1
		
		If ($i<$pathƒ.length)
			
			$sub:=New object:C1471
			
			$schemPtr->properties:=New object:C1471
			$schemPtr->properties[$member]:=$sub
			
			$o:=$sub
			
			$schemPtr:=->$o
			
		End if 
	End for each 
	
	$exists:=JSON Validate:C1456(This:C1470.content; $schem).success
	
	//================================================================================
	// Create a path in the object if it not exist
Function createPath($path : Variant; $type : Integer)->$o : Object
	
	var $typeƒ : Integer
	var $pathƒ : Collection
	var $key : Text
	
	ASSERT:C1129(Count parameters:C259>=1; "Missing path parameter")
	
	$typeƒ:=Is object:K8:27
	
	If (Count parameters:C259>=2)
		
		$typeƒ:=$type
		
	End if 
	
	$o:=This:C1470.content
	
	If (Value type:C1509($path)=Is collection:K8:32)
		
		$pathƒ:=$path
		
	Else 
		
		$pathƒ:=Split string:C1554($path; ".")
		
	End if 
	
	For each ($key; $pathƒ)
		
		If ($o[$key]=Null:C1517)
			
			If ($key=$pathƒ[$pathƒ.length-1])  // Last item
				
				Case of 
						
						//______________________________________________________
					: ($typeƒ=Is object:K8:27)
						
						$o[$key]:=New object:C1471
						
						//______________________________________________________
					: ($typeƒ=Is collection:K8:32)
						
						$o[$key]:=New collection:C1472
						
						//______________________________________________________
					: ($typeƒ=Is text:K8:3)
						
						$o[$key]:=""
						
						//______________________________________________________
					: ($typeƒ=Is longint:K8:6)\
						 | ($typeƒ=Is real:K8:4)
						
						$o[$key]:=0
						
						//______________________________________________________
					: ($typeƒ=Is null:K8:31)
						
						$o[$key]:=Null:C1517
						
						//______________________________________________________
					: ($typeƒ=Is date:K8:7)
						
						$o[$key]:=!00-00-00!
						
						//______________________________________________________
					: ($typeƒ=Is time:K8:8)
						
						$o[$key]:=?00:00:00?
						
						//______________________________________________________
					: ($typeƒ=Is picture:K8:10)
						
						var $p : Picture
						$o[$key]:=$p
						
						//______________________________________________________
					Else 
						
						$o[$key]:=Null:C1517
						
						//______________________________________________________
				End case 
				
			Else 
				
				$o[$key]:=New object:C1471
				$o:=$o[$key]
				
			End if 
			
		Else 
			
			If ($key#$pathƒ[$pathƒ.length-1])
				
				$o:=$o[$key]
				
			End if 
		End if 
	End for each 
	
	$o:=This:C1470.content
	
	//================================================================================
	// Tests the equality against passed object
Function equal($o : Object)->$isEqual : Boolean
	
	$isEqual:=New collection:C1472(This:C1470.content).equal(New collection:C1472($o))
	
	
	//================================================================================