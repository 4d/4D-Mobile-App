//%attributes = {"executedOnServer":true}
// ----------------------------------------------------
// Project method : test_XcodeProj
// Created #2017 by Eric Marchand
// ----------------------------------------------------
// Description: Test plist and openstep, test the template

// ----------------------------------------------------
// Declarations

C_OBJECT:C1216($Obj_result; $Obj_; $Obj_proj; $Obj_objects; $Obj_object; $Obj_template)
C_TEXT:C284($File_; $Txt_key; $File_tmp; $Txt_projectName; $Txt_testTable)

// ----------------------------------------------------
// Init test files

$File_:=mobileUnit("pathname"; New object:C1471("target"; "templates")).value+"list"
$Obj_template:=JSON Parse:C1218(Document to text:C1236($File_+Folder separator:K24:12+"manifest.json"))

// Find project in template path
$Obj_:=New object:C1471("action"; "find"; "type"; "xcodeproj"; "path"; $File_)
$Obj_result:=mobileUnit("xcode"; $Obj_)
ASSERT:C1129($Obj_result.success; "Failed to find xcode project into "+$File_)

$File_:=Folder:C1567($Obj_result.path; fk platform path:K87:2).file("project.pbxproj").platformPath
$Txt_projectName:="___PRODUCT___"
$Txt_testTable:="testtable"


// do not modify real template file, so copy in a temporary folder
$File_tmp:=Temporary folder:C486+"test"+Folder separator:K24:12+"test.xcodeproj"+Folder separator:K24:12+"project.pbxproj"
CREATE FOLDER:C475($File_tmp; *)

If (Test path name:C476($File_tmp)=Is a document:K24:1)
	
	DELETE DOCUMENT:C159($File_tmp)
	
End if 

COPY DOCUMENT:C541($File_; $File_tmp)

// Read project name
$Obj_result:=XcodeProj(New object:C1471("action"; "projectName"; "path"; $File_tmp))
ASSERT:C1129($Obj_result.success; "Failed to read project name in "+$File_tmp)
ASSERT:C1129($Obj_result.value=$Txt_projectName; "Failed to read template "+$File_tmp)

// ----------------------------------------------------
// Unit Tests
$File_tmp:=Temporary folder:C486+"test"

// TEST: Read project plist

$Obj_result:=XcodeProj(New object:C1471("action"; "read"; "path"; $File_tmp))
ASSERT:C1129($Obj_result.success; "Failed to read template file as plist "+$File_tmp)

$Obj_proj:=$Obj_result.value
$Obj_objects:=$Obj_proj.objects

// TEST: creation of mapping ie. map of file path and uuid
$Obj_:=$Obj_result
$Obj_result:=XcodeProj(New object:C1471("action"; "mapping"; "projObject"; $Obj_))  // exclude current project id
ASSERT:C1129($Obj_result.success; "Failed to generate source tree mapping: success = false")
ASSERT:C1129(Value type:C1509($Obj_.mapping)=Is object:K8:27; "Failed to generate source tree mapping: no object in passed object")
ASSERT:C1129(Value type:C1509($Obj_result.mapping)=Is object:K8:27; "Failed to generate source tree mapping: no object in returned object")

// TEST: random id and pass project ids
$Obj_:=New object:C1471("action"; "randomObjectId"; "proj"; $Obj_proj)
$Obj_result:=XcodeProj($Obj_)  // exclude current project id
ASSERT:C1129($Obj_result.success; "Failed to generate random id."+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.value#Null:C1517; "Failed to generate random id")
ASSERT:C1129(Length:C16("48861A111E8953B800C1A97C")=Length:C16($Obj_result.value); "Failed to check size of "+$Obj_.action)

// TEST: Add table, not in tree mode (NO MORE EMbedded JSON files, project file has been cleaned)
/*$Obj_:=New object("action"; "addTableForm"; "proj"; $Obj_proj; "table"; $Txt_testTable; "uuid"; $Obj_template.uuid)\



$Obj_result:=mobileUnit("xcodeProj"; $Obj_)
ASSERT($Obj_result.success; "Failed to insert table form"+JSON Stringify($Obj_result))*/

/*$Obj_:=New object("action";"addTableJSON";"proj";$Obj_proj;"table";$Txt_testTable;"uuid";$Obj_template.uuid)\



$Obj_result:=mobileUnit ("xcodeProj";$Obj_)
ASSERT($Obj_result.success; "Failed to insert table JSON in project"+JSON Stringify($Obj_result))*/

// TEST: re read - and make a tree
$Obj_result:=XcodeProj(New object:C1471("action"; "read"; "path"; $File_tmp))
ASSERT:C1129($Obj_result.success; "Failed to read template file as plist "+$File_tmp)
$Obj_proj:=$Obj_result.value
$Obj_objects:=$Obj_proj.objects

$Obj_result:=XcodeProj(New object:C1471("action"; "tree"; "proj"; $Obj_proj))
// $Obj_result:=mobileUnit ("xcodeProj";New object("action";"tree";"object";$Obj_proj))
ASSERT:C1129($Obj_result.success; "Failed to create a tree from project file"+String:C10($Obj_result.error))

// TEST: Add table, in tree mode
$Obj_:=New object:C1471("action"; "addTableForm"; \
"proj"; $Obj_proj; \
"table"; $Txt_testTable; \
"uuid"; $Obj_template.uuid)
$Obj_result:=XcodeProj($Obj_)
ASSERT:C1129($Obj_result.success; "Failed to insert table form in tree mode "+JSON Stringify:C1217($Obj_result))

/*$Obj_:=New object("action"; "addTableJSON"; "proj"; $Obj_proj; "table"; $Txt_testTable; "uuid"; $Obj_template.uuid)\



$Obj_result:=mobileUnit("xcodeProj"; $Obj_)
ASSERT($Obj_result.success; "Failed to insert table JSON in project with tree mode"+JSON Stringify($Obj_result))*/

// TEST: sort by ISA the objects, allow to study project
var $Col_isa : Collection
$Col_isa:=New collection:C1472(\
"PBXFileReference"; \
"PBXGroup"; \
"PBXBuildFile"; \
"PBXVariantGroup"; \
"XCBuildConfiguration"; \
"XCVersionGroup"; \
"XCConfigurationList"; \
"PBXNativeTarget"; \
"PBXContainerItemProxy"; \
"PBXTargetDependency"; \
"PBXProject"; \
"PBXSourcesBuildPhase"; \
"PBXShellScriptBuildPhase"; \
"PBXResourcesBuildPhase"; \
"PBXFrameworksBuildPhase"; \
"PBXCopyFilesBuildPhase")

var $Obj_ByIsa : Object
$Obj_ByIsa:=New object:C1471

For each ($Txt_key; $Col_isa)
	
	$Obj_ByIsa[$Txt_key]:=New collection:C1472  // $Obj_objects.query("isa = :1";$Txt_key) // not working...
	
End for each 

For each ($Txt_key; $Obj_objects)
	
	$Obj_object:=OB Get:C1224($Obj_objects; $Txt_key)
	ASSERT:C1129($Col_isa.indexOf($Obj_object.isa)>=0; $Obj_object.isa+" not found in isaCol")
	If ($Obj_ByIsa[$Obj_object.isa]=Null:C1517)
		$Obj_ByIsa[$Obj_object.isa]:=New collection:C1472
	End if 
	$Obj_ByIsa[$Obj_object.isa].push($Obj_object)
	
	
End for each 

// TEST: Check if there is a group with name $Txt_testTable, ie. table group has been added?
$Obj_object:=Null:C1517

For each ($Obj_; $Obj_ByIsa["PBXGroup"])
	
	If (String:C10($Obj_.path)=$Txt_testTable)
		
		$Obj_object:=$Obj_
		
	End if 
End for each 

ASSERT:C1129($Obj_object#Null:C1517; "Failed to find a group named "+$Txt_testTable+" in project after adding it")
ASSERT:C1129($Obj_object.children.length=4; "Wrong number files under "+$Txt_testTable+" group ("+String:C10($Obj_object.children.length)+")")

// TEST: Restore project format by setting references (after modification)
$Obj_result:=XcodeProj(New object:C1471("action"; "untree"; "proj"; $Obj_proj))
ASSERT:C1129($Obj_result.success; "Failed to read template "+$File_)

// NOT A TEST: Re-read to clean modifications
$Obj_result:=XcodeProj(New object:C1471("action"; "read"; "path"; $File_tmp))
ASSERT:C1129($Obj_result.success; "Failed to read template file as plist "+$File_tmp)
$Obj_proj:=$Obj_result.value
$Obj_objects:=$Obj_proj.objects

$Obj_result:=XcodeProj((New object:C1471("action"; "tree"; "proj"; $Obj_proj)))
ASSERT:C1129($Obj_result.success; "Failed to create a tree from project file"+JSON Stringify:C1217($Obj_result))

// TEST: Restore project format by setting references (without modification)
$Obj_result:=XcodeProj((New object:C1471("action"; "untree"; "proj"; $Obj_proj)))
ASSERT:C1129($Obj_result.success; "Failed to read template "+$File_)

$Obj_proj:=$Obj_result.value

// TEST: Write project plist in openstep format
$Obj_:=New object:C1471("action"; "write"; "object"; $Obj_proj; "path"; $File_tmp)
$Obj_result:=XcodeProj($Obj_)
ASSERT:C1129($Obj_result.success; "Failed to write template "+$File_tmp)

// Could test content equal for $File_ and $File_tmp when template is sanitized (ie. some " encapsulate the values)

//C_TEXT($Txt_cmd;$Txt_error;$Txt_in;$Txt_out)
//$Txt_cmd:="diff --strip-trailing-cr "+singleQuote (Convert path system to POSIX($File_))+" "+singleQuote (Convert path system to POSIX($File_tmp))
//LAUNCH EXTERNAL PROCESS($Txt_cmd;$Txt_in;$Txt_out;$Txt_error)

//ASSERT(Length($Txt_out)=0;"There is diff: "+$Txt_out)
