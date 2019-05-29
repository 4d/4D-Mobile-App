//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_ACTION
  // Database: 4D Mobile App
  // ID[5A64EA882E6E427785DD1F014276EFDB]
  // Created #8-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_value)
C_LONGINT:C283($Lon_i;$Lon_number;$Lon_parameters;$Lon_row;$Lon_x)
C_POINTER:C301($Ptr_me;$Ptr_published)
C_TEXT:C284($Mnu_choice;$Mnu_main)
C_OBJECT:C1216($Obj_context;$Obj_form)

If (False:C215)
	C_OBJECT:C1216(STRUCTURE_ACTION ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_form:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_context:=$Obj_form.form
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Mnu_main:=Create menu:C408

Case of 
		
		  //________________________________________
	: ($Obj_context.focus=$Obj_form.tables)
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:sortByTableName")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"sortByName")
		
		If (Bool:C1537($Obj_context.tableSortByName))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:sortByTableNumber")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"sortDefault")
		
		If (Not:C34(Bool:C1537($Obj_context.tableSortByName)))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:onlyPublishedTables")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"published")
		
		If (Bool:C1537($Obj_context.tableFilterPublished))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:search")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"search")
		SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;"f";Command key mask:K16:1)
		
		  //________________________________________
	: ($Obj_context.focus=$Obj_form.fields)
		
		$Ptr_me:=ui.pointer($Obj_form.fieldList)
		$Lon_number:=Size of array:C274($Ptr_me->)
		
		$Lon_row:=Find in array:C230($Ptr_me->;True:C214)
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:sortByFieldName")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"sortByName")
		
		If (Bool:C1537($Obj_context.fieldSortByName))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:sortByFieldNumber")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"sortDefault")
		
		If (Not:C34(Bool:C1537($Obj_context.fieldSortByName)))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:onlyPublishedFields")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"published")
		
		If (Bool:C1537($Obj_context.fieldFilterPublished))
			
			SET MENU ITEM MARK:C208($Mnu_main;-1;Char:C90(18))
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		$Ptr_published:=ui.pointer($Obj_form.published)
		
		If ($Lon_number>0)\
			 & ($Lon_row>0)
			
			If (Bool:C1537($Ptr_published->{$Lon_row}))
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:unpublish")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"unpublish")
				
			Else 
				
				APPEND MENU ITEM:C411($Mnu_main;":xliff:publish")
				SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"publish")
				
			End if 
			
			SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;Char:C90(Space:K15:42);Command key mask:K16:1)
			
			If (editor_Locked )
				
				DISABLE MENU ITEM:C150($Mnu_main;-1)
				
			End if 
			
		Else 
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:publish")
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"publish")
			DISABLE MENU ITEM:C150($Mnu_main;-1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		If (Count in array:C907($Ptr_published->;0)=0)
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:unpublishAll")
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"unpublishAll")
			
		Else 
			
			APPEND MENU ITEM:C411($Mnu_main;":xliff:publishAll")
			SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"publishAll")
			
		End if 
		
		  //#93984
		If ($Lon_number=0)\
			 | (editor_Locked )
			
			DISABLE MENU ITEM:C150($Mnu_main;-1)
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_main;"-")
		
		APPEND MENU ITEM:C411($Mnu_main;":xliff:search")
		SET MENU ITEM PARAMETER:C1004($Mnu_main;-1;"search")
		SET MENU ITEM SHORTCUT:C423($Mnu_main;-1;"f";Command key mask:K16:1)
		
		  //…………………………………………………………………………………………………
End case 

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_main)
RELEASE MENU:C978($Mnu_main)

Case of 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="sortByName")\
		 | ($Mnu_choice="sortDefault")
		
		If ($Obj_context.focus=$Obj_form.tables)
			
			$Obj_context.tableSortByName:=Not:C34(Bool:C1537($Obj_context.tableSortByName))
			
			STRUCTURE_Handler (New object:C1471(\
				"action";"tableList"))
			
		Else 
			
			$Obj_context.fieldSortByName:=Not:C34(Bool:C1537($Obj_context.fieldSortByName))
			
			structure_FIELD_LIST ($Obj_form)
			
		End if 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="published")  // Add-remove published filter
		
		If ($Obj_context.focus=$Obj_form.tables)
			
			$Obj_context.tableFilterPublished:=Not:C34(Bool:C1537($Obj_context.tableFilterPublished))
			
			STRUCTURE_Handler (New object:C1471(\
				"action";"tableList"))
			
			STRUCTURE_Handler (New object:C1471(\
				"action";"tableFilter"))
			
		Else 
			
			$Obj_context.fieldFilterPublished:=Not:C34(Bool:C1537($Obj_context.fieldFilterPublished))
			
			structure_FIELD_LIST ($Obj_form)
			
			STRUCTURE_Handler (New object:C1471(\
				"action";"fieldFilter"))
			
		End if 
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="search")
		
		EXECUTE METHOD IN SUBFORM:C1085("search";"Search_HANDLER";*;New object:C1471(\
			"action";"search"))
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="publish")\
		 | ($Mnu_choice="unpublish")
		
		$Ptr_me:=ui.pointer($Obj_form.fieldList)
		$Ptr_published:=ui.pointer($Obj_form.published)
		$Boo_value:=($Mnu_choice="publish")
		
		  // For each selected items
		Repeat 
			
			$Lon_x:=Find in array:C230($Ptr_me->;True:C214;$Lon_x+1)
			
			If ($Lon_x>0)
				
				$Ptr_published->{$Lon_x}:=Num:C11($Boo_value)
				
			End if 
		Until ($Lon_x=-1)
		
		STRUCTURE_UPDATE ($Obj_form)
		
		  //………………………………………………………………………………………
	: ($Mnu_choice="publishAll")\
		 | ($Mnu_choice="unpublishAll")
		
		$Ptr_published:=ui.pointer($Obj_form.published)
		$Boo_value:=($Mnu_choice="publishAll")
		
		For ($Lon_i;1;Size of array:C274($Ptr_published->);1)
			
			$Ptr_published->{$Lon_i}:=Num:C11($Boo_value)
			
		End for 
		
		STRUCTURE_UPDATE ($Obj_form)
		
		  //………………………………………………………………………………………
	Else 
		
		If (Length:C16($Mnu_choice)>0)
			
			ASSERT:C1129(False:C215;"Unknown menu action ("+$Mnu_choice+")")
			
		End if 
		
		  //………………………………………………………………………………………
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End