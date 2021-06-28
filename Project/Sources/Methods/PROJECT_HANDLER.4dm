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

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($IN=Null:C1517)  // Form method
		
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
				
				//BEEP
				//ARRAY TEXT($order; 0x0000)
				//FORM GET ENTRY ORDER($order; 1)
				//GOTO OBJECT($order{1})
				
				//______________________________________________________
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				For each ($panel; panels)
					
					EXECUTE METHOD IN SUBFORM:C1085($panel; "panel_UI"; *; (OBJECT Get pointer:C1124(Object named:K67:5; "UI"))->)
					
				End for each 
				
				panel_GOTO
				
				//______________________________________________________
			: ($e.code=On Bound Variable Change:K2:52)
				
				If (Not:C34(FEATURE.with("wizards")))
					
					Form:C1466.$worker:=Form:C1466.$project.$worker
					
				End if 
				
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
	: ($IN.action="projectAudit")  // Audit the project
		
		// ----------------------------------------------------
		If (Num:C11(EDITOR.window)#0)
			
			// Send result
			EDITOR.callMeBack("projectAuditResult"; PROJECT.audit())
			
		Else 
			
			// Test purpose - Return result
			$0:=PROJECT.audit($IN)
			
		End if 
		
		// ----------------------------------------------------
		// End
		
		//=========================================================
	: ($IN.action="projectAuditResult")  // Result of the project audit
		
		// ================================== //
		// Execution space is the form EDITOR //
		// ================================== //
		
		// Store the status
		If (Form:C1466.status=Null:C1517)
			
			Form:C1466.status:=New object:C1471
			
		End if 
		
		Form:C1466.status.project:=Bool:C1537(EDITOR.projectAudit.success)
		Form:C1466.audit:=EDITOR.projectAudit
		
		// Update UI
		EDITOR.callMeBack("tableProperties")
		EDITOR.callMeBack("fieldProperties")
		EDITOR.callMeBack("refreshViews")
		EDITOR.callMeBack("update_data")
		
		If (Bool:C1537(EDITOR.projectAudit.success))  // Update status
			
			OB REMOVE:C1226(EDITOR; "projectInvalid")
			
		Else   // Display alert only one time
			
			If (Not:C34(Bool:C1537(EDITOR.projectInvalid)))
				
				EDITOR.projectInvalid:=True:C214
				
				$ok:=New object:C1471(\
					"action"; "projectFixErrors"; \
					"audit"; EDITOR.projectAudit)
				
				
				If (EDITOR.projectAudit.errors.length=1)
					
					$title:=EDITOR.projectAudit.errors[0].message
					
					Case of 
							
							//________________________________________
						: (EDITOR.projectAudit.errors[0].type="template")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
							
							$cancel:=New object:C1471(\
								"action"; "page_views"; \
								"tab"; EDITOR.projectAudit.errors[0].tab; \
								"table"; EDITOR.projectAudit.errors[0].table)
							
							//________________________________________
						: (EDITOR.projectAudit.errors[0].type="icon")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
							
							$cancel:=New object:C1471(\
								"action"; "page_properties"; \
								"panel"; EDITOR.projectAudit.errors[0].panel; \
								"table"; EDITOR.projectAudit.errors[0].table; \
								"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
							
							//________________________________________
						: (EDITOR.projectAudit.errors[0].type="formatter")
							
							$additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
							
							$cancel:=New object:C1471(\
								"action"; "page_properties"; \
								"panel"; EDITOR.projectAudit.errors[0].panel; \
								"table"; EDITOR.projectAudit.errors[0].table; \
								"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
							
							//________________________________________
						: (EDITOR.projectAudit.errors[0].type="filter")
							
							$additional:="wouldYouLikeToRemoveTheFilterToFixYourProject"
							
							$cancel:=New object:C1471(\
								"action"; "page_data"; \
								"panel"; EDITOR.projectAudit.errors[0].panel; \
								"table"; EDITOR.projectAudit.errors[0].table)
							
							//________________________________________
						Else 
							
							ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+EDITOR.projectAudit.errors[0].type)
							
							//________________________________________
					End case 
					
				Else 
					
					$c:=EDITOR.projectAudit.errors.extract("type").distinct()
					
					If ($c.length=1)
						
						Case of 
								
								//________________________________________
							: ($c[0]="template")
								
								$title:="someTemplatesAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"tab"; EDITOR.projectAudit.errors[0].tab; \
									"table"; EDITOR.projectAudit.errors[0].table)
								
								//________________________________________
							: ($c[0]="icon")
								
								$title:="someIconsAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table; \
									"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="formatter")
								
								$title:="someFormattersAreMissingOrInvalid"
								$additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table; \
									"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
								
								//________________________________________
							: (EDITOR.projectAudit.errors[0].type="filter")
								
								$title:="someFiltersAreNotValidatedOrInvalid"
								$additional:="wouldYouLikeToRemoveTheInvalidOrNotValidatedFilters"
								
								$cancel:=New object:C1471(\
									"action"; "page_data"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table)
								
								//________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+$c[0].type)
								
								//________________________________________
						End case 
						
					Else 
						
						$title:="someResourcesAreMissingOrInvalid"
						$additional:="doYouWantToFixYourProjectByUsingTheDefaultResources"
						
						// Load the firts one
						Case of 
								
								//________________________________________
							: (EDITOR.projectAudit.errors[0].type="template")
								
								$cancel:=New object:C1471(\
									"action"; "page_views"; \
									"tab"; EDITOR.projectAudit.errors[0].tab; \
									"table"; EDITOR.projectAudit.errors[0].table)
								
								//________________________________________
							: (EDITOR.projectAudit.errors[0].type="icon")
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table; \
									"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="formatter")
								
								$cancel:=New object:C1471(\
									"action"; "page_properties"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table; \
									"field"; Num:C11(EDITOR.projectAudit.errors[0].field))
								
								//________________________________________
							: ($c[0]="filter")
								
								$cancel:=New object:C1471(\
									"action"; "page_data"; \
									"panel"; EDITOR.projectAudit.errors[0].panel; \
									"table"; EDITOR.projectAudit.errors[0].table)
								
								//________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+EDITOR.projectAudit.errors[0].type)
								
								//________________________________________
						End case 
					End if 
				End if 
				
				// user dialog
				POST_MESSAGE(New object:C1471("target"; $form.window; \
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
		
		If (Form:C1466.$dialog.projectInvalid#Null:C1517)
			
			// reset project invalid after user make it decision, do not wait a potiential audit #100588
			// XXX if could be done only one time in code, when dialog dismissing it will better (a dismissAction or completeAction)
			OB REMOVE:C1226(Form:C1466.$dialog; "projectInvalid")
			
		End if 
		
		$update:=project_Fix($IN)
		
		If (Num:C11($form.window)>0)
			
			// Store the status
			If (Form:C1466.status=Null:C1517)
				
				Form:C1466.status:=New object:C1471(\
					"project"; $update.success)
				
			Else 
				
				Form:C1466.status.project:=$update.success
				
			End if 
			
			// Update UI
			EDITOR.callMeBack("tableProperties")
			EDITOR.callMeBack("fieldProperties")
			EDITOR.callMeBack("refreshViews")
			EDITOR.callMeBack("update_data")
			
			// Relaunch audit
			EDITOR.callMeBack("projectAudit")
			
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