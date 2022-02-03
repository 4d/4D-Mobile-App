Class constructor()
	
Function connect($dbFile : 4D:C1709.File)
	This:C1470.file:=$dbFile
	
Function execute($sql : Text)->$out : Text
	ASSERT:C1129(This:C1470.file#Null:C1517; "No db file to execute sql statemet")
	
	// TODO: using cs.lep or other things like java groovy process?
	var $in : Text
	If (Is Windows:C1573)
		LAUNCH EXTERNAL PROCESS:C811("sqlite3.exe "+str_singleQuoted(This:C1470.file.platformPath)+" \""+$sql+"\""; $in; $out)
	Else 
		LAUNCH EXTERNAL PROCESS:C811("sqlite3 "+str_singleQuoted(This:C1470.file.path)+" \""+$sql+"\""; $in; $out)
	End if 
	
Function disconnect()
	This:C1470.file:=Null:C1517