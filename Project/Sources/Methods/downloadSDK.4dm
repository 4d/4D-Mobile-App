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
var $request : 4D:C1709.HTTPRequest
var $sdk : 4D:C1709.ZipFile
var $callback : cs:C1710._downloadSDK

ASSERT:C1129(Count parameters:C259>=2)

Component:=Component || cs:C1710.component.new()

Logger:=Logger || cs:C1710.logger.new()
Logger.verbose:=Component.isMatrix

Logger.info("Verify "+$target+" SDK, Server: "+$server)

$withUI:=True:C214 & Not:C34($silent)

$applicationVersion:=Application version:C493($buildNumber; *)

Case of 
		
		//______________________________________________________
	: ($target="android")
		
		$sdk:=cs:C1710.path.new().cacheSdkAndroid()
		$run:=True:C214
		
		//______________________________________________________
	: ($target="ios")
		
		$sdk:=cs:C1710.path.new().cacheSdkApple()
		$run:=True:C214
		
		//______________________________________________________
	Else 
		
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
							
							$url:=$url+"id4dmobile_QMobile_Main_Android_Sdk_Build/.lastSuccessful/android.zip"
							
						Else 
							
							$url:=$url+"id4dmobile_QMobile_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								$url:=$url+"x_Android_Sdk_Build/.lastSuccessful/android.zip"
								
							Else 
								
								$url:=$url+"r"+$applicationVersion[[7]]+"_IOS_Sdk_Build/.lastSuccessful/android.zip"
								
							End if 
						End if 
						
						//______________________________________________________
					: ($target="ios")
						
						If ($applicationVersion[[1]]="A")
							
							$url:=$url+"id4dmobile_4dIOSSdk_Build/.lastSuccessful/ios.zip"
							
						Else 
							
							$url:=$url+"id4dmobile_QMobile_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								$url:=$url+"x_IOS_Sdk_Build/.lastSuccessful/ios.zip"
								
							Else 
								
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
		
		Logger.error("Unknown server: "+$server)
		$run:=False:C215
		
		//______________________________________________________
End case 

If ($run)
	
	$request:=4D:C1709.HTTPRequest.new($url; New object:C1471("method"; "HEAD")).wait(10)
	
	If (Num:C11($request.response.status)=200)
		
		$run:=True:C214
		
		$fileManifest:=$sdk.parent.file("manifest.json")
		
		If ($fileManifest.exists)
			
			$manifest:=JSON Parse:C1218($fileManifest.getText())
			
			$run:=Not:C34(Bool:C1537($manifest.noUpdate))  // Possibility to block the automatic update for the dev
			
			If ($run)
				
				$run:=Num:C11($manifest.build)<$buildNumber  // Not for the same build
				
			Else 
				
				Logger.warning("The update of 4D Mobile "+$target+" SDK is locked")
				
			End if 
			
			If ($run)
				
				$run:=(String:C10($manifest.ETag)#String:C10($request.response.headers.ETag))  // True if newer version
				
			End if 
		End if 
		
		If ($run | $force)
			
			Logger.info("Downloading: "+$url)
			
			$callback:=cs:C1710._downloadSDK.new("GET"; \
				Num:C11($request.response.headers["Content-Length"]); \
				$sdk; \
				$fileManifest; \
				$withUI ? Replace string:C233(Get localized string:C991("downloadingSDK"); "{os}"; Choose:C955($target="android"; "Android"; "iOS")) : ""; \
				New object:C1471("window"; $caller; "method"; "editor_CALLBACK"; "message"; "updateRibbon"))
			
			$request:=4D:C1709.HTTPRequest.new($url; $callback)
			
		End if 
		
	Else 
		
		// ERROR
		Logger.error($request.URL+" "+$request.method+": "+$request.errors.extract("message").join("\r"))
		
	End if 
End if 