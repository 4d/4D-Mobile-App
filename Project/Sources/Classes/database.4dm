Class extends env

Class constructor
	var $t; $userParam : Text
	var $o : Object
	
	Super:C1705()
	
	This:C1470.structure:=File:C1566(Structure file:C489(*); fk platform path:K87:2)
	This:C1470.data:=File:C1566(Data file:C490; fk platform path:K87:2)
	This:C1470.preferences:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.structure.name)
	
	This:C1470.isCompiled:=Is compiled mode:C492(*)
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	This:C1470.locked:=Is data file locked:C716
	
	This:C1470.isProject:=Bool:C1537(Get database parameter:C643(Is host database a project:K37:99))
	This:C1470.isBinary:=Not:C34(This:C1470.isProject)
	
	This:C1470.isMatrix:=(Structure file:C489=Structure file:C489(*))
	
	This:C1470.isRemote:=(Application type:C494=4D Remote mode:K5:5)
	
	If (This:C1470.isProject)
		
		If (This:C1470.structure.parent.name="Project")
			
			// Up one level
			This:C1470.root:=This:C1470.structure.parent.parent
			
		Else 
			
			This:C1470.root:=This:C1470.structure.parent
			
		End if 
		
	Else 
		
		If (Not:C34(This:C1470.isRemote))
			
			This:C1470.root:=This:C1470.structure.parent
			
		End if 
	End if 
	
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
	
	// === === === === === === === === === === === === === === === === === === ===
Function isMethodAvailable
	var $0 : Boolean
	var $1 : Text
	
	If (Asserted:C1132(Count parameters:C259>=1))
		
		ARRAY TEXT:C222($textArray; 0x0000)
		METHOD GET NAMES:C1166($textArray; *)
		
		$0:=(Find in array:C230($textArray; $1)>0)
		
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