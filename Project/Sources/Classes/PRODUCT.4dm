Class extends panel

//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor
	
	Super:C1705(Formula:C1597(editor_CALLBACK).source)
	
	This:C1470.context:=Super:C1706.init()
	
	If (OB Is empty:C1297(This:C1470.context))
		
		This:C1470.init()
		
		// Constraints definition
		cs:C1710.ob.new(This:C1470.context).createPath("constraints.rules"; Is collection:K8:32)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	This:C1470.toBeInitialized:=False:C215
	
	This:C1470.input("productName"; "10_name")
	This:C1470.productNameAlert:=cs:C1710.attention.new("name.alert")
	
	This:C1470.input("productVersion"; "11_version")
	
	This:C1470.input("productID")
	
	This:C1470.input("productCopyright"; "30_copyright")
	
	This:C1470.widget("icon")
	This:C1470.button("iconAction")
	This:C1470.iconAlert:=cs:C1710.attention.new("icon.alert")
	
	var $group : cs:C1710.group
	$group:=This:C1470.group("dominantColor")
	This:C1470.formObject("color").addToGroup($group)
	This:C1470.formObject("colorBorder"; "color.border").addToGroup($group)
	This:C1470.formObject("colorLabel"; "color.label").addToGroup($group)
	This:C1470.button("colorButton"; "color.button").addToGroup($group)
	
	This:C1470.mainColor:=""
	This:C1470.iconColor:=Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		$e:=Super:C1706.handleEvents(On Load:K2:1; On Timer:K2:25; On Bound Variable Change:K2:52)
		
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				This:C1470.onLoad()
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				This:C1470.update()
				
				//______________________________________________________
			: ($e.code=On Bound Variable Change:K2:52)
				
				// Update UI
				This:C1470.refresh()
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//==============================================
			: (This:C1470.colorButton.catch($e; On Clicked:K2:4))
				
				This:C1470.doColorMenu()
				
				//==============================================
			: (This:C1470.productName.catch())
				
				Case of 
						
						//______________________________________________________
					: ($e.code=On After Edit:K2:43)
						
						This:C1470.checkName(Get edited text:C655)
						
						//______________________________________________________
					: ($e.code=On Data Change:K2:15)
						
						This:C1470.checkName(Form:C1466.product.name)
						
						// Update bundleIdentifier & navigationTitle
						Form:C1466.product.bundleIdentifier:=Form:C1466.organization.id+"."+formatString("bundleApp"; Form:C1466.product.name)
						Form:C1466.main.navigationTitle:=Form:C1466.product.name
						
						//______________________________________________________
				End case 
				
				//==============================================
			: (This:C1470.icon.catch())
				
				// ❗️MANAGED INTO OBJECT METHOD BECAUSE OF THE DRAG AND DROP
				
				//==============================================
			: (This:C1470.iconAction.catch($e; On Clicked:K2:4))
				
				This:C1470.doIconMenu()
				
				//________________________________________
		End case 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function onLoad()
	
	If (PROJECT.ui.dominantColor#Null:C1517)
		
		This:C1470.mainColor:=cs:C1710.color.new(PROJECT.ui.dominantColor).main
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function update()
	
	This:C1470.checkName(Form:C1466.product.name)
	This:C1470.displayIcon()
	
	This:C1470.color.setColors(This:C1470.mainColor; This:C1470.mainColor)
	
	If (This:C1470.iconColor=Null:C1517)
		
		This:C1470.iconColor:=cs:C1710.color.new(cs:C1710.bmp.new(OBJECT Get value:C1743("icon")).getDominantColor()).main
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doColorMenu()
	
	var $color : cs:C1710.color
	var $menu : cs:C1710.menu
	
	$menu:=cs:C1710.menu.new()\
		.append("useTheSystemColorSelector"; "picker")\
		.append("useTheMainColorOfTheIcon"; "fromIcon").enable(cs:C1710.color.new(This:C1470.mainColor).main#Num:C11(This:C1470.iconColor))\
		.popup(This:C1470.colorBorder)
	
	If ($menu.selected)
		
		Case of 
				
				//________________________
			: ($menu.choice="picker")
				
				$color:=cs:C1710.color.new(Select RGB color:C956(This:C1470.mainColor))
				
				//________________________
			: ($menu.choice="fromIcon")
				
				$color:=cs:C1710.color.new(cs:C1710.bmp.new(OBJECT Get value:C1743("icon")).getDominantColor())
				This:C1470.iconColor:=$color.main
				
/*//________________________
// Not validated by PO because new feature could add a more consequente panel
// With other ways to enter css color, maybe feature flag for dev, deactivate it
//________________________________________
: ($menu.choice="_o_cssColor")
var $requested : Text
$requested:=Request(Get localized string("enterAWebColor"))
If (Length($requested)>0)
$color:=cs.color.new($requested)
If ($color.isValid())
This.iconColor:=$color.main
Else
ALERT(Get localized string("invalidWebColor"))
End if
End if
*/
				
				//________________________
		End case 
		
		If ($color#Null:C1517)
			
			If ($color.isValid())
				
				This:C1470.mainColor:=$color.main
				PROJECT.ui.dominantColor:=$color.css.components
				PROJECT.save()
				
				This:C1470.color.setColors(This:C1470.mainColor; This:C1470.mainColor)
				
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
Function doIcon()->$allow : Integer
	
	var $p : Picture
	var $e : Object
	
	$allow:=-1
	$e:=This:C1470.event
	
	Case of 
			
			//______________________________________________________
		: ($e.code=On Getting Focus:K2:7)
			
			This:C1470.iconAction.show()
			
			//______________________________________________________
		: ($e.code=On Losing Focus:K2:8)
			
			This:C1470.iconAction.hide()
			
			//______________________________________________________
		: ($e.code=On Double Clicked:K2:5)
			
			This:C1470.browseIcon()
			
			//______________________________________________________
		: ($e.code=On Drag Over:K2:13)
			
			GET PICTURE FROM PASTEBOARD:C522($p)
			
			If (Not:C34(Bool:C1537(OK)))
				
				// Alllow pictures
				DOCUMENT:=Get file from pasteboard:C976(1)
				
				If (Length:C16(DOCUMENT)>0)
					
					OK:=Num:C11(Is picture file:C1113(DOCUMENT))
					
					If ((OK=0) && Is macOS:C1572)
						
						// Accept applications
						OK:=Num:C11(Path to object:C1547(DOCUMENT).extension=".app")
						
					End if 
				End if 
			End if 
			
			If (Bool:C1537(OK))
				
				$allow:=0
				
			End if 
			
			//______________________________________________________
		: ($e.code=On Drop:K2:12)
			
			GET PICTURE FROM PASTEBOARD:C522($p)
			
			If (Bool:C1537(OK))
				
				This:C1470.setIcon($p)
				
			Else 
				
				DOCUMENT:=Get file from pasteboard:C976(1)
				
				If (Length:C16(DOCUMENT)>0)
					
					This:C1470.getIcon(DOCUMENT)
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Manage the icon's action button
Function doIconMenu()
	
	var $p : Picture
	var $menu : Object
	
	
	$menu:=cs:C1710.menu.new()
	
	$menu.append("CommonMenuItemPaste"; "setIcon")
	GET PICTURE FROM PASTEBOARD:C522($p)
	$menu.enable(Bool:C1537(OK))
	
	$menu.line()
	$menu.append("browse"; "browseIcon")
	$menu.line()
	
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
	
	$menu.popup()
	
	If ($menu.selected)
		
		If ($menu.choice="setIcon")
			
			This:C1470.setIcon($p)
			
		Else 
			
			This:C1470[$menu.choice]()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Display the App icon
Function displayIcon
	
	var $picture : Picture
	var $folder : 4D:C1709.Folder
	
	$folder:=Form:C1466._folder.folder("Assets.xcassets/AppIcon.appiconset")
	
	If ($folder.exists)
		
		READ PICTURE FILE:C678($folder.file("ios-marketing1024.png").platformPath; $picture)
		
	Else 
		
		$folder:=Form:C1466._folder.folder("Android")
		
		If ($folder.exists)
			
			READ PICTURE FILE:C678($folder.file("main/ic_launcher-playstore.png").platformPath; $picture)
			
		Else 
			
			READ PICTURE FILE:C678(EDITOR.errorIcon; $picture)
			
		End if 
	End if 
	
	This:C1470.icon.setValue($picture)
	
	If (String:C10(This:C1470.mainColor)="")
		
		This:C1470.mainColor:=cs:C1710.color.new(cs:C1710.bmp.new($picture).getDominantColor()).css.components
		PROJECT.ui.dominantColor:=This:C1470.mainColor
		PROJECT.save()
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === ===
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
							
							$t:=cs:C1710.plist.new($file).get("CFBundleIconFile")
							
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
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Update assets according to the target systems
Function setIcon($picture : Picture)
	
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
	
	This:C1470.iconColor:=cs:C1710.color.new(cs:C1710.bmp.new($picture).getDominantColor()).css.components
	This:C1470.refresh()
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Open the iOS icons folder
Function openAppleIconFolder
	
	SHOW ON DISK:C922(PROJECT._folder.folder("Assets.xcassets/AppIcon.appiconset").platformPath; *)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
	// Open the iOS icons folder
Function openAndroidIconFolder
	
	SHOW ON DISK:C922(PROJECT._folder.folder("Android").platformPath; *)
	
	//=== === === === === === === === === === === === === === === === === === === === ===
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
	