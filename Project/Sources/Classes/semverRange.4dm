
Class constructor($variant : Variant)
	
	Case of 
		: (Value type:C1509($variant)=Is collection:K8:32)
			
			ASSERT:C1129(($variant.length=2); "range must count two version")
			This:C1470.min:=$variant[0]/*first*/
			This:C1470.max:=$variant[$variant.length-1]/*last*/
			
		: (Value type:C1509($variant)=Is object:K8:27)
			
			If (($variant.min#Null:C1517) & ($variant.max#Null:C1517))
				This:C1470.min:=cs:C1710.version.new($variant.min)
				This:C1470.max:=cs:C1710.version.new($variant.max)
			Else   // one version passed?
				This:C1470.min:=cs:C1710.version.new($variant)
				This:C1470.max:=This:C1470.min
			End if 
			
		: (Value type:C1509($variant)=Is text:K8:3)
			
			ASSERT:C1129(Length:C16($variant)>0; "range could not be empty text")
			
			//%W-533.1
			Case of 
				: ($variant[[1]]="^")  // up to major
					
					This:C1470.min:=cs:C1710.version.new(Substring:C12($variant; 2))
					This:C1470.max:=This:C1470.min.maxMajor()
					
				: ($variant[[1]]="~")  // up to minor
					
					This:C1470.min:=cs:C1710.version.new(Substring:C12($variant; 2))
					This:C1470.max:=This:C1470.min.maxMinor()
					
				: ($variant[[1]]=">")  // up to minor
					
					If ($variant[[2]]="=")  // up to minor
						This:C1470.min:=cs:C1710.version.new(Substring:C12($variant; 3))
					Else 
						This:C1470.min:=cs:C1710.version.new(Substring:C12($variant; 2))
						This:C1470.min.increment("patch")
					End if 
					If (This:C1470.semver=Null:C1517)
						This:C1470.semver:=cs:C1710.semver.new()
					End if 
					This:C1470.max:=This:C1470.semver.vMax
					
				: ($variant[[1]]="<")  // up to minor
					
					If ($variant[[2]]="=")
						This:C1470.max:=cs:C1710.version.new(Substring:C12($variant; 3))
					Else 
						This:C1470.max:=cs:C1710.version.new(Substring:C12($variant; 2))
						This:C1470.max.decrement("patch")
					End if 
					If (This:C1470.semver=Null:C1517)
						This:C1470.semver:=cs:C1710.semver.new()
					End if 
					This:C1470.min:=This:C1470.semver.v0
					
				: ($variant[[1]]="=")  // equal to
					
					This:C1470.min:=cs:C1710.version.new(Substring:C12($variant; 2))
					This:C1470.max:=This:C1470.min
					
				: (Position:C15(" - "; $variant)>0)
					var $versions : Collection
					$versions:=Split string:C1554($variant; " - ")
					This:C1470.min:=cs:C1710.version.new($versions[0])
					This:C1470.max:=cs:C1710.version.new($versions[1])
					
				Else   // simple one, ie. exact version
					This:C1470.min:=cs:C1710.version.new($variant)
					This:C1470.max:=This:C1470.min
			End case 
			//%W+533.1
			
		Else 
			
			ASSERT:C1129(False:C215; "Unknown input for range version")
			
	End case 
	
Function satisfiedBy($version : Variant)->$result : Boolean
	$result:=This:C1470.min.lte($version)
	If ($result)
		$result:=This:C1470.max.gte($version)
	End if 
	