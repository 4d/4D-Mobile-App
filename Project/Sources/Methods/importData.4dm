//%attributes = {"invisible":true}
/*
C_OBJECT($Obj_;$Obj_record)

$Obj_:=JSON Parse(Document to text(Get 4D folder(Current resources folder)+"templates:data:JSON:___TABLE___.data.json"))

If ($Obj_.__ENTITIES#Null)

For each ($Obj_record;$Obj_.__ENTITIES)

QUERY([Commands];[Commands]ID=$Obj_record.id)

If (Records in selection([Commands])=0)

CREATE RECORD([Commands])
[Commands]ID:=$Obj_record.id

End if 

[Commands]Command Number:=$Obj_record.commandNumber
[Commands]Command Name:=$Obj_record.commandName
[Commands]themeName:=$Obj_record.themeName
[Commands]syntax:=$Obj_record.syntax
[Commands]theDescription:=$Obj_record.theDescription

SAVE RECORD([Commands])

End for each 
End if 
*/

C_PICTURE:C286($picture)
C_BLOB:C604($pictureBlob)
C_TEXT:C284($pictureURL; $fieldName; $primaryKey)
C_OBJECT:C1216($e; $s; $field)
C_LONGINT:C283($i; $j; $max; $maxStr; $hs)
C_OBJECT:C1216($classStore)
C_BOOLEAN:C305($withPicture)

$withPicture:=False:C215

If (Shift down:C543)
	$classStore:=ds:C1482[Request:C163("class store name?")]
Else 
	$classStore:=ds:C1482.Employes
End if 

If ($classStore=Null:C1517)
	ALERT:C41("this class store do not exists")
	ABORT:C156
End if 


If (Shift down:C543)
	$max:=Num:C11(Request:C163("how many?"))
	If ($max<=0)
		$max:=10
	End if 
Else 
	$max:=10
End if 

If (Shift down:C543)
	$maxStr:=Num:C11(Request:C163("string concatenate?"))
	If ($max<=0)
		$maxStr:=1
	End if 
Else 
	$maxStr:=10
End if 

$primaryKey:=$classStore.getInfo().primaryKey

$pictureURL:="https://picsum.photos/1000"
For ($i; 1; $max)
	$e:=$classStore.new()
	For each ($fieldName; $classStore)
		If ($fieldName=$primaryKey)
			// skip
		Else 
			$field:=$classStore[$fieldName]
			// TODO manage primary key
			Case of 
				: ($field.type="string")
					$e[$fieldName]:=""
					For ($j; 1; $maxStr)
						$e[$fieldName]:=$e[$fieldName]+Generate UUID:C1066
					End for 
				: ($field.type="number")
					$e[$fieldName]:=Random:C100
				: ($field.type="bool")
					$e[$fieldName]:=(Random:C100%2)>0
				: ($field.type="date")
					$e[$fieldName]:=Current date:C33  // add random
				: ($field.type="object")
					$e[$fieldName]:=New object:C1471("num"; Random:C100; "str"; Generate UUID:C1066)
				: ($field.type="image")
					If ($withPicture)
						$hs:=HTTP Get:C1157($pictureURL; $pictureBlob)
						BLOB TO PICTURE:C682($pictureBlob; $picture)
						$e[$fieldName]:=$picture
					End if 
				Else 
					
			End case 
		End if 
	End for each 
	$s:=$e.save()
End for 
