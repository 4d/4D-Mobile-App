var $index; $start : Integer

If (Form:C1466#Null:C1517)
	
	If (Form:C1466.editedText#Null:C1517)
		
		ARRAY TEXT:C222($array; 0x0000)
		COLLECTION TO ARRAY:C1562(Form:C1466.values; $array)
		
		Form:C1466.selected:=New collection:C1472
		$start:=1
		
		Repeat 
			
			$index:=Find in array:C230($array; Form:C1466.editedText+"@"; $start)
			
			If ($index>0)
				
				Form:C1466.selected.push(New object:C1471(\
					"value"; $array{$index}))
				
				$start:=$index+1
				
			End if 
		Until ($index=-1)
		
		Form:C1466.selected:=Form:C1466.selected
		
		If (Form:C1466.selected.length>0)
			
			LISTBOX SELECT ROW:C912(*; "predicting"; 1; lk replace selection:K53:1)
			
		Else 
			
			LISTBOX SELECT ROW:C912(*; "predicting"; 0; lk replace selection:K53:1)
			
		End if 
	End if 
End if 