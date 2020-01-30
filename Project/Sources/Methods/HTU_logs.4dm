//%attributes = {}
C_OBJECT:C1216($o)

If (False:C215)
	
	  //***************************************************************************************************
	  //        Create a log file named "log.txt" into the 4D logs folder or reset it if it exists
	  //***************************************************************************************************
	$o:=logger ("log.txt").reset()
	
	$o.info("logger.info(message)")  // Since the default value of "verbose" is false, this line will not be written
	$o.warning("logger.warning(message)")  // Warnings and errors are always written
	$o.error("logger.error(message)")
	
	$o.verbose:=True:C214  // "verbose" authorizes the logging of information
	$o.info("Hello world")  // This will be written since verbose is True
	
	If (Shift down:C543)
		
		$o.open()  // Opens the log file with the default text editor
		
	End if 
End if 

If (True:C214)
	
	  //***************************************************************************************************
	  //   Create a log file named "test.log" into the user/library/logs folder or reset it if it exists
	  //***************************************************************************************************
	$o:=logger ("~/Library/Logs/test.log").reset()
	
	$o.info("logger.info(message)")  // Since the default value of "verbose" is false, this line will not be written
	$o.warning("logger.warning(message)")  // Log a warning
	$o.error("logger.error(message)")  // Log an error
	
	$o.line()  // Insert a line
	$o.log("\n")  // Insert a blank line
	
	$o.verbose:=True:C214  // "verbose" authorizes the logging of information
	
	$o.info(New object:C1471(\
		"test";"Hello world"))  // Objects are stringified
	
	$o.line("\n")
	$o.log("-> START")  // Insert a user trace
	$o.info(True:C214)  // Booleans are stringified
	$o.log("<- STOP")
	$o.log("\n")
	
	$o.line("=-";30)  // Insert a user define line
	$o.info(Pi:K30:1)  // Numeric are stringified
	$o.line("=-";30)
	$o.line("\n")
	
	$o.log("logger.log(message,level)";Warning message:K38:2)  // Put a warning
	
	$o.log("\n")
	$o.trace()  // Log the call chain
	
	If (Shift down:C543)
		
		$o.open()  // Opens the log file with the default application to browse logs, generally Console.app
		
	End if 
End if 

If (False:C215)
	
	  //***************************************************************************************************
	  //                 Init the log into the system debugging environment
	  //***************************************************************************************************
	$o:=logger 
	
	$o.info("logger.info(message)")
	$o.warning("logger.warning(message)")
	$o.error("logger.error(message)")
	
	$o.verbose:=True:C214
	$o.info("Hello world")
	
	  //***************************************************************************************************
	  //      Change the destination of messages to the 4D diagnostic log file and start log if any
	  //***************************************************************************************************
	$o.setDestination(Into 4D diagnostic log:K38:8).start()
	
	$o.line()  // Insert a line
	
	$o.info("logger.info(message)")
	$o.warning("logger.warning(message)")
	$o.error("logger.error(message)")
	
	$o.verbose:=True:C214
	$o.info("Hello world")
	
	$o.line()  // Insert a line
	
	$o.stop()  // Restore the previous state of the Diagnostic log recording
	
End if 