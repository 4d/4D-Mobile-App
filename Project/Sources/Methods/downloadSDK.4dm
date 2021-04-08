//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)

var $applicationVersion : Text
var $run; $withUI : Boolean
var $buildNumber : Integer
var $o; $manifest : Object
var $file; $fileManifest : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $sdk : 4D:C1709.ZipFile
var $error : cs:C1710.error
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

$withUI:=True:C214

If (Count parameters:C259>=2)
	
	$withUI:=Not:C34($silent)
	
End if 

$applicationVersion:=Application version:C493($buildNumber; *)

$http:=cs:C1710.http.new("https://resources-download.4d.com/sdk/"\
+Choose:C955($applicationVersion[[1]]="A"; "main"; Delete string:C232($applicationVersion; 1; 4))+"/"\
+String:C10($buildNumber)+"/"\
+$target+"/"+$target+".zip").setResponseType(Is a document:K24:1; $sdk)

$fileManifest:=$sdk.parent.file("manifest.json")

If ($fileManifest.exists)
	
	$manifest:=JSON Parse:C1218($fileManifest.getText())
	
	$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
	
	If ($run)
		
		// Verify the SDK version
		$o:=$http.headers.query("name = 'x-amz-meta-version'").pop()
		
		If ($o#Null:C1517)
			
			$file:=cs:C1710.path.new().cacheSdkAndroidUnzipped().file("sdkVersion")
			
			If ($file.exists)
				
				$run:=Split string:C1554($file.getText(); "\r")[0]#$o.value
				
			End if 
		End if 
	End if 
	
	If (Count parameters:C259>=4)
		
		$run:=$run | $force
		
	End if 
	
Else 
	
	$run:=True:C214
	
End if 

If ($run)
	
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
		
/* START HIDING ERRORS */
		$error:=cs:C1710.error.new()
		$error.hide()
		
		$folder:=ZIP Read archive:C1637($sdk).root.copyTo($o.parent)
		
/* STOP HIDING ERRORS */
		$error.show()
		
		If ($folder.exists)
			
			$manifest:=New object:C1471
			
			For each ($o; $http.headers)
				
				$manifest[$o.name]:=$o.value
				
			End for each 
			
			$fileManifest.setText(JSON Stringify:C1217($manifest; *))
			
			RECORD.info("Update the 4D Mobile "+$target+" SDK version "+$manifest["x-amz-meta-version"])
			
		Else 
			
			RECORD.warning("Failed to unarchive "+$sdk.path)
			
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