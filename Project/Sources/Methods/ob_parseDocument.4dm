//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_parseDocument
  // Created 15-7-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Parse a document to an object.
  // ----------------------------------------------------
  // Declarations

C_TEXT:C284($1)
C_OBJECT:C1216($0)

C_OBJECT:C1216($Obj_result)
C_TEXT:C284($Txt_path;$Txt_buffer;$Txt_methodOnErrorCall)
C_LONGINT:C283($Lon_parameters)

If (False:C215)
	C_OBJECT:C1216(ob_parseDocument ;$0)
	C_TEXT:C284(ob_parseDocument ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_path:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_result:=New object:C1471("success";False:C215)


If (Test path name:C476($Txt_path)=Is a document:K24:1)
	
	$Txt_buffer:=Document to text:C1236($Txt_path)
	
	Case of 
		: (Length:C16($Txt_buffer)=0)
			
			$Obj_result.errors:=New collection:C1472("File "+$Txt_path+" is empty")
			
			  //: (Not(Match regex("(?m-si)^\\{.*\\}$";$Txt_buffer;1))) // XXX need to trim line ending and space before using
			
			  //$Obj_result.errors:=New collection("File "+$Txt_path+" is not in JSON format")
			
		Else 
			
			$Txt_methodOnErrorCall:=Method called on error:C704
			
			ob_Lon_Error:=0
			ON ERR CALL:C155("ob_noError")
			
			$Obj_result.value:=JSON Parse:C1218($Txt_buffer)
			
			ON ERR CALL:C155($Txt_methodOnErrorCall)
			
			$Obj_result.success:=$Obj_result.value#Null:C1517
			
			If (Not:C34($Obj_result.success))
				
				$Obj_result.errors:=New collection:C1472($Txt_path+" is not in JSON format. ("+String:C10(ob_Lon_Error)+")")
				
			End if 
			
	End case 
	
Else 
	
	$Obj_result.errors:=New collection:C1472($Txt_path+" is not a document")
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End