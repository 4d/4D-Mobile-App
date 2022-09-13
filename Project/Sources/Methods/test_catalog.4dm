//%attributes = {}
C_BOOLEAN:C305($b)
C_OBJECT:C1216($o)

COMPONENT_INIT

err_TRY

//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "NOT EXPOSED"))

ASSERT:C1129(Not:C34($o.success))
ASSERT:C1129($o.errors#Null:C1517)
ASSERT:C1129($o.errors.length=1)
ASSERT:C1129($o.errors[0]="Table not found \"NOT EXPOSED\"")


//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "Command"))

$b:=Not:C34($o.success)

ASSERT:C1129(Not:C34($o.success))
ASSERT:C1129($o.errors#Null:C1517)
ASSERT:C1129($o.errors.length=1)
ASSERT:C1129($o.errors[0]="Table not found \"Command\"")

//_____________________________________________________________
If (Component.isMatrix)
	
	$o:=catalog("fields"; New object:C1471(\
		"tableName"; "Commands"))
	
	$b:=$b & $o.success
	
	ASSERT:C1129($o.success)
	
End if 

//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "UNIT_0"))

$b:=$b & $o.success

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.fields.length=32)
	ASSERT:C1129($o.errors=Null:C1517)
	
	If (Asserted:C1132($o.infos#Null:C1517))
		
		If (Asserted:C1132($o.infos.length=1))
			
			ASSERT:C1129($o.infos[0]="Recursive relation \"recursive_0\" on [UNIT_0]")
			
		End if 
	End if 
	
	If (Asserted:C1132($o.warnings#Null:C1517))
		
		If (Asserted:C1132($o.warnings.length=2))
			
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_3] -> [UNIT_0]")
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_3] -> [UNIT_0]")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "UNIT_1"))

$b:=$b & $o.success

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.fields.length=23)
	
	If (Asserted:C1132($o.infos#Null:C1517))
		
		If (Asserted:C1132($o.infos.length=1))
			
			ASSERT:C1129($o.infos[0]="Recursive relation \"recursive_0\" on [UNIT_0]")
			
		End if 
	End if 
	
	If (Asserted:C1132($o.warnings#Null:C1517))
		
		If (Asserted:C1132($o.warnings.length=2))
			
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_0] -> [UNIT_1]")
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_0] -> [UNIT_1]")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "UNIT_2"))

$b:=$b & $o.success

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.fields.length=26)
	
	If (Asserted:C1132($o.infos#Null:C1517))
		
		If (Asserted:C1132($o.infos.length=1))
			
			ASSERT:C1129($o.infos[0]="Recursive relation \"recursive_0\" on [UNIT_0]")
			
		End if 
	End if 
	
	If (Asserted:C1132($o.warnings#Null:C1517))
		
		If (Asserted:C1132($o.warnings.length=2))
			
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_1] -> [UNIT_2]")
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_1] -> [UNIT_2]")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$o:=catalog("fields"; New object:C1471(\
"tableName"; "UNIT_3"))

$b:=$b & $o.success

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.fields.length=29)
	
	If (Asserted:C1132($o.infos#Null:C1517))
		
		If (Asserted:C1132($o.infos.length=1))
			
			ASSERT:C1129($o.infos[0]="Recursive relation \"recursive_0\" on [UNIT_0]")
			
		End if 
	End if 
	
	If (Asserted:C1132($o.warnings#Null:C1517))
		
		If (Asserted:C1132($o.warnings.length=2))
			
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_2] -> [UNIT_3]")
			ASSERT:C1129($o.warnings[0]="Circular relation [UNIT_2] -> [UNIT_3]")
			
		End if 
	End if 
End if 

err_FINALLY
