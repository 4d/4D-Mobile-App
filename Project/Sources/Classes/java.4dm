
Class extends externalProcess

Class constructor
	This:C1470.cmd:="java"  // TODO : find java? in config or JAVA_HOME or ? or which java on unix
	
Function version
	var $0 : Object
	$0:=This:C1470.launch(This:C1470.cmd; New collection:C1472("-version"))