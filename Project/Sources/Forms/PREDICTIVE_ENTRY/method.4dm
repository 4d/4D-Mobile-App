var $index; $start : Integer
var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Double Clicked:K2:5)
		
		Form:C1466.choice:=Form:C1466.current
		CALL SUBFORM CONTAINER:C1086(-1)
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		Form:C1466.choice:=Form:C1466.current
		
		//______________________________________________________
	: ($e.code=On Bound Variable Change:K2:52)
		
		If (Form:C1466#Null:C1517)
			
			If (Form:C1466.search#Null:C1517)
				
				ARRAY TEXT:C222($array; 0x0000)
				COLLECTION TO ARRAY:C1562(Form:C1466.values; $array)
				
				Form:C1466.found:=New collection:C1472
				$start:=1
				
				Repeat 
					
					If (Bool:C1537(Form:C1466.contains))
						
						$index:=Find in array:C230($array; "@"+Form:C1466.search+"@"; $start)
						
					Else 
						
						// By default, starts with
						$index:=Find in array:C230($array; Form:C1466.search+"@"; $start)
						
					End if 
					
					If ($index>0)
						
						Form:C1466.found.push(New object:C1471(\
							"value"; $array{$index}))
						
						$start:=$index+1
						
					End if 
				Until ($index=-1)
				
				Form:C1466.found:=Form:C1466.found
				
				If (Form:C1466.found.length>0)
					
					If (Form:C1466.found.length=1)\
						 & (Bool:C1537(Form:C1466.automaticSelectionOfASingleValue))
						
						Form:C1466.choice:=Form:C1466.found[0]
						CALL SUBFORM CONTAINER:C1086(-1)  // Validate
						
					Else 
						
						If (Bool:C1537(Form:C1466.withValue))
							
							If (Form:C1466.found.query("value = :1"; Form:C1466.search).pop()=Null:C1517)
								
								// Insert the searched string as the first element
								Form:C1466.found.insert(0; New object:C1471(\
									"value"; Form:C1466.search))
								
								LISTBOX SELECT ROW:C912(*; "predicting"; 2; lk replace selection:K53:1)
								OBJECT SET SCROLL POSITION:C906(*; "predicting"; 1; *)
								Form:C1466.choice:=Form:C1466.found[1]
								
							Else 
								
								LISTBOX SELECT ROW:C912(*; "predicting"; 1; lk replace selection:K53:1)
								OBJECT SET SCROLL POSITION:C906(*; "predicting"; 1; *)
								Form:C1466.choice:=Form:C1466.found[0]
								
							End if 
							
						Else 
							
							LISTBOX SELECT ROW:C912(*; "predicting"; 1; lk replace selection:K53:1)
							OBJECT SET SCROLL POSITION:C906(*; "predicting"; 1; *)
							Form:C1466.choice:=Form:C1466.found[0]
							
						End if 
						
						CALL SUBFORM CONTAINER:C1086(-2)  // Show
						
					End if 
					
				Else 
					
					CALL SUBFORM CONTAINER:C1086(-3)  // Hide
					
				End if 
			End if 
		End if 
		
		//______________________________________________________
End case 