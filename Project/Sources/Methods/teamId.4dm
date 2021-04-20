//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : teamId
// Created by Eric Marchand
// ----------------------------------------------------
// Description:
// Get team ids in macOS
// ----------------------------------------------------
// Declarations
#DECLARE($params : Object)->$response : Object

If (False:C215)
	C_OBJECT:C1216(teamId; $0)
	C_OBJECT:C1216(teamId; $1)
End if 

var $o; $params; $response : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
	
	$response:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($params.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
	: ($params.action="list")
		
		$response.value:=New collection:C1472()
		
		If (Bool:C1537($params.provisioningProfiles))
			
			$response.provisioningProfiles:=provisioningProfiles(New object:C1471(\
				"action"; "read"))
			
			If (Bool:C1537($response.provisioningProfiles.success))
				
				$response.provisioningProfiles:=$response.provisioningProfiles.value
				
				$c:=$response.provisioningProfiles.extract("TeamIdentifier"; "id"; "TeamName"; "name")
				
				// Remove useless collection in format
				For each ($o; $c)
					
					If (Value type:C1509($o.id)=Is collection:K8:32)
						
						If ($o.id.count()>0)
							
							$o.id:=$o.id[0]
							
						End if 
					End if 
				End for each 
				
				$response.value.combine($c)
				
				$response.success:=True:C214
				
			End if 
		End if 
		
		If (Bool:C1537($params.certificate))
			
			$response.certificates:=certificate(New object:C1471(\
				"action"; "codesigning"; \
				"subject"; True:C214))
			
			If (Bool:C1537($response.certificates.success))
				
				$response.certificates:=$response.certificates.certificates
				
				$c:=$response.certificates.extract("subject").extract("OU"; "id"; "O"; "name")
				
				// XXX extract mail from CN? useful if personal team with same name
				$response.value.combine($c)
				$response.success:=True:C214
				
			End if 
		End if 
		
		// Filter distinct
		$c:=$response.value
		
		$response.value:=New collection:C1472()
		
		For each ($o; $c)
			
			If ($response.value.query("id = :1"; $o.id).pop()=Null:C1517)
				
				$response.value.push($o)
				
				// Else check maybe if current is better than previous (ie have name)
				
			End if 
		End for each 
		
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$params.action+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
If ($params.caller#Null:C1517)
	
	CALL FORM:C1391($params.caller; String:C10($params.callerMethod); String:C10($params.callerReturn); $response)
	
End if 
