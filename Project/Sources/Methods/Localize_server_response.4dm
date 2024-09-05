//%attributes = {"invisible":true}
#DECLARE($in)->$message : Text

If (False:C215)
	C_VARIANT:C1683(Localize_server_response; $1)
	C_TEXT:C284(Localize_server_response; $0)
End if 

If (Value type:C1509($in)=Is text:K8:3)
	
	// The returned messages are not localized…
	// …so we do it
	
	$message:=$in
	
Else 
	
	Case of 
			
			//……………………………………………………………………………
		: ($in=30)
			
			$message:=Get localized string:C991("theWebServerIsNotReachable")
			
			//……………………………………………………………………………
		: ($in=401)
			
			$message:=Get localized string:C991("unauthorizedAccess")
			
			//……………………………………………………………………………
		: ($in=403)
			
			$message:=Get localized string:C991("unauthorizedAccess")
			
			//……………………………………………………………………………
		: ($in=404)
			
			$message:=Get localized string:C991("serverNotFound")
			
			//……………………………………………………………………………
		: ($in=503)
			
			$message:=Get localized string:C991("serviceUnavailable")
			
			//……………………………………………………………………………
		Else 
			
			$message:=Get localized string:C991("error:")+String:C10($in)
			Logger.info("unlocalized http error code: "+String:C10($in))
			
			//……………………………………………………………………………
	End case 
End if 

Case of 
		
		//______________________________________________________
	: ($message="The request is mal formed")
		
		$message:=Get localized string:C991("theRequestIsMalformed")
		
		//______________________________________________________
	: ($message="The database method has failed")
		
		$message:=Get localized string:C991("theDatabaseMethodHasFailed")
		
		//______________________________________________________
	: ($message="The database method took too long to execute")
		
		$message:=Get localized string:C991("theDatabaseMethodTookTooLongToExecute")
		
		//______________________________________________________
	: ($message="The database method is not defined")
		
		$message:=Get localized string:C991("theDatabaseMethodIsNotDefined")
		
		//______________________________________________________
	: ($message="The request is unauthorized")\
		 | ($message="This request is forbidden")
		
		$message:=Get localized string:C991("unauthorizedAccess")+\
			"\r"+Get localized string:C991("makeSureThatTheKeyProvidedIsTheKeyOfTheServer")
		
		//______________________________________________________
	: ($message="Max number of sessions reached")
		
		$message:=Get localized string:C991("maxNumberOfSessionsReached")
		
		//______________________________________________________
	: ($message="Unable to generate authorization key")
		
		$message:=Get localized string:C991("failedToGenerateAuthorizationKey")
		
		//______________________________________________________
	Else 
		
		Logger.info("unlocalized http error message: "+$message)
		
		//______________________________________________________
End case 