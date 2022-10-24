
Class constructor($target; $reference)
	
	var $t : Text
	
	This:C1470.platformPath:=""
	This:C1470.path:=""
	This:C1470.relativePath:=""
	
	This:C1470._filesystemPathnames:=New collection:C1472
	This:C1470._filesystemPathnames.push(New object:C1471("constant"; fk data folder:K87:12; "path"; "/DATA/"))
	This:C1470._filesystemPathnames.push(New object:C1471("constant"; fk database folder:K87:14; "path"; "/PACKAGE/"))
	This:C1470._filesystemPathnames.push(New object:C1471("constant"; fk resources folder:K87:11; "path"; "/RESOURCES/"))
	This:C1470._filesystemPathnames.push(New object:C1471("constant"; fk logs folder:K87:17; "path"; "/LOGS/"))
	
	If (Asserted:C1132(Count parameters:C259>0; Current method name:C684+": Missing parameter"))
		
		If (Count parameters:C259>=2)
			
			This:C1470.setReference($reference)
			
		Else 
			
			This:C1470.__defaultReference()
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.reference=Null:C1517)
				
				// ERROR
				
				//______________________________________________________
			: (Value type:C1509($target)=Is object:K8:27)
				
				This:C1470.setTarget($target)
				
				//______________________________________________________
			: (Value type:C1509($target)=Is text:K8:3)
				
				If ((Position:C15(":"; $target)>0))  // Platform path
					
					//%W-533.1
					If ($target[[1]]=Folder separator:K24:12)
						
						// relative
						This:C1470.relativePath:=Replace string:C233($target; Folder separator:K24:12; "/")
						This:C1470.platformPath:=This:C1470.reference.platformPath+Substring:C12($target; 2)
						
					Else 
						
						// Absolute
						This:C1470.platformPath:=$target
						This:C1470.path:=Convert path system to POSIX:C1106(This:C1470.platformPath)
						
						$t:=Convert path system to POSIX:C1106(Replace string:C233($target; This:C1470.reference.platformPath; ""))
						
						If (Position:C15("/Volumes/"; $t; *)=0)\
							 && (Position:C15("/Users/"; $t; *)=0)
							
							This:C1470.relativePath:=$t
							
						Else 
							
							This:C1470.relativePath:=This:C1470.path
							
						End if 
					End if 
					//%W+533.3
					
				Else   // POSIX
					
					$t:=Replace string:C233($target; This:C1470.reference.path; ""; 1)
					
					If (Length:C16($t)#Length:C16($target))
						
						// Absolute
						This:C1470.path:=$target
						This:C1470.relativePath:="/"+$t
						
					Else 
						
						// Relative
						This:C1470.relativePath:=$target
						
						If (Position:C15("/Volumes/"; $target; *)=0)\
							 && (Position:C15("/Users/"; $target; *)=0)
							
							This:C1470.path:=This:C1470.reference.path+Substring:C12(This:C1470.relativePath; 2)
							
						Else 
							
							This:C1470.path:=$target
							
						End if 
					End if 
					
					This:C1470.platformPath:=Convert path POSIX to system:C1107(This:C1470.path)
					
				End if 
				
				This:C1470.target:=FileOrFolderFrom(This:C1470.platformPath)
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; Current method name:C684+": The parameter must be a text or a File or a Folder object")
				
				//______________________________________________________
		End case 
	End if 
	
/*======================================================================*/
Function isAlias() : Boolean
	
	return (This:C1470.target.isAlias)
	
/*======================================================================*/
Function isOriginal() : Boolean
	
	return (Not:C34(This:C1470.isAlias()))
	
/*======================================================================*/
Function unSandBoxed()->$path : Text
	
	var $t : Text
	var $filesystem : Object
	
	$path:=This:C1470.path
	
	For each ($filesystem; This:C1470._filesystemPathnames)
		
		// Unsandboxed
		$t:=Folder:C1567(Folder:C1567($filesystem.constant; *).platformPath; fk platform path:K87:2).path
		
		If (Position:C15($t; $path; 1; *)=1)
			
			$path:=Replace string:C233($path; $t; $filesystem.path)
			
			return 
			
		End if 
	End for each 
	
/*======================================================================*/
Function __defaultReference
	
	If (This:C1470.reference=Null:C1517)
		
		// Default is the database folder
		This:C1470.reference:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
		
	End if 
	
/*======================================================================*/
Function setReference($reference)
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($reference)=Is object:K8:27)
			
			If (OB Instance of:C1731($reference; 4D:C1709.Folder))\
				 | (OB Instance of:C1731($reference; 4D:C1709.File))
				
				This:C1470.reference:=$reference
				
			Else 
				
				This:C1470.reference:=Null:C1517
				ASSERT:C1129(False:C215; Current method name:C684+".setReference(): The passed object must be a File/Folder object")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($reference)=Is text:K8:3)
			
			This:C1470.reference:=Folder:C1567($reference; Position:C15(":"; $reference)>0 ? fk platform path:K87:2 : fk posix path:K87:1)
			
			//______________________________________________________
		Else 
			
			This:C1470.reference:=Null:C1517
			ASSERT:C1129(False:C215; Current method name:C684+".setReference(): The reference must be a pathname or a File/Folder")
			
			//______________________________________________________
	End case 
	
/*======================================================================*/
Function setTarget($target; $reference)
	
	If (Count parameters:C259>=2)
		
		This:C1470.setReference($reference)
		
	Else 
		
		This:C1470.__defaultReference()
		
	End if 
	
	If (Count parameters:C259>=1)
		
		If (OB Instance of:C1731($target; 4D:C1709.Folder))\
			 | (OB Instance of:C1731($target; 4D:C1709.File))
			
			This:C1470.target:=$target
			This:C1470.platformPath:=This:C1470.target.platformPath
			This:C1470.path:=(OB Instance of:C1731($target; 4D:C1709.File)) ? File:C1566(This:C1470.platformPath; fk platform path:K87:2).path : Folder:C1567(This:C1470.platformPath; fk platform path:K87:2).path
			
			If (Position:C15(This:C1470.reference.path; This:C1470.path)=1)
				
				This:C1470.relativePath:="/"+Replace string:C233(This:C1470.path; This:C1470.reference.path; "")
				
			Else 
				
				If (Position:C15("/Users/"; This:C1470.path; *)=0)\
					 & (Position:C15("/Volumes/"; This:C1470.path; *)=0)
					
					This:C1470.relativePath:="/"+Replace string:C233(This:C1470.path; This:C1470.reference.path; "")
					
				Else 
					
					This:C1470.relativePath:=This:C1470.path
					
				End if 
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; Current method name:C684+"setTarget(): The passed object must be a File or a Folder")
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215; Current method name:C684+"setTarget(): Missing File/Folder parameter")
		
	End if 