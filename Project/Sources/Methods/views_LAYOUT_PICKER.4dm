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
C_LONGINT:C283($i;$indx;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($dom;$t;$tProcessingInstruction)
C_OBJECT:C1216($archive;$errors;$folderComponent;$folderDatabase;$o;$oLocal)
C_OBJECT:C1216($oManifest;$oPicker;$pathTemplate;$svg)
C_COLLECTION:C1488($c)

ARRAY TEXT:C222($tTxt_forms;0)

If (False:C215)
	C_TEXT:C284(views_LAYOUT_PICKER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$oLocal:=New object:C1471(\
		"type";$1;\
		"cell";New object:C1471("width";140;"height";180);\
		"icon";New object:C1471("width";300;"height";300);\
		"forms";New collection:C1472;\
		"dialog";VIEWS_Handler (New object:C1471("action";"init"))\
		)
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // <NONE>
		
	End if 
	
	  // Load internal templates
	$folderComponent:=COMPONENT_Pathname ($oLocal.type+"Forms")
	
	  // Load the global manifest
	$oManifest:=JSON Parse:C1218($folderComponent.file("manifest.json").getText())
	
	For each ($o;$folderComponent.folders())
		
		$success:=True:C214
		
		For each ($t;$oManifest.mandatory) While ($success)
			
			$success:=$folderComponent.folder($o.name).file($t).exists
			
		End for each 
		
		If ($success)
			
			$oLocal.forms.push($o.fullName)
			
		End if 
	End for each 
	
	  // Search for templates into the host database
	$folderDatabase:=COMPONENT_Pathname ("host_"+$oLocal.type+"Forms")
	
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
		
		If (featuresFlags.with("resourcesBrowser"))
			
/* START HIDING ERRORS */$errors:=err .hide()
			
			  // Add downloaded templates
			For each ($o;$folderDatabase.files().query("extension = :1";commonValues.archiveExtension))
				
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
							
							$success:=String:C10(JSON Parse:C1218($archive.root.file("manifest.json").getText()).type)=($oLocal.type+"form")
							
							If ($success)
								
								$c.push("/"+$o.fullName)
								
							End if 
						End if 
					End if 
				End if 
			End for each 
			
/* STOP HIDING ERRORS */$errors.show()
			
		End if 
		
		$oLocal.forms.combine($c)
		
	End if 
	
	COLLECTION TO ARRAY:C1562($oLocal.forms;$tTxt_forms)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Find the default template
$tTxt_forms{0}:=String:C10($oManifest.default)
$tTxt_forms:=Find in array:C230($tTxt_forms;$tTxt_forms{0})

$oPicker:=New object:C1471(\
"action";"forms";\
"pictures";New collection:C1472;\
"pathnames";New collection:C1472;\
"helpTips";New collection:C1472;\
"celluleWidth";$oLocal.cell.width;\
"celluleHeight";$oLocal.cell.height;\
"offset";10;\
"thumbnailWidth";$oLocal.icon.width;\
"noPicture";Get localized string:C991("noMedia");\
"tips";True:C214;\
"background";0x00FFFFFF;\
"backgroundStroke";ui.strokeColor;\
"promptColor";0x00FFFFFF;\
"promptBackColor";ui.strokeColor;\
"hidePromptSeparator";True:C214;\
"forceRedraw";True:C214;\
"prompt";str .setText("selectAFormTemplateToUseAs").localized($oLocal.type);\
"selector";$oLocal.type)

$oPicker.vOffset:=155  // Offset of the background button

/* START HIDING ERRORS */$errors:=err .hide()

For ($i;1;Size of array:C274($tTxt_forms);1)
	
	CLEAR VARIABLE:C89($p)
	
	If ($tTxt_forms{$i}[[1]]="/")
		
		$t:=Delete string:C232($tTxt_forms{$i};1;1)
		
		If (featuresFlags.with("resourcesBrowser"))
			
			If (Path to object:C1547($tTxt_forms{$i}).extension=commonValues.archiveExtension)  // Archive
				
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
	
	If ($pathTemplate.extension=commonValues.archiveExtension)  // Archive
		
		$archive:=ZIP Read archive:C1637($pathTemplate)
		
		If ($archive#Null:C1517)
			
			  // Create image
			$svg:=svg .setDimensions($oLocal.cell.width;$oLocal.cell.height)
			
			  // Put icon
			$x:=$archive.root.file("layoutIconx2.png").getContent()
			BLOB TO PICTURE:C682($x;$p)
			$svg.embedPicture($p;-10;0)
			
			$o:=JSON Parse:C1218($archive.root.file("manifest.json").getText())
			
			  // Put text
			$svg.textArea($o.name;0;$oLocal.cell.height-20)\
				.setDimensions($oLocal.cell.width)\
				.setFill("dimgray")\
				.setAttribute("text-align";"center")
			
			$oPicker.pictures.push($svg.getPicture())
			$oPicker.pathnames.push($tTxt_forms{$i})
			$oPicker.helpTips.push(str .setText("tipsTemplate").localized(New collection:C1472(String:C10($pathTemplate.fullName);String:C10($o.organization.login);String:C10($o.version))))
			
		Else 
			
			  // Invalid archive = ignore
			
		End if 
		
	Else 
		
		$pathTemplate:=$pathTemplate.file("template.svg")
		
		If ($pathTemplate.exists)
			
			If ($pathTemplate.parent.file("layoutIconx2.png").exists)  // Use media
				
				  // Create image
				$svg:=svg .setDimensions($oLocal.cell.width;$oLocal.cell.height)
				
				  // Media
				READ PICTURE FILE:C678($pathTemplate.parent.file("layoutIconx2.png").platformPath;$p)
				$svg.embedPicture($p;-10;0)
				
				  // Title
				$t:=$tTxt_forms{$i}
				
				If ($t[[1]]="/")  // Database template
					
					$t:=Delete string:C232($t;1;1)
					
				End if 
				
				$svg.textArea($t;0;$oLocal.cell.height-20)\
					.setDimensions($oLocal.cell.width)\
					.setFill("dimgray")\
					.setAttribute("text-align";"center")
				
				$p:=$svg.getPicture()
				
			Else   // Create from the template
				
				PROCESS 4D TAGS:C816($pathTemplate.getText();$t)
				
				$t:=DOM Parse XML variable:C720($t)
				
				If (OK=1)
					
					  // Add the css reference
					If (COMPONENT_Pathname ("templates").file("template.css").exists)
						
						  //<?xml-stylesheet href="file://localhost/Users/vdl/Desktop/monstyle.css" type="text/css"?>
						$tProcessingInstruction:="xml-stylesheet type=\"text/css\" href=\""\
							+"file://localhost"+Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16);*)+"templates/template.css"\
							+"\""
						
						$dom:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088($t);XML processing instruction:K45:9;$tProcessingInstruction)
						
					End if 
					
					SVG EXPORT TO PICTURE:C1017($t;$p;Own XML data source:K45:18)
					CREATE THUMBNAIL:C679($p;$p;$oLocal.cell.width;$oLocal.cell.height)
					
				End if 
			End if 
			
			If ($i=$tTxt_forms)
				
				  // Put the default template at first position
				$oPicker.pictures.insert(0;$p)
				$oPicker.pathnames.insert(0;$tTxt_forms{$i})
				$oPicker.helpTips.insert(0;".default template")
				
			Else 
				
				$oPicker.pictures.push($p)
				$oPicker.pathnames.push($tTxt_forms{$i})
				$oPicker.helpTips.push("")
				
			End if 
			
		Else 
			
			  // Not a template folder = ignore
			
		End if 
	End if 
End for 

/* STOP HIDING ERRORS */$errors.show()

If (featuresFlags.with("resourcesBrowser"))
	
	  // Put an "explore" button after the default template
	$svg:=svg ("load";File:C1566("/RESOURCES/templates/more.svg")).setDimensions($oLocal.cell.width;$oLocal.cell.height)
	
	  //$oPicker.pictures.insert(1;$svg.getPicture())
	  //$oPicker.pathnames.insert(1;Null)
	  //$oPicker.helpTips.insert(1;str ("downloadMoreResources").localized($oLocal.type))
	
	$oPicker.pictures.push($svg.getPicture())
	$oPicker.pathnames.push(Null:C1517)
	$oPicker.helpTips.push(str ("downloadMoreResources").localized($oLocal.type))
	
End if 

  // Add 1 because the widget work with arrays
$indx:=$oPicker.pathnames.indexOf(String:C10(Form:C1466[$oLocal.type][$oLocal.dialog.$.tableNum()].form))+1
$oPicker.item:=Choose:C955($indx=0;1;$indx)

  // Display selector
$oLocal.dialog.form.call(New collection:C1472("pickerShow";$oPicker))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End