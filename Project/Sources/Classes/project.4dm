Class constructor
	
	var $1 : Object
	
	This:C1470.datamodel:=$1.dataModel
	This:C1470.actions:=$1.actions
	
	//==============================================================
Function updateActions
	
	var $indx : Integer
	var $table;$parameter : Object
	
	If (This:C1470.actions#Null:C1517)
		
		For each ($table;This:C1470.actions)
			
			If (This:C1470.datamodel[String:C10($table.tableNumber)]#Null:C1517)
				
				If ($table.parameters#Null:C1517)
					
					For each ($parameter;$table.parameters)
						
						If (This:C1470.datamodel[String:C10($table.tableNumber)][String:C10($parameter.fieldNumber)]=Null:C1517)
							
							// THE FIELD DOESN'T EXIST ANYMORE
							$table.parameters.remove($table.parameters.indexOf($parameter))
							
						End if 
					End for each 
				End if 
				
			Else 
				
				// THE TABLE DOESN'T EXIST ANYMORE
				This:C1470.actions.remove($indx)
				
			End if 
			
			$indx:=$indx+1
			
		End for each 
		
		If (This:C1470.actions.length=0)
			
			// NO MORE ACTION
			OB REMOVE:C1226(This:C1470.project;"actions")
			
		End if 
	End if 