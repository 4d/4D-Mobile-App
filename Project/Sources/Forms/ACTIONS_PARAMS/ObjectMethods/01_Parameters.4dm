#DECLARE()->$allow : Integer

var $allow : Integer
var $x : Blob
var $e; $ƒ; $me; $o : Object

$ƒ:=panel()
$e:=$ƒ.event

$e.row:=Drop position:C608

Case of 
		
		//______________________________________________________
	: (PROJECT.isLocked())
		
		$allow:=-1
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)
		
		// Get the pastboard
		GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.parameter"; $x)
		
		If (Bool:C1537(OK))
			
			BLOB TO VARIABLE:C533($x; $o)
			SET BLOB SIZE:C606($x; 0)
			
			$me:=$ƒ.parameters
			
			If ($e.row=-1)  // After the last line
				
				If ($o.src#$me.rowsNumber())  // Not if the source was the last line
					
					$o:=$me.getRowCoordinates($me.rowsNumber())
					$o.top:=$o.bottom
					$o.right:=$me.coordinates.right
					
				Else 
					
					$allow:=-1  // Reject drop
					
				End if 
				
			Else 
				
				If ($o.src#$e.row)\
					 & ($e.row#($o.src+1))  // Not the same or the next one
					
					$o:=$me.getRowCoordinates($e.row)
					$o.bottom:=$o.top
					$o.right:=$me.coordinates.right
					
				Else 
					
					$allow:=-1  // Reject drop
					
				End if 
			End if 
			
		Else 
			
			$allow:=-1  // Reject drop
			
		End if 
		
		//______________________________________________________
End case 

If ($allow=-1)
	
	SET CURSOR:C469(9019)
	$ƒ.dropCursor.hide()
	
Else 
	
	$ƒ.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
	$ƒ.dropCursor.show()
	
End if 