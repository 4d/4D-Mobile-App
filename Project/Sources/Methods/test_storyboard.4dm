//%attributes = {}

C_OBJECT:C1216($Obj_result)
C_BOOLEAN:C305($Boo_shift)
$Boo_shift:=Shift down:C543

If (Not:C34($Boo_shift))
	TRY 
End if 

  //_____________________________________________________________

  // Test detailform action


C_OBJECT:C1216($Folder_template;$Obj_tags;$Folder_test;$Obj_template;$Obj_element;$Obj_dom)
C_COLLECTION:C1488($Col_fields)
C_LONGINT:C283($Lon_duplicateExpected;$Lon_relationCount;$Lon_fieldCount;$Lon_relationMinPosition)
$Col_fields:=New collection:C1472(\
New object:C1471("name";"field 1";"id";1);\
New object:C1471("name";"field 2";"id";2);\
New object:C1471("name";"field 3";"id";3);\
New object:C1471("name";"field 4";"id";4);\
New object:C1471("name";"field 5";"id";5);\
New object:C1471("name";"field 6";"id";6);\
New object:C1471("name";"field 7";"id";7);\
New object:C1471("name";"relation 1";"relatedEntities";"TableRelated1");\
New object:C1471("name";"field 5";"id";5);\
New object:C1471("name";"relation 2";"relatedEntities";"TableRelated2");\
New object:C1471("name";"relation 1";"relatedEntities";"TableRelated1");\
New object:C1471("name";"field 3";"id";3))
$Lon_relationCount:=3
$Lon_fieldCount:=$Col_fields.length-$Lon_relationCount
$Lon_relationMinPosition:=8  // /!\ relation could be only after detail headers, so here after 8 for the moment (the test will failed if you put relation in header)
$Obj_tags:=New object:C1471("table";New object:C1471("name";"tablename";"fields";$Col_fields;"detailFields";$Col_fields))
$Folder_test:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).folder("testdetailform")
$Folder_test.create()

C_COLLECTION:C1488($Col_templates)
$Col_templates:=Folder:C1567(fk resources folder:K87:11).folder("templates").folder("form").folder("detail").folders()
If (Folder:C1567(fk resources folder:K87:11).folder("mobile").folder("form").folder("detail").exists)
	$Col_templates.combine(Folder:C1567(fk resources folder:K87:11).folder("mobile").folder("form").folder("detail").folders())
End if 

For each ($Folder_template;$Col_templates)
	
	$Obj_template:=ob_parseFile ($Folder_template.file("manifest.json")).value
	$Obj_template.source:=$Folder_template.platformPath
	
	For each ($Obj_element;$Obj_template.elements)
		OB REMOVE:C1226($Obj_element;"tags")  // remove tags.mandatories for test purpose, do not want to filter if not defined
	End for each 
	
	$Obj_result:=storyboard (New object:C1471("action";"detailform";"template";$Obj_template;"tags";$Obj_tags;"target";$Folder_test.file($Folder_template.name+".storyboard").platformPath))
	
	$Lon_duplicateExpected:=($Obj_template.relation.elements.length*$Lon_relationCount)+($Obj_template.elements.length*($Lon_fieldCount-Num:C11($Obj_template.fields.count)))
	ASSERT:C1129($Lon_relationMinPosition>Num:C11($Obj_template.fields.count);"Change Lon_relationMinPosition and add new fields if template has more field in headers")
	
	ASSERT:C1129(Bool:C1537($Obj_result.success);$Obj_template.name+": "+JSON Stringify:C1217($Obj_result))
	
	ASSERT:C1129($Obj_result.doms#Null:C1517;$Obj_template.name+": Must have inserted doms node for tempalte ")
	
	If ($Obj_result.doms#Null:C1517)
		
		ASSERT:C1129($Obj_result.doms.length=$Lon_duplicateExpected;$Obj_template.name+": node inserted length "+String:C10($Obj_result.doms.length)+" not equals to expected "+String:C10($Lon_duplicateExpected))
		
		  //If ($Obj_result.doms.length#$Lon_duplicateExpected) // code for debug purpose 
		  //For each($Obj_dom;$Obj_result.doms)
		  //$Obj_dom:=xml($Obj_dom.elementRef).getName()
		  //End for each
		  //End if
		
		For each ($Obj_dom;$Obj_result.doms)
			ASSERT:C1129(Bool:C1537($Obj_dom.success);$Obj_template.name+": dom node in error "+JSON Stringify:C1217($Obj_dom))
		End for each 
		
	End if 
	
End for each 

If ($Boo_shift)
	SHOW ON DISK:C922($Folder_test.platformPath)
Else 
	$Folder_test.delete(Delete with contents:K24:24)
End if 

  //_____________________________________________________________

If (Not:C34($Boo_shift))
	FINALLY 
End if 