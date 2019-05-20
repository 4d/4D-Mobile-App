//%attributes = {"invisible":true}
/*
result := ***unzip*** ( param )
 -> param (Object)
 <- result (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : unzip
  // Database: 4D Mobile Express
  // ID[2C5BC49577384A6CB5E3A0123C950044]
  // Created #28-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($Obj_param;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(unzip ;$0)
	C_OBJECT:C1216(unzip ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_param:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_param.file#Null:C1517;"Missing tag file"))
	
	If (Asserted:C1132(Test path name:C476($Obj_param.file)=Is a document:K24:1;"file not found"))
		
		$Txt_cmd:="unzip -o "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_param.file))
		
		Case of 
				
				  //________________________________________
			: ($Obj_param.target#Null:C1517)
				
				CREATE FOLDER:C475($Obj_param.target;*)
				
				If (String:C10($Obj_param.cache)#"")
					
					If (Test path name:C476($Obj_param.cache)#Is a folder:K24:2)
						
						  // Create the cache
						$Obj_result.success:=unzip (New object:C1471("file";$Obj_param.file;"target";$Obj_param.cache)).success  //<====== RECURSIVE
						
					Else 
						
						$Obj_result.success:=True:C214  // do cp
						
					End if 
					
					If ($Obj_result.success)
						
						$Obj_result.success:=False:C215  // reset status
						$Txt_cmd:="cp -Rf "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_param.cache))+" "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_param.target))
						
					End if 
					
				Else 
					
					$Txt_cmd:=$Txt_cmd+" -d "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_param.target))
					
				End if 
				
				  //________________________________________
			: ($Obj_param.members#Null:C1517)
				
				$Txt_cmd:="unzip -p "+str_singleQuoted (Convert path system to POSIX:C1106($Obj_param.file))
				$Txt_cmd:=$Txt_cmd+" "+String:C10($Obj_param.members)
				
				  //________________________________________
		End case 
		
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			$Obj_result.out:=$Txt_out
			
			If (Length:C16($Txt_error)=0)
				
				$Obj_result.success:=True:C214
				
			Else 
				
				$Obj_result.error:=$Txt_error
				
			End if 
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End