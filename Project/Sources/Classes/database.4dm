Class extends env

Class constructor()
	
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
	
	// Non-thread-safe commands are delegated to the application process
	var $signal : 4D:C1709.Signal
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