//%attributes = {"invisible":true}
/*
***editor_CALLBACK*** ( selector ; in )
 -> selector (Text)
 -> in (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : editor_CALLBACK
  // Database: 4D Mobile Express
  // ID[5690C64849C740CF84EA709314ABDED7]
  // Created #11-8-2017 by Vincent de Lachaux
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

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_selector)
C_OBJECT:C1216($Obj_form;$Obj_in)

If (False:C215)
	C_TEXT:C284(editor_CALLBACK ;$1)
	C_OBJECT:C1216(editor_CALLBACK ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_selector:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
	$Obj_form:=New object:C1471(\
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
	
	ABORT:C156
	
End if 


  // ----------------------------------------------------
If ($Obj_form.currentForm=$Obj_form.editor)
	
	editor_MESSAGES ($Txt_selector;$Obj_form;$Obj_in)
	
Else 
	
	project_MESSAGES ($Txt_selector;$Obj_form;$Obj_in)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End