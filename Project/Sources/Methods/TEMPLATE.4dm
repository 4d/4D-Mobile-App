//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : template
// ID[9D7291F8EA044C9C92BEF06808B65A17]
// Created 21-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// -
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_copy; $Boo_processTags)
C_LONGINT:C283($i; $ii; $Lon_parameters)
C_TEXT:C284($Dir_tgt; $File_src; $File_tgt; $t; $Txt_fileName; $Txt_folder)
C_OBJECT:C1216($o; $Obj_input; $Obj_output; $Obj_result; $Obj_tempo)
C_COLLECTION:C1488($Col_catalog; $Col_pathComponents; $Col_types)

ARRAY TEXT:C222($tTxt_buffer; 0)

If (False:C215)
	C_OBJECT:C1216(template; $0)
	C_OBJECT:C1216(template; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_input:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	// Check parameters
	ASSERT:C1129($Obj_input.source#Null:C1517)
	ASSERT:C1129($Obj_input.target#Null:C1517)
	ASSERT:C1129(Value type:C1509($Obj_input.source)=Is text:K8:3)
	ASSERT:C1129(Value type:C1509($Obj_input.target)=Is text:K8:3)
	
	$Obj_output:=New object:C1471(\
		"success"; False:C215; \
		"children"; New collection:C1472; \
		"source"; String:C10($Obj_input.source))
	
	$o:=Path to object:C1547($Obj_input.source)
	$o.isFolder:=True:C214
	$Obj_input.source:=Object to path:C1548($o)
	
	$o:=Path to object:C1547($Obj_input.target)
	$o.isFolder:=True:C214
	$Obj_input.target:=Object to path:C1548($o)
	
	CREATE FOLDER:C475($Obj_input.target; *)
	
	Case of 
			
			//________________________________________
		: (Value type:C1509($Obj_input.catalog)=Is collection:K8:32)
			
			$Col_catalog:=$Obj_input.catalog
			
			//________________________________________
		: (Test path name:C476($Obj_input.source)=Is a folder:K24:2)  // Get catalog from source
			
			$Col_catalog:=doc_catalog($Obj_input.source)
			
			//________________________________________
		Else 
			
			$Obj_output.error:="Template folder '"+$Obj_input.source+"' not exist"
			$Obj_output.needProjectAudit:=True:C214
			
			ASSERT:C1129(dev_Matrix; "Template has no valid source to get doc catalog: "+$Obj_input.source)
			
			//________________________________________
	End case 
	
	var $str : cs:C1710.str
	$str:=cs:C1710.str.new()  // init class
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Boo_processTags:=$Obj_input.tags#Null:C1517

If ($Col_catalog#Null:C1517)
	
	For ($i; 0; $Col_catalog.length-1; 1)
		
		$t:=JSON Stringify:C1217($Col_catalog[$i])
		
		If ($str.setText($t).isJsonObject())
			
			// DIRECTORY
			
			$o:=JSON Parse:C1218($t)
			OB GET PROPERTY NAMES:C1232($o; $tTxt_buffer)
			
			If (Size of array:C274($tTxt_buffer)>0)
				
				If ($Boo_processTags)
					
					// Replace variables
					$Txt_folder:=Process_tags($tTxt_buffer{1}; $Obj_input.tags; New collection:C1472("filename"))
					
				Else 
					
					$Txt_folder:=$tTxt_buffer{1}
					
				End if 
				
				$Dir_tgt:=$Obj_input.target+$Txt_folder+Folder separator:K24:12
				CREATE FOLDER:C475($Dir_tgt; *)
				
				$Obj_tempo:=OB Copy:C1225($Obj_input)
				$Obj_tempo.source:=$Obj_input.source+$tTxt_buffer{1}+Folder separator:K24:12
				$Obj_tempo.target:=$Dir_tgt
				
				$Obj_tempo.catalog:=$o[$tTxt_buffer{1}]
				
				$Obj_result:=template($Obj_tempo)  // <================================== RECURSIVE
				$Obj_output.children.push($Obj_result)
				ob_error_combine($Obj_output; $Obj_result)
				
			End if 
			
		Else 
			
			// FILE
			
			$t:=$Col_catalog[$i]
			ASSERT:C1129(Length:C16($t)>0; "file name empty")
			
			If ($Boo_processTags)
				
				// Replace variables
				$Txt_fileName:=Process_tags($t; $Obj_input.tags; New collection:C1472("filename"))
				
			Else 
				
				$Txt_fileName:=$t
				
			End if 
			
			ASSERT:C1129(Length:C16($Txt_fileName)>0; "file name empty")
			
			$File_tgt:=$Obj_input.target+$Txt_fileName
			$File_src:=$Obj_input.source+$t
			
			If (Test path name:C476($File_tgt)=Is a document:K24:1)
				
				If ($Txt_fileName="manifest.json")
					
					// special case for manifest.json, try to dispatch it in template
					// TODO replace with a renaming rules given by template (to avoid folder conflict and issue with custom folder in template)
					$Col_pathComponents:=findFirstPathComponentInCatalog($Obj_input.catalog)
					
					If ($Col_pathComponents.length>0)
						
						For ($ii; 0; $Col_pathComponents.length-1; 1)
							
							$Col_pathComponents[$ii]:=Process_tags($Col_pathComponents[$ii]; $Obj_input.tags; New collection:C1472("filename"))
							
						End for 
						
						CREATE FOLDER:C475($Obj_input.target+$Col_pathComponents.join(Folder separator:K24:12)+Folder separator:K24:12; *)
						$File_tgt:=$Obj_input.target+$Col_pathComponents.join(Folder separator:K24:12)+Folder separator:K24:12+$Txt_fileName
						
					End if 
					
				Else 
					
					// XXX see if we autorize overriding files
					LOG_EVENT(New object:C1471(\
						"message"; "A file '"+$Txt_fileName+"' already exist at destination '"+$Obj_input.target+"' when copying '"+$File_src+"'"; \
						"importance"; Warning message:K38:2))
					
				End if 
			End if 
			
			// Get file type to minimize replacement // XXX could also split the code
			Case of 
					
					//______________________________________________________
				: ($Txt_fileName="@.swift")
					
					$Col_types:=New collection:C1472("swift")
					
					//______________________________________________________
				: ($Txt_fileName="Info.plist")
					
					$Col_types:=New collection:C1472("Info.plist")
					
					//______________________________________________________
				: ($Txt_fileName="Contents.json")
					
					$Col_types:=New collection:C1472("asset")
					
					//______________________________________________________
				: ($Txt_fileName="project.pbxproj")
					
					$Col_types:=New collection:C1472("project.pbxproj")
					
					//______________________________________________________
				: ($Txt_fileName="@.storyboard")
					
					$Col_types:=New collection:C1472("storyboard")
					
					//______________________________________________________
				: ($Txt_fileName="@.sh")  // or maybe check parent path
					
					$Col_types:=New collection:C1472("script")
					
					//______________________________________________________
				: ($Txt_fileName="Settings.plist")\
					 | ($Txt_fileName="Settings.debug.plist")
					
					$Col_types:=New collection:C1472("settings")
					
					//______________________________________________________
				Else 
					
					$Col_types:=New collection:C1472
					
					//______________________________________________________
			End case 
			
			If ($t="@___TABLE___@")
				
				$Col_types.push("___TABLE___")
				
			End if 
			
			$Boo_copy:=True:C214
			
			Case of 
					
					//______________________________________________________
				: (Not:C34($Boo_processTags))
					
					// Ignore
					
					//______________________________________________________
				: (doc_document(New object:C1471(\
					"action"; "isAlias"; \
					"path"; $File_src)).isAlias)
					
					// Ignore
					
					//______________________________________________________
				: (Is picture file:C1113($File_src))
					
					// Ignore
					
					//______________________________________________________
				: (Position:C15(".git"+Folder separator:K24:12; $File_src)>0)
					
					// ignore XXX maybe filter before all content of git folders before calling
					
					//______________________________________________________
				: ($Txt_fileName="manifest.json")
					
					// Ignore
					
					//______________________________________________________
				Else 
					
					Process_tags_on_file($File_src; $File_tgt; $Obj_input.tags; $Col_types)
					$Boo_copy:=False:C215
					
					//______________________________________________________
			End case 
			
			If ($Boo_copy)
				
				COPY DOCUMENT:C541($File_src; $File_tgt; *)
				
			Else 
				
				// Already copied by process tags
				
			End if 
			
			$Obj_output.children.push(New object:C1471(\
				"source"; $File_src; \
				"target"; $File_tgt; \
				"types"; $Col_types))
			
		End if 
	End for 
	
	$Obj_output.success:=($Obj_output.children.length>0)
	
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_output

// ----------------------------------------------------
// End