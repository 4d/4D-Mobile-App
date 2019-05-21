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
