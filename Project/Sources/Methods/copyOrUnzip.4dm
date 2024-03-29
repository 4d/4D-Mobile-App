//%attributes = {"invisible":true}
#DECLARE($Obj_param : Object)->$Obj_result : Object
// ----------------------------------------------------
// Project method : unzip
// ID[2C5BC49577384A6CB5E3A0123C950044]
// Created 28-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations

C_TEXT:C284($Txt_cmd; $Txt_error; $Txt_in; $Txt_out)

If (False:C215)
	C_OBJECT:C1216(copyOrUnzip; $0)
	C_OBJECT:C1216(copyOrUnzip; $1)
End if 

// ----------------------------------------------------
// Initialisations

If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$Obj_result:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Asserted:C1132($Obj_param.file#Null:C1517; "Missing tag file"))
	
	If (Asserted:C1132(Test path name:C476($Obj_param.file)=Is a document:K24:1; "file not found"))
		
		$Txt_cmd:="unzip -o "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.file))
		
		Case of 
				
				//________________________________________
			: ($Obj_param.target#Null:C1517)
				
				CREATE FOLDER:C475($Obj_param.target; *)
				
				If (String:C10($Obj_param.cache)#"")
					
					If (Test path name:C476($Obj_param.cache)#Is a folder:K24:2)
						
						// Create the cache
						$Obj_result.success:=copyOrUnzip(New object:C1471("file"; $Obj_param.file; "target"; $Obj_param.cache)).success  //<====== RECURSIVE
						
					Else 
						
						$Obj_result.success:=True:C214  // do cp
						
					End if 
					
					If ($Obj_result.success)
						
						$Obj_result.success:=False:C215  // reset status
						$Txt_cmd:="cp -Rf "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.cache))+" "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.target))
						
					End if 
					
				Else 
					
					$Txt_cmd:=$Txt_cmd+" -d "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.target))
					
				End if 
				
				//________________________________________
			: ($Obj_param.members#Null:C1517)
				
				$Txt_cmd:="unzip -p "+str_singleQuoted(Convert path system to POSIX:C1106($Obj_param.file))
				$Txt_cmd:=$Txt_cmd+" "+String:C10($Obj_param.members)
				
				//________________________________________
		End case 
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			$Obj_result.out:=$Txt_out
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_result.success:=True:C214
				
			Else 
				
				$Obj_result.error:=$Txt_error
				
			End if 
		End if 
	End if 
End if 