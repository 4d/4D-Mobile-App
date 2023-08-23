Class constructor
	
	This:C1470._matrix:=Structure file:C489=Structure file:C489(*)
	This:C1470.mode:=Is compiled mode:C492
	This:C1470._user:=Current user:C182
	This:C1470._systemUser:=Current system user:C484
	This:C1470.allowTrace:=True:C214
	
Function get debug() : Boolean
	
	return This:C1470._matrix
	
Function get compiled() : Boolean
	
	return This:C1470.mode
	
Function get interpreted() : Boolean
	
	return Not:C34(This:C1470.mode)
	
Function get development() : Boolean
	
	return This:C1470._matrix
	
Function get deployment() : Boolean
	
	return Not:C34(This:C1470._matrix)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function TRACE($condition : Text)
	
	If (This:C1470._doTrace($condition))
		
		TRACE:C157
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function ASSERT($data : Object)
	
	If (Not:C34(This:C1470._doAssert($data))) && ($data.message#Null:C1517)
		
		ASSERT:C1129(False:C215; String:C10($data.message))
		
	End if 
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
Function _doAssert($data : Object) : Boolean
	
	var $key : Text
	
	If (This:C1470.deployment)
		
		return True:C214  // No assert in deploiement
		
	End if 
	
	If ($data=Null:C1517)
		
		return False:C215  // Force
		
	End if 
	
	// Testing the condidition
	For each ($key; $data)
		
		Case of 
				
				//______________________________________________________
			: ($key="equal")
				
				return ($data[$key]=$data.value)
				
				//______________________________________________________
			: ($key="unequal")
				
				return ($data[$key]#$data.value)
				
				//______________________________________________________
			: ($key="pathname")  // Test a pathname
				
				$data.value:=Num:C11($data.value)
				
				If ($data.value=-43)
					
					// Return True if the pathname is valid (folder or file)
					return (Test path name:C476($data[$key])#$data.value)
					
				Else 
					
					// Return True if the pathname is valid for the given type
					return (Test path name:C476($data[$key])=$data.value)
					
				End if 
				
				//______________________________________________________
			: (OB Instance of:C1731($data[$key]; 4D:C1709.File))\
				 || (OB Instance of:C1731($data[$key]; 4D:C1709.Folder))
				
				If ($data.value=Null:C1517) || Bool:C1537($data.value)
					
					// Returns True if the File or Folder exist
					return $data[$key].exists
					
				Else 
					
					// Returns True if the File or Folder doesn't exist
					return Not:C34($data[$key].exists)
					
				End if 
				
				//______________________________________________________
		End case 
	End for each 
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
Function _doTrace($condition : Text) : Boolean
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.compiled) || (Not:C34(Caps lock down:C547))
			
			return 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($condition="true")\
			 || ($condition="force")
			
			return True:C214
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($condition="user:@")
			
			$condition:=Delete string:C232($condition; 1; 5)
			return (This:C1470._user=$condition) || (This:C1470._systemUser=$condition)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Macintosh option down:C545 || Windows Alt down:C563)
			
			return True:C214
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 