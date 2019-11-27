//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : storyboard_fix_id
  // Created 20-11-2019 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // fix storyboard xml
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters;$Lon_ids)
C_OBJECT:C1216($Obj_element;$Obj_result)
C_OBJECT:C1216($Obj_nodeByIds;$Obj_tag;$Obj_child;$Obj_tagMapping;$Dom_child)
C_TEXT:C284($Txt_tagPrefix;$Txt_tagInterfix;$Txt_tagFullPrefix;$Txt_tag;$Txt_buffer)

If (False:C215)
	C_OBJECT:C1216(storyboard_fix_id ;$0)
	C_OBJECT:C1216(storyboard_fix_id ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_element:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

  // Get children
$Obj_result.children:=$Obj_element.dom.children(True:C214)
$Obj_result.element:=$Obj_element

$Txt_tagPrefix:="TAG-"
$Txt_tagInterfix:="FD"

If ($Obj_result.children.success)
	
	  // get node by id (suppose no duplicate id)
	$Obj_nodeByIds:=New object:C1471()
	
	$Obj_tag:=$Obj_element.dom.getAttribute("id")
	If ($Obj_tag.success)
		If (Position:C15($Txt_tagPrefix;$Obj_tag.value)#1)  // has prefix, check interfix
			$Obj_nodeByIds[$Obj_tag.value]:=$Obj_child  // no tag prefix, will be replaced too
		End if 
		
		$Txt_tagInterfix:=Substring:C12($Obj_tag.value;5;2)  // get interfix (expect unique... maybe do some work)
		
	End if 
	
	For each ($Obj_child;$Obj_result.children.elements)
		
		$Obj_tag:=$Obj_child.getAttribute("id")
		If ($Obj_tag.success)
			$Obj_nodeByIds[$Obj_tag.value]:=$Obj_child
		End if 
		
	End for each 
	
	  // Find current max tag ID if already started to replace tags
	$Txt_tagFullPrefix:=$Txt_tagPrefix+$Txt_tagInterfix+"-"
	$Lon_ids:=0
	$Dom_child:=New object:C1471("success";True:C214)
	While ($Dom_child.success)
		
		$Lon_ids:=$Lon_ids+1
		$Dom_child:=$Obj_element.dom.findById($Txt_tagFullPrefix+String:C10($Lon_ids+1;"##000"))
		
	End while 
	
	  // Look for wrong tags
	$Obj_tagMapping:=New object:C1471()
	For each ($Txt_tag;$Obj_nodeByIds)
		
		If (Position:C15($Txt_tagPrefix;$Txt_tag)#1)
			$Lon_ids:=$Lon_ids+1
			$Obj_tagMapping[$Txt_tag]:=$Txt_tagFullPrefix+String:C10($Lon_ids;"##000")
		End if 
	End for each 
	
	  // Make the tag id replacement
	$Txt_buffer:=$Obj_element.dom.export().variable
	For each ($Txt_tag;$Obj_tagMapping)
		
		$Txt_buffer:=Replace string:C233($Txt_buffer;$Txt_tag;$Obj_tagMapping[$Txt_tag])
		
	End for each 
	
	  // Recreate a new node
	$Obj_element.originalDom:=$Obj_element.dom  // store old one (useful to get parent or replace)
	$Obj_element.insertInto:=$Obj_element.originalDom.parent()
	$Obj_element.dom:=xml ("parse";New object:C1471("variable";$Txt_buffer))
	$Obj_element.tagInterfix:=$Txt_tagInterfix
	$Obj_element.idCount:=$Lon_ids  // TODO check if need +1 or -1 or not
	$Obj_result.success:=Bool:C1537($Obj_element.dom.success)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_result

  // ----------------------------------------------------
  // End