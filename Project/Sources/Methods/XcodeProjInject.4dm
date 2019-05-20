//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : XcodeProjInject
  // Created #2018 by Eric Marchand
  // ----------------------------------------------------
  // Description: Edit Xcode project file with recursivity

  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_OBJECT:C1216($Obj_in;$Obj_out)
C_OBJECT:C1216($Obj_project;$Obj_parent;$Obj_children;$Obj_uuid;$Obj_intermediate;$Obj_buffer)

C_TEXT:C284($File_buffer;$Txt_path;$Txt_parentpath;$Txt_filename;$Txt_parentuuid;$Txt_intermediate;$Txt_currentPath)

C_LONGINT:C283($Lon_parameters)

C_COLLECTION:C1488($Col_intermediate)

If (False:C215)
	C_OBJECT:C1216(XcodeProjInject ;$0)
	C_OBJECT:C1216(XcodeProjInject ;$1)
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

$Obj_project:=$Obj_in.proj

Case of 
		
		  //________________________________________
	: (Value type:C1509($Obj_in.node)=Is object:K8:27)
		
		$Obj_out.children:=New collection:C1472()
		
		$Col_intermediate:=$Obj_in.node.children.reduce("col_distinctObject";New collection:C1472())  // remove duplicate
		
		For each ($Obj_children;$Col_intermediate)
			
			  // Manage children with a target destination in project
			If (Length:C16(String:C10($Obj_children.target))>0)
				
				$Obj_buffer:=XcodeProjInject (New object:C1471(\
					"path";$Obj_children.target;\
					"types";$Obj_children.types;\
					"mapping";$Obj_in.mapping;\
					"proj";$Obj_in.proj;\
					"target";$Obj_in.target;\
					"uuid";$Obj_in.uuid\
					))
				ob_error_combine ($Obj_out;$Obj_buffer)
				$Obj_out.children.push($Obj_buffer)
				
			Else 
				
				  // ignore if no target (or maybe check intermediate folder
				
			End if 
			
			  // recursive on children if any
			If (Value type:C1509($Obj_children.children)=Is collection:K8:32)
				
				$Obj_buffer:=Path to object:C1547(String:C10($Obj_children.source))
				
				Case of 
						
					: (String:C10($Obj_buffer.extension)=".xcassets")
						
						If ((Path to object:C1547($Obj_buffer.parentFolder).name="Resources")\
							 & ($Obj_buffer.name="Assets"))
							
							  // Already inserted in default project
							
						Else 
							
							ob_warning_add ($Obj_out;"Asset '"+$Obj_children.source+"' will not be injected automatically in project. (Resources/Assets.xcassets are managed)")
							
						End if 
						
						  //----------------------------------------
					: (String:C10($Obj_buffer.name)="Carthage")
						
						  // Ignore sdk
						  //----------------------------------------
					Else 
						
						$Obj_buffer:=XcodeProjInject (New object:C1471(\
							"node";$Obj_children;\
							"mapping";$Obj_in.mapping;\
							"proj";$Obj_in.proj;\
							"target";$Obj_in.target;\
							"uuid";$Obj_in.uuid\
							))
						ob_error_combine ($Obj_out;$Obj_buffer)
						$Obj_out.children.push($Obj_buffer)
						
						  //----------------------------------------
				End case 
			End if 
		End for each 
		
		  //______________________________________________________
	: (Value type:C1509($Obj_in.path)=Is text:K8:3)
		
		  // XXX remove duplicated code
		
		$File_buffer:=$Obj_in.path
		$File_buffer:=Replace string:C233($File_buffer;$Obj_in.target;"")  // remove full path -> relative to project
		
		  //$File_buffer:=Convert path system to POSIX($File_buffer)  //  Manage posix mapping
		$File_buffer:="/"+Replace string:C233($File_buffer;Folder separator:K24:12;"/")  // Manage posix mapping
		
		If (Position:C15("/Carthage/";$File_buffer)=0)  // ignore carthage file, will be injected by sdk
			
			  ///  Look up for parent node
			$Txt_parentpath:=""
			
			  ///  look for the longuest, XXX maybe sort before to speed up or have a better tree structure...
			If (Position:C15("/";$File_buffer;2)=0)
				
				$Txt_parentpath:="/"
				
			Else 
				
				For each ($Txt_path;$Obj_in.mapping)
					
					If (Position:C15($Txt_path+"/";$File_buffer)=1)  // start with
						
						If (Length:C16($Txt_path)>Length:C16(String:C10($Txt_parentpath)))
							
							$Txt_parentpath:=$Txt_path
							
						End if 
					End if 
				End for each 
			End if 
			
			  // We have a parent node
			If (Length:C16(String:C10($Txt_parentpath))>0)
				
				  // take relative path to this parent
				$File_buffer:=Replace string:C233($File_buffer;$Txt_parentpath;"")
				
				  // get the parent object
				$Txt_parentuuid:=$Obj_in.mapping[$Txt_parentpath]
				$Obj_parent:=$Obj_project.objects[$Txt_parentuuid]
				
				  // get file file name and intermediate folder
				$Col_intermediate:=Split string:C1554($File_buffer;"/")  // XXX check if mapping has delimiter posix
				$Txt_filename:=$Col_intermediate.pop()
				
				  // If there is some folder to create, create it as xcode proj group
				$Txt_currentPath:=""
				
				If ($Obj_parent#Null:C1517)
					
					For each ($Txt_intermediate;$Col_intermediate)
						
						If (Length:C16($Txt_intermediate)>0)
							
							$Txt_currentPath:=$Txt_currentPath+"/"+$Txt_intermediate
							
							$Obj_intermediate:=XcodeProj (New object:C1471(\
								"action";"addGroup";\
								"proj";$Obj_project;\
								"name";$Txt_intermediate;\
								"uuid";$Txt_parentuuid))
							$Txt_parentuuid:=$Obj_intermediate.groupRef
							
							$Obj_in.mapping[$Txt_parentpath+$Txt_currentPath]:=$Txt_parentuuid
							
						End if 
					End for each 
					
					  // uuid of phase XXX maybe look it into project files instead of info from uuid
					$Obj_uuid:=New object:C1471(\
						"resources";String:C10($Obj_in.uuid.resources);\
						"sources";String:C10($Obj_in.uuid.sources);\
						"parent";$Txt_parentuuid)
					
					  // then add the file according to the type
					Case of 
							
							  // ----------------------------------------
						: ($Obj_in.types.indexOf("swift")>-1)
							
							  // add as source file
							$Obj_out.value:=XcodeProj (New object:C1471(\
								"action";"addSwift";\
								"proj";$Obj_project;\
								"name";$Txt_filename;\
								"uuid";$Obj_uuid))
							ob_error_combine ($Obj_out;$Obj_out.value)
							
							  // ----------------------------------------
						: ($Obj_in.types.indexOf("storyboard")>-1)
							
							  // add as resource file
							$Obj_out.value:=XcodeProj (New object:C1471(\
								"action";"addStoryboard";\
								"proj";$Obj_project;\
								"name";$Txt_filename;\
								"uuid";$Obj_uuid))
							ob_error_combine ($Obj_out;$Obj_out.value)
							
							  // ----------------------------------------
						Else 
							
							  // add as source file
							$Obj_out.value:=XcodeProj (New object:C1471(\
								"action";"addFile";\
								"proj";$Obj_project;\
								"name";$Txt_filename;\
								"uuid";$Obj_uuid))
							
							If (Position:C15(".";$Txt_filename)#1)  // Ignore hidden files for errors
								
								ob_error_combine ($Obj_out;$Obj_out.value)
								
							End if 
							
							  // ----------------------------------------
					End case 
					
					If (Value type:C1509($Obj_out.value)=Is object:K8:27)
						
						$Obj_out.value.parent:=New object:C1471("uuid";$Txt_parentuuid;\
							"path";$Txt_parentpath+$Txt_currentPath)
						
					End if 
					
				Else 
					
					If (Length:C16($Txt_parentuuid)>0)
						
						ASSERT:C1129(dev_Matrix ;"Could not add, no parent object "+$Txt_parentuuid+" in project: file path"+$File_buffer)
						
						  // Else Assert? here $Txt_parentuuid is empty, no parent found in hierarchy, could not add the file. Could be normal if a file under an asset or folder pointer
						
					End if 
				End if 
				
			Else 
				
				If (Position:C15("/.";$File_buffer)#1)
					
					ASSERT:C1129(dev_Matrix ;"No parent found in project for "+$File_buffer)
					
				End if 
			End if 
		End if 
		
		  //______________________________________________________
End case 

$Obj_out.success:=Not:C34(ob_error_has ($Obj_out))

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End