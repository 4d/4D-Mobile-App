//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : views_LAYOUT_PICKER
// ID[F73301CBEEE042CEAD2D2D1CEBB4C9E5]
// Created 11-1-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $1 : Text

If (False:C215)
	C_TEXT:C284(views_LAYOUT_PICKER; $1)
End if 

var $default; $fileName; $t : Text
var $p : Picture
var $forAndroidOnly; $forIosOnly; $isSelected; $success : Boolean
var $i; $indx : Integer
var $x : Blob
var $data; $manifest; $o; $picker; $template : Object
var $c : Collection
var $error : cs:C1710.error
var $folder; $internal; $userTemplates : 4D:C1709.Folder
var $zip : 4D:C1709.ZipArchive
var $str : cs:C1710.str
var $svg : cs:C1710.svg
var $tmpl : cs:C1710.tmpl

ARRAY TEXT:C222($formsArray; 0x0000)

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/github.png").platformPath; $p; *)
	
	$data:=New object:C1471(\
		"type"; $1; \
		"cell"; New object:C1471("width"; 140; "height"; 180); \
		"icon"; New object:C1471("width"; 300; "height"; 300); \
		"forms"; New collection:C1472; \
		"dialog"; VIEWS_Handler(New object:C1471("action"; "init")); \
		"github"; $p\
		)
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/images/more.png").platformPath; $p; *)
	$data.morePicture:=$p
	
	$str:=cs:C1710.str.new()
	$error:=cs:C1710.error.new()
	
	// Load internal templates
	$internal:=cs:C1710.path.new()[$data.type+"Forms"]()
	
	// Load the global manifest
	$manifest:=JSON Parse:C1218($internal.file("manifest.json").getText())
	$default:=String:C10($manifest.default)
	
	// WE ASSUME THAT OUR TEMPLATES ARE WELL-FORMED 😇
	
	$forIosOnly:=Not:C34(Form:C1466.$android)
	$forAndroidOnly:=Not:C34(Form:C1466.$ios)
	
	For each ($folder; $internal.folders())
		
		$tmpl:=cs:C1710.tmpl.new($folder.fullName; $data.type)
		
		Case of 
				
				//______________________________________________________
			: ($forIosOnly & $tmpl.ios)
				
				$data.forms.push($folder.fullName)
				
				//______________________________________________________
			: ($forAndroidOnly & $tmpl.android)
				
				$data.forms.push($folder.fullName)
				
				//______________________________________________________
			: ($tmpl.ios & $tmpl.android)
				
				$data.forms.push($folder.fullName)
				
				//______________________________________________________
		End case 
	End for each 
	
	// Search for templates into the host database
	$userTemplates:=cs:C1710.path.new()["host"+$data.type+"Forms"]()
	
	If ($userTemplates.exists)
		
		$c:=New collection:C1472
		
		For each ($folder; $userTemplates.folders())
			
			$success:=True:C214
			
			$tmpl:=cs:C1710.tmpl.new("/"+$folder.fullName; $data.type)
			
			Case of 
					
					//______________________________________________________
				: ($forIosOnly & $tmpl.ios)
					
					For each ($fileName; $manifest.mandatory) While ($success)
						
						$success:=$userTemplates.folder($folder.name).file($fileName).exists\
							 || $userTemplates.folder($folder.name).folder("ios").file($fileName).exists
						
					End for each 
					
					//______________________________________________________
				: ($forAndroidOnly & $tmpl.android)
					
					$success:=$userTemplates.folder($folder.name).file("app/src/main/res/layout/layout.xml").exists\
						 || $userTemplates.folder($folder.name).folder("android").file("app/src/main/res/layout/layout.xml").exists
					
					//______________________________________________________
				: ($tmpl.ios & $tmpl.android)
					
					For each ($fileName; $manifest.mandatory) While ($success)
						
						$success:=$userTemplates.folder($folder.name).file($fileName).exists\
							 || $userTemplates.folder($folder.name).folder("ios").file($fileName).exists
						
					End for each 
					
					$success:=$success & $userTemplates.folder($folder.name).file("app/src/main/res/layout/layout.xml").exists\
						 || $userTemplates.folder($folder.name).folder("android").file("app/src/main/res/layout/layout.xml").exists
					
					//______________________________________________________
				Else 
					
					$success:=False:C215
					
					//______________________________________________________
			End case 
			
			If ($success)
				
				$c.push("/"+$folder.fullName)
				
			End if 
		End for each 
		
		$error.hide()  // <- START HIDING ERRORS
		
		// Add downloaded templates
		For each ($template; $userTemplates.files().query("extension = :1"; SHARED.archiveExtension))
			
			$zip:=ZIP Read archive:C1637($template)
			
			If ($zip#Null:C1517)
				
				$success:=True:C214
				
				$tmpl:=cs:C1710.tmpl.new("/"+$zip.root.name+".zip"; $data.type)
				
				Case of 
						
						//______________________________________________________
					: ($forIosOnly & $tmpl.ios)
						
						For each ($t; $manifest.mandatory) While ($success)
							
							$success:=$zip.root.file($t).exists | \
								$zip.root.folder("ios").file($t).exists
							
						End for each 
						
						//______________________________________________________
					: ($forAndroidOnly & $tmpl.android)
						
						$success:=$zip.root.file("app/src/main/res/layout/layout.xml").exists | \
							$zip.root.folder("android").file("app/src/main/res/layout/layout.xml").exists
						
						//______________________________________________________
					: ($tmpl.ios & $tmpl.android)
						
						For each ($t; $manifest.mandatory) While ($success)
							
							$success:=$zip.root.file($t).exists | \
								$zip.root.folder("ios").file($t).exists
							
						End for each 
						
						$success:=$success & $zip.root.file("app/src/main/res/layout/layout.xml").exists | \
							$zip.root.folder("android").file("app/src/main/res/layout/layout.xml").exists
						
						//______________________________________________________
					Else 
						
						$success:=False:C215
						
						//______________________________________________________
				End case 
				
				If ($success)
					
					$c.push("/"+$template.fullName)
					
				End if 
			End if 
		End for each 
		
		$error.show()  // <- STOP HIDING ERRORS
		
		$data.forms.combine($c)
		
	End if 
	
	// Sorting will put the downloaded models first
	$data.forms:=$data.forms.orderBy()
	
	COLLECTION TO ARRAY:C1562($data.forms; $formsArray)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// Find the default template & keep its index
$formsArray{0}:=$default
$formsArray:=Find in array:C230($formsArray; $formsArray{0})

$picker:=New object:C1471(\
"action"; "forms"; \
"pictures"; New collection:C1472; \
"pathnames"; New collection:C1472; \
"helpTips"; New collection:C1472; \
"infos"; New collection:C1472; \
"celluleWidth"; $data.cell.width; \
"celluleHeight"; $data.cell.height; \
"offset"; 10; \
"thumbnailWidth"; $data.icon.width; \
"noPicture"; Get localized string:C991("noMedia"); \
"tips"; True:C214; \
"background"; Choose:C955(UI.darkScheme; 0x0000; 0x00FFFFFF); \
"backgroundStroke"; UI.strokeColor; \
"prompt"; $str.setText("selectAFormTemplateToUseAs").localized($data.type); \
"promptColor"; 0x00FFFFFF; \
"promptBackColor"; UI.strokeColor; \
"hidePromptSeparator"; True:C214; \
"forceRedraw"; True:C214; \
"selector"; $data.type)

/* Hot zones definition */
$picker.hotZones:=New collection:C1472

// github icon
$picker.hotZones.push(New object:C1471(\
"left"; 8; \
"top"; 8; \
"width"; 16; \
"height"; 16; \
"target"; $picker.infos; \
"formula"; Formula:C1597(tmpl_INFOS); \
"cursor"; 9015))

/* Contextual menu */
$picker.contextual:=New object:C1471(\
"target"; $picker.infos; \
"formula"; Formula:C1597(tmpl_CONTEXTUAL))

$picker.vOffset:=155  // Offset of the background button

// List of forms used in this project
$picker.marked:=New collection:C1472

For each ($t; Form:C1466[$data.type])
	
	$picker.marked.push(Form:C1466[$data.type][$t].form)
	
End for each 

$error.hide()  // <- START HIDING ERRORS

For ($i; 1; Size of array:C274($formsArray); 1)
	
	CLEAR VARIABLE:C89($p)
	
	If (PROJECT.isCustomResource($formsArray{$i}[[1]]))
		
		$t:=Delete string:C232($formsArray{$i}; 1; 1)
		
		If (Path to object:C1547($formsArray{$i}).extension=SHARED.archiveExtension)  // Archive
			
			// Downloaded template
			$template:=$userTemplates.file($t)
			
		Else 
			
			// Database template
			$template:=$userTemplates.folder($t)
			
		End if 
		
	Else 
		
		// Internal template
		$template:=$internal.folder($formsArray{$i})
		
	End if 
	
	$isSelected:=(String:C10(Form:C1466.$dialog[Current form name:C1298].template.sources.fullName)=$template.fullName)
	
	If ($template.extension=SHARED.archiveExtension)  // Archive
		
		$zip:=ZIP Read archive:C1637($template)
		
		If ($zip#Null:C1517)
			
			// Create image
			$svg:=cs:C1710.svg.new().size($data.cell.width; $data.cell.height)
			
			If ($isSelected)  //selected
				
				If (UI.darkScheme)
					
					$svg.rect($data.cell.width-6; $data.cell.height-3)\
						.position(5; 2)\
						.stroke(UI.colors.strokeColor.css.hexLong)\
						.fill("#0D3648")\
						.radius(10)
					
				Else 
					
					$svg.rect($data.cell.width-6; $data.cell.height-3)\
						.position(5; 2)\
						.stroke(UI.colors.strokeColor.css.hexLong)\
						.fill(UI.colors.backgroundSelectedColor.css.hexLong)\
						.radius(10)
					
				End if 
			End if 
			
			// Put icon
			$x:=$zip.root.file("layoutIconx2.png").getContent()
			BLOB TO PICTURE:C682($x; $p)
			CLEAR VARIABLE:C89($x)
			$svg.image($p).moveHorizontally(-8)
			
			// Get the manifest
			$o:=JSON Parse:C1218($zip.root.file("manifest.json").getText())
			
			If (Feature.with("duplicateTemplate"))
				
				$o.file:=$template  // Will activate menu to show on disk or duplicate
				
			End if 
			
			If ($o.homepage#Null:C1517)  // See tmpl_INFOS
				
				$o.tips:="accessTheGithubRepository"
				$o.formula:=Formula:C1597(tmpl_INFOS)
				
			Else 
				
				$o.formula:=Formula:C1597(tmpl_CONTEXTUAL)
				
			End if 
			
			// Put text
			$svg.textArea($o.name; "root")\
				.position(0; $data.cell.height-20)\
				.width($data.cell.width)\
				.fill(Choose:C955(UI.darkScheme; Choose:C955($isSelected; "dimgray"; "white"); "dimgray"))\
				.alignment(Align center:K42:3)\
				.fontStyle(Choose:C955($isSelected; Bold:K14:2; Normal:K14:15))
			
			// Mark if used
			$o.used:=($picker.marked.indexOf($formsArray{$i})#-1)
			
			If ($o.used)
				
				$svg.fontStyle(Bold:K14:2)
				
			End if 
			
			// Add github icon
			$svg.image($data.github)\
				.position(Choose:C955($picker.selector="list"; 10; 5); Choose:C955($picker.selector="list"; 4; 12))
			
			$picker.pictures.push($svg.picture())
			$picker.pathnames.push($formsArray{$i})
			$picker.helpTips.push($str.setText("tipsTemplate").localized(New collection:C1472(String:C10($template.fullName); String:C10($o.organization.login); String:C10($o.version))))
			$picker.infos.push($o)
			
		Else 
			
			// Invalid archive = ignore
			
		End if 
		
	Else 
		
		$o:=Null:C1517  // Import to reset to not pass to next template
		
		If (Feature.with("duplicateTemplate"))
			
			If ($template.file("manifest.json").exists)
				
				$o:=JSON Parse:C1218($template.file("manifest.json").getText())
				$o.file:=$template
				
				If ($o.homepage#Null:C1517)  // See tmpl_INFOS
					
					$o.tips:="accessTheGithubRepository"
					$o.formula:=Formula:C1597(tmpl_INFOS)
					
				Else 
					
					$o.formula:=Formula:C1597(tmpl_CONTEXTUAL)
					
				End if 
			End if 
		End if 
		
		$template:=$template.file("template.svg")
		
		If ($template.exists)
			
			If ($template.parent.file("layoutIconx2.png").exists)  // Use media
				
				// Create image
				$svg:=cs:C1710.svg.new().size($data.cell.width; $data.cell.height)
				
				If ($isSelected)  //selected
					
					If (UI.darkScheme)
						
						$svg.rect($data.cell.width-6; $data.cell.height-3)\
							.position(5; 2)\
							.stroke(UI.colors.strokeColor.css.hexLong)\
							.fill("#0D3648")\
							.radius(10)
						
					Else 
						
						$svg.rect($data.cell.width-6; $data.cell.height-3)\
							.position(5; 2)\
							.stroke(UI.colors.strokeColor.css.hexLong)\
							.fill(UI.colors.backgroundSelectedColor.css.hexLong)\
							.radius(10)
						
					End if 
				End if 
				
				// Media
				READ PICTURE FILE:C678($template.parent.file("layoutIconx2.png").platformPath; $p)
				$svg.image($p).moveHorizontally(-8)
				
				// Title
				$t:=$formsArray{$i}
				
				If (PROJECT.isCustomResource($t))  // Database template
					
					$t:=Delete string:C232($t; 1; 1)
					
				End if 
				
				If (Feature.with("duplicateTemplate"))
					
					$o.used:=($picker.marked.indexOf($formsArray{$i})#-1)
					If ($o.used)
						
						$svg.fontStyle(Bold:K14:2)
						
					End if 
					
					$svg.image($data.morePicture)\
						.position(Choose:C955($picker.selector="list"; 10; 5); Choose:C955($picker.selector="list"; 4; 12))
					
				End if 
				
				// Put text
				$svg.textArea($template.parent.name; "root")\
					.position(0; $data.cell.height-20)\
					.size($data.cell.width)\
					.fill(Choose:C955(UI.darkScheme; Choose:C955($isSelected; "white"; "white"); "dimgray"))\
					.alignment(Align center:K42:3)\
					.fontStyle(Choose:C955($isSelected; Bold:K14:2; Normal:K14:15))
				
				// Mark if used
				If ($picker.marked.indexOf($formsArray{$i})#-1)
					
					$svg.fontStyle(Bold:K14:2)
					
				End if 
				
				$p:=$svg.picture()
				
			Else   // Create a preview from the template
				
				PROCESS 4D TAGS:C816($template.getText(); $t)
				
				$svg:=cs:C1710.svg.new().parse($t)
				
				If ($svg.success)
					
					// Add the css reference
					$svg.styleSheet(Choose:C955(UI.darkScheme; File:C1566("/RESOURCES/css/template_dark.css"); File:C1566("/RESOURCES/css/template.css")))
					
					$p:=$svg.picture()
					CREATE THUMBNAIL:C679($p; $p; $data.cell.width; $data.cell.height-40)
					
					$svg:=cs:C1710.svg.new().size($data.cell.width; $data.cell.height)
					
					If ($isSelected)  //selected
						
						If (UI.darkScheme)
							
							$svg.rect($data.cell.width-6; $data.cell.height-3)\
								.position(5; 2)\
								.stroke(UI.colors.strokeColor.css.hexLong)\
								.fill("#0D3648")\
								.radius(10)
							
						Else 
							
							$svg.rect($data.cell.width-6; $data.cell.height-3)\
								.position(5; 2)\
								.stroke(UI.colors.strokeColor.css.hexLong)\
								.fill(UI.colors.backgroundSelectedColor.css.hexLong)\
								.radius(10)
							
						End if 
					End if 
					
					$svg.image($p).y(10)  //.moveH(-5)
					
					// Put text
					$svg.textArea($template.name; "root")\
						.position(0; $data.cell.height-20)\
						.size($data.cell.width)\
						.fill(Choose:C955(UI.darkScheme; Choose:C955($isSelected; "dimgray"; "white"); "dimgray"))\
						.alignment(Align center:K42:3)\
						.fontStyle(Choose:C955($isSelected; Bold:K14:2; Normal:K14:15))
					
					$p:=$svg.picture()
					
				End if 
			End if 
			
			If ($i=$formsArray)
				
				// Put the default template at first position
				$picker.pictures.insert(0; $p)
				$picker.pathnames.insert(0; $formsArray{$i})
				$picker.helpTips.insert(0; Get localized string:C991("defaultTemplate"))
				$picker.infos.insert(0; $o)
				
			Else 
				
				$picker.pictures.push($p)
				$picker.pathnames.push($formsArray{$i})
				$picker.helpTips.push("")
				$picker.infos.push($o)
				
			End if 
			
		Else 
			
			// Not a template folder = ignore
			
		End if 
	End if 
End for 

$error.show()  // <- STOP HIDING ERRORS

// Put an "explore" button
$svg:=cs:C1710.svg.new().size($data.cell.width; $data.cell.height)

// Media
If (UI.darkScheme)
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/templates/more_dark@2x.png").platformPath; $p)
	
Else 
	
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/templates/more@2x.png").platformPath; $p)
	
End if 

$svg.image($p).position(20; 30).size(96)

// Put text
/*
$svg.textArea(Get localized string("explore"); "root").position(0; $ƒ.cell.height-20)\
.dimensions($data.cell.width)\
.fill("dimgray")\
.textAlignment(Align center)
*/

// Put in second position
/*
$oPicker.pictures.insert(1;$svg.picture())
$oPicker.pathnames.insert(1;Null)
$oPicker.helpTips.insert(1;$str.setText("downloadMoreResources").localized($ƒ.type))
$oPicker.infos.push(Null)
*/

$o:=New object:C1471("type"; "more"; "data"; $data)

// Put at the end
$picker.pictures.push($svg.picture())
$picker.pathnames.push(Null:C1517)
$picker.helpTips.push($str.setText("downloadMoreResources").localized($data.type))
$picker.infos.push($o)

$picker.hideSelection:=True:C214  // The selected item is already highlighted

// Add 1 because the widget work with arrays
$indx:=$picker.pathnames.indexOf(String:C10(Form:C1466[$data.type][$data.dialog.$.tableNum()].form))+1
$picker.item:=Choose:C955($indx=0; 1; $indx)

// Display selector
$data.dialog.form.call(New collection:C1472("pickerShow"; $picker))

// ----------------------------------------------------
// End