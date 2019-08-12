//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : views_LAYOUT_PICKER
  // Database: 4D Mobile Express
  // ID[F73301CBEEE042CEAD2D2D1CEBB4C9E5]
  // Created 11-1-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_OK)
C_LONGINT:C283($i;$kLon_cellHeight;$kLon_cellWidth;$kLon_iconWidth;$Lon_index;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($Dom_buffer;$t;$Txt_processingInstruction;$Txt_typeForm)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_manifest;$Obj_picker;$Path_component)
C_OBJECT:C1216($Path_database;$Path_template;$svg)
C_COLLECTION:C1488($Col_forms;$Col_host)

ARRAY TEXT:C222($tTxt_forms;0)

If (False:C215)
	C_TEXT:C284(views_LAYOUT_PICKER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_typeForm:=$1  // "list" or "detail"
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_form:=views_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
	$kLon_iconWidth:=300
	
	$kLon_cellWidth:=140
	$kLon_cellHeight:=180
	
	$Col_forms:=New collection:C1472
	
	  // Load components templates
	$Path_component:=COMPONENT_Pathname ($Txt_typeForm+"Forms")
	
	  // Load the global manifest
	$Obj_manifest:=JSON Parse:C1218($Path_component.file("manifest.json").getText())
	
	For each ($o;$Path_component.folders())
		
		$Boo_OK:=True:C214
		
		For each ($t;$Obj_manifest.mandatory) While ($Boo_OK)
			
			$Boo_OK:=$Path_component.folder($o.name).file($t).exists
			
		End for each 
		
		If ($Boo_OK)
			
			$Col_forms.push($o.fullName)
			
		End if 
	End for each 
	
	  // Search for templates into the host database
	$Path_database:=COMPONENT_Pathname ("host_"+$Txt_typeForm+"Forms")
	
	If ($Path_database.exists)
		
		$Col_host:=New collection:C1472
		
		For each ($o;$Path_database.folders())
			
			$Boo_OK:=True:C214
			
			For each ($t;$Obj_manifest.mandatory) While ($Boo_OK)
				
				$Boo_OK:=$Path_database.folder($o.name).file($t).exists
				
			End for each 
			
			If ($Boo_OK)
				
				$Col_host.push("/"+$o.fullName)
				
			End if 
		End for each 
		
		$Col_forms.combine($Col_host)
		
	End if 
	
	COLLECTION TO ARRAY:C1562($Col_forms;$tTxt_forms)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // Find the default template
$tTxt_forms{0}:=String:C10($Obj_manifest.default)
$tTxt_forms:=Find in array:C230($tTxt_forms;$tTxt_forms{0})

$Obj_picker:=New object:C1471(\
"action";"forms";\
"pictures";New collection:C1472;\
"pathnames";New collection:C1472;\
"celluleWidth";$kLon_cellWidth;\
"celluleHeight";$kLon_cellHeight;\
"offset";10;\
"thumbnailWidth";$kLon_iconWidth;\
"noPicture";Get localized string:C991("noMedia");\
"tips";True:C214;\
"background";0x00FFFFFF;\
"backgroundStroke";ui.strokeColor;\
"promptColor";0x00FFFFFF;\
"promptBackColor";ui.strokeColor;\
"hidePromptSeparator";True:C214;\
"forceRedraw";True:C214;\
"prompt";str_localized (New collection:C1472("selectAFormTemplateToUseAs";$Txt_typeForm));\
"selector";$Txt_typeForm)

For ($i;1;Size of array:C274($tTxt_forms);1)
	
	CLEAR VARIABLE:C89($p)
	
	If ($tTxt_forms{$i}[[1]]="/")
		
		  // Database template
		$Path_template:=$Path_database.folder(Delete string:C232($tTxt_forms{$i};1;1))
		
	Else 
		
		$Path_template:=$Path_component.folder($tTxt_forms{$i})
		
	End if 
	
	$Path_template:=$Path_template.file("template.svg")
	
	If ($Path_template.exists)
		
		If ($Path_template.parent.file("layoutIconx2.png").exists)
			
			  // Use the media
			READ PICTURE FILE:C678($Path_template.parent.file("layoutIconx2.png").platformPath;$p)
			
			$svg:=svg .setDimensions($kLon_cellWidth;$kLon_cellHeight)
			
			$svg.embedPicture($p;-10;0)
			
			$t:=$tTxt_forms{$i}
			
			If ($t[[1]]="/")
				$t:=Delete string:C232($t;1;1)
			End if 
			
			$svg.textArea($t;0;$kLon_cellHeight-20)\
				.setDimensions($kLon_cellWidth)\
				.setFill("dimgray")\
				.setAttribute("text-align";"center")
			
			$p:=$svg.getPicture()
			
		Else 
			
			  // Create from the template
			PROCESS 4D TAGS:C816($Path_template.getText();$t)
			
			$t:=DOM Parse XML variable:C720($t)
			
			If (OK=1)
				
				  // Add the css reference
				If (COMPONENT_Pathname ("templates").file("template.css").exists)
					
					  //<?xml-stylesheet href="file://localhost/Users/vdl/Desktop/monstyle.css" type="text/css"?>
					$Txt_processingInstruction:="xml-stylesheet type=\"text/css\" href=\""\
						+"file://localhost"+Convert path system to POSIX:C1106(Get 4D folder:C485(Current resources folder:K5:16);*)+"templates/template.css"\
						+"\""
					
					$Dom_buffer:=DOM Append XML child node:C1080(DOM Get XML document ref:C1088($t);XML processing instruction:K45:9;$Txt_processingInstruction)
					
				End if 
				
				SVG EXPORT TO PICTURE:C1017($t;$p;Own XML data source:K45:18)
				CREATE THUMBNAIL:C679($p;$p;$kLon_cellWidth;$kLon_cellHeight)
				
			End if 
		End if 
		
		If ($i=$tTxt_forms)
			
			  // Put the default template at first position
			$Obj_picker.pictures.insert(0;$p)
			$Obj_picker.pathnames.insert(0;$tTxt_forms{$i})
			
		Else 
			
			$Obj_picker.pictures.push($p)
			$Obj_picker.pathnames.push($tTxt_forms{$i})
			
		End if 
		
	Else 
		
		  // Not a template folder = ignore
		
	End if 
End for 

  // Add 1 because the widget work with arrays
$Lon_index:=$Obj_picker.pathnames.indexOf(String:C10(Form:C1466[$Txt_typeForm][$Obj_context.tableNum()].form))+1
$Obj_picker.item:=Choose:C955($Lon_index=0;1;$Lon_index)

$Obj_picker.vOffset:=155  // Offset of the background button

  // Display selector
$Obj_form.form.call(New collection:C1472("pickerShow";$Obj_picker))

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End