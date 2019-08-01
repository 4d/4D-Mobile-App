//%attributes = {}
C_OBJECT:C1216($svg;$o)

Case of 
		
		  //______________________________________________________
	: (True:C214)
		
		$o:=New object:C1471(\
			"viewport-fill";"lavender";\
			"viewBox";"0 0 1000 500";\
			"preserveAspectRatio";"none")
		
		$svg:=svg (JSON Stringify:C1217($o)).dimensions(1000;500;"px")
		
		$svg.rect(10;10;100;20;New object:C1471(\
			"stroke";"blue"))
		
		$svg.rect(10;40;100;20;New object:C1471(\
			"stroke";"red";\
			"fill";"yellow";\
			"rx";5))
		
		  //______________________________________________________
End case 

EXECUTE METHOD:C1007("SVGTool_SHOW_IN_VIEWER";*;$svg.root)

$svg.close()