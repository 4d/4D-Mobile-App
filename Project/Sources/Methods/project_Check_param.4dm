//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : project_Check_param
// ID[79BFA3C24536452A892A486A32EC7437]
// Created 28-8-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($table; $field)
C_OBJECT:C1216($o; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(project_Check_param; $0)
	C_OBJECT:C1216(project_Check_param; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
	$o:=$Obj_in.project
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
// CHECK IF THE PROJECT COULD BE CREATE
Case of 
		
		//______________________________________________________
	: ((Length:C16(String:C10($o.product.name))=0))  // Empty App name
		
		$o:=New object:C1471(\
			"page"; "general"; \
			"panel"; "PRODUCT"; \
			"object"; "10_name")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; UI.alert+" "+Get localized string:C991("theProductNameIsMandatory"); \
			"additional"; "pleaseGiveNameToYourProduct"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	: (OB Get:C1224($o; "dataModel"; Is object:K8:27)=Null:C1517)\
		 | OB Is empty:C1297(OB Get:C1224($o; "dataModel"; Is object:K8:27))  // No published structure
		
		$o:=New object:C1471(\
			"page"; "structure")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; UI.alert+" "+Get localized string:C991("noPublishedTable"); \
			"additional"; "youMustPublishAtLeastOneFieldToBeAbleToBuildYourApplication"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	: ($o.main.order=Null:C1517)\
		 | ($o.main.order.length=0)  // No table in the main menu
		
		$o:=New object:C1471(\
			"page"; "main")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; UI.alert+" "+Get localized string:C991("noTableDefinedInTheMainMenu"); \
			"additional"; "youMustSetAtLeastOneTableIntoTheMainMenu"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	Else 
		
		$Obj_out.success:=True:C214  // no error
		
		//______________________________________________________
End case 

/*
redmine:#117188
[BUG] error generating a mobile project if the project.4dmobileapp file is not in the Mobile Projects folder
*/
If ($Obj_out.success & Bool:C1537($Obj_in.build))
	
	If (Value type:C1509($Obj_in.project.$project.file)=Is object:K8:27)
		
		$Obj_out.success:=(cs:C1710.doc.new($Obj_in.project.$project.file.parent.parent).relativePath="/Mobile Projects/")
		
		If (Not:C34($Obj_out.success))
			
			DO_MESSAGE(New object:C1471(\
				"action"; "show"; \
				"type"; "alert"; \
				"title"; UI.alert+" "+Get localized string:C991("unableToGenerateApp"); \
				"additional"; Get localized string:C991("theprojectmustbelocatedrinthemobileprojectsfolder"); \
				"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "build_stop"))\
				))
			
		End if 
	End if 
End if 

If ($Obj_out.success & Bool:C1537($Obj_in.build))
	
	// CHECK IF THE PROJECT COULD BE BUILD
	$o:=$Obj_in.project.dataModel
	
	For each ($table; $o)
		
		For each ($field; $o[$table])
			
			Case of 
					
					//………………………………………………………………………………………………………
				: (PROJECT.isField($field))
					
					//
					
					//………………………………………………………………………………………………………
				: (Value type:C1509($o[$table][$field])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToOne($o[$table][$field]))  // N -> 1 relation
					
					//
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToMany($o[$table][$field]))  // 1 -> N relation
					
					If (Value type:C1509($o[String:C10($o[$table][$field].relatedTableNumber)])=Is undefined:K8:13)
						
						$Obj_out.success:=False:C215
						
						// Ensure the errors collection exists
						$Obj_out:=ob_createPath($Obj_out; "errors"; Is collection:K8:32)
						$Obj_out.errors.push(_o_str("theLinkedTableIsNotPublished").localized($o[$table][$field].relatedEntities))
						
					End if 
					//………………………………………………………………………………………………………
			End case 
			
		End for each 
	End for each 
	
	If (Not:C34($Obj_out.success))
		
		$o:=New object:C1471(\
			"page"; "structure")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; UI.alert+" "+Get localized string:C991("theDefinitionOfTheStructureIsInconsistent"); \
			"additional"; "- "+$Obj_out.errors.join("\r- ")+"\r\r\r"+Get localized string:C991("youMustFixItBeforeBuildingTheApplication"); \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
	End if 
	
End if 

If ($Obj_out.success & Bool:C1537($Obj_in.run))
	
	// CHECK IF THE PROJECT COULD BE RUN
	
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End