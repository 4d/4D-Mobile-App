Class extends Entity

exposed Function get computedName()->$name : Text
	
	$name:=Uppercase:C13(This:C1470.Name)
	
exposed Function get picture()->$avatar : Picture
	
	CREATE THUMBNAIL:C679(This:C1470.Avatar; $avatar; 300; 400)
	
Function get notExposed()->$result : Text
	
	$result:="test"
	
exposed Function get withSetter()->$result : Text
	
	$result:="test"
	
exposed Function set withSetter($entry : Text)
	
	var $bool : Boolean
	
	$bool:=$entry#Null:C1517
	
exposed Function get withSetterNonExposed()->$result : Text
	
	$result:="test"
	
Function set withSetterNonExposed($entry : Text)
	
	var $bool : Boolean
	
	$bool:=$entry#Null:C1517