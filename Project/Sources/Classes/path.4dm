Class constructor
	
	C_TEXT:C284($1)
	C_BOOLEAN:C305($2)
	
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
	
/*========================================================*/
Function create
	
	C_BOOLEAN:C305($1)
	
	If ($1)
		
		This:C1470.target.create()
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
/*========================================================
	
                    INTERNAL
	
========================================================*/
Function cacheSdkApple()
	var $0 : 4D:C1709.File
	$0:=This:C1470.cacheSDK().folder(Application version:C493+"/iOS/").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAndroid()
	var $0 : 4D:C1709.File
	$0:=This:C1470.cacheSDK().folder(Application version:C493+"/Android/").file("sdk.zip")
	
/*========================================================*/
Function cacheSdkAndroidUnzipped()
	var $0 : 4D:C1709.Folder
	$0:=This:C1470.cacheSDK().folder(Application version:C493+"/Android/sdk")
	
/*========================================================*/
Function cacheSDK()
	var $0 : 4D:C1709.Folder
	
	$0:=This:C1470.cache().folder("sdk")
	
/*========================================================*/
Function cache()  // 4D Mobile cache folder
	var $0 : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		$0:=Folder:C1567(fk desktop folder:K87:19).parent.folder("Library/Caches/com.4d.mobile")
		
	Else 
		
		$0:=Folder:C1567(fk desktop folder:K87:19).parent.folder("AppData/Roaming/4DMobile")
		
	End if 
	
/*========================================================*/
Function sdk  // sdk folder ||||||||||| OBSOLETE ||||||||||||
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/sdk/Versions")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function project  // project folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567("/RESOURCES/default project")
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function templates  // templates folder
	
	C_OBJECT:C1216($0)
	
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
	
	$0:=This:C1470.target
	
/*========================================================*/
Function scripts  // scripts folder
	
	C_OBJECT:C1216($0)
	
	// Unsandboxed for use with LEP
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/scripts").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
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
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/form").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidListForms  // android list forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/form/list").platformPath; fk platform path:K87:2)
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function androidDetailForms  // android detail forms folder
	
	C_OBJECT:C1216($0)
	
	This:C1470.target:=Folder:C1567(Folder:C1567("/RESOURCES/templates/android/form/detail").platformPath; fk platform path:K87:2)
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
Function databasePreferences($fileName : Text)  //  Writable user database preferences folder
	
	C_OBJECT:C1216($0)
	
	If (Count parameters:C259>=1)
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name).file($fileName)
		
	Else 
		
		This:C1470.target:=Folder:C1567(fk user preferences folder:K87:10).folder(Folder:C1567(Database folder:K5:14; *).name)
		
	End if 
	
	This:C1470.exists:=This:C1470.target.exists
	
	$0:=This:C1470.target
	
/*========================================================*/
Function projects  // Projects folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=Folder:C1567(fk database folder:K87:14; *).folder("Mobile Projects")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function products  // Products folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	C_OBJECT:C1216($o)
	
	//#WARNING - Folder(Database folder;*).parent = Null
	$o:=Path to object:C1547(Get 4D folder:C485(Database folder:K5:14; *))
	This:C1470.target:=Folder:C1567($o.parentFolder+$o.name+" - Mobile"+Folder separator:K24:12; fk platform path:K87:2)
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function host  // Mobile folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
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
			
			This:C1470.create($1)
			
		Else 
			
			This:C1470.exists:=This:C1470.target.exists
			
		End if 
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostForms  // Form folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.host().folder("form")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostFormatters  // Formatters folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.host().folder("formatters")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostIcons  // Icons folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.host().folder("medias/icons")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostlistForms  // form/list folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.hostForms().folder("list")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostloginForms  // login folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.hostForms().folder("login")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostdetailForms  // form/detail folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.hostForms().folder("detail")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/
Function hostNavigationForms  // form/navigation folder
	
	C_OBJECT:C1216($0)
	C_BOOLEAN:C305($1)
	
	This:C1470.target:=This:C1470.hostForms().folder("navigation")
	
	If (Count parameters:C259>=1)
		
		This:C1470.create($1)
		
	Else 
		
		This:C1470.exists:=This:C1470.target.exists
		
	End if 
	
	$0:=This:C1470.target
	
/*========================================================*/