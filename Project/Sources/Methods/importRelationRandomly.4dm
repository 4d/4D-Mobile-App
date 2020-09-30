//%attributes = {"invisible":true,"preemptive":"capable"}


C_OBJECT:C1216($classStore)
C_OBJECT:C1216($entities; $entity; $related)
C_TEXT:C284($key)
C_LONGINT:C283($one; $two)

If (Shift down:C543)
	$classStore:=ds:C1482[Request:C163("class store name?")]
Else 
	$classStore:=ds:C1482.Employes
End if 

$entities:=$classStore.all()

For each ($entity; $entities)
	For each ($key; $classStore)
		
		Case of 
			: ($classStore[$key].kind="relatedEntities")
				
/*$related:=ds[$classStore[$key].relatedDataClass].all()
				
$one:=Random%$related.length
$two:=Random%$related.length
				
$related:=$related.slice(Min($two;$one);Max($two;$one))
				
$entity[$key]:=$related*/
				
			: ($classStore[$key].kind="relatedEntity")
				
				$related:=ds:C1482[$classStore[$key].relatedDataClass].all()
				If ($related.length>0)
					$one:=Random:C100%$related.length
					$entity[$key]:=$related[$one]
					// else nothing to add
				End if 
			Else 
				// ignore
		End case 
		
	End for each 
	
	$entity.save()
	
End for each 