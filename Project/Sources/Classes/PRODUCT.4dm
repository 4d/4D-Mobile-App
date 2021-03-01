/*===============================================
PRODUCTS pannel Class
===============================================*/
Class extends form

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
Class constructor
	
	Super:C1705("editor_CALLBACK")
	
	This:C1470.context:=editor_INIT
	
	If (OB Is empty:C1297(This:C1470.context)) | Shift down:C543
		
		This:C1470.productName:=cs:C1710.widget.new("10_name")
		This:C1470.productNameAlert:=cs:C1710.attention.new("name.alert")
		
		This:C1470.productVersion:=cs:C1710.widget.new("11_version")
		
		This:C1470.productID:=cs:C1710.widget.new("id")
		
		This:C1470.productCopyright:=cs:C1710.widget.new("30_copyright")
		
		This:C1470.icon:=cs:C1710.widget.new("icon")
		This:C1470.iconAlert:=cs:C1710.attention.new("icon.alert")
		This:C1470.iconAction:=cs:C1710.attention.new("icon.action")
		
		This:C1470.target:=cs:C1710.static.new("target.label")
		This:C1470.ios:=cs:C1710.button.new("ios")
		This:C1470.android:=cs:C1710.button.new("android")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Manage the icon's action button
Function iconMenu()
	
	var $p : Picture
	var $menu : Object
	
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append("CommonMenuItemPaste"; "setIcon")
	GET PICTURE FROM PASTEBOARD:C522($p)
	$menu.enable(Bool:C1537(OK))
	
	$menu.line()
	$menu.append("browse"; "browseIcon")
	$menu.line()
	
	If (FEATURE.with("android"))  //🚧
		
		If (Is macOS:C1572)
			
			If (Value type:C1509(Form:C1466.info.target)=Is collection:K8:32)
				
				$menu.append("showiOSIconsFolder"; "openAppleIconFolder")
				$menu.append("showAndroidIconsFolder"; "openAndroidIconFolder")
				
			Else 
				
				$menu.append("showIconsFolder"; Choose:C955(String:C10(Form:C1466.info.target)="iOS"; "openAppleIconFolder"; "openAndroidIconFolder"))
				
			End if 
			
		Else 
			
			$menu.append("showIconsFolder"; "openAndroidIconFolder")
			
		End if 
		
	Else 
		
		$menu.append("showIconsFolder"; "openAppleIconFolder").enable(Bool:C1537(This:C1470.assets.folder.exists))
		
	End if 
	
	$menu.popup()
	
	If ($menu.selected)
		
		If ($menu.choice="setIcon")
			
			This:C1470.setIcon($p)
			
		Else 
			
			This:C1470[$menu.choice]()
			
		End if 
	End if 
	
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Display the App icon
Function displayIcon
	
	var $picture : Picture
	var $folder : 4D:C1709.Folder
	
	If (FEATURE.with("android"))
		
		$folder:=Form:C1466._folder.folder("Assets.xcassets/AppIcon.appiconset")
		
		If ($folder.exists)
			
			READ PICTURE FILE:C678($folder.file("ios-marketing1024.png").platformPath; $picture)
			
		Else 
			
			$folder:=Form:C1466._folder.folder("Android")
			
			If ($folder.exists)
				
				READ PICTURE FILE:C678($folder.file("main/ic_launcher-playstore.png").platformPath; $picture)
				
			Else 
				
				READ PICTURE FILE:C678(UI.errorIcon; $picture)
				
			End if 
		End if 
		
		This:C1470.icon.setValue($picture)
		
	Else 
		
		var $o : Object
		var $file : 4D:C1709.File
		
		If (This:C1470.assets.icons#Null:C1517)
			
			If (Is macOS:C1572)
				
				$o:=This:C1470.assets.icons.images.query("idiom = :1"; "ios-marketing").pop()
				
				If ($o#Null:C1517)
					
					$file:=This:C1470.assets.folder.file($o.filename)
					
					If ($file.exists)
						
						READ PICTURE FILE:C678($file.platformPath; $picture)
						This:C1470.icon.setValue($picture)
						This:C1470.iconAlert.reset()
						
					Else 
						
						This:C1470.icon.setValue($picture)
						This:C1470.iconAlert.alert(".Missing file.")  // #MARK_LOCALIZE
						
					End if 
					
				Else 
					
					This:C1470.icon.setValue($picture)
					This:C1470.iconAlert.alert(".The icon is mandatory.")  // #MARK_LOCALIZE
					
				End if 
				
			Else 
				
				$o:=This:C1470.assets.icons.images.query("idiom = :1"; "ios-marketing").pop()
				
				If ($o#Null:C1517)
					
					$file:=This:C1470.assets.folder.file($o.filename)
					
					If ($file.exists)
						
						READ PICTURE FILE:C678($file.platformPath; $picture)
						This:C1470.icon.setValue($picture)
						This:C1470.iconAlert.reset()
						
					Else 
						
						This:C1470.icon.setValue($picture)
						This:C1470.iconAlert.alert(".Missing file.")  // #MARK_LOCALIZE
						
					End if 
					
				Else 
					
					This:C1470.icon.setValue($picture)
					This:C1470.iconAlert.alert(".The icon is mandatory.")  // #MARK_LOCALIZE
					
				End if 
			End if 
			
		Else 
			
			
			READ PICTURE FILE:C678(UI.errorIcon; $picture)
			This:C1470.icon.setValue($picture)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Choose an icon file
Function browseIcon
	
	var $filter; $fileName : Text
	
	If (Is macOS:C1572)
		
		// Accept an image file or an app
		$filter:="public.image;.app"
		
	Else 
		
		// Image file only
		$filter:="public.image"
		
	End if 
	
	$fileName:=Select document:C905(8858; $filter; Get localized string:C991("selectAPictureOrAnApplication"); Use sheet window:K24:11)
	
	If (Bool:C1537(OK))
		
		This:C1470.getIcon(DOCUMENT)
		
	End if 
	
	//=========================================================
	// Retrieve icon from a platform pathname
Function getIcon($pathname : Text)
	
	var $t : Text
	var $icon : Picture
	
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	If (Count parameters:C259>=1)
		
		If ($pathname[[Length:C16($pathname)]]#Folder separator:K24:12)
			
			READ PICTURE FILE:C678($pathname; $icon)
			
		Else 
			
			$folder:=Folder:C1567($pathname; fk platform path:K87:2)
			
			If ($folder.isPackage)  // For macOS, try to get the app icon
				
				$folder:=$folder.folder("Contents")
				
				If ($folder.exists)
					
					$file:=$folder.files().query("fullName = Info.plist").pop()
					
					If (Bool:C1537($file.exists))
						
						$folder:=$folder.folders().query("fullName = Resources").pop()
						
						If (Bool:C1537($folder.exists))
							
							$t:=String:C10(plist_toObject($file.getText()).CFBundleIconFile.string)  // xxxxxx.icns
							
							If (Length:C16($t)>0)
								
								If ($t#"@.icns")
									
									$t:=$t+".icns"
									
								End if 
								
								$file:=$folder.file($t)
								
								If ($file.exists)
									
									READ PICTURE FILE:C678($file.platformPath; $icon)
									
									If (Bool:C1537(OK))
										
										CONVERT PICTURE:C1002($icon; ".png")
										
									End if 
								End if 
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
	
	If (Picture size:C356($icon)>0)
		
		This:C1470.setIcon($icon)
		
	Else 
		
		// ERROR
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Update assets according to the target systems 
Function setIcon($picture : Picture)
	
	If (FEATURE.with("android"))
		
		If (Is macOS:C1572)
			
			If (Form:C1466.$ios)
				
				PROJECT.AppIconSet($picture)
				
			End if 
			
			If (Form:C1466.$android)
				
				PROJECT.AndroidIconSet($picture)
				
			End if 
			
		Else 
			
			PROJECT.AndroidIconSet($picture)
			
		End if 
		
	Else 
		
		PROJECT.AppIconSet($picture)
		
	End if 
	
	This:C1470.displayIcon()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Open the iOS icons folder
Function openAppleIconFolder
	
	SHOW ON DISK:C922(Form:C1466.$project.folder.folder("Assets.xcassets/AppIcon.appiconset").platformPath; *)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Open the iOS icons folder
Function openAndroidIconFolder
	
	SHOW ON DISK:C922(Form:C1466.$project.folder.folder("Android").platformPath; *)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Check the product name constraints
Function checkName($name : Text)
	
	var $length : Integer
	var $e : Object
	
	$length:=Length:C16($name)
	$e:=FORM Event:C1606
	
	Case of 
			
			//______________________________________________________
		: ($length=0)\
			 & ($e.code=On After Edit:K2:43)
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: ($length=0)
			
			This:C1470.productNameAlert.alert("productNameIsMandatory")
			
			//%W-533.1
			//______________________________________________________
		: (Position:C15($name[[1]]; "\\!@#$%^&*-+=123456789")>0)
			//%W+533.1
			
			This:C1470.productNameAlert.alert("numbersOrSpecialCharactersAreNotAllowedInTheFirstPosition")
			
			//______________________________________________________
		: ($length<2)
			
			If ($e.code=On After Edit:K2:43)
				
				// NOTHING MORE TO DO
				
			Else 
				
				This:C1470.productNameAlert.alert("productNameCannotBeFewerThan2Characters")
				
			End if 
			
			//______________________________________________________
		: ($length>50)
			
			This:C1470.productNameAlert.alert("productNameCannotExceed50Characters")
			
			//______________________________________________________
		: ($length>23)
			
			This:C1470.productNameAlert.warning("productNameMustBeApproximately23CharactersOrLess")
			
			//______________________________________________________
		Else 
			
			This:C1470.productNameAlert.reset()
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === === 
	// Manage UI for the target
Function displayTarget
	
	If (Value type:C1509(Form:C1466.info.target)=Is collection:K8:32)
		
		This:C1470.ios.setValue(Form:C1466.info.target.indexOf("iOS")#-1)
		This:C1470.android.setValue(Form:C1466.info.target.indexOf("android")#-1)
		
	Else 
		
		This:C1470.ios.setValue(String:C10(Form:C1466.info.target)="iOS")
		This:C1470.android.setValue(String:C10(Form:C1466.info.target)="android")
		
	End if 
	
	//=========================================================
	//=                      OBSOLETE                         =
	//=========================================================
Function loadIcon
	
	If (Not:C34(FEATURE.with("android")))
		
		var $folder : 4D:C1709.Folder
		$folder:=Form:C1466._folder.folder("Assets.xcassets/AppIcon.appiconset")
		
		If (This:C1470.assets=Null:C1517)
			
			$folder.create()
			
			This:C1470.assets:=New object:C1471(\
				"root"; $folder.platformPath)
			
			This:C1470.assets.folder:=$folder
			
		End if 
		
		If (This:C1470.assets.icons=Null:C1517)\
			 | (This:C1470.assets.file=Null:C1517)
			
			var $file : 4D:C1709.File
			$file:=$folder.file("Contents.json")
			
			If ($file.exists)
				
				This:C1470.assets.icons:=JSON Parse:C1218($file.getText())
				
			End if 
		End if 
		
		This:C1470.displayIcon()
		
	End if 
	