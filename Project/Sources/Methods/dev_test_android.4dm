//%attributes = {}


Case of 
		
		//______________________________________________________
	: (True:C214)
		
		var $studio : cs:C1710.studio
		$studio:=cs:C1710.studio.new()
		$studio.installLatestCommandLineTools()
		$studio.installLatestCommandLineTools(Num:C11(JSON Parse:C1218(File:C1566("/RESOURCES/android.json").getText()).latestCommandLineTools))
		
		//______________________________________________________
	: (True:C214)
		
		var $sdk : cs:C1710.sdkmanager
		$sdk:=cs:C1710.sdkmanager.new()
		
		var $c : Collection
		$c:=$sdk.installedPackages()
		
		//______________________________________________________
	: (True:C214)
		
		var $sdk : cs:C1710.sdkmanager
		$sdk:=cs:C1710.sdkmanager.new()
		
		var $ready : Boolean
		$ready:=$sdk.isReady()
		
		//If (Not($ready))
		
		////$ready:=$sdk.update()
		
		//$sdk.acceptLicences()
		
		
		//$ready:=$sdk.isReady()
		
		//End if
		
		
		//______________________________________________________
	: (True:C214)
		
		//var $emulator : cs.androidEmulator
		//$emulator:=cs.androidEmulator.new()
		
		//var $possibleSimulators : Collection
		//$possibleSimulators:=$emulator.availableSimulators()
		
		var $adb : cs:C1710.adb
		$adb:=cs:C1710.adb.new()
		
		var $plugged : Collection
		$plugged:=$adb.plugged()  // -> Plugged devices
		
		var $serial : Text
		If ($plugged.length>0)
			
			$serial:=$plugged[0].udid
			
			$o:=$adb.getDeviceProperties($serial)
			
			var $packages : Collection
			$packages:=$adb.packageList($serial)
			$packages:=$adb.userPackageList($serial)
			
			If ($packages.indexOf("com.d4pop.quickopen")>=0)
				
				//$adb.waitUninstallApp($serial; "com.d4pop.quickopen")
				$adb.launchApp("com.d4pop.quickopen")
				
				
				
			End if 
			
		End if 
		
		//______________________________________________________
	: (True:C214)
		
		
		
		var $adb : cs:C1710.adb
		$adb:=cs:C1710.adb.new()
		
		$adb.launch($adb.cmd+" --help")
		
		//______________________________________________________
	: (True:C214)
		
		
		var $emulator : cs:C1710.androidEmulator
		$emulator:=cs:C1710.androidEmulator.new()
		
		
		var $possibleSimulators : Collection
		$possibleSimulators:=$emulator.availableSimulators()
		
		var $adb : cs:C1710.adb
		$adb:=cs:C1710.adb.new()
		
		var $availableDevices : Collection
		$availableDevices:=$adb.availableDevices()  // -> Attached devices (plugged devices & booted simulators)
		
		If ($emulator.isBooted("emulator-5554"))
			
			
		Else 
			
			$o:=$emulator.start("emulator-5554"; True:C214)
			
		End if 
		
		
		//______________________________________________________
	: (True:C214)
		
		var $androidProcess : cs:C1710.androidProcess
		$androidProcess:=cs:C1710.androidProcess.new()
		
		var $folder : 4D:C1709.Folder
		$folder:=$androidProcess.androidSDKFolder()
		
		var $adb : cs:C1710.adb
		$adb:=cs:C1710.adb.new()
		
		var $availableDevices : Collection
		$availableDevices:=$adb.availableDevices()  // -> Attached devices (plugged devices & booted simulators)
		
		$availableDevices:=$adb.availableDevices("9")
		$availableDevices:=$adb.availableDevices("11")
		$availableDevices:=$adb.availableDevices("12")
		
		var $plugged : Collection
		$plugged:=$adb.plugged()  // -> Plugged devices
		
		var $serial : Text
		If ($plugged.length>0)
			
			$serial:=$plugged[0].udid
			
		End if 
		
		var $t : Text
		$t:=$adb._packageName("com.myCompany.My-App-4")
		
		
		
		$plugged:=$adb.plugged("10")  // -> Plugged devices
		$plugged:=$adb.plugged("11")  // -> Plugged devices
		
		//== Get device android version
		//adb shell getprop ro.build.version.release
		//$adb.launch($adb.cmd+" -s "+$plugged[0].udid+" shell getprop ro.build.version.release")
		
		$plugged:=$adb.plugged()  // -> Plugged devices
		//$adb.launch($adb.cmd+" -s "+$plugged[0].udid+" shell getprop")
		
		var $o : Object
		$o:=$adb.getDeviceProperties($serial)
		$o:=$adb.getDeviceProperties("emulator-5554")
		
		If ($serial#"")
			
			$adb.installApp("/Users/vdl/Sources_4D/depot/4eDimension/main/4DComponents/Internal User Components/4D Mobile App - Mobile/My App 4/Android/My App 4/app/build/outputs/apk/debug/app-debug.apk"; $serial)
			
			var $packages : Collection
			$packages:=$adb.packageList($serial)
			$packages:=$adb.userPackageList($serial)
			
			If ($adb.isAppInstalled("com.myCompany.My_App_4"; $serial))
				
				//$adb.uninstallApp("com.myCompany.My_App_4"; $serial)
				
			Else 
				// A "If" statement should never omit "Else"
				
				
			End if 
			
		End if 
		
		var $listBootedDevices : Object
		$listBootedDevices:=$adb.listBootedDevices()
		
		
		//______________________________________________________
	: (True:C214)
		
		
		$c:=$adb.availableDevices()
		$c:=$adb.listBootedDevices()
		$c:=$adb.plugged()
		
		//var $avd : cs.avd
		//$avd:=cs.avd.new()
		
		//$c:=$avd._o_devices()
		
		//______________________________________________________
	: (True:C214)
		
		//$sdk:=cs.sdkmanager.new()
		//$cmd:=$sdk.cmd+" --licenses"
		//$options:=New object
		//$options.hideConsole:=True
		//$options.onMessage:="systemWorkerCallBack"
		//$options.onError:="systemWorkerCallBack"
		//$options.onTerminated:="systemWorkerCallBack"
		//$systemWorker:=4D.SystemWorker.new($cmd; $options)
		//$systemWorker.wait()
		//$systemWorker.terminate()
		
		//______________________________________________________
	: (True:C214)
		
		CALL WORKER:C1389(1; Formula:C1597(downloadSDK).source; "aws"; "android")
		
		//______________________________________________________
	: (True:C214)
		
		//cs.studio.new().uninstall()
		
		//______________________________________________________
	: (True:C214)
		
		var $studio : cs:C1710.studio
		$studio:=cs:C1710.studio.new()
		$studio.installLatestCommandLineTools()
		
		//______________________________________________________
	: (True:C214)
		
		var $avd : cs:C1710.avd
		$avd:=cs:C1710.avd.new()
		
		var $c : Collection
		$c:=$avd.availableDevices()
		
		//______________________________________________________
	: (True:C214)
		
		var $emu : cs:C1710.androidEmulator
		$emu:=cs:C1710.androidEmulator.new()
		
		var $listOfEmu : Collection
		//$listOfEmu:=$emu.list().emulators
		
		If (Asserted:C1132($listOfEmu.length>0; "No emu"))
			
			var $result : Object
			$result:=$emu.start($listOfEmu[0]; True:C214/*async*/)  // seem to block until close, maybe run start in background or not using option of LAUNCH Exxternal process
			
			var $adb : cs:C1710.adb
			$adb:=cs:C1710.adb.new()
			
			//$result:=$adb.kill($listOfEmu[0])  // seems to no work
			//$result:=$adb.killServer()  // seems to no work
			
		End if 
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 