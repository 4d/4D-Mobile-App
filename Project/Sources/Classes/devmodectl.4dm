/*
devmodectl
SUBCOMMANDS:
    single                      sets up Developer Mode for a single device
    list                        list connected devices and their Developer Mode
                                status
    streaming                   performs setup in a streaming fashion (as
                                devices come-in)
    help                        prints helpful information

*/
Class extends lep

// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor()
	
	Super:C1705()
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// List connected devices and their Developer Mode
Function list()->$devices : Collection
	
	var $cmd; $line : Text
	var $c; $lines : Collection
	
	This:C1470.launch("xcrun devmodectl list")
	
	$devices:=New collection:C1472()
	
	If (This:C1470.success)
		
		$lines:=Split string:C1554(This:C1470.outputStream; "\n")
		
		$line:=$lines.shift()
		ASSERT:C1129(Match regex:C1019("(?m-si)^UDID\\s*Developer Mode Status$"; $line; 1))
		
		For each ($line; $lines)
			
			$c:=Split string:C1554($line; "\t")
			
			If ($c.length>=2)\
				 && ($devices.query("udid = :1"; $c[0]).pop()=Null:C1517)
				
				$devices.push(New object:C1471(\
					"udid"; $c[0]; \
					"devModeStatus"; $c[1]))
				
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets up Developer Mode for a single device
Function single($deviceUDID : Text)
	
	This:C1470.launch("xcrun devmodectl "+$deviceUDID)
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Performs setup in a streaming fashion (as devices come-in)
Function streaming($options : Object) : 4D:C1709.SystemWorker
	
	return 4D:C1709.SystemWorker.new("xcrun devmodectl streaming"; $options)
	