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

var $default; $node; $root; $t : Text
var $p : Picture
var $success : Boolean
var $i; $indx : Integer
var $x : Blob
var $error; $ƒ; $manifest; $o; $picker; $str : Object
var $c : Collection

var $template : 4D:C1709.Document
var $folder; $internal; $user : 4D:C1709.Folder
var $file : 4D:C1709.File
var $archive : 4D:C1709.ZipArchive
var $svg : cs:C1710.svg

ARRAY TEXT:C222($formsArray; 0)

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$t:=Folder:C1567(fk resources folder:K87:11).file("images/github.png").platformPath
	READ PICTURE FILE:C678($t; $p; *)
	
	$ƒ:=New object:C1471(\
		"type"; $1; \
		"cell"; New object:C1471("width"; 140; "height"; 180); \
		"icon"; New object:C1471("width"; 300; "height"; 300); \
		"forms"; New collection:C1472; \
		"dialog"; VIEWS_Handler(New object:C1471("action"; "init")); \
		"github"; $p\
		)
	
	$str:=_o_str
	
	// Load internal templates
	$internal:=path[$ƒ.type+"Forms"]()
	
	// Load the global manifest
	$manifest:=JSON Parse:C1218($internal.file("manifest.json").getText())
	$default:=String:C10($manifest.default)
	
	For each ($folder; $internal.folders())
		
		$success:=True:C214
		
		For each ($t; $manifest.mandatory) While ($success)
			
			$success:=$internal.folder($folder.name).file($t).exists
			
		End for each 
		
		If ($success)
			
			$ƒ.forms.push($folder.fullName)
			
		End if 
	End for each 
	
	// Search for templates into the host database
	$user:=path["host"+$ƒ.type+"Forms"]()
	
	If ($user.exists)
		
		$c:=New collection:C1472
		
		For each ($folder; $user.folders())
			
			$success:=True:C214
			
			For each ($t; $manifest.mandatory) While ($success)
				
				$success:=$user.folder($folder.name).file($t).exists
				
			End for each 
			
			If ($success)
				
				$c.push("/"+$folder.fullName)
				
			End if 
		End for each 
		
/***********************
START HIDING ERRORS
***********************/
		$error:=err.hide()
		
		// Add downloaded templates
		For each ($o; $user.files().query("extension = :1"; SHARED.archiveExtension))
			
			$archive:=ZIP Read archive:C1637($o)
			
			If ($archive#Null:C1517)
				
				$success:=True:C214
				
				For each ($t; $manifest.mandatory) While ($success)
					
					$success:=$archive.root.file($t).exists
					
				End for each 
				
				If ($success)
					
					$manifest:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
					$success:=($manifest#Null:C1517)
					
					If ($success)
						
						$success:=String:C10(JSON Parse:C1218($archive.root.file("manifest.json").getText()).type)=($ƒ.type+"form")
						
						If ($success)
							
							$c.push("/"+$o.fullName)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
		
/***********************
STOP HIDING ERRORS
***********************/
		$error.show()
		
		$ƒ.forms.combine($c)
		
	End if 
	
	// Sorting will put the downloaded models first
	$ƒ.forms:=$ƒ.forms.orderBy()
	
	COLLECTION TO ARRAY:C1562($ƒ.forms; $formsArray)
	
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
"celluleWidth"; $ƒ.cell.width; \
"celluleHeight"; $ƒ.cell.height; \
"offset"; 10; \
"thumbnailWidth"; $ƒ.icon.width; \
"noPicture"; Get localized string:C991("noMedia"); \
"tips"; True:C214; \
"background"; 0x00FFFFFF; \
"backgroundStroke"; UI.strokeColor; \
"promptColor"; 0x00FFFFFF; \
"promptBackColor"; UI.strokeColor; \
"hidePromptSeparator"; True:C214; \
"forceRedraw"; True:C214; \
"prompt"; $str.setText("selectAFormTemplateToUseAs").localized($ƒ.type); \
"selector"; $ƒ.type)

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
"cursor"; 9000; \
"tips"; "accessTheGithubRepository"))

/* Contextual menu */
$picker.contextual:=New object:C1471(\
"target"; $picker.infos; \
"formula"; Formula:C1597(tmpl_CONTEXTUAL))

$picker.vOffset:=155  // Offset of the background button

// List of forms used in this project
$picker.marked:=New collection:C1472

For each ($t; Form:C1466[$ƒ.type])
	
	$picker.marked.push(Form:C1466[$ƒ.type][$t].form)
	
End for each 

/***********************
START HIDING ERRORS
***********************/
$error:=err.hide()

For ($i; 1; Size of array:C274($formsArray); 1)
	
	CLEAR VARIABLE:C89($p)
	
	If ($formsArray{$i}[[1]]="/")
		
		$t:=Delete string:C232($formsArray{$i}; 1; 1)
		
		If (Path to object:C1547($formsArray{$i}).extension=SHARED.archiveExtension)  // Archive
			
			// Downloaded template
			$template:=$user.file($t)
			
		Else 
			
			// Database template
			$template:=$user.folder($t)
			
		End if 
		
	Else 
		
		// Internal template
		$template:=$internal.folder($formsArray{$i})
		
	End if 
	
	If ($template.extension=SHARED.archiveExtension)  // Archive
		
		$archive:=ZIP Read archive:C1637($template)
		
		If ($archive#Null:C1517)
			
			// Create image
			$svg:=cs:C1710.svg.new().dimensions($ƒ.cell.width; $ƒ.cell.height)
			
			// Put icon
			$x:=$archive.root.file("layoutIconx2.png").getContent()
			BLOB TO PICTURE:C682($x; $p)
			CLEAR VARIABLE:C89($x)
			$svg.imageEmbedded($p; "root").position(-8)
			
			// Get the manifest
			$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
			
			// Put text
			$svg.textArea($o.name; "root").position(0; $ƒ.cell.height-20)\
				.dimensions($ƒ.cell.width)\
				.fill("dimgray")\
				.alignment(Align center:K42:3)
			
			// Mark if used
			$o.used:=($picker.marked.indexOf($formsArray{$i})#-1)
			
			If ($o.used)
				
				$svg.fontStyle(Bold:K14:2)
				
			End if 
			
			// Add github icon
			$svg.imageEmbedded($ƒ.github; "root").position(1; 4)
			
			$picker.pictures.push($svg.picture())
			$picker.pathnames.push($formsArray{$i})
			$picker.helpTips.push($str.setText("tipsTemplate").localized(New collection:C1472(String:C10($template.fullName); String:C10($o.organization.login); String:C10($o.version))))
			$picker.infos.push($o)
			
		Else 
			
			// Invalid archive = ignore
			
		End if 
		
	Else 
		
		$template:=$template.file("template.svg")
		
		If ($template.exists)
			
			If ($template.parent.file("layoutIconx2.png").exists)  // Use media
				
				// Create image
				$svg:=cs:C1710.svg.new().dimensions($ƒ.cell.width; $ƒ.cell.height)
				
				// Media
				READ PICTURE FILE:C678($template.parent.file("layoutIconx2.png").platformPath; $p)
				$svg.imageEmbedded($p; "root").position(-8)
				
				// Title
				$t:=$formsArray{$i}
				
				If ($t[[1]]="/")  // Database template
					
					$t:=Delete string:C232($t; 1; 1)
					
				End if 
				
				// Put text
				$svg.textArea($template.parent.name; "root")\
					.position(0; $ƒ.cell.height-20)\
					.dimensions($ƒ.cell.width)\
					.fill("dimgray")\
					.alignment(Align center:K42:3)
				
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
					$file:=path.templates().file("template.css")
					
					If ($file.exists)
						
						$svg.styleSheet($file)
						
					End if 
					
					$p:=$svg.picture()
					CREATE THUMBNAIL:C679($p; $p; $ƒ.cell.width; $ƒ.cell.height)
					
				End if 
			End if 
			
			If ($i=$formsArray)
				
				// Put the default template at first position
				$picker.pictures.insert(0; $p)
				$picker.pathnames.insert(0; $formsArray{$i})
				$picker.helpTips.insert(0; Get localized string:C991("defaultTemplate"))
				$picker.infos.insert(0; Null:C1517)
				
			Else 
				
				$picker.pictures.push($p)
				$picker.pathnames.push($formsArray{$i})
				$picker.helpTips.push("")
				$picker.infos.push(Null:C1517)
				
			End if 
			
		Else 
			
			// Not a template folder = ignore
			
		End if 
	End if 
End for 

/***********************
STOP HIDING ERRORS
***********************/
$error.show()

// Put an "explore" button
$svg:=cs:C1710.svg.new().dimensions($ƒ.cell.width; $ƒ.cell.height)

// Media
READ PICTURE FILE:C678(File:C1566("/RESOURCES/templates/more-white@2x.png").platformPath; $p)
$svg.imageEmbedded($p).position(20; 30).dimensions(96)

// Put text
//$svg.textArea(Get localized string("explore"); "root").position(0; $ƒ.cell.height-20)\
		.dimensions($ƒ.cell.width)\
		.fill("dimgray")\
		.textAlignment(Align center)

// Put in second position
//$oPicker.pictures.insert(1;$svg.picture())
//$oPicker.pathnames.insert(1;Null)
//$oPicker.helpTips.insert(1;$str.setText("downloadMoreResources").localized($ƒ.type))
//$oPicker.infos.push(Null)

// Put at the end
$picker.pictures.push($svg.picture())
$picker.pathnames.push(Null:C1517)
$picker.helpTips.push($str.setText("downloadMoreResources").localized($ƒ.type))
$picker.infos.push(Null:C1517)


// Add 1 because the widget work with arrays
$indx:=$picker.pathnames.indexOf(String:C10(Form:C1466[$ƒ.type][$ƒ.dialog.$.tableNum()].form))+1
$picker.item:=Choose:C955($indx=0; 1; $indx)

// Display selector
$ƒ.dialog.form.call(New collection:C1472("pickerShow"; $picker))

// ----------------------------------------------------
// End