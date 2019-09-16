//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : Check_entry
  // ID[EF03B91FABE9498C8BCC73345EE2A978]
  // Created 10-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_pattern)
C_OBJECT:C1216($Obj_param;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(_o_Check_entry ;$0)
	C_OBJECT:C1216(_o_Check_entry ;$1)
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
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Obj_param.type="https")
		
		$Txt_pattern:="(?m-si)https://"
		
		$Obj_result.success:=Match regex:C1019($Txt_pattern;$Obj_param.value;1)
		
		  //______________________________________________________
	: ($Obj_param.type="url")
		
		$Txt_pattern:="(?m-si)^(?:(?:https?)://)?(?:localhost|127.0.0.1|(?:\\S+(?::\\S*)?@)?(?:(?!10(?:\\.\\d{1,3}){3})(?!127(?:\\.\\d{1,3}){3}"+\
			")(?!169\\.254(?:\\.\\d{1,3}){2})(?!192\\.168(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9"+\
			"]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|"+\
			"(?:(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1}-\\x{ffff}0-9]+)(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}0-9]+-?)*[a-z\\x{00a1"+\
			"}-\\x{ffff}0-9]+)*(?:\\.(?:[a-z\\x{00a1}-\\x{ffff}]{2,}))))(?::\\d{2,5})?(?:/[^\\s]*)?$"
		
		$Obj_result.success:=Match regex:C1019($Txt_pattern;$Obj_param.value;1)
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End