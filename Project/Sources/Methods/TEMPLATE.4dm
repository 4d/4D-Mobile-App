//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Obj_input : Object)->$Obj_output : Object
// ----------------------------------------------------
// Project method : template
// ID[9D7291F8EA044C9C92BEF06808B65A17]
// Created 21-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// -
// ----------------------------------------------------
// Declarations

C_BOOLEAN:C305($Boo_copy; $Boo_processTags)
C_LONGINT:C283($i; $ii)
C_TEXT:C284($t; $Txt_fileName; $Txt_folder)
C_OBJECT:C1216($o; $Obj_result; $Obj_tempo)
C_COLLECTION:C1488($Col_catalog; $Col_pathComponents; $Col_types)
var $Dir_tgt : 4D:C1709.Folder
var $File_src; $File_tgt : 4D:C1709.File

ARRAY TEXT:C222($tTxt_buffer; 0)

If (False:C215)
	C_OBJECT:C1216(TEMPLATE; $0)
	C_OBJECT:C1216(TEMPLATE; $1)
End if 

// ----------------------------------------------------
// Initialisations

// Check parameters
ASSERT:C1129($Obj_input.source#Null:C1517)
ASSERT:C1129($Obj_input.target#Null:C1517)

$Obj_input.source:=FolderFrom($Obj_input.source)
$Obj_input.target:=FolderFrom($Obj_input.target)

$Obj_output:=New object:C1471(\
"success"; False:C215; \
"children"; New collection:C1472; \
"source"; String:C10($Obj_input.source.platformPath))

$Obj_input.target.create()

Case of 
		
		//________________________________________
	: (Value type:C1509($Obj_input.catalog)=Is collection:K8:32)
		
		$Col_catalog:=$Obj_input.catalog
		
		//________________________________________
	: ($Obj_input.source.exists)  // Get catalog from source
		
		If ($Obj_input.exclude#Null:C1517)  // could do this code in one line if _o_doc_catalog check if null or length emptys
			$Col_catalog:=_o_doc_catalog($Obj_input.source.platformPath; $Obj_input.exclude)
		Else 
			$Col_catalog:=_o_doc_catalog($Obj_input.source.platformPath)
		End if 
		
		//________________________________________
	Else 
		
		$Obj_output.error:="Template folder '"+$Obj_input.source.path+"' not exist"
		$Obj_output.needProjectAudit:=True:C214
		
		ASSERT:C1129(dev_Matrix; "Template has no valid source to get doc catalog: "+$Obj_input.source.path)
		
		//________________________________________
End case 

var $str : cs:C1710.str
$str:=cs:C1710.str.new()  // init class

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
				
				$Dir_tgt:=$Obj_input.target.folder($Txt_folder)
				$Dir_tgt.create()
				
				$Obj_tempo:=OB Copy:C1225($Obj_input)
				$Obj_tempo.source:=$Obj_input.source.folder($tTxt_buffer{1})
				$Obj_tempo.target:=$Dir_tgt
				
				$Obj_tempo.catalog:=$o[$tTxt_buffer{1}]
				
				$Obj_result:=TEMPLATE($Obj_tempo)  // <================================== RECURSIVE
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
			
			$File_tgt:=$Obj_input.target.file($Txt_fileName)
			$File_src:=$Obj_input.source.file($t)
			
			If ($File_tgt.exists)
				
				If ($Txt_fileName="manifest.json")
					
					// special case for manifest.json, try to dispatch it in template
					// TODO replace with a renaming rules given by template (to avoid folder conflict and issue with custom folder in template)
					$Col_pathComponents:=findFirstPathComponentInCatalog($Obj_input.catalog)
					
					If ($Col_pathComponents.length>0)
						
						For ($ii; 0; $Col_pathComponents.length-1; 1)
							
							$Col_pathComponents[$ii]:=Process_tags($Col_pathComponents[$ii]; $Obj_input.tags; New collection:C1472("filename"))
							
						End for 
						
						Folder:C1567($Obj_input.target.platformPath+$Col_pathComponents.join(Folder separator:K24:12)+Folder separator:K24:12; fk platform path:K87:2).create()  // XXX simplify?
						$File_tgt:=File:C1566($Obj_input.target.platformPath+$Col_pathComponents.join(Folder separator:K24:12)+Folder separator:K24:12+$Txt_fileName; fk platform path:K87:2)
						
					End if 
					
				Else 
					
					// XXX see if we autorize overriding files
					LOG_EVENT(New object:C1471(\
						"message"; "A file '"+$Txt_fileName+"' already exist at destination '"+$Obj_input.target.path+"' when copying '"+$File_src.path+"'"; \
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
			
			If (Not:C34($Boo_processTags))\
				 || ($Txt_fileName="manifest.json")\
				 || (Is picture file:C1113($File_src.platformPath))\
				 || (Position:C15(".git"+Folder separator:K24:12; $File_src.platformPath)>0)\
				 || ($File_src.isAlias)
				
				// Ignore
				
			Else 
				
				Process_tags_on_file($File_src; $File_tgt; $Obj_input.tags; $Col_types)
				$Boo_copy:=False:C215
				
			End if 
			
			If ($Boo_copy)
				
				If (Feature.with("buildWithCmd"))
					$File_src.copyTo($File_tgt.parent; $File_tgt.fullName; fk overwrite:K87:5)
				Else 
					COPY DOCUMENT:C541($File_src.platformPath; $File_tgt.platformPath; *)
				End if 
			Else 
				
				// Already copied by process tags
				
			End if 
			
			$Obj_output.children.push(New object:C1471(\
				"source"; $File_src.platformPath; \
				"target"; $File_tgt.platformPath; \
				"types"; $Col_types))
			
		End if 
	End for 
	
	$Obj_output.success:=($Obj_output.children.length>0)
	
End if 