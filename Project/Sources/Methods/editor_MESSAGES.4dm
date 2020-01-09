//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_MESSAGES
  // ID[FBCD164D418F4DC18E4AEE9871391F89]
  // Created 10-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Management of messages addressed to the main form
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_OBJECT:C1216($2)
C_OBJECT:C1216($3)

C_LONGINT:C283($Lon_parameters)
C_POINTER:C301($Ptr_ribbon)
C_TEXT:C284($t;$Txt_selector)
C_OBJECT:C1216($o;$Obj_form;$Obj_in;$Obj_project)

If (False:C215)
	C_TEXT:C284(editor_MESSAGES ;$1)
	C_OBJECT:C1216(editor_MESSAGES ;$2)
	C_OBJECT:C1216(editor_MESSAGES ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1
	$Obj_form:=$2
	$Obj_in:=$3
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=4)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_selector="description")  // Update UI of the TITLE subform
		
		EXECUTE METHOD IN SUBFORM:C1085("description";"editor_description";*;$Obj_in)
		
		  //______________________________________________________
	: ($Txt_selector="showBrowser")
		
		OBJECT SET SUBFORM:C1138(*;"browser";"BROWSER")
		OBJECT SET VISIBLE:C603(*;"browser";True:C214)
		(OBJECT Get pointer:C1124(Object named:K67:5;"browser"))->:=$Obj_in
		
		  //______________________________________________________
	: ($Txt_selector="projectAuditResult")
		
		PROJECT_HANDLER (New object:C1471(\
			"action";$Txt_selector;\
			"audit";$Obj_in))
		
		  //______________________________________________________
	: ($Txt_selector="structureCheckingResult")  // Callback from 'structure'
		
		If ($Obj_in.success)
			
			STRUCTURE_CALLBACK ($Obj_in.value)
			
		Else 
			
			ASSERT:C1129(False:C215)
			
			  // Display an error message ?
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="simulator")
		
		If ($Obj_in.success)
			
			Form:C1466.$dialog[$Obj_form.editor].ribbon.devices:=$Obj_in.devices
			
			  // Touch the ribbon subform
			(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.ribbon))->:=Form:C1466.$dialog[$Obj_form.editor].ribbon
			
		Else 
			
			  // DO_MESSAGE (New object(\
								"action";"show";\
								"type";"alert";\
								"title";"noDevices";\
								"additional";""))
			
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="syncDataModel")
		
		structure_REPAIR 
		
		  //______________________________________________________
	: ($Txt_selector="goToPage")
		
		editor_PAGE ($Obj_in.page)
		
		Form:C1466.$dialog[$Obj_form.editor].ribbon.page:=Form:C1466.currentPage
		
		  // Touch the ribbon subform
		(OBJECT Get pointer:C1124(Object named:K67:5;"ribbon"))->:=Form:C1466.$dialog[$Obj_form.editor].ribbon
		
		Case of 
				
				  //………………………………………………………………………………
			: ($Obj_in.panel#Null:C1517)
				
				CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"goTo";$Obj_in)
				
				  //………………………………………………………………………………
			: ($Obj_in.tab#Null:C1517)
				
				CALL FORM:C1391($Obj_form.window;$Obj_form.callback;"selectTab";$Obj_in)
				
				  //………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Txt_selector="checkInstall")
		
		  // Store the result
		Form:C1466.xCode:=$Obj_in
		
		If (Form:C1466.status=Null:C1517)
			
			Form:C1466.status:=New object:C1471(\
				"xCode";$Obj_in.ready)
			
		Else 
			
			Form:C1466.status.xCode:=$Obj_in.ready
			
		End if 
		
		editor_CALLBACK ("updateRibbon")
		
		  //______________________________________________________
	: ($Txt_selector="updateRibbon")
		
		  // Update teamID status
		$Obj_project:=(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.project))->
		Form:C1466.status.teamId:=(Length:C16(String:C10($Obj_project.organization.teamId))>0)
		
		  // Give status to ribbon
		$Ptr_ribbon:=OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.ribbon)
		$Ptr_ribbon->status:=Form:C1466.status
		
		  // Touch
		$Ptr_ribbon->:=$Ptr_ribbon->
		
		  //______________________________________________________
	: ($Txt_selector="build@")
		
		  // build = Result of the build/archive action
		  // build_stop =  Cancel build process
		OB REMOVE:C1226(Form:C1466;"build")
		
		  // Remove the temporary authorizations, if any
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
		
		For each ($t;$o)
			
			If ($t="$_@")
				
				OB REMOVE:C1226($o;$t)
				
			End if 
		End for each 
		
		If ($Txt_selector="build")
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: (Not:C34($Obj_in.success))
					
					  // Could show the issue
					If (Not:C34(Is compiled mode:C492))
						
						  // ALERT(JSON Stringify($Obj_callback;*))  // Need to test
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				: (Bool:C1537($Obj_in.param.archive))
					
					If (Bool:C1537($Obj_in.param.manualInstallation))
						
						DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
							str ("theApplicationHasBeenSuccessfullyGenerated").localized($Obj_in.param.project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
							str ("theApplicationHasBeenSuccessfullyInstalled").localized($Obj_in.param.project.product.name))
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				Else 
					
					DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
						str ("theApplicationHasBeenSuccessfullyGenerated").localized($Obj_in.param.project.product.name))
					
					If (Bool:C1537($Obj_in.param.create)\
						 & Not:C34(Bool:C1537($Obj_in.param.archive))\
						 & Not:C34(Bool:C1537($Obj_in.param.build))\
						 & Not:C34(Bool:C1537($Obj_in.param.run)))
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";Choose:C955((Num:C11(Form:C1466.window)>0);Form:C1466.window;$Obj_form.window);\
							"action";"show";\
							"type";"confirm";\
							"title";"projectCreationSuccessful";\
							"additional";"wouldYouLikeToRevealInFinder";\
							"okFormula";Formula:C1597(SHOW ON DISK:C922(String:C10($Obj_in.param.path)))))
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($Txt_selector="ignoreServerStructureAdjustement")
		
		  // Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
		
		  // Set the temporary authorization
		$o.$_ignoreServerStructureAdjustement:=True:C214
		
		  // Relaunch the build process
		BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$o;\
			"create";True:C214;\
			"build";True:C214;\
			"run";True:C214;\
			"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	: ($Txt_selector="allowStructureModification")
		
		  // Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
		
		  // Set the temporary authorization
		$o.$_allowStructureAdjustments:=True:C214
		
		If (Bool:C1537($Obj_in.value))  // Remember my choice
			
			  // Set the option & save
			$o.allowStructureAdjustments:=Bool:C1537($Obj_in.value)
			project_SAVE (OB Copy:C1225($o))
			
		End if 
		
		  // Relaunch the build process
		BUILD (New object:C1471(\
			"caller";Current form window:C827;\
			"project";$o;\
			"create";True:C214;\
			"build";True:C214;\
			"run";True:C214;\
			"verbose";Bool:C1537(Form:C1466.verbose)))
		
		  //______________________________________________________
	Else 
		
		  // Pass to PROJECT subform
		EXECUTE METHOD IN SUBFORM:C1085($Obj_form.project;$Obj_form.callback;*;$Txt_selector;$Obj_in)
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End