Class extends env

Class constructor()
	
	var $t; $userParam : Text
	var $l : Integer
	var $o : Object
	
	Super:C1705()
	
	This:C1470.structureFile:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
	This:C1470.dataFile:=File:C1566(Data file:C490; fk platform path:K87:2)
	
	This:C1470.name:=This:C1470.structureFile.name
	
	This:C1470.databaseFolder:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
	This:C1470.preferencesFolder:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.name)
	
	This:C1470.isCompiled:=Is compiled mode:C492(*)
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	
	This:C1470.isMatrix:=(Structure file:C489=Structure file:C489(*))
	This:C1470.isComponent:=Not:C34(This:C1470.isMatrix)
	
	This:C1470.isLocked:=Is data file locked:C716
	
	This:C1470.isRemote:=(Application type:C494=4D Remote mode:K5:5)
	
	//******************************************
	// old as alias
	This:C1470.root:=This:C1470.databaseFolder
	This:C1470.structure:=This:C1470.structureFile
	This:C1470.data:=This:C1470.dataFile
	This:C1470.preferences:=This:C1470.preferencesFolder
	//******************************************
	
	PROCESS PROPERTIES:C336(Current process:C322; $t; $l; $l; $l)
	
	This:C1470.runInPreemptive:=$l ?? 1
	
	//FIXME: Execute in cooperative process
	If (Not:C34(This:C1470.runInPreemptive))
		
		//%T-
		This:C1470.isProject:=Bool:C1537(Get database parameter:C643(Is host database a project:K37:99))
		This:C1470.isBinary:=Not:C34(This:C1470.isProject)
		
		This:C1470.components:=New collection:C1472
		ARRAY TEXT:C222($textArray; 0x0000)
		COMPONENT LIST:C1001($textArray)
		ARRAY TO COLLECTION:C1563(This:C1470.components; $textArray)
		
		This:C1470.plugins:=New collection:C1472
		ARRAY LONGINT:C221($IntegerArray; 0x0000)
		PLUGIN LIST:C847($IntegerArray; $textArray)
		ARRAY TO COLLECTION:C1563(This:C1470.plugins; $textArray)
		
		$IntegerArray{0}:=Get database parameter:C643(User param value:K37:94; $userParam)
		
		If (Length:C16($userParam)>0)
			
			// Decode special entities
			$userParam:=Replace string:C233($userParam; "&amp;"; "&")
			$userParam:=Replace string:C233($userParam; "&lt;"; "<")
			$userParam:=Replace string:C233($userParam; "&gt;"; ">")
			$userParam:=Replace string:C233($userParam; "&apos;"; "'")
			$userParam:=Replace string:C233($userParam; "&quot;"; "\"")
			
			Case of 
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\{.*\\}$"; $userParam; 1))  // Json object
					
					This:C1470.parameters:=New object:C1471
					$o:=JSON Parse:C1218($userParam)
					
					For each ($t; $o)
						
						This:C1470.parameters[$t]:=$o[$t]
						
					End for each 
					
					//______________________________________________________
				: (Match regex:C1019("(?m-si)^\\[.*\\]$"; $userParam; 1))  // Json array
					
					JSON PARSE ARRAY:C1219($userParam; $textArray)
					This:C1470.parameters:=New collection:C1472
					ARRAY TO COLLECTION:C1563(This:C1470.parameters; $textArray)
					
					//______________________________________________________
				Else 
					
					This:C1470.parameters:=$userParam
					
					//______________________________________________________
			End case 
		End if 
		//%T+
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function isMethodAvailable
	var $0 : Boolean
	var $1 : Text
	
	//FIXME: Execute in cooperative process
	If (Not:C34(This:C1470.runInPreemptive))
		If (Asserted:C1132(Count parameters:C259>=1))
			
			ARRAY TEXT:C222($textArray; 0x0000)
			METHOD GET NAMES:C1166($textArray; *)
			
			$0:=(Find in array:C230($textArray; $1)>0)
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function isComponentAvailable
	var $0 : Boolean
	var $1 : Text
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$0:=(This:C1470.components.indexOf($1)#-1)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function isPluginAvailable
	var $0 : Boolean
	var $1 : Text
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		$0:=(This:C1470.plugins.indexOf($1)#-1)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
	// Check if the database folder is writable
Function isWritable()->$writable : Boolean
	
	var $methodCalledOnError : Text
	var $file : 4D:C1709.File
	
	$methodCalledOnError:=Method called on error:C704
	ON ERR CALL:C155("noError")
	$file:=This:C1470.databaseFolder.file("._")
	$writable:=$file.create()
	$file.delete()
	ON ERR CALL:C155($methodCalledOnError)