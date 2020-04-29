Class constructor
	
	C_OBJECT:C1216(${1})
	
	C_LONGINT:C283($i)
	
	This:C1470.target:=New collection:C1472
	
	For ($i;1;Count parameters:C259;1)
		
		This:C1470.target.push(${$i})
		
	End for 
	
Function distributeHorizontally
	
	C_OBJECT:C1216($1)
	
	C_LONGINT:C283($bottom;$height;$left;$lGap;$offset;$right)
	C_LONGINT:C283($top;$width)
	C_OBJECT:C1216($o)
	
	If ($1.start#Null:C1517)
		
		$offset:=Num:C11($1.start)
		
	End if 
	
	If ($1.gap#Null:C1517)
		
		$lGap:=Num:C11($1.gap)
		
	End if 
	
	For each ($o;This:C1470.target)
		
		OBJECT GET BEST SIZE:C717(*;$o.name;$width;$height)
		
		Case of 
				  //______________________________
			: ($o.type=Object type static text:K79:2)
				
				  // Add 10 pixels
				$width:=$width+10
				
				  //______________________________
			Else 
				
				  // Add 10% for margins
				$width:=Round:C94($width*1.1;0)
				
				  //______________________________
		End case 
		
		  // Minimum & maximum width
		$width:=Choose:C955($width<Num:C11($1.minWidth);Num:C11($1.minWidth);$width)
		
		If ($1.maxWidth#Null:C1517)
			
			$width:=Choose:C955($width>Num:C11($1.maxWidth);Num:C11($1.maxWidth);$width)
			
		End if 
		
		  // Get current object coordinates
		OBJECT GET COORDINATES:C663(*;$o.name;$left;$top;$right;$bottom)
		
		  // Resize current object
		If ($offset#0)
			
			$left:=$offset
			
		End if 
		
		$right:=$left+$width
		OBJECT SET COORDINATES:C1248(*;$o.name;$left;$top;$right;$bottom)
		
		  // Calculate the cumulative shift
		$offset:=$right+$lGap
		
	End for each 