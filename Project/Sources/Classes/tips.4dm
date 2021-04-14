
// === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	This:C1470.backup:=This:C1470.status()
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function status()->$status : Object
	
	$status:=New object:C1471(\
		"enabled"; Get database parameter:C643(Tips enabled:K37:79)=1; \
		"delay"; Get database parameter:C643(Tips delay:K37:80); \
		"duration"; Get database parameter:C643(Tips duration:K37:81))
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function restore()
	
	SET DATABASE PARAMETER:C642(Tips enabled:K37:79; Num:C11(This:C1470.backup.enabled))
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; This:C1470.backup.delay)
	SET DATABASE PARAMETER:C642(Tips duration:K37:81; This:C1470.backup.duration)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function default()
	
	SET DATABASE PARAMETER:C642(Tips enabled:K37:79; 1)
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; 45)
	SET DATABASE PARAMETER:C642(Tips duration:K37:81; 720)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function defaultDelay()
	
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; 45)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function setDelay($delay : Integer)
	
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; $delay)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function delay()->$delay : Integer
	
	$delay:=Get database parameter:C643(Tips delay:K37:80)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function defaultDuration()
	
	SET DATABASE PARAMETER:C642(Tips duration:K37:81; 720)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function setDuration($duration : Integer)
	
	SET DATABASE PARAMETER:C642(Tips duration:K37:81; $duration)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function duration()->$duration : Integer
	
	$duration:=Get database parameter:C643(Tips duration:K37:81)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function enable($enabled)
	
	If (Count parameters:C259>=1)
		
		SET DATABASE PARAMETER:C642(Tips enabled:K37:79; Num:C11($enabled))  // Could be integer or boolean
		
	Else 
		
		SET DATABASE PARAMETER:C642(Tips enabled:K37:79; 1)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function enabled()->$enabled : Boolean
	
	$enabled:=(Get database parameter:C643(Tips enabled:K37:79)=1)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function disable()
	
	This:C1470.enable(False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function disabled()->$disabled : Boolean
	
	$disabled:=(Get database parameter:C643(Tips enabled:K37:79)=0)
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function instantly($duration : Integer)
	
	SET DATABASE PARAMETER:C642(Tips enabled:K37:79; 1)
	SET DATABASE PARAMETER:C642(Tips delay:K37:80; 1)
	
	If (Count parameters:C259>=1)
		
		SET DATABASE PARAMETER:C642(Tips duration:K37:81; $duration)
		
	End if 