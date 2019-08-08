//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : XcodeProj
  // Created 2017 by Eric Marchand
  // ----------------------------------------------------
  // Description: Edit Xcode project file

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters;$Lon_i)
C_TEXT:C284($Txt_buffer;$Txt_objectRef)
C_TEXT:C284($Txt_formType;$Txt_fileRef;$Txt_buildfileRef;$Txt_tableName)
C_TEXT:C284($Txt_tableName)
C_OBJECT:C1216($Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_objects;$Obj_tableGroup;$Obj_file;$Obj_buildfile;$Obj_object;$Obj_object_child;$Obj_types)
C_COLLECTION:C1488($Col_children)
ARRAY TEXT:C222($tTxt_keys;0)
C_BOOLEAN:C305($Bool_tree)


If (False:C215)
	C_OBJECT:C1216(XcodeProj ;$0)
	C_OBJECT:C1216(XcodeProj ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($Obj_in.action#Null:C1517;"Missing the tag \"action\""))
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_in.action="read")
			
			If ($Obj_in.path#Null:C1517)
				
				$Obj_out:=Xcode (\
					New object:C1471("action";"find";\
					"type";"xcodeproj";\
					"path";$Obj_in.path))
				
				If ($Obj_out.success)
					
					$Txt_buffer:=$Obj_out.path+Folder separator:K24:12+"project.pbxproj"
					$Obj_out:=plist (New object:C1471("action";"object";"path";$Txt_buffer))
					$Obj_out.path:=$Txt_buffer
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="write")
			
			If (($Obj_in.path#Null:C1517) & ($Obj_in.object#Null:C1517))
				
				$Txt_buffer:=$Obj_in.path
				
				If (Test path name:C476($Obj_in.path)=Is a folder:K24:2)
					
					$Obj_out:=Xcode (\
						New object:C1471("action";"find";\
						"type";"xcodeproj";\
						"path";$Obj_in.path))
					
					If ($Obj_out.success)
						
						$Txt_buffer:=$Obj_out.path+"project.pbxproj"
						
					End if 
					
				End if 
				
				$Obj_out:=plist (New object:C1471(\
					"action";"fromobject";\
					"object";$Obj_in.object;\
					"format";"openstep";\
					"project";String:C10($Obj_in.project);\
					"path";$Txt_buffer\
					))
				$Obj_out.path:=$Txt_buffer
				$Obj_out.object:=$Obj_in.object
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("path and object must be defined")
				
			End if 
			
			
			  //______________________________________________________
		: ($Obj_in.action="mapping")
			
			If ($Obj_in.projObject#Null:C1517)
				
				$Obj_objects:=$Obj_in.projObject.value.objects
				If (Value type:C1509($Obj_in.projObject.mapping)#Is object:K8:27)
					$Obj_in.projObject.mapping:=New object:C1471
				End if 
				
				If ($Obj_in.uuid=Null:C1517)
					
					$Obj_object:=$Obj_objects[$Obj_in.projObject.value.rootObject]
					$Obj_in.projObject.mapping["/"]:=$Obj_object.mainGroup
					$Obj_object:=$Obj_objects[$Obj_object.mainGroup]
					
				Else 
					
					$Obj_object:=$Obj_objects[$Obj_in.uuid]
					
				End if 
				
				If (Value type:C1509($Obj_object.children)=Is collection:K8:32)
					
					For each ($Txt_fileRef;$Obj_object.children)
						
						$Obj_file:=$Obj_objects[$Txt_fileRef]
						
						If (Length:C16(String:C10($Obj_file.path))>0)
							
							If (Value type:C1509($Obj_file.children)=Is collection:K8:32)
								  // XXX maybe exclude .., and resolve ../apath
								$Txt_buffer:=String:C10($Obj_in.path)+"/"+$Obj_file.path
								$Obj_in.projObject.mapping[$Txt_buffer]:=$Txt_fileRef
								
								XcodeProj (New object:C1471("action";"mapping";"projObject";$Obj_in.projObject;"path";$Txt_buffer;"uuid";$Txt_fileRef))
								
							End if 
						End if 
					End for each 
				End if 
				
				$Obj_out.mapping:=$Obj_in.projObject.mapping  // shared result
				$Obj_out.success:=True:C214
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("projObject be defined")
				
			End if 
			  //______________________________________________________
		: ($Obj_in.action="randomObjectId")
			
			  // Maybe parameters are encapsulated into a project object
			If ($Obj_in.proj#Null:C1517)
				If ($Obj_in.proj.objects#Null:C1517)
					  // get the objects
					$Obj_in.objects:=$Obj_in.proj.objects
				End if 
			End if 
			
			CLEAR VARIABLE:C89($tTxt_keys)
			
			If (Value type:C1509($Obj_in.objects)=Is object:K8:27)
				
				OB GET PROPERTY NAMES:C1232($Obj_in.objects;$tTxt_keys)
				
			End if 
			  // Else
			If (Value type:C1509($Obj_in.objects)=Is collection:K8:32)
				
				  //col_TO_TEXT_ARRAY ($Obj_in.objects;->$tTxt_keys)
				COLLECTION TO ARRAY:C1562($Obj_in.objects;$tTxt_keys)
				
			End if 
			
			  // Generate an id not already in the array
			$Txt_buffer:=Substring:C12(Generate UUID:C1066;1;24)
			
			While (Find in array:C230($tTxt_keys;$Txt_buffer)#-1)
				
				$Txt_buffer:=Substring:C12(Generate UUID:C1066;1;24)
				
			End while 
			
			$Obj_out.success:=True:C214
			$Obj_out.value:=$Txt_buffer
			
			  //______________________________________________________
		: ($Obj_in.action="addGroup")
			
			If (($Obj_in.proj#Null:C1517) & ($Obj_in.uuid#Null:C1517) & ($Obj_in.name#Null:C1517))
				
				  // project is in tree mode or not?
				If (Bool:C1537($Obj_in.tree))  // could force with parameter
					$Bool_tree:=$Obj_in.tree
				Else 
					  // Tree mode if rootObject is not a reference but an object
					$Bool_tree:=Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27
				End if 
				
				$Obj_objects:=$Obj_in.proj.objects
				
				$Col_children:=$Obj_objects[$Obj_in.uuid].children
				If ($Col_children#Null:C1517)
					
					  // Create a Group for the table
					$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_tableGroup:=New object:C1471(\
						"path";$Obj_in.name;\
						"isa";"PBXGroup";\
						"sourceTree";"<group>";\
						"children";New collection:C1472\
						)
					  /// ...and add it
					$Obj_objects[$Txt_fileRef]:=$Obj_tableGroup
					
					If ($Bool_tree)
						$Obj_tableGroup.ref:=$Txt_fileRef
						$Col_children.push($Obj_tableGroup)
					Else 
						$Col_children.push($Txt_fileRef)
					End if 
					
					$Obj_out.group:=$Obj_tableGroup
					$Obj_out.groupRef:=$Txt_fileRef
					
					  // Else // No collection children, maybe object do not accept children like Assets, folder pointer
					
				End if 
				
				$Obj_out.success:=True:C214
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj, uuid and table must be defined")
				
			End if 
			
			
			  //______________________________________________________
		: ($Obj_in.action="addFile")
			
			$Obj_types:=XcodeProj (New object:C1471(\
				"action";"filetype";\
				"filename";String:C10($Obj_in.name)))
			
			  // If not defined by caller, take values according to file name
			If ($Obj_in.type=Null:C1517)
				$Obj_in.type:=$Obj_types.type
			End if 
			If ($Obj_in.resources=Null:C1517)
				$Obj_in.resources:=$Obj_types.resources
			End if 
			If ($Obj_in.sources=Null:C1517)
				$Obj_in.sources:=$Obj_types.sources
			End if 
			
			Case of 
					
				: ($Obj_in.name="manifest.json")
					  // Ignore
					$Obj_out.success:=True:C214
					
				: ($Obj_in.proj=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("proj must be defined")
					
				: ($Obj_in.uuid=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("uuid must be defined")
					
				: ($Obj_in.name=Null:C1517)
					
					$Obj_out.errors:=New collection:C1472("name must be defined")
					
				: (Not:C34($Obj_types.success))
					
					ob_error_combine ($Obj_out;$Obj_types;"No xcode project file type for "+String:C10($Obj_in.name))
					
				Else 
					  // project is in tree mode or not?
					If (Bool:C1537($Obj_in.tree))  // could force with parameter
						$Bool_tree:=$Obj_in.tree
					Else 
						  // Tree mode if rootObject is not a reference but an object
						$Bool_tree:=Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27
					End if 
					
					If (Value type:C1509($Obj_in.uuid)=Is text:K8:3)  // could be passed as unique string
						$Obj_in.uuid:=New object:C1471("parent";$Obj_in.uuid)
					End if 
					
					$Obj_objects:=$Obj_in.proj.objects
					$Col_children:=$Obj_objects[$Obj_in.uuid.parent].children
					If ($Col_children#Null:C1517)
						
						  /// in xcode tree
						$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
						$Obj_file:=New object:C1471(\
							"path";$Obj_in.name;\
							"isa";"PBXFileReference";\
							"sourceTree";"<group>";\
							"fileEncoding";"4";\
							"lastKnownFileType";$Obj_in.type\
							)
						$Obj_objects[$Txt_fileRef]:=$Obj_file
						
						If (Value type:C1509($Obj_in.uuid)=Is text:K8:3)  // could be passed as unique string
							$Obj_in.uuid:=New object:C1471("parent";$Obj_in.uuid)
						End if 
						
						$Obj_tableGroup:=$Obj_objects[$Obj_in.uuid.parent]
						If ($Bool_tree)
							$Obj_file.ref:=$Txt_fileRef
							$Col_children.push($Obj_file)
						Else 
							$Col_children.push($Txt_fileRef)
						End if 
						$Obj_out.file:=$Obj_file
						$Obj_out.fileRef:=$Txt_fileRef
						
						  // If resource
						If (Bool:C1537($Obj_in.resources))
							$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
							$Obj_buildfile:=New object:C1471(\
								"fileRef";$Txt_fileRef;\
								"isa";"PBXBuildFile"\
								)
							$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
							$Col_children:=$Obj_objects[$Obj_in.uuid.resources].files
							If ($Bool_tree)
								$Obj_buildfile.ref:=$Txt_buildfileRef
								$Col_children.push($Obj_buildfile)
							Else 
								$Col_children.push($Txt_buildfileRef)
							End if 
							
							$Obj_out.resource:=$Obj_buildfile
							$Obj_out.resourceRef:=$Txt_buildfileRef
						End if 
						
						  // If source
						If (Bool:C1537($Obj_in.sources))
							$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
							$Obj_buildfile:=New object:C1471(\
								"fileRef";$Txt_fileRef;\
								"isa";"PBXBuildFile"\
								)
							$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
							$Col_children:=$Obj_objects[$Obj_in.uuid.sources].files
							If ($Bool_tree)
								$Obj_buildfile.ref:=$Txt_buildfileRef
								$Col_children.push($Obj_buildfile)
							Else 
								$Col_children.push($Txt_buildfileRef)
							End if 
							
							$Obj_out.build:=$Obj_buildfile
							$Obj_out.buildRef:=$Txt_buildfileRef
						End if 
						  // Else // No collection children, maybe object do not accept children like Assets, folder pointer
						
						$Obj_out.success:=True:C214
					End if 
					
			End case 
			
			  //______________________________________________________
		: ($Obj_in.action="addSwift")  // XXX or build object
			
			If (($Obj_in.proj#Null:C1517) & ($Obj_in.uuid#Null:C1517) & ($Obj_in.name#Null:C1517))
				
				  // project is in tree mode or not?
				If (Bool:C1537($Obj_in.tree))  // could force with parameter
					$Bool_tree:=$Obj_in.tree
				Else 
					  // Tree mode if rootObject is not a reference but an object
					$Bool_tree:=Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27
				End if 
				
				$Obj_objects:=$Obj_in.proj.objects
				
				  // Swift files
				  /// in xcode tree
				$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
				$Obj_file:=New object:C1471(\
					"path";$Obj_in.name;\
					"isa";"PBXFileReference";\
					"sourceTree";"<group>";\
					"fileEncoding";"4";\
					"lastKnownFileType";"sourcecode.swift"\
					)
				$Obj_objects[$Txt_fileRef]:=$Obj_file
				
				$Obj_tableGroup:=$Obj_objects[$Obj_in.uuid.parent]
				$Col_children:=$Obj_tableGroup.children
				If ($Bool_tree)
					$Obj_file.ref:=$Txt_fileRef
					$Col_children.push($Obj_file)
				Else 
					$Col_children.push($Txt_fileRef)
				End if 
				$Obj_out.file:=$Obj_file
				$Obj_out.fileRef:=$Txt_fileRef
				
				  /// in xcode build phase
				$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
				$Obj_buildfile:=New object:C1471(\
					"fileRef";$Txt_fileRef;\
					"isa";"PBXBuildFile"\
					)
				$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
				$Col_children:=$Obj_objects[$Obj_in.uuid.sources].files
				If ($Bool_tree)
					$Obj_buildfile.ref:=$Txt_buildfileRef
					$Col_children.push($Obj_buildfile)
				Else 
					$Col_children.push($Txt_buildfileRef)
				End if 
				
				$Obj_out.build:=$Obj_buildfile
				$Obj_out.buildRef:=$Txt_buildfileRef
				
				$Obj_out.success:=True:C214
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj, uuid and name must be defined")
				
			End if 
			  //______________________________________________________
		: ($Obj_in.action="addStoryboard")  // XXX or resource object
			
			If (($Obj_in.proj#Null:C1517) & ($Obj_in.uuid#Null:C1517) & ($Obj_in.name#Null:C1517))
				
				  // project is in tree mode or not?
				If (Bool:C1537($Obj_in.tree))  // could force with parameter
					$Bool_tree:=$Obj_in.tree
				Else 
					  // Tree mode if rootObject is not a reference but an object
					$Bool_tree:=Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27
				End if 
				
				$Obj_objects:=$Obj_in.proj.objects
				
				  /// in xcode tree
				$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
				$Obj_file:=New object:C1471(\
					"path";$Obj_in.name;\
					"isa";"PBXFileReference";\
					"sourceTree";"<group>";\
					"fileEncoding";"4";\
					"lastKnownFileType";"file.storyboard"\
					)
				$Obj_objects[$Txt_fileRef]:=$Obj_file
				$Obj_tableGroup:=$Obj_objects[$Obj_in.uuid.parent]
				$Col_children:=$Obj_tableGroup.children
				If ($Bool_tree)
					$Obj_file.ref:=$Txt_fileRef
					$Col_children.push($Obj_file)
				Else 
					$Col_children.push($Txt_fileRef)
				End if 
				$Obj_out.file:=$Obj_file
				$Obj_out.fileRef:=$Txt_fileRef
				
				$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
				$Obj_buildfile:=New object:C1471(\
					"fileRef";$Txt_fileRef;\
					"isa";"PBXBuildFile"\
					)
				$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
				$Col_children:=$Obj_objects[$Obj_in.uuid.resources].files
				If ($Bool_tree)
					$Obj_buildfile.ref:=$Txt_buildfileRef
					$Col_children.push($Obj_buildfile)
				Else 
					$Col_children.push($Txt_buildfileRef)
				End if 
				
				$Obj_out.resource:=$Obj_buildfile
				$Obj_out.resourceRef:=$Txt_buildfileRef
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj, uuid and name must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="addTableForm")
			
			If (($Obj_in.proj#Null:C1517) & ($Obj_in.table#Null:C1517) & ($Obj_in.uuid#Null:C1517))
				
				ASSERT:C1129($Obj_in.uuid.tableFormsGroup#Null:C1517)  // Key For Sources/Form/Table
				ASSERT:C1129($Obj_in.uuid.sources#Null:C1517)  // Key for source build phase
				ASSERT:C1129($Obj_in.uuid.resources#Null:C1517)  // Key for resources phrase
				
				  // project is in tree mode or not?
				If (Bool:C1537($Obj_in.tree))  // could force with parameter
					$Bool_tree:=$Obj_in.tree
				Else 
					  // Tree mode if rootObject is not a reference but an object
					$Bool_tree:=Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27
				End if 
				
				$Txt_tableName:=$Obj_in.table
				ASSERT:C1129(Length:C16($Txt_tableName)>0)  // xxx make not success instead
				
				$Obj_objects:=$Obj_in.proj.objects
				
				  // Create a Group for the table
				$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
				$Obj_tableGroup:=New object:C1471(\
					"path";$Txt_tableName;\
					"isa";"PBXGroup";\
					"sourceTree";"<group>";\
					"children";New collection:C1472\
					)
				  /// ...and add it
				$Obj_objects[$Txt_fileRef]:=$Obj_tableGroup
				$Col_children:=$Obj_objects[$Obj_in.uuid.tableFormsGroup].children
				If ($Bool_tree)
					$Obj_tableGroup.ref:=$Txt_fileRef
					$Col_children.push($Obj_tableGroup)
				Else 
					$Col_children.push($Txt_fileRef)
				End if 
				
				  // Add swift and storyboard files to table group created, and in build phase
				
				For each ($Txt_formType;New collection:C1472("ListForm";"DetailForm"))
					
					  // Swift files
					  /// in xcode tree
					$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_file:=New object:C1471(\
						"path";$Txt_tableName+$Txt_formType+".swift";\
						"isa";"PBXFileReference";\
						"sourceTree";"<group>";\
						"fileEncoding";"4";\
						"lastKnownFileType";"sourcecode.swift"\
						)
					$Obj_objects[$Txt_fileRef]:=$Obj_file
					$Col_children:=$Obj_tableGroup.children
					If ($Bool_tree)
						$Obj_file.ref:=$Txt_fileRef
						$Col_children.push($Obj_file)
					Else 
						$Col_children.push($Txt_fileRef)
					End if 
					
					  /// in xcode build phase
					$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_buildfile:=New object:C1471(\
						"fileRef";$Txt_fileRef;\
						"isa";"PBXBuildFile"\
						)
					$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
					$Col_children:=$Obj_objects[$Obj_in.uuid.sources].files
					If ($Bool_tree)
						$Obj_buildfile.ref:=$Txt_buildfileRef
						$Col_children.push($Obj_buildfile)
					Else 
						$Col_children.push($Txt_buildfileRef)
					End if 
					
					  // storyboard files
					  /// in xcode tree
					$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_file:=New object:C1471(\
						"path";$Txt_tableName+$Txt_formType+".storyboard";\
						"isa";"PBXFileReference";\
						"sourceTree";"<group>";\
						"fileEncoding";"4";\
						"lastKnownFileType";"file.storyboard"\
						)
					$Obj_objects[$Txt_fileRef]:=$Obj_file
					$Col_children:=$Obj_tableGroup.children
					If ($Bool_tree)
						$Obj_file.ref:=$Txt_fileRef
						$Col_children.push($Obj_file)
					Else 
						$Col_children.push($Txt_fileRef)
					End if 
					
					$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_buildfile:=New object:C1471(\
						"fileRef";$Txt_fileRef;\
						"isa";"PBXBuildFile"\
						)
					$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
					$Col_children:=$Obj_objects[$Obj_in.uuid.resources].files
					If ($Bool_tree)
						$Obj_buildfile.ref:=$Txt_buildfileRef
						$Col_children.push($Obj_buildfile)
					Else 
						$Col_children.push($Txt_buildfileRef)
					End if 
					
				End for each 
				
				$Obj_out.success:=True:C214
				$Obj_out.value:=$Obj_in.proj
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj, uuid and table must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="addTableJSON")
			
			If (($Obj_in.proj#Null:C1517) & ($Obj_in.table#Null:C1517) & ($Obj_in.uuid#Null:C1517))
				
				$Obj_objects:=$Obj_in.proj.objects
				$Txt_tableName:=$Obj_in.table
				
				ASSERT:C1129($Obj_in.uuid.resources#Null:C1517)  // Key for resources phrase
				ASSERT:C1129($Obj_in.uuid.json#Null:C1517)  // Keys for JSON structures and data groups
				
				  // XXX maybe add option to add only catalog or data (filter)
				OB GET PROPERTY NAMES:C1232($Obj_in.uuid.json;$tTxt_keys)
				
				For ($Lon_i;1;Size of array:C274($tTxt_keys);1)
					$Txt_formType:=$tTxt_keys{$Lon_i}
					
					  // Add file in xcode tree
					$Txt_fileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_file:=New object:C1471(\
						"path";$Txt_tableName+"."+$Txt_formType+".json";\
						"isa";"PBXFileReference";\
						"sourceTree";"<group>";\
						"fileEncoding";"4";\
						"lastKnownFileType";"txt.json"\
						)
					$Obj_objects[$Txt_fileRef]:=$Obj_file
					$Col_children:=$Obj_objects[$Obj_in.uuid.json[$Txt_formType]].children
					If ($Bool_tree)
						$Obj_file.ref:=$Txt_fileRef
						$Col_children.push($Obj_file)
					Else 
						$Col_children.push($Txt_fileRef)
					End if 
					
					  // Add file in resource phase
					$Txt_buildfileRef:=XcodeProj (New object:C1471("action";"randomObjectId";"proj";$Obj_in.proj)).value
					$Obj_buildfile:=New object:C1471(\
						"fileRef";$Txt_fileRef;\
						"isa";"PBXBuildFile"\
						)
					$Obj_objects[$Txt_buildfileRef]:=$Obj_buildfile
					$Col_children:=$Obj_objects[$Obj_in.uuid.resources].files
					If ($Bool_tree)
						$Obj_buildfile.ref:=$Txt_buildfileRef
						$Col_children.push($Obj_buildfile)
					Else 
						$Col_children.push($Txt_buildfileRef)
					End if 
					
				End for 
				
				$Obj_out.success:=True:C214
				$Obj_out.value:=$Obj_in.proj
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj and table must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="tree")
			  // Replace all object references by the corresponding object
			
			If ($Obj_in.proj#Null:C1517)
				
				$Obj_objects:=$Obj_in.proj.objects
				
				  // rootObject
				$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_in.proj.rootObject)
				
				If ($Obj_object_child#Null:C1517)
					
					$Obj_in.proj.rootObject:=$Obj_object_child
					
				End if 
				
				  // for each objects
				OB GET PROPERTY NAMES:C1232($Obj_objects;$tTxt_keys)
				
				For ($Lon_i;1;Size of array:C274($tTxt_keys);1)
					
					$Txt_objectRef:=$tTxt_keys{$Lon_i}
					$Obj_object:=OB Get:C1224($Obj_objects;$Txt_objectRef)
					$Obj_object["ref"]:=$Txt_objectRef  // save reference in object
					
					  // Check childrens for each objects
					XcodeProj (New object:C1471(\
						"action";"refsToCollection";\
						"key";"children";\
						"object";$Obj_object;\
						"objects";$Obj_objects\
						))
					
					  // Check files for each objects
					XcodeProj (New object:C1471(\
						"action";"refsToCollection";\
						"key";"files";\
						"object";$Obj_object;\
						"objects";$Obj_objects\
						))
					
					If ($Obj_object.isa="PBXNativeTarget")
						
						XcodeProj (New object:C1471(\
							"action";"refsToCollection";\
							"key";"buildPhases";\
							"object";$Obj_object;\
							"objects";$Obj_objects\
							))
						
						If ($Obj_object.buildConfigurationList#Null:C1517)
							
							If (Value type:C1509($Obj_object.buildConfigurationList)=Is text:K8:3)
								
								$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.buildConfigurationList)
								
								If ($Obj_object_child#Null:C1517)
									
									$Obj_object.buildConfigurationList:=$Obj_object_child
									
								End if 
								
							End if 
							
						End if 
						
						If ($Obj_object.productReference#Null:C1517)
							
							$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.productReference)
							
							If ($Obj_object_child#Null:C1517)
								
								$Obj_object.product:=$Obj_object_child
								
							End if 
							
						End if 
						
					End if 
					
					If ($Obj_object.isa="PBXProject")
						
						If ($Obj_object.buildConfigurationList#Null:C1517)
							
							$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.buildConfigurationList)
							
							If ($Obj_object_child#Null:C1517)
								
								$Obj_object.buildConfigurationList:=$Obj_object_child
								
							End if 
							
						End if 
						
						XcodeProj (New object:C1471(\
							"action";"refsToCollection";\
							"key";"targets";\
							"object";$Obj_object;\
							"objects";$Obj_objects\
							))
						
						If ($Obj_object.mainGroup#Null:C1517)
							
							$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.mainGroup)
							
							If ($Obj_object_child#Null:C1517)
								
								$Obj_object.mainGroup:=$Obj_object_child
								
							End if 
							
						End if 
						
					End if 
					
					If ($Obj_object.productRefGroup#Null:C1517)
						
						$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.productRefGroup)
						
						If ($Obj_object_child#Null:C1517)
							
							$Obj_object.productGroup:=$Obj_object_child
							
						End if 
						
					End if 
					
					If ($Obj_object.isa="XCConfigurationList")
						
						XcodeProj (New object:C1471(\
							"action";"refsToCollection";\
							"key";"buildConfigurations";\
							"object";$Obj_object;\
							"objects";$Obj_objects\
							))
						
					End if 
					
					If ($Obj_object.isa="PBXBuildFile")
						
						If ($Obj_object.fileRef#Null:C1517)
							
							$Obj_object_child:=OB Get:C1224($Obj_objects;$Obj_object.fileRef)
							
							If ($Obj_object_child#Null:C1517)
								
								$Obj_object.file:=$Obj_object_child
								
							End if 
							
						End if 
						
					End if 
					
				End for 
				
				$Obj_out.success:=True:C214
				$Obj_out.value:=$Obj_in.proj
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="untree")
			  // Replace all objects by the corresponding object reference
			
			If ($Obj_in.proj#Null:C1517)
				
				If (Value type:C1509($Obj_in.proj.rootObject)=Is object:K8:27)
					
					$Obj_in.proj.rootObject:=OB Get:C1224($Obj_in.proj.rootObject;"ref")
					
				End if 
				
				If ($Obj_in.proj.objects#Null:C1517)
					
					$Obj_objects:=$Obj_in.proj.objects
					
					OB GET PROPERTY NAMES:C1232($Obj_objects;$tTxt_keys)
					
					For ($Lon_i;1;Size of array:C274($tTxt_keys);1)
						
						$Txt_objectRef:=$tTxt_keys{$Lon_i}
						$Obj_object:=OB Get:C1224($Obj_objects;$Txt_objectRef)
						
						If ($Obj_object.files#Null:C1517)
							
							$Obj_object.files:=$Obj_object.files.extract("ref")
							
						End if 
						
						If ($Obj_object.children#Null:C1517)
							
							$Obj_object.children:=$Obj_object.children.extract("ref")
							
						End if 
						
						If ($Obj_object.isa="PBXBuildFile")
							
							If ($Obj_object.file#Null:C1517)
								
								OB REMOVE:C1226($Obj_object;"file")  // keep fileRef
								
							End if 
							
						End if 
						
						If ($Obj_object.isa="PBXNativeTarget")
							
							If ($Obj_object.buildPhases#Null:C1517)
								
								$Obj_object.buildPhases:=$Obj_object.buildPhases.extract("ref")
								
							End if 
							
							If (Value type:C1509($Obj_object.buildConfigurationList)=Is object:K8:27)
								
								$Obj_object.buildConfigurationList:=OB Get:C1224($Obj_object.buildConfigurationList;"ref")
								
							End if 
							
							If ($Obj_object.product#Null:C1517)
								
								OB REMOVE:C1226($Obj_object;"product")  // keep productRef
								
							End if 
							
						End if 
						
						If ($Obj_object.isa="XCConfigurationList")
							
							If ($Obj_object.buildConfigurations#Null:C1517)
								
								$Obj_object.buildConfigurations:=$Obj_object.buildConfigurations.extract("ref")
								
							End if 
							
						End if 
						
						If ($Obj_object.isa="PBXProject")
							
							If ($Obj_object.targets#Null:C1517)
								
								$Obj_object.targets:=$Obj_object.targets.extract("ref")
								
							End if 
							
							If (Value type:C1509($Obj_object.buildConfigurationList)=Is object:K8:27)
								
								$Obj_object.buildConfigurationList:=OB Get:C1224($Obj_object.buildConfigurationList;"ref")
								
							End if 
							
							If (Value type:C1509($Obj_object.mainGroup)=Is object:K8:27)
								
								$Obj_object.mainGroup:=OB Get:C1224($Obj_object.mainGroup;"ref")
								
							End if 
							
							If ($Obj_object.productGroup#Null:C1517)
								
								OB REMOVE:C1226($Obj_object;"productGroup")  // keep productRefGroup
								
							End if 
							
						End if 
						
					End for 
					
					For ($Lon_i;1;Size of array:C274($tTxt_keys);1)
						
						$Txt_objectRef:=$tTxt_keys{$Lon_i}
						$Obj_object:=OB Get:C1224($Obj_objects;$Txt_objectRef)
						OB REMOVE:C1226($Obj_object;"ref")
						
					End for 
					
					$Obj_out.success:=True:C214
					$Obj_out.value:=$Obj_in.proj
					
				Else 
					
					$Obj_out.errors:=New collection:C1472("proj have no objects field")
					
				End if 
				
			Else 
				
				$Obj_out.errors:=New collection:C1472("proj must be defined")
				
			End if 
			
			  //______________________________________________________
		: ($Obj_in.action="refsToCollection")
			
			  // Replace the references in .object[.key] collection by its object
			  // found in .objects
			  // XXX maybe create an external method
			
			$Txt_buffer:=$Obj_in.key  // the key of element (files, children)
			$Obj_object:=$Obj_in.object  // the object to modify
			$Obj_objects:=$Obj_in.objects  // dictionary of object bt references
			
			If (Value type:C1509($Obj_object[$Txt_buffer])=Is collection:K8:32)
				
				$Col_children:=New collection:C1472
				
				For each ($Txt_buffer;$Obj_object[$Txt_buffer])
					
					$Obj_object_child:=OB Get:C1224($Obj_objects;$Txt_buffer)
					
					If (Value type:C1509($Obj_object_child)=Is object:K8:27)
						
						$Col_children.push($Obj_object_child)
						
					End if 
					
				End for each 
				
				$Obj_object[$Txt_buffer]:=$Col_children
				
			End if 
			
			
			  //______________________________________________________
		: ($Obj_in.action="filetype")
			  // Replace all objects by the corresponding object reference
			
			$Obj_out.success:=True:C214
			
			$Obj_in.extension:=Path to object:C1547($Obj_in.filename).extension
			
			Case of 
					
					  //________________________________________
				: (Length:C16($Obj_in.extension)=0)
					
					$Obj_out.success:=False:C215
					
					  //________________________________________
				: ($Obj_in.extension=".storyboard")
					
					$Obj_out.type:="file.storyboard"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".xib")
					
					$Obj_out.type:="file.xib"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".swift")
					
					$Obj_out.type:="sourcecode.swift"
					$Obj_out.sources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".md")
					
					$Obj_out.type:="net.daringfireball.markdown"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".bundle")
					
					$Obj_out.type:="wrapper.plug-in"
					$Obj_out.resources:=True:C214
					$Obj_out.folder:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".xcassets")
					
					$Obj_out.type:="folder.assetcatalog"
					$Obj_out.resources:=True:C214
					$Obj_out.folder:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".plist")
					
					$Obj_out.type:="text.plist.xml"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".html")\
					 | ($Obj_in.extension=".htm")
					
					$Obj_out.type:="text.html"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".txt")\
					 | ($Obj_in.extension=".svg")
					
					$Obj_out.type:="text"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".sketch")\
					 | ($Obj_in.extension=".ai")
					
					$Obj_out.type:="text"  // just design resource
					
					  //________________________________________
				: ($Obj_in.extension=".zip")
					
					$Obj_out.type:="archive.zip"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".strings")
					
					$Obj_out.type:="text.plist.strings"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".png")
					
					$Obj_out.type:="image.png"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".jpeg")\
					 | ($Obj_in.extension=".jpg")
					
					$Obj_out.type:="image.jpeg"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".gif")
					
					$Obj_out.type:="image.gif"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".pdf")
					
					$Obj_out.type:="image.pdf"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".ico")
					
					$Obj_out.type:="image.ico"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".json")
					
					$Obj_out.type:="text.json"
					$Obj_out.resources:=True:C214
					
					  //________________________________________
				: ($Obj_in.extension=".m")
					
					$Obj_out.type:="sourcecode.c.objc"
					
					  //$Obj_out.sources:=True //  not implemented (need a bridge header)
					
					  //________________________________________
				: ($Obj_in.extension=".h")
					
					$Obj_out.type:="sourcecode.c.h"
					
					  //$Obj_buffer.sources:=True //  not implemented
					
					  //________________________________________
				: ($Obj_in.extension=".ds_store")
					
					$Obj_out.success:=False:C215
					
					  //________________________________________
				Else 
					
					ob_warning_add ($Obj_out;"Unknown type of file '"+String:C10($Obj_in.extension)+"'. Could not be added to final project")
					ASSERT:C1129(dev_Matrix ;"Unknown type of file "+String:C10($Obj_in.extension))
					$Obj_out.success:=False:C215
					
					  //________________________________________
			End case 
			
			  //______________________________________________________
	End case 
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End