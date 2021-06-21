Class constructor
	
	C_TEXT:C284($1)
	C_VARIANT:C1683($2)
	
	If (Count parameters:C259>=1)
		
		If (Count parameters:C259>=2)
			
			This:C1470[$1]($2)
			
		Else 
			
			This:C1470[$1]()
			
		End if 
		
	Else 
		
		This:C1470.target:=Null:C1517
		This:C1470.exists:=False:C215
		
	End if 
	
	This:C1470.home:=Folder:C1567(Split string:C1554(Folder:C1567(fk desktop folder:K87:19).path; "/").resize(3).join("/"))
	
/*========================================================*/
Function create($do : Boolean)
	
	If ($do)
		
		This:C1470.target.create()
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
/*========================================================
	
                    USER
	
========================================================*/
Function userCache()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.home.folder("Library/Caches/com.4d.mobile")
		
	Else 
		
		$folder:=This:C1470.home.folder("AppData/Local/4D Mobile")
		
	End if 
	
	$folder.create()
	
/*========================================================*/
Function userlibrary()->$folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$folder:=This:C1470.home.folder("Library")
		
	Else 
		
		$folder:=This:C1470.home.folder("AppData/LocalLow/")
		
	End if 
	
/*========================================================*/
Function preferences($fileName : Text)->$target : Object
	
	If (Count parameters:C259>=1)
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).file("4D Mobile App/"+$fileName)
		
	Else 
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder("4D Mobile App")
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	$target:=This:C1470.target
	
/*========================================================
	
                    INTERNAL
	
========================================================*/
Function cacheSdkApple()->$zip : 4D:C1709.ZipArchive
	
	$zip:=This:C1470.cacheSDK().folder(Application version:C493+"/iOS/").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAppleUnzipped()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470.cacheSDK().folder(Application version:C493+"/iOS/sdk")
	
/*========================================================*/
Function cacheSdkAndroid()->$zip : 4D:C1709.ZipArchive
	
	$zip:=This:C1470.cacheSDK().folder(Application version:C493+"/Android/").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAndroidUnzipped()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470.cacheSDK().folder(Application version:C493+"/Android/sdk")
	
/*========================================================*/
Function cacheSDK()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470.systemCache().folder("sdk")
	
/*========================================================*/
Function systemCache()->$folder : 4D:C1709.Folder  // 4D Mobile cache folder
	
	If (Is macOS:C1572)
		
		$folder:=Folder:C1567("/Library/Caches/com.4D.mobile")
		
	Else 
		
		// Use ProgramData
		$folder:=Folder:C1567(fk system folder:K87:13).parent.folder("ProgramData/4D Mobile")
		
	End if 
	
	$folder.create()
	
/*========================================================*/
Function sdk  // sdk folder ||||||||||| TEST PURPOSE ||||||||||||
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/sdk")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function defaultroject()->$folder : 4D:C1709.Folder  // project folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/default project")
	This:C1470.exists:=This:C1470.target.exists
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function project()->$folder : 4D:C1709.Folder  // project folder
	
	This:C1470.target:=Folder:C1567("/RESOURCES/default project")
	This:C1470.exists:=This:C1470.target.exists
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function templates()->$folder : 4D:C1709.Folder  // templates folder
	
	If (FEATURE.with("compressionOfTemplates"))
		
		If (DATABASE.isMatrix) & Not:C34(FEATURE.with("testCompression"))
			
			// Use uncompressed resources
			This:C1470.target:=Folder:C1567("/RESOURCES/templates")
			
		Else 
			
			This:C1470.target:=ZIP Read archive:C1637(File:C1566("/RESOURCES/templates.zip")).root
			
		End if 
		
	Else 
		
		This:C1470.target:=Folder:C1567("/RESOURCES/templates")
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function scripts()->$folder : 4D:C1709.Folder  // scripts folder
	
	// Unsandboxed for use with LEP
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function _icons  // icons folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/images/tableIcons")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function tableIcons
	
	C_OBJECT:C1216($0)
	
	$0:=This:C1470._icons()
	
/*========================================================*/
Function fieldIcons
	
	C_OBJECT:C1216($0)
	
	$0:=This:C1470._icons()
	
/*========================================================*/
Function actionIcons
	
	C_OBJECT:C1216($0)
	
	$0:=This:C1470._icons()
	
/*========================================================*/
Function forms  // forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function listForms  // list forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/list")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function detailForms  // detail forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/detail")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function navigationForms  // navigation forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/navigation")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function loginForms  // login forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/templates/form/login")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidTemplates  // android templates folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidForms  // android forms folder
	
	C_OBJECT:C1216($0)
	
	//This.target:=Folder(Folder("/RESOURCES/templates/android/form").platformPath; fk platform path)
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/form").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidListForms  // android list forms folder
	
	C_OBJECT:C1216($0)
	
	//This.target:=Folder(Folder("/RESOURCES/templates/android/form/list").platformPath; fk platform path)
	This:C1470.target:=This:C1470.androidForms().folder("list")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidDetailForms  // android detail forms folder
	
	C_OBJECT:C1216($0)
	
	//This.target:=Folder(Folder("/RESOURCES/templates/android/form/detail").platformPath; fk platform path)
	This:C1470.target:=This:C1470.androidForms().folder("detail")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidProject  // android project files folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidProjectFilesToCopy  // android project files to copy folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/copy").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidProjectTemplateFiles  // android project template files folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/tpl").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================
	
                  USER DATABASE
	
========================================================*/
Function databasePreferences($fileName : Text)->$target : Object  //  Writable user database preferences folder
	
	If (Count parameters:C259>=1)
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name).file($fileName)
		
	Else 
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name)
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	$target:=This:C1470.target
	
/*========================================================*/
Function projects($create : Boolean)->$folder : 4D:C1709.Folder  // Projects folder
	
	This:C1470.target:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function products($create : Boolean)->$folder : 4D:C1709.Folder  // Products folder
	
	var $o : Object
	
	//#WARNING - Folder(Database folder;*).parent = Null
	$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14; *))
	This:C1470.target:=Folder:C1567($o.parentFolder+$o.name+" - Mobile"; fk platform path:K87:2)
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function host($create : Boolean)->$folder : 4D:C1709.Folder  // Mobile folder
	
	C_OBJECT:C1216($o)
	
	$o:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16; *); fk platform path:K87:2)
	
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
			
			This:C1470.create($create)
			
		Else 
			
			This:C1470.exists:=This:C1470.target.exists
			
		End if 
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostForms($create : Boolean)->$folder : 4D:C1709.Folder  // Form folder
	
	This:C1470.target:=This:C1470.host().folder("form")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostFormatters($create : Boolean)->$folder : 4D:C1709.Folder  // Formatters folder
	
	This:C1470.target:=This:C1470.host().folder("formatters")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostActionParameterFormatters($create : Boolean)->$folder : 4D:C1709.Folder  // Action Parameter Formatters folder
	
	This:C1470.target:=This:C1470.host().folder("actionParameters")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostIcons($create : Boolean)->$folder : 4D:C1709.Folder  // Icons folder
	
	This:C1470.target:=This:C1470.host().folder("medias/icons")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostlistForms($create : Boolean)->$folder : 4D:C1709.Folder  // form/list folder
	
	This:C1470.target:=This:C1470.hostForms().folder("list")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostloginForms($create : Boolean)->$folder : 4D:C1709.Folder  // login folder
	
	This:C1470.target:=This:C1470.hostForms().folder("login")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostdetailForms($create : Boolean)->$folder : 4D:C1709.Folder  // form/detail folder
	
	This:C1470.target:=This:C1470.hostForms().folder("detail")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function hostNavigationForms($create : Boolean)->$folder : 4D:C1709.Folder  // form/navigation folder
	
	This:C1470.target:=This:C1470.hostForms().folder("navigation")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$folder:=This:C1470.target
	
/*========================================================*/
Function key()->$file : 4D:C1709.file
	
	$file:=Folder:C1567(MobileApps folder:K5:47; *).file("key.mobileapp")
	
/*========================================================*/
Function icon($relativePath : Text)->$file : 4D:C1709.File
	
	$file:=This:C1470._getResource($relativePath; "icon")
	
/*========================================================*/
Function list($relativePath : Text)->$file : 4D:C1709.Folder
	
	$file:=This:C1470._getResource($relativePath; "list")
	
/*========================================================*/
Function detail($relativePath : Text)->$file : 4D:C1709.Folder
	
	$file:=This:C1470._getResource($relativePath; "detail")
	
/*========================================================*/
Function navigation($relativePath : Text)->$file : 4D:C1709.Folder
	
	$file:=This:C1470._getResource($relativePath; "navigation")
	
/*========================================================*/
Function _getResource($relativePath : Text; $type : Text)->$target : Object
	
	var $error : Object
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
		
		If (Path to object:C1547($relativePath).extension=SHARED.archiveExtension)
			
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
	