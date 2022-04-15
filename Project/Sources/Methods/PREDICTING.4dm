//%attributes = {"invisible":true}
var $e; $ƒ : Object

$e:=FORM Event:C1606

If (Form:C1466#Null:C1517)
	
	If (Form:C1466.ƒ=Null:C1517)
		
		Form:C1466.ƒ:=cs:C1710.PREDICTING.new()
		
	End if 
End if 

$ƒ:=Form:C1466.ƒ

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			If (Form:C1466.bakgroundColor#Null:C1517)
				
				$ƒ.background.colors:=New object:C1471(\
					"foreground"; $ƒ.bacgroundColor; \
					"background"; Form:C1466.bakgroundColor)
				
			End if 
			
			If (Form:C1466.search#Null:C1517)
				
				var $index; $start : Integer
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
				
				If (Form:C1466.found.length>0)
					
					Form:C1466.found:=Form:C1466.found.orderBy("value asc")
					
					If (Form:C1466.found.length=1)\
						 & (Bool:C1537(Form:C1466.automaticSelectionOfASingleValue))
						
						Form:C1466.choice:=Form:C1466.found[0]
						$ƒ.validate()
						
					Else 
						
						$index:=1
						
						If (Bool:C1537(Form:C1466.withValue))
							
							If (Form:C1466.found.query("value = :1"; Form:C1466.search).pop()=Null:C1517)\
								 & (Length:C16(Form:C1466.search)>0)
								
								// Insert the searched string as the first element
								Form:C1466.found.insert(0; New object:C1471(\
									"value"; Form:C1466.search))
								
								// And select the first found item
								$index:=2
								
							End if 
						End if 
						
						$ƒ.predicting.select($index)
						Form:C1466.choice:=Form:C1466.found[$index-1]
						$ƒ.open()
						
					End if 
					
					$ƒ.predicting.data:=Form:C1466.found
					
				Else 
					
					$ƒ.close()
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	Case of 
			
			//______________________________________________________
		: ($ƒ.predicting.catch())
			
			Form:C1466.choice:=Form:C1466.current
			$ƒ.validate()
			
			//________________________________________
	End case 
End if 