//%attributes = {"invisible":true,"preemptive":"capable"}
// -> silent  =   No interface for progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($server : Text; $target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)

If (False:C215)
	C_TEXT:C284(downloadSDK; $1)
	C_TEXT:C284(downloadSDK; $2)
	C_BOOLEAN:C305(downloadSDK; $3)
	C_LONGINT:C283(downloadSDK; $4)
	C_BOOLEAN:C305(downloadSDK; $5)
End if 

var $applicationVersion; $url : Text
var $run; $withUI : Boolean
var $buildNumber : Integer
var $manifest; $o : Object
var $fileManifest; $preferences : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $sdk : 4D:C1709.ZipFile
var $error : cs:C1710.error
var $http : cs:C1710.http
var $progress : cs:C1710.progress

ASSERT:C1129(Count parameters:C259>=2)

DATABASE:=DATABASE || cs:C1710.database.new()

Logger:=Logger || cs:C1710.logger.new()
Logger.verbose:=DATABASE.isMatrix

Logger.info("Verify "+$target+" SDK, Server: "+$server)

$withUI:=True:C214

If (Count parameters:C259>=3)
	
	$withUI:=Not:C34($silent)
	
End if 

$applicationVersion:=Application version:C493($buildNumber; *)
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
		Logger.error("Uknown SDK target: "+$target)
		
		//______________________________________________________
End case 

Case of 
		
		//______________________________________________________
	: (Not:C34($run))
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: ($server="aws")
		
		$url:="https://resources-download.4d.com/sdk/{version}/{build}/{target}/{target}.zip"
		
		If ($applicationVersion[[1]]="A")
			
			$url:=Replace string:C233($url; "{version}"; "main")
			
		Else 
			
			If (Num:C11($applicationVersion[[7]])=0)
				
				// LTS
				$url:=Replace string:C233($url; "{version}"; $applicationVersion[[5]]+$applicationVersion[[6]]+".x")
				
			Else 
				
				// Release
				$url:=Replace string:C233($url; "{version}"; $applicationVersion[[5]]+$applicationVersion[[6]]+"R"+$applicationVersion[[7]])
				
			End if 
		End if 
		
		$url:=Replace string:C233($url; "{build}"; String:C10($buildNumber))
		$url:=Replace string:C233($url; "{target}"; $target)
		
		//______________________________________________________
	: ($server="TeamCity")
		
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
						Logger.error("Uknown SDK target: "+$target)
						
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
		Logger.error("Unknown server: "+$server)
		
		//______________________________________________________
End case 

If ($run)
	
	$http:=cs:C1710.http.new($url).setResponseType(Is a document:K24:1; $sdk)
	
	$fileManifest:=$sdk.parent.file("manifest.json")
	
	If ($fileManifest.exists)
		
		$manifest:=JSON Parse:C1218($fileManifest.getText())
		
		$run:=Not:C34(Bool:C1537($manifest.noUpdate))  // Possibility to block the automatic update for the dev
		
		If ($run)
			
			$run:=Num:C11($manifest.build)<$buildNumber  // Not for the same build
			
		Else 
			
			$http.status:=8858
			
		End if 
		
		If ($run)
			
			$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
			$run:=$run & ($http.status=200)
			
			// ============================== //
			//  TEMPORARY FALLBACK TO GITHUB  //
			// ============================== //
			If ($http.status=404)\
				 & ($server="aws")\
				 & ($target="android")\
				 & (Application version:C493[[3]]="0")\
				 & (Process number:C372("unit_BATCH_EXECUTE")=0)
				
				$http.setURL("https://github.com/4d-go-mobile/sdk/releases/download/19.x/android.zip")
				$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
				$run:=$run & ($http.status=200)
				
				If ($run)
					
					$server:="github"
					
				End if 
			End if 
			// ============================== //
			
			
			If ($run)
				
				If ($server="aws")
					
					// Verify the SDK version
					$o:=$http.responseHeaders.query("name = 'x-amz-meta-version'").pop()
					
					If ($o#Null:C1517)
						
						$run:=($o.value#$manifest.version)
						
					End if 
				End if 
			End if 
			
			If (Count parameters:C259>=5)
				
				$run:=$run | $force
				
			End if 
		End if 
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($run)
			
			Logger.info("Downloading: "+$url)
			
			If ($withUI)
				
				$progress:=cs:C1710.progress.new("downloadInProgress")\
					.setMessage(Replace string:C233(Get localized string:C991("downloadingSDK"); "{os}"; Choose:C955($target="android"; "Android"; "iOS")))  //.bringToFront()
				
			End if 
			
			$http.get()
			
			// ============================== //
			//  TEMPORARY FALLBACK TO GITHUB  //
			// ============================== //
			If ($http.status=404)\
				 & ($server="aws")\
				 & ($target="android")\
				 & (Application version:C493[[3]]="0")\
				 & (Process number:C372("unit_BATCH_EXECUTE")=0)
				
				$http.setURL("https://github.com/mesopelagique/sdk_docs/releases/download/19.x/android.zip")
				$run:=$http.newerRelease(String:C10($manifest.ETag); String:C10($manifest["Last-Modified"]))
				$run:=$run & ($http.status=200)
				
				If ($run)
					
					$server:="github"
					$http.get()
					
				End if 
			End if 
			// ============================== //
			
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
				
				Logger.info("Unzipping: "+$sdk.path)
				
/* START HIDING ERRORS */
				$error:=cs:C1710.error.new("hide")
				
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
					
					Logger.info("The 4D Mobile "+$target+" SDK was updated to version "+$manifest.version)
					
					//$sdk.delete()
					
					If (Count parameters:C259>=4)
						
						CALL FORM:C1391($caller; "editor_CALLBACK"; "updateRibbon")
						
					End if 
					
				Else 
					
					Logger.warning("Failed to unarchive "+$sdk.path)
					
				End if 
				
			Else 
				
				Logger.warning($http.url+": "+$http.lastError)
				
			End if 
			
			If ($withUI)
				
				$progress.close()
				
			End if 
			
			//______________________________________________________
		: ($http.status=8858)
			
			Logger.warning("The update of 4D Mobile "+$target+" SDK is locked")
			
			//______________________________________________________
		: ($http.status=200)
			
			// Force manifest modification date to avoid a new execution today
			$fileManifest.setText($fileManifest.getText())
			
			Logger.info("The 4D Mobile "+$target+" SDK is up to date")
			
			//______________________________________________________
		Else 
			
			Logger.error($http.url+": "+$http.lastError)
			
			//______________________________________________________
	End case 
End if 