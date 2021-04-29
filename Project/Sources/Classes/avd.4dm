Class extends androidProcess

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.exe:=This:C1470._exe()
	This:C1470.cmd:=This:C1470.exe.path
	
	If (Is Windows:C1573)
		
		This:C1470.cmd:=This:C1470.cmd+".bat"
		
	End if 
	
	var $studio : cs:C1710.studio
	$studio:=cs:C1710.studio.new()
	
	If ($studio.success)
		
		If (Bool:C1537($studio.javaHome.exists))
			
			This:C1470.setEnvironnementVariable("JAVA_HOME"; $studio.javaHome.path)
			
		End if 
	End if 
	
	// In case of fail with android cmd, we could try this env var
	//This.setEnvironnementVariable("ANDROID_HOME"; This.androidSDKFolder().path)
	//This.setEnvironnementVariable("ANDROID_SDK_ROOT"; This.androidSDKFolder().path)
	//This.setEnvironnementVariable("ANDROID_AVD_HOME"; This.androidSDKFolder().path+".android/avd")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _exe()->$file : 4D:C1709.File
	
	// Prefer latest
	$file:=This:C1470.androidSDKFolder().file("cmdline-tools/latest/bin/avdmanager")
	
	If (Not:C34($file.exists))
		
		$file:=This:C1470.androidSDKFolder().file("tools/bin/avdmanager")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of potential device simulators
Function devices()->$devices : Collection
	
	var $start : Integer
	var $o : Object
	
	$devices:=New collection:C1472
	
	This:C1470.launch(This:C1470.cmd+" list device")
	
	If (This:C1470.success)
		
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000)
		
		While (Match regex:C1019("(?m-si)id:\\s(\\d+)\\sor\\s\"([^\"]*)\"\\s*Name:\\s(\\V*)\\s*OEM\\s*:\\s(\\V*)"; This:C1470.outputStream; $start; $pos; $len))
			
			$o:=New object:C1471(\
				"id"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
				"udid"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1})+"."+Replace string:C233(Substring:C12(This:C1470.outputStream; $pos{2}; $len{2}); " "; "_"); \
				"name"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3}); \
				"OEM"; Substring:C12(This:C1470.outputStream; $pos{4}; $len{4}))
			
			$start:=$pos{4}+$len{4}
			
			If (Position:C15("tv_"; $o.udid)=0) & (Position:C15("wear_"; $o.udid)=0)
				
				$devices.push($o)
				
			End if 
		End while 
		
	Else 
		
		//#ERROR
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of available device simulators
Function availableDevices()->$devices : Collection
	
	var $t : Text
	var $index; $length; $start : Integer
	var $o : Object
	
	$devices:=New collection:C1472
	
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.success)
		
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000)
		
		$length:=Length:C16(This:C1470.outputStream)
		
		While (Match regex:C1019("(?m-si)Name:\\s(\\S*)(?:\\s*Device:\\s([^\\n]*))?\\s*Path:\\s(\\S*)(?:\\s*Target:\\s([^\\n]*\\R*[^\\n]*))?(?:\\s*Skin:"+\
			"\\s(\\S*))?(?:\\s*Sdcard:\\s(\\S*))?(?:\\s*Error:\\s([^\\n]*))?"; This:C1470.outputStream; $start; $pos; $len))
			
			$o:=New object:C1471(\
				"udid"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
				"name"; ""; \
				"device"; ""; \
				"path"; ""; \
				"target"; ""; \
				"skin"; ""; \
				"Sdcard"; ""; \
				"error"; ""; \
				"isAvailable"; False:C215; \
				"missingSystemImage"; False:C215; \
				"isOutDated"; False:C215)
			
			$index:=2
			
			If ($pos{$index}#-1)
				
				$o.device:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$index:=3
			
			If ($pos{$index}#-1)
				
				$o.path:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$index:=4
			
			If ($pos{$index}#-1)
				
				$t:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				$o.target:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$index:=5
			
			If ($pos{$index}#-1)
				
				$o.skin:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$index:=6
			
			If ($pos{$index}#-1)
				
				$o.Sdcard:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$index:=7
			
			If ($pos{$index}#-1)
				
				$o.error:=Substring:C12(This:C1470.outputStream; $pos{$index}; $len{$index})
				
			Else 
				
				Repeat 
					
					$index:=$index-1
					
					If ($pos{$index}#-1)
						
						$start:=$pos{$index}+$len{$index}+1
						
					End if 
				Until ($pos{$index}#-1)
			End if 
			
			$o.name:=Replace string:C233($o.udid; "_"; " ")
			
			$t:=String:C10($o.error)
			$o.isAvailable:=(Length:C16($t)=0)
			$o.missingSystemImage:=(Position:C15("Missing system image"; $t)>0)
			$o.isOutDated:=(Position:C15("no longer exists as a device"; $t)>0)
			
			If ($o.isAvailable)\
				 & (Not:C34($o.missingSystemImage) & Not:C34($o.isOutDated))
				
				$devices.push($o)
				
			End if 
			
			If ($start>$length)
				
				$start:=$length
				
			End if 
		End while 
		
	Else 
		
		RECORD.error("availableDevices() failed")
		RECORD.log(This:C1470.errors.join("\r"))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a collection of available device simulators
Function _o_devices()->$devices : Collection
	
	var $start : Integer
	
	$devices:=New collection:C1472
	
	//This.ignoreErrorInOutputStream:=True
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.success)
		
		$start:=1
		
		ARRAY LONGINT:C221($pos; 0x0000)
		ARRAY LONGINT:C221($len; 0x0000)
		
		While (Match regex:C1019("(?m-si)Name:\\s(\\V*)\\s*Path:\\s(\\V*)"; This:C1470.outputStream; $start; $pos; $len))
			
			$devices.push(New object:C1471(\
				"name"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
				"path"; Substring:C12(This:C1470.outputStream; $pos{2}; $len{2})))
			
			$start:=$pos{2}+$len{2}+1
			
		End while 
		
	Else 
		
		//#ERROR
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if a given device name or path is available
Function isDeviceAvailable($device : Text)->$available : Boolean
	
	$available:=This:C1470.devices().query("(name = :1) or (path = :1)"; $device).pop()#Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function listAvds  // List emulators
	var $0 : Text  // returns complete output
	
	This:C1470.launch(This:C1470.cmd+" list avd")
	
	If (This:C1470.errorStream#Null:C1517)
		$0:=This:C1470.errorStream
	Else 
		$0:=String:C10(This:C1470.outputStream)
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function isAvdExisting  // Check if avd already exists
	var $0 : Boolean
	var $1 : Text  // avd name
	var $listOutput; $separator : Text
	
	$listOutput:=This:C1470.listAvds()
	
	$separator:=Choose:C955(Is macOS:C1572; "/"; "\\")
	
	// Searching for "/avd_name.avd" expression
	If (Position:C15($separator+$1+".avd\n"; String:C10($listOutput))=0)
		// avd name not found, means it doesn't exists
		$0:=False:C215
	Else 
		// avd name found, means it already exists
		$0:=True:C214
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create a new AVD.
	// You must provide a name for the AVD and specify the ID of the SDK package to use
Function createAvd($avd : Object)->$this : cs:C1710.avd
	
	var $command : Text
	
	ASSERT:C1129($avd.name#Null:C1517)
	ASSERT:C1129($avd.image#Null:C1517)
	
	$command:=This:C1470.cmd+" create avd --force -n "+This:C1470.quoted($avd.name)+" -k "+This:C1470.quoted($avd.image)
	
	If ($avd.definition#Null:C1517)
		
		$command:=$command+" --device "+This:C1470.quoted($avd.definition)
		
	End if 
	
	This:C1470.launch($command)
	
	$this:=This:C1470