Class constructor($id : Text; $options : Variant)
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			This:C1470[$id]($options)
			
		Else 
			
			This:C1470[$id]()
			
		End if 
		
	Else 
		
		This:C1470.target:=Null:C1517
		This:C1470.exists:=False:C215
		
	End if 
	
	
	//MARK:-TOOLS
Function resolve($path : Text) : Object
	
	If (Length:C16($path)=0)
		
		return File:C1566("📄")
		
	End if 
	
	If ($path="/@")\
		 && (Position:C15("/Volumes/"; $path; *)=0)\
		 && (Position:C15("/Users/"; $path; *)=0)
		
		// Relative 
		return $path="@/"\
			 ? Folder:C1567(database.databaseFolder.path+$path)\
			 : File:C1566(database.databaseFolder.path+$path)
		
	Else 
		
		// Absolute
		return $path="@/"\
			 ? Folder:C1567($path)\
			 : File:C1566($path)
		
	End if 
	
	//MARK:-USER
Function userHome() : 4D:C1709.Folder
	
	return Folder:C1567(fk home folder:K87:24)
	
/*========================================================*/
Function userDesktop() : 4D:C1709.Folder
	
	return Folder:C1567(fk desktop folder:K87:19)
	
/*========================================================*/
Function userDocuments() : 4D:C1709.Folder
	
	return Folder:C1567(fk documents folder:K87:21)
	
/*========================================================*/
Function userCache()->$folder : 4D:C1709.Folder
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is macOS:C1572)
			
			$folder:=This:C1470.userHome().folder("Library/Caches/com.4d.mobile")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is Windows:C1573)
			
			$folder:=This:C1470.userHome().folder("AppData/Local/4D Mobile")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			$folder:=This:C1470.userHome().folder(".cache/com.4d.mobile")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	If ($folder#Null:C1517)
		
		$folder.create()
		
	End if 
	
/*========================================================*/
Function userlibrary() : 4D:C1709.Folder
	
	Case of 
		: (Is macOS:C1572)
			
			return This:C1470.userHome().folder("Library")
			
		: (Is Windows:C1573)
			
			return This:C1470.userHome().folder("AppData/LocalLow/")
			
		Else 
			
			return Folder:C1567("/usr/local/lib")
			
	End case 
	
/*========================================================*/
Function preferences($fileName : Text) : Object
	
	If (Count parameters:C259>=1)
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).file("4D Mobile App/"+$fileName)
		
	Else 
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder("4D Mobile App")
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
	//MARK:-INTERNAL
	
Function isSdkAppleExists() : Boolean
	
	return This:C1470.cacheSdkAppleUnzipped().exists || This:C1470.sdkApple().exists/*will be unzipped*/
	
Function cacheSdkApple() : 4D:C1709.File
	
	return This:C1470.cacheSdkAppleUnzipped().folder("iOS").file("sdk.zip")
	return This:C1470.cacheSdkVersion().folder("iOS").file("sdk.zip")
/*========================================================*/
Function cacheSdkAppleManifest() : 4D:C1709.File
	
	return This:C1470.cacheSdkVersion().folder("iOS").file("manifest.json")
	
/*========================================================*/
Function cacheSdkAppleUnzipped() : 4D:C1709.Folder
	
	return This:C1470.cacheSdkVersion().folder("iOS/sdk")
	
/*========================================================*/
	
Function isSdkAndroidExists() : Boolean
	
	return This:C1470.cacheSdkAndroidUnzipped().exists || This:C1470.sdkAndroid().exists/*will be unzipped*/
	
/*========================================================*/
Function cacheSdkAndroid() : 4D:C1709.File
	
	return This:C1470.cacheSdkVersion().folder("Android").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAndroidManifest() : 4D:C1709.File
	
	return This:C1470.cacheSdkVersion().folder("Android").file("manifest.json")
	
/*========================================================*/
Function cacheSdkAndroidUnzipped() : 4D:C1709.Folder
	
	return This:C1470.cacheSdkVersion().folder("Android/sdk")
	
/*========================================================*/
Function cacheSdkVersion() : 4D:C1709.Folder
	var $cache : 4D:C1709.Folder
	$cache:=This:C1470.cacheSDK()
	
	If ($cache.folder("latest").exists)
		
		return $cache.folder("latest")
		
	End if 
	
	return $cache.folder(Application version:C493)
	
/*========================================================*/
Function cacheSDK() : 4D:C1709.Folder
	
	return This:C1470.systemCache().folder("sdk")
	
/*========================================================*/
Function systemCache()->$folder : 4D:C1709.Folder  // 4D Mobile cache folder
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is macOS:C1572)
			
			$folder:=Folder:C1567("/Library/Caches/com.4D.mobile")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Is Windows:C1573)
			
			// Use ProgramData
			$folder:=Folder:C1567(fk system folder:K87:13).parent.folder("ProgramData/4D Mobile")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			// $folder:=Folder("/var/cache/com.4D.mobile")  // Need sudo to create, so we provide user cache instead
			$folder:=This:C1470.userCache()
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	$folder.create()
	return $folder
	
/*========================================================*/
Function sdk() : 4D:C1709.Folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/sdk")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function sdkApple() : 4D:C1709.File  // ios zip sdk
	This:C1470.target:=This:C1470.hostSDK().file("ios.zip")  // could be placed in client base
	If (This:C1470.target.exists)
		This:C1470.exists:=True:C214
		return This:C1470.target
	End if 
	
	This:C1470.target:=This:C1470.sdk().file("ios.zip")  // if embedded it re-become the one used
	If (This:C1470.target.exists)
		This:C1470.exists:=True:C214
		return This:C1470.target
	End if 
	
	If (Feature.with("iosSDKfromAWS"))
		return This:C1470.cacheSdkApple()
	Else 
		This:C1470.target:=This:C1470.sdk().file("ios.zip")
		This:C1470.exists:=This:C1470.target.exists
		
		If (dev_Matrix)
			
			If (Not:C34(This:C1470.exists))
				
				This:C1470.target:=Folder:C1567(Application file:C491; fk platform path:K87:2).file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/sdk/ios.zip")
				This:C1470.exists:=This:C1470.target.exists
				
			End if 
		End if 
		
		return This:C1470.target
	End if 
	
	
/*========================================================*/
Function sdkAndroid() : 4D:C1709.File  // android zip sdk
	This:C1470.target:=This:C1470.hostSDK().file("android.zip")  // could be placed in client base
	If (This:C1470.target.exists)
		This:C1470.exists:=True:C214
		return This:C1470.target
	End if 
	
	This:C1470.target:=This:C1470.sdk().file("android.zip")  // if embedded it become the one used
	If (This:C1470.target.exists)
		This:C1470.exists:=True:C214
		return This:C1470.target
	End if 
	
	return This:C1470.cacheSdkAndroid()
	
/*========================================================*/
Function defaultroject() : 4D:C1709.Folder  // project folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/default project")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function project() : 4D:C1709.Folder  // project folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/default project")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function templates() : 4D:C1709.Folder  // templates folder
	
	If (Feature.with("compressionOfTemplates"))
		
		If (Component.isMatrix) & Feature.disabled("testCompression")
			
			// Use uncompressed resources
			This:C1470.target:=Folder:C1567("/RESOURCES/templates")
			
		Else 
			
			This:C1470.target:=ZIP Read archive:C1637(File:C1566("/RESOURCES/templates.zip")).root
			
		End if 
		
	Else 
		
		This:C1470.target:=Folder:C1567("/RESOURCES/templates")
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function scripts() : 4D:C1709.Folder  // scripts folder
	
	// Unsandboxed for use with LEP
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function tableIcons() : 4D:C1709.Folder
	
	return This:C1470._icons()
	
/*========================================================*/
Function fieldIcons() : 4D:C1709.Folder
	
	return This:C1470._icons()
	
/*========================================================*/
Function actionIcons() : 4D:C1709.Folder
	
	return This:C1470._icons()
	
/*========================================================*/
Function forms() : 4D:C1709.Folder  // forms folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function listForms() : 4D:C1709.Folder  // list forms folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/list")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function detailForms() : 4D:C1709.Folder  // detail forms folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/detail")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function navigationForms() : 4D:C1709.Folder  // navigation forms folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/navigation")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function loginForms() : 4D:C1709.Folder  // login forms folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/login")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidTemplates() : 4D:C1709.Folder  // android templates folder
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidForms() : 4D:C1709.Folder  // android forms folder
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/form").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidListForms() : 4D:C1709.Folder  // android list forms folder
	
	This:C1470.target:=This:C1470.androidForms().folder("list")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidDetailForms() : 4D:C1709.Folder  // android detail forms folder
	
	This:C1470.target:=This:C1470.androidForms().folder("detail")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidProject() : 4D:C1709.Folder  // android project files folder
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidProjectFilesToCopy() : 4D:C1709.Folder  // android project files to copy folder
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/copy").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function androidProjectTemplateFiles() : 4D:C1709.Folder  // android project template files folder
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/tpl").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
	//MARK:-USER DATABASE
Function databasePreferences($fileName : Text) : Object  //  Writable user database preferences folder
	
	If (Count parameters:C259>=1)
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name).file($fileName)
		
	Else 
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name)
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target
	
/*========================================================*/
Function projects($create : Boolean) : 4D:C1709.Folder  // Projects folder
	
	This:C1470.target:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function products($create : Boolean) : 4D:C1709.Folder  // Products folder
	
	var $o : Object
	
	//#WARNING - Folder(Database folder;*).parent = Null
	If (Feature.with("buildWithCmd"))
		$o:=Folder:C1567(Folder:C1567(Database folder:K5:14; *).platformPath; fk platform path:K87:2)
		This:C1470.target:=$o.parent.folder($o.fullName+" - Mobile")
	Else 
		$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14; *))  // not server l compliant
		This:C1470.target:=Folder:C1567($o.parentFolder+$o.name+" - Mobile"; fk platform path:K87:2)
	End if 
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function host($create : Boolean) : 4D:C1709.Folder  // Mobile folder
	
	C_OBJECT:C1216($o)
	
	$o:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2)
	
	If ($o.file("mobile").exists)
		
		If ($o.file("mobile").original#Null:C1517)
			
			// Could be an alias
			This:C1470.target:=$o.file("mobile").original
			
		Else 
			
			This:C1470.target:=$o.file("mobile")
			
		End if 
		
		This:C1470.exists:=This:C1470.target.exists
		
	Else 
		
		This:C1470.target:=$o.folder("mobile")
		
		If (Count parameters:C259>=1)
			
			This:C1470._create($create)
			
		Else 
			
			This:C1470.exists:=This:C1470.target.exists
			
		End if 
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostForms($create : Boolean) : 4D:C1709.Folder  // Form folder
	
	This:C1470.target:=This:C1470.host().folder("form")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostSDK($create : Boolean) : 4D:C1709.Folder  // SDK folder
	
	This:C1470.target:=This:C1470.host().folder("sdk")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostFormatters($create : Boolean) : 4D:C1709.Folder  // Formatters folder
	
	This:C1470.target:=This:C1470.host().folder("formatters")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostInputControls($create : Boolean) : 4D:C1709.Folder  // Action Parameter input controls folder
	
	This:C1470.target:=This:C1470.host().folder("inputControls")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostIcons($create : Boolean) : 4D:C1709.Folder  // Icons folder
	
	This:C1470.target:=This:C1470.host().folder("medias/icons")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostlistForms($create : Boolean) : 4D:C1709.Folder  // form/list folder
	
	This:C1470.target:=This:C1470.hostForms().folder("list")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostloginForms($create : Boolean) : 4D:C1709.Folder  // login folder
	
	This:C1470.target:=This:C1470.hostForms().folder("login")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostdetailForms($create : Boolean) : 4D:C1709.Folder  // form/detail folder
	
	This:C1470.target:=This:C1470.hostForms().folder("detail")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function hostNavigationForms($create : Boolean) : 4D:C1709.Folder  // form/navigation folder
	
	This:C1470.target:=This:C1470.hostForms().folder("navigation")
	
	If (Count parameters:C259>=1)
		
		This:C1470._create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	return This:C1470.target
	
/*========================================================*/
Function iOSDb($relativePath : Variant) : 4D:C1709.File
	
	var $currentFolder : 4D:C1709.Folder
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($relativePath)=Is text:K8:3)
			
			$currentFolder:=Folder:C1567($relativePath; fk platform path:K87:2)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509($relativePath)=Is object:K8:27) && OB Instance of:C1731($relativePath; 4D:C1709.Folder))
			
			$currentFolder:=$relativePath
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	If ($currentFolder.fullName="project.dataSet")
		
		return $currentFolder.file("Resources/Structures.sqlite")
		
	Else 
		
		return $currentFolder.file("project.dataSet/Resources/Structures.sqlite")
		
	End if 
	
/*========================================================*/
Function androidDb($relativePath : Variant) : 4D:C1709.File
	
	var $currentFolder : 4D:C1709.Folder
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($relativePath)=Is text:K8:3)
			
			// General build process provide now platform path,
			// But some android class do not take into account path and use This.project._folder.path
			// Until all code has been changed to pass 4d folder, we make a code that support any type of path
			If (Is Windows:C1573)
				
				$currentFolder:=(Position:C15("\\"; $relativePath)=0) ? Folder:C1567($relativePath) : Folder:C1567($relativePath; fk platform path:K87:2)
				
			Else 
				
				//%W-533.1
				$currentFolder:=($relativePath[[1]]="/" ? Folder:C1567($relativePath) : Folder:C1567($relativePath; fk platform path:K87:2))
				//%W+533.1
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ((Value type:C1509($relativePath)=Is object:K8:27) && OB Instance of:C1731($relativePath; 4D:C1709.Folder))
			
			$currentFolder:=$relativePath
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	If ($currentFolder.fullName="project.dataSet")
		
		return $currentFolder.file("android/static.db")
		
	Else 
		
		return $currentFolder.file("project.dataSet/android/static.db")
		
	End if 
	
	
/*========================================================*/
Function mobileApps() : 4D:C1709.Folder
	
	If (Is macOS:C1572 || Is Windows:C1573)
		
		return Folder:C1567(fk mobileApps folder:K87:18; *)
		
	Else 
		
		// TEMPORARY with dataless on linux only: ask to make it compatible with dataless
		return Folder:C1567(fk database folder:K87:14; *).folder("MobileApps")
		
	End if 
	
/*========================================================*/
Function key() : 4D:C1709.File
	
	return This:C1470.mobileApps().file("key.mobileapp")
	
/*========================================================*/
Function icon($relativePath : Text) : 4D:C1709.File
	
	return This:C1470._getResource($relativePath; "icon")
	
/*========================================================*/
Function list($relativePath : Text) : 4D:C1709.Folder
	
	return This:C1470._getResource($relativePath; "list")
	
/*========================================================*/
Function detail($relativePath : Text) : 4D:C1709.Folder
	
	return This:C1470._getResource($relativePath; "detail")
	
/*========================================================*/
Function navigation($relativePath : Text) : 4D:C1709.Folder
	
	return This:C1470._getResource($relativePath; "navigation")
	
	//MARK:-[PRIVATE]
/*========================================================*/
Function _create($do : Boolean)
	
	If ($do)
		
		This:C1470.target.create()
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
/*========================================================*/
Function _getResource($relativePath : Text; $type : Text)->$target : Object
	
	var $folder : 4D:C1709.Folder
	var $archive : 4D:C1709.ZipArchive
	var $error : cs:C1710.error
	
	If ($relativePath[[1]]="/")
		
		$relativePath:=Delete string:C232($relativePath; 1; 1)
		
		Case of 
				
				//……………………………………………………………………………
			: ($type="list")
				
				$folder:=This:C1470.hostlistForms()
				
				//……………………………………………………………………………
			: ($type="detail")
				
				$folder:=This:C1470.hostdetailForms()
				
				//……………………………………………………………………………
			: ($type="login")
				
				$folder:=This:C1470.hostloginForms()
				
				//……………………………………………………………………………
			: ($type="navigation")
				
				$folder:=This:C1470.hostNavigationForms()
				
				//……………………………………………………………………………
			: ($type="icon")
				
				// For the moment, no distinction between table, field or action icons
				$folder:=This:C1470.hostIcons()
				
				//……………………………………………………………………………
		End case 
		
		If (GetFileExtension($relativePath)=SHARED.archiveExtension)
			
/* START HIDING ERRORS */
			$error:=cs:C1710.error.new().hide()
			$archive:=ZIP Read archive:C1637($folder.file($relativePath))
			$error.show()
/* STOP HIDING ERRORS */
			
			If ($archive#Null:C1517)
				
				$target:=$archive.root
				
			End if 
			
		Else 
			
			$target:=$folder.file($relativePath)
			
		End if 
		
	Else 
		
		Case of 
				
				//……………………………………………………………………………
			: ($type="list")
				
				$target:=This:C1470.listForms().folder($relativePath)
				
				//……………………………………………………………………………
			: ($type="detail")
				
				$target:=This:C1470.detailForms().folder($relativePath)
				
				//……………………………………………………………………………
			: ($type="navigation")
				
				$target:=This:C1470.navigationForms().folder($relativePath)
				
				//……………………………………………………………………………
			: ($type="icon")
				
				// For the moment, no distinction between table, field or action icons
				$target:=This:C1470.tableIcons().file($relativePath)
				
				//……………………………………………………………………………
		End case 
	End if 
	
/*========================================================*/
Function _icons() : 4D:C1709.Folder  // icons folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/images/tableIcons")
	This:C1470.exists:=This:C1470.target.exists
	
	return This:C1470.target