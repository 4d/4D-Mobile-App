//%attributes = {"invisible":true,"preemptive":"capable"}
// -> server  =   server used to download such as aws, github
// -> target  =   mobile OS: ios or android
// -> silent  =   No interface for progression
// -> caller  =   caller thread number to notify progression
// -> force   =   Force the download even if the file is up to date (see verification code)
#DECLARE($server : Text; $target : Text; $silent : Boolean; $caller : Integer; $force : Boolean)->$request : 4D:C1709.HTTPRequest

If (False:C215)
	C_TEXT:C284(downloadSDK; $1)
	C_TEXT:C284(downloadSDK; $2)
	C_BOOLEAN:C305(downloadSDK; $3)
	C_LONGINT:C283(downloadSDK; $4)
	C_BOOLEAN:C305(downloadSDK; $5)
End if 

var $applicationVersion; $url; $version : Text
var $run; $withUI : Boolean
var $buildNumber : Integer
var $manifest; $o; $param : Object
var $fileManifest; $preferences : 4D:C1709.File
var $sdk : 4D:C1709.ZipFile

ASSERT:C1129(Count parameters:C259>=2)

Component:=Component || cs:C1710.component.new()

Logger:=Logger || cs:C1710.logger.new()
Logger.verbose:=Component.isMatrix

Logger.info("Verify "+$target+" SDK, Server: "+$server)

$withUI:=True:C214 & Not:C34($silent)

$applicationVersion:=Application version:C493($buildNumber; *)

Case of 
		
		//______________________________________________________
	: ($buildNumber=0)
		
		Logger.alert("It is not possible to download the SDK "+$target+" without build number.")
		
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

var $pref : Object
$preferences:=Folder:C1567(fk user preferences folder:K87:10).file("4d.mobile")
If ($preferences.exists)
	$pref:=JSON Parse:C1218($preferences.getText())
Else 
	$pref:=New object:C1471
End if 

If ($pref.sdk.server#Null:C1517)  // allow to force type of download
	$server:=String:C10($pref.sdk.server)
End if 

Case of 
		
		//______________________________________________________
	: (Not:C34($run))
		
		// <NOTHING MORE TO DO>
		
		//______________________________________________________
	: (($server="aws") || ($server="") || ($server="github"))
		
		$version:=/*Main*/($applicationVersion[[1]]="A") ? "main"\
			 : /*LTS*/((Num:C11($applicationVersion[[7]])=0) ? $applicationVersion[[5]]+$applicationVersion[[6]]+".x"\
			 : /*Release*/$applicationVersion[[5]]+$applicationVersion[[6]]+"R"+$applicationVersion[[7]])
		
		Case of 
				//___ github release
			: ($server="github")
				
				If ($version="main")
					$url:="https://github.com/4d/{target}-sdk/releases/latest/download/{target}.zip"  // maybe find some link to pre-release instead?
				Else 
					$url:="https://github.com/4d/{target}-sdk/releases/download/v{version}/{target}.zip"  // use vXXX for tag to not be in conflict with branches
				End if 
				If (Length:C16(String:C10($pref.githubToken))>0)  // to support if private
					$url:=Replace string:C233($url; "https://"; "https://"+String:C10($pref.githubToken)+"@")
				End if 
				
				$target:=Lowercase:C14($target)  // to be sure (sometimes github is casesensitive)
				
				//___ custom ones
			: ($pref.sdk.url#Null:C1517)
				
				$url:=$pref.sdk.url
				
				//___ aws
			Else 
				$url:="https://resources-download.4d.com/sdk/{version}/{build}/{target}/{target}.zip"
		End case 
		
		$url:=Replace string:C233($url; "{version}"; $version)
		$url:=Replace string:C233($url; "{build}"; String:C10($buildNumber))
		$url:=Replace string:C233($url; "{target}"; $target)
		
		//______________________________________________________
	: ($server="TeamCity")
		
		If ($preferences.exists)
			
			$o:=$pref
			
			If ($o.tc#Null:C1517)
				
				$url:="http://"+String:C10($o.tc)+"@srv-build:8111/repository/download/"
				
				Case of 
						
						//______________________________________________________
					: ($target="android")
						
						If ($applicationVersion[[1]]="A")
							
							$url:=$url+"Build4D_Main_Mobile_Android_Sdk_Build/.lastSuccessful/android.zip"
							
						Else 
							
							$url:=$url+"Build4D_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								$url:=$url+"x_NightlyGit_Mobile_Android_Sdk_Build/.lastSuccessful/android.zip"
								
							Else 
								
								$url:=$url+"r"+$applicationVersion[[7]]+"_NightlyGit_Mobile_Android_Sdk_Build/.lastSuccessful/android.zip"
								
							End if 
						End if 
						
						//______________________________________________________
					: ($target="ios")
						
						If ($applicationVersion[[1]]="A")
							
							$url:=$url+"Build4D_Main_Mobile_IOS_Sdk_Build/.lastSuccessful/ios.zip"
							
						Else 
							
							$url:=$url+"Build4D_"+$applicationVersion[[5]]+$applicationVersion[[6]]
							
							If ($applicationVersion[[7]]="0")
								
								$url:=$url+"x_NightlyGit_Mobile_IOS_Sdk_Build/.lastSuccessful/ios.zip"
								
							Else 
								
								$url:=$url+"r"+$applicationVersion[[7]]+"_NightlyGit_Mobile_IOS_Sdk_Build/.lastSuccessful/ios.zip"
								
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
		
		Logger.error("Unknown server  "+$server+" type to download sdk. You could add new code or just set server to empty string, and specify and url")
		$run:=False:C215
		
		//______________________________________________________
End case 

If ($run | $force)
	
	$request:=4D:C1709.HTTPRequest.new($url; New object:C1471("method"; "HEAD"))
	
	$fileManifest:=$sdk.parent.file("manifest.json")
	
	If ($fileManifest.exists)
		
		$manifest:=JSON Parse:C1218($fileManifest.getText())
		
		$run:=Not:C34(Bool:C1537($manifest.noUpdate))  // Possibility to block the automatic update for the dev
		
		If ($run)
			
			$run:=Num:C11($manifest.build)<$buildNumber  // Not for the same build
			
		Else 
			
			Logger.warning("The update of 4D Mobile "+$target+" SDK is locked")
			
		End if 
	End if 
	
	If ($run | $force)
		
		While (Not:C34($request.terminated))
			
			IDLE:C311
			
		End while 
		
		// MARK:ACI0103670
		$run:=($manifest=Null:C1517) || (String:C10($manifest.ETag || $manifest.etag)#String:C10($request.response.headers.etag))  // True if newer version
		
		If ($run | $force)
			
			Logger.info("Downloading: "+$url)
			
			$param:=New object:C1471(\
				"what"; "SDK"; \
				"sdk"; $sdk; \
				"manifest"; $fileManifest)
			
			If ($withUI)
				
				$param.title:=Replace string:C233(Get localized string:C991("downloadingSDK"); "{os}"; $target="android" ? "Android" : "iOS")
				$param.caller:=New object:C1471("window"; $caller; "method"; "editor_CALLBACK"; "message"; "updateRibbon")
				
			End if 
			
			$request:=4D:C1709.HTTPRequest.new($url; cs:C1710._download.new($param))
			
		End if 
	End if 
End if 