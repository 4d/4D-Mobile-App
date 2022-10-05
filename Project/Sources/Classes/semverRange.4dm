// === === === === === === === === === === === === === === === === === === === === ===
Class constructor($range)
	
	var $length : Integer
	var $c : Collection
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($range)=Is collection:K8:32)
			
			If (Asserted:C1132($range.length=2; "range must count two version"))
				
				This:C1470.min:=$range[0]/*first*/
				This:C1470.max:=$range[1]/*last*/
				
			Else 
				
				// ERROR
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($range)=Is object:K8:27)
			
			If (Asserted:C1132($range.min#Null:C1517; "missing range.min attribute"))
				
				If ($range.max#Null:C1517)
					
					This:C1470.min:=cs:C1710.version.new($range.min)
					This:C1470.max:=cs:C1710.version.new($range.max)
					
				Else   // One version passed?
					
					This:C1470.min:=cs:C1710.version.new($range)
					This:C1470.max:=This:C1470.min
					
				End if 
				
			Else 
				
				// ERROR
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($range)=Is text:K8:3)
			
			$length:=Length:C16($range)
			
			//%W-533.1
			Case of 
					
					//======================================
				: ($length=0)
					
					// ERROR
					
					//======================================
				: ($length>=2) && ($range[[1]]="^")  // Up to major
					
					This:C1470.min:=cs:C1710.version.new(Delete string:C232($range; 1; 1))
					This:C1470.max:=This:C1470.min.maxMajor()
					
					//======================================
				: ($length>=2) && ($range[[1]]="~")  // Up to minor
					
					This:C1470.min:=cs:C1710.version.new(Delete string:C232($range; 1; 1))
					This:C1470.max:=This:C1470.min.maxMinor()
					
					//======================================
				: ($length>=2) && ($range[[1]]=">")  // Up to minor
					
					If ($range[[2]]="=")  // Up to minor
						
						If ($length>=3)
							
							This:C1470.min:=cs:C1710.version.new(Delete string:C232($range; 1; 2))
							
						Else 
							
							// ERROR
							
						End if 
						
					Else 
						
						This:C1470.min:=cs:C1710.version.new(Delete string:C232($range; 1; 1))
						This:C1470.min.increment("patch")
						
					End if 
					
					This:C1470.semver:=This:C1470.semver || cs:C1710.semver.new()
					This:C1470.max:=This:C1470.semver.vMax
					
					//======================================
				: ($length>=2) && ($range[[1]]="<")  // Up to minor
					
					If ($range[[2]]="=")
						
						If ($length>=3)
							
							This:C1470.max:=cs:C1710.version.new(Delete string:C232($range; 1; 2))
							
						Else 
							
							// ERROR
							
						End if 
						
					Else 
						
						This:C1470.max:=cs:C1710.version.new(Delete string:C232($range; 1; 1))
						This:C1470.max.decrement("patch")
						
					End if 
					
					This:C1470.semver:=This:C1470.semver || cs:C1710.semver.new()
					This:C1470.min:=This:C1470.semver.v0
					
					//======================================
				: ($length>=2) && ($range[[1]]="=")  // Equal to
					
					This:C1470.min:=cs:C1710.version.new(Delete string:C232($range; 1; 1))
					This:C1470.max:=This:C1470.min
					
					//======================================
				: ($length>=2) && (Position:C15(" - "; $range)>0)
					
					$c:=Split string:C1554($range; " - ")
					This:C1470.min:=cs:C1710.version.new($c[0])
					This:C1470.max:=cs:C1710.version.new($c[1])
					
					//======================================
				Else   // Simple one, ie. exact version
					
					This:C1470.min:=cs:C1710.version.new($range)
					This:C1470.max:=This:C1470.min
					
					//======================================
			End case 
			//%W+533.1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			ASSERT:C1129(False:C215; "Unknown input for range version")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function satisfiedBy($version) : Boolean
	
	var $result : Boolean
	
	$result:=This:C1470.min.lte($version)
	
	If ($result)
		
		$result:=This:C1470.max.gte($version)
		
	End if 
	
	return $result