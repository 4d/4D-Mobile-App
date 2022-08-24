Class constructor($target; $pattern : Text)
	
	This:C1470._target:=""
	This:C1470._pattern:=""
	This:C1470.success:=True:C214
	This:C1470.matches:=Null:C1517
	This:C1470.errorCode:=0
	This:C1470.errors:=New collection:C1472
	This:C1470.lastError:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470.setTarget($target)
		
		If (Count parameters:C259>=2)
			
			This:C1470.setPattern($pattern)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get target() : Text
	
	return This:C1470._target
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set target($target)
	
	This:C1470._setTarget($target)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get pattern() : Text
	
	return This:C1470._pattern
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set pattern($pattern : Text)
	
	This:C1470._pattern:=$pattern
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets the string where will be perform the search.
	// Could be a text or a disk file
Function setTarget($target) : cs:C1710.regex
	
	This:C1470._setTarget($target)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets the regular expression to use.
Function setPattern($pattern : Text) : cs:C1710.regex
	
	This:C1470._pattern:=$pattern
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function match($start; $all : Boolean) : cs:C1710.regex
	
	var $methodCalledOnError : Text
	var $match : Boolean
	var $i : Integer
	var $item : Object
	
	ARRAY LONGINT:C221($positions; 0)
	ARRAY LONGINT:C221($lengths; 0)
	
	If (Count parameters:C259>=1)
		
		If (Value type:C1509($start)=Is boolean:K8:9)
			
			$all:=$start
			$start:=1
			
		Else 
			
			$start:=Num:C11($start)
			
		End if 
		
	Else 
		
		$start:=1  // Start the search with the first character
		
	End if 
	
	This:C1470.success:=False:C215
	This:C1470.matches:=New collection:C1472
	This:C1470.errorCode:=0
	
	$methodCalledOnError:=This:C1470._errorCatch()
	
	Repeat 
		
		ERROR:=0
		
		$match:=Match regex:C1019(This:C1470._pattern; This:C1470._target; $start; $positions; $lengths)
		
		If (ERROR=0)
			
			If ($match)
				
				This:C1470.success:=True:C214
				
				For ($i; 0; Size of array:C274($positions); 1)
					
					$item:=New object:C1471(\
						"data"; Substring:C12(This:C1470._target; $positions{$i}; $lengths{$i}); \
						"position"; $positions{$i}; \
						"length"; $lengths{$i})
					
					If ($lengths{$i}=0)
						
						$match:=($i>0)
						
						If ($match)
							
							$match:=($positions{$i}#$positions{$i-1})
							
						End if 
					End if 
					
					This:C1470.matches.push($item)
					
					If ($positions{$i}>0)
						
						$start:=$positions{$i}+$lengths{$i}
						
					End if 
				End for 
				
				$match:=$all  // Stop after the first match ?
				
			End if 
			
		Else 
			
			This:C1470.errorCode:=ERROR
			This:C1470._pushError("Error while parsing pattern \""+This:C1470._pattern+"\"")
			
		End if 
	Until (Not:C34($match))
	
	This:C1470._errorCatch($methodCalledOnError)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function extract($group : Text) : cs:C1710.regex
	
	var $methodCalledOnError : Text
	var $start : Integer
	
	This:C1470.success:=False:C215
	This:C1470.matches:=New collection:C1472
	This:C1470.errorCode:=0
	
	$start:=1
	
	$methodCalledOnError:=This:C1470._errorCatch()
	
	This:C1470._errorCatch($methodCalledOnError)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function substitute($replacement : Text) : cs:C1710.regex
	
	var $methodCalledOnError : Text
	var $start : Integer
	
	This:C1470.success:=False:C215
	This:C1470.matches:=New collection:C1472
	This:C1470.errorCode:=0
	
	$start:=1
	
	$methodCalledOnError:=This:C1470._errorCatch()
	
	This:C1470._errorCatch($methodCalledOnError)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _errorCatch($onErrCallMethod : Text)->$currentOnErrCallMethod : Text
	
	If (Count parameters:C259>=1)
		
		ON ERR CALL:C155($onErrCallMethod)
		
	Else 
		
		$currentOnErrCallMethod:=Method called on error:C704
		ON ERR CALL:C155(Formula:C1597(noError).source)
		CLEAR VARIABLE:C89(ERROR)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($error : Text)
	
	This:C1470.lastError:=$error
	This:C1470.errors.push($error)
	This:C1470.success:=False:C215
	
	ASSERT:C1129(Structure file:C489#Structure file:C489(*))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _setTarget($target)
	
	Case of 
			
			//…………………………………………………………………………………………
		: (Value type:C1509($target)=Is text:K8:3)
			
			This:C1470._target:=$target
			
			//…………………………………………………………………………………………
		: (Value type:C1509($target)=Is object:K8:27)
			
			If (OB Class:C1730($target).name="File")
				
				If ($target.exists)
					
					This:C1470._target:=$target.getText()
					
				Else 
					
					This:C1470._pushError("file not found")
					
				End if 
				
			Else 
				
				This:C1470._pushError("target is not a 4D File")
				
			End if 
			
			//…………………………………………………………………………………………
		Else 
			
			This:C1470._pushError("target must be text or file")
			
			//…………………………………………………………………………………………
	End case 