var $0 : Integer

var $x : Blob
var $e; $ƒ; $me; $o : Object

$ƒ:=panel()
$e:=$ƒ.event
$me:=$ƒ.actions

Case of 
		
		//______________________________________________________
	: (editor_Locked)
		
		$0:=-1
		
		//______________________________________________________
	: (Num:C11($e.row)=0)
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: ($e.code=On Drag Over:K2:13)  // Manage drag & drop cursor
		
		// Get the pastboard
		GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.action"; $x)
		
		If (Bool:C1537(OK))
			
			BLOB TO VARIABLE:C533($x; $o)
			SET BLOB SIZE:C606($x; 0)
			
			$o.tgt:=Drop position:C608
			
			If ($o.tgt=-1)  // After the last line
				
				If ($o.src#$me.rowsNumber())  // Not if the source was the last line
					
					$o:=$me.cellCoordinates(1; $me.rowsNumber()).cellBox
					$o.top:=$o.bottom
					$o.right:=$me.coordinates.right
					
					$ƒ.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
					$ƒ.dropCursor.show()
					
				Else 
					
					$0:=-1  // Reject drop
					$ƒ.dropCursor.hide()
					
				End if 
				
			Else 
				
				If ($o.src#$o.tgt)\
					 & ($o.tgt#($o.src+1))  // Not the same or the next one
					
					$o:=$me.cellCoordinates(1; $o.tgt).cellBox
					$o.bottom:=$o.top
					$o.right:=$me.coordinates.right
					
					$ƒ.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
					$ƒ.dropCursor.show()
					
				Else 
					
					$0:=-1  // Reject drop
					$ƒ.dropCursor.hide()
					
				End if 
			End if 
			
		Else 
			
			$0:=-1  // Reject drop
			$ƒ.dropCursor.hide()
			
		End if 
		
		//______________________________________________________
End case 