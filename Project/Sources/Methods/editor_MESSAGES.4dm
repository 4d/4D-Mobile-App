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

C_POINTER:C301($ptr)
C_TEXT:C284($t;$tSelector)
C_OBJECT:C1216($form;$o;$oIN)

If (False:C215)
	C_TEXT:C284(editor_MESSAGES ;$1)
	C_OBJECT:C1216(editor_MESSAGES ;$2)
	C_OBJECT:C1216(editor_MESSAGES ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=3;"Missing parameter"))
	
	  // Required parameters
	$tSelector:=$1
	$form:=$2
	$oIN:=$3
	
	  // Default values
	
	  // Optional parameters
	If (Count parameters:C259>=4)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($tSelector="description")  // Update UI of the TITLE subform
		
		EXECUTE METHOD IN SUBFORM:C1085("description";"editor_description";*;$oIN)
		
		  //______________________________________________________
	: ($tSelector="setURL")
		
		  //record.log("--> setURL")
		(OBJECT Get pointer:C1124(Object named:K67:5;"browser"))->:=$oIN
		
		  //______________________________________________________
	: ($tSelector="hideBrowser")
		
		  //record.log("--> hideBrowser")
		OBJECT SET SUBFORM:C1138(*;"browser";"EMPTY")
		OBJECT SET VISIBLE:C603(*;"browser";False:C215)
		
		  //______________________________________________________
	: ($tSelector="showBrowser")
		
		  //record.log("--> showBrowser")
		OBJECT SET VISIBLE:C603(*;"browser";True:C214)
		
		  //______________________________________________________
	: ($tSelector="initBrowser")
		
		  //record.log("--> initBrowser")
		OBJECT SET VISIBLE:C603(*;"browser";True:C214)
		OBJECT SET SUBFORM:C1138(*;"browser";"BROWSER")
		
		CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"setURL";$oIN)
		
		  //______________________________________________________
	: ($tSelector="projectAuditResult")
		
		PROJECT_Handler (New object:C1471(\
			"action";$tSelector;\
			"audit";$oIN))
		
		  //______________________________________________________
	: ($tSelector="structureCheckingResult")  // Callback from 'structure'
		
		If ($oIN.success)
			
			STRUCTURE_CALLBACK ($oIN.value)
			
		Else 
			
			ASSERT:C1129(False:C215)
			
			  // Display an error message ?
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="simulator")
		
		If ($oIN.success)
			
			Form:C1466.$dialog[$form.editor].ribbon.devices:=$oIN.devices
			
			  // Touch the ribbon subform
			(OBJECT Get pointer:C1124(Object named:K67:5;$form.ribbon))->:=Form:C1466.$dialog[$form.editor].ribbon
			
		Else 
			
			  // DO_MESSAGE (New object(\
												"action";"show";\
												"type";"alert";\
												"title";"noDevices";\
												"additional";""))
			
		End if 
		
		  //______________________________________________________
	: ($tSelector="syncDataModel")
		
		structure_REPAIR 
		
		  //______________________________________________________
	: ($tSelector="goToPage")
		
		editor_PAGE ($oIN.page)
		
		Form:C1466.$dialog[$form.editor].ribbon.page:=Form:C1466.currentPage
		
		  // Touch the ribbon subform
		(OBJECT Get pointer:C1124(Object named:K67:5;"ribbon"))->:=Form:C1466.$dialog[$form.editor].ribbon
		
		Case of 
				
				  //………………………………………………………………………………
			: ($oIN.panel#Null:C1517)
				
				CALL FORM:C1391($form.window;$form.callback;"goTo";$oIN)
				
				  //………………………………………………………………………………
			: ($oIN.tab#Null:C1517)
				
				CALL FORM:C1391($form.window;$form.callback;"selectTab";$oIN)
				
				  //………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($tSelector="checkInstall")
		
		  // Store the result
		Form:C1466.xCode:=$oIN
		
		If (Form:C1466.status=Null:C1517)
			
			Form:C1466.status:=New object:C1471(\
				"xCode";$oIN.ready)
			
		Else 
			
			Form:C1466.status.xCode:=$oIN.ready
			
		End if 
		
		editor_CALLBACK ("updateRibbon")
		
		  //______________________________________________________
	: ($tSelector="updateRibbon")
		
		  // Update teamID status
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5;$form.project))->
		Form:C1466.status.teamId:=(Length:C16(String:C10($o.organization.teamId))>0)
		
		  // Give status to ribbon
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5;$form.ribbon)
		$ptr->status:=Form:C1466.status
		
		  // Touch
		$ptr->:=$ptr->
		
		  //______________________________________________________
	: ($tSelector="build@")
		
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
		
		If ($tSelector="build")
			
			Case of 
					
					  //…………………………………………………………………………………………………………………………
				: (Not:C34($oIN.success))
					
					  // Could show the issue
					If (Not:C34(Is compiled mode:C492))
						
						  // ALERT(JSON Stringify($Obj_callback;*))  // Need to test
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				: (Bool:C1537($oIN.param.archive))
					
					If (Bool:C1537($oIN.param.manualInstallation))
						
						DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
							str ("theApplicationHasBeenSuccessfullyGenerated").localized($oIN.param.project.product.name))
						
					Else 
						
						DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
							str ("theApplicationHasBeenSuccessfullyInstalled").localized($oIN.param.project.product.name))
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
				Else 
					
					DISPLAY NOTIFICATION:C910(Get localized string:C991("4dProductName");\
						str ("theApplicationHasBeenSuccessfullyGenerated").localized($oIN.param.project.product.name))
					
					If (Bool:C1537($oIN.param.create)\
						 & Not:C34(Bool:C1537($oIN.param.archive))\
						 & Not:C34(Bool:C1537($oIN.param.build))\
						 & Not:C34(Bool:C1537($oIN.param.run)))
						
						POST_FORM_MESSAGE (New object:C1471(\
							"target";Choose:C955((Num:C11(Form:C1466.window)>0);Form:C1466.window;$form.window);\
							"action";"show";\
							"type";"confirm";\
							"title";"projectCreationSuccessful";\
							"additional";"wouldYouLikeToRevealInFinder";\
							"okFormula";Formula:C1597(SHOW ON DISK:C922(String:C10($oIN.param.path)))))
						
					End if 
					
					  //…………………………………………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	: ($tSelector="ignoreServerStructureAdjustement")
		
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
	: ($tSelector="allowStructureModification")
		
		  // Get the project
		$o:=(OBJECT Get pointer:C1124(Object named:K67:5;"project"))->
		
		  // Set the temporary authorization
		$o.$_allowStructureAdjustments:=True:C214
		
		If (Bool:C1537($oIN.value))  // Remember my choice
			
			  // Set the option & save
			$o.allowStructureAdjustments:=Bool:C1537($oIN.value)
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
		EXECUTE METHOD IN SUBFORM:C1085($form.project;$form.callback;*;$tSelector;$oIN)
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End