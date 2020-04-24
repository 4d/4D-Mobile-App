//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : capabilities
  // Created 2019 by Eric Marchand
  // ----------------------------------------------------
  // Description: Edit projects files to add capabilities
  // - iOS Xcode project : entitlements or Info.plist
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_in;$Obj_out;$Obj_capability;$Obj_buffer;$Obj_params;$Obj_types)
C_TEXT:C284($File_entitlements;$File_info;$Txt_fileType)
C_OBJECT:C1216($Col_fileTypes)

If (False:C215)
	C_OBJECT:C1216(capabilities ;$0)
	C_OBJECT:C1216(capabilities ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

If ($Obj_in.tags=Null:C1517)
	
	$Obj_in.tags:=New object:C1471
	
End if 

$Obj_types:=New object:C1471(\
"info";String:C10($Obj_in.target)+"Xcode"+Folder separator:K24:12+"Info.plist";\
"settings";String:C10($Obj_in.target)+"Settings"+Folder separator:K24:12+"Settings.plist";\
"entitlements";String:C10($Obj_in.target)+String:C10($Obj_in.tags.product)+".entitlements")


Case of 
		
		  //______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
	: ($Obj_in.action="inject")  // inject in projects files
		
		If ($Obj_in.capabilities=Null:C1517)
			
			If (Value type:C1509($Obj_in.value)=Is object:K8:27)  // we want to inject from this object
				
				$Obj_in.capabilities:=capabilities (New object:C1471("action";"find";"value";$Obj_in.value)).capabilities
				
			End if 
		End if 
		
		  // Transform to native capabilities
		$Obj_params:=New object:C1471(\
			)
		
		Case of 
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.capabilities)=Is object:K8:27)
				
				$Obj_params:=capabilities (New object:C1471(\
					"action";"natify";\
					"value";$Obj_in.capabilities))
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.capabilities)=Is collection:K8:32)
				
				For each ($Txt_fileType;$Obj_types)
					
					$Obj_params[$Txt_fileType]:=New collection:C1472()
					
				End for each 
				
				For each ($Obj_capability;$Obj_in.capabilities)
					
					$Obj_buffer:=capabilities (New object:C1471(\
						"action";"natify";\
						"value";$Obj_capability))
					
					  // merge (XXX maybe ob_deepMerge)
					For each ($Txt_fileType;$Obj_types)
						
						$Obj_params[$Txt_fileType]:=$Obj_params[$Txt_fileType].combine($Obj_buffer[$Txt_fileType])
						
					End for each 
				End for each 
				
				  // ----------------------------------------
			Else   // nothing?
				
				  // ----------------------------------------
		End case 
		
		  // Finnaly write
		$Obj_params.action:="write"
		$Obj_params.target:=$Obj_in.target
		$Obj_params.tags:=$Obj_in.tags
		
		$Obj_out:=capabilities ($Obj_params)
		
		  //______________________________________________________
	: ($Obj_in.action="find")  // from project 4d file, return the list of capabilities
		
		$Obj_out:=ob_findProperty ($Obj_in.value;"capabilities")
		$Obj_out.capabilities:=$Obj_out.value
		  //______________________________________________________
	: ($Obj_in.action="mergeObjects")  // from project 4d file, return the list of capabilities
		
		If (Value type:C1509($Obj_in.value)=Is collection:K8:32)
			
			$Obj_out.value:=$Obj_in.value.reduce("col_formula";New object:C1471(\
				);"$1.accumulator:=ob_deepMerge ($1.accumulator;"+\
				"$1.value)")
			$Obj_out.success:=True:C214
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="read")  // read files from project target
		
		Case of 
				
				  // ----------------------------------------
			: ($Obj_types[String:C10($Obj_in.type)]#Null:C1517)  // want only a specific types
				
				$Obj_out[$Obj_in.type]:=plist (New object:C1471(\
					"action";"object";\
					"path";$Obj_types[$Obj_in.type]))
				
				ob_error_combine ($Obj_out;$Obj_out[$Obj_in.type])
				$Obj_out[$Obj_in.type]:=$Obj_out[$Obj_in.type].value
				
				$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))
				
				  // ----------------------------------------
			Else   // read all
				
				For each ($Txt_fileType;$Obj_types)
					
					$Obj_out[$Txt_fileType]:=plist (New object:C1471(\
						"action";"object";\
						"path";$Obj_types[$Txt_fileType]))
					ob_error_combine ($Obj_out;$Obj_out[$Txt_fileType])
					$Obj_out[$Txt_fileType]:=$Obj_out[$Txt_fileType].value
					
				End for each 
				
				$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))
				
				  // ----------------------------------------
		End case 
		
		  //______________________________________________________
	: ($Obj_in.action="write")
		
		$Obj_out:=capabilities (New object:C1471(\
			"action";"read";\
			"target";$Obj_in.target;\
			"tags";$Obj_in.tags;\
			"info";$Obj_in.info#Null:C1517;\
			"settings";$Obj_in.settings#Null:C1517;\
			"entitlements";$Obj_in.entitlements#Null:C1517))
		
		If ($Obj_out.success)
			
			For each ($Txt_fileType;$Obj_types)
				
				  // Merge if parameters is collection
				If (Value type:C1509($Obj_in[$Txt_fileType])=Is collection:K8:32)
					
					$Obj_in[$Txt_fileType]:=capabilities (New object:C1471("action";"mergeObjects";"value";$Obj_in[$Txt_fileType])).value
					
				End if 
				
				  // merge read and new one
				If (Value type:C1509($Obj_in[$Txt_fileType])=Is object:K8:27)
					
					If (Not:C34(OB Is empty:C1297($Obj_in[$Txt_fileType])))
						
						$Obj_out[$Txt_fileType]:=ob_deepMerge ($Obj_out[$Txt_fileType];$Obj_in[$Txt_fileType])
						
					Else 
						
						  // Do nothing
						$Obj_out[$Txt_fileType]:=Null:C1517
						
					End if 
				End if 
				
				  // write into file
				If ($Obj_out[$Txt_fileType]#Null:C1517)
					
					$Obj_out[$Txt_fileType]:=plist (New object:C1471(\
						"action";"fromObject";\
						"format";"xml";\
						"object";$Obj_out[$Txt_fileType];\
						"path";$Obj_types[$Txt_fileType]))
					$Obj_out[$Txt_fileType].value:=$Obj_in[$Txt_fileType]
					
				End if 
			End for each 
			
			  // Else failed to read files
			
		End if 
		
		  //______________________________________________________
	: ($Obj_in.action="natify")  // transform simple key to real key
		
		  // If (iOS)
		  // Init result
		For each ($Txt_fileType;$Obj_types)
			
			$Obj_out[$Txt_fileType]:=New collection:C1472()
			
		End for each 
		
		If (Value type:C1509($Obj_in.value)=Is object:K8:27)
			
			$Obj_in:=$Obj_in.value  // get value has input
			
		End if 
		
		  // Check if there is already native ones defined, just copy it
		Case of 
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.info)=Is collection:K8:32)
				
				$Obj_out.info.combine($Obj_in.info)
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.info)=Is object:K8:27)
				
				$Obj_out.info.push($Obj_in.info)
				
				  // ----------------------------------------
		End case 
		
		Case of 
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.entitlements)=Is collection:K8:32)
				
				$Obj_out.entitlements.combine($Obj_in.entitlements)
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.entitlements)=Is object:K8:27)
				
				$Obj_out.entitlements.push($Obj_in.entitlements)
				
				  // ----------------------------------------
		End case 
		
		Case of 
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.settings)=Is collection:K8:32)
				
				$Obj_out.settings.combine($Obj_in.settings)
				
				  // ----------------------------------------
			: (Value type:C1509($Obj_in.settings)=Is object:K8:27)
				
				$Obj_out.settings.push($Obj_in.settings)
				
				  // ----------------------------------------
		End case 
		
		  // Manage simple properties
		If (Bool:C1537($Obj_in.home) | Bool:C1537($Obj_in.homekit))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.homekit";True:C214))
			
		End if 
		
		If (Bool:C1537($Obj_in.siri) | Bool:C1537($Obj_in.assistant))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.siri";True:C214))
			
		End if 
		
		If (Bool:C1537($Obj_in.wifiInfo))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.networking.wifi-info";True:C214))
			
		End if 
		
		If (Bool:C1537($Obj_in.dataProtection))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.default-data-protection";"NSFileProtectionComplete"))
			
		End if 
		
		If (Bool:C1537($Obj_in.pushNotification))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"aps-environment";"development"))  // production?
			
			$Obj_out.settings.push(New object:C1471(\
				"pushNotification";True:C214))
			
		End if 
		
		If (Bool:C1537($Obj_in.classKit))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.ClassKit-environment";"development"))  // production?
			
		End if 
		
		If (Bool:C1537($Obj_in.health) | Bool:C1537($Obj_in.healthkit))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.healthkit";True:C214))
			
			If (Bool:C1537($Obj_in.healthRecords))
				
				$Obj_out.entitlements.push(New object:C1471(\
					"com.apple.developer.healthkit.access";New collection:C1472("health-records")))
				
			Else 
				
				$Obj_out.entitlements.push(New object:C1471(\
					"com.apple.developer.healthkit.access";New collection:C1472()))
				
			End if 
		End if 
		
		If (Bool:C1537($Obj_in.signInWithOS))
			
			$Obj_out.entitlements.push(New object:C1471(\
				"com.apple.developer.applesignin";New collection:C1472("Default")))
			
		End if 
		
		
		If (Bool:C1537($Obj_in.map))
			
			$Obj_out.info.push(New object:C1471(\
				"CFBundleDocumentTypes";New collection:C1472(New object:C1471(\
				"CFBundleTypeName";"MKDirectionsRequest";\
				"LSItemContentTypes";New collection:C1472("com.apple.maps.directionsrequest")))))
			
			If (Value type:C1509($Obj_in.mapModes)=Is collection:K8:32)
				
				$Obj_out.info.push(New object:C1471(\
					"MKDirectionsApplicationSupportedModes";$Obj_in.mapModes))
				
				  //collection(\
					"MKDirectionsModeBike";\
					"MKDirectionsModeBus";\
					"MKDirectionsModeCar";\
					"MKDirectionsModeFerry";\
					"MKDirectionsModeOther";\
					"MKDirectionsModePedestrian";\
					"MKDirectionsModePlane";\
					"MKDirectionsModeRideShare";\
					"MKDirectionsModeStreetCar";\
					"MKDirectionsModeSubway";\
					"MKDirectionsModeTaxi";\
					"MKDirectionsModeTrain"\
					)
				
			End if 
		End if 
		
		If (Bool:C1537($Obj_in.location)\
			 | (Length:C16(String:C10($Obj_in.location))>0))
			
			If (Bool:C1537($Obj_in.location))
				
				$Obj_in.location:="$(PRODUCT_NAME) needs access to the GPS coordinates for your location."
				
			End if 
			
			$Obj_out.info.push(New object:C1471(\
				"NSLocationWhenInUseUsageDescription";String:C10($Obj_in.location)))
			
		End if 
		
		If (Bool:C1537($Obj_in.locationBackground)\
			 | (Length:C16(String:C10($Obj_in.locationBackground))>0))
			
			If (Bool:C1537($Obj_in.locationBackground))
				
				$Obj_in.locationBackground:="$(PRODUCT_NAME) you keep track of your course places needs access. It needs access to the GPS coordinates for your location."
				
			End if 
			
			$Obj_out.info.push(New object:C1471(\
				"NSLocationAlwaysUsageDescription";String:C10($Obj_in.locationBackground)))
			
		End if 
		
		If (Bool:C1537($Obj_in.camera)\
			 | (Length:C16(String:C10($Obj_in.camera))>0))
			
			If (Bool:C1537($Obj_in.camera))
				
				$Obj_in.camera:="$(PRODUCT_NAME) lets you make photos to share it. It needs access to the Camera."
				
			End if 
			
			$Obj_out.info.push(New object:C1471(\
				"NSCameraUsageDescription";String:C10($Obj_in.camera)))
			
		End if 
		
		If (Bool:C1537($Obj_in.photo)\
			 | (Length:C16(String:C10($Obj_in.photo))>0))
			
			If (Bool:C1537($Obj_in.photo))
				
				$Obj_in.photo:="$(PRODUCT_NAME) lets you use your photo to share it. It needs access to the photo library."
				
			End if 
			
			$Obj_out.info.push(New object:C1471(\
				"NSPhotoLibraryUsageDescription";String:C10($Obj_in.photo)))
			
		End if 
		
		If (Bool:C1537($Obj_in.contacts)\
			 | (Length:C16(String:C10($Obj_in.contacts))>0))
			
			If (Bool:C1537($Obj_in.contacts))
				
				$Obj_in.contacts:="$(PRODUCT_NAME) needs access to the Contacts to let you share it."
				
			End if 
			
			$Obj_out.info.push(New object:C1471(\
				"NSContactsUsageDescription";String:C10($Obj_in.contacts)))
			
		End if 
		
		  //________________________________________
		$Obj_out.success:=($Obj_out.info.length>0) | ($Obj_out.entitlements.length>0)  // Else nothings added
		
		  //________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		  //________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End