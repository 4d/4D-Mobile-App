
Class constructor
	This:C1470.v0:=cs:C1710.version.new(0; 0; 0)
	This:C1470.v1:=cs:C1710.version.new(1; 0; 0)
	This:C1470.vMax:=cs:C1710.version.new(MAXLONG:K35:2; MAXLONG:K35:2; MAXLONG:K35:2)
	
Function version()->$version : Object
	C_VARIANT:C1683(${1})
	Case of 
		: (Count parameters:C259>2)
			$version:=cs:C1710.version.new($1; $2; $3)
		: (Count parameters:C259>1)
			$version:=cs:C1710.version.new($1; $2)
		: (Count parameters:C259>0)
			$version:=cs:C1710.version.new($1)
		Else 
			$version:=cs:C1710.version.new()
	End case 
	
Function major($v1 : Variant)->$result : Integer
	$result:=cs:C1710.version.new($v1).major
	
Function minor($v1 : Variant)->$result : Integer
	$result:=cs:C1710.version.new($v1).minor
	
Function patch($v1 : Variant)->$result : Integer
	$result:=cs:C1710.version.new($v1).patch
	
Function valid($v1 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).valid
	
Function compare($v1 : Variant; $v2 : Variant)->$result : Integer
	$result:=cs:C1710.version.new($v1).compareTo($v2)
	
Function gt($v1 : Variant; $v2 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).gt($v2)
	
Function gte($v1 : Variant; $v2 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).gte($v2)
	
Function lt($v1 : Variant; $v2 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).lt($v2)
	
Function lte($v1 : Variant; $v2 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).lte($v2)
	
Function eq($v1 : Variant; $v2 : Variant)->$result : Boolean
	$result:=cs:C1710.version.new($v1).eq($v2)
	
Function range($rangeInfo : Variant)->$range : Object
	$range:=cs:C1710.semverRange.new($rangeInfo)
	$range.semver:=This:C1470
	