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
C_TEXT:C284($1)

C_BLOB:C604($x)
C_BOOLEAN:C305($success)
C_LONGINT:C283($i;$indx)
C_PICTURE:C286($p)
C_TEXT:C284($dom;$root;$t;$tDefault)
C_OBJECT:C1216($archive;$error;$folderComponent;$folderDatabase;$ƒ;$o)
C_OBJECT:C1216($oManifest;$oPicker;$pathTemplate;$str;$svg)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_forms;0)

If (False:C215)
	C_TEXT:C284(views_LAYOUT_PICKER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	$t:=Folder:C1567(fk resources folder:K87:11).file("images/github.png").platformPath
	READ PICTURE FILE:C678($t;$p;*)
	
	$ƒ:=New object:C1471(\
		"type";$1;\
		"cell";New object:C1471("width";140;"height";180);\
		"icon";New object:C1471("width";300;"height";300);\
		"forms";New collection:C1472;\
		"dialog";VIEWS_Handler (New object:C1471("action";"init"));\
		"github";$p\
		)
	
	$str:=str 
	
	  // Load internal templates
	$folderComponent:=path [$ƒ.type+"Forms"]()
	
	  // Load the global manifest
	$oManifest:=JSON Parse:C1218($folderComponent.file("manifest.json").getText())
	$tDefault:=String:C10($oManifest.default)
	
	For each ($o;$folderComponent.folders())
		
		$success:=True:C214
		
		For each ($t;$oManifest.mandatory) While ($success)
			
			$success:=$folderComponent.folder($o.name).file($t).exists
			
		End for each 
		
		If ($success)
			
			$ƒ.forms.push($o.fullName)
			
		End if 
	End for each 
	
	  // Search for templates into the host database
	$folderDatabase:=path ["host"+$ƒ.type+"Forms"]()
	
	If ($folderDatabase.exists)
		
		$c:=New collection:C1472
		
		For each ($o;$folderDatabase.folders())
			
			$success:=True:C214
			
			For each ($t;$oManifest.mandatory) While ($success)
				
				$success:=$folderDatabase.folder($o.name).file($t).exists
				
			End for each 
			
			If ($success)
				
				$c.push("/"+$o.fullName)
				
			End if 
		End for each 
		
		If (feature.with("resourcesBrowser"))
			
/***********************
START HIDING ERRORS
***********************/
			$error:=err .hide()
			
			  // Add downloaded templates
			For each ($o;$folderDatabase.files().query("extension = :1";SHARED.archiveExtension))
				
				$archive:=ZIP Read archive:C1637($o)
				
				If ($archive#Null:C1517)
					
					$success:=True:C214
					
					For each ($t;$oManifest.mandatory) While ($success)
						
						$success:=$archive.root.file($t).exists
						
					End for each 
					
					If ($success)
						
						$oManifest:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
						$success:=($oManifest#Null:C1517)
						
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
			
		End if 
		
		$ƒ.forms.combine($c)
		
	End if 
	
	  // Sorting will put the downloaded models first
	$ƒ.forms:=$ƒ.forms.orderBy()
	
	COLLECTION TO ARRAY:C1562($ƒ.forms;$tTxt_forms)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Find the default template & keep its index
$tTxt_forms{0}:=$tDefault
$tTxt_forms:=Find in array:C230($tTxt_forms;$tTxt_forms{0})

$oPicker:=New object:C1471(\
"action";"forms";\
"pictures";New collection:C1472;\
"pathnames";New collection:C1472;\
"helpTips";New collection:C1472;\
"infos";New collection:C1472;\
"celluleWidth";$ƒ.cell.width;\
"celluleHeight";$ƒ.cell.height;\
"offset";10;\
"thumbnailWidth";$ƒ.icon.width;\
"noPicture";Get localized string:C991("noMedia");\
"tips";True:C214;\
"background";0x00FFFFFF;\
"backgroundStroke";ui.strokeColor;\
"promptColor";0x00FFFFFF;\
"promptBackColor";ui.strokeColor;\
"hidePromptSeparator";True:C214;\
"forceRedraw";True:C214;\
"prompt";$str.setText("selectAFormTemplateToUseAs").localized($ƒ.type);\
"selector";$ƒ.type)

If (feature.with("resourcesBrowser"))
	
/* Hot zones definition */
	$oPicker.hotZones:=New collection:C1472
	
	  // github icon
	$oPicker.hotZones.push(New object:C1471(\
		"left";8;\
		"top";8;\
		"width";16;\
		"height";16;\
		"target";$oPicker.infos;\
		"formula";Formula:C1597(tmpl_INFOS );\
		"cursor";9000;\
		"tips";"accessTheGithubRepository"))
	
/* Contextual menu */
	$oPicker.contextual:=New object:C1471(\
		"target";$oPicker.infos;\
		"formula";Formula:C1597(tmpl_CONTEXTUAL ))
	
End if 

$oPicker.vOffset:=155  // Offset of the background button

  // List of forms used in this project
$oPicker.marked:=New collection:C1472

For each ($t;Form:C1466[$ƒ.type])
	
	$oPicker.marked.push(Form:C1466[$ƒ.type][$t].form)
	
End for each 

/***********************
START HIDING ERRORS
***********************/
$error:=err .hide()

For ($i;1;Size of array:C274($tTxt_forms);1)
	
	CLEAR VARIABLE:C89($p)
	
	If ($tTxt_forms{$i}[[1]]="/")
		
		$t:=Delete string:C232($tTxt_forms{$i};1;1)
		
		If (feature.with("resourcesBrowser"))
			
			If (Path to object:C1547($tTxt_forms{$i}).extension=SHARED.archiveExtension)  // Archive
				
				  // Downloaded template
				$pathTemplate:=$folderDatabase.file($t)
				
			Else 
				
				  // Database template
				$pathTemplate:=$folderDatabase.folder($t)
				
			End if 
			
		Else 
			
			  // Database template
			$pathTemplate:=$folderDatabase.folder($t)
			
		End if 
		
	Else 
		
		  // Internal template
		$pathTemplate:=$folderComponent.folder($tTxt_forms{$i})
		
	End if 
	
	If ($pathTemplate.extension=SHARED.archiveExtension)  // Archive
		
		$archive:=ZIP Read archive:C1637($pathTemplate)
		
		If ($archive#Null:C1517)
			
			  // Create image
			$svg:=svg ().setDimensions($ƒ.cell.width;$ƒ.cell.height)
			
			  //$svg.rect(0;0;$ƒ.cell.width;$ƒ.cell.height).setStroke("grey")
			
			  // Put icon
			$x:=$archive.root.file("layoutIconx2.png").getContent()
			BLOB TO PICTURE:C682($x;$p)
			CLEAR VARIABLE:C89($x)
			$svg.embedPicture($p;-8)
			
			  // Get the manifest
			$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
			
			  // Put text
			$svg.textArea($o.name;0;$ƒ.cell.height-20)\
				.setDimensions($ƒ.cell.width)\
				.setFill("dimgray")\
				.setAttribute("text-align";"center")
			
			  // Mark if used
			$o.used:=($oPicker.marked.indexOf($tTxt_forms{$i})#-1)
			
			If ($o.used)
				
				$svg.setAttribute("font-weight";"bold")
				
			End if 
			
			  // Add github icon
			$svg.embedPicture($ƒ.github;1;4)  //.setDimensions(16)
			
			$oPicker.pictures.push($svg.getPicture())
			$oPicker.pathnames.push($tTxt_forms{$i})
			$oPicker.helpTips.push($str.setText("tipsTemplate").localized(New collection:C1472(String:C10($pathTemplate.fullName);String:C10($o.organization.login);String:C10($o.version))))
			$oPicker.infos.push($o)
			
		Else 
			
			  // Invalid archive = ignore
			
		End if 
		
	Else 
		
		$pathTemplate:=$pathTemplate.file("template.svg")
		
		If ($pathTemplate.exists)
			
			If ($pathTemplate.parent.file("layoutIconx2.png").exists)  // Use media
				
				  // Create image
				$svg:=svg .setDimensions($ƒ.cell.width;$ƒ.cell.height)
				
				  //$svg.rect(0;0;$ƒ.cell.width;$ƒ.cell.height).setStroke("red")
				
				  // Media
				READ PICTURE FILE:C678($pathTemplate.parent.file("layoutIconx2.png").platformPath;$p)
				$svg.embedPicture($p;-8;0)
				
				  // Title
				$t:=$tTxt_forms{$i}
				
				If ($t[[1]]="/")  // Database template
					
					$t:=Delete string:C232($t;1;1)
					
				End if 
				
				  // Put text
				$svg.textArea($pathTemplate.parent.name;0;$ƒ.cell.height-20)\
					.setDimensions($ƒ.cell.width)\
					.setFill("dimgray")\
					.setAttribute("text-align";"center")
				
				  // Mark if used
				If ($oPicker.marked.indexOf($tTxt_forms{$i})#-1)
					
					$svg.setAttribute("font-weight";"bold")
					
				End if 
				
				$p:=$svg.getPicture()
				
			Else   // Create from the template
				
				PROCESS 4D TAGS:C816($pathTemplate.getText();$t)
				
				$root:=DOM Parse XML variable:C720($t)
				
				If (OK=1)
					
					  // Add the css reference
					If (path .templates().file("template.css").exists)
						
						  //<?xml-stylesheet href="file://localhost/Users/vdl/Desktop/monstyle.css" type="text/css"?>
						$t:="xml-stylesheet type=\"text/css\" href=\""\
							+"file://localhost"+Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16);*)+"templates/template.css"\
							+"\""
						
						$dom:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088($root);XML processing instruction:K45:9;$t)
						
					End if 
					
					SVG EXPORT TO PICTURE:C1017($root;$p;Own XML data source:K45:18)
					CREATE THUMBNAIL:C679($p;$p;$ƒ.cell.width;$ƒ.cell.height)
					
				End if 
			End if 
			
			If ($i=$tTxt_forms)
				
				  // Put the default template at first position
				$oPicker.pictures.insert(0;$p)
				$oPicker.pathnames.insert(0;$tTxt_forms{$i})
				$oPicker.helpTips.insert(0;Get localized string:C991("defaultTemplate"))
				$oPicker.infos.insert(0;Null:C1517)
				
			Else 
				
				$oPicker.pictures.push($p)
				$oPicker.pathnames.push($tTxt_forms{$i})
				$oPicker.helpTips.push("")
				$oPicker.infos.push(Null:C1517)
				
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

If (feature.with("resourcesBrowser"))
	
	  // Put an "explore" button
	$svg:=svg .setDimensions($ƒ.cell.width;$ƒ.cell.height)
	
	  // Media
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/templates/more-white@2x.png").platformPath;$p)
	$svg.embedPicture($p;20;30).setDimensions(96)
	
	  // Put text
	  //$svg.textArea(Get localized string("explore");0;$ƒ.cell.height-20)\
										.setDimensions($ƒ.cell.width)\
										.setFill("dimgray")\
										.setAttribute("text-align";"center")
	
	  // Put in second position
	  //$oPicker.pictures.insert(1;$svg.getPicture())
	  //$oPicker.pathnames.insert(1;Null)
	  //$oPicker.helpTips.insert(1;$str.setText("downloadMoreResources").localized($ƒ.type))
	  //$oPicker.infos.push(Null)
	
	  // Put at the end
	$oPicker.pictures.push($svg.getPicture())
	$oPicker.pathnames.push(Null:C1517)
	$oPicker.helpTips.push($str.setText("downloadMoreResources").localized($ƒ.type))
	$oPicker.infos.push(Null:C1517)
	
End if 

  // Add 1 because the widget work with arrays
$indx:=$oPicker.pathnames.indexOf(String:C10(Form:C1466[$ƒ.type][$ƒ.dialog.$.tableNum()].form))+1
$oPicker.item:=Choose:C955($indx=0;1;$indx)

  // Display selector
$ƒ.dialog.form.call(New collection:C1472("pickerShow";$oPicker))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End