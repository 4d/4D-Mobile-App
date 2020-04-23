//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : certificate
  // Created by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Get information about installed certificate in macOS
  //
  // certificate (New object("action";"codesigning";"subject";True))
  //   - get info about signing identity ie. dev that sign app
  // ----------------------------------------------------

  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters;$Lon_x;$Lon_y)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out;$Txt_buffer)
C_OBJECT:C1216($Obj_param;$Obj_result;$Obj_buffer)


If (False:C215)
	C_OBJECT:C1216(certificate ;$0)
	C_OBJECT:C1216(certificate ;$1)
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
	: ($Obj_param.action="codesigning")
		
		$Txt_cmd:="/usr/bin/security find-identity -v -p codesigning"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Obj_result.success:=True:C214
				$Obj_result.certificates:=New collection:C1472()
				
				$Lon_x:=Position:C15("\n";$Txt_out)
				
				While ($Lon_x#0)
					
					$Txt_buffer:=Substring:C12($Txt_out;1;$Lon_x-1)
					
					$Lon_y:=Position:C15(") ";$Txt_buffer)
					If ($Lon_y>0)
						$Txt_buffer:=Substring:C12($Txt_buffer;$Lon_y+2)
						$Lon_y:=Position:C15(" ";$Txt_buffer)
						
						$Obj_buffer:=New object:C1471
						$Obj_buffer.id:=Substring:C12($Txt_buffer;1;$Lon_y)
						$Obj_buffer.name:=Substring:C12($Txt_buffer;$Lon_y+2;Length:C16($Txt_buffer)-$Lon_y-2)
						If (Position:C15("CSSMERR_TP_CERT_REVOKED";$Obj_buffer.name)=0)  // ignore revoked XXX maybe ignore all errors
							$Obj_result.certificates.push($Obj_buffer)
							
							Case of 
								: (Bool:C1537($Obj_param.subject))
									$Obj_buffer.pem:=certificate (New object:C1471("action";"pem";"name";$Obj_buffer.name)).value
									$Obj_buffer.subject:=certificate (New object:C1471("action";"subject";"pem";$Obj_buffer.pem)).value
									
								: (Bool:C1537($Obj_param.pem))
									$Obj_buffer.pem:=certificate (New object:C1471("action";"pem";"name";$Obj_buffer.name)).value
									
							End case 
							
						End if 
					End if 
					$Txt_out:=Substring:C12($Txt_out;$Lon_x+1)
					$Lon_x:=Position:C15("\n";$Txt_out)
					
				End while 
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="pem")
		
		$Txt_cmd:="security find-certificate -c \""+String:C10($Obj_param.name)+"\" -p"
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Obj_result.success:=True:C214
				$Obj_result.value:=$Txt_out
				
			End if 
			
		End if 
		
		  //______________________________________________________
	: ($Obj_param.action="subject")
		
		
		$Txt_cmd:="openssl x509 -subject -noout"
		$Txt_in:=String:C10($Obj_param.pem)
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
		
		If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
			
			If (Length:C16($Txt_out)>0)
				
				$Obj_result.success:=True:C214
				
				$Obj_result.value:=New object:C1471
				$Lon_x:=Position:C15("/";$Txt_out)
				
				While ($Lon_x#0)
					$Txt_buffer:=Substring:C12($Txt_out;1;$Lon_x-1)
					
					$Lon_y:=Position:C15("=";$Txt_buffer)
					If ($Lon_y>0)
						$Obj_buffer:=New object:C1471
						$Obj_result.value[Substring:C12($Txt_buffer;1;$Lon_y-1)]:=Substring:C12($Txt_buffer;$Lon_y+1)
					End if 
					
					$Txt_out:=Substring:C12($Txt_out;$Lon_x+1)
					$Lon_x:=Position:C15("/";$Txt_out)
					
				End while 
				
			End if 
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_param.action+"\"")
		
		  //______________________________________________________
End case 

$0:=$Obj_result
