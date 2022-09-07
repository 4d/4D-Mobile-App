//USE: envDatabase
//USE: noError

Class extends env

Class constructor()
	
	var $pathname : Text
	var $plist : Object
	var $file : 4D:C1709.File
	var $signal : 4D:C1709.Signal
	
	Super:C1705()
	
	This:C1470.isCompiled:=Is compiled mode:C492(*)
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	
	This:C1470.isDebug:=This:C1470.isInterpreted\
		 | (Position:C15("debug"; Application version:C493(*))>0)\
		 | Folder:C1567(fk user preferences folder:K87:10).file("_vdl").exists
	
	This:C1470.type:=Choose:C955(Application type:C494; "Local"; "Volume desktop"; "Unkwon (2)"; "Desktop"; "Remote"; "Server")
	This:C1470.isRemote:=(This:C1470.type="Remote")
	This:C1470.isLocal:=Not:C34(This:C1470.isRemote)
	
	$pathname:=Structure file:C489(*)
	
	This:C1470.isMatrix:=(Structure file:C489=$pathname)
	This:C1470.isComponent:=Not:C34(This:C1470.isMatrix)
	
	If (This:C1470.isRemote)
		
		This:C1470.name:=$pathname
		This:C1470.dataless:=False:C215
		
	Else 
		
		This:C1470.structureFile:=File:C1566($pathname; fk platform path:K87:2)
		
		$pathname:=Data file:C490
		This:C1470.dataless:=(Length:C16($pathname)=0)
		
		If (Not:C34(This:C1470.dataless))
			
			This:C1470.dataFile:=File:C1566($pathname; fk platform path:K87:2)
			This:C1470.isLocked:=Is data file locked:C716
			
		End if 
		
		This:C1470.name:=This:C1470.structureFile.name
		
		// Unsanboxing
		This:C1470.databaseFolder:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
		
		$file:=This:C1470.databaseFolder.file("Info.plist")
		
		If ($file.exists)
			
			$plist:=$file.getAppInfo()
			
			This:C1470.plist:=$plist
			
			If ($plist.CFBundleShortVersionString#Null:C1517)
				
				This:C1470.version:=String:C10($plist.CFBundleShortVersionString)
				
				If ($plist.CFBundleVersion#Null:C1517)
					
					This:C1470.version:=This:C1470.version+" ("+String:C10($plist.CFBundleVersion)+")"
					
				End if 
			End if 
		End if 
	End if 
	
	This:C1470.userPreferencesFolder:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.name)
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("env")
	CALL WORKER:C1389(1; "envDatabase"; $signal)
	$signal.wait()
	
	This:C1470.isProject:=$signal.isProject
	This:C1470.isBinary:=$signal.isBinary
	This:C1470.components:=$signal.components.copy()
	This:C1470.plugins:=$signal.plugins.copy()
	
	If ($signal.parameters#Null:C1517)
		
		This:C1470.parameters:=Value type:C1509($signal.parameters)=Is text:K8:3 ? $signal.parameters : $signal.parameters.copy()
		
	Else 
		
		This:C1470.parameters:=Null:C1517
		
	End if 
	
	// === === === === === === === === === === === === === === ===
Function get mode() : Text
	
	return This:C1470.isCompiled ? "compiled" : "interpreted"
	
	// === === === === === === === === === === === === === === ===
	// Caution: Only test tables that are available via REST.
Function isDataEmpty() : Boolean
	
	var $table : Text
	var $empty : Boolean
	
	If (This:C1470.dataless)
		
		return True:C214
		
	End if 
	
	$empty:=True:C214
	
	For each ($table; ds:C1482) Until (Not:C34($empty))
		
		$empty:=ds:C1482[$table].all().length=0
		
	End for each 
	
	return $empty
	
	// === === === === === === === === === === === === === === === === === === ===
Function isMethodAvailable($name : Text) : Boolean
	
	//FIXME: Execute in cooperative process
	ARRAY TEXT:C222($textArray; 0x0000)
	
	//%T-
	METHOD GET NAMES:C1166($textArray; *)
	//%T+
	
	return Find in array:C230($textArray; $name)>0
	
	// === === === === === === === === === === === === === === === === === === ===
Function isComponentAvailable($name : Text) : Boolean
	
	return This:C1470.components.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === ===
Function isPluginAvailable($name : Text) : Boolean
	
	return This:C1470.plugins.indexOf($name)#-1
	
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
	
	// === === === === === === === === === === === === === === ===
Function clearCompiledCode()
	
	var $folder : 4D:C1709.Folder
	
	If (This:C1470.isProject\
		 && This:C1470.isInterpreted\
		 && Not:C34(This:C1470.isRemote))
		
		$folder:=This:C1470.structureFile.parent.parent.folder("Libraries")
		
		If ($folder.exists)
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		$folder:=This:C1470.structureFile.parent.folder("DerivedData/CompiledCode")
		
		If ($folder.exists)
			
			$folder.delete(Delete with contents:K24:24)
			
		End if 
		
		For each ($folder; This:C1470.root.folders().query("name = userPreferences"))
			
			$folder:=$folder.folder("CompilerIntermediateFiles")
			
			If ($folder.exists)
				
				$folder.delete(Delete with contents:K24:24)
				
			End if 
		End for each 
	End if 
	
	// === === === === === === === === === === === === === === ===
Function methods($filter : Text) : Collection
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("env")
	
	Use ($signal)
		
		$signal.action:="methods"
		$signal.filter:=$filter
		
	End use 
	
	CALL WORKER:C1389(1; "envDatabase"; $signal)
	$signal.wait()
	
	return $signal.methods.copy()
	
	// === === === === === === === === === === === === === === ===
Function setUserParam($userParam)
	
	var $signal : 4D:C1709.Signal
	
	Case of 
			
			//__________________________
		: ($userParam=Null:C1517)
			
			$userParam:=""
			
			//__________________________
		: (Value type:C1509($userParam)=Is text:K8:3)
			
			// <NOTHING MORE TO DO>
			
			//__________________________
		: (Value type:C1509($userParam)=Is object:K8:27)\
			 | (Value type:C1509($userParam)=Is collection:K8:32)
			
			$userParam:=JSON Stringify:C1217($userParam)
			
			//__________________________
		Else 
			
			$userParam:=String:C10($userParam)
			
			//__________________________
	End case 
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("env")
	
	Use ($signal)
		
		$signal.userParam:=$userParam
		
	End use 
	
	CALL WORKER:C1389(1; "envDatabase"; $signal)
	$signal.wait()
	
	// === === === === === === === === === === === === === === ===
Function restart($options; $message : Text)
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("env")
	
	Use ($signal)
		
		$signal.action:="restart"
		$signal.this:=OB Copy:C1225(This:C1470; ck shared:K85:29; $signal)
		
		If ($options#Null:C1517)
			
			$signal.options:=$options
			
		End if 
		
		If (Length:C16($message)>0)
			
			$signal.options:=$message
			
		End if 
	End use 
	
	CALL WORKER:C1389(1; "envDatabase"; $signal)
	$signal.wait()
	
	// === === === === === === === === === === === === === === ===
Function restartCompiled($userParam) : Object
	
	return This:C1470._restart(True:C214; $userParam)
	
	// === === === === === === === === === === === === === === ===
Function restartInterpreted($userParam) : Object
	
	return This:C1470._restart(False:C215; $userParam)
	
	// === === === === === === === === === === === === === === ===
Function _restart($compiled : Boolean; $userParam) : Object
	
	var $signal : 4D:C1709.Signal
	
	// Non-thread-safe commands are delegated to the application process
	$signal:=New signal:C1641("env")
	
	Use ($signal)
		
		$signal.action:="_restart"
		$signal.this:=OB Copy:C1225(This:C1470; ck shared:K85:29; $signal)
		$signal.compiled:=$compiled
		
		If ($userParam#Null:C1517)
			
			$signal.userParam:=$userParam
			
		End if 
	End use 
	
	CALL WORKER:C1389(1; "envDatabase"; $signal)
	$signal.wait()
	
	return $signal.result