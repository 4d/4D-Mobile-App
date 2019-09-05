//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : git
  // Created 28-6-2017 by Eric Marchand
  // ----------------------------------------------------
  // Description:

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
C_OBJECT:C1216($Obj_param;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(git ;$0)
	C_OBJECT:C1216(git ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_param:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"True")
	
	$Obj_result:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 


Case of 
	: ($Obj_param.action=Null:C1517)
		
		TRACE:C157
		
	: ($Obj_param.action="create")
		
		If ($Obj_param.force=Null:C1517)
			$Obj_param.force:=False:C215
		End if 
		
		$Obj_param.action:="status"
		$Obj_result:=git ($Obj_param)
		If (Not:C34($Obj_result.success) | $Obj_param.force)
			$Obj_param.action:="init"
			$Obj_result:=git ($Obj_param)
			$Obj_param.action:="add -A"
			$Obj_result:=git ($Obj_param)
			
			If ($Obj_param.comment=Null:C1517)
				$Obj_param.comment:="initial"
			End if 
			
			$Obj_param.action:="commit -m "+$Obj_param.comment
			$Obj_result:=git ($Obj_param)
		Else 
			  // already exist
			$Obj_result.success:=False:C215
			$Obj_result.errors:=New collection:C1472("Already exist")
		End if 
	Else 
		
		
		If (($Obj_param.path=Null:C1517) & ($Obj_param.posix=Null:C1517))
			
			$Obj_result.errors:=New collection:C1472("path or posix must be specified")
			
		Else 
			
			If ($Obj_param.posix=Null:C1517)
				$Obj_param.posix:=Convert path system to POSIX:C1106($Obj_param.path)
			End if 
			
			$Txt_cmd:="git -C "+str_singleQuoted ($Obj_param.posix)+" "+$Obj_param.action
			
		End if 
		
		
		If (Length:C16($Txt_cmd)>0)
			
			LAUNCH EXTERNAL PROCESS:C811($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)
			
			If (Asserted:C1132(OK=1;"LEP failed: "+$Txt_cmd))
				
				If (Length:C16($Txt_error)=0)
					
					$Obj_result.success:=True:C214
					$Obj_result.value:=$Txt_out
					
				Else 
					
					$Obj_result.error:=$Txt_error
					
				End if 
			End if 
		End if 
		
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End