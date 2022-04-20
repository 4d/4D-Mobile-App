// TODO: Class extends lep for sqlite3

Class constructor($exe : 4D:C1709.File)
	
	If (Count parameters:C259>0)
		
		This:C1470.cmd:=$exe.path
		
	Else 
		
		If (Is Windows:C1573)
			
			This:C1470.cmd:=Folder:C1567(fk resources folder:K87:11).folder("scripts/win").file("sqlite3.exe").platformPath
			
		Else 
			
			This:C1470.cmd:="sqlite3"
			
		End if 
	End if 
	
	// Choose database file to apply operation
Function connect($dbFile : 4D:C1709.File)
	
	This:C1470.database:=$dbFile
	
	// Remove database file
Function disconnect()
	
	This:C1470.database:=Null:C1517
	
	// Execute an sql statement and return output data
Function execute($sql : Text)->$out : Text
	
	ASSERT:C1129(This:C1470.database#Null:C1517; "No db file to execute sql statement")
	
	var $in; $err; $cmd : Text
	
	If (Is Windows:C1573)
		
		$cmd:="\""+This:C1470.cmd+"\" \""+This:C1470.database.platformPath+"\" \""+$sql+"\""
		
	Else 
		
		$cmd:=str_singleQuoted(This:C1470.cmd)+" "+str_singleQuoted(This:C1470.database.path)+" \""+$sql+"\""
		
	End if 
	
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)