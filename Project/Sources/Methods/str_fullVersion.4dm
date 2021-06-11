//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($wantedVersion : Text)->$fullVersion : Text

var $separator : Text
$separator:="."

var $components : Collection
$components:=Split string:C1554($wantedVersion; $separator)

var $finalComponents : Collection
$finalComponents:=New collection:C1472()

var $index : Integer

For ($index; 0; 2; 1)
	
	If ($index<$components.length)
		
		$finalComponents.push(Num:C11($components[$index]))  // Only number
		
	Else 
		
		$finalComponents.push(0)  // Padding with 0
		
	End if 
End for 

$fullVersion:=$finalComponents.join(".")