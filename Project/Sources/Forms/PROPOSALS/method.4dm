var $bottom; $count; $height; $left; $right; $top : Integer
var $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.list:=cs:C1710.proposalsbox.new("proposals Box")
		
		$count:=Form:C1466.proposals.length
		
		If ($count>1)
			
			$height:=20*Choose:C955($count>101; 10; $count)
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; Current form window:C827)
			SET WINDOW RECT:C444($left; $top; $right; $top+$height; Current form window:C827)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				//…………………………………………………………………
			: ($e.objectName="upArrow")
				
				If ((Form:C1466.index>1)\
					 & (Form:C1466.index<=Form:C1466.proposals.length))
					
					Form:C1466.list.select(Form:C1466.index-1)
					
				End if 
				
				//…………………………………………………………………
			: ($e.objectName="downArrow")
				
				If ((Form:C1466.index>=0)\
					 & (Form:C1466.index<Form:C1466.proposals.length))
					
					Form:C1466.list.select(Form:C1466.index+1)
					
				End if 
				
				//…………………………………………………………………
			: ($e.objectName="close")
				
				CANCEL:C270
				
				//…………………………………………………………………
		End case 
		
		//________________________________________
End case 