//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)

var $url : Text
var $run; $silent; $withUI : Boolean
var $o : Object
var $manifest; $preferences : 4D:C1709.File
var $sdk : 4D:C1709.ZipFile
var $http : cs:C1710.http
var $progress : cs:C1710.progress

Case of 
		//______________________________________________________
	: (Is macOS:C1572)
		
		RECORD:=logger("~/Library/Logs/"+Folder:C1567(fk database folder:K87:14).name+".log")
		
		//______________________________________________________
	: (Is Windows:C1573)
		
		RECORD:=logger(Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(fk database folder:K87:14; *).name).file(Folder:C1567(fk database folder:K87:14).name+".log"))
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

RECORD.verbose:=DATABASE.isMatrix

$preferences:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")

If ($preferences.exists)
	
	$o:=JSON Parse:C1218($preferences.getText())
	
	If ($o.tc#Null:C1517)
		
		Case of 
				
				//______________________________________________________
			: ($target="android")
				
				$sdk:=cs:C1710.path.new().cacheSdkAndroid()
				$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/id4dmobile_QMobile_Main_Android_Sdk_Build/.lastSuccessful/android.zip"
				
				//______________________________________________________
			: ($target="ios")
				
				$sdk:=cs:C1710.path.new().cacheSdkApple()
				$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/id4dmobile_QMobile_Main_iOS_Sdk_Build/.lastSuccessful/iOS.zip"
				
				//______________________________________________________
			Else 
				
				RECORD.error("Uknown SDK target")
				
				//______________________________________________________
		End case 
		
		$http:=cs:C1710.http.new($url).setResponseType(Is a document:K24:1; $sdk)
		
		$manifest:=$sdk.parent.file("manifest.json")
		
		If ($manifest.exists)
			
			$http.head()
			
			If ($http.success)
				
				$o:=JSON Parse:C1218($manifest.getText())
				$run:=$http.newerRelease(String:C10($o.etag); String:C10($o.lastModification))
				
			Else 
				
				RECORD.warning($http.errors.join("\r"))
				
			End if 
			
			If (Count parameters:C259>=3)
				
				$run:=$run | $force
				
			End if 
			
		Else 
			
			$run:=True:C214
			
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
	
	RECORD.info("Update the 4D Mobile "+$target+" SDK")
	
	If ($withUI)
		
		$progress:=cs:C1710.progress.new("downloadInProgress")\
			.setMessage(Replace string:C233(Get localized string:C991("downloadingSDK"); "{os}"; Choose:C955($target="android"; "Android"; "iOS"))).bringToFront()
		
	End if 
	
	$http.get()
	
	If ($http.success)
		
		$o:=New object:C1471
		$o.etag:=String:C10($http.headers.query("name = 'ETag'").pop().value)
		$o.lastModification:=String:C10($http.headers.query("name = 'Last-Modified'").pop().value)
		$manifest.setText(JSON Stringify:C1217($o; *))
		
		// Delete the old SDK folder if any
		$o:=$sdk.parent.folder("sdk")
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
		
		// Extract all files
		If ($withUI)
			
			$progress.setMessage("unzipping")
			
		End if 
		
		$o:=ZIP Read archive:C1637($sdk).root.copyTo($o.parent)
		
	Else 
		
		RECORD.error($http.errors.join("\r"))
		
	End if 
	
	If ($withUI)
		
		$progress.close()
		
	End if 
	
Else 
	
	If ($withUI)
		
		If (Count parameters:C259>=2)
			
			POST_MESSAGE(New object:C1471(\
				"action"; "show"; \
				"target"; $caller; \
				"type"; "alert"; \
				"additional"; Replace string:C233(Get localized string:C991("yourVersionOf4dMobileSdkUpToDate"); "{os}"; Choose:C955($target="android"; "Android"; "iOS"))))
			
		Else 
			
			ALERT:C41(Replace string:C233(Get localized string:C991("yourVersionOf4dMobileSdkUpToDate"); "{os}"; Choose:C955($target="android"; "Android"; "iOS")))
			
		End if 
	End if 
	
	RECORD.info("The 4D Mobile "+$target+" SDK is up to date")
	
End if 