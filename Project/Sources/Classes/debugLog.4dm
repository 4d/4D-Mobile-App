/**
* Create a new debug log helper
*
* @param parameters: object with key "recording"
*/

Class constructor
	C_OBJECT:C1216($1)
	This:C1470.parameters:=$1
	This:C1470.restoreParameters:=New object:C1471
	
	If (This:C1470.parameters#Null:C1517)
		
		If (Num:C11(This:C1470.parameters.recording)=0)
			
			This:C1470.parameters.recording:=8+2  // Arbitrary default value
			
		End if 
	End if 
	
Function start
	
	If (This:C1470.parameters#Null:C1517)
		
		This:C1470._createRestore(This:C1470.parameters)
		This:C1470._set(This:C1470.parameters)
		
	End if 
	
Function stop
	This:C1470._set(This:C1470.restoreParameters)
	
Function _createRestore
	C_OBJECT:C1216($1)
	
	If (Num:C11($1.recording)>0)
		
		This:C1470.restoreParameters.recording:=Get database parameter:C643(Current process debug log recording:K37:97)
		
	End if 
	
	If (Num:C11($1.currentProcess)>0)
		
		This:C1470.restoreParameters.currentProcess:=Get database parameter:C643(Current process debug log recording:K37:97)
		
	End if 
	
Function _set
	C_OBJECT:C1216($1)
	ASSERT:C1129($1#Null:C1517)
	
	If ($1.recording#Null:C1517)
		
		SET DATABASE PARAMETER:C642(Debug log recording:K37:34; This:C1470.parameters.recording)
		
	End if 
	
	If ($1.currentProcess#Null:C1517)
		
		SET DATABASE PARAMETER:C642(Current process debug log recording:K37:97; This:C1470.parameters.currentProcess)
		
	End if 