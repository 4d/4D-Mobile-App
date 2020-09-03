Class constructor
	var $1 : Text
	
	var lastError : Object
	
	This:C1470.errors:=""
	This:C1470.stack:=New collection:C1472
	This:C1470.current:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470[$1]()
		
	End if 
	
	//===================================================================================
Function install  // Installs the passed error-handling method
	var $1 : Text
	
	This:C1470.__record()
	
	If ($1#This:C1470.current)
		
		// Install the method
		ON ERR CALL:C155($1)
		This:C1470.current:=$1
		
	End if 
	
	CLEAR VARIABLE:C89(ERROR)
	CLEAR VARIABLE:C89(ERROR METHOD)
	CLEAR VARIABLE:C89(ERROR LINE)
	CLEAR VARIABLE:C89(ERROR FORMULA)
	
	//===================================================================================
Function deinstall  // Deinstalls the last error-handling method and restore the previous one
	var $t : Text
	
	If (This:C1470.stack.length>0)
		
		// Get the previous method if any
		$t:=String:C10(This:C1470.stack.shift())
		
	Else 
		
		// NO MORE ERROR CAPTURE
		
	End if 
	
	This:C1470.current:=$t
	
	ON ERR CALL:C155($t)
	
	//===================================================================================
Function capture  // Installs a local capture of the errors
	
	lastError:=Null:C1517
	
	This:C1470.__record()
	
	// Install the method
	ON ERR CALL:C155("errors_CAPTURE")
	
	This:C1470.current:="errors_CAPTURE"
	
	//===================================================================================
Function noError  // Returns true if no errors were encountered during a capture phase
	
	var $0 : Boolean
	
	$0:=(lastError=Null:C1517)
	
	//===================================================================================
Function lastError  // Returns the last error encountered during a capture phase
	var $0 : Object
	
/*
{
"error" : error code,
"method" : method name
"line" : line number
"formula" : line code
"stack" : [
{
"code" : error code,
"component" : compoinent code,
"desc" : description
},
...
]
*/
	
	$0:=lastError
	
	//===================================================================================
Function release
	
	If (This:C1470.current="errors_CAPTURE")
		
		This:C1470.deinstall()
		
	End if 
	
	//===================================================================================
Function hide  // Hide errors
	
	This:C1470.__record()
	
	// Install the method
	ON ERR CALL:C155("errors_HIDE")
	
	This:C1470.current:="errors_HIDE"
	
	//===================================================================================
Function show  // Removes the hide errors method
	
	If (This:C1470.current="errors_HIDE")\
		 | (This:C1470.current="errors_CAPTURE")
		
		This:C1470.deinstall()
		
	End if 
	
	//===================================================================================
Function reset  // Reinit the stack & stop the trapping of errors
	
	This:C1470.stack:=New collection:C1472
	This:C1470.current:=""
	
	ON ERR CALL:C155("")
	
	//===================================================================================
Function __record  // 🛠 Record the current method called on error
	
	This:C1470.stack.unshift(Method called on error:C704)