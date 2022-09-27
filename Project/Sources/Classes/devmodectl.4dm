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
	
	// list connected devices and their Developer Mode
Function list()->$devices : Collection
	var $cmd : Text
	$cmd:="xcrun devmodectl list"
	
	This:C1470.launch($cmd)
	
	$devices:=New collection:C1472()
	If (This:C1470.success)
		var $lines; $deviceValues : Collection
		$lines:=Split string:C1554(This:C1470.outputStream; "\n")
		
		var $line : Text
		$line:=$lines.shift()
		// XXX In dev could assert if header $line change.
		For each ($line; $lines)
			
			$deviceValues:=Split string:C1554($line; "\t")
			If ($deviceValues.length>1)
				$devices.push(New object:C1471("udid"; $deviceValues[0]; "devModeStatus"; $deviceValues[1]))
			End if 
			
		End for each 
		
	End if 
	
	// sets up Developer Mode for a single device
Function single($deviceUDID : Text)
	var $cmd : Text
	$cmd:="xcrun devmodectl "+$deviceUDID
	
	This:C1470.launch($cmd)
	
	// performs setup in a streaming fashion (as devices come-in)
Function streaming($options : Object)->$worker : 4D:C1709.SystemWorker
	var $cmd : Text
	$cmd:="xcrun devmodectl streaming"
	$worker:=4D:C1709.SystemWorker.new($cmd; $options)
	