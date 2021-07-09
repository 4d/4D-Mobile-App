//%attributes = {"invisible":true}
var $e : Object

$e:=FORM Event:C1606

If ($e.objectName=Null:C1517)  // <== FORM METHOD
	
	If (Form:C1466#Null:C1517)
		
		If (Form:C1466.ƒ=Null:C1517)
			
			Form:C1466.ƒ:=cs:C1710.PREDICTING.new()
			
		End if 
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Double Clicked:K2:5)
			
			Form:C1466.choice:=Form:C1466.current
			Form:C1466.ƒ.validate()
			
			//______________________________________________________
		: ($e.code=On Bound Variable Change:K2:52)
			
			If (Form:C1466.bakgroundColor#Null:C1517)
				
				Form:C1466.ƒ.background.setColors(Form:C1466.ƒ.background.getForegroundColor(); Form:C1466.bakgroundColor)
				
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
						Form:C1466.ƒ.validate()
						
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
						
						Form:C1466.ƒ.predicting.select($index)
						Form:C1466.choice:=Form:C1466.found[$index-1]
						Form:C1466.ƒ.open()
						
					End if 
					
					Form:C1466.ƒ.predicting.data:=Form:C1466.found
					
				Else 
					
					Form:C1466.ƒ.close()
					
				End if 
			End if 
			
			//______________________________________________________
		: ($e.code=On Selection Change:K2:29)
			
			Form:C1466.choice:=Form:C1466.current
			
			//______________________________________________________
	End case 
	
Else   // <== WIDGETS METHOD
	
	// 
	
End if 