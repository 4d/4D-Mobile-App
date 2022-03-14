Class constructor
	var $1 : Object
	
	If (Count parameters:C259>0)
		This:C1470.path:=$1
		
		If (This:C1470.path#Null:C1517)
			
			ASSERT:C1129(OB Instance of:C1731(This:C1470.path; 4D:C1709.File); "storyboard must be a file")
			
		End if 
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
		: ($Obj_element.insertMode="none")
			
			// do not insert
			
		Else 
			
			ASSERT:C1129(False:C215; "Cannot known how to insert XML node. Missing insertMode on element")
			
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
Function checkInsertInto  // ($Obj_element : Object; $Obj_tags : Object)
	var $Obj_element; $1 : Object
	$Obj_element:=$1
	
	If ($Obj_element.insertInto=Null:C1517)
		$Obj_element.insertInto:=$Obj_element.dom.parent()
	End if 
	
Function checkInsert
	var $Obj_element; $1 : Object
	$Obj_element:=$1
	var $Obj_tags; $2 : Object
	$Obj_tags:=$2
	
	If (Length:C16(String:C10($Obj_element.insertMode))=0)
		
		$Obj_element.insertMode:="append"
		
	End if 
	
	// - Check if there is some mandatories tags before inserting
	If (Value type:C1509($Obj_element.tags.mandatories)=Is collection:K8:32)
		
		C_OBJECT:C1216($Obj_tag)
		For each ($Obj_tag; $Obj_element.tags.mandatories)
			
			If (String:C10(ob_getByPath($Obj_tags; String:C10($Obj_tag.key)).value)="")  // support not empty rules now
				
				$Obj_element.insertMode:="none"  // do not insert
				
			End if 
		End for each 
	End if 
	
	// Reformat storyboard document to follow xcode rules (line ending, attributes order, add missing resources)
Function format($Obj_in : Object)->$Obj_out : Object  // MAC ONLY
	var $Txt_cmd; $Txt_error; $Txt_in; $Txt_out : Text
	var $File_ : 4D:C1709.File
	
	$Obj_out:=New object:C1471()
	
	
	If (Not:C34(Is macOS:C1572))
		return   // just not format file on other OS > result, opening with Xcode project will make a lot of change in storyboard file (in vcs)
	End if 
	
	Case of 
		: (Count parameters:C259=0)
			$Obj_in:=New object:C1471("path"; This:C1470.path)
			
		: (OB Instance of:C1731($Obj_in; 4D:C1709.File))
			
			$Obj_in:=New object:C1471("path"; $Obj_in)  // CLEAN: remove all this compatibility code, only file must be passed
			
		: (File:C1566(String:C10($Obj_in.path); fk platform path:K87:2).exists)
			ASSERT:C1129(dev_Matrix; "Must not be string, now File")  // Deprecated, maybe be test ...
			$Obj_in.path:=File:C1566($Obj_in.path; fk platform path:K87:2)
			
			// Else maybe not exists
			
	End case 
	
	If ($Obj_in.path.exists)
		
		// Use temp file because inplace command do not reformat
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
				$Obj_out:=_o_plist(New object:C1471(\
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
	
Function _ibtoolVersion()->$Obj_out : Object
	
	// Get storyboard tool version (could be used to replace in storyboard header)
	var $Txt_cmd; $Txt_error; $Txt_in; $Txt_out : Text
	$Txt_cmd:="ibtool --version"
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
		
		If (Length:C16($Txt_out)>0)
			
			var $File_ : Object
			$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+"ibtool.plist")
			$File_.setText($Txt_out)
			$Obj_out:=_o_plist(New object:C1471(\
				"action"; "object"; \
				"domain"; $File_.path))
			$File_.delete()
			
			If (($Obj_out.success)\
				 & ($Obj_out.value#Null:C1517))
				
				$Obj_out.version:=String:C10($Obj_out.value["com.apple.ibtool.version"]["bundle-version"])
				
			End if 
		End if 
	End if 
	
/* fix color asset according to theme. issues on simu*/
Function colorAssetFix($theme : Object)->$Obj_out : Object
	var $t : Text
	var $asModification : Boolean
	var $node; $Dom_child; $root; $File_; $Obj_color : Object
	
	$Obj_out:=New object:C1471()
	$File_:=This:C1470.path
	
	// read file
	$root:=_o_xml("load"; $File_)
	
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
			_o_doc_UNLOCK_DIRECTORY(New object:C1471(\
				"path"; $File_.parent.platformPath))
			$root.save($File_)
			
			This:C1470.format()
			
		End if 
		
		$root.close()
		
	End if 
	
	$Obj_out.success:=True:C214
	
/* remove all empty image asset, and double*/
Function imageAssetFix()->$out : Object
	var $t : Text
	var $asModification : Boolean
	var $node; $attributes; $root : Object
	var $c : Collection
	
	$out:=New object:C1471(\
		"success"; False:C215)
	
	// Read file
	$root:=_o_xml("load"; This:C1470.path)
	
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
			
			$out.success:=True:C214
			
		End if 
		
		$root.close()
		
	End if 
	
/* fix potential duplicated id elements, due to copy paste in storyboard (as requested by PO) */
Function fixDomChildID($element : Object)->$result : Object
	
	var $t; $Txt_tag; $Txt_tagFullPrefix; $Txt_tagInterfix; $Txt_tagPrefix : Text
	var $Boo_haveWrongTag : Boolean
	var $Lon_current; $Lon_ids : Integer
	var $Obj_child; $Obj_nodeByIds; $Obj_tag; $Obj_tagMapping : Object
	
	$result:=New object:C1471(\
		"success"; False:C215)
	
	$result.children:=$element.dom.children(True:C214)
	$result.element:=$element
	
	$Txt_tagPrefix:="TAG-"
	$Txt_tagInterfix:="FD"
	
	If ($result.children.success)
		
		// get node by id (suppose no duplicate id)
		$Obj_nodeByIds:=New object:C1471()
		
		$Obj_tag:=$element.dom.getAttribute("id")
		If ($Obj_tag.success)
			If (Position:C15($Txt_tagPrefix; $Obj_tag.value)#1)  // has prefix, check interfix
				$Obj_nodeByIds[$Obj_tag.value]:=$Obj_child  // no tag prefix, will be replaced too
			End if 
			
			$Txt_tagInterfix:=Substring:C12($Obj_tag.value; 5; 2)  // get interfix (expect unique... maybe do some work)
			
		End if 
		
		For each ($Obj_child; $result.children.elements)
			
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
		$t:=$element.dom.export().variable
		For each ($Txt_tag; $Obj_tagMapping)
			
			$t:=Replace string:C233($t; $Txt_tag; $Obj_tagMapping[$Txt_tag])
			
		End for each 
		
		// Recreate a new node
		If ($Boo_haveWrongTag)  //or $Obj_tagMapping key size  OPTI: if we do nothing, do not return new node (just edit the current one and add idCount)
			$element.originalDom:=$element.dom  // store old one (useful to get parent or replace)
			$element.insertInto:=$element.originalDom.parent()
			$element.dom:=_o_xml("parse"; New object:C1471("variable"; $t))
			$element.tagInterfix:=$Txt_tagInterfix
		End if 
		
		$element.idCount:=$Lon_ids  // TODO check if need +1 or -1 or not
		$result.success:=Bool:C1537($element.dom.success)
		
	End if 
	
	
	// MARK : Form (extract to StoryboardForm?)
	
Function checkStoryboardPath
	C_OBJECT:C1216($Obj_template; $1)
	$Obj_template:=$1
	If ($Obj_template.storyboard=Null:C1517)  // set default path if not defined
		
		$Obj_template.storyboard:=$Obj_template.parent[This:C1470.type].storyboard
		
	End if 
	This:C1470.path:=Folder:C1567($Obj_template.source; fk platform path:K87:2).file(String:C10($Obj_template.storyboard))
	
	
Function relationSegue($relation : Object)
	C_TEXT:C284($0; $Txt_buffer)
	If ($relation.transition=Null:C1517)
		$relation.transition:=New object:C1471()
	End if 
	
	If (Length:C16(String:C10($relation.transition.kind))=0)
		$relation.transition.kind:="show"
		// else check type?
	End if 
	
	$Txt_buffer:="<segue destination=\"TAG-SN-001\""
	
	If ($relation.transition.customClass#Null:C1517)
		$Txt_buffer:=$Txt_buffer+" customClass=\""+String:C10($relation.transition.customClass)+"\""
	End if 
	If ($relation.transition.customModule#Null:C1517)
		$Txt_buffer:=$Txt_buffer+" customModule=\""+String:C10($relation.transition.customModule)+"\""
	End if 
	If ($relation.transition.modalPresentationStyle#Null:C1517)
		$Txt_buffer:=$Txt_buffer+" modalPresentationStyle=\""+String:C10($relation.transition.modalPresentationStyle)+"\""
	End if 
	If ($relation.transition.modalTransitionStyle#Null:C1517)
		$Txt_buffer:=$Txt_buffer+" modalTransitionStyle=\""+String:C10($relation.transition.modalTransitionStyle)+"\""
	End if 
	$Txt_buffer:=$Txt_buffer+" kind=\""+String:C10($relation.transition.kind)+"\""
	$Txt_buffer:=$Txt_buffer+" identifier=\"___FIELD___\" id=\"TAG-SG-001\"/>"
	
	$0:=$Txt_buffer
	
Function isRelationField($field : Object)->$is : Boolean
	$is:=PROJECT.isRelation($field)
	
Function injectElement
	C_OBJECT:C1216($Obj_field; $1; $Obj_tags; $2; $Obj_template; $3; $Obj_out; $6)
	C_LONGINT:C283($Lon_j; $4)
	C_BOOLEAN:C305($isHorizontal; $5)
	$Obj_field:=$1
	$Obj_tags:=$2
	$Obj_template:=$3
	$Lon_j:=$4
	$isHorizontal:=$5
	$Obj_out:=$6  // result (could be $0 if caller merge result)
	
	C_TEXT:C284($Txt_buffer)
	
	// Set tags:
	// - field
	$Obj_tags.field:=$Obj_field
	$Obj_tags.storyboardID:=New collection:C1472
	
	
	C_COLLECTION:C1488($Col_elements)
	If (This:C1470.isRelationField($Obj_field))  // relation to N field
		
		$Col_elements:=$Obj_template.relation.elements
		
	Else 
		
		$Col_elements:=$Obj_template.elements
		
	End if 
	
	// For each element... (scene, cell, ...)
	C_OBJECT:C1216($Obj_element)
	For each ($Obj_element; $Col_elements)
		
		This:C1470.checkInsert($Obj_element; $Obj_tags)
		
		If ($Obj_element.dom#Null:C1517)  // if valid element
			
			If ($isHorizontal)
				/// HEADER for row
				If ($Obj_element.insertIntoRow=Null:C1517)
					
					If ($Obj_element.insertInto.parent().getName().name="stackView")  // only on stack view (suppose only one element has stack view parent..., same as relation)
						$Txt_buffer:="<stackView opaque=\"NO\" contentMode=\"scaleToFill\" distribution=\"fillEqually\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"ROW-SV"+String:C10($Lon_j; "##000")+"\"></stackView>"
						$Obj_element.insertIntoRow:=$Obj_element.insertInto.append($Txt_buffer)
						$Txt_buffer:="<rect key=\"frame\" x=\"0.0\" y=\"200\" width=\"375\" height=\"97\"/>"
						$Dom_:=$Obj_element.insertIntoRow.append($Txt_buffer)
						$Txt_buffer:="<subviews></subviews>"
						$Obj_element.insertIntoRow:=$Obj_element.insertIntoRow.append($Txt_buffer)
					Else 
						$Obj_element.insertIntoRow:=$Obj_element.insertInto
					End if 
				End if 
				/// END HEADER for row
			End if 
			
			// - randoms ids
			If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
				
				C_OBJECT:C1216($Obj_storyboardID)
				$Obj_storyboardID:=New object:C1471(\
					"tagInterfix"; $Obj_element.tagInterfix; \
					"storyboardIDs"; This:C1470.randomIDS($Obj_element.idCount))
				
				$Obj_tags.storyboardID.push($Obj_storyboardID)  // By using a collection we have now TAG for previous elements also injected (could be useful for "connections")
				
			End if 
			
			// Process tags on the element
			$Txt_buffer:=$Obj_element.dom.export().variable
			$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; New collection:C1472("___TABLE___"; "detailform"; "storyboardID"))
			
			// Insert node for this element
			If (Bool:C1537($Obj_element.insertInto.success))
				
				C_OBJECT:C1216($Dom_)
				$Dom_:=This:C1470.insertInto($Obj_element; $Txt_buffer; $Lon_j)
				$Obj_out.doms.push($Dom_)
				
			Else 
				
				ob_error_add($Obj_out; "Failed to insert after processing tags '"+$Txt_buffer+"'")
				
			End if 
			
		End if 
	End for each 
	
	
Function xmlAppendRelationAttributeForField()->$response : Object
	C_LONGINT:C283($Lon_j; $1)
	$Lon_j:=$1
	C_OBJECT:C1216($Dom_root; $2)
	$Dom_root:=$2
	C_BOOLEAN:C305($IsToMany; $3)
	$IsToMany:=$3
	C_OBJECT:C1216($Dom_; $0)
	
	
	// find the element $Lon_j by looking at userDefinedRuntimeAttribute
	$Dom_:=$Dom_root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='bindTo.record.___FIELD_"+String:C10($Lon_j)+"___']")  // or value="___FIELD_1_BINDING_TYPE___"
	If ($Dom_.success)
		C_OBJECT:C1216($Dom_parent)
		$Dom_parent:=$Dom_.parent()
		
		C_TEXT:C284($Txt_buffer)
		If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationFormat]").success))
			$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationFormat\" value=\"___FIELD_"+String:C10($Lon_j)+"_FORMAT___\"/>"
			$Dom_parent.append(_o_xml("parse"; New object:C1471("variable"; $Txt_buffer)))
		End if 
		If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationName]").success))
			$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationName\" value=\"___FIELD_"+String:C10($Lon_j)+"___\"/>"
			$Dom_parent.append(_o_xml("parse"; New object:C1471("variable"; $Txt_buffer)))
		End if 
		If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationLabel]").success))
			$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationLabel\" value=\"___FIELD_"+String:C10($Lon_j)+"_LABEL___\"/>"
			$Dom_parent.append(_o_xml("parse"; New object:C1471("variable"; $Txt_buffer)))
		End if 
		If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationShortLabel]").success))
			$Txt_buffer:="<userDefinedRuntimeAttribute type=\"string\" keyPath=\"relationShortLabel\" value=\"___FIELD_"+String:C10($Lon_j)+"_SHORT_LABEL___\"/>"
			$Dom_parent.append(_o_xml("parse"; New object:C1471("variable"; $Txt_buffer)))
		End if 
		If (Not:C34($Dom_parent.findByXPath("[@keyPath=relationIsToMany]").success))
			$Txt_buffer:="<userDefinedRuntimeAttribute type=\"boolean\" keyPath=\"relationIsToMany\" value=\""+Choose:C955($IsToMany; "YES"; "NO")+"\"/>"
			$Dom_parent.append(_o_xml("parse"; New object:C1471("variable"; $Txt_buffer)))
		End if 
		
	End if 
	
	$0:=$Dom_
	
Function injectSegue
	C_LONGINT:C283($Lon_j; $1)
	$Lon_j:=$1
	C_OBJECT:C1216($Dom_root; $2)
	$Dom_root:=$2
	C_OBJECT:C1216($3; $Obj_field)
	$Obj_field:=$3
	C_OBJECT:C1216($4; $Obj_tags)
	$Obj_tags:=$4
	C_OBJECT:C1216($5; $Obj_template)
	$Obj_template:=$5
	C_OBJECT:C1216($6; $Obj_out)
	$Obj_out:=$6  // result (could be $0 if caller merge result)
	
	If (Length:C16(String:C10($Obj_field.bindingType))=0)
		$Obj_field.bindingType:="relation"  // TODO this must be done before when we are looking for binding
	End if 
	
	C_OBJECT:C1216($Dom_)
	$Dom_:=$Dom_root.findByXPath("//*/userDefinedRuntimeAttribute[@keyPath='bindTo.record.___FIELD_"+String:C10($Lon_j)+"___']")  // or value="___FIELD_1_BINDING_TYPE___"
	$Dom_:=$Dom_.parentWithName("scene").firstChild().firstChild()  // objects.XController (table view , view , collection view)
	
	If ($Dom_.success)
		
		$Obj_template.relation:=New object:C1471("elements"; New collection:C1472())
		
		//ASSERT(This.relationFolder#Null)
		C_OBJECT:C1216($Obj_element)
		$Obj_element:=New object:C1471(\
			"insertInto"; $Dom_root.findByXPath("/document/scenes"); \
			"dom"; _o_xml("load"; This:C1470.relationFolder.file("storyboardScene.xml")); \
			"idCount"; 3; \
			"tagInterfix"; "SN"; \
			"insertMode"; "append")
		$Obj_template.relation.elements.push($Obj_element)
		
		$Obj_element:=New object:C1471("idCount"; 1; \
			"insertInto"; $Dom_; \
			"tagInterfix"; "SG"; \
			"insertMode"; "append"\
			)
		
		C_TEXT:C284($Txt_buffer)
		$Txt_buffer:=This:C1470.relationSegue($Obj_template.relation)
		$Obj_element.insertInto:=$Obj_element.insertInto.findOrCreate("connections")  // Find its <connections> children, if not exist create it
		$Obj_element.dom:=_o_xml("parse"; New object:C1471("variable"; $Txt_buffer))
		$Obj_template.relation.elements.push($Obj_element)
		
		This:C1470.injectElement($Obj_field; $Obj_tags; $Obj_template; $Lon_j; False:C215; $Obj_out)
		
	Else 
		
		// Invalid relation
		ASSERT:C1129(dev_Matrix; "Cannot add relation on this template. Cannot find viewController: "+JSON Stringify:C1217($Obj_field))
		
	End if 
	
Function exportDom
	C_OBJECT:C1216($1; $Obj_template)
	$Obj_template:=$1
	C_OBJECT:C1216($2; $target)
	$target:=$2
	C_OBJECT:C1216($3; $Obj_tags)
	$Obj_tags:=$3
	C_OBJECT:C1216($4; $Dom_root)
	$Dom_root:=$4
	
	C_TEXT:C284($Txt_buffer)
	$Txt_buffer:=$Dom_root.export().variable
	$Txt_buffer:=Process_tags($Txt_buffer; $Obj_tags; New collection:C1472("storyboard"; "___TABLE___"))
	$Txt_buffer:=Replace string:C233($Txt_buffer; "<userDefinedRuntimeAttribute type=\"image\" keyPath=\"image\"/>"; "")  // Remove useless empty image
	
	C_OBJECT:C1216($File_)
	$File_:=$target.file(Process_tags(String:C10($Obj_template.storyboard); $Obj_tags; New collection:C1472("filename")))
	$File_.setText($Txt_buffer; "UTF-8"; Document with CRLF:K24:20)
	
	This:C1470.format($File_)