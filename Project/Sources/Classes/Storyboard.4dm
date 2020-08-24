Class constructor
	C_OBJECT:C1216($1)
	This:C1470.path:=$1
	If (This:C1470.path#Null:C1517)
		ASSERT:C1129(OB Instance of:C1731(This:C1470.path; 4D:C1709.File); "storyboard must be a file")
	End if 
	
Function randomID
	C_TEXT:C284($0)
	$0:=Generate UUID:C1066
	$0:=Substring:C12($0; 1; 3)+"-"+Substring:C12($0; 4; 2)+"-"+Substring:C12($0; 7; 3)
	
Function randomIDS
	C_COLLECTION:C1488($0)
	$0:=New collection:C1472
	
	C_LONGINT:C283($1; $l)
	$l:=$1
	
	C_LONGINT:C283($i)
	C_TEXT:C284($Txt_buffer)
	For ($i; 1; $l; 1)
		
		$Txt_buffer:=Generate UUID:C1066
		$Txt_buffer:=Substring:C12($Txt_buffer; 1; 3)+"-"+Substring:C12($Txt_buffer; 4; 2)+"-"+Substring:C12($Txt_buffer; 7; 3)
		
		$0.push($Txt_buffer)
		
	End for 
	
	// Reformat storyboard document to follow xcode rules (line ending, attributes order, add missing resources)
Function format  // MAC ONLY
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($Obj_in)
	$Obj_in:=This:C1470
	If (Value type:C1509($Obj_in.path)=Is text:K8:3)
		
		If (Test path name:C476(String:C10($Obj_in.path))=Is a document:K24:1)
			
			ASSERT:C1129(dev_Matrix; "Must not be string, now File")  // Deprecated, maybe be test ...
			$Obj_in.path:=File:C1566($Obj_in.path; fk platform path:K87:2)
			
		End if 
	End if 
	
	Case of 
			
			// ----------------------------------------
		: ($Obj_in.path=Null:C1517)
			
			$Obj_out.errors:=New collection:C1472("path not defined")
			
			// ----------------------------------------
		: ($Obj_in.path.exists)
			
			// Use temp file because inplace command do not reformat
			C_OBJECT:C1216($File_)
			$File_:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".storyboard")
			$Obj_in.path.copyTo($File_.parent; $File_.name+$File_.extension)
			
			C_TEXT:C284($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
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
			
			$File_.delete()  // delete temporary file
			$Obj_out.errors:=New collection:C1472("path do not exist")
			
			// ----------------------------------------
	End case 
	
	$0:=$Obj_out
	
Function ibtoolVersion
	C_OBJECT:C1216($Obj_out; $File_)
	C_TEXT:C284($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	// Get storyboard tool version (could be used to replace in storyboard header)
	$Txt_cmd:="ibtool --version"
	LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
	
	If (Asserted:C1132(OK=1; "LEP failed: "+$Txt_cmd))
		
		If (Length:C16($Txt_out)>0)
			
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
	
/* fix color asset according to theme. issues on simu*/
Function colorAssetFix
	C_OBJECT:C1216($Obj_out; $0)
	$Obj_out:=New object:C1471()
	C_OBJECT:C1216($theme; $1)
	$theme:=$1
	
	C_OBJECT:C1216($File_)
	$File_:=This:C1470.path
	
	// read file
	C_OBJECT:C1216($Dom_root; $Dom_; $Dom_child)
	$Dom_root:=xml("load"; $File_)
	
	// find named colors
	C_BOOLEAN:C305($Boo_buffer)
	$Boo_buffer:=False:C215
	
	For each ($Dom_; $Dom_root.findMany("/document/resources/namedColor").elements)
		
		// get color name
		C_TEXT:C284($Txt_buffer)
		$Txt_buffer:=$Dom_.getAttribute("name").value
		
		If ($theme[$Txt_buffer]#Null:C1517)
			
			If (Value type:C1509($theme[$Txt_buffer])=Is object:K8:27)
				
				// get color xml child
				$Dom_child:=$Dom_.firstChild()
				
				C_OBJECT:C1216($Obj_color)
				$Obj_color:=$theme[$Txt_buffer]
				
				// recreate node
				$Dom_child.remove()
				$Dom_child:=$Dom_.create("color")
				$Boo_buffer:=True:C214
				
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
	
	If ($Boo_buffer)
		
		// write if there is one named colors (could also do it only if one attribute change)
		doc_UNLOCK_DIRECTORY(New object:C1471(\
			"path"; $File_.parent.platformPath))
		$Dom_root.save($File_)
		$Dom_root.close()
		
		This:C1470.format()
		
	End if 
	
	$Obj_out.success:=True:C214
	
	$0:=$Obj_out
	
/* remove all empty image asset, and double*/
Function imageAssetFix
	C_OBJECT:C1216($Obj_out; $0)
	$Obj_out:=New object:C1471()
	
	C_OBJECT:C1216($File_)
	$File_:=This:C1470.path
	
	// read file
	C_OBJECT:C1216($Dom_root; $Dom_)
	$Dom_root:=xml("load"; $File_)
	C_BOOLEAN:C305($Boo_buffer)
	$Boo_buffer:=False:C215
	
	// find named colors
	For each ($Dom_; $Dom_root.findMany("/document/resources/image").elements)
		
		C_COLLECTION:C1488($Col_)
		$Col_:=New collection:C1472
		
		// get  name
		C_TEXT:C284($Txt_buffer)
		$Txt_buffer:=$Dom_.getAttribute("name").value
		
		If (Length:C16($Txt_buffer)=0)
			
			$Dom_.remove()
			$Boo_buffer:=True:C214
			
		Else 
			
			If ($Col_.indexOf($Txt_buffer)>-1)
				
				$Boo_buffer:=True:C214
				
			Else 
				
				$Col_.push($Txt_buffer)
				
			End if 
		End if 
	End for each 
	
	// Remove empty value attribute of userDefinedRuntimeAttribute with type image
	For each ($Dom_; $Dom_root.findByName("userDefinedRuntimeAttribute").elements)
		
		C_OBJECT:C1216($Obj_attributes)
		$Obj_attributes:=$Dom_.attributes().attributes
		
		If (String:C10($Obj_attributes.type)="image")
			
			If ($Obj_attributes.value#Null:C1517)\
				 & (Length:C16(String:C10($Obj_attributes.value))=0)
				
				$Dom_.removeAttribute("value")
				$Boo_buffer:=True:C214
				
			End if 
		End if 
	End for each 
	
	// write if there is one modification
	If ($Boo_buffer)
		
		$Dom_root.save($File_)
		$Dom_root.close()
		
		This:C1470.format()
		
	End if 
	
	$Obj_out.success:=True:C214
	
	$0:=$Obj_out
	
/* fix potential duplicated id elements, due to copy paste in storyboard (as requested by PO) */
Function fixDomChildID($Obj_element : Object)
	C_OBJECT:C1216($0)
	C_OBJECT:C1216($1)
	
	C_LONGINT:C283($Lon_parameters; $Lon_ids; $Lon_current)
	C_OBJECT:C1216($Obj_result)
	C_OBJECT:C1216($Obj_nodeByIds; $Obj_tag; $Obj_child; $Obj_tagMapping; $Dom_child)
	C_TEXT:C284($Txt_tagPrefix; $Txt_tagInterfix; $Txt_tagFullPrefix; $Txt_tag; $Txt_buffer)
	C_BOOLEAN:C305($Boo_haveWrongTag)
	
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
		$Txt_buffer:=$Obj_element.dom.export().variable
		For each ($Txt_tag; $Obj_tagMapping)
			
			$Txt_buffer:=Replace string:C233($Txt_buffer; $Txt_tag; $Obj_tagMapping[$Txt_tag])
			
		End for each 
		
		// Recreate a new node
		If ($Boo_haveWrongTag)  //or $Obj_tagMapping key size  OPTI: if we do nothing, do not return new node (just edit the current one and add idCount)
			$Obj_element.originalDom:=$Obj_element.dom  // store old one (useful to get parent or replace)
			$Obj_element.insertInto:=$Obj_element.originalDom.parent()
			$Obj_element.dom:=xml("parse"; New object:C1471("variable"; $Txt_buffer))
			$Obj_element.tagInterfix:=$Txt_tagInterfix
		End if 
		
		$Obj_element.idCount:=$Lon_ids  // TODO check if need +1 or -1 or not
		$Obj_result.success:=Bool:C1537($Obj_element.dom.success)
		
	End if 
	
	$0:=$Obj_result
	