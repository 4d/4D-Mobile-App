//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : PROJECT_HANDLER
  // Database: 4D Mobile Express
  // ID[AF22D4902A9B46CDA9555BD5A14C9AF7]
  // Created 1-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters)
C_TEXT:C284($Txt_additional;$Txt_panel;$Txt_title)
C_OBJECT:C1216($Obj_cancel;$Obj_form;$Obj_in;$Obj_ok;$Obj_update)
C_COLLECTION:C1488($Col_buffer;$Col_panels)

If (False:C215)
	C_OBJECT:C1216(PROJECT_HANDLER ;$0)
	C_OBJECT:C1216(PROJECT_HANDLER ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window";Current form window:C827)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=Form event code:C388
		
		  // ----------------------------------------------------
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				$Col_panels:=New collection:C1472
				
				$Col_panels.push(New object:C1471(\
					"title";Get localized string:C991("organization");\
					"form";"ORGANIZATION"))
				
				$Col_panels.push(New object:C1471(\
					"title";Get localized string:C991("product");\
					"form";"PRODUCT"))
				
				$Col_panels.push(New object:C1471(\
					"title";Get localized string:C991("developer");\
					"form";"DEVELOPER"))
				
				project_UI_DEFINITION ($Col_panels)
				
				SET TIMER:C645(-1)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Unload:K2:2)
				
				  //
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				For each ($Txt_panel;panel_Objects )
					
					EXECUTE METHOD IN SUBFORM:C1085($Txt_panel;"panel_UI";*;(OBJECT Get pointer:C1124(Object named:K67:5;"UI"))->)
					
				End for each 
				
				panel_GOTO 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Bound Variable Change:K2:52)
				
				Form:C1466.$worker:=Form:C1466.$project.$worker
				
				  // Update panels
				panel_TOUCH 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="projectAudit")  // Audit the project
		
		  // ----------------------------------------------------
		If (Num:C11($Obj_form.window)#0)
			
			  // Send result
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"projectAuditResult";project_Audit ($Obj_in))
			
		Else 
			
			  // Test purpose - Return result
			$0:=project_Audit ($Obj_in)
			
		End if 
		
		  // ----------------------------------------------------
		  // End
		
		  //=========================================================
	: ($Obj_in.action="projectAuditResult")  // Result of the project audit
		
		  // ================================== //
		  // Execution space is the form EDITOR //
		  // ================================== //
		
		  // Store the status
		If (Form:C1466.status=Null:C1517)
			
			Form:C1466.status:=New object:C1471
			
		End if 
		
		Form:C1466.status.project:=$Obj_in.audit.success
		Form:C1466.audit:=$Obj_in.audit
		
		  // Update UI
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"tableProperties")
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"fieldProperties")
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"refreshViews")
		CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"update_data")
		
		If ($Obj_in.audit.success)
			
			  // Update status
			If (Form:C1466.$dialog.projectInvalid#Null:C1517)
				
				OB REMOVE:C1226(Form:C1466.$dialog;"projectInvalid")
				
			End if 
			
		Else 
			
			  // Display alert only one time
			If (Not:C34(Bool:C1537(Form:C1466.$dialog.projectInvalid)))
				
				Form:C1466.$dialog.projectInvalid:=True:C214
				
				$Obj_ok:=New object:C1471(\
					"action";"projectFixErrors";\
					"audit";$Obj_in.audit)
				
				  // Try to show message according to errors
				If ($Obj_in.audit.errors.length=1)
					
					$Txt_title:=$Obj_in.audit.errors[0].message
					
					Case of 
							
							  //________________________________________
						: ($Obj_in.audit.errors[0].type="template")
							
							$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
							
							$Obj_cancel:=New object:C1471(\
								"action";"page_views";\
								"tab";$Obj_in.audit.errors[0].tab;\
								"table";$Obj_in.audit.errors[0].table)
							
							  //________________________________________
						: ($Obj_in.audit.errors[0].type="icon")
							
							$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
							
							$Obj_cancel:=New object:C1471(\
								"action";"page_properties";\
								"panel";$Obj_in.audit.errors[0].panel;\
								"table";$Obj_in.audit.errors[0].table;\
								"field";Num:C11($Obj_in.audit.errors[0].field))
							
							  //________________________________________
						: ($Obj_in.audit.errors[0].type="formatter")
							
							$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
							
							$Obj_cancel:=New object:C1471(\
								"action";"page_properties";\
								"panel";$Obj_in.audit.errors[0].panel;\
								"table";$Obj_in.audit.errors[0].table;\
								"field";Num:C11($Obj_in.audit.errors[0].field))
							
							  //________________________________________
						: ($Obj_in.audit.errors[0].type="filter")
							
							$Txt_additional:="wouldYouLikeToRemoveTheFilterToFixYourProject"
							
							$Obj_cancel:=New object:C1471(\
								"action";"page_data";\
								"panel";$Obj_in.audit.errors[0].panel;\
								"table";$Obj_in.audit.errors[0].table)
							
							  //________________________________________
						Else 
							
							ASSERT:C1129(dev_Matrix ;"Unknown project audit error type "+$Obj_in.audit.errors[0].type)
							
							  //________________________________________
					End case 
					
				Else 
					
					$Col_buffer:=$Obj_in.audit.errors.extract("type").distinct()
					
					If ($Col_buffer.length=1)
						
						Case of 
								
								  //________________________________________
							: ($Col_buffer[0]="template")
								
								$Txt_title:="someTemplatesAreMissingOrInvalid"
								$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultTemplates"
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_views";\
									"tab";$Obj_in.audit.errors[0].tab;\
									"table";$Obj_in.audit.errors[0].table)
								
								  //________________________________________
							: ($Col_buffer[0]="icon")
								
								$Txt_title:="someIconsAreMissingOrInvalid"
								$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultIcons"
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_properties";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table;\
									"field";Num:C11($Obj_in.audit.errors[0].field))
								
								  //________________________________________
							: ($Col_buffer[0]="formatter")
								
								$Txt_title:="someFormattersAreMissingOrInvalid"
								$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultFormatter"
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_properties";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table;\
									"field";Num:C11($Obj_in.audit.errors[0].field))
								
								  //________________________________________
							: ($Obj_in.audit.errors[0].type="filter")
								
								$Txt_title:="someFiltersAreNotValidatedOrInvalid"
								$Txt_additional:="wouldYouLikeToRemoveTheInvalidOrNotValidatedFilters"
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_data";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table)
								
								  //________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix ;"Unknown project audit error type "+$Col_buffer[0].type)
								
								  //________________________________________
						End case 
						
					Else 
						
						$Txt_title:="someResourcesAreMissingOrInvalid"
						$Txt_additional:="doYouWantToFixYourProjectByUsingTheDefaultResources"
						
						  // Load the firts one
						Case of 
								
								  //________________________________________
							: ($Obj_in.audit.errors[0].type="template")
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_views";\
									"tab";$Obj_in.audit.errors[0].tab;\
									"table";$Obj_in.audit.errors[0].table)
								
								  //________________________________________
							: ($Obj_in.audit.errors[0].type="icon")
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_properties";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table;\
									"field";Num:C11($Obj_in.audit.errors[0].field))
								
								  //________________________________________
							: ($Col_buffer[0]="formatter")
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_properties";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table;\
									"field";Num:C11($Obj_in.audit.errors[0].field))
								
								  //________________________________________
							: ($Col_buffer[0]="filter")
								
								$Obj_cancel:=New object:C1471(\
									"action";"page_data";\
									"panel";$Obj_in.audit.errors[0].panel;\
									"table";$Obj_in.audit.errors[0].table)
								
								  //________________________________________
							Else 
								
								ASSERT:C1129(dev_Matrix ;"Unknown project audit error type "+$Obj_in.audit.errors[0].type)
								
								  //________________________________________
						End case 
					End if 
				End if 
				
				  // user dialog
				POST_FORM_MESSAGE (New object:C1471("target";$Obj_form.window;\
					"action";"show";\
					"type";"confirm";\
					"title";$Txt_title;\
					"additional";$Txt_additional;\
					"ok";"update";\
					"cancel";"reviewing";\
					"cancelAction";JSON Stringify:C1217($Obj_cancel);\
					"okAction";JSON Stringify:C1217($Obj_ok)))
				
			End if 
		End if 
		
		  //=========================================================
	: ($Obj_in.action="projectFixErrors")
		
		If (Form:C1466.$dialog.projectInvalid#Null:C1517)
			
			  // reset project invalid after user make it decision, do not wait a potiential audit #100588
			  // XXX if could be done only one time in code, when dialog dismissing it will better (a dismissAction or completeAction)
			OB REMOVE:C1226(Form:C1466.$dialog;"projectInvalid")
			
		End if 
		
		$Obj_update:=project_Fix ($Obj_in)
		
		If (Num:C11($Obj_form.window)>0)
			
			  // Store the status
			If (Form:C1466.status=Null:C1517)
				
				Form:C1466.status:=New object:C1471(\
					"project";$Obj_update.success)
				
			Else 
				
				Form:C1466.status.project:=$Obj_update.success
				
			End if 
			
			  // Update UI [
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"tableProperties")
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"fieldProperties")
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"refreshViews")
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"update_data")
			  //]
			
			  // Relaunch audit
			CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"projectAudit")
			
			  // Save project
			ui.saveProject()
			
		Else 
			
			  // Test purpose - Return result
			$0:=$Obj_update
			
		End if 
		  //=========================================================
		
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End