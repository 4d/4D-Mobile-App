Class extends lep

/*
https://en.wikipedia.org/wiki/Property_list
https://osxdaily.com/2016/03/10/convert-plist-file-xml-binary-mac-os-x-plutil/
https://medium.com/@karaiskc/understanding-apples-binary-property-list-format-281e6da00dbd
*/

//#MARK_TODO : manage openstep

// === === === === === === === === === === === === === === === === === === ===
Class constructor($file : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.file:=File:C1566("?")  // A non existing file
	
	This:C1470.isConverted:=False:C215
	This:C1470.isBinary:=False:C215
	This:C1470.isJson:=False:C215
	This:C1470.content:=Null:C1517
	
	If (Count parameters:C259>=1)
		
		If ($file.path="/PACKAGE/@")\
			 | ($file.path="/DATA/@")\
			 | ($file.path="/LOGS/@")\
			 | ($file.path="/RESOURCES/@")\
			 | ($file.path="/SOURCES/@")\
			 | ($file.path="/PROJECT/@")
			
			// Unsandboxing for LEP
			$file:=File:C1566($file.platformPath; fk platform path:K87:2)
			
		End if 
		
		This:C1470.read($file)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function read($file : 4D:C1709.file)->$this : cs:C1710.plist
	var $x : Blob
	var $t : Text
	
	If (Count parameters:C259>=1)
		
		This:C1470.file:=$file
		
	End if 
	
	This:C1470.success:=Bool:C1537(This:C1470.file.exists)
	
	If (Asserted:C1132(This:C1470.success; "missing file: "+String:C10(This:C1470.file.path)))
		
		If (Is macOS:C1572)
			
			// *TEST THE HEADER: Should be for a binary plist "bplist" followed by two bytes indicating the version of the format.
			$x:=This:C1470.file.getContent()
			
			This:C1470.isBinary:=($x{0}=0x0062)\
				 & ($x{1}=0x0070)\
				 & ($x{2}=0x006C)\
				 & ($x{3}=0x0069)\
				 & ($x{4}=0x0073)\
				 & ($x{5}=0x0074)\
				 & (($x{6}>=0x0030) & ($x{6}<=0x0039))\
				 & (($x{7}=0x0030) & ($x{7}=0x0039))
			
			If (This:C1470.isBinary)
				
				// Convert
				This:C1470.buffer:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("buffer.plist")
				This:C1470.buffer.delete()
				This:C1470.launch("plutil -convert xml1 "+This:C1470.quoted(This:C1470.file.path)+" -o "+This:C1470.quoted(This:C1470.buffer.path))
				This:C1470.isConverted:=This:C1470.success
				
				//SHOW ON DISK(This.buffer.platformPath)
				
				If (This:C1470.isConverted)
					
					This:C1470.content:=This:C1470.buffer.getAppInfo()
					
				Else 
					
					// *ERROR
					This:C1470._pushError("Conversion from binary failure: "+This:C1470.file.path)
					
				End if 
				
			Else 
				
				$t:=This:C1470.file.getText()
				
				If (Length:C16($t)>0)
					
					This:C1470.isJson:=Match regex:C1019("(?mi-s)^\\{.*\\}$"; $t; 1)
					
					If (This:C1470.isJson)
						
						This:C1470.content:=JSON Parse:C1218($t)
						
					Else 
						
						This:C1470.content:=This:C1470.file.getAppInfo()
						
					End if 
					
				Else 
					
					// *ERROR
					This:C1470._pushError("Failed to recover file contents: "+This:C1470.file.path)
					
				End if 
			End if 
			
		Else 
			
			// *WE ASSUME THAT IT'S A XML FILE
			This:C1470.content:=This:C1470.file.getAppInfo()
			
		End if 
	End if 
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === ===
Function write()
	
	If (This:C1470.isConverted)
		
		If (This:C1470.isBinary)
			
/*
❌ THERE IS A BUG WITH setAppInfo() with the file "com.apple.iphonesimulator.plist"
after setAppInfo() the convert to binary1 failed
DEV, PO et QA alerted
*/
			
			This:C1470.buffer.setAppInfo(This:C1470.content)
			This:C1470.launch("plutil -convert binary1 "+This:C1470.quoted(This:C1470.buffer.path)+" -o "+This:C1470.quoted(This:C1470.file.path))
			This:C1470.success:=This:C1470.success & (Position:C15("Property List error:"; This:C1470.outputStream)=0)
			
			If (This:C1470.success)
				
				
				
			Else 
				
				// *ERROR
				This:C1470._pushError("Conversion to binary failure: "+This:C1470.file.path)
				
			End if 
		End if 
		
	Else 
		
		If (This:C1470.isJson)
			
			This:C1470.file.setText(JSON Stringify:C1217(This:C1470.content; *))
			
		Else 
			
			This:C1470.file.setAppInfo(This:C1470.content)
			
		End if 
	End if 