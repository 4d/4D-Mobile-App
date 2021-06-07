//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : ob_writeToFile
// Created 13-12-2019 by Eric Marchand
// ----------------------------------------------------
// Description:
// Write an object to a file.
// ----------------------------------------------------
// Declarations

C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)
C_BOOLEAN:C305($3)

C_OBJECT:C1216($Obj_input; $Obj_out; $File_output)
C_TEXT:C284($Txt_buffer; $Txt_methodOnErrorCall)
C_LONGINT:C283($Lon_parameters)
C_BOOLEAN:C305($Boo_prettify)

If (False:C215)
	C_OBJECT:C1216(ob_writeToFile; $0)
	C_OBJECT:C1216(ob_writeToFile; $1)
	C_OBJECT:C1216(ob_writeToFile; $2)
	C_BOOLEAN:C305(ob_writeToFile; $3)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
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
"success"; True:C214)

$Txt_methodOnErrorCall:=Method called on error:C704

If (Structure file:C489=Structure file:C489(*))  // Ne pas masquer en dev
	
	ON ERR CALL:C155("")
	
Else 
	
	ERROR:=0
	ON ERR CALL:C155("noError")  // CLEAN use another handler?
	
End if 

If ($Boo_prettify)
	
	// Pretty mode
	$Txt_buffer:=JSON Stringify:C1217($Obj_input; *)
	
Else 
	
	$Txt_buffer:=JSON Stringify:C1217($Obj_input)
	
End if 

$File_output.setText($Txt_buffer)

ON ERR CALL:C155($Txt_methodOnErrorCall)

If (ERROR#0)
	
	$Obj_out.success:=False:C215
	$Obj_out.errorCode:=ERROR
	ob_error_add($Obj_out; "Failed to write to '"+$Txt_buffer+"'")
	
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End