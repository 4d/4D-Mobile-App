//%attributes = {}
var $i; $l; $Lon_indx; $Lon_tableNumber; $start : Integer
var $o : Object
var $c : Collection

err_TRY

COMPONENT_INIT

$start:=Milliseconds:C459

//_____________________________________________________________
$o:=_o_structure(New object:C1471(\
"action"; "catalog"))

If (Asserted:C1132($o.success))
	
	If (Asserted:C1132($o.value#Null:C1517))
		
		If (Asserted:C1132($o.value.length>0))
			
			$c:=$o.value
			
		End if 
	End if 
End if 

//_____________________________________________________________
$o:=_o_structure(New object:C1471(\
"action"; "catalog"; \
"name"; "HELLO_WORLD"))

If (Asserted:C1132(Not:C34($o.success)))
	
	If (Asserted:C1132($o.errors#Null:C1517))
		
		If (Asserted:C1132($o.errors.length>0))
			
			ASSERT:C1129($o.errors[0]="Table not found: HELLO_WORLD")
			
		End if 
	End if 
End if 

//_____________________________________________________________
$o:=_o_structure(New object:C1471(\
"action"; "catalog"; \
"tableNumber"; 8858))

If (Asserted:C1132(Not:C34($o.success)))
	
	If (Asserted:C1132($o.errors#Null:C1517))
		
		If (Asserted:C1132($o.errors.length>0))
			
			ASSERT:C1129($o.errors[0]="Table not found: #8858")
			
		End if 
	End if 
End if 

//_____________________________________________________________
For ($i; 1; Get last table number:C254; 1)
	
	If (Is table number valid:C999($i))
		
		If (Table name:C256($i)="UNIT_0")
			
			$l:=$i
			$i:=MAXLONG:K35:2-1
			
		End if 
	End if 
End for 

$o:=_o_structure(New object:C1471(\
"action"; "catalog"; \
"name"; "UNIT_0"))

If (Asserted:C1132($o.success))
	
	If (Asserted:C1132($o.value#Null:C1517))
		
		If (Asserted:C1132($o.value.length=1))
			
			ASSERT:C1129($o.value[0].name="UNIT_0")
			ASSERT:C1129($o.value[0].tableNumber=$l)
			ASSERT:C1129($o.value[0].primaryKey="ID")
			
			If (Asserted:C1132($o.value[0].field#Null:C1517))
				
				If (Asserted:C1132($o.value[0].field.length>0))
					
					For ($i; 1; Get last table number:C254; 1)
						
						If (Is table number valid:C999($i))
							
							If (Table name:C256($i)="UNIT_1")
								
								$Lon_tableNumber:=$i
								$i:=MAXLONG:K35:2-1
								
							End if 
						End if 
					End for 
					
					ASSERT:C1129($o.value[0].field.length=10)
					
					$c:=$o.value[0].field.extract("name")
					
					$Lon_indx:=$c.indexOf("ID")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=1)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="ID")
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=4)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=Null:C1517)
						
					End if 
					
					$Lon_indx:=$c.indexOf("Field_2")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=2)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="Field_2")
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=10)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=Null:C1517)
						
					End if 
					
					$Lon_indx:=$c.indexOf("Field_3")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=3)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="Field_3")
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=10)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=Null:C1517)
						
					End if 
					
					$Lon_indx:=$c.indexOf("Field_4")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=4)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="Field_4")
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=10)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=Null:C1517)
						
					End if 
					
					$Lon_indx:=$c.indexOf("Field_5")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=5)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="Field_5")
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=10)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=Null:C1517)
						
					End if 
					
					$Lon_indx:=$c.indexOf("recursive_0")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="recursive_0")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass="UNIT_0")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=$l)
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=-1)
						
					End if 
					
					$Lon_indx:=$c.indexOf("r_1")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="r_1")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass="UNIT_1")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=$Lon_tableNumber)
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=-1)
						
					End if 
					
					$Lon_indx:=$c.indexOf("r_2")
					
					If (Asserted:C1132($Lon_indx#-1))
						
						ASSERT:C1129($o.value[0].field[$Lon_indx].id=Null:C1517)
						ASSERT:C1129($o.value[0].field[$Lon_indx].name="r_2")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedDataClass="UNIT_1")
						ASSERT:C1129($o.value[0].field[$Lon_indx].relatedTableNumber=$Lon_tableNumber)
						ASSERT:C1129($o.value[0].field[$Lon_indx].type=-1)
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 

err_FINALLY

If (Structure file:C489=Structure file:C489(*))
	
	ALERT:C41(String:C10(Milliseconds:C459-$start))
	
End if 