//%attributes = {"invisible":true}
#DECLARE($keystroke : Integer)

var $row : Integer

FILTER KEYSTROKE:C389("")

Case of 
		
		//______________________________________________________
	: ($keystroke=ReturnKey:K12:27)
		
		Form:C1466.choice:=Form:C1466.current
		
		//______________________________________________________
	: ($keystroke=Down arrow key:K12:19)
		
		$row:=Num:C11(Form:C1466.index)+1
		
		If ($row>(Form:C1466.found.length))
			
			$row:=1
			
		End if 
		
		Form:C1466.ƒ.predicting.select($row)
		Form:C1466.choice:=Form:C1466.found[$row-1]
		
		//______________________________________________________
	: ($keystroke=Up arrow key:K12:18)
		
		$row:=Num:C11(Form:C1466.index)-1
		
		If ($row<=0)
			
			$row:=Form:C1466.found.length
			
		End if 
		
		Form:C1466.ƒ.predicting.select($row)
		Form:C1466.choice:=Form:C1466.found[$row-1]
		
		//______________________________________________________
End case 