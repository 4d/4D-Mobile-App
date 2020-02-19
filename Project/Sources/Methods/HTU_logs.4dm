//%attributes = {}
C_OBJECT:C1216($logger)

If (False:C215)
	
	  //***************************************************************************************************
	  //        Create a log file named "log.txt" into the 4D logs folder or reset it if it exists
	  //***************************************************************************************************
	$logger:=logger ("log.txt").reset()
	
	$logger.info("logger.info(message)")  // Since the default value of "verbose" is false, this line will not be written
	$logger.warning("logger.warning(message)")  // Warnings and errors are always written
	$logger.error("logger.error(message)")
	
	$logger.verbose:=True:C214  // "verbose" authorizes the logging of information
	$logger.info("Hello world")  // This will be written since verbose is True
	
	If (Shift down:C543)
		
		$logger.open()  // Opens the log file with the default text editor
		
	End if 
End if 

If (True:C214)
	
	  //***************************************************************************************************
	  //   Create a log file named "test.log" into the user/library/logs folder or reset it if it exists
	  //***************************************************************************************************
	$logger:=logger ("~/Library/Logs/test.log").reset()
	
	$logger.info("logger.info(message)")  // Since the default value of "verbose" is false, this line will not be written
	$logger.warning("logger.warning(message)")  // Log a warning
	$logger.error("logger.error(message)")  // Log an error
	
	$logger.line()  // Insert a line
	$logger.log("\n")  // Insert a blank line
	
	$logger.verbose:=True:C214  // "verbose" authorizes the logging of information
	
	$logger.info(New object:C1471(\
		"test";"Hello world"))  // Objects are stringified
	
	$logger.line("\n")
	$logger.log("-> START")  // Insert a user trace
	$logger.info(True:C214)  // Booleans are stringified
	$logger.log("<- STOP")
	$logger.log("\n")
	
	$logger.line("=-";30)  // Insert a user define line
	$logger.info(Pi:K30:1)  // Numeric are stringified
	$logger.line("=-";30)
	$logger.line("\n")
	
	$logger.log("logger.log(message,level)";Warning message:K38:2)  // Put a warning
	
	$logger.log("\n")
	$logger.trace()  // Log the call chain
	
	If (Shift down:C543)
		
		$logger.open()  // Opens the log file with the default application to browse logs, generally Console.app
		
	End if 
End if 

If (False:C215)
	
	  //***************************************************************************************************
	  //                 Init the log into the system debugging environment
	  //***************************************************************************************************
	$logger:=logger 
	
	$logger.info("logger.info(message)")
	$logger.warning("logger.warning(message)")
	$logger.error("logger.error(message)")
	
	$logger.verbose:=True:C214
	$logger.info("Hello world")
	
	  //***************************************************************************************************
	  //      Change the destination of messages to the 4D diagnostic log file and start log if any
	  //***************************************************************************************************
	$logger.setDestination(Into 4D diagnostic log:K38:8).start()
	
	$logger.line()  // Insert a line
	
	$logger.info("logger.info(message)")
	$logger.warning("logger.warning(message)")
	$logger.error("logger.error(message)")
	
	$logger.verbose:=True:C214
	$logger.info("Hello world")
	
	$logger.line()  // Insert a line
	
	$logger.stop()  // Restore the previous state of the Diagnostic log recording
	
End if 