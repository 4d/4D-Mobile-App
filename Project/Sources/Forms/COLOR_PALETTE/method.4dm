var $e : Object
$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		var $x; $j; $indx; $i; $y : Integer
		var $svg : cs:C1710.svg
		var $c : Collection
		
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/colors.json").getText()).indexed
		
		$svg:=cs:C1710.svg.new().setAttributes(New object:C1471("stroke-width"; 1; "stroke-width"; 1; "stroke"; "white"))
		
		For ($i; 0; 15; 1)  // Each row
			
			$x:=0
			
			For ($j; 1; 16; 1)  // Each column
				
				$indx:=($i*16)+$j
				
				$svg.rect(11; 11).position($x; $y).id(String:C10($indx)).fill($c[$indx-1])
				
				$x:=$x+11
				
			End for 
			
			$y:=$y+11
			
		End for 
		
		OBJECT SET VALUE:C1742("colorIndexed"; $svg.picture())
		
End case 