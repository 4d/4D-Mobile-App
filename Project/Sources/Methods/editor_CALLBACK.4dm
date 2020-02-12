//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_CALLBACK
  // ID[5690C64849C740CF84EA709314ABDED7]
  // Created 11-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Manage all callbacks to the editor window.
  // Some reminders can be addressed to a specific panel. In this case & if the panel is
  // displayed on the current screen, the message is sent to it
  // otherwise nothing more is do.
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($tSelector)
C_OBJECT:C1216($form;$oIN)

If (False:C215)
	C_TEXT:C284(editor_CALLBACK ;$1)
	C_OBJECT:C1216(editor_CALLBACK ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$tSelector:=$1
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		$oIN:=$2
		
	End if 
	
	If (feature.with("newViewUI"))
		
		$form:=New object:C1471(\
			"window";Current form window:C827;\
			"callback";Current method name:C684;\
			"currentForm";Current form name:C1298;\
			"editor";"EDITOR";\
			"project";"PROJECT";\
			"developer";"DEVELOPER";\
			"structure";"STRUCTURE";\
			"tableProperties";"TABLES";\
			"fieldProperties";"FIELDS";\
			"mainMenu";"MAIN";\
			"views";"VIEWS";\
			"server";"SERVER";\
			"data";"DATA";\
			"dataSource";"SOURCE";\
			"actions";"ACTIONS";\
			"actionParameters";"ACTIONS_PARAMS";\
			"ribbon";"ribbon")
		
	Else 
		
		$form:=New object:C1471(\
			"window";Current form window:C827;\
			"callback";Current method name:C684;\
			"currentForm";Current form name:C1298;\
			"editor";"EDITOR";\
			"project";"PROJECT";\
			"developer";"DEVELOPER";\
			"structure";"STRUCTURE";\
			"tableProperties";"TABLES";\
			"fieldProperties";"FIELDS";\
			"mainMenu";"MAIN";\
			"views";"_o_VIEWS";\
			"server";"SERVER";\
			"data";"DATA";\
			"dataSource";"SOURCE";\
			"actions";"ACTIONS";\
			"actionParameters";"ACTIONS_PARAMS";\
			"ribbon";"ribbon")
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($form.currentForm=$form.editor)
	
	editor_MESSAGES ($tSelector;$form;$oIN)
	
Else 
	
	project_MESSAGES ($tSelector;$form;$oIN)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End