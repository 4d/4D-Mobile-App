//%attributes = {}
C_LONGINT:C283($i)
C_OBJECT:C1216($o;$oProgress)
C_COLLECTION:C1488($c)

$c:=New collection:C1472()
$c[19]:=True:C214

$oProgress:=progress ("PROCESSING A COLLECTION").forEach($c;Formula:C1597(htuProgressDoSomething );True:C214)

$oProgress.setTitle("Waiting for next step…")
DELAY PROCESS:C323(Current process:C322;60)

$o:=New object:C1471

For ($i;1;50;1)
	
	$o["property_"+String:C10($i)]:=$i
	
End for 

$oProgress.setTitle("PROCESSING AN OBJECT").showStop().forEach($o;Formula:C1597(htuProgressDoSomething );True:C214)

If ($oProgress.stopped)
	
	$oProgress.close()
	
	$oProgress:=progress ("Cancelling operation…")
	DELAY PROCESS:C323(Current process:C322;60)
	$oProgress.close()
	
Else 
	
	$oProgress.setTitle("Waiting for next step…").hideStop()
	DELAY PROCESS:C323(Current process:C322;60)
	
	$c:=New collection:C1472
	
	For ($i;1;50;1)
		
		$c.push("Array item #"+String:C10($i))
		
	End for 
	
	$oProgress.setTitle("PROCESSING AN ARRAY").forEach($c;Formula:C1597(htuProgressDoSomething ))
	
End if 