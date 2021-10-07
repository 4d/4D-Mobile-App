//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : env_Database_setting
// ID[33966321E2DE470E8A359A94EB152664]
// Created 23-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
#DECLARE($selector : Text)->$response : Object

If (False:C215)
	C_TEXT:C284(env_Database_setting; $1)
	C_OBJECT:C1216(env_Database_setting; $0)
End if 

var $value : Boolean
var $settings : Object

// ----------------------------------------------------
// Initialisations
$response:=New object:C1471(\
"success"; False:C215)

// ----------------------------------------------------
$settings:=cs:C1710.xml.new(_4D Get Database Settings as XML:C1535).toObject()["com.4d"]

If (Count parameters:C259=0)  // Current settings
	
	$response.value:=$settings
	
Else 
	
	Case of 
			
			//______________________________________________________
		: ($selector="web")
			
			$response.value:=$settings.web
			
			//______________________________________________________
		: ($selector="rest")  // Default value is False
			
			If ($settings.web.standalone_server.rest.launch_at_startup#Null:C1517)
				
				$value:=($settings.web.standalone_server.rest.launch_at_startup)
				
			End if 
			
			$response.value:=$value
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unknown entry point: \""+$selector+"\"")
			
			//______________________________________________________
	End case 
End if 