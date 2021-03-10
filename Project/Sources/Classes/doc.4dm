
Class constructor
	var $1 : Variant
	var $2 : Variant
	
	var $t : Text
	
	This:C1470.platformPath:=""
	This:C1470.path:=""
	This:C1470.relativePath:=""
	
	If (Asserted:C1132(Count parameters:C259>0; Current method name:C684+": Missing parameter"))
		
		If (Count parameters:C259>=2)
			
			This:C1470.setReference($2)
			
		Else 
			
			This:C1470.__defaultReference()
			
		End if 
		
		Case of 
				
				//______________________________________________________
			: (This:C1470.reference=Null:C1517)
				
				// ERROR
				
				//______________________________________________________
			: (Value type:C1509($1)=Is object:K8:27)
				
				This:C1470.setTarget($1)
				
				//______________________________________________________
			: (Value type:C1509($1)=Is text:K8:3)
				
				If ((Position:C15(":"; $1)>0))  // Platform path
					
					//%W-533.1
					If ($1[[1]]=Folder separator:K24:12)
						
						// relative
						This:C1470.relativePath:=Replace string:C233($1; Folder separator:K24:12; "/")
						This:C1470.platformPath:=This:C1470.reference.platformPath+Substring:C12($1; 2)
						
					Else 
						
						// Absolute
						This:C1470.platformPath:=$1
						This:C1470.relativePath:=Convert path system to POSIX:C1106(Replace string:C233($1; This:C1470.reference.platformPath; ""))
						
					End if 
					//%W+533.3
					
					This:C1470.path:=Convert path system to POSIX:C1106(This:C1470.platformPath)
					
				Else   // POSIX
					
					$t:=Replace string:C233($1; This:C1470.reference.path; ""; 1)
					
					If (Length:C16($t)#Length:C16($1))
						
						// Absolute
						This:C1470.path:=$1
						This:C1470.relativePath:="/"+$t
						
					Else 
						
						// Relative
						This:C1470.relativePath:=$1
						
						If (Position:C15("/Volumes/"; $1; *)=0)\
							 & (Position:C15("/Users/"; $1; *)=0)
							
							This:C1470.path:=This:C1470.reference.path+Substring:C12(This:C1470.relativePath; 2)
							
						Else 
							
							This:C1470.path:=$1
							
						End if 
					End if 
					
					This:C1470.platformPath:=Convert path POSIX to system:C1107(This:C1470.path)
					
				End if 
				
				If (Path to object:C1547(This:C1470.platformPath).isFolder)
					
					// Folder
					This:C1470.target:=Folder:C1567(This:C1470.platformPath; fk platform path:K87:2)
					
				Else 
					
					// File
					This:C1470.target:=File:C1566(This:C1470.platformPath; fk platform path:K87:2)
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; Current method name:C684+": The parameter must be a text or a File or a Folder object")
				
				//______________________________________________________
		End case 
	End if 
	
/*======================================================================*/
	//Function digest()->$digest : Text
	
	
/*======================================================================*/
Function __defaultReference
	
	If (This:C1470.reference=Null:C1517)
		
		// Default is the database folder
		This:C1470.reference:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
		
	End if 
	
/*======================================================================*/
Function setReference
	
	var $1
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is object:K8:27)
			
			If (OB Instance of:C1731($1; 4D:C1709.Folder))\
				 | (OB Instance of:C1731($1; 4D:C1709.File))
				
				This:C1470.reference:=$1
				
			Else 
				
				This:C1470.reference:=Null:C1517
				ASSERT:C1129(False:C215; Current method name:C684+"__defaultReference(): The passed object must be a File/Folder object")
				
			End if 
			
			//______________________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			This:C1470.reference:=Folder:C1567($1; Choose:C955(Position:C15(":"; $1)>0; fk platform path:K87:2; fk posix path:K87:1))
			
			//______________________________________________________
		Else 
			
			This:C1470.reference:=Null:C1517
			ASSERT:C1129(False:C215; Current method name:C684+"__defaultReference(): The reference must be a path or a File/Folder")
			
			//______________________________________________________
	End case 
	
/*======================================================================*/
Function setTarget
	var $1 : Variant
	var $2 : Variant
	
	If (Count parameters:C259>=2)
		
		This:C1470.setReference($2)
		
	Else 
		
		This:C1470.__defaultReference()
		
	End if 
	
	If (Count parameters:C259>=1)
		
		If (OB Instance of:C1731($1; 4D:C1709.Folder))\
			 | (OB Instance of:C1731($1; 4D:C1709.File))
			
			This:C1470.target:=$1
			This:C1470.platformPath:=This:C1470.target.platformPath
			
			If (OB Instance of:C1731($1; 4D:C1709.File))
				
				// Unsandboxed file
				This:C1470.path:=File:C1566(This:C1470.platformPath; fk platform path:K87:2).path
				
			Else 
				
				// Unsandboxed older
				This:C1470.path:=Folder:C1567(This:C1470.platformPath; fk platform path:K87:2).path
				
			End if 
			
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
		
		ASSERT:C1129(False:C215; Current method name:C684+"setTarget(): Missing File/folder parameter")
		
	End if 
	