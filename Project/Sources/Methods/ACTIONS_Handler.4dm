//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_Handler
// ID[3FB32AB369A0439BB4469E866D8C3C10]
// Created 11-03-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($b)
C_LONGINT:C283($eventCode; $l)
C_PICTURE:C286($p)
C_OBJECT:C1216($context; $form; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_Handler; $0)
	C_OBJECT:C1216(ACTIONS_Handler; $1)
End if 

// ----------------------------------------------------
// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$form:=New object:C1471(\
""; editor_Panel_init; \
"form"; UI.form("editor_CALLBACK").get(); \
"add"; UI.button("actions.add"); \
"remove"; UI.button("actions.remove"); \
"databaseMethod"; UI.button("actionMethod"); \
"actions"; UI.listbox("actions"); \
"noPublishedTable"; UI.widget("noPublishedTable"); \
"iconGrid"; UI.widget("iconGrid"); \
"dropCursor"; UI.static("dropCursor"); \
"name"; "names"; \
"icon"; "icons"; \
"shortLabel"; "shorts"; \
"label"; "labels"; \
"table"; "tables"; \
"scope"; "scopes"\
)

$context:=$form[""]

If (OB Is empty:C1297($context))\
 | (Shift down:C543 & (Structure file:C489=Structure file:C489(*)))  // First load
	
	// Constraints definition
	ob_createPath($context; "constraints.rules"; Is collection:K8:32)
	
	// Define form member methods
	$context.load:=Formula:C1597(ACTIONS_UI("load"))
	$context.listUI:=Formula:C1597(ACTIONS_UI("listUI"))
	$context.tableName:=Formula:C1597(ACTIONS_UI("tableName"; $1).value)
	$context.scopeLabel:=Formula:C1597(ACTIONS_UI("scopeLabel"; $1).value)
	$context.backgroundColor:=Formula:C1597(ACTIONS_UI("backgroundColor"; $1).color)
	$context.metaInfo:=Formula:C1597(ACTIONS_UI("metaInfo"; $1))
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$eventCode:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($eventCode=On Load:K2:1)
				
				// This trick remove the horizontal gap
				$form.actions.setScrollbar(0; 2)
				
				// Load project actions
				$context.load()
				
				// Set the initial display
				If (_and(\
					Formula:C1597(Form:C1466.dataModel#Null:C1517); \
					Formula:C1597(Not:C34(OB Is empty:C1297(Form:C1466.dataModel)))))
					
					$form.actions.show()
					$form.noPublishedTable.hide()
					
					$form.add.enable()
					$form.databaseMethod.enable()
					
					If (_and(\
						Formula:C1597(Form:C1466.actions#Null:C1517); \
						Formula:C1597(Form:C1466.actions.length>0)))
						
						// Select last used action or the first one
						If ($context.$current#Null:C1517)
							
							$l:=Form:C1466.actions.indexOf($context.$current)
							
						End if 
						
						$form.actions.select($l+1)
						$form.form.call("selectParameters")
						
					End if 
					
					$form.actions.focus()
					
				Else 
					
					$form.actions.hide()
					$form.noPublishedTable.show()
					
					$form.add.disable()
					$form.databaseMethod.disable()
					
				End if 
				
				// Set colors
				$form.dropCursor.setColors(Highlight menu background color:K23:7)
				
				// Preload the icons
				$form.form.call("actionIcons")
				
				// Give the focus to the actions listbox
				$form.actions.focus()
				
				androidLimitations(True:C214; "Actions are coming soon for Android")
				
				//______________________________________________________
			: ($eventCode=On Timer:K2:25)  // Refresh UI
				
				// Update parameters panel if any
				If (Form:C1466.$dialog.ACTIONS_PARAMS#Null:C1517)
					
					Form:C1466.$dialog.ACTIONS_PARAMS.action:=$context.current
					$form.form.call("refreshParameters")
					
				End if 
				
				$form.remove.setEnabled(_and(\
					Formula:C1597($context.index#Null:C1517); \
					Formula:C1597($context.index#0)))
				
				ARRAY TEXT:C222($tTxt_; 0x0000)
				METHOD GET PATHS:C1163(Path database method:K72:2; $tTxt_; *)
				$b:=(Find in array:C230($tTxt_; METHOD Get path:C1164(Path database method:K72:2; "onMobileAppAction"))>0)
				$form.databaseMethod.setTitle(Choose:C955($b; "edit..."; "create..."))
				$form.databaseMethod.setEnabled($b | _and(Formula:C1597(Form:C1466.actions#Null:C1517); Formula:C1597(Form:C1466.actions.length>0)))
				ui_ALIGN_ON_BEST_SIZE(Align right:K42:4; $form.databaseMethod.name; "actionMethod.label")
				
				androidLimitations(True:C214)
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$form
		
		//=========================================================
	: ($Obj_in.action="actionIcons")  // Call back from widget
		
		$context.current.icon:=$Obj_in.pathnames[$Obj_in.item-1]
		
		$p:=$Obj_in.pictures[$Obj_in.item-1]
		CREATE THUMBNAIL:C679($p; $p; 24; 24; Scaled to fit:K6:2)
		$context.current.$icon:=$p
		
		GOTO OBJECT:C206(*; "")  // Force redraw of the collection !
		
		$form.form.refresh()
		
		PROJECT.save()
		
		//=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		($form.iconGrid.pointer())->:=editor_LoadIcons(ob_setProperties($Obj_in; New object:C1471(\
			"target"; "actionIcons")))
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
//%W-518.7
Case of 
		
		//________________________________________
	: (Undefined:C82($Obj_out))
		
		//________________________________________
	: ($Obj_out=Null:C1517)
		
		//________________________________________
	: (Value type:C1509(($Obj_out=Null:C1517))=Is undefined:K8:13)
		
		//________________________________________
	Else 
		
		$0:=$Obj_out
		
		//________________________________________
End case 
//%W+518.7

// ----------------------------------------------------
// End