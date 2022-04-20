//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : PROJECT_HANDLER
// ID[AF22D4902A9B46CDA9555BD5A14C9AF7]
// Created 1-9-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(PROJECT_Handler; $0)
	C_OBJECT:C1216(PROJECT_Handler; $1)
End if 

var $additional; $panel; $title : Text
var $cancel; $e; $form; $IN; $ok; $update : Object
var $c : Collection

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$IN:=$1
	
End if 

$form:=New object:C1471(\
"window"; Current form window:C827)

If (Form:C1466#Null:C1517)
	
	If (Form:C1466.$dialog#Null:C1517)
		
		If (Form:C1466.$dialog.PROJECT=Null:C1517)
			
			Form:C1466.$dialog.PROJECT:=cs:C1710.PROJECT_FORM.new()
			
		End if 
		
		var $ƒ : Object
		$ƒ:=Form:C1466.$dialog.PROJECT
		
	End if 
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)
		
		// MARK:-Form method
		
		$e:=FORM Event:C1606
		
		// ----------------------------------------------------
		Case of 
				
				//______________________________________________________
			: ($e.code=On Load:K2:1)
				
				OBJECT SET VISIBLE:C603(*; "background"; False:C215)
				
				SET TIMER:C645(-1)
				
				//______________________________________________________
			: ($e.code=On Unload:K2:2)
				
				//
				
				//______________________________________________________
			: ($e.code=On Getting Focus:K2:7)
				
				ARRAY TEXT:C222($order; 0x0000)
				FORM GET ENTRY ORDER:C1469($order; 1)
				GOTO OBJECT:C206($order{1})
				
				//______________________________________________________
			: ($e.code=On Activate:K2:9)
				
				// BEEP
				//ARRAY TEXT($order; 0x0000)
				//FORM GET ENTRY ORDER($order; 1)
				//GOTO OBJECT($order{1})
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				For each ($panel; panels)
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; Formula:C1597(panel_UI).source; *; (OBJECT Get pointer:C1124(Object named:K67:5; "UI"))->)
					
				End for each 
				
				panel_GOTO
				
				//______________________________________________________
			: ($e.code=On Bound Variable Change:K2:52)
				
				var $height; $width : Integer
				
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
				OBJECT SET COORDINATES:C1248(*; "background"; 0; 0; $width; $height)
				
				// Update panels
				panel_TOUCH
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($IN.action=Null:C1517)
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($IN.action="projectAudit")
		
		// MARK:-Audit the project
		
		If (Num:C11(UI.window)#0)
			
			// Send result
			UI.callMeBack("projectAuditResult"; PROJECT.audit())
			
		Else 
			
			// Test purpose - Return result
			$0:=PROJECT.audit($IN)
			
		End if 
		
		//=========================================================
	: ($IN.action="projectAuditResult")
		
		// MARK:-Result of the project audit
		
		// ================================== //
		// Execution space is the form EDITOR //
		// ================================== //
		
		// Store the status
		If (Form:C1466.status=Null:C1517)
			
			Form:C1466.status:=New object:C1471
			
		End if 
		
		Form:C1466.status.project:=Bool:C1537(UI.projectAudit.success)
		Form:C1466.audit:=UI.projectAudit
		
		// Update UI
		UI.callMeBack("tableProperties")
		UI.callMeBack("fieldProperties")
		UI.callMeBack("refreshViews")
		UI.callMeBack("update_data")
		
		If (Bool:C1537(UI.projectAudit.success))  // Update status
			
			OB REMOVE:C1226(UI; "projectInvalid")
			
		Else   // Display alert only one time
			
			If (Not:C34(Bool:C1537(UI.projectInvalid)))
				
				UI.projectInvalid:=True:C214
				
				$ok:=New object:C1471(\
					"action"; "projectFixErrors"; \
					"audit"; UI.projectAudit)
				
				If (UI.projectAudit.errors.length=1)
					
					$title:=UI.projectAudit.errors[0].message
					
					Case of 
							
							//________________________________________
						: (UI.projectAudit.errors[0].type="template")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
							
							$cancel:=New object:C1471(\
								"action"; "page_views"; \
								"tab"; UI.projectAudit.errors[0].tab; \
								"table"; UI.projectAudit.errors[0].table)
							
							//________________________________________
						: (UI.projectAudit.errors[0].type="field")
							
							$additional:="doYouWantToFixYourProjectByDeletingThisField"
							
							$cancel:=New object:C1471(\
								"action"; "page_views"; \
								"tab"; UI.projectAudit.errors[0].tab; \
								"table"; UI.projectAudit.errors[0].table)
							
							//________________________________________
						: (UI.projectAudit.errors[0].type="icon")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
							
							$cancel:=New object:C1471(\
								"action"; "page_properties"; \
								"panel"; UI.projectAudit.errors[0].panel; \
								"table"; UI.projectAudit.errors[0].table; \
								"field"; Num:C11(UI.projectAudit.errors[0].field))
							
							//________________________________________
						: (UI.projectAudit.errors[0].type="formatter")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
							
							$cancel:=New object:C1471(\
								"action"; "page_properties"; \
								"panel"; UI.projectAudit.errors[0].panel; \
								"table"; UI.projectAudit.errors[0].table; \
								"field"; Num:C11(UI.projectAudit.errors[0].field))
							
							//________________________________________
						: (UI.projectAudit.errors[0].type="filter")
							
							$additional:="wouldYouLikeToRemoveTheFilterToFixYourProject"
							
							$cancel:=New object:C1471(\
								"action"; "page_data"; \
								"panel"; UI.projectAudit.errors[0].panel; \
								"table"; UI.projectAudit.errors[0].table)
							
							//________________________________________
						Else 
							
							ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+UI.projectAudit.errors[0].type)
							
							//________________________________________
					End case 
					
				Else 
					
					$c:=UI.projectAudit.errors.extract("type").distinct()
					
					If ($c.length=1)
						
						Case of 
								
								//________________________________________
							: ($c[0]="template")
								
								$title:="someTemplatesAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"tab"; UI.projectAudit.errors[0].tab; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							: ($c[0]="field")
								
								$title:="someFieldsUsedInFormsAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByDeletingTheseFields"
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							: ($c[0]="icon")
								
								$title:="someIconsAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table; \
									"field"; Num:C11(UI.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="formatter")
								
								$title:="someFormattersAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table; \
									"field"; Num:C11(UI.projectAudit.errors[0].field))
								
								//________________________________________
							: (UI.projectAudit.errors[0].type="filter")
								
								$title:="someFiltersAreNotValidatedOrInvalid"
								$additional:="wouldYouLikeToRemoveTheInvalidOrNotValidatedFilters"
								
								$cancel:=New object:C1471(\
									"action"; "page_data"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+$c[0].type)
								
								//________________________________________
						End case 
						
					Else 
						
						$title:="someResourcesOrFieldsAreMissingOrInvalid"
						$additional:="doYouWantToFixYourProjectByUsingTheDefaultResources"
						
						// Load the firts one
						Case of 
								
								//________________________________________
							: (UI.projectAudit.errors[0].type="template")
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"tab"; UI.projectAudit.errors[0].tab; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							: (UI.projectAudit.errors[0].type="field")
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							: (UI.projectAudit.errors[0].type="icon")
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table; \
									"field"; Num:C11(UI.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="formatter")
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table; \
									"field"; Num:C11(UI.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="filter")
								
								$cancel:=New object:C1471(\
									"action"; "page_data"; \
									"panel"; UI.projectAudit.errors[0].panel; \
									"table"; UI.projectAudit.errors[0].table)
								
								//________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+UI.projectAudit.errors[0].type)
								
								//________________________________________
						End case 
					End if 
				End if 
				
				// User dialog
				UI.postMessage(New object:C1471(\
					"action"; "show"; \
					"type"; "confirm"; \
					"title"; $title; \
					"additional"; $additional; \
					"ok"; "update"; \
					"cancel"; "reviewing"; \
					"cancelAction"; JSON Stringify:C1217($cancel); \
					"okAction"; JSON Stringify:C1217($ok)))
				
			End if 
		End if 
		
		//=========================================================
	: ($IN.action="projectFixErrors")
		
		// MARK:-projectFixErrors
		
		If (Form:C1466.$dialog.projectInvalid#Null:C1517)
			
			// Reset project invalid after user make it decision, do not wait a potiential audit #100588
			// XXX if could be done only one time in code, when dialog dismissing it will better (a dismissAction or completeAction)
			OB REMOVE:C1226(Form:C1466.$dialog; "projectInvalid")
			
		End if 
		
		//$update:=project_Fix($IN)
		$update:=PROJECT.fix($IN)
		
		If (Num:C11($form.window)>0)
			
			// Store the status
			If (Form:C1466.status=Null:C1517)
				
				Form:C1466.status:=New object:C1471(\
					"project"; $update.success)
				
			Else 
				
				Form:C1466.status.project:=$update.success
				
			End if 
			
			// Update UI
			UI.callMeBack("tableProperties")
			UI.callMeBack("fieldProperties")
			UI.callMeBack("refreshViews")
			UI.callMeBack("update_data")
			
			// Relaunch audit
			UI.callMeBack("projectAudit")
			
			// Save project
			PROJECT.save()
			
		Else 
			
			// Test purpose - Return result
			$0:=$update
			
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$IN.action+"\"")
		
		//=========================================================
End case 