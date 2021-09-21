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
	
	// ⚠️ In some cases (Surface), the Home folder is not the parent of the desktop folder.
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
Function cacheSdkApple()->$zip : 4D:C1709.ZipFile
	
	$zip:=This:C1470.cacheSDK().folder(Application version:C493+"/iOS/").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAppleUnzipped()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470.cacheSDK().folder(Application version:C493+"/iOS/sdk")
	
/*========================================================*/
Function cacheSdkAndroid()->$zip : 4D:C1709.ZipFile
	
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
Function sdk()->$folder : 4D:C1709.Folder  // sdk folder ||||||||||| TEST PURPOSE ||||||||||||
	
	$folder:=Folder:C1567("/RESOURCES/sdk")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function defaultroject()->$folder : 4D:C1709.Folder  // project folder
	
	$folder:=Folder:C1567("/RESOURCES/default project")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function project()->$folder : 4D:C1709.Folder  // project folder
	
	$folder:=Folder:C1567("/RESOURCES/default project")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function templates()->$folder : 4D:C1709.Folder  // templates folder
	
	If (FEATURE.with("compressionOfTemplates"))
		
		If (DATABASE.isMatrix) & Not:C34(FEATURE.with("testCompression"))
			
			// Use uncompressed resources
			$folder:=Folder:C1567("/RESOURCES/templates")
			
		Else 
			
			$folder:=ZIP Read archive:C1637(File:C1566("/RESOURCES/templates.zip")).root
			
		End if 
		
	Else 
		
		$folder:=Folder:C1567("/RESOURCES/templates")
		
	End if 
	
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function scripts()->$folder : 4D:C1709.Folder  // scripts folder
	
	// Unsandboxed for use with LEP
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function _icons()->$folder : 4D:C1709.Folder  // icons folder
	
	$folder:=Folder:C1567("/RESOURCES/images/tableIcons")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function tableIcons()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470._icons()
	
/*========================================================*/
Function fieldIcons()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470._icons()
	
/*========================================================*/
Function actionIcons()->$folder : 4D:C1709.Folder
	
	$folder:=This:C1470._icons()
	
/*========================================================*/
Function forms()->$folder : 4D:C1709.Folder  // forms folder
	
	$folder:=Folder:C1567("/RESOURCES/templates/form")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function listForms()->$folder : 4D:C1709.Folder  // list forms folder
	
	$folder:=Folder:C1567("/RESOURCES/templates/form/list")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function detailForms()->$folder : 4D:C1709.Folder  // detail forms folder
	
	$folder:=Folder:C1567("/RESOURCES/templates/form/detail")
	This:C1470.target:=$folder
	This:C1470.exists:=This:C1470.target.exists
	
/*========================================================*/
Function navigationForms()->$folder : 4D:C1709.Folder  // navigation forms folder
	
	$folder:=Folder:C1567("/RESOURCES/templates/form/navigation")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function loginForms()->$folder : 4D:C1709.Folder  // login forms folder
	
	$folder:=Folder:C1567("/RESOURCES/templates/form/login")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidTemplates()->$folder : 4D:C1709.Folder  // android templates folder
	
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidForms()->$folder : 4D:C1709.Folder  // android forms folder
	
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/templates/form").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidListForms()->$folder : 4D:C1709.Folder  // android list forms folder
	
	//This.target:=Folder(Folder("/RESOURCES/templates/android/form/list").platformPath; fk platform path)
	$folder:=This:C1470.androidForms().folder("list")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidDetailForms()->$folder : 4D:C1709.Folder  // android detail forms folder
	
	$folder:=This:C1470.androidForms().folder("detail")
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidProject()->$folder : 4D:C1709.Folder  // android project files folder
	
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidProjectFilesToCopy()->$folder : 4D:C1709.Folder  // android project files to copy folder
	
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/copy").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================*/
Function androidProjectTemplateFiles()->$folder : 4D:C1709.Folder  // android project template files folder
	
	$folder:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/project/tpl").platformPath; fk platform path:K87:2)
	This:C1470.target:=$folder
	This:C1470.exists:=$folder.exists
	
/*========================================================
	
                  USER DATABASE
	
========================================================*/
Function databasePreferences($fileName : Text)->$target : Object  //  Writable user database preferences folder
	
	If (Count parameters:C259>=1)
		
		$target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name).file($fileName)
		
	Else 
		
		$target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name)
		
	End if 
	
	This:C1470.target:=$target
	This:C1470.exists:=$target.exists
	
/*========================================================*/
Function projects($create : Boolean)->$folder : 4D:C1709.Folder  // Projects folder
	
	$folder:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects")
	This:C1470.target:=$folder
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=$folder.exists
		
	End if 
	
	
/*========================================================*/
Function products($create : Boolean)->$folder : 4D:C1709.Folder  // Products folder
	
	var $o : Object
	
	//#WARNING - Folder(Database folder;*).parent = Null
	$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14; *))
	$folder:=Folder:C1567($o.parentFolder+$o.name+" - Mobile"; fk platform path:K87:2)
	This:C1470.target:=$folder
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($create)
		
	Else 
		
		This:C1470.exists:=$folder.exists
		
	End if 
	
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
Function hostInputControls($create : Boolean)->$folder : 4D:C1709.Folder  // Action Parameter input controls folder
	
	This:C1470.target:=This:C1470.host().folder("inputControls")
	
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
Function key()->$file : 4D:C1709.File
	
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
	