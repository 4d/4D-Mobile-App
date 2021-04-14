//%attributes = {}


Case of 
		
		//______________________________________________________
	: (True:C214)
		
		downloadSDK("aws"; "android")
		
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
		
		var $avd : cs:C1710.avd
		$avd:=cs:C1710.avd.new()
		
		var $c : Collection
		$c:=$avd.availableDevices()
		
		//______________________________________________________
	: (True:C214)
		
		var $emu : cs:C1710.androidEmulator
		$emu:=cs:C1710.androidEmulator.new()
		
		var $listOfEmu : Collection
		$listOfEmu:=$emu.list().emulators
		
		If (Asserted:C1132($listOfEmu.length>0; "No emu"))
			
			var $result : Object
			$result:=$emu.start($listOfEmu[0]; True:C214/*async*/)  // seem to block until close, maybe run start in background or not using option of LAUNCH Exxternal process
			
			var $adb : cs:C1710.adb
			$adb:=cs:C1710.adb.new()
			
			$result:=$adb.kill($listOfEmu[0])  // seems to no work
			$result:=$adb.killServer()  // seems to no work
			
		End if 
		
		//______________________________________________________
	Else 
		
		// A "Case of" statement should never omit "Else"
		
		//______________________________________________________
End case 