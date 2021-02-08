//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($silent : Boolean; $force : Boolean)

var $url : Text
var $run; $silent; $withUI : Boolean
var $o; $progress : Object
var $manifest; $preferences : 4D:C1709.File
var $sdk : 4D:C1709.ZipFile
var $http : cs:C1710.http

$sdk:=cs:C1710.path.new().cacheSdkAndroid()

$manifest:=$sdk.parent.file("manifest.json")

$preferences:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")

If ($preferences.exists)
	
	$o:=JSON Parse:C1218($preferences.getText())
	
	If ($o.tc#Null:C1517)
		
		$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/id4dmobile_QMobile_Main_Android_Sdk_Build/.lastSuccessful/dependencies.zip"
		
		$http:=cs:C1710.http.new($url).setResponseType(Is a document:K24:1; $sdk)
		
		If ($manifest.exists)
			
			$http.head()
			
			If ($http.success)
				
				// The ETag HTTP response header is an identifier for a specific version of a
				// Resource. It lets caches be more efficient and save bandwidth, as a web server
				// Does not need to resend a full response if the content has not changed.
				
				$run:=(Replace string:C233(String:C10($http.headers.query("name = 'ETag'").pop().value); "\""; "")#String:C10(JSON Parse:C1218($manifest.getText()).etag))
				
			End if 
			
		Else 
			
			$run:=True:C214
			
		End if 
		
		If (Count parameters:C259>=2)
			
			$run:=$run | $force
			
		End if 
		
	Else 
		
		ALERT:C41("You must add tc with user:pass in 4d.mobile")
		SHOW ON DISK:C922($preferences.platformPath)
		
	End if 
	
Else 
	
	ALERT:C41("You must add tc with user:pass in 4d.mobile")
	SHOW ON DISK:C922($preferences.platformPath)
	
End if 

$withUI:=True:C214

If (Count parameters:C259>=1)
	
	$withUI:=Not:C34($silent)
	
End if 

If ($run)
	
	If ($withUI)
		
		$progress:=progress("downloadInProgress").setMessage("downloadingAndroidSdk").bringToFront()
		
	End if 
	
	$http.get()
	
	If ($http.success)
		
		$o:=New object:C1471
		$o.etag:=Replace string:C233(String:C10($http.headers.query("name = 'ETag'").pop().value); "\""; "")
		$o.lastModification:=String:C10($http.headers.query("name = 'Last-Modified'").pop().value)
		$manifest.setText(JSON Stringify:C1217($o; *))
		
	Else 
		
		// A "If" statement should never omit "Else"
		
	End if 
	
	If ($withUI)
		
		$progress.close()
		
	End if 
	
	If (DATABASE.isMatrix)
		
		ASSERT:C1129($http.success)
		
	End if 
	
Else 
	
	If ($withUI)
		
		ALERT:C41(".Your SDK version is currently the newest version available.")
		
	End if 
End if 