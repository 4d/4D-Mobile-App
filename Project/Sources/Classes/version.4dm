// === === === === === === === === === === === === === === === === === === === === ===
Class constructor($version; $minor; $patch)
	
	var $counts : Integer
	var $c : Collection
	
	$counts:=Count parameters:C259
	
	This:C1470.valid:=True:C214
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($counts=1)
			
			Case of 
					
					//======================================
				: (Value type:C1509($version)=Is text:K8:3)
					
					$c:=Split string:C1554($version; ".")
					
					Case of 
							
							//……………………………………………………………………………………………………
						: ($c.length>2)
							
							This:C1470.major:=Num:C11($c[0])
							This:C1470.minor:=Num:C11($c[1])
							This:C1470.patch:=Num:C11($c[2])
							
							//……………………………………………………………………………………………………
						: ($c.length>1)
							
							This:C1470.major:=Num:C11($c[0])
							This:C1470.minor:=Num:C11($c[1])
							This:C1470.patch:=0
							
							//……………………………………………………………………………………………………
						: ($c.length>0)
							
							This:C1470.major:=Num:C11($c[0])
							This:C1470.minor:=0
							This:C1470.patch:=0
							
							//……………………………………………………………………………………………………
						Else 
							
							This:C1470.major:=0
							This:C1470.minor:=0
							This:C1470.patch:=0
							This:C1470.valid:=False:C215
							
							//……………………………………………………………………………………………………
					End case 
					
					//======================================
				: (Value type:C1509($version)=Is collection:K8:32)
					
					Case of 
							
							//……………………………………………………………………………………………………
						: ($version.length>2)
							
							This:C1470.major:=Num:C11($version[0])
							This:C1470.minor:=Num:C11($version[1])
							This:C1470.patch:=Num:C11($version[2])
							
							//……………………………………………………………………………………………………
						: ($version.length>1)
							
							This:C1470.major:=Num:C11($version[0])
							This:C1470.minor:=Num:C11($version[1])
							This:C1470.patch:=0
							
							//……………………………………………………………………………………………………
						: ($version.length>0)
							
							This:C1470.major:=Num:C11($version[0])
							This:C1470.minor:=0
							This:C1470.patch:=0
							
							//……………………………………………………………………………………………………
						Else 
							
							This:C1470.major:=0
							This:C1470.minor:=0
							This:C1470.patch:=0
							This:C1470.valid:=False:C215
							
							//……………………………………………………………………………………………………
					End case 
					
					//======================================
				: (Value type:C1509($version)=Is object:K8:27)
					
					This:C1470.major:=$version.major
					This:C1470.minor:=$version.minor
					This:C1470.patch:=$version.patch
					
					//======================================
				Else   // Expect num
					
					This:C1470.major:=Num:C11($version)
					This:C1470.minor:=0
					This:C1470.patch:=0
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($counts=2)
			
			This:C1470.major:=Num:C11($version)
			This:C1470.minor:=Num:C11($minor)
			This:C1470.patch:=0
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($counts>2)
			
			This:C1470.major:=Num:C11($version)
			This:C1470.minor:=Num:C11($minor)
			This:C1470.patch:=Num:C11($patch)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			This:C1470.major:=0
			This:C1470.minor:=0
			This:C1470.patch:=0
			This:C1470.valid:=False:C215
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function compareTo($version) : Integer
	
	var $that : cs:C1710.version
	
	$that:=cs:C1710.version.new($version)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.major>$that.major)
			
			return 1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.major<$that.major)
			
			return -1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else   // Major equal
			
			Case of 
					
					//======================================
				: (This:C1470.minor>$that.minor)
					
					return 1
					
					//======================================
				: (This:C1470.minor<$that.minor)
					
					return -1
					
					//======================================
				Else   // Minor equal
					
					Case of 
							
							//……………………………………………………………………………………………………
						: (This:C1470.patch>$that.patch)
							
							return 1
							
							//……………………………………………………………………………………………………
						: (This:C1470.patch<$that.patch)
							
							return -1
							
							//……………………………………………………………………………………………………
						Else   // Patch equal
							
							return 0
							
							//……………………………………………………………………………………………………
					End case 
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function gt($version) : Boolean
	
	return This:C1470.compareTo($version)>0
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function gte($version) : Boolean
	
	return This:C1470.compareTo($version)>=0
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function lt($version) : Boolean
	
	return This:C1470.compareTo($version)<0
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function lte($version) : Boolean
	
	return This:C1470.compareTo($version)<=0
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function eq($version) : Boolean
	
	return This:C1470.equalTo($version)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function neq($version) : Boolean
	
	return Not:C34(This:C1470.eq($version))  // PERF: implement it instead of using Not
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function equalTo($version : Variant) : Boolean
	
	var $that : cs:C1710.version
	
	$that:=cs:C1710.version.new($version)
	
	If (This:C1470.major#$that.major)
		
		return False:C215
		
	Else   // Major equal
		
		If (This:C1470.minor#$that.minor)
			
			return False:C215
			
		Else   // Minor equal
			
			If (This:C1470.patch#$that.patch)
				
				return False:C215
				
			Else   // Patch equal
				
				return True:C214
				
			End if 
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function inc($part : Text)
	
	This:C1470.increment($part)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function increment($part : Text)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="major")
			
			This:C1470.major:=This:C1470.major+1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="minor")
			
			This:C1470.minor:=This:C1470.minor+1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="patch")
			
			This:C1470.patch:=This:C1470.patch+1
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			ASSERT:C1129(False:C215; "Incorrect type of level "+String:C10($part))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function decrement($part : Text)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="major")
			
			ASSERT:C1129(This:C1470.major>0; "Cannot decrement a 0 major version")
			This:C1470.major:=This:C1470.major>0 ? This:C1470.major-1 : 0
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="minor")
			
			If (This:C1470.minor=0)
				
				This:C1470.minor:=MAXLONG:K35:2
				This:C1470.decrement("major")
				
			Else 
				
				ASSERT:C1129(This:C1470.minor>0; "Cannot decrement a 0 minor version")
				This:C1470.minor:=This:C1470.minor>0 ? This:C1470.minor-1 : 0
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($part="patch")
			
			If (This:C1470.patch=0)
				
				This:C1470.patch:=MAXLONG:K35:2
				This:C1470.decrement("minor")
				
			Else 
				
				ASSERT:C1129(This:C1470.patch>0; "Cannot decrement a 0 patch version")
				This:C1470.patch:=This:C1470.patch>0 ? This:C1470.patch-1 : 0
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			ASSERT:C1129(False:C215; "Incorrect type of level "+String:C10($part))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function maxMinor() : Object
	
	return cs:C1710.version.new(This:C1470.major; This:C1470.minor; MAXLONG:K35:2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function maxMajor() : Object
	
	return cs:C1710.version.new(This:C1470.major; MAXLONG:K35:2; MAXLONG:K35:2)