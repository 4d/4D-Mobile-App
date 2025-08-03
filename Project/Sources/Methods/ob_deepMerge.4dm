//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : ob_deepMerge
// ----------------------------------------------------
// Description:
// Copy object properties from source to target
// ----------------------------------------------------
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!! NOT FINALIZED !!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// ----------------------------------------------------
#DECLARE($target: Object; $source: Object; $overwrite: Boolean): Object

// Variable declarations
var $parameters: Integer
var $sourceType: Integer
var $property: Text

// ----------------------------------------------------
// Initialisations
$parameters:=Count parameters

If (Asserted($parameters>=2; "Missing parameter"))
	
	// Initialize target if null
	If ($target=Null)
		$target:={}
	End if 
	
	// Handle optional overwrite parameter
	If ($parameters<3)
		$overwrite:=True
	End if
	
Else 
	ABORT
End if 

// ----------------------------------------------------
For each ($property; $source)
	
	$sourceType:=Value type($source[$property])
	
	Case of 
			
			//________________________________________
		: ($sourceType=Is object)
			
			Case of 
				: ($target[$property]=Null)
					
					$target[$property]:=OB Copy($source[$property])
					
				: ($overwrite)
					If (Value type($target[$property])#Is object)
						
						$target[$property]:={}
						
					End if 
					
					$target[$property]:=ob_deepMerge(\
						$target[$property]; \
						OB Copy($source[$property]); \
						$overwrite)
					
					// Else ignore, 
			End case 
			
			//________________________________________
		: ($sourceType=Is collection)
			
			Case of 
				: ($target[$property]=Null)
					
					$target[$property]:=$source[$property].copy()
					
				: ($overwrite)
					
					If (Value type($target[$property])#Is collection)
						
						$target[$property]:=New collection
						
					End if 
					
					$target[$property]:=$target[$property].concat($source[$property].copy())
					
					// Else ignore, do not overwrite
			End case 
			
			//________________________________________
		Else 
			
			Case of 
				: ($overwrite)
					$target[$property]:=$source[$property]
				: ($target[$property]=Null)
					$target[$property]:=$source[$property]
					// Else ignore, do not override
			End case 
			//________________________________________
	End case 
End for each 

// ----------------------------------------------------
// Return
return $target

// ----------------------------------------------------
// End