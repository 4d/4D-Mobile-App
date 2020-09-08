Class constructor
	var $1: Boolean
	
	This:C1470.success:=True:C214
	
	This:C1470.application:=Null:C1517
	
	This:C1470.lastError:=""
	This:C1470.errors:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		This:C1470.path($1)
		
	Else 
		
		This:C1470.path()
		
	End if 
	
	//====================================================================
Function defaultPath
	
	var $folder : 4D:C1709.Directory
	
	$folder:=Folder:C1567("/Applications/Xcode.app")
	
	This:C1470.success:=$folder.exists
	
	If (This:C1470.success)
		
		This:C1470.application:=$folder
		
	End if 
	
	//====================================================================
Function isDefaultPath
	var $0: Boolean
	
	$0:=(This:C1470.application.path=Folder:C1567("/Applications/Xcode.app").path)
	
	//====================================================================
	// Return by default the default path,
	// If not exist the tool path,
	// If not exist one of the path found by spotlight. The last version.
Function path
	
	var $1: Boolean  // Use default path
	
	var $useDefaultPath; $search : Boolean
	var $folder : 4D:C1709.Directory
	
	If (Count parameters:C259>=1)
		
		$useDefaultPath:=$1
		
	End if 
	
	$search:=True:C214
	
	This:C1470.defaultPath()
	
	If (This:C1470.success & $useDefaultPath)
		
		$search:=False:C215
		
	Else 
		
		// Test the tools path
		This:C1470.toolsPath()
		
		If (This:C1470.success)
			
			$folder:=This:C1470.tools.parent.parent
			
			If (This:C1470.application.path=$folder.path)
				
				This:C1470.application:=$folder
				$search:=False:C215
				
			End if 
		End if 
	End if 
	
	If ($search)
		
		This:C1470.lastPath()
		
	End if 
	
	//====================================================================
Function toolsPath
	var $o : Object
	
	$o:=This:C1470.__lep("xcode-select --print-path")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)
		
		This:C1470.tools:=Folder:C1567(Replace string:C233($o.out; "\n"; ""))
		This:C1470.success:=This:C1470.tools.exists
		
	Else 
		
		This:C1470.lastError:=$o.error
		This:C1470.errors.push($o.error)
		
	End if 
	
	//====================================================================
Function lastPath
	var $pathname; $t; $version : Text
	var $o : Object
	var $c : Collection
	
	$c:=This:C1470.paths()
	
	If (This:C1470.success)
		
		This:C1470.success:=False:C215
		
		For each ($pathname; $c)
			
			$version:=This:C1470.version(Folder:C1567($pathname))
			
			If (This:C1470.__versionCompare($version; $t)>=0)  // Equal or higher
				
				$t:=$version
				This:C1470.version:=$version
				This:C1470.application:=Folder:C1567($pathname)
				This:C1470.success:=True:C214
				
			End if 
		End for each 
	End if 
	
	//====================================================================
	// Get al installed xcode using spotlight
Function paths
	var $0: Collection
	
	var $pos : Integer
	var $o : Object
	
	$o:=This:C1470.__lep("mdfind \"kMDItemCFBundleIdentifier == 'com.apple.dt.Xcode'\"")
	
	This:C1470.success:=$o.success
	
	If (This:C1470.success)
		
		$0:=Split string:C1554($o.out; "\n"; sk ignore empty strings:K86:1)
		
	Else 
		
		This:C1470.lastError:=Choose:C955(Length:C16($o.error)=0; "No Xcode installed"; $o.error)
		
	End if 
	
	//====================================================================
Function version
	var $0: Text
	var $1: 4D:C1709.Directory
	
	var $o : Object
	
	var $directory : 4D:C1709.Directory
	
	If (Count parameters:C259>=1)
		
		$directory:=$1
		
	Else 
		
		$directory:=This:C1470.application
		
	End if 
	
	$o:=This:C1470.__lep("defaults read"+" '"+$directory.file("Contents/Info.plist").path+"' CFBundleShortVersionString")
	
	If ($o.success)
		
		$0:=Replace string:C233($o.out; "\n"; "")
		
	End if 
	
	//====================================================================
Function __lep
	var $0: Object
	var $1: Text
	
	var $cmd; $error; $in; $out : Text
	
	$0:=New object:C1471(\
		"success"; False:C215)
	
	LAUNCH EXTERNAL PROCESS:C811($1; $in; $out; $error)
	
	$0.out:=$out
	$0.error:=$error
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$cmd))
		
		$0.success:=(Length:C16($out)>0)\
			 & (Length:C16($error)=0)
		
	End if 
	
	//====================================================================
	// Compare two string version
	// -  0 if equal
	// -  1 if $1 is more recent than $2
	// - -1 if $1 is less recent than $2
Function __versionCompare
	var $0: Integer  //0 if equal, 1 if $1 is more recent than $2, -1 if $1 is less recent than $2
	var $1: Text  // Version to test
	var $2: Text  // Reference version
	var $3: Text  // Separator (optional - "." if omitted)
	
	var $separator : Text
	var $i : Integer
	var $c1; $c2 : Collection
	
	$separator:="."
	
	If (Count parameters:C259>=1)
		
		$separator:=$3
		
	End if 
	
	$c1:=Split string:C1554($1; $separator)
	$c2:=Split string:C1554($2; $separator)
	
	Case of 
			
			//______________________________________________________
		: ($c1.length>$c2.length)
			
			$c2.resize($c1.length; "0")
			
			//______________________________________________________
		: ($c2.length>$c1.length)
			
			$c1.resize($c2.length; "0")
			
			//______________________________________________________
	End case 
	
	For ($i; 0; $c2.length-1; 1)
		
		Case of 
				
				//______________________________________________________
			: (Num:C11($c1[$i])>Num:C11($c2[$i]))
				
				$0:=1
				$i:=MAXLONG:K35:2-1
				
				//______________________________________________________
			: (Num:C11($c1[$i])<Num:C11($c2[$i]))
				
				$0:=-1
				$i:=MAXLONG:K35:2-1
				
				//______________________________________________________
			Else 
				
				// Go on
				
				//______________________________________________________
		End case 
	End for 