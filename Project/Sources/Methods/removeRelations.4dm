//%attributes = {"invisible":true}

C_OBJECT:C1216($classStore)
If (Shift down:C543)
	$classStore:=ds:C1482[Request:C163("class store name?")]
Else 
	$classStore:=ds:C1482.Employes
End if 

C_OBJECT:C1216($entities)
$entities:=$classStore.all()

C_OBJECT:C1216($entity)
For each ($entity; $entities)
	C_TEXT:C284($key)
	For each ($key; $classStore)
		
		Case of 
			: ($classStore[$key].kind="relatedEntities")
				
			: ($classStore[$key].kind="relatedEntity")
				
				$entity[$key]:=Null:C1517
				
			Else 
				// ignore
		End case 
		
	End for each 
	
	$entity.save()
	
End for each 