//%attributes = {"invisible":true}
C_OBJECT:C1216($Obj_;$Obj_record)

$Obj_:=JSON Parse:C1218(Document to text:C1236(Get 4D folder:C485(Current resources folder:K5:16)+"templates:data:JSON:___TABLE___.data.json"))

If ($Obj_.__ENTITIES#Null:C1517)
	
	For each ($Obj_record;$Obj_.__ENTITIES)
		
		QUERY:C277([Commands:1];[Commands:1]ID:1=$Obj_record.id)
		
		If (Records in selection:C76([Commands:1])=0)
			
			CREATE RECORD:C68([Commands:1])
			[Commands:1]ID:1:=$Obj_record.id
			
		End if 
		
		[Commands:1]Command Number:2:=$Obj_record.commandNumber
		[Commands:1]Command Name:3:=$Obj_record.commandName
		[Commands:1]themeName:4:=$Obj_record.themeName
		[Commands:1]syntax:5:=$Obj_record.syntax
		[Commands:1]theDescription:6:=$Obj_record.theDescription
		
		SAVE RECORD:C53([Commands:1])
		
	End for each 
End if 