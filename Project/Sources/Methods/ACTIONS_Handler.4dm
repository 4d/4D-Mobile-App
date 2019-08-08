//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_Handler
  // Database: 4D Mobile App
  // ID[3FB32AB369A0439BB4469E866D8C3C10]
  // Created 11-03-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($b)
C_LONGINT:C283($l;$Lon_formEvent;$Lon_parameters)
C_PICTURE:C286($p)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_in;$Obj_out;$Path_internal)
C_OBJECT:C1216($Path_user)

If (False:C215)
	C_OBJECT:C1216(ACTIONS_Handler ;$0)
	C_OBJECT:C1216(ACTIONS_Handler ;$1)
End if 

  // ----------------------------------------------------
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"$";editor_INIT ;\
		"form";ui.form("editor_CALLBACK").get();\
		"add";ui.button("actions.add");\
		"remove";ui.button("actions.remove");\
		"databaseMethod";ui.button("actionMethod");\
		"actions";ui.listbox("actions");\
		"noPublishedTable";ui.widget("noPublishedTable");\
		"iconGrid";ui.widget("iconGrid");\
		"dropCursor";ui.static("dropCursor");\
		"name";"names";\
		"icon";"icons";\
		"shortLabel";"shorts";\
		"label";"labels";\
		"table";"tables";\
		"scope";"scopes"\
		)
	
	$Obj_context:=$Obj_form.$
	
	If (OB Is empty:C1297($Obj_context))\
		 | (Shift down:C543 & (Structure file:C489=Structure file:C489(*)))  // First load
		
		  // Constraints definition
		ob_createPath ($Obj_context;"constraints.rules";Is collection:K8:32)
		
		  // Define form member methods
		$Obj_context.load:=Formula:C1597(ACTIONS_Handler (New object:C1471(\
			"action";"load")))
		
		$Obj_context.listUI:=Formula:C1597(ACTIONS_UI ("listUI"))
		
		$Obj_context.tableName:=Formula:C1597(ACTIONS_UI ("tableName";$1).value)
		$Obj_context.scopeLabel:=Formula:C1597(ACTIONS_UI ("scopeLabel";$1).value)
		
		$Obj_context.backgroundColor:=Formula:C1597(ACTIONS_UI ("backgroundColor";$1).color)
		$Obj_context.metaInfo:=Formula:C1597(ACTIONS_UI ("metaInfo";$1))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				$Obj_form.actions.setScrollbar(0;2)
				
				  // Load project actions
				$Obj_context.load()
				
				  // Set the initial display
				If (_and (\
					Formula:C1597(Form:C1466.dataModel#Null:C1517);\
					Formula:C1597(Not:C34(OB Is empty:C1297(Form:C1466.dataModel)))))
					
					$Obj_form.actions.show()
					$Obj_form.noPublishedTable.hide()
					
					$Obj_form.add.enable()
					$Obj_form.databaseMethod.enable()
					
					If (_and (\
						Formula:C1597(Form:C1466.actions#Null:C1517);\
						Formula:C1597(Form:C1466.actions.length>0)))
						
						  // Select last used action or the first one
						If ($Obj_context.$current#Null:C1517)
							
							$l:=Form:C1466.actions.indexOf($Obj_context.$current)
							
						End if 
						
						$Obj_form.actions.select($l+1)
						$Obj_form.form.call("selectParameters")
						
					End if 
					
					$Obj_form.actions.focus()
					
				Else 
					
					$Obj_form.actions.hide()
					$Obj_form.noPublishedTable.show()
					
					$Obj_form.add.disable()
					$Obj_form.databaseMethod.disable()
					
				End if 
				
				  // Set colors
				$Obj_form.dropCursor.setColors(Highlight menu background color:K23:7)
				
				  // Preload the icons
				$Obj_form.form.call("actionIcons")
				
				  // Give the focus to the actions listbox
				$Obj_form.actions.focus()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)  // Refresh UI
				
				  // Update parameters panel if any
				Form:C1466.$dialog.ACTIONS_PARAMS.action:=$Obj_context.current
				$Obj_form.form.call("refreshParameters")
				
				$Obj_form.remove.setEnabled(_and (\
					Formula:C1597($Obj_context.index#Null:C1517);\
					Formula:C1597($Obj_context.index#0)))
				
				ARRAY TEXT:C222($tTxt_;0x0000)
				METHOD GET PATHS:C1163(Path database method:K72:2;$tTxt_;*)
				$b:=(Find in array:C230($tTxt_;METHOD Get path:C1164(Path database method:K72:2;"onMobileAppAction"))>0)
				$Obj_form.databaseMethod.setTitle(Get localized string:C991(Choose:C955($b;"edit...";"create...")))
				$Obj_form.databaseMethod.setEnabled($b | _and (Formula:C1597(Form:C1466.actions#Null:C1517);Formula:C1597(Form:C1466.actions.length>0)))
				ui_ALIGN_ON_BEST_SIZE (Align right:K42:4;$Obj_form.databaseMethod.name;"actionMethod.label")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="load")  // Load project actions
		
		If (Form:C1466.actions#Null:C1517)
			
			$Path_internal:=COMPONENT_Pathname ("actionIcons")
			$Path_user:=COMPONENT_Pathname ("host_actionIcons")
			
			  // Compute icons
			For each ($o;Form:C1466.actions)
				
				$t:=String:C10($o.icon)
				
				Case of 
						
						  //……………………………………………………………………………
					: (Length:C16($t)=0)
						
						READ PICTURE FILE:C678(ui.noIcon;$p)
						
						  //……………………………………………………………………………
					: ($t[[1]]="/")
						
						$t:=Delete string:C232($t;1;1)
						
						If ($Path_user.file($t).exists)
							
							READ PICTURE FILE:C678($Path_user.file($t).platformPath;$p)
							
						Else 
							
							READ PICTURE FILE:C678(ui.errorIcon;$p)
							
						End if 
						
						  //……………………………………………………………………………
					Else 
						
						READ PICTURE FILE:C678($Path_internal.file($t).platformPath;$p)
						
						  //……………………………………………………………………………
				End case 
				
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				$o.$icon:=$p
				
			End for each 
		End if 
		
		  //=========================================================
	: ($Obj_in.action="actionIcons")  // Call back from widget
		
		$Obj_context.current.icon:=$Obj_in.pathnames[$Obj_in.item-1]
		
		$p:=$Obj_in.pictures[$Obj_in.item-1]
		CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
		$Obj_context.current.$icon:=$p
		
		GOTO OBJECT:C206(*;"")  // Force redraw of the collection !
		
		$Obj_form.form.refresh()
		
		project.save()
		
		  //=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		($Obj_form.iconGrid.pointer())->:=editor_LoadIcons (ob_setProperties ($Obj_in;New object:C1471(\
			"target";"actionIcons")))
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
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