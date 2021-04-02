//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)

var $url; $version : Text
var $run; $silent; $withUI : Boolean
var $buildNumber : Integer
var $o; $manifest : Object
var $fileManifest : 4D:C1709.File
var $sdk : 4D:C1709.ZipFile
var $http : cs:C1710.http
var $progress : cs:C1710.progress

ASSERT:C1129(Count parameters:C259>=1)

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

Case of 
		
		//______________________________________________________
	: ($target="android")
		
		$sdk:=cs:C1710.path.new().cacheSdkAndroid()
		
		//______________________________________________________
	: ($target="ios")
		
		$sdk:=cs:C1710.path.new().cacheSdkApple()
		
		//______________________________________________________
	Else 
		
		RECORD.error("Uknown SDK target")
		
		//______________________________________________________
End case 

$buildNumber:=Num:C11(JSON Parse:C1218(File:C1566("/RESOURCES/resources.json").getText()).sdk[$target])

$fileManifest:=$sdk.parent.file("manifest.json")

If ($fileManifest.exists)
	
	$manifest:=JSON Parse:C1218($fileManifest.getText())
	$run:=(Num:C11($manifest.buildNumber)<$buildNumber)
	
	If (Count parameters:C259>=4)
		
		$run:=$run | $force
		
	End if 
	
Else 
	
	$run:=True:C214
	
End if 

$withUI:=True:C214

If (Count parameters:C259>=2)
	
	$withUI:=Not:C34($silent)
	
End if 

If ($run)
	
	RECORD.info("Update the 4D Mobile "+$target+" SDK")
	
	$url:="https://preprod-resources-download.4d.com/sdk/"
	
	If (Application version:C493(*)="A@")  //main
		
		$url:=$url+"main/"+String:C10($buildNumber)+"/"+$target+"/"+$target+".zip"
		
	Else 
		
		$url:=$url+applicationVersion+"/"+String:C10($buildNumber)+"/"+$target+"/"+$target+".zip"
		
	End if 
	
	$http:=cs:C1710.http.new($url).setResponseType(Is a document:K24:1; $sdk)
	
	If ($withUI)
		
		$progress:=cs:C1710.progress.new("downloadInProgress")\
			.setMessage(Replace string:C233(Get localized string:C991("downloadingSDK"); "{os}"; Choose:C955($target="android"; "Android"; "iOS"))).bringToFront()
		
	End if 
	
	$http.get()
	
	If ($http.success)
		
		// Delete the old SDK folder, if any
		$o:=$sdk.parent.folder("sdk")
		
		If ($o.exists)
			
			$o.delete(Delete with contents:K24:24)
			
		End if 
		
		// Extract all files
		If ($withUI)
			
			$progress.setMessage("unzipping")
			
		End if 
		
		$o:=ZIP Read archive:C1637($sdk).root.copyTo($o.parent)
		
		If ($o.exists)
			
			$manifest.buildNumber:=$buildNumber
			$fileManifest.setText(JSON Stringify:C1217($manifest; *); Document with LF:K24:22)
			
		Else 
			
			// A "If" statement should never omit "Else" 
			
		End if 
		
	Else 
		
		RECORD.warning($http.url+": "+$http.errors.join("\r"))
		
	End if 
	
	If ($withUI)
		
		$progress.close()
		
	End if 
	
Else 
	
	If ($withUI)
		
		If (Count parameters:C259>=3)
			
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