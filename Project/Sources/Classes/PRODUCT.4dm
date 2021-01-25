/*===============================================
PRODUCTS pannel Class
===============================================*/
Class extends form

//________________________________________________________________
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
		
		// TARGET
		This:C1470.target:=cs:C1710.static.new("target.label")
		This:C1470.apple:=cs:C1710.button.new("ios")
		This:C1470.android:=cs:C1710.button.new("android")
		
		// Constraints definition
		ob_createPath(This:C1470.context; "constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=========================================================
	// Load the appiconset contents
Function loadIcon
	var $file : 4D:C1709.File
	var $folder : 4D:C1709.Folder
	
	If (Is macOS:C1572)
		
		If (FEATURE.with("wizards"))
			
			$folder:=PROJECT.$project.file.parent.folder("Assets.xcassets/AppIcon.appiconset")
			
		Else 
			
			// A "If" statement should never omit "Else" 
			$folder:=Form:C1466.$project.file.parent.folder("Assets.xcassets/AppIcon.appiconset")
			
		End if 
		
		If (This:C1470.assets=Null:C1517)
			
			$folder.create()
			
			//**********************************
			This:C1470.assets:=New object:C1471(\
				"root"; $folder.platformPath)
			
			This:C1470.assets.folder:=$folder
			
		End if 
		
		If (This:C1470.assets.icons=Null:C1517)\
			 | (This:C1470.assets.file=Null:C1517)
			
			$file:=$folder.file("Contents.json")
			
			If ($file.exists)
				
				This:C1470.assets.icons:=JSON Parse:C1218($file.getText())
				
			End if 
		End if 
		
		This:C1470.displayIcon()
		
	Else 
		
		// Path is relative to the project file
		$folder:=Form:C1466.$project.file.parent.folder("Assets.xcassets/AppIcon.appiconset")
		
		If (This:C1470.assets=Null:C1517)
			
			$folder.create()
			
			//**********************************
			This:C1470.assets:=New object:C1471(\
				"root"; $folder.platformPath)
			
			This:C1470.assets.folder:=$folder
			
		End if 
		
		If (This:C1470.assets.icons=Null:C1517)\
			 | (This:C1470.assets.file=Null:C1517)
			
			$file:=$folder.file("Contents.json")
			
			If (Asserted:C1132($file.exists))
				
				This:C1470.assets.icons:=JSON Parse:C1218($file.getText())
				
			End if 
		End if 
		
		This:C1470.displayIcon()
		
	End if 
	
	//=========================================================
	// Display the selected icon
Function displayIcon
	var $picture : Picture
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
	
	//=========================================================
	// Choose an icon file
Function browseIcon
	var $filter; $name : Text
	
	If (Is macOS:C1572)
		
		// Accept an image file or an app
		$filter:="public.image;.app"
		
	Else 
		
		// Image file only
		$filter:="public.image"
		
	End if 
	
	$name:=Select document:C905(8858; $filter; Get localized string:C991("selectAPictureOrAnApplication"); Use sheet window:K24:11)
	
	If (Bool:C1537(OK))
		
		This:C1470.getIcon(DOCUMENT)
		
	End if 
	
	//=========================================================
	// Retrieve icon from a pathname
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
			
			If (Is macOS:C1572)
				
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
				
			Else 
				
				ASSERT:C1129(False:C215)
				
			End if 
		End if 
	End if 
	
	If (Picture size:C356($icon)>0)
		
		This:C1470.setIcon($icon)
		
	Else 
		
		// ERROR
		
	End if 
	
	//=========================================================
	// Update asset & the form object
Function setIcon
	var $1 : Picture
	
	var $pixels : Real
	var $decimalSeparator; $t : Text
	var $blank; $icon; $picture : Picture
	var $height; $pos; $width : Integer
	var $content; $o : Object
	var $size : Real
	
	var $file : 4D:C1709.File
	
	$picture:=$1
	
	// Check size
	PICTURE PROPERTIES:C457($picture; $width; $height)
	
	If ($width>1024)\
		 | ($height>1024)
		
		CREATE THUMBNAIL:C679($picture; $picture; 1024; 1024; Scaled to fit prop centered:K6:6)
		PICTURE PROPERTIES:C457($picture; $width; $height)
		
	End if 
	
	// #96701 - Add a blank background
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/blanck.png").platformPath; $blank)
	COMBINE PICTURES:C987($picture; $blank; Superimposition:K61:10; $picture; (1024-$width)\2; (1024-$height)\2)
	
	$file:=This:C1470.assets.folder.file("Contents.json")
	
	// Create all sizes of icons & Update contents.json
	If (Not:C34($file.exists))
		
		File:C1566("/RESOURCES/default project/Assets.xcassets/AppIcon.appiconset/Contents.json").copyTo(This:C1470.assets.folder)
		
	End if 
	
	$content:=JSON Parse:C1218($file.getText())
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $decimalSeparator)
	
	For each ($o; $content.images)
		
		$t:=$o.size
		$pos:=Position:C15("x"; $o.size)
		
		If ($pos>0)
			
			$size:=Num:C11(Replace string:C233(Substring:C12($t; 1; $pos-1); "."; $decimalSeparator))
			$pixels:=$size*Num:C11($o.scale)
			
			CREATE THUMBNAIL:C679($picture; $icon; $pixels; $pixels; Scaled to fit prop centered:K6:6)
			
			$t:=$o.idiom+Replace string:C233(String:C10($size); $decimalSeparator; "")
			
			If ($o.scale#"1x")
				
				//%W-533.1
				$t:=$t+"@"+$o.scale[[1]]
				//%W+533.1
				
			End if 
			
			$t:=$t+".png"
			
			WRITE PICTURE FILE:C680(This:C1470.assets.root+$t; $icon; ".png")
			
		End if 
	End for each 
	
	If (This:C1470.assets.icons=Null:C1517)
		
		This:C1470.assets.icons:=New object:C1471
		
	End if 
	
	This:C1470.assets.icons.images:=$content.images
	
	TEXT TO DOCUMENT:C1237(This:C1470.assets.root+"Contents.json"; JSON Stringify:C1217($content; *))
	
	// Update form picture
	This:C1470.icon.setValue($picture)
	
	This:C1470.displayIcon()
	
	//=========================================================
	// Open the iOS icons folder
Function openAppleIconFolder
	
	SHOW ON DISK:C922(This:C1470.assets.folder.platformPath; *)
	
	//=========================================================
	// Open the iOS icons folder
Function openAndroidIconFolder
	
	ALERT:C41("We are going to doux 🤣")
	
	//=========================================================
	// Check the product name constraints
Function checkName
	var $1 : Text
	
	var $length : Integer
	var $e : Object
	
	$length:=Length:C16($1)
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
		: (Position:C15($1[[1]]; "\\!@#$%^&*-+=123456789")>0)
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
	
	//=========================================================
	// Manage UI for the target
Function displayTarget
	
	If (Value type:C1509(Form:C1466.info.target)=Is collection:K8:32)
		
		This:C1470.apple.setValue(Form:C1466.info.target.indexOf("iOS")#-1)
		This:C1470.android.setValue(Form:C1466.info.target.indexOf("android")#-1)
		
	Else 
		
		This:C1470.apple.setValue(String:C10(Form:C1466.info.target)="iOS")
		This:C1470.android.setValue(String:C10(Form:C1466.info.target)="android")
		
	End if 
	
	//=========================================================
	// Populate the target value into te project
Function setTarget
	
	var $android; $apple : Boolean
	
	$apple:=This:C1470.apple.getValue()
	$android:=This:C1470.android.getValue()
	
	If ($apple & $android)
		
		Form:C1466.info.target:=New collection:C1472("iOS"; "android")
		
	Else 
		
		If (Not:C34($android))
			
			// According to platform
			Form:C1466.info.target:=Choose:C955(Is macOS:C1572; "iOS"; "android")
			
		Else 
			
			Form:C1466.info.target:=Choose:C955($android; "android"; "iOS")
			
		End if 
	End if 
	
	PROJECT.save()
	
	This:C1470.displayTarget()
	
	If ($apple & Is macOS:C1572 & Not:C34(Bool:C1537(Form:C1466.$project.$xCode.ready)))\
		 | ($android & Not:C34(Bool:C1537(Form:C1466.$project.$studio.ready)))
		
		// Launch the verification of the development tools
		CALL WORKER:C1389(Form:C1466.$project.$worker; "editor_CHECK_INSTALLATION"; New object:C1471(\
			"caller"; Form:C1466.$project.$mainWindow; "project"; Form:C1466.$project))
		
	End if 