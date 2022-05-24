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
	
	var $t : Text
	var $content : Object
	
	If (File:C1566("/PACKAGE/Info.plist").exists)
		
		$content:=cs:C1710.plist.new(File:C1566("/PACKAGE/Info.plist")).content
		
		If ($content.CFBundleShortVersionString#Null:C1517)
			
			$t:=$content.CFBundleShortVersionString
			
			If (Num:C11($content.CFBundleVersion)#0)
				
				$t+=" ("+String:C10($content.CFBundleVersion)+")"
				
			End if 
			
			return $t
			
		Else 
			
			return This:C1470._ideVersion()+" ("+This:C1470._ideBuildNumber()+")"
			
		End if 
		
	Else 
		
		return This:C1470._ideVersion()+" ("+This:C1470._ideBuildNumber()+")"
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function get buildNumber() : Integer
	
	var $content : Object
	
	If (File:C1566("/PACKAGE/Info.plist").exists)
		
		$content:=cs:C1710.plist.new(File:C1566("/PACKAGE/Info.plist")).content
		
		If ($content.CFBundleVersion#Null:C1517)
			
			return Num:C11($content.CFBundleVersion)
			
		Else 
			
			return Num:C11(This:C1470._ideBuildNumber())
			
		End if 
		
	Else 
		
		return Num:C11(This:C1470._ideBuildNumber())
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === ===
Function _ideVersion() : Text
	
	var $major; $release; $revision; $version : Text
	
	$version:=Application version:C493
	
	//%W-533.1
	$major:=$version[[1]]+$version[[2]]  // LTS version
	$release:=$version[[3]]  // Release number
	$revision:=$version[[4]]  // Revision number
	
	//%W+533.1
	
	If ($release="0")
		
		// Revision number
		$major+=$revision#"0" ? ("."+$revision) : ""
		
	Else 
		
		// Release number
		$major+="R"
		$major+=$release
		
	End if 
	
	return $major
	
	// === === === === === === === === === === === === === === === === === === ===
Function _ideBuildNumber() : Text
	
	var $version : Text
	var $buildNum : Integer
	
	$version:=Application version:C493($buildNum)
	return String:C10($buildNum)