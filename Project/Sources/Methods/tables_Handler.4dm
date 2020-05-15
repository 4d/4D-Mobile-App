//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tables_Handler
  // ID[3D5EC88F9A2C460C8D6DE0C7B17E6B10]
  // Created 26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_formEvent;$Lon_parameters;$Lon_x)
C_PICTURE:C286($p)
C_POINTER:C301($Ptr_ids)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(tables_Handler ;$0)
	C_OBJECT:C1216(tables_Handler ;$1)
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
		"tableList";"01_tables";\
		"ids";"IDs";\
		"idColumn";1;\
		"tables";"tables";\
		"tableColumn";2;\
		"icons";"icons";\
		"iconColumn";3;\
		"labels";"labels";\
		"labelColumn";5;\
		"shortLabels";"shortLabels";\
		"shortlabelColumn";4;\
		"iconGrid";"iconGrid")
	
	$Obj_context:=$Obj_form.form
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*;$Obj_form.tableList;0;2)
				
				  // Constraints definition
				$Obj_context.constraints:=New object:C1471
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				tables_Handler (New object:C1471(\
					"action";"update"))
				
				  // Preload the icons
				CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"tableIcons")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		$o:=publishedTableList (New object:C1471(\
			"dataModel";Form:C1466.dataModel))
		
		OBJECT SET VISIBLE:C603(*;$Obj_form.tableList;False:C215)
		
		If ($o.success)
			
			COLLECTION TO ARRAY:C1562($o.ids;(ui.pointer($Obj_form.ids))->)
			COLLECTION TO ARRAY:C1562($o.names;(ui.pointer($Obj_form.tables))->)
			COLLECTION TO ARRAY:C1562($o.labels;(ui.pointer($Obj_form.labels))->)
			COLLECTION TO ARRAY:C1562($o.shortLabels;(ui.pointer($Obj_form.shortLabels))->)
			COLLECTION TO ARRAY:C1562($o.icons;(ui.pointer($Obj_form.icons))->)
			
			If ($o.ids.length>0)
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.tableList;True:C214)
				OBJECT SET VISIBLE:C603(*;"noPublishedTable";False:C215)
				GOTO OBJECT:C206(*;$Obj_form.tableList)
				
				  // Select the first table if any
				If (Num:C11($Obj_context.currentTableNumber)=0)
					
					$Obj_context.currentTableNumber:=$o.ids[0]
					
				End if 
				
				If ($Obj_context.currentTable=Null:C1517)
					
					$Obj_context.currentTable:=Form:C1466.dataModel[String:C10($Obj_context.currentTableNumber)]
					
				End if 
				
				LISTBOX SORT COLUMNS:C916(*;$Obj_form.tableList;2;>)
				
				  // Select current table
				$Lon_x:=Find in array:C230((ui.pointer($Obj_form.ids))->;String:C10($Obj_context.currentTableNumber))
				LISTBOX SELECT ROW:C912(*;$Obj_form.tableList;Choose:C955($Lon_x<0;1;$Lon_x);lk replace selection:K53:1)
				
			Else 
				
				OB REMOVE:C1226($Obj_context;"currentTableNumber")
				OB REMOVE:C1226($Obj_context;"currentTable")
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.tableList;False:C215)
				OBJECT SET VISIBLE:C603(*;"noPublishedTable";True:C214)
				
			End if 
			
		Else 
			
			OB REMOVE:C1226($Obj_context;"currentTableNumber")
			OB REMOVE:C1226($Obj_context;"currentTable")
			
			OBJECT SET VISIBLE:C603(*;$Obj_form.tableList;False:C215)
			OBJECT SET VISIBLE:C603(*;"noPublishedTable";True:C214)
			
		End if 
		
		editor_Locked ($Obj_form.labels;$Obj_form.shortLabels)
		
		editor_ui_LISTBOX ($Obj_form.tableList)
		
		  //=========================================================
	: ($Obj_in.action="tableIcons")  // Call back from widget
		
		$Ptr_ids:=ui.pointer($Obj_form.ids)
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			  // Update data model
			  //%W-533.3
			Form:C1466.dataModel[$Ptr_ids->{$Obj_in.row}][""].icon:=$Obj_in.pathnames[$Obj_in.item-1]
			  //%W+533.3
			
			  // Update UI
			$Ptr_ids:=ui.pointer($Obj_form.icons)
			
			If ($Obj_in.pictures[$Obj_in.item-1]#Null:C1517)
				
				$p:=$Obj_in.pictures[$Obj_in.item-1]
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				
				  //%W-533.3
				$Ptr_ids->{$Obj_in.row}:=$p
				  //%W+533.3
				
			Else 
				
				  //%W-533.3
				CLEAR VARIABLE:C89($Ptr_ids->{$Obj_in.row})
				  //%W+533.3
				
			End if 
		End if 
		
		  //=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		$Obj_in.target:="tableIcons"
		(ui.pointer($Obj_form.iconGrid))->:=editor_LoadIcons ($Obj_in)
		
		  //=========================================================
	: ($Obj_in.action="select")  // Set the selected table
		
		$Obj_context.currentTableNumber:=Num:C11($Obj_in.tableNumber)
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End