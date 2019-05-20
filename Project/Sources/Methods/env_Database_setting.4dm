//%attributes = {"invisible":true}
/*
out := ***env_Database_setting*** ( selector )
 -> selector (Text)
 <- out (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : env_Database_setting
  // Database: 4D Mobile Express
  // ID[33966321E2DE470E8A359A94EB152664]
  // Created #23-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dom_root;$Txt_buffer;$Txt_selector)
C_OBJECT:C1216($Obj_out;$Obj_settings)

If (False:C215)
	C_OBJECT:C1216(env_Database_setting ;$0)
	C_TEXT:C284(env_Database_setting ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_selector:=$1
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_buffer:=_4D Get Database Settings as XML:C1535

$Dom_root:=DOM Parse XML variable:C720($Txt_buffer)

If (OK=1)
	
	CLEAR VARIABLE:C89($Txt_buffer)
	
	$Obj_out.success:=True:C214
	
	$Obj_settings:=xml_elementToObject ($Dom_root)["com.4d"]
	
	DOM CLOSE XML:C722($Dom_root)
	
	Case of 
			
			  //______________________________________________________
		: (Length:C16($Txt_selector)=0)  // Current settings
			
			$Obj_out.value:=$Obj_settings
			
			  //______________________________________________________
		: ($Txt_selector="web")
			
			$Obj_out.value:=$Obj_settings.web
			
			  //______________________________________________________
		: ($Txt_selector="rest")  // Default value is False
			
			If ($Obj_settings.web.standalone_server.rest.launch_at_startup#Null:C1517)
				
				$Boo_OK:=($Obj_settings.web.standalone_server.rest.launch_at_startup)
				
			End if 
			
			$Obj_out.value:=$Boo_OK
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_selector+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End