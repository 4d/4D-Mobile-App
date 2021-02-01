
Class extends externalProcess

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.cmd:="java"  // TODO : find java? in config or JAVA_HOME or ? or which java on unix
	
	This:C1470._version()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _version
	
	var $o : Object
	
	This:C1470.resultInErrorStream:=True:C214
	$o:=This:C1470.launch(This:C1470.cmd; New collection:C1472("-version"))
	This:C1470.resultInErrorStream:=False:C215
	
	ARRAY LONGINT:C221($pos; 0x0000)
	ARRAY LONGINT:C221($len; 0x0000)
	
	If (Match regex:C1019("(?m-si)java version \"([^\"]*)\""; $o.error; 1; $pos; $len))
		
		This:C1470.version:=Substring:C12($o.error; $pos{1}; $len{1})
		
	End if 