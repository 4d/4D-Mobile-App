//%attributes = {"invisible":true}
#DECLARE($keystroke : Integer)

var $row : Integer

Case of 
		
		//______________________________________________________
	: ($keystroke=Return key:K12:27)
		
		FILTER KEYSTROKE:C389("")
		Form:C1466.choice:=Form:C1466.current
		
		//______________________________________________________
	: ($keystroke=Down arrow key:K12:19)
		
		FILTER KEYSTROKE:C389("")
		
		$row:=Num:C11(Form:C1466.index)+1
		
		If ($row>(Form:C1466.found.length))
			
			$row:=1
			
		End if 
		
		LISTBOX SELECT ROW:C912(*; "predicting"; $row; lk replace selection:K53:1)
		OBJECT SET SCROLL POSITION:C906(*; "predicting"; $row; *)
		Form:C1466.choice:=Form:C1466.found[$row-1]
		
		//______________________________________________________
	: ($keystroke=Up arrow key:K12:18)
		
		FILTER KEYSTROKE:C389("")
		
		$row:=Num:C11(Form:C1466.index)-1
		
		If ($row<0)
			
			$row:=Form:C1466.found.length
			
		End if 
		
		LISTBOX SELECT ROW:C912(*; "predicting"; $row; lk replace selection:K53:1)
		OBJECT SET SCROLL POSITION:C906(*; "predicting"; $row; *)
		Form:C1466.choice:=Form:C1466.found[$row-1]
		
		//______________________________________________________
End case 