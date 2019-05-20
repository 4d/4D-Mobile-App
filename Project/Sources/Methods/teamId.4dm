//%attributes = {"invisible":true,"preemptive":"capable"}

  // ----------------------------------------------------
  // Project method : teamId
  // Database: 4D Mobile App
  // Created by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Get team ids in macOS
  // ----------------------------------------------------

  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters;$Lon_pos)
C_OBJECT:C1216($Obj_param;$Obj_result;$Obj_buffer)
C_COLLECTION:C1488($Col_buffer)


If (False:C215)
	C_OBJECT:C1216(teamId ;$0)
	C_OBJECT:C1216(teamId ;$1)
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
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"True")
	
	$Obj_result:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------


Case of 
		
		  //______________________________________________________
	: ($Obj_param.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_param.action="list")
		
		
		$Obj_result.value:=New collection:C1472()
		
		If (Bool:C1537($Obj_param.provisioningProfiles))
			
			$Obj_result.provisioningProfiles:=provisioningProfiles (New object:C1471("action";"read"))
			
			If (Bool:C1537($Obj_result.provisioningProfiles.success))
				$Obj_result.provisioningProfiles:=$Obj_result.provisioningProfiles.value
				
				$Col_buffer:=$Obj_result.provisioningProfiles.extract("TeamIdentifier";"id";"TeamName";"name")
				
				  // Remove useless collection in format
				For each ($Obj_buffer;$Col_buffer)
					If (Value type:C1509($Obj_buffer.id)=Is collection:K8:32)
						If ($Obj_buffer.id.count()>0)
							$Obj_buffer.id:=$Obj_buffer.id[0]
						End if 
					End if 
				End for each 
				
				$Obj_result.value.combine($Col_buffer)
				
				$Obj_result.success:=True:C214
			End if 
			
		End if 
		
		If (Bool:C1537($Obj_param.certificate))
			
			$Obj_result.certificates:=certificate (New object:C1471("action";"codesigning";"subject";True:C214))
			
			If (Bool:C1537($Obj_result.certificates.success))
				$Obj_result.certificates:=$Obj_result.certificates.certificates
				
				$Col_buffer:=$Obj_result.certificates.extract("subject").extract("OU";"id";"O";"name")
				  // XXX extract mail from CN? useful if personal team with same name
				$Obj_result.value.combine($Col_buffer)
				$Obj_result.success:=True:C214
			End if 
			
		End if 
		
		  // filter distinct
		$Col_buffer:=$Obj_result.value
		$Obj_result.value:=New collection:C1472()
		
		For each ($Obj_buffer;$Col_buffer)
			
			$Lon_pos:=$Obj_result.value.extract("id").indexOf($Obj_buffer.id)
			If ($Lon_pos=-1)
				$Obj_result.value.push($Obj_buffer)
				  // Else check maybe if current is better than previous (ie have name)
			End if 
			
		End for each 
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_param.action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
If ($Obj_param.caller#Null:C1517)
	
	CALL FORM:C1391($Obj_param.caller;String:C10($Obj_param.callerMethod);String:C10($Obj_param.callerReturn);$Obj_result)
	
Else 
	
	$0:=$Obj_result
	
End if 

  // ----------------------------------------------------
  // End
