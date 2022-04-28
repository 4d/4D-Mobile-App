Class constructor
	
	This:C1470.isMacOs:=Is macOS:C1572
	This:C1470.isWindows:=Is Windows:C1573
	This:C1470.isLinux:=Not:C34(This:C1470.isMacOs) & Not:C34(This:C1470.isWindows)
	
	This:C1470.machineName:=Current machine:C483
	This:C1470.userName:=Current system user:C484
	
	This:C1470.home:=Folder:C1567(Split string:C1554(Folder:C1567(fk desktop folder:K87:19).path; "/").resize(3).join("/"))
	This:C1470.desktop:=Folder:C1567(System folder:C487(Desktop:K41:16); fk platform path:K87:2)
	This:C1470.documents:=Folder:C1567(System folder:C487(Documents folder:K41:18); fk platform path:K87:2)
	This:C1470.systemFolder:=Folder:C1567(This:C1470.isWindows ? System folder:C487(System Win:K41:13) : System folder:C487(System:K41:1); fk platform path:K87:2)
	This:C1470.applicationsFolder:=Folder:C1567(System folder:C487(Applications or program files:K41:17); fk platform path:K87:2)
	
	This:C1470.screens:=New collection:C1472().resize(Count screens:C437; New object:C1471("coordinates"; New object:C1471; "workArea"; New object:C1471))
	
	var $bottom; $i; $left; $right; $top : Integer
	var $creen : Object
	
	For each ($creen; This:C1470.screens)
		
		$i+=1
		
		SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen size:K27:9)
		$creen.coordinates.left:=$left
		$creen.coordinates.top:=$top
		$creen.coordinates.right:=$right
		$creen.coordinates.bottom:=$bottom
		
		SCREEN COORDINATES:C438($left; $top; $right; $bottom; $i; Screen work area:K27:10)
		$creen.workArea.left:=$left
		$creen.workArea.top:=$top
		$creen.workArea.right:=$right
		$creen.workArea.bottom:=$bottom
		
	End for each 
	
	This:C1470.mainScreenID:=Menu bar screen:C441  //On Windows, Menu bar screen always returns 1
	This:C1470.mainScreen:=This:C1470.screens[This:C1470.mainScreenID-1]
	
	This:C1470.menuBarHeight:=Menu bar height:C440
	
	This:C1470.updateEnvironmentValues(True:C214)
	
	//===================================================================================
	// Update user & system values that may have been modified
Function updateEnvironmentValues($system : Boolean)
	var $value : Text
	
	If ($system)  // To update the  volumes
		
		// ⚠️ time-consuming
		This:C1470.systemInfos:=Get system info:C1571
		
	End if 
	
	GET SYSTEM FORMAT:C994(Currency symbol:K60:3; $value)
	This:C1470.currencySymbol:=$value
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $value)
	This:C1470.decimalSeparator:=$value
	
	GET SYSTEM FORMAT:C994(Thousand separator:K60:2; $value)
	This:C1470.thousandSeparator:=$value
	
	GET SYSTEM FORMAT:C994(Date separator:K60:10; $value)
	This:C1470.dateSeparator:=$value
	
	GET SYSTEM FORMAT:C994(Short date day position:K60:12; $value)
	This:C1470.dateDayPosition:=Num:C11($value)
	
	GET SYSTEM FORMAT:C994(Short date month position:K60:13; $value)
	This:C1470.dateMonthPosition:=Num:C11($value)
	
	GET SYSTEM FORMAT:C994(Short date year position:K60:14; $value)
	This:C1470.dateYearPosition:=Num:C11($value)
	
	GET SYSTEM FORMAT:C994(System date long pattern:K60:9; $value)
	This:C1470.dateLongPattern:=$value
	
	GET SYSTEM FORMAT:C994(System date medium pattern:K60:8; $value)
	This:C1470.dateMediumPattern:=$value
	
	GET SYSTEM FORMAT:C994(System date short pattern:K60:7; $value)
	This:C1470.dateShortPattern:=$value
	
	GET SYSTEM FORMAT:C994(Time separator:K60:11; $value)
	This:C1470.timeSeparator:=$value
	
	GET SYSTEM FORMAT:C994(System time AM label:K60:15; $value)
	This:C1470.timeAMLabel:=$value
	
	GET SYSTEM FORMAT:C994(System time PM label:K60:16; $value)
	This:C1470.timePMLabel:=$value
	
	GET SYSTEM FORMAT:C994(System time long pattern:K60:6; $value)
	This:C1470.timeLongPattern:=$value
	
	GET SYSTEM FORMAT:C994(System time medium pattern:K60:5; $value)
	This:C1470.timeMediumPattern:=$value
	
	GET SYSTEM FORMAT:C994(System time short pattern:K60:4; $value)
	This:C1470.timeShortPattern:=$value
	
	//===================================================================================
Function startupDisk($path : Text; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=Folder:C1567("/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//===================================================================================
Function userLibrary($path : Text; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=This:C1470.home.folder("Library/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//===================================================================================
Function preferences($path : Text; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=This:C1470.home.folder("Library/Preferences/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//===================================================================================
Function userCaches($path; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=This:C1470.home.folder("Library/Caches/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//===================================================================================
Function logs($path : Text; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=This:C1470.home.folder("Library/Logs/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//===================================================================================
Function applicationSupport($path : Text; $create : Boolean) : Object
	
	var $o : Object
	
	$o:=This:C1470.home.folder("Library/Application Support/")
	
	If (Count parameters:C259>=2)
		
		$o:=This:C1470._postProcessing($o; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$o:=This:C1470._postProcessing($o; $path)
			
		End if 
	End if 
	
	return $o
	
	//mark:-
	//===================================================================================
Function _postProcessing($document : Object; $pathOrCreate : Variant; $create : Boolean)->$return : Object
	
	$return:=$document
	
	If (Count parameters:C259>=2)
		
		If (Value type:C1509($pathOrCreate)=Is boolean:K8:9)
			
			If ($pathOrCreate)
				
				$document.create()
				
			End if 
			
		Else 
			
			//%W-533.1
			If ($pathOrCreate[[Length:C16($pathOrCreate)]]="/")
				
				//%W+533.1
				
				// Append folder
				$return:=$document.folder($pathOrCreate)
				
			Else 
				
				// Append file
				$return:=$document.file($pathOrCreate)
				
			End if 
		End if 
		
		If (Count parameters:C259>=3)
			
			If ($create)
				
				$document.create()
				
			End if 
		End if 
	End if 