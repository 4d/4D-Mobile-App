//%attributes = {}
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($l)
C_TEXT:C284($t)

If (False:C215)
	C_OBJECT:C1216(object ;$0)
	C_TEXT:C284(object ;$1)
End if 

$l:=OBJECT Get type:C1300(*;$1)

Case of 
		
		  //__________________________
	: ($l=Object type static text:K79:2)\
		 | ($l=Object type rectangle:K79:32)\
		 | ($l=Object type rounded rectangle:K79:34)\
		 | ($l=Object type line:K79:33)
		
		$t:="static"
		
		  //__________________________
	: ($l=Object type push button:K79:16)\
		 | ($l=Object type checkbox:K79:26)
		
		$t:="button"
		
		  //__________________________
	Else 
		
		$t:="widget"
		
		  //__________________________
End case 

$0:=cs:C1710[$t].new($1)