//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($silent : Boolean; $force : Boolean)

var $run; $withUI : Boolean
var $o; $progress : Object
var $url : Text
var $sdk : 4D:C1709.ZipFile
var $preferences : 4D:C1709.File
var $http : cs:C1710.http

$sdk:=cs:C1710.path.new().cacheSdkAndroid()

If ($sdk.exists)
	
	// Verify…
	// (not downloaded today for the momemnt)
	$run:=($sdk.modificationDate<Current date:C33)
	
	If (Count parameters:C259>=2)
		
		$run:=$run | $force
		
	End if 
	
Else 
	
	$run:=True:C214
	
End if 

If ($run)
	
	$withUI:=True:C214
	
	If (Count parameters:C259>=1)
		
		$withUI:=Not:C34($silent)
		
	End if 
	
	$preferences:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")
	
	If ($preferences.exists)
		
		$o:=JSON Parse:C1218($preferences.getText())
		
		If ($o.tc#Null:C1517)
			
			If ($withUI)
				
				$progress:=progress("downloadInProgress").setMessage("downloadingAndroidSdk").bringToFront()
				
			End if 
			
			$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/id4dmobile_QMobile_Main_Android_Sdk_Build/.lastSuccessful/dependencies.zip"
			
			$http:=cs:C1710.http.new($url)
			$http.setResponseType(Is a document:K24:1; $sdk)
			
			$http.get()
			
			If ($withUI)
				
				$progress.close()
				
			End if 
			
			If (DATABASE.isMatrix)
				
				ASSERT:C1129($http.success)
				
			End if 
			
		Else 
			
			ALERT:C41("You must add tc with user:pass in 4d.mobile")
			SHOW ON DISK:C922($preferences.platformPath)
			
		End if 
		
	Else 
		
		ALERT:C41("You must add tc with user:pass in 4d.mobile")
		SHOW ON DISK:C922($preferences.platformPath)
		
	End if 
End if 