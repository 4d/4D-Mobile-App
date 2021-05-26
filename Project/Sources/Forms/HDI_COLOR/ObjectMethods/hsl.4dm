
var $c : Collection
$c:=Form:C1466.color.setHSL(OBJECT Get value:C1743(OBJECT Get name:C1087(Object current:K67:2))).getMatchingColors(Form:C1466.complementaryDropdown.index)

Form:C1466.main:=Form:C1466.color.main
OBJECT SET RGB COLORS:C628(*; "main"; Form:C1466.main; Form:C1466.main)

var $i : Integer
For ($i; 0; 3; 1)
	
	If ($i<$c.length)
		
		OBJECT SET VISIBLE:C603(*; "color_"+String:C10($i); True:C214)
		OBJECT SET RGB COLORS:C628(*; "color_"+String:C10($i); Form:C1466.foreground; $c[$i])
		
	Else 
		
		OBJECT SET VISIBLE:C603(*; "color_"+String:C10($i); False:C215)
		
	End if 
End for 

OBJECT SET RGB COLORS:C628(*; "main.css"; Form:C1466.color.fontColor())
