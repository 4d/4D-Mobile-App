//%attributes = {"invisible":true}
var $t : Text
var $withRelation : Boolean
var $o; $table : Object

If (PROJECT.$android)
	
	If (Value type:C1509($1)=Is object:K8:27)
		
		$table:=PROJECT.dataModel[String:C10($1.tableNumber)]
		
	Else 
		
		$table:=PROJECT.dataModel[String:C10($1)]
		
	End if 
	
	If ($table#Null:C1517)
		
		For each ($o; OB Entries:C1720($table)) Until ($withRelation)
			
			If (Length:C16($o.key)#0)
				
				If (String:C10(Num:C11($o.key))#$o.key)\
					 & (Value type:C1509($o.value)=Is object:K8:27)
					
					$withRelation:=($o.value.relatedEntities#Null:C1517)
					
					If (Not:C34($withRelation))
						
						For each ($o; OB Entries:C1720($o.value)) Until ($withRelation)
							
							If (String:C10(Num:C11($o.key))#$o.key)\
								 & (Value type:C1509($o.value)=Is object:K8:27)
								
								$withRelation:=Bool:C1537($o.value.isToMany)
								
							End if 
						End for each 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	If ($withRelation)
		
		CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "footer"; New object:C1471(\
			"message"; "One to Many relations are coming soon for Android"; \
			"type"; "android"))
		
	Else 
		
		CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "footer"; New object:C1471(\
			"message"; ""))
		
	End if 
End if 