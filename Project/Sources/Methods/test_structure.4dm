//%attributes = {}
C_LONGINT:C283($i;$l;$Lon_tableNumber;$Lon_x)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

TRY

COMPONENT_INIT

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"catalog"))

If (Asserted:C1132($o.success))
	
	If (Asserted:C1132($o.value#Null:C1517))
		
		If (Asserted:C1132($o.value.length>0))
			
			$c:=$o.value
			
		End if 
	End if 
End if 

//=============================================================
//=                    fieldDefinition                        =
//=============================================================

$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"ID";\
"tableNumber";8858))

If (Asserted:C1132(Not:C34($o.success)))
	
	If (Asserted:C1132($o.errors#Null:C1517))
		
		If (Asserted:C1132($o.errors.length>0))
			
			ASSERT:C1129($o.errors[0]="Table not found #8858")
			
		End if 
	End if 
End if 

For ($i;1;Get last table number:C254;1)
	
	If (Is table number valid:C999($i))
		
		If (Table name:C256($i)="UNIT_0")
			
			$l:=$i
			$i:=MAXLONG:K35:2-1
			
		End if 
	End if 
End for 

$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"ID";\
"tableNumber";$l))

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.tableNumber=$l)
	ASSERT:C1129($o.tableName="UNIT_0")
	
	ASSERT:C1129($o.fieldNumber=1)
	ASSERT:C1129($o.name="ID")
	
	ASSERT:C1129($o.path="ID")
	
	ASSERT:C1129($o.type=4)
	
	ASSERT:C1129($o.fieldType=Is longint:K8:6)
	
End if 

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"r_1.Field_1_2";\
"tableNumber";$l))

If (Asserted:C1132($o.success))
	
	For ($i;1;Get last table number:C254;1)
		
		If (Is table number valid:C999($i))
			
			If (Table name:C256($i)="UNIT_1")
				
				$Lon_tableNumber:=$i
				$i:=MAXLONG:K35:2-1
				
			End if 
		End if 
	End for 
	
	ASSERT:C1129($o.tableNumber=$Lon_tableNumber)
	ASSERT:C1129($o.tableName="UNIT_1")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_1_2")
	
	ASSERT:C1129($o.path="r_1.Field_1_2")
	
	ASSERT:C1129($o.type=3)
	ASSERT:C1129($o.fieldType=Is integer:K8:5)
	
End if 

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"r_2.Field_1_2";\
"tableNumber";$l))

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.tableNumber=$Lon_tableNumber)
	ASSERT:C1129($o.tableName="UNIT_1")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_1_2")
	
	ASSERT:C1129($o.path="r_2.Field_1_2")
	
	ASSERT:C1129($o.type=3)
	ASSERT:C1129($o.fieldType=Is integer:K8:5)
	
End if 

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"r_1.r_1_2.Field_2_3";\
"tableNumber";$l))

If (Asserted:C1132($o.success))
	
	For ($i;1;Get last table number:C254;1)
		
		If (Is table number valid:C999($i))
			
			If (Table name:C256($i)="UNIT_2")
				
				$Lon_tableNumber:=$i
				$i:=MAXLONG:K35:2-1
				
			End if 
		End if 
	End for 
	
	ASSERT:C1129($o.tableNumber=$Lon_tableNumber)
	ASSERT:C1129($o.tableName="UNIT_2")
	
	ASSERT:C1129($o.fieldNumber=3)
	ASSERT:C1129($o.name="Field_2_3")
	
	ASSERT:C1129($o.path="r_1.r_1_2.Field_2_3")
	
	ASSERT:C1129($o.type=1)
	ASSERT:C1129($o.fieldType=Is boolean:K8:9)
	
End if 

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"r_1.r_1_2.r_2_3.Field_3_2";\
"tableNumber";$l;\
"catalog";$c))

If (Asserted:C1132($o.success))
	
	For ($i;1;Get last table number:C254;1)
		
		If (Is table number valid:C999($i))
			
			If (Table name:C256($i)="UNIT_3")
				
				$Lon_tableNumber:=$i
				$i:=MAXLONG:K35:2-1
				
			End if 
		End if 
	End for 
	
	ASSERT:C1129($o.tableNumber=$Lon_tableNumber)
	ASSERT:C1129($o.tableName="UNIT_3")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_3_2")
	
	ASSERT:C1129($o.path="r_1.r_1_2.r_2_3.Field_3_2")
	
	ASSERT:C1129($o.type=12)
	ASSERT:C1129($o.fieldType=Is picture:K8:10)
	
End if 

//_____________________________________________________________
$o:=structure(New object:C1471(\
"action";"fieldDefinition";\
"path";"r_2.r_1_2.r_2_3.Field_3_2";\
"tableNumber";$l;\
"catalog";$c))

If (Asserted:C1132($o.success))
	
	ASSERT:C1129($o.tableNumber=$Lon_tableNumber)
	ASSERT:C1129($o.tableName="UNIT_3")
	
	ASSERT:C1129($o.fieldNumber=2)
	ASSERT:C1129($o.name="Field_3_2")
	
	ASSERT:C1129($o.path="r_2.r_1_2.r_2_3.Field_3_2")
	
	ASSERT:C1129($o.type=12)
	ASSERT:C1129($o.fieldType=Is picture:K8:10)
	
End if 

If (Structure file:C489=Structure file:C489(*))
	
	//=============================================================
	//=                   __DeletedRecords                        =
	//=============================================================
	
	DOCUMENT:="DROP TABLE IF EXISTS "+String:C10(SHARED.deletedRecordsTable.name)
	
	Begin SQL
		
		EXECUTE IMMEDIATE :DOCUMENT
		
	End SQL
	
	$o:=structure(New object:C1471(\
		"action";"verifyDeletedRecords"))
	
	If (Asserted:C1132(Not:C34($o.success);"verifyDeletedRecords when the table doesn't exist"))
		
		$o:=structure(New object:C1471(\
			"action";"createDeletedRecords"))
		
		If (Asserted:C1132($o.success;"createDeletedRecords when the table doesn't exist"))
			
			$o:=structure(New object:C1471(\
				"action";"verifyDeletedRecords"))
			
			If (Asserted:C1132($o.success;"verifyDeletedRecords when the table exist"))
				
				$o:=structure(New object:C1471(\
					"action";"createDeletedRecords"))
				
				ASSERT:C1129($o.success;"createDeletedRecords when the table already exist")
				
				$o:=structure(New object:C1471(\
					"action";"catalog";\
					"name";SHARED.deletedRecordsTable.name))
				
				ASSERT:C1129(Not:C34($o.success);"catalog doesn't filter the deletedRecords table")
				
			End if 
		End if 
	End if 
	
	//=============================================================
	//=                         __stamps                          =
	//=============================================================
	
	DOCUMENT:="CREATE TABLE IF NOT EXISTS UNIT_STRUCTURE (ID INT32, PRIMARY KEY (ID));"
	
	Begin SQL
		
		EXECUTE IMMEDIATE :DOCUMENT
		
	End SQL
	
	$o:=structure(New object:C1471(\
		"action";"verifyStamps";\
		"tableName";"UNIT_STRUCTURE"))
	
	ASSERT:C1129(Not:C34($o.success);"verifyStamps when field is missing")
	
	$o:=structure(New object:C1471(\
		"action";"createStamps";\
		"tableName";"UNIT_STRUCTURE"))
	
	If (Asserted:C1132($o.success;"createStamps when the stamp doesn't exist"))
		
		$o:=structure(New object:C1471(\
			"action";"createStamps";\
			"tableName";"UNIT_STRUCTURE"))
		
		ASSERT:C1129($o.success;"createStamps when the stamp already exist")
		
		$o:=structure(New object:C1471(\
			"action";"verifyStamps";\
			"tableName";"UNIT_STRUCTURE"))
		
		ASSERT:C1129($o.success;"verifyStamps when the field exist")
		
	End if 
	
	$o:=structure(New object:C1471(\
		"action";"verify";\
		"tables";"UNIT_STRUCTURE"))
	
	ASSERT:C1129($o.success;"verify for a table")
	
	$o:=structure(New object:C1471(\
		"action";"verify";\
		"tables";New collection:C1472("UNIT_STRUCTURE")))
	
	ASSERT:C1129($o.success;"verify for collection of tables")
	
	$o:=structure(New object:C1471(\
		"action";"verifyStamps";\
		"tableName";"UNKNOWN"))
	
	ASSERT:C1129(Not:C34($o.success);"verifyStamps for an unknown table")
	
	DOCUMENT:="DROP TABLE IF EXISTS UNIT_STRUCTURE;"
	
	Begin SQL
		
		EXECUTE IMMEDIATE :DOCUMENT
		
	End SQL
	
	
Else 
	
	// A "If" statement should never omit "Else" 
	
End if 
//_____________________________________________________________

FINALLY