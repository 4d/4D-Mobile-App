Class constructor($shortcut : Text)
	
	var lastError : Object
	
	This:C1470.stack:=New collection:C1472
	This:C1470.current:=""
	
	If (Count parameters:C259>=1)
		
		This:C1470[$shortcut]()
		
	End if 
	
	//===================================================================================
	/// Installs the passed error-handling method
Function install($method : Text)
	
	This:C1470._record()
	
	If ($method#This:C1470.current)
		
		// Install the method
		ON ERR CALL:C155($method)
		This:C1470.current:=$method
		
	End if 
	
	CLEAR VARIABLE:C89(ERROR)
	CLEAR VARIABLE:C89(ERROR METHOD)
	CLEAR VARIABLE:C89(ERROR LINE)
	CLEAR VARIABLE:C89(ERROR FORMULA)
	
	//===================================================================================
	/// Deinstalls the last error-handling method and restore the previous one
Function deinstall
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
	/// Installs a local capture of the errors
Function capture()
	
	lastError:=Null:C1517
	
	This:C1470._record()
	
	// Install the method
	ON ERR CALL:C155("err_CAPTURE")
	
	This:C1470.current:="err_CAPTURE"
	
	//===================================================================================
	/// Hide errors
Function hide()->$this : cs:C1710.error
	
	This:C1470._record()
	
	// Install the method
	ON ERR CALL:C155("err_HIDE")
	
	This:C1470.current:="err_HIDE"
	
	$this:=This:C1470
	
	//===================================================================================
Function ignoreLastError()
	
	lastError:=Null:C1517
	
	//===================================================================================
	/// Returns true if no errors were encountered during a capture phase
Function noError()->$noError : Boolean
	
	$noError:=(lastError=Null:C1517)
	
	//===================================================================================
	/// Returns true if errors were encountered during a capture phase
Function withError()->$withError : Boolean
	
	$withError:=(lastError#Null:C1517)
	
	//===================================================================================
	/// Returns the last error encountered during a capture phase
Function lastError()->$error : Object
	
	$error:=lastError
	
	//===================================================================================
	/// Returns the stack of error descriptions
Function errors()->$desc : Collection
	
	If (lastError.stack#Null:C1517)
		
		$desc:=lastError.stack.extract("desc")
		
	End if 
	
	//===================================================================================
Function release
	
	If (This:C1470.current="err_CAPTURE")
		
		This:C1470.deinstall()
		
	End if 
	
	//===================================================================================
	/// Removes the hide errors method
Function show
	
	If (This:C1470.current="err_HIDE")\
		 | (This:C1470.current="err_CAPTURE")
		
		This:C1470.deinstall()
		
	End if 
	
	//===================================================================================
Function reset  // Reinit the stack & stop the trapping of errors
	
	This:C1470.stack:=New collection:C1472
	This:C1470.current:=""
	
	ON ERR CALL:C155("")
	
	//===================================================================================
Function _record  // 🛠 Record the current method called on error
	
	This:C1470.stack.unshift(Method called on error:C704)