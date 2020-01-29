//%attributes = {}
C_OBJECT:C1216($o)

  //***************************************************************************************************
  //        Create a log file named "log.txt" into the 4D logs folder or reset it if it exists
  //***************************************************************************************************
$o:=logs ("log.txt").reset()

$o.infos("Hello world")  // Since the default value of "verbose" is false, this line will not be written
$o.warning("a statement or event that indicates a possible or impending danger, problem, or other unpleasant situation.")  // Warnings and errors are always written
$o.error("a message indicating that an incorrect instruction has been given, or that there is an error resulting from faulty software or hardware.")
$o.verbose:=True:C214  // "verbose" authorizes the logging of information
$o.infos("Hello world")  // This will be written since verbose is True

If (Shift down:C543)
	
	$o.open()  // Opens the log file with the default text editor
	
End if 

  //***************************************************************************************************
  //   Create a log file named "test.log" into the user/library/logs folder or reset it if it exists
  //***************************************************************************************************
$o:=logs ("~/Library/Logs/test.log").reset()

$o.infos("Hello world")
$o.warning("a statement or event that indicates a possible or impending danger, problem, or other unpleasant situation.")
$o.error("a message indicating that an incorrect instruction has been given, or that there is an error resulting from faulty software or hardware.")
$o.verbose:=True:C214
$o.infos("Hello world")

If (Shift down:C543)
	
	$o.open()  // Opens the log file with the default application to browse logs, generally Console.app
	
End if 

  //***************************************************************************************************
  //                 Init the log into the system debugging environment
  //***************************************************************************************************
$o:=logs 

$o.infos("Hello world")
$o.warning("a statement or event that indicates a possible or impending danger, problem, or other unpleasant situation.")
$o.error("a message indicating that an incorrect instruction has been given, or that there is an error resulting from faulty software or hardware.")
$o.verbose:=True:C214
$o.infos("Hello world")

  //***************************************************************************************************
  //      Change the destination of messages to the 4D diagnostic log file and start log if any
  //***************************************************************************************************
$o.setDestination(Into 4D diagnostic log:K38:8).start()

$o.line()  // Insert a line

$o.infos("Hello world")
$o.warning("a statement or event that indicates a possible or impending danger, problem, or other unpleasant situation.")
$o.error("a message indicating that an incorrect instruction has been given, or that there is an error resulting from faulty software or hardware.")
$o.verbose:=True:C214
$o.infos("Hello world")

$o.line()  // Insert a line

$o.stop()  // Restore the previous state of the Diagnostic log recording