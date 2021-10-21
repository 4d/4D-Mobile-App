Class constructor($date : Date; $time : Time)
	
	If (Count parameters:C259>=1)
		
		This:C1470.dateRef:=$date
		
	Else 
		
		This:C1470.dateRef:=Current date:C33
		
	End if 
	
	If (Count parameters:C259>=2)
		
		This:C1470.timeRef:=$time
		
	Else 
		
		This:C1470.timeRef:=Current time:C178
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a formatted string : AAAA-MM-JJ HH-MM-SS
Function stamp($date : Date; $time : Time)->$stamp : Text
	
	var $d : Date
	var $t : Time
	
	$t:=Choose:C955(Count parameters:C259>=2; $time; ?00:00:00?+This:C1470.timeRef)
	$d:=Choose:C955(Count parameters:C259>=1; $date; This:C1470.dateRef)
	
	$stamp:=String:C10($d; ISO date GMT:K1:10; $t)
	$stamp:=Replace string:C233($stamp; "T"; " ")
	$stamp:=Replace string:C233($stamp; ":"; "-")
	$stamp:=Replace string:C233($stamp; "Z"; "")
	
	