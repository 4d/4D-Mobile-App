

Class constructor
	C_VARIANT:C1683($1; $2; $3)
	var $counts : Integer
	$counts:=Count parameters:C259
	Case of   // fix count parameters from formula
		: (Undefined:C82($1))
			$counts:=0
		: (Undefined:C82($2))
			$counts:=1
		: (Undefined:C82($3))
			$counts:=2
	End case 
	This:C1470.valid:=True:C214
	Case of 
		: ($counts=1)
			
			Case of 
				: (Value type:C1509($1)=Is text:K8:3)
					C_COLLECTION:C1488($col)
					$col:=Split string:C1554($1; ".")
					Case of 
						: ($col.length>2)
							This:C1470.major:=Num:C11($col[0])
							This:C1470.minor:=Num:C11($col[1])
							This:C1470.patch:=Num:C11($col[2])
						: ($col.length>1)
							This:C1470.major:=Num:C11($col[0])
							This:C1470.minor:=Num:C11($col[1])
							This:C1470.patch:=0
						: ($col.length>0)
							This:C1470.major:=Num:C11($col[0])
							This:C1470.minor:=0
							This:C1470.patch:=0
						Else 
							This:C1470.major:=0
							This:C1470.minor:=0
							This:C1470.patch:=0
							This:C1470.valid:=False:C215
					End case 
					
				: (Value type:C1509($1)=Is collection:K8:32)
					Case of 
						: ($1.length>2)
							This:C1470.major:=Num:C11($1[0])
							This:C1470.minor:=Num:C11($1[1])
							This:C1470.patch:=Num:C11($1[2])
						: ($1.length>1)
							This:C1470.major:=Num:C11($1[0])
							This:C1470.minor:=Num:C11($1[1])
							This:C1470.patch:=0
						: ($1.length>0)
							This:C1470.major:=Num:C11($1[0])
							This:C1470.minor:=0
							This:C1470.patch:=0
						Else 
							This:C1470.major:=0
							This:C1470.minor:=0
							This:C1470.patch:=0
							This:C1470.valid:=False:C215
					End case 
				: (Value type:C1509($1)=Is object:K8:27)
					This:C1470.major:=$1.major
					This:C1470.minor:=$1.minor
					This:C1470.patch:=$1.patch
				Else   // expect num
					This:C1470.major:=Num:C11($1)
					This:C1470.minor:=0
					This:C1470.patch:=0
			End case 
		: ($counts=2)
			This:C1470.major:=Num:C11($1)
			This:C1470.minor:=Num:C11($2)
			This:C1470.patch:=0
		: ($counts>2)
			This:C1470.major:=Num:C11($1)
			This:C1470.minor:=Num:C11($2)
			This:C1470.patch:=Num:C11($3)
		Else 
			This:C1470.major:=0
			This:C1470.minor:=0
			This:C1470.patch:=0
			This:C1470.valid:=False:C215
	End case 
	
Function compareTo($version : Variant)->$result : Integer
	var $that : Object
	$that:=cs:C1710.version.new($version)
	
	Case of 
		: (This:C1470.major>$that.major)
			$result:=1
		: (This:C1470.major<$that.major)
			$result:=-1
		Else   // major equal
			Case of 
				: (This:C1470.minor>$that.minor)
					$result:=1
				: (This:C1470.minor<$that.minor)
					$result:=-1
				Else   // minor equal
					Case of 
						: (This:C1470.patch>$that.patch)
							$result:=1
						: (This:C1470.patch<$that.patch)
							$result:=-1
						Else   // patch equal
							$result:=0
					End case 
			End case 
	End case 
	
Function gt($version : Variant)->$result : Boolean
	$result:=This:C1470.compareTo($version)>0
	
Function gte($version : Variant)->$result : Boolean
	$result:=This:C1470.compareTo($version)>=0
	
Function lt($version : Variant)->$result : Boolean
	$result:=This:C1470.compareTo($version)<0
	
Function lte($version : Variant)->$result : Boolean
	$result:=This:C1470.compareTo($version)<=0
	
Function eq($version : Variant)->$result : Boolean
	$result:=This:C1470.equalTo($version)
	
Function neq($version : Variant)->$result : Boolean
	$result:=Not:C34(This:C1470.eq($version))  // PERF: implement it instead of using Not
	
Function equalTo($version : Variant)->$result : Boolean
	var $that : Object
	$that:=cs:C1710.version.new($version)
	
	If (This:C1470.major#$that.major)
		$result:=False:C215
	Else   // major equal
		If (This:C1470.minor#$that.minor)
			$result:=False:C215
		Else   // minor equal
			If (This:C1470.patch#$that.patch)
				$result:=False:C215
			Else   // patch equal
				$result:=True:C214
			End if 
		End if 
	End if 
	
Function inc($part : Text)
	This:C1470.increment($part)
	
Function increment($part : Text)
	Case of 
		: ($part="major")
			This:C1470.major:=This:C1470.major+1
		: ($part="minor")
			This:C1470.minor:=This:C1470.minor+1
		: ($part="patch")
			This:C1470.patch:=This:C1470.patch+1
		Else 
			ASSERT:C1129(False:C215; "Incorrect type of level "+String:C10($part))
	End case 
	
Function decrement($part : Text)
	Case of 
		: ($part="major")
			ASSERT:C1129(This:C1470.major>0; "Cannot decrement a 0 major version")
			This:C1470.major:=This:C1470.major-1
			
		: ($part="minor")
			If (This:C1470.minor=0)
				This:C1470.minor:=MAXLONG:K35:2
				This:C1470.decrement("major")
			Else 
				This:C1470.minor:=This:C1470.minor-1
			End if 
			
		: ($part="patch")
			If (This:C1470.patch=0)
				This:C1470.patch:=MAXLONG:K35:2
				This:C1470.decrement("minor")
			Else 
				This:C1470.patch:=This:C1470.patch-1
			End if 
		Else 
			ASSERT:C1129(False:C215; "Incorrect type of level "+String:C10($part))
	End case 
	
Function maxMinor()->$version : Object
	$version:=cs:C1710.version.new(This:C1470.major; This:C1470.minor; MAXLONG:K35:2)
	
Function maxMajor()->$version : Object
	$version:=cs:C1710.version.new(This:C1470.major; MAXLONG:K35:2; MAXLONG:K35:2)
	