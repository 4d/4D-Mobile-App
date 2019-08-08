//%attributes = {}
  // ----------------------------------------------------
  // Project method : CALL_MAIN_PROCESS
  // ID[79652FE5469142B69148E65B3B12F516]
  // Created 8-8-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Utility method to execute on thread-safe commands
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)
C_TEXT:C284($2)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($signal)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(CALL_MAIN_PROCESS ;$1)
	C_TEXT:C284(CALL_MAIN_PROCESS ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$signal:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($2="listOfLoadedComponents")
		
		ARRAY TEXT:C222($aT;0x0000)
		COMPONENT LIST:C1001($aT)
		
		Use ($signal)
			
			$c:=New shared collection:C1527
			ARRAY TO COLLECTION:C1563($c;$aT)
			$signal.value:=$c
			
		End use 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+String:C10($2)+"\"")
		
		  //______________________________________________________
End case 

$signal.trigger()

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End