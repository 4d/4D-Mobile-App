//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : STRUCTURE_ACTION
  // ID[5A64EA882E6E427785DD1F014276EFDB]
  // Created 8-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_value)
C_LONGINT:C283($Lon_i;$Lon_number;$Lon_parameters;$Lon_row;$Lon_x)
C_POINTER:C301($Ptr_me;$Ptr_published)
C_OBJECT:C1216($Obj_context;$Obj_form;$Obj_popup)

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
$Obj_popup:=cs:C1710.menu.new()

Case of 
		
		  //________________________________________
	: ($Obj_context.focus=$Obj_form.tables)
		
		$Obj_popup.append(":xliff:sortByTableName";"sortByName";Bool:C1537($Obj_context.tableSortByName))
		$Obj_popup.append(":xliff:sortByTableNumber";"sortDefault";Not:C34(Bool:C1537($Obj_context.tableSortByName)))
		$Obj_popup.line()
		$Obj_popup.append(":xliff:onlyPublishedTables";"published";Bool:C1537($Obj_context.tableFilterPublished))
		
		  //________________________________________
	: ($Obj_context.focus=$Obj_form.fields)
		
		$Ptr_me:=ui.pointer($Obj_form.fieldList)
		$Lon_number:=Size of array:C274($Ptr_me->)
		
		$Lon_row:=Find in array:C230($Ptr_me->;True:C214)
		
		$Obj_popup.append(":xliff:sortByFieldName";"sortByName";Bool:C1537($Obj_context.fieldSortByName))
		$Obj_popup.append(":xliff:sortByFieldNumber";"sortDefault";Not:C34(Bool:C1537($Obj_context.fieldSortByName)))
		$Obj_popup.line()
		$Obj_popup.append(":xliff:onlyPublishedFields";"published";Bool:C1537($Obj_context.fieldFilterPublished))
		$Obj_popup.line()
		
		$Ptr_published:=ui.pointer($Obj_form.published)
		
		If ($Lon_number>0)\
			 & ($Lon_row>0)
			
			If (Bool:C1537($Ptr_published->{$Lon_row}))
				
				$Obj_popup.append(":xliff:unpublish";"unpublish")
				
			Else 
				
				$Obj_popup.append(":xliff:publish";"publish")
				
			End if 
			
			  //$Obj_popup.shortcut(Char(Space);Command key mask)
			
			If (editor_Locked )
				
				$Obj_popup.disable()
				
			End if 
			
		Else 
			
			$Obj_popup.append(":xliff:publish";"publish").disable()
			
		End if 
		
		If (Count in array:C907($Ptr_me->;True:C214)#$Lon_number)
			
			$Obj_popup.line()
			
			If (Count in array:C907($Ptr_published->;0)=0)
				
				$Obj_popup.append(":xliff:unpublishAll";"unpublishAll")
				
			Else 
				
				$Obj_popup.append(":xliff:publishAll";"publishAll")
				
			End if 
		End if 
		
		  //#93984
		If ($Lon_number=0)\
			 | (editor_Locked )
			
			$Obj_popup.disable()
			
		End if 
		
		  //…………………………………………………………………………………………………
End case 

$Obj_popup.line()
$Obj_popup.append(":xliff:search";"search").shortcut("f";Command key mask:K16:1)

If ($Obj_popup.popup().selected)
	
	Case of 
			
			  //………………………………………………………………………………………
		: ($Obj_popup.choice="sortByName")\
			 | ($Obj_popup.choice="sortDefault")
			
			If ($Obj_context.focus=$Obj_form.tables)
				
				$Obj_context.tableSortByName:=Not:C34(Bool:C1537($Obj_context.tableSortByName))
				
				STRUCTURE_Handler (New object:C1471(\
					"action";"tableList"))
				
			Else 
				
				$Obj_context.fieldSortByName:=Not:C34(Bool:C1537($Obj_context.fieldSortByName))
				
				structure_FIELD_LIST ($Obj_form)
				
			End if 
			
			  //………………………………………………………………………………………
		: ($Obj_popup.choice="published")  // Add-remove published filter
			
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
		: ($Obj_popup.choice="search")
			
			EXECUTE METHOD IN SUBFORM:C1085("search";"Search_HANDLER";*;New object:C1471(\
				"action";"search"))
			
			  //………………………………………………………………………………………
		: ($Obj_popup.choice="publish")\
			 | ($Obj_popup.choice="unpublish")
			
			$Ptr_me:=ui.pointer($Obj_form.fieldList)
			$Ptr_published:=ui.pointer($Obj_form.published)
			$Boo_value:=($Obj_popup.choice="publish")
			
			  // For each selected items
			
			Repeat 
				
				$Lon_x:=Find in array:C230($Ptr_me->;True:C214;$Lon_x+1)
				
				If ($Lon_x>0)
					
					$Ptr_published->{$Lon_x}:=Num:C11($Boo_value)
					
				End if 
			Until ($Lon_x=-1)
			
			STRUCTURE_UPDATE ($Obj_form)
			
			  //………………………………………………………………………………………
		: ($Obj_popup.choice="publishAll")\
			 | ($Obj_popup.choice="unpublishAll")
			
			$Ptr_published:=ui.pointer($Obj_form.published)
			$Boo_value:=($Obj_popup.choice="publishAll")
			
			For ($Lon_i;1;Size of array:C274($Ptr_published->);1)
				
				$Ptr_published->{$Lon_i}:=Num:C11($Boo_value)
				
			End for 
			
			STRUCTURE_UPDATE ($Obj_form)
			
			  //………………………………………………………………………………………
		Else 
			
			If (Length:C16($Obj_popup.choice)>0)
				
				ASSERT:C1129(False:C215;"Unknown menu action ("+$Obj_popup.choice+")")
				
			End if 
			
			  //………………………………………………………………………………………
	End case 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End