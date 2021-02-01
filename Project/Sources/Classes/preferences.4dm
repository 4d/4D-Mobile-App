
// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor()
	
	This:C1470._user:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name)
	This:C1470._database:=Folder:C1567(fk database folder:K87:14).folder("Preferences")
	This:C1470.sessionRoot:=Folder:C1567(fk desktop folder:K87:19).parent.folder("Library/Preferences/")
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function user($path)->$this : cs:C1710.preferences
	
	This:C1470.target:=This:C1470._user.file($path)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function database($path)->$this : cs:C1710.preferences
	
	This:C1470.target:=This:C1470._database.file($path)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function session($path)->$this : cs:C1710.preferences
	
	This:C1470.target:=This:C1470._session.file($path)
	
	$this:=This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function get($key : Text; $target : Text)->$value : Variant
	
	var $o : Object
	var $file : 4D:C1709.File
	
	If (Bool:C1537(This:C1470.target.exists))
		
		$value:=JSON Parse:C1218(This:C1470.target.getText())[$key]
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function set($key : Text; $value : Variant; $target : Text)
	
	var $o : Object
	var $file : 4D:C1709.File
	
	If (Bool:C1537(This:C1470.target.exists))
		
		$o:=JSON Parse:C1218(This:C1470.target.getText())
		
	Else 
		
		// Create
		$o:=New object:C1471
		
	End if 
	
	If (Count parameters:C259>=2)
		
		$o[$key]:=$value
		
	Else 
		
		// Remove
		OB REMOVE:C1226($o; $key)
		
	End if 
	
	This:C1470.target.setText(JSON Stringify:C1217($o; *))