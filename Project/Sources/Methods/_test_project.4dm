//%attributes = {}
var $field : cs:C1710.field
var $o : cs:C1710.ob
var $project : cs:C1710.project
var $table : cs:C1710.table

COMPONENT_INIT

ON ERR CALL:C155("")

$project:=cs:C1710.project.new(JSON Parse:C1218(cs:C1710.path.new().projects().file("New project/project.4dmobileapp").getText()))

If ($project.dataModel#Null:C1517)
	
	ASSERT:C1129($project.table(8858)=Null:C1517)
	ASSERT:C1129($project.table("dummy")=Null:C1517)
	ASSERT:C1129($project.table("8858")=Null:C1517)
	
	$table:=$project.table(5)  // From table ID
	
	$o:=cs:C1710.ob.new($table)
	ASSERT:C1129($o.isEqual($project.table("5")))  // From key
	ASSERT:C1129($o.isEqual($project.table($table[""].name)))  // From name
	ASSERT:C1129($o.isEqual($project.table($table)))  // From object
	
	$table:=$project.table("ALL_TYPES")
	
	If (Asserted:C1132($table#Null:C1517))
		
		ASSERT:C1129($project.field($table; "computedInteger")#Null:C1517)
		ASSERT:C1129($project.field($table; "5")#Null:C1517)
		ASSERT:C1129($project.field($table; 5)#Null:C1517)
		
		ASSERT:C1129($project.field($table; "dummy")=Null:C1517)
		ASSERT:C1129($project.field($table; 8858)=Null:C1517)
		ASSERT:C1129($project.field($table; "8858")=Null:C1517)
		
		$field:=$project.field($table; 4)  // From field ID
		
		$o:=cs:C1710.ob.new($field)
		ASSERT:C1129($o.isEqual($project.field($table; "4")))  // From key
		ASSERT:C1129($o.isEqual($project.field($table; $field.name)))  // From name
		ASSERT:C1129($o.isEqual($project.field($table; $field)))  // From object
		
	End if 
	
Else 
	
	// A "If" statement should never omit "Else" 
	
End if 
