Class constructor
	var $1 : Object
	
	This:C1470.path:=$1
	
	If (This:C1470.path#Null:C1517)
		
		ASSERT:C1129(OB Instance of:C1731(This:C1470.path; 4D:C1709.File); "storyboard must be a file")
		
	End if 
	
Function randomID
	var $0 : Text
	var $1 : Integer
	
	var $t : Text
	var $i; $l : Integer
	
	$0:=Generate UUID:C1066
	$0:=Substring:C12($0; 1; 3)+"-"+Substring:C12($0; 4; 2)+"-"+Substring:C12($0; 7; 3)
	
Function randomIDS
	var $0 : Collection
	$0:=New collection:C1472
	
	var $l; $1 : Integer
	$l:=$1
	
	var $t : Text
	
	var $i : Integer
	For ($i; 1; $l; 1)
		
		$t:=Generate UUID:C1066
		$t:=Substring:C12($t; 1; 3)+"-"+Substring:C12($t; 4; 2)+"-"+Substring:C12($t; 7; 3)
		
		$0.push($t)
		
	End for 
	
Function insertInto  // ($Obj_element : Object; $text : Text; $at : Integer)
	C_OBJECT:C1216($0; $Dom_)
	
	var $Obj_element; $1 : Object
	$Obj_element:=$1
	var $text; $2 : Text
	$text:=$2
	var $at; $3 : Integer
	$at:=$3
	
	$Dom_:=Null:C1517
	Case of 
			
			// ----------------------------------------
		: ($Obj_element.insertMode="append")
			
			$Dom_:=$Obj_element.insertInto.append($text)
			
			// ----------------------------------------
		: ($Obj_element.insertMode="first")
			
			$Dom_:=$Obj_element.insertInto.insertFirst($text)
			
			// ----------------------------------------
		: ($Obj_element.insertMode="iteration")
			
			$Dom_:=$Obj_element.insertInto.insertAt($text; $at)
			
			// ----------------------------------------
	End case 
	
	If ($Dom_#Null:C1517)
		
		ob_removeFormula($Dom_)  // For debugging purpose remove all formula
		
	End if 
	$0:=$Dom_
	
	
/* If not set, find number of id to inject */
Function checkIDCount  // ($Obj_element : Object)
	var $Obj_element; $1 : Object
	$Obj_element:=$1
	
	C_LONGINT:C283($Lon_ids)
	$Lon_ids:=Num:C11($Obj_element.idCount)
	
	If ($Lon_ids=0)  // idCount, not defined, try to count into storyboard
		
		C_OBJECT:C1216($Dom_child)
		$Dom_child:=$Obj_element.dom  // 001 must be encapsulated node
		$Lon_ids:=0
		
		While ($Dom_child.success)
			
			$Lon_ids:=$Lon_ids+1
			$Dom_child:=$Obj_element.dom.findById("TAG-"+$Obj_element.tagInterfix+"-"+String:C10($Lon_ids+1; "##000"))
			
		End while 
		
		If ($Lon_ids=1)
			
			$Lon_ids:=32  // default value if not found
			
		End if 
	End if 
	
	$Obj_element.idCount:=$Lon_ids
	
/* If not set, update default parameters for insert mode */
Function checkInsert  // ($Obj_element : Object; $Obj_tags : Object)
	var $Obj_element; $1 : Object
	$Obj_element:=$1
	var $Obj_tags; $2 : Object
	$Obj_tags:=$2
	
	
	If ($Obj_element.insertInto=Null:C1517)
		$Obj_element.insertInto:=$Obj_element.dom.parent()
	End if 
	
	If (Length:C16(String:C10($Obj_element.insertMode))=0)
		
		$Obj_element.insertMode:="append"
		
	End if 
	
	// - Check if there is some mandatories tags before inserting
	If (Value type:C1509($Obj_element.tags.mandatories)=Is collection:K8:32)
		
		C_OBJECT:C1216($Obj_tag)
		For each ($Obj_tag; $Obj_element.tags.mandatories)
			
			If (String:C10($Obj_tags[String:C10($Obj_tag.key)])="")  // support not empty rules now
				
				$Obj_element.insertMode:="none"  // do not insert
				
			End if 
		End for each 
	End if 
	
	// Reformat storyboard document to follow xcode rules (line ending, attributes order, add missing resources)
Function format  // MAC ONLY
	var $0 : Object
	var $1 : Object  // file to format
	
	var $Txt_cmd; $Txt_error; $Txt_in; $Txt_out : Text
	var $Obj_in; $Obj_out : Object
	
	$Obj_out:=New object:C1471()
	
	$Obj_in:=New object:C1471("path"; $1)
	If (Value type:C1509($Obj_in.path)=Is text:K8:3)
		
		If (Test path name:C476(String:C10($Obj_in.path))=Is a document:K24:1)
			
			ASSERT:C1129(dev_Matrix; "Must not be string, now File")  // Deprecated, maybe be test ...
			$Obj_in.path:=File:C1566($Obj_in.path; fk platform path:K87:2)
			
		End if 
	End if 
	
	If ($1.exists)
		
		// Use temp file because inplace command do not reformat
		C_OBJECT:C1216($File_)
		$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".storyboard")
		$Obj_in.path.copyTo($File_.parent; $File_.name+$File_.extension)
		
		$Txt_cmd:="ibtool --upgrade "+str_singleQuoted($File_.path)+" --write "+str_singleQuoted($Obj_in.path.path)
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
			
			$Obj_out.success:=True:C214
			$File_.delete()  // delete temporary file
			
			If (Length:C16($Txt_out)>0)
				
				$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
				$File_.setText($Txt_out)
				$Obj_out:=plist(New object:C1471(\
					"action"; "object"; \
					"domain"; $File_.path))
				$File_.delete()  // delete temporary file
				
				If (($Obj_out.success)\
					 & ($Obj_out.value#Null:C1517))
					
					// errors
					Case of 
							
							//........................................
						: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is collection:K8:32)
							
							$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.document.errors"]
							
							//........................................
						: (Value type:C1509($Obj_out.value["com.apple.ibtool.document.errors"])=Is object:K8:27)
							
							$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.document.errors"])
							
							//........................................
						: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is collection:K8:32)
							
							$Obj_out.errors:=$Obj_out.value["com.apple.ibtool.errors"]
							
							//........................................
						: (Value type:C1509($Obj_out.value["com.apple.ibtool.errors"])=Is object:K8:27)
							
							$Obj_out.errors:=New collection:C1472($Obj_out.value["com.apple.ibtool.errors"])
							
							//........................................
					End case 
					
					If (Value type:C1509($Obj_out.errors)=Is collection:K8:32)
						
						$Obj_out.success:=$Obj_out.errors.length=0
						
					End if 
				End if 
			End if 
		End if 
		
		// ----------------------------------------
	Else 
		
		//$File_.delete()  // delete temporary file
		$Obj_out.errors:=New collection:C1472("path do not exist")
		
		// ----------------------------------------
	End if 
	
	$0:=$Obj_out
	
Function ibtoolVersion
	var $0; $Obj_out : Object
	
	// Get storyboard tool version (could be used to replace in storyboard header)
	var $Txt_cmd; $Txt_error; $Txt_in; $Txt_out : Text
	$Txt_cmd:="ibtool --version"
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
		
		If (Length:C16($Txt_out)>0)
			
			var $File_ : Object
			$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
			$File_.setText($Txt_out)
			$Obj_out:=plist(New object:C1471(\
				"action"; "object"; \
				"domain"; $File_.path))
			$File_.delete()
			
			If (($Obj_out.success)\
				 & ($Obj_out.value#Null:C1517))
				
				$Obj_out.version:=String:C10($Obj_out.value["com.apple.ibtool.version"]["bundle-version"])
				
			End if 
		End if 
	End if 
	$0:=$Obj_out
	
/* fix color asset according to theme. issues on simu*/
Function colorAssetFix
	var $0 : Object
	var $1 : Object
	
	var $t : Text
	var $asModification : Boolean
	var $node; $Dom_child; $root; $File_; $Obj_color; $Obj_out; $theme : Object
	
	$Obj_out:=New object:C1471()
	$theme:=$1
	
	$File_:=This:C1470.path
	
	// read file
	$root:=xml("load"; $File_)
	
	// find named colors
	$asModification:=False:C215
	
	If ($root.success)
		
		For each ($node; $root.findMany("/document/resources/namedColor").elements)
			
			// get color name
			$t:=$node.getAttribute("name").value
			
			If ($theme[$t]#Null:C1517)
				
				If (Value type:C1509($theme[$t])=Is object:K8:27)
					
					// get color xml child
					$Dom_child:=$node.firstChild()
					
					$Obj_color:=$theme[$t]
					
					// recreate node
					$Dom_child.remove()
					$Dom_child:=$node.create("color")
					$asModification:=True:C214
					
					Case of 
							
							//______________________________________________________
						: ($Obj_color.space="gray")
							
							If ($Obj_color.alpha=Null:C1517)
								
								$Obj_color.alpha:=1
								
							End if 
							
							$Dom_child.setAttributes(New object:C1471(\
								"white"; String:C10($Obj_color.white); \
								"alpha"; String:C10($Obj_color.alpha); \
								"colorSpace"; "custom"; \
								"customColorSpace"; "genericGamma22GrayColorSpace"))
							
							//______________________________________________________
						: ($Obj_color.space="srgb")
							
							If ($Obj_color.alpha=Null:C1517)
								
								$Obj_color.alpha:=255
								
							End if 
							
							$Dom_child.setAttributes(New object:C1471(\
								"alpha"; String:C10($Obj_color.alpha/255; "&xml"); \
								"red"; String:C10($Obj_color.red/255; "&xml"); \
								"green"; String:C10($Obj_color.green/255; "&xml"); \
								"blue"; String:C10($Obj_color.blue/255; "&xml"); \
								"colorSpace"; "custom"; \
								"customColorSpace"; "sRGB"))
							
							// ----------------------------------------
						Else 
							
							ASSERT:C1129("Unknown color space "+$Obj_color.space)
							
							// ----------------------------------------
					End case 
				End if 
			End if 
		End for each 
		
		If ($asModification)
			
			// write if there is one named colors (could also do it only if one attribute change)
			doc_UNLOCK_DIRECTORY(New object:C1471(\
				"path"; $File_.parent.platformPath))
			$root.save($File_)
			
			This:C1470.format()
			
		End if 
		
		$root.close()
		
	End if 
	
	$Obj_out.success:=True:C214
	
	$0:=$Obj_out
	
/* remove all empty image asset, and double*/
Function imageAssetFix
	var $0 : Object
	
	var $t : Text
	var $asModification : Boolean
	var $node; $attributes; $root : Object
	var $c : Collection
	
	$0:=New object:C1471(\
		"success"; False:C215)
	
	// Read file
	$root:=xml("load"; This:C1470.path)
	
	If ($root.success)
		
		// Find named colors
		For each ($node; $root.findMany("/document/resources/image").elements)
			
			$c:=New collection:C1472
			
			// Get  name
			$t:=$node.getAttribute("name").value
			
			If (Length:C16($t)=0)
				
				$node.remove()
				$asModification:=True:C214
				
			Else 
				
				If ($c.indexOf($t)>-1)
					
					$asModification:=True:C214
					
				Else 
					
					$c.push($t)
					
				End if 
			End if 
		End for each 
		
		// Remove empty value attribute of userDefinedRuntimeAttribute with type image
		For each ($node; $root.findByName("userDefinedRuntimeAttribute").elements)
			
			$attributes:=$node.attributes().attributes
			
			If (String:C10($attributes.type)="image")
				
				If ($attributes.value#Null:C1517)\
					 & (Length:C16(String:C10($attributes.value))=0)
					
					$node.removeAttribute("value")
					$asModification:=True:C214
					
				End if 
			End if 
		End for each 
		
		// Write if there is one modification
		If ($asModification)
			
			$root.save(This:C1470.path)
			This:C1470.format()
			
			$0.success:=True:C214
			
		End if 
		
		$root.close()
		
	End if 
	
/* fix potential duplicated id elements, due to copy paste in storyboard (as requested by PO) */
Function fixDomChildID($Obj_element : Object)
	var $0 : Object
	var $1 : Object
	
	var $t; $Txt_tag; $Txt_tagFullPrefix; $Txt_tagInterfix; $Txt_tagPrefix : Text
	var $Boo_haveWrongTag : Boolean
	var $Lon_current; $Lon_ids : Integer
	var $Obj_child; $Obj_element; $Obj_nodeByIds; $Obj_result; $Obj_tag; $Obj_tagMapping : Object
	
	$Obj_result:=New object:C1471(\
		"success"; False:C215)
	
	$Obj_result.children:=$Obj_element.dom.children(True:C214)
	$Obj_result.element:=$Obj_element
	
	$Txt_tagPrefix:="TAG-"
	$Txt_tagInterfix:="FD"
	
	If ($Obj_result.children.success)
		
		// get node by id (suppose no duplicate id)
		$Obj_nodeByIds:=New object:C1471()
		
		$Obj_tag:=$Obj_element.dom.getAttribute("id")
		If ($Obj_tag.success)
			If (Position:C15($Txt_tagPrefix; $Obj_tag.value)#1)  // has prefix, check interfix
				$Obj_nodeByIds[$Obj_tag.value]:=$Obj_child  // no tag prefix, will be replaced too
			End if 
			
			$Txt_tagInterfix:=Substring:C12($Obj_tag.value; 5; 2)  // get interfix (expect unique... maybe do some work)
			
		End if 
		
		For each ($Obj_child; $Obj_result.children.elements)
			
			$Obj_tag:=$Obj_child.getAttribute("id")
			If ($Obj_tag.success)
				$Obj_nodeByIds[$Obj_tag.value]:=$Obj_child
			End if 
			
		End for each 
		
		// Find current max tag ID if already started to replace tags
		$Txt_tagFullPrefix:=$Txt_tagPrefix+$Txt_tagInterfix+"-"
		$Lon_ids:=0
		$Boo_haveWrongTag:=False:C215
		For each ($Txt_tag; $Obj_nodeByIds)
			
			If (Position:C15($Txt_tagFullPrefix; $Txt_tag)=1)
				$Lon_current:=Num:C11(Replace string:C233($Txt_tag; $Txt_tagFullPrefix; ""))
				If ($Lon_current>$Lon_ids)
					$Lon_ids:=$Lon_current
				End if 
			Else 
				$Boo_haveWrongTag:=True:C214
			End if 
			
		End for each 
		
		// Look for wrong tags
		$Obj_tagMapping:=New object:C1471()
		For each ($Txt_tag; $Obj_nodeByIds)
			
			If (Position:C15($Txt_tagPrefix; $Txt_tag)#1)
				$Lon_ids:=$Lon_ids+1
				$Obj_tagMapping[$Txt_tag]:=$Txt_tagFullPrefix+String:C10($Lon_ids; "##000")
			End if 
		End for each 
		
		// Make the tag id replacement
		$t:=$Obj_element.dom.export().variable
		For each ($Txt_tag; $Obj_tagMapping)
			
			$t:=Replace string:C233($t; $Txt_tag; $Obj_tagMapping[$Txt_tag])
			
		End for each 
		
		// Recreate a new node
		If ($Boo_haveWrongTag)  //or $Obj_tagMapping key size  OPTI: if we do nothing, do not return new node (just edit the current one and add idCount)
			$Obj_element.originalDom:=$Obj_element.dom  // store old one (useful to get parent or replace)
			$Obj_element.insertInto:=$Obj_element.originalDom.parent()
			$Obj_element.dom:=xml("parse"; New object:C1471("variable"; $t))
			$Obj_element.tagInterfix:=$Txt_tagInterfix
		End if 
		
		$Obj_element.idCount:=$Lon_ids  // TODO check if need +1 or -1 or not
		$Obj_result.success:=Bool:C1537($Obj_element.dom.success)
		
	End if 
	
	$0:=$Obj_result
	
	
	// MARK : Form (extract to StoryboardForm?)
	
Function checkStoryboardPath
	C_OBJECT:C1216($Obj_template; $1)
	$Obj_template:=$1
	If ($Obj_template.storyboard=Null:C1517)  // set default path if not defined
		
		$Obj_template.storyboard:=$Obj_template.parent[This:C1470.type].storyboard
		
	End if 
	This:C1470.path:=Folder:C1567($Obj_template.source; fk platform path:K87:2).file(String:C10($Obj_template.storyboard))
	