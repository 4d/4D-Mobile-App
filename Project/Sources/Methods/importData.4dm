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
C_TEXT:C284($pictureURL;$fieldName)
C_OBJECT:C1216($e;$s;$field)
C_LONGINT:C283($i;$max;$hs)
C_OBJECT:C1216($classStore)

$classStore:=ds:C1482.ALL_TYPES
$max:=100

$pictureURL:="https://picsum.photos/1000"
For ($i;1;$max)
	$e:=$classStore.new()
	For each ($fieldName;$classStore)
		$field:=$classStore[$fieldName]
		  // TODO manage primary key
		Case of 
			: ($field.type="string")
				$e[$fieldName]:=Generate UUID:C1066
			: ($field.type="number")
				$e[$fieldName]:=Random:C100
			: ($field.type="bool")
				$e[$fieldName]:=(Random:C100%2)>0
			: ($field.type="date")
				$e[$fieldName]:=Current date:C33  // add random
			: ($field.type="object")
				$e[$fieldName]:=New object:C1471("num";Random:C100;"str";Generate UUID:C1066)
			: ($field.type="image")
				$hs:=HTTP Get:C1157($pictureURL;$pictureBlob)
				BLOB TO PICTURE:C682($pictureBlob;$picture)
				$e[$fieldName]:=$picture
			Else 
				
		End case 
	End for each 
	$s:=$e.save()
End for 