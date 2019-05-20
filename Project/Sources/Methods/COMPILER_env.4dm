//%attributes = {"invisible":true}
If (False:C215)  //#THREAD-SAFE
	
	  //______________________________________________________
	C_OBJECT:C1216(env_Database_setting ;$0)
	C_TEXT:C284(env_Database_setting ;$1)
	
	  //______________________________________________________
	C_OBJECT:C1216(env_userPathname ;$0)
	C_TEXT:C284(env_userPathname ;$1)
	
	  //______________________________________________________
End if 

If (False:C215)  //#NOT THREAD-SAFE
	
	  //______________________________________________________
	C_BOOLEAN:C305(env_Component_availabe ;$0)
	C_TEXT:C284(env_Component_availabe ;$1)
	
	  //______________________________________________________
End if 