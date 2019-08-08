//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_writeDocument
  // Database: 4D Mobile App
  // Created 15-1-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Write an object to a document.
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($3)

C_OBJECT:C1216($Obj_input;$Obj_out)
C_TEXT:C284($File_output;$Txt_buffer;$Txt_methodOnErrorCall)
C_LONGINT:C283($Lon_parameters)
C_BOOLEAN:C305($Boo_prettify)

If (False:C215)
	C_OBJECT:C1216(ob_writeToDocument ;$0)
	C_OBJECT:C1216(ob_writeToDocument ;$1)
	C_TEXT:C284(ob_writeToDocument ;$2)
	C_BOOLEAN:C305(ob_writeToDocument ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_input:=$1
	$File_output:=$2
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Boo_prettify:=$3
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_out:=New object:C1471(\
"success";True:C214)

$Txt_methodOnErrorCall:=Method called on error:C704
ob_Lon_Error:=0
ON ERR CALL:C155("ob_noError")  // CLEAN use another handler?

If ($Boo_prettify)
	
	  // Pretty mode
	$Txt_buffer:=JSON Stringify:C1217($Obj_input;*)
	
Else 
	
	$Txt_buffer:=JSON Stringify:C1217($Obj_input)
	
End if 

TEXT TO DOCUMENT:C1237($File_output;$Txt_buffer)

ON ERR CALL:C155($Txt_methodOnErrorCall)

If (ob_Lon_Error#0)
	
	$Obj_out.success:=False:C215
	$Obj_out.errorCode:=ob_Lon_Error
	ob_error_add ($Obj_out;"Failed to write to '"+$Txt_buffer+"'")
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End