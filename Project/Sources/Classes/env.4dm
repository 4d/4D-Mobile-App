Class constructor
	
	This:C1470.isMacOs:=Is macOS:C1572
	This:C1470.isWindows:=Is Windows:C1573
	This:C1470.isLinux:=Not:C34(This:C1470.isMacOs) & Not:C34(This:C1470.isWindows)
	This:C1470.systemInfos:=Get system info:C1571
	
	This:C1470.homeFolder:=Folder:C1567(fk desktop folder:K87:19).parent
	
	This:C1470.update()
	
	//===================================================================================
Function update  // Updating the values that can be modified after the database is open
	var $t : Text
	
	GET SYSTEM FORMAT:C994(Currency symbol:K60:3; $t)
	This:C1470.currencySymbol:=$t
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $t)
	This:C1470.decimalSeparator:=$t
	
	GET SYSTEM FORMAT:C994(Thousand separator:K60:2; $t)
	This:C1470.thousandSeparator:=$t
	
	GET SYSTEM FORMAT:C994(Date separator:K60:10; $t)
	This:C1470.dateSeparator:=$t
	
	GET SYSTEM FORMAT:C994(Short date day position:K60:12; $t)
	This:C1470.dateDayPosition:=Num:C11($t)
	
	GET SYSTEM FORMAT:C994(Short date month position:K60:13; $t)
	This:C1470.dateMonthPosition:=Num:C11($t)
	
	GET SYSTEM FORMAT:C994(Short date year position:K60:14; $t)
	This:C1470.dateYearPosition:=Num:C11($t)
	
	GET SYSTEM FORMAT:C994(System date long pattern:K60:9; $t)
	This:C1470.dateLongPattern:=$t
	
	GET SYSTEM FORMAT:C994(System date medium pattern:K60:8; $t)
	This:C1470.dateMediumPattern:=$t
	
	GET SYSTEM FORMAT:C994(System date short pattern:K60:7; $t)
	This:C1470.dateShortPattern:=$t
	
	GET SYSTEM FORMAT:C994(Time separator:K60:11; $t)
	This:C1470.timeSeparator:=$t
	
	GET SYSTEM FORMAT:C994(System time AM label:K60:15; $t)
	This:C1470.timeAMLabel:=$t
	
	GET SYSTEM FORMAT:C994(System time PM label:K60:16; $t)
	This:C1470.timePMLabel:=$t
	
	GET SYSTEM FORMAT:C994(System time long pattern:K60:6; $t)
	This:C1470.timeLongPattern:=$t
	
	GET SYSTEM FORMAT:C994(System time medium pattern:K60:5; $t)
	This:C1470.timeMediumPattern:=$t
	
	GET SYSTEM FORMAT:C994(System time short pattern:K60:4; $t)
	This:C1470.timeShortPattern:=$t
	
	//===================================================================================
Function home($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function library($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function preferences($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Preferences/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function caches($path; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Caches/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function logs($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Logs/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function derivedData($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Developer/Xcode/DerivedData/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function simulators($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Developer/CoreSimulator/Devices/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function applicationSupport($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Application Support/")
	
	If (Count parameters:C259>=2)
		
		$document:=This:C1470._postProcessing($document; $path; $create)
		
	Else 
		
		If (Count parameters:C259>=1)
			
			$document:=This:C1470._postProcessing($document; $path)
			
		End if 
	End if 
	
	//===================================================================================
Function archives($path : Text; $create : Boolean)->$document : 4D:C1709.Document
	
	$document:=This:C1470.homeFolder.folder("Library/Developer/Xcode/Archives/")
	
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