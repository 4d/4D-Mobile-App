Class constructor
	
	This:C1470.message:="Hello World"
	
Function get hello() : Text
	
	return (This:C1470.message)
	
Function set hello($text : Text)
	
	This:C1470.message:=$text
	
Function bool($bool : Boolean) : Boolean
	
	return (Count parameters:C259>=1 ? $bool : True:C214)