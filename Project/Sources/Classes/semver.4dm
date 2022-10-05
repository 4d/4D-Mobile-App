// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.v0:=cs:C1710.version.new(0; 0; 0)
	This:C1470.v1:=cs:C1710.version.new(1; 0; 0)
	This:C1470.vMax:=cs:C1710.version.new(MAXLONG:K35:2; MAXLONG:K35:2; MAXLONG:K35:2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function version($major; $minor; $patch) : cs:C1710.version
	
	return cs:C1710.version.new(Copy parameters:C1790)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function major($version) : Integer
	
	return cs:C1710.version.new($version).major
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function minor($version) : Integer
	
	return cs:C1710.version.new($version).minor
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function patch($version) : Integer
	
	return cs:C1710.version.new($version).patch
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function valid($version) : Boolean
	
	return cs:C1710.version.new($version).valid
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function compare($v1; $v2) : Integer
	
	return cs:C1710.version.new($v1).compareTo($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function gt($v1; $v2) : Boolean
	
	return cs:C1710.version.new($v1).gt($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function gte($v1; $v2) : Boolean
	
	return cs:C1710.version.new($v1).gte($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function lt($v1; $v2) : Boolean
	
	return cs:C1710.version.new($v1).lt($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function lte($v1; $v2) : Boolean
	
	return cs:C1710.version.new($v1).lte($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function eq($v1; $v2) : Boolean
	
	return cs:C1710.version.new($v1).eq($v2)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function range($rangeInfo) : cs:C1710.semverRange
	
	var $range : cs:C1710.semverRange
	
	$range:=cs:C1710.semverRange.new($rangeInfo)
	$range.semver:=This:C1470
	
	return $range