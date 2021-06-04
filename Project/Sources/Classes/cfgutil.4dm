Class extends lep

/*
cfgutil performs various management tasks on one or more attached iOS
devices. It can be used manually and as part of automated workflows.

⚠️ Apple Configurator 2.app must be installed ?

*/

//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705()
	
	This:C1470.exe:=This:C1470.getExe("Apple Configurator 2.app")
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getExe($bundleName : Text)->$exe : 4D:C1709.File
	
	var $bundle : 4D:C1709.Folder
	$bundle:=Folder:C1567("Applications/"+$bundleName)
	
	If (Not:C34($bundle.exists))
		
		// Try with Spotlight
		This:C1470.launch("mdfind \"kMDItemCFBundleIdentifier == 'com.apple.configurator.ui'\"")
		
		If (This:C1470.success)
			
			var $c : Collection
			$c:=Split string:C1554(This:C1470.outputStream; "\n")
			
			If ($c.length>0)
				
				$bundle:=Folder:C1567("Applications/"+$c[0])
				
			End if 
		End if 
	End if 
	
	If ($bundle.exists)
		
		$exe:=$bundle.file("Contents/MacOS/cfgutil")
		This:C1470.success:=$exe.exists
		
	Else 
		
		// Last try, by watching at path
		This:C1470.launch("which cfgutil")
		
		If (This:C1470.success)\
			 & (Length:C16(This:C1470.outputStream)>0)
			
			$exe:=File:C1566(This:C1470.outputStream)
			
		Else 
			
			This:C1470._pushError("cfgutil command not found")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === ===
Function connected()->$devices : Collection
	
	var $ecid : Text
	var $o : Object
	var $index; $start : Integer
	
	$devices:=New collection:C1472
	
	If (Bool:C1537(This:C1470.exe))
		
		// ⚠️ Ne semble plus fonctionner depuis la màj de Xcode 12.4
		This:C1470.launch(This:C1470.singleQuoted(This:C1470.exe.path)+" --format JSON list")
		
		If (This:C1470.success)
			
			$o:=JSON Parse:C1218(This:C1470.outputStream)
			
			If ($o.Devices#Null:C1517)
				
				For each ($ecid; $o.Devices)
					
					$devices.push($o.Output[$ecid])
					
				End for each 
			End if 
		End if 
		
	Else 
		
		// Other option if no 'cfgutil'
		// ⚠️ 'instruments' is now deprecated in favor of 'xcrun xctrace'
		This:C1470.resultInErrorStream:=True:C214
		This:C1470.launch("xcrun xctrace list devices")
		This:C1470.resultInErrorStream:=False:C215
		
		If (This:C1470.success)
			
			$index:=Position:C15("== Simulators =="; This:C1470.outputStream)
			
			If ($index>0)
				
				This:C1470.outputStream:=Substring:C12(This:C1470.outputStream; 1; $index-1)
				
			End if 
			
			ARRAY LONGINT:C221($pos; 0)
			ARRAY LONGINT:C221($len; 0)
			
			$start:=1
			
			//While (Match regex("(?m-si)^([^(]*)\\s\\(([0-9\\.]+\\)\\s\\(([[:xdigit:]]{8}-[[:xdigit:]]{16}))\\)$"; This.outputStream; $start; $pos; $len))
			While (Match regex:C1019("(?-msi)((?:iPhone|iPad)\\s[^(]*)\\(([^)]*)\\)\\s\\(([^)]*)\\)"; This:C1470.outputStream; $start; $pos; $len))
				
				$devices.push(New object:C1471(\
					"name"; Substring:C12(This:C1470.outputStream; $pos{1}; $len{1}); \
					"os"; Substring:C12(This:C1470.outputStream; $pos{2}; $len{2}); \
					"udid"; Substring:C12(This:C1470.outputStream; $pos{3}; $len{3})))
				
				$start:=$pos{3}+$len{3}
				
			End while 
			
		Else 
			
			// #ERROR
			
		End if 
	End if 