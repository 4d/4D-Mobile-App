Class extends Entity

// Alias scalaires
exposed Alias aka_Nom Name

// Calculated Scalars
exposed Function get computedName()->$name : Text
	
	$name:=Uppercase:C13(This:C1470.Name)
	
exposed Function get computedAvatar()->$avatar : Picture
	
	CREATE THUMBNAIL:C679(This:C1470.Avatar; $avatar; 300; 400)
	
Function get computedNotExposed()->$result : Text
	
	$result:="test"
	
exposed Function get computedWithoutSetter()->$result : Text
	
	$result:="test"
	
exposed Function get computedWithSetter()->$result : Text
	
	$result:="test"
	
exposed Function set computedWithSetter($entry : Text)
	
	var $bool : Boolean
	
	$bool:=$entry#Null:C1517
	
exposed Function get computedWithSetterNonExposed()->$test : Text
	
	$test:="test"
	
Function set computedWithSetterNonExposed($entry : Text)
	
	var $bool : Boolean
	
	$bool:=$entry#Null:C1517
	
	// Calculated non-scalars
exposed Function get computedNonScalar()->$selection : cs:C1710.EmployesSelection