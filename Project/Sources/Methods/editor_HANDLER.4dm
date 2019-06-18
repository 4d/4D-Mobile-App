//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_HANDLER
  // Database: 4D Mobile Express
  // ID[A10EF3BB0680451287316759D2D9A5B9]
  // Created #17-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_bottom;$Lon_formEvent;$Lon_height;$Lon_left;$Lon_middle;$Lon_parameters)
C_LONGINT:C283($Lon_right;$Lon_top;$Lon_width)
C_TEXT:C284($Txt_worker)
C_OBJECT:C1216($o;$Obj_form;$Obj_in;$Obj_project)

If (False:C215)
	C_OBJECT:C1216(editor_HANDLER ;$1)
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
		"window";Current form window:C827;\
		"form";editor_INIT ;\
		"ribbon";"ribbon";\
		"description";"description";\
		"project";"project";\
		"message";"message";\
		"greeting";"welcome")
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=Form event:C388
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				OBJECT SET VISIBLE:C603(*;"debug.@";Bool:C1537(Storage:C1525.database.isMatrix))
				
				$o:=ui.tips
				$o.enable()
				$o.defaultDelay()
				$o.defaultDuration()
				
				  // Set current page, ribbon and description [
				Form:C1466.currentPage:="general"
				
				$Obj_form.form.ribbon:=New object:C1471(\
					"state";"open";\
					"tab";"section";\
					"page";Form:C1466.currentPage)
				
				(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.description))->:=Form:C1466.currentPage
				(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.ribbon))->:=Form:C1466.$dialog.EDITOR.ribbon
				  //]
				
				If (Form:C1466.root=Null:C1517)
					
					  // Keep the project directory
					Form:C1466.root:=Path to object:C1547(Form:C1466.project).parentFolder
					
				End if 
				
				  // Load the project
				$Obj_project:=project_Load (Form:C1466.project)
				
				  //=====================================
				  //  #TEMPO a lot value are by table
				  // ===================================== [
				If ($Obj_project.ui=Null:C1517)
					
					$Obj_project.ui:=New object:C1471(\
						"navigationTransition";"PresentSlideSegue")
					
				End if 
				
				  // ===================================== ]
				
				$Obj_project.$project:=Form:C1466
				
				  // Retrieve the project name
				$Obj_project.$project.product:=Path to object:C1547(Form:C1466.root).name
				
				  // Set the dialog title
				SET WINDOW TITLE:C213(Get localized string:C991("4dProductName")+": "+$Obj_project.$project.product;$Obj_form.window)
				
				  // Touch the project subform
				(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.project))->:=$Obj_project
				
				  // Display the greeting message if any [
				If (Bool:C1537(editor_Preferences .doNotShowGreetingMessage))
					
					editor_HANDLER (New object:C1471(\
						"action";"open"))
					
				Else 
					
					FORM GOTO PAGE:C247(2)
					
				End if 
				  //]
				
				SET TIMER:C645(-1)
				
				  //______________________________________________________
			: ($Lon_formEvent=On Close Box:K2:21)
				
				ACCEPT:C269
				
				  //______________________________________________________
			: ($Lon_formEvent=On Data Change:K2:15)
				
				  // Autosave
				project_SAVE 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Activate:K2:9)
				
				EXECUTE METHOD IN SUBFORM:C1085("project";"EDITOR_ON_ACTIVATE")
				
				  //______________________________________________________
			: ($Lon_formEvent=On Unload:K2:2)
				
				CALL WORKER:C1389("4D Mobile ("+String:C10($Obj_form.window)+")";"killWorker")
				
				  //______________________________________________________
			: ($Lon_formEvent=On Resize:K2:27)
				
				If (OBJECT Get visible:C1075(*;"picker"))
					
					CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"pickerHide")
					
				End if 
				
				EXECUTE METHOD IN SUBFORM:C1085($Obj_form.project;"editor_CALLBACK";*;"pickerHide";New object:C1471(\
					"action";"forms";\
					"onResize";True:C214))
				
				EXECUTE METHOD IN SUBFORM:C1085($Obj_form.project;"call_MESSAGE_DISPATCH";*;New object:C1471(\
					"target";"panel.";\
					"method";"UI_SET_GEOMETRY"))
				
				  // Center message
				OBJECT GET SUBFORM CONTAINER SIZE:C1148($Lon_width;$Lon_height)
				$Lon_middle:=$Lon_width\2
				
				OBJECT GET COORDINATES:C663(*;$Obj_form.message;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				$Lon_width:=$Lon_right-$Lon_left
				$Lon_left:=$Lon_middle-($Lon_width\2)
				$Lon_right:=$Lon_left+$Lon_width
				
				OBJECT SET COORDINATES:C1248(*;$Obj_form.message;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
				
				  // Center the greeting screen
				(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.greeting))->:=1+(OBJECT Get pointer:C1124(Object named:K67:5;$Obj_form.greeting))->
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.project;True:C214)
				
				EXECUTE METHOD IN SUBFORM:C1085($Obj_form.project;"call_MESSAGE_DISPATCH";*;New object:C1471(\
					"target";"panel.";\
					"method";"UI_SET_GEOMETRY"))
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Lon_formEvent)+")")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="open")
		
		OBJECT SET VISIBLE:C603(*;$Obj_form.ribbon;True:C214)
		OBJECT SET VISIBLE:C603(*;$Obj_form.description;True:C214)
		
		  // Launch project verifications
		editor_PROJECT_AUDIT 
		
		$Txt_worker:="4D Mobile ("+String:C10($Obj_form.window)+")"
		
		  // Launch checking the development environment
		CALL WORKER:C1389($Txt_worker;"mobile_Check_installation";New object:C1471(\
			"caller";$Obj_form.window))
		
		  // Launch recovering the list of available simulator devices
		CALL WORKER:C1389($Txt_worker;"simulator";New object:C1471(\
			"action";"devices";\
			"filter";"available";\
			"minimumVersion";commonValues.iosDeploymentTarget;\
			"caller";$Obj_form.window))
		
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