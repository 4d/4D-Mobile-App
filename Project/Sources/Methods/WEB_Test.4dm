//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : WEB_Test
  // Database: 4D Mobile Express
  // ID[ED45AF251317479D9DF28306A8B8FE95]
  // Created #17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_buffer;$Txt_OnErrorMethod)
C_OBJECT:C1216($Obj_in;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(WEB_Test ;$0)
	C_OBJECT:C1216(WEB_Test ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_in:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	ASSERT:C1129($Obj_in#Null:C1517)
	ASSERT:C1129($Obj_in.url#Null:C1517)
	
	$Obj_result:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_OnErrorMethod:=Method called on error:C704

ON ERR CALL:C155("noError")

$Obj_result.status:=HTTP Get:C1157($Obj_in.url+"/4DWEBTEST";$Txt_buffer)

ON ERR CALL:C155($Txt_OnErrorMethod)

$Obj_result.success:=($Obj_result.status=200)

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End