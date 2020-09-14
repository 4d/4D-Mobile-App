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