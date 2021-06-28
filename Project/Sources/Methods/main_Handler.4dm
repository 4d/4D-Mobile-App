//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : main_Handler
// ID[04B71BD2C4E54E2BA14CC82ED37FDCB3]
// Created 31-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i; $l; $Lon_available; $Lon_event; $Lon_published)
C_POINTER:C301($Ptr_IDs; $Ptr_mainIDs; $Ptr_mainNames; $Ptr_names)
C_TEXT:C284($Txt_tableNumber)
C_OBJECT:C1216($o; $Obj_context; $Obj_form; $Obj_in; $Obj_out)

If (False:C215)
	C_OBJECT:C1216(main_Handler; $0)
	C_OBJECT:C1216(main_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

// Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$Obj_form:=New object:C1471(\
"window"; Current form window:C827; \
"ui"; editor_Panel_init; \
"eventCode"; Form event code:C388; \
"currentWidget"; OBJECT Get name:C1087(Object current:K67:2); \
"focusedWidget"; OBJECT Get name:C1087(Object with focus:K67:3); \
"tables"; _o_UI.listbox("01_available"); \
"tableNames"; _o_UI.widget("table_names"); \
"tableNumbers"; _o_UI.widget("table_ids"); \
"mains"; _o_UI.listbox("02_displayed"); \
"mainNames"; _o_UI.widget("main_names"); \
"mainNumbers"; _o_UI.widget("main_ids"); \
"addOne"; _o_UI.button("b.add.one"); \
"addAll"; _o_UI.button("b.add.all"); \
"removeOne"; _o_UI.button("b.remove.one"); \
"removeAll"; _o_UI.button("b.remove.all")\
)

$Obj_context:=$Obj_form.ui

If (OB Is empty:C1297($Obj_context))\
 | (Structure file:C489=Structure file:C489(*))
	
	// Define form methods
	$Obj_context.order:=Formula:C1597(main_Handler(New object:C1471(\
		"action"; "order")))
	$Obj_context.insert:=Formula:C1597(main_Handler(New object:C1471(\
		"action"; "add"; \
		"id"; $1; \
		"name"; $2; \
		"row"; $3)))
	$Obj_context.append:=Formula:C1597(main_Handler(New object:C1471(\
		"action"; "add"; \
		"id"; $1; \
		"name"; $2)))
	$Obj_context.UI:=Formula:C1597(main_Handler(New object:C1471(\
		"action"; "update")))
	$Obj_context.buttonsUI:=Formula:C1597(main_Handler(New object:C1471(\
		"action"; "buttons")))
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_event:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_event=On Load:K2:1)
				
				// This trick remove the horizontal gap
				$Obj_form.tables.setScrollbar(0; 2)
				$Obj_form.mains.setScrollbar(0; 2)
				
				$Obj_context.constraints:=New object:C1471
				
				$Obj_context.UI()
				
				//______________________________________________________
			: ($Lon_event=On Timer:K2:25)
				
				//OB GET PROPERTY NAMES($Obj_dataModel;$tTxt_keys)
				//$Lon_count:=Size of array($tTxt_keys)
				//OBJECT SET VISIBLE(*;"noPublishedTable";$Lon_count=0)
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		//=========================================================
	: ($Obj_in.action="update")  // UI
		
		ob_createPath(Form:C1466.main; "order"; Is collection:K8:32)
		
		$Ptr_names:=OBJECT Get pointer:C1124(Object named:K67:5; "table_names")
		$Ptr_IDs:=OBJECT Get pointer:C1124(Object named:K67:5; "table_ids")
		
		CLEAR VARIABLE:C89($Ptr_names->)
		CLEAR VARIABLE:C89($Ptr_IDs->)
		
		$Ptr_mainNames:=OBJECT Get pointer:C1124(Object named:K67:5; "main_names")
		$Ptr_mainIDs:=OBJECT Get pointer:C1124(Object named:K67:5; "main_ids")
		
		CLEAR VARIABLE:C89($Ptr_mainNames->)
		CLEAR VARIABLE:C89($Ptr_mainIDs->)
		
		// Available tables
		If (Form:C1466.dataModel#Null:C1517)
			
			For each ($Txt_tableNumber; Form:C1466.dataModel)
				
				APPEND TO ARRAY:C911($Ptr_names->; Form:C1466.dataModel[$Txt_tableNumber][""].label)
				APPEND TO ARRAY:C911($Ptr_IDs->; $Txt_tableNumber)
				
			End for each 
		End if 
		
		OBJECT SET VISIBLE:C603(*; "noPublishedTable"; Size of array:C274($Ptr_names->)=0)
		
		// Selected tables
		For each ($Txt_tableNumber; Form:C1466.main.order)
			
			If (Form:C1466.dataModel[$Txt_tableNumber]#Null:C1517)
				
				APPEND TO ARRAY:C911($Ptr_mainIDs->; $Txt_tableNumber)
				APPEND TO ARRAY:C911($Ptr_mainNames->; Form:C1466.dataModel[$Txt_tableNumber][""].label)
				
			End if 
		End for each 
		
		If (PROJECT.isLocked())
			
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; $Obj_form.tables.name; False:C215; False:C215; False:C215; False:C215)
			$Obj_form.tables.setProperty(lk selection mode:K53:35; lk none:K53:57)
			$Obj_form.tables.deselect()
			
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; $Obj_form.mains.name; False:C215; False:C215; False:C215; False:C215)
			$Obj_form.mains.setProperty(lk selection mode:K53:35; lk none:K53:57)
			$Obj_form.mains.deselect()
			
		Else 
			
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; $Obj_form.tables.name; True:C214; False:C215; False:C215; False:C215)
			$Obj_form.tables.setProperty(lk selection mode:K53:35; lk multiple:K53:59)
			
			OBJECT SET DRAG AND DROP OPTIONS:C1183(*; $Obj_form.mains.name; False:C215; False:C215; True:C214; False:C215)
			$Obj_form.mains.setProperty(lk selection mode:K53:35; lk single:K53:58)
			
		End if 
		
		$Obj_context.buttonsUI()
		
		//=========================================================
	: ($Obj_in.action="order")  // Update table order
		
		$Ptr_mainIDs:=$Obj_form.mainNumbers.pointer()
		
		Form:C1466.main.order:=New collection:C1472
		
		For ($i; 1; Size of array:C274($Ptr_mainIDs->); 1)
			
			Form:C1466.main.order[$i-1]:=$Ptr_mainIDs->{$i}
			
		End for 
		
		$Obj_context.buttonsUI()
		
		//=========================================================
	: ($Obj_in.action="buttons")  // Manage activation/inactivation of the buttons
		
		If (PROJECT.isLocked())
			
			$Obj_form.addOne.disable()
			$Obj_form.addAll.disable()
			$Obj_form.removeOne.disable()
			$Obj_form.removeAll.disable()
			
		Else 
			
			$Lon_available:=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; "table_names"))->)
			$Lon_published:=Size of array:C274((OBJECT Get pointer:C1124(Object named:K67:5; "main_names"))->)
			
			$Obj_form.addOne.setEnabled(($Lon_available>$Lon_published) & ($Obj_form.tables.selected()>0))
			$Obj_form.addAll.setEnabled($Lon_available>$Lon_published)
			$Obj_form.removeOne.setEnabled($Obj_form.mains.selected()>0)
			$Obj_form.removeAll.setEnabled($Lon_published>0)
			
		End if 
		
		//=========================================================
	: (Count parameters:C259<1)  // Error - All entry points below needs an object parameter
		
		ASSERT:C1129(False:C215; "Missing parameter")
		
		//=========================================================
	: ($Obj_in.action="add")  // [panel] Add a table in the menu
		
		$Ptr_mainNames:=$Obj_form.mainNames.pointer()
		$Ptr_mainIDs:=$Obj_form.mainNumbers.pointer()
		
		//#MARK_TODO - Check template limits @see manifest.json table.max
		
		If (Find in array:C230($Ptr_mainIDs->; $Obj_in.id)=-1)
			
			If ($Obj_in.row#Null:C1517)
				
				If ($Obj_in.row>=0)
					
					INSERT IN ARRAY:C227($Ptr_mainIDs->; $Obj_in.row)
					INSERT IN ARRAY:C227($Ptr_mainNames->; $Obj_in.row)
					
					//%W-533.3
					$Ptr_mainIDs->{$Obj_in.row}:=$Obj_in.id
					$Ptr_mainNames->{$Obj_in.row}:=$Obj_in.name
					//%W+533.3
					
				Else 
					
					APPEND TO ARRAY:C911($Ptr_mainIDs->; $Obj_in.id)
					APPEND TO ARRAY:C911($Ptr_mainNames->; $Obj_in.name)
					
				End if 
				
			Else 
				
				APPEND TO ARRAY:C911($Ptr_mainIDs->; $Obj_in.id)
				APPEND TO ARRAY:C911($Ptr_mainNames->; $Obj_in.name)
				
			End if 
			
		Else 
			
			// Already in
			
		End if 
		
		//=========================================================
	: ($Obj_in.action="push")
		
		// Ensure the path is valid
		$o:=ob_createPath(Form:C1466; "main.order"; Is collection:K8:32)
		
		If ($o.main.order.indexOf($Obj_in.tableNumber)=-1)
			
			$o.main.order.push($Obj_in.tableNumber)
			
		End if 
		
		//=========================================================
	: ($Obj_in.action="remove")
		
		// Ensure the path is valid
		$o:=ob_createPath(Form:C1466; "main.order"; Is collection:K8:32)
		
		$l:=$o.main.order.indexOf($Obj_in.tableNumber)
		
		If ($l#-1)
			
			$o.main.order.remove($l)
			
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
If ($Obj_out#Null:C1517)
	
	$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End