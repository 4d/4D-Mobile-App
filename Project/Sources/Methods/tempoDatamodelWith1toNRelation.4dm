//%attributes = {"invisible":true}
var $t : Text
var $b : Boolean
var $o; $table : Object
var $c : Collection

If (Value type:C1509($1)=Is object:K8:27)
	
	$table:=PROJECT.dataModel[String:C10($1.tableNumber)]
	
Else 
	
	$table:=PROJECT.dataModel[String:C10($1)]
	
End if 

If ($table#Null:C1517)
	
	$c:=OB Entries:C1720($table)
	
	For each ($o; $c) Until ($b)
		
		If (Length:C16($o.key)#0)
			
			If (String:C10(Num:C11($o.key))=$o.key)
				
				// Field
				
			Else 
				
				$b:=($o.value.relatedEntities#Null:C1517)
				
			End if 
		End if 
	End for each 
End if 

If ($b)
	
	CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "footer"; New object:C1471(\
		"message"; "One to Many relations are coming soon for Android"; \
		"type"; "highlight"))
	
Else 
	
	CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "footer"; New object:C1471(\
		"message"; ""; \
		"type"; "highlight"))
	
End if 