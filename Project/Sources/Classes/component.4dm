Class constructor()
	
	Super:C1705()
	
	This:C1470.structureFile:=File:C1566(Structure file:C489; fk platform path:K87:2)
	This:C1470.databaseFolder:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2)
	This:C1470.preferencesFolder:=Folder:C1567(fk user preferences folder:K87:10).folder(This:C1470.name)
	
	This:C1470.isCompiled:=Is compiled mode:C492
	This:C1470.isInterpreted:=Not:C34(This:C1470.isCompiled)
	
	This:C1470.isMatrix:=(Structure file:C489=Structure file:C489(*))
	This:C1470.isComponent:=Not:C34(This:C1470.isMatrix)
	
	// === === === === === === === === === === === === === === === === === === ===
Function get name() : Text
	
	return This:C1470.structureFile.name
	
	// === === === === === === === === === === === === === === === === === === ===
Function get version() : Text
	
	var $version : Text
	var $plist : Object
	
	If (File:C1566("/PACKAGE/Info.plist").exists)
		
		$plist:=cs:C1710.plist.new(File:C1566("/PACKAGE/Info.plist")).content
		
		If ($plist.CFBundleShortVersionString#Null:C1517)
			
			$version:=$plist.CFBundleShortVersionString
			
			If (Num:C11($plist.CFBundleVersion)#0)
				
				$version+=" ("+String:C10($plist.CFBundleVersion)+")"
				
			End if 
			
			return $version
			
		Else 
			
			return This:C1470._ideVersion()+" ("+This:C1470._ideBuildNumber()+")"
			
		End if 
		
	Else 
		
		return This:C1470._ideVersion()+" ("+This:C1470._ideBuildNumber()+")"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function get buildNumber() : Integer
	
	var $plist : Object
	
	If (File:C1566("/PACKAGE/Info.plist").exists)
		
		$plist:=cs:C1710.plist.new(File:C1566("/PACKAGE/Info.plist")).content
		return Num:C11($plist.CFBundleVersion#Null:C1517 ? $plist.CFBundleVersion : This:C1470._ideBuildNumber())
		
	Else 
		
		return Num:C11(This:C1470._ideBuildNumber())
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function clearCompiledCode()
	
	var $folder : 4D:C1709.Folder
	
	If (This:C1470.isMatrix)
		
		If (This:C1470.structureFile.parent.folder("DerivedData/CompiledCode").exists)
			
			This:C1470.structureFile.parent.folder("DerivedData/CompiledCode").delete(Delete with contents:K24:24)
			
		End if 
		
		For each ($folder; This:C1470.databaseFolder.folders().query("name = userPreferences"))
			
			If ($folder.folder("CompilerIntermediateFiles").exists)
				
				$folder.folder("CompilerIntermediateFiles").delete(Delete with contents:K24:24)
				
			End if 
		End for each 
	End if 
	
	// MARK:-
	// === === === === === === === === === === === === === === === === === === ===
Function _ideVersion() : Text
	
	var $major; $release; $revision : Text
	var $c : Collection
	
	$c:=Split string:C1554(Application version:C493; "")
	$major:=$c[0]+$c[1]  // LTS version
	$release:=$c[2]  // Release number
	$revision:=$c[3]  // Revision number
	
	If ($release="0")
		
		return $major+($revision#"0" ? ("."+$revision) : "")
		
	Else 
		
		return $major+"R"+$release
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _ideBuildNumber() : Text
	
	var $version : Text
	var $buildNum : Integer
	
	$version:=Application version:C493($buildNum)
	return String:C10($buildNum)