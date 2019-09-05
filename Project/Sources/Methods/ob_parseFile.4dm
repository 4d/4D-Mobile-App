//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_parseFile
  // Created 05-8-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Parse a File to an object.
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($1)
C_OBJECT:C1216($0)

C_OBJECT:C1216($Obj_result;$File_path)
C_TEXT:C284($Txt_buffer;$Txt_methodOnErrorCall)
C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_OBJECT:C1216(ob_parseFile ;$0)
	C_OBJECT:C1216(ob_parseFile ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$File_path:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_result:=New object:C1471("success";False:C215)


If (Bool:C1537($File_path.exists))
	
	$Txt_buffer:=$File_path.getText()
	
	Case of 
		: (Length:C16($Txt_buffer)=0)
			
			$Obj_result.errors:=New collection:C1472("File "+String:C10($File_path.path)+" is empty")
			
		Else 
			
			$Txt_methodOnErrorCall:=Method called on error:C704
			
			ob_Lon_Error:=0
			ON ERR CALL:C155("ob_noError")
			
			$Obj_result.value:=JSON Parse:C1218($Txt_buffer)
			
			ON ERR CALL:C155($Txt_methodOnErrorCall)
			
			$Obj_result.success:=$Obj_result.value#Null:C1517
			
			If (Not:C34($Obj_result.success))
				
				$Obj_result.errors:=New collection:C1472(String:C10($File_path.path)+" is not in JSON format. ("+String:C10(ob_Lon_Error)+")")
				
			End if 
			
	End case 
	
Else 
	
	$Obj_result.errors:=New collection:C1472(String:C10($File_path.path)+" is not an existing file")
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End