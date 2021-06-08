Class constructor
	
	This:C1470.isMacOs:=Is macOS:C1572
	This:C1470.isWindows:=Is Windows:C1573
	This:C1470.isLinux:=Not:C34(This:C1470.isMacOs) & Not:C34(This:C1470.isWindows)
	This:C1470.systemInfos:=Get system info:C1571
	
	This:C1470.home:=Folder:C1567(Split string:C1554(Folder:C1567(fk desktop folder:K87:19).path; "/").resize(3).join("/"))
	
	This:C1470.update()
	
	//===================================================================================
Function update  // Updating values that can be modified after opening the database
	var $value : Text
	
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
Function startupDisk($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=Folder:C1567("/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function userLibrary($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function preferences($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Preferences/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function userCaches($path; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Caches/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function logs($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Logs/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
	//Function derivedData($path : Text; $create : Boolean)->$document : 4D.File
	//$document:=This.home.folder("Library/Developer/Xcode/DerivedData/")
	//If (Count parameters>=2)
	//$document:=This._postProcessing($document; $path; $create)
	//Else 
	//If (Count parameters>=1)
	//$document:=This._postProcessing($document; $path)
	//End if 
	//End if 
	
	//===================================================================================
Function simulators($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Developer/CoreSimulator/Devices/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function applicationSupport($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Application Support/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function archives($path : Text; $create : Boolean)->$document : 4D:C1709.File
	
	$document:=This:C1470.home.folder("Library/Developer/Xcode/Archives/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
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