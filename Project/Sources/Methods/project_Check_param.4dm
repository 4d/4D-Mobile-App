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
#DECLARE($in : Object)->$result : Object

If (False:C215)
	C_OBJECT:C1216(project_Check_param; $0)
	C_OBJECT:C1216(project_Check_param; $1)
End if 

var $field; $table : Text
var $dataModel; $in; $o; $project; $result : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	
	// Optional parameters
	// <NONE>
	
	$result:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
//      CHECK IF THE PROJECT COULD BE CREATE
// ----------------------------------------------------
$project:=$in.project

Case of 
		
		//______________________________________________________
	: ((Length:C16(String:C10($project.product.name))=0))  // Empty App name
		
		$o:=New object:C1471(\
			"page"; "general"; \
			"panel"; "PRODUCT"; \
			"object"; "10_name")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; EDITOR.alert+" "+Get localized string:C991("theProductNameIsMandatory"); \
			"additional"; "pleaseGiveNameToYourProduct"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	: (OB Get:C1224($project; "dataModel"; Is object:K8:27)=Null:C1517)\
		 | OB Is empty:C1297(OB Get:C1224($project; "dataModel"; Is object:K8:27))  // No published structure
		
		$o:=New object:C1471(\
			"page"; "structure")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; EDITOR.alert+" "+Get localized string:C991("noPublishedTable"); \
			"additional"; "youMustPublishAtLeastOneFieldToBeAbleToBuildYourApplication"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	: ($project.main.order=Null:C1517)\
		 | ($project.main.order.length=0)  // No table in the main menu
		
		$o:=New object:C1471(\
			"page"; "main")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; EDITOR.alert+" "+Get localized string:C991("noTableDefinedInTheMainMenu"); \
			"additional"; "youMustSetAtLeastOneTableIntoTheMainMenu"; \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
		//______________________________________________________
	Else 
		
		$result.success:=True:C214  // No error
		
		//______________________________________________________
End case 

If ($result.success & Bool:C1537($in.build))
	
/*
redmine:#117188
[BUG] error generating a mobile project if the project.4dmobileapp file is not in the Mobile Projects folder
*/
	
	$result.success:=(cs:C1710.doc.new($in.project._folder.parent).relativePath="/Mobile Projects/")
	
	If (Not:C34($result.success))
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; EDITOR.alert+" "+Get localized string:C991("unableToGenerateApp"); \
			"additional"; Get localized string:C991("theprojectmustbelocatedrinthemobileprojectsfolder"); \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "build_stop"))\
			))
		
	End if 
End if 

If ($result.success & Bool:C1537($in.build))
	
	// ----------------------------------------------------
	//       CHECK IF THE PROJECT COULD BE BUILD
	// ----------------------------------------------------
	
	$dataModel:=$in.project.dataModel
	
	For each ($table; $dataModel)
		
		For each ($field; $dataModel[$table])
			
			Case of 
					
					//………………………………………………………………………………………………………
				: (PROJECT.isField($field))
					
					// 
					
					//………………………………………………………………………………………………………
				: (Value type:C1509($dataModel[$table][$field])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToOne($dataModel[$table][$field]))  // N -> 1 relation
					
					// 
					
					//………………………………………………………………………………………………………
				: (PROJECT.isRelationToMany($dataModel[$table][$field]))  // 1 -> N relation
					
					If (Value type:C1509($dataModel[String:C10($dataModel[$table][$field].relatedTableNumber)])=Is undefined:K8:13)
						
						$result.success:=False:C215
						
						// Ensure the errors collection exists
						$result:=ob_createPath($result; "errors"; Is collection:K8:32)
						$result.errors.push(cs:C1710.str.new("theLinkedTableIsNotPublished").localized($dataModel[$table][$field].relatedEntities))
						
					End if 
					
					//………………………………………………………………………………………………………
			End case 
		End for each 
	End for each 
	
	If (Not:C34($result.success))
		
		$o:=New object:C1471(\
			"page"; "structure")
		
		DO_MESSAGE(New object:C1471(\
			"action"; "show"; \
			"type"; "alert"; \
			"title"; EDITOR.alert+" "+Get localized string:C991("theDefinitionOfTheStructureIsInconsistent"); \
			"additional"; "- "+$result.errors.join("\r- ")+"\r\r\r"+Get localized string:C991("youMustFixItBeforeBuildingTheApplication"); \
			"okFormula"; Formula:C1597(CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "goToPage"; $o))))
		
	End if 
End if 

If ($result.success & Bool:C1537($in.run))
	
	// ----------------------------------------------------
	//       CHECK IF THE PROJECT COULD BE RUN
	// ----------------------------------------------------
	
End if 

// ----------------------------------------------------
// End