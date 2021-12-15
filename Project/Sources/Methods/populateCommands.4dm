//%attributes = {}
var $command : Text
var $number : Integer
var $classStore : 4D:C1709.DataClass
var $entity : 4D:C1709.Entity

$classStore:=ds:C1482.Commands

Repeat 
	
	$number:=$number+1
	
	$command:=Command name:C538($number)
	
	If (OK=1)\
		 & (Length:C16($command)>0)
		
		$entity:=$classStore.new()
		
		$entity["Command Number"]:=$number
		$entity["Command name"]:=$command
		
		$entity.save()
		
	End if 
	
Until (OK=0)