//%attributes = {"invisible":true}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($server : Text; $target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)

var $applicationVersion; $url : Text
var $run; $withUI : Boolean
var $buildNumber : Integer
var $o; $manifest : Object
var $file; $fileManifest : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $sdk : 4D:C1709.ZipFile
var $error : cs:C1710.error
var $http : cs:C1710.http
var $progress : cs:C1710.progress

ASSERT:C1129(Count parameters:C259>=2)

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

$withUI:=True:C214

If (Count parameters:C259>=3)
	
	$withUI:=Not:C34($silent)
	
End if 

$run:=True:C214

Case of 
		
		//______________________________________________________
	: ($target="android")
		
		$sdk:=cs:C1710.path.new().cacheSdkAndroid()
		
		//______________________________________________________
	: ($target="ios")
		
		$sdk:=cs:C1710.path.new().cacheSdkApple()
		
		//______________________________________________________
	Else 
		
		$run:=False:C215
		RECORD.error("Uknown SDK target: "+$target)
		
		//______________________________________________________
End case 

$applicationVersion:=Application version:C493($buildNumber; *)

Case of 
		
		//______________________________________________________
	: (Not:C34($run))
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: ($server="aws")
		
		//$buildNumber:=264302  // Force build number for test purpose
		
		$url:="https://resources-download.4d.com/sdk/"\
			+Choose:C955($applicationVersion[[1]]="A"; "main"; Delete string:C232($applicationVersion; 1; 4))+"/"\
			+String:C10($buildNumber)+"/"\
			+$target+"/"+$target+".zip"
		
		//______________________________________________________
	: ($server="TeamCity")
		
		var $preferences : 4D:C1709.File
		$preferences:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")
		
		If ($preferences.exists)
			
			$o:=JSON Parse:C1218($preferences.getText())
			
			If ($o.tc#Null:C1517)
				
				$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/"
				
				Case of 
						
						//______________________________________________________
					: ($target="android")
						
						If ($applicationVersion[[1]]="A")
							
							//http://srv-build:8111/repository/download/id4dmobile_QMobile_Main_Android_Sdk_Build//855236:id/android.zip
							$url:=$url+"id4dmobile_QMobile_Main_Android_Sdk_Build/.lastSuccessful/android.zip"
							
						Else 
							
							$url:=$url+"id4dmobile_QMobile_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								//http://srv-build:8111/repository/download/id4dmobile_QMobile_19x_Android_Sdk_Build/853617:id/android.zip
								$url:=$url+"x_Android_Sdk_Build/.lastSuccessful/android.zip"
								
							Else 
								
								//http://srv-build:8111/repository/download/id4dmobile_QMobile_18r6_IOS_Sdk_Build/838082:id/android.zip
								$url:=$url+"r"+$applicationVersion[[7]]+"_IOS_Sdk_Build/.lastSuccessful/android.zip"
								
							End if 
						End if 
						
						
						//______________________________________________________
					: ($target="ios")
						
						If ($applicationVersion[[1]]="A")
							
							//http://srv-build:8111/repository/download/id4dmobile_4dIOSSdk_Build/855236:id/ios.zip
							$url:=$url+"id4dmobile_4dIOSSdk_Build/.lastSuccessful/ios.zip"
							
						Else 
							
							$url:=$url+"id4dmobile_QMobile_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								//http://srv-build:8111/repository/download/id4dmobile_QMobile_19x_IOS_Sdk_Build/837030:id/ios.zip
								$url:=$url+"x_IOS_Sdk_Build/.lastSuccessful/ios.zip"
								
							Else 
								
								//http://srv-build:8111/repository/download/id4dmobile_QMobile_18r6_IOS_Sdk_Build/838082:id/1.0.zip
								$url:=$url+"r"+$applicationVersion[[7]]+"x_IOS_Sdk_Build/.lastSuccessful/ios.zip"
								
							End if 
						End if 
						
						//______________________________________________________
					Else 
						
						$run:=False:C215
						RECORD.error("Uknown SDK target: "+$target)
						
						//______________________________________________________
				End case 
				
			Else 
				
				$run:=False:C215
				ALERT:C41("You must add \"tc\" key with user:pass in 4d.mobile")
				SHOW ON DISK:C922($preferences.platformPath)
				
			End if 
			
		Else 
			
			$run:=False:C215
			ALERT:C41("You must add \"tc\" key with user:pass in 4d.mobile")
			SHOW ON DISK:C922($preferences.platformPath)
			
		End if 
		
		//______________________________________________________
	Else 
		
		$run:=False:C215
		RECORD.error("Unknown server: "+$server)
		
		//______________________________________________________
End case 

If ($run)
	
	$http:=cs:C1710.http.new($url).setResponseType(Is a document:K24:1; $sdk)
	
	$fileManifest:=$sdk.parent.file("manifest.json")
	
	If ($fileManifest.exists)
		
		$manifest:=JSON Parse:C1218($fileManifest.getText())
		
		$run:=Not:C34(Bool:C1537($manifest.noUpdate))
		
		If ($run)
			
			If ($run)
				
				$run:=Num:C11($manifest.build)<$buildNumber
				
			End if 
			
			$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
			$run:=$run & ($http.status=200)
			
			
			// ============================== //
			//  TEMPORARY FALLBACK TO GITHUB  //
			// ============================== //
			If ($http.status=404) & ($target="android")
				
				$http.setURL("https://github.com/mesopelagique/sdk_docs/releases/download/19.x/android.zip")
				$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
				$run:=$run & ($http.status=200)
				
			End if 
			// ============================== //
			
			If ($run)
				
				If ($server="aws")
					
					// Verify the SDK version
					$o:=$http.responseHeaders.query("name = 'x-amz-meta-version'").pop()
					
					If ($o#Null:C1517)
						
						$file:=cs:C1710.path.new().cacheSdkAndroidUnzipped().file("sdkVersion")
						
						If ($file.exists)
							
							$run:=Split string:C1554($file.getText(); "\r")[0]#$o.value
							
						End if 
					End if 
				End if 
			End if 
			
			If (Count parameters:C259>=5)
				
				$run:=$run | $force
				
			End if 
			
		Else 
			
			$http.status:=8858
			
		End if 
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($run)
			
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
					
					ARRAY LONGINT:C221($pos; 0x0000)
					ARRAY LONGINT:C221($len; 0x0000)
					If (Match regex:C1019("(?mi-s)^(https?://)[^@]*@(.*)$"; $http.url; 1; $pos; $len))
						
						$http.url:=Substring:C12($http.url; $pos{1}; $len{1})+Substring:C12($http.url; $pos{2}; $len{2})
						
					End if 
					
					$manifest:=New object:C1471(\
						"source"; $server; \
						"url"; $http.url; \
						"version"; "unknown"; \
						"build"; 0)
					
					If ($folder.file("sdkVersion").exists)
						
						$manifest.version:=Replace string:C233($folder.file("sdkVersion").getText(); "\r"; "")
						
					End if 
					
					For each ($o; $http.headers)
						
						$manifest[$o.name]:=$o.value
						
						If ($o.name="x-amz-meta-build")
							
							$manifest.build:=Num:C11($o.value)
							
						End if 
					End for each 
					
					$fileManifest.setText(JSON Stringify:C1217($manifest; *))
					
					RECORD.info("Update the 4D Mobile "+$target+" SDK version "+$manifest.version)
					
				Else 
					
					RECORD.warning("Failed to unarchive "+$sdk.path)
					
				End if 
				
			Else 
				
				RECORD.warning($http.url+": "+$http.lastError)
				
			End if 
			
			If ($withUI)
				
				$progress.close()
				
			End if 
			
			//______________________________________________________
		: ($http.status=8858)
			
			RECORD.warning("The update of 4D Mobile "+$target+" SDK is locked")
			
			//______________________________________________________
		: ($http.status=200)
			
			If ($withUI)
				
				If (Count parameters:C259>=4)
					
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
			
			//______________________________________________________
		Else 
			
			RECORD.error($http.url+": "+$http.lastError)
			
			//______________________________________________________
	End case 
End if 