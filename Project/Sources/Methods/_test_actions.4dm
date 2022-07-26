//%attributes = {}
//%attributes = {}
var $action; $parameters; $project; $response : Object
var $original : 4D:C1709.File
var $temporary : 4D:C1709.Folder

$temporary:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)

// Recover a project with only one table in the data model & no action
$original:=Folder:C1567(fk database folder:K87:14; *).file("Mobile Projects/actionsOneTable/project.4dmobileapp")

// Mark:-[New action]
// Mark:Without table if only 1 table
$parameters:=New object:C1471(\
"test"; "new"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5))

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	If (False:C215)  // Retrieve the saved project
		
		$project:=JSON Parse:C1218($parameters.project.getText())
		
	Else   // Use the returned project
		
		$project:=$response.project
		
	End if 
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].name="action")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].shortLabel="Action")
			ASSERT:C1129($project.actions[0].label="Action")
			ASSERT:C1129($project.actions[0].tableNumber=Num:C11(OB Keys:C1719($project.dataModel)[0]); "The target table should be self-defined")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].name="newParameter")
						ASSERT:C1129($project.actions[0].parameters[0].label="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].shortLabel="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With table number
$parameters:=New object:C1471(\
"test"; "new"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; 5)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	$project:=$response.project
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].name="action")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].shortLabel="Action")
			ASSERT:C1129($project.actions[0].label="Action")
			ASSERT:C1129($project.actions[0].tableNumber=5; "The target table should be 5")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].name="newParameter")
						ASSERT:C1129($project.actions[0].parameters[0].label="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].shortLabel="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With table name
$parameters:=New object:C1471(\
"test"; "new"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES")

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	If (Asserted:C1132($response.success))
		
		$project:=$response.project
		
		If (Asserted:C1132($project.actions#Null:C1517))
			
			If (Asserted:C1132($project.actions.length=1))
				
				ASSERT:C1129($project.actions[0].name="action")
				ASSERT:C1129($project.actions[0].scope="table")
				ASSERT:C1129($project.actions[0].shortLabel="Action")
				ASSERT:C1129($project.actions[0].label="Action")
				ASSERT:C1129($project.actions[0].tableNumber=5; "The target table should be 5")
				
				If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
					
					If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
						
						If (Asserted:C1132($project.actions[0].parameters.length=1))
							
							ASSERT:C1129($project.actions[0].parameters[0].name="newParameter")
							ASSERT:C1129($project.actions[0].parameters[0].label="New Parameter")
							ASSERT:C1129($project.actions[0].parameters[0].shortLabel="New Parameter")
							ASSERT:C1129($project.actions[0].parameters[0].type="string")
							
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With table object
$parameters:=New object:C1471(\
"test"; "new"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5))

$project:=JSON Parse:C1218($parameters.project.getText())

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	$project:=$response.project
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].name="action")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].shortLabel="Action")
			ASSERT:C1129($project.actions[0].label="Action")
			ASSERT:C1129($project.actions[0].tableNumber=5; "The target table should be 5")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].name="newParameter")
						ASSERT:C1129($project.actions[0].parameters[0].label="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].shortLabel="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With a non existing table
$parameters:=New object:C1471(\
"test"; "new"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "dummy")

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	$project:=$response.project
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].name="action")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].shortLabel="Action")
			ASSERT:C1129($project.actions[0].label="Action")
			ASSERT:C1129($project.actions[0].tableNumber=Null:C1517; "The target table must not be defined")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].name="newParameter")
						ASSERT:C1129($project.actions[0].parameters[0].label="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].shortLabel="New Parameter")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:-[Sort action]
// Mark:With only field if only 1 table
// Fixme:The name is modified by 4D
$parameters:=New object:C1471(\
"test"; "sort"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"field"; "Alpha_Field")

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	$project:=$response.project
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].preset="sort")
			ASSERT:C1129($project.actions[0].name="sortAllTypes")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].label="Sort…")
			ASSERT:C1129($project.actions[0].shortLabel="Sort…")
			ASSERT:C1129($project.actions[0].icon="actions/Sort.svg")
			ASSERT:C1129($project.actions[0].tableNumber=Num:C11(OB Keys:C1719($project.dataModel)[0]); "The target table should be self-defined")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].format="ascending")
						
						// Fixme:The name is modified by 4D
						ASSERT:C1129($project.actions[0].parameters[0].name="Alpha_Field")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With table & field
$parameters:=New object:C1471(\
"test"; "sort"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"field"; 2)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132($response.success))
	
	$project:=$response.project
	
	If (Asserted:C1132($project.actions#Null:C1517))
		
		If (Asserted:C1132($project.actions.length=1))
			
			ASSERT:C1129($project.actions[0].preset="sort")
			ASSERT:C1129($project.actions[0].name="sortAllTypes")
			ASSERT:C1129($project.actions[0].scope="table")
			ASSERT:C1129($project.actions[0].label="Sort…")
			ASSERT:C1129($project.actions[0].shortLabel="Sort…")
			ASSERT:C1129($project.actions[0].icon="actions/Sort.svg")
			ASSERT:C1129($project.actions[0].tableNumber=5; "The target table should be 5")
			
			If (Asserted:C1132($project.actions[0].parameters#Null:C1517))
				
				If (Asserted:C1132(Value type:C1509($project.actions[0].parameters)=Is collection:K8:32))
					
					If (Asserted:C1132($project.actions[0].parameters.length=1))
						
						ASSERT:C1129($project.actions[0].parameters[0].format="ascending")
						
						// Fixme:The name is modified by 4D
						ASSERT:C1129($project.actions[0].parameters[0].name="Alpha_Field")
						ASSERT:C1129($project.actions[0].parameters[0].type="string")
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

// Mark:With non sortable field
$parameters:=New object:C1471(\
"test"; "sort"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"field"; "objectField")

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success)))
	
	ASSERT:C1129($response.error="The field is not sortable")
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

// Mark : With bad field
$parameters:=New object:C1471(\
"test"; "sort"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"field"; "dummy")

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success)))
	
	ASSERT:C1129($response.error="Field not found")
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

// Mark:-[Add an action]
// Mark: delete with well formed action
$action:=New object:C1471(\
"preset"; "delete"; \
"style"; "destructive"; \
"name"; "deleteAllTypes"; \
"scope"; "currentRecord"; \
"label"; "Remove"; \
"shortLabel"; "Remove"; \
"icon"; "actions/Delete.svg"; \
"tableNumber"; 5\
)

$parameters:=New object:C1471(\
"test"; "add"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"action"; $action)

$response:=mobileUnit("actions"; $parameters)

ASSERT:C1129($response.success; "The creation of the action failed")

// Mark: delete with missing name
$action:=New object:C1471(\
"preset"; "delete"; \
"style"; "destructive"; \
"scope"; "currentRecord"; \
"label"; "Remove"; \
"shortLabel"; "Remove"; \
"icon"; "actions/Delete.svg"; \
"tableNumber"; 5\
)

$parameters:=New object:C1471(\
"test"; "add"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"action"; $action)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success); "The creation of the action should have failed"))
	
	ASSERT:C1129($response.errors.indexOf("The required property \"name\" is missing.")#-1)
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

// Mark: delete with missing specific style
$action:=New object:C1471(\
"preset"; "delete"; \
"name"; "deleteAllTypes"; \
"scope"; "currentRecord"; \
"label"; "Remove"; \
"shortLabel"; "Remove"; \
"icon"; "actions/Delete.svg"; \
"tableNumber"; 5\
)

$parameters:=New object:C1471(\
"test"; "add"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"action"; $action)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success); "The creation of the action should have failed"))
	
	ASSERT:C1129($response.errors.indexOf("The required property \"style\" is missing.")#-1)
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

// Mark: sort with empty parameters
$action:=New object:C1471(\
"preset"; "sort"; \
"name"; "sortAllTypes"; \
"scope"; "table"; \
"label"; "Sort"; \
"shortLabel"; "Sort"; \
"parameters"; New collection:C1472\
)

$parameters:=New object:C1471(\
"test"; "add"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"action"; $action)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success); "The creation of the action should have failed"))
	
	ASSERT:C1129($response.errors.indexOf("The array contains less items than specified in the schema.")#-1)
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

// Mark: sort with empty parameters
$action:=New object:C1471(\
"preset"; "sort"; \
"name"; "sortAllTypes"; \
"scope"; "table"; \
"label"; "Sort"; \
"shortLabel"; "Sort"; \
"parameters"; New collection:C1472(New object:C1471)\
)

$parameters:=New object:C1471(\
"test"; "add"; \
"project"; $original.copyTo($temporary; fk overwrite:K87:5); \
"table"; "ALL_TYPES"; \
"action"; $action)

$response:=mobileUnit("actions"; $parameters)

If (Asserted:C1132(Not:C34($response.success); "The creation of the action should have failed"))
	
	//ASSERT($response.errors.indexOf("The array contains less items than specified in the schema.")#-1)
	ASSERT:C1129($response.project.actions=Null:C1517; "The action should not be created")
	
End if 

