Class constructor($target)
	
	var $name : Text
	var $mode; $state; $time : Integer
	
	Super:C1705()
	
	This:C1470.target:=Null:C1517
	
	This:C1470._verbose:=False:C215
	This:C1470.success:=True:C214
	
	This:C1470.component:=Folder:C1567(fk database folder:K87:14).name
	
	PROCESS PROPERTIES:C336(Current process:C322; $name; $state; $time; $mode)
	This:C1470.process:=$name
	This:C1470.isWorker:=($mode ?? 1)
	
	This:C1470.errors:=New collection:C1472()
	
	This:C1470.setTarget($target)
	
Function get verbose() : Boolean
	
	return (This:C1470._verbose)
	
Function set verbose($verbose : Boolean) : Boolean
	
	This:C1470._verbose:=$verbose
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function get lastError() : Text
	
	var $last : Integer
	$last:=This:C1470.errors.length-1
	
	If ($last>=0)
		
		return (This:C1470.errors[$last])
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function setTarget($target) : cs:C1710.logger
	
	var $file : 4D:C1709.File
	
	If ($target=Null:C1517)
		
		// Set the default location of the log file
		
		Case of 
				
				//______________________________________________________
			: (Is macOS:C1572)
				
				$target:="~/Library/Logs/"+Folder:C1567(fk database folder:K87:14).name+".log"
				
				//______________________________________________________
			: (Is Windows:C1573)
				
				$target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(fk database folder:K87:14; *).name).file(Folder:C1567(fk database folder:K87:14).name+".log")
				
				//______________________________________________________
		End case 
	End if 
	
	If (Value type:C1509($target)=Is longint:K8:6)\
		 | (Value type:C1509($target)=Is real:K8:4)
		
		If (This:C1470.isWorker)
			
			This:C1470._pushError("This target value cannot be used for a worker!")
			
		Else 
			
			This:C1470._restore()
			
			This:C1470.target:=$target
			This:C1470._destination:="4D"
			This:C1470.success:=True:C214
			
		End if 
		
	Else 
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($target)=Is text:K8:3)
				
				If (Position:C15("/"; $target)=0)
					
					$file:=Folder:C1567(fk logs folder:K87:17; *).file($target)
					
				Else 
					
					$file:=File:C1566(Replace string:C233($target; "~"; cs:C1710.path.new().userHome().path))
					
				End if 
				
				This:C1470._setTarget($file)
				
				//______________________________________________________
			: (Value type:C1509($target)=Is object:K8:27)
				
				If (OB Instance of:C1731($target; 4D:C1709.File))
					
					This:C1470._setTarget($target)
					
				Else 
					
					This:C1470._pushError("The object passed isn't a File object")
					
				End if 
				
				//______________________________________________________
			Else 
				
				This:C1470._pushError("target parameter must be a Text or a File object")
				
				//______________________________________________________
		End case 
	End if 
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function info($message) : cs:C1710.logger
	
	return (This:C1470._pushMessage($message; Information message:K38:1))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function warning($message) : cs:C1710.logger
	
	return (This:C1470._pushMessage($message; Warning message:K38:2))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function error($message) : cs:C1710.logger
	
	return (This:C1470._pushMessage($message; Error message:K38:3))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function log($message) : cs:C1710.logger
	
	return (This:C1470._pushMessage($message; 8858))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function line($line : Text; $count : Integer) : cs:C1710.logger
	
	$line:=$line || ("-"*80)
	
	If ($count>0)
		
		$line*=$count
		
	End if 
	
	If (This:C1470._destination="4D")
		
		LOG EVENT:C667(This:C1470.target; $line; Information message:K38:1)
		
	Else 
		
		This:C1470.target.setText(This:C1470.target.getText()+$line+"\n")
		
	End if 
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function trace() : cs:C1710.logger
	
	return (This:C1470.line("*"; 50)._pushMessage(Get call chain:C1662.query("name!=:1"; Current method name:C684); 8858).line("*"; 50))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function open()
	
	If (Value type:C1509(This:C1470.target)=Is object:K8:27)\
		 && (OB Instance of:C1731(This:C1470.target; 4D:C1709.File))
		
		OPEN URL:C673(String:C10(This:C1470.target.platformPath))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function start()
	
	If (This:C1470._destination="4D")
		
		//%T-
		Case of 
				
				//……………………………………………………………………………………………………
			: (This:C1470.isWorker)
				
				// Worker can't call SET DATABASE PARAMETER
				This:C1470._pushError(".start() cannot be used for a worker!")
				
				//______________________________________________________
			: (This:C1470.target=Into 4D commands log:K38:7)
				
				This:C1470.logStatus:=Get database parameter:C643(Debug log recording:K37:34)
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 1)
				This:C1470.success:=True:C214
				
				//______________________________________________________
			: (This:C1470.target=Into 4D diagnostic log:K38:8)
				
				This:C1470.logStatus:=Get database parameter:C643(Diagnostic log recording:K37:69)
				SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; 1)
				This:C1470.success:=True:C214
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				This:C1470.success:=False:C215
				
				//______________________________________________________
		End case 
		//%T+
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function stop()
	
	If (This:C1470._destination="4D")
		
		//%T-
		Case of 
				
				//……………………………………………………………………………………………………
			: (This:C1470.isWorker)
				
				// Worker can't call SET DATABASE PARAMETER
				This:C1470._pushError(".stop() cannot be used for a worker!")
				
				//______________________________________________________
			: (This:C1470.target=Into 4D commands log:K38:7)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; This:C1470.logStatus)
				This:C1470.success:=True:C214
				
				//______________________________________________________
			: (This:C1470.target=Into 4D diagnostic log:K38:8)
				
				SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; This:C1470.logStatus)
				This:C1470.success:=True:C214
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				This:C1470.success:=False:C215
				
				//______________________________________________________
		End case 
		//%T+
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function reset()
	
	If (This:C1470._destination="4D")
		
		//%T-
		Case of 
				
				//……………………………………………………………………………………………………
			: (This:C1470.isWorker)
				
				// Worker can't call SET DATABASE PARAMETER
				This:C1470._pushError(".reset() cannot be used for a worker!")
				
				//______________________________________________________
			: (This:C1470.target=Into 4D commands log:K38:7)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 0)
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; 1)
				This:C1470.success:=True:C214
				
				//______________________________________________________
			: (This:C1470.target=Into 4D diagnostic log:K38:8)
				
				SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; 0)
				SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; 1)
				This:C1470.success:=True:C214
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			Else 
				
				This:C1470.success:=False:C215
				
				//______________________________________________________
		End case 
		//%T+
		
	Else 
		
		This:C1470.clear()
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function clear() : cs:C1710.logger
	
	If (This:C1470.target.exists)
		
		This:C1470.target.setText("")
		This:C1470.success:=(Length:C16(This:C1470.target.getText())=0)
		
	Else 
		
		This:C1470.success:=This:C1470.target.create()
		
	End if 
	
	
	// MARK:-[PRIVATE]
	// === === === === === === === === === === === === === === === === === === === === ===
Function _pushMessage($message; $level : Integer) : cs:C1710.logger
	
	$level:=$level || Information message:K38:1
	
	If (This:C1470.verbose)\
		 | ($level#Information message:K38:1)
		
		Case of 
				
				//……………………………………………………………………………………
			: (Value type:C1509($message)=Is object:K8:27)
				
				$message:=JSON Stringify:C1217($message; *)
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: (Value type:C1509($message)=Is collection:K8:32)
				
				$message:=JSON Stringify:C1217($message; *)
				
				//……………………………………………………………………………………
			: (Value type:C1509($message)=Is boolean:K8:9)
				
				$message:=$message ? "TRUE" : "FALSE"
				
				//……………………………………………………………………………………
			Else 
				
				$message:=String:C10($message)
				
				//……………………………………………………………………………………
		End case 
		
		If (This:C1470._destination="4D")
			
			If ((This:C1470.target=Into system standard outputs:K38:9))
				
				Case of 
						
						//……………………………………………………………………………………………………
					: ($level=Error message:K38:3)
						
						LOG EVENT:C667(This:C1470.target; "error: "+$message; $level)
						
						//……………………………………………………………………………………………………
					: ($level=Warning message:K38:2)
						
						LOG EVENT:C667(This:C1470.target; "warning: "+$message; $level)
						
						//……………………………………………………………………………………………………
					: ($level=Information message:K38:1)
						
						LOG EVENT:C667(This:C1470.target; (Is Windows:C1573 ? "" : "note: ")+$message; $level)
						
						//……………………………………………………………………………………………………
				End case 
				
			Else 
				
				LOG EVENT:C667(This:C1470.target; "("+This:C1470.component+") "+This:C1470.process+" - "+$message; $level)
				
			End if 
			
		Else 
			
			If ($level#8858)
				
				$message:=Replace string:C233(String:C10(Current date:C33; ISO date:K1:8; Current time:C178); "T"; " ")+"\t"\
					+This:C1470.process+" - "\
					+Choose:C955($level; "info"; "warning"; "error")+": "\
					+$message
				
			End if 
			
			This:C1470.target.setText(This:C1470.target.getText()+$message+"\n")
			
		End if 
	End if 
	
	return (This:C1470)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function _pushError($error)
	
	This:C1470.success:=False:C215
	
	This:C1470.error:=$error
	This:C1470.errors.push($error)
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Restore the previous status, if any
Function _restore()
	
	If (This:C1470._destination="4D")
		
		//%T-
		Case of 
				
				//……………………………………………………………………………………………………
			: (This:C1470.isWorker)
				
				// Worker can't call SET DATABASE PARAMETER
				This:C1470._pushError("This value cannot be used for a worker!")
				
				//……………………………………………………………………………………………………
			: (This:C1470.target=Into 4D commands log:K38:7)
				
				SET DATABASE PARAMETER:C642(Debug log recording:K37:34; Num:C11(This:C1470.logStatus))
				
				//……………………………………………………………………………………………………
			: (This:C1470.target=Into 4D diagnostic log:K38:8)
				
				SET DATABASE PARAMETER:C642(Diagnostic log recording:K37:69; Num:C11(This:C1470.logStatus))
				
				//……………………………………………………………………………………………………
		End case 
		//%T+
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	// Create file if any
Function _setTarget($file : 4D:C1709.File)
	
	This:C1470.success:=$file.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470.success:=$file.create()
		
	End if 
	
	If (This:C1470.success)
		
		This:C1470._destination:="file"
		This:C1470.target:=$file
		
	Else 
		
		This:C1470.target:=Null:C1517
		This:C1470._pushError("Failed to create the file:"+$file.path)
		
	End if 