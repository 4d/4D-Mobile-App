//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : doc_Folder
  // Database: 4D Mobile App
  // ID[590433DF7CDC4611A0FE5A7B2AE025E4]
  // Created #12-7-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Waiting for Folder command !
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_i;$Lon_level;$Lon_parameters)
C_TEXT:C284($File_test;$Txt_errorMethod;$Txt_pathname;$Txt_property)
C_OBJECT:C1216($Obj_folder;$Obj_options;$Obj_template)

ARRAY TEXT:C222($tTxt_files;0)
ARRAY TEXT:C222($tTxt_folders;0)

If (False:C215)
	C_OBJECT:C1216(doc_Folder ;$0)
	C_TEXT:C284(doc_Folder ;$1)
	C_OBJECT:C1216(doc_Folder ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_pathname:=$1
	
	  // Default values
	$Obj_folder:=Path to object:C1547($Txt_pathname)
	
	$Obj_folder.folders:=New collection:C1472
	$Obj_folder.files:=New collection:C1472
	
	$Obj_template:=New object:C1471(\
		"exist";False:C215;\
		"writable";False:C215;\
		"isFolder";False:C215;\
		"isFile";False:C215;\
		"name";"";\
		"extension";"";\
		"fullName";"";\
		"parent";"";\
		"parentFolder";"";\
		"nativePath";"";\
		"path";""\
		)
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_options:=$2
		
	End if 
	
	$Lon_level:=-1  // Dummy value
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  //%R-
If (Length:C16($Txt_pathname)#0)
	
	$Obj_folder.isFolder:=Bool:C1537(Position:C15($Txt_pathname[[Length:C16($Txt_pathname)]];":\\"))
	$Obj_folder.isFile:=Not:C34($Obj_folder.isFolder)
	$Obj_folder.exists:=(Test path name:C476($Txt_pathname)=Is a folder:K24:2)
	$Obj_folder.fullName:=$Obj_folder.name+$Obj_folder.extension
	$Obj_folder.nativePath:=$Txt_pathname
	$Obj_folder.path:=Convert path system to POSIX:C1106($Txt_pathname)
	
	If ($Obj_folder.exists)
		
		If (Bool:C1537($Obj_options.writable))
			
			$File_test:=$Obj_folder.nativePath+"."+Generate UUID:C1066
			
			$Txt_errorMethod:=Method called on error:C704
			ON ERR CALL:C155("hideError")
			TEXT TO DOCUMENT:C1237($File_test;"")
			ON ERR CALL:C155($Txt_errorMethod)
			
			$Obj_folder.writable:=(Test path name:C476($File_test)=Is a document:K24:1)
			
			If ($Obj_folder.writable)
				
				DELETE DOCUMENT:C159($File_test)
				
			End if 
		End if 
		
		If ($Obj_options.depth#Null:C1517)
			
			$Lon_level:=Num:C11($Obj_options.depth)
			
			$Obj_options.depth:=$Lon_level-1
			
		End if 
		
		If (Num:C11($Obj_options.depth)>=0)
			
			FOLDER LIST:C473($Txt_pathname;$tTxt_folders)
			
			For ($Lon_i;1;Size of array:C274($tTxt_folders);1)
				
				$Obj_folder.folders.push(doc_Folder ($Txt_pathname+$tTxt_folders{$Lon_i}+Folder separator:K24:12;$Obj_options))
				
			End for 
			
			DOCUMENT LIST:C474($Txt_pathname;$tTxt_files;Absolute path:K24:14)
			
			For ($Lon_i;1;Size of array:C274($tTxt_files);1)
				
				$Obj_folder.files.push(doc_File ($tTxt_files{$Lon_i};$Obj_options))
				
			End for 
		End if 
	End if 
	
	$Obj_folder.parent:=Convert path system to POSIX:C1106($Obj_folder.parentFolder)
	
	If ($Lon_level#-1)
		
		$Obj_options.depth:=$Lon_level
		
	End if 
End if 

For each ($Txt_property;$Obj_template)
	
	If ($Obj_folder[$Txt_property]=Null:C1517)
		
		$Obj_folder[$Txt_property]:=$Obj_template[$Txt_property]
		
	End if 
End for each 
  //%R+

  // ----------------------------------------------------
  // Return
$0:=$Obj_folder

  // ----------------------------------------------------
  // End