//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : fields_Handler
  // Database: 4D Mobile Express
  // ID[BF3981E8AF72452DB0171AEDA52AF625]
  // Created #26-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($i;$Lon_fieldNumber;$Lon_formEvent;$Lon_parameters)
C_PICTURE:C286($p)
C_POINTER:C301($r)
C_OBJECT:C1216($o;$Obj_context;$Obj_dataModel;$Obj_form;$Obj_in;$Obj_out)
C_COLLECTION:C1488($Col_buffer)

If (False:C215)
	C_OBJECT:C1216(fields_Handler ;$0)
	C_OBJECT:C1216(fields_Handler ;$1)
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
		"fieldList";"01_fields";\
		"ids";"IDs";\
		"fields";"fields";\
		"icons";"icons";\
		"iconColumn";3;\
		"labels";"labels";\
		"labelColumn";5;\
		"shortLabels";"shortLabels";\
		"shortlabelColumn";4;\
		"formats";"formats";\
		"formatColumn";6;\
		"iconGrid";"iconGrid")
	
	$Obj_context:=$Obj_form.form
	
	$Obj_context.tableNumber:=Num:C11(Form:C1466.$dialog.TABLES.currentTableNumber)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		$Obj_dataModel:=Form:C1466.dataModel
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*;$Obj_form.fieldList;0;2)
				
				  // Constraints definition
				$Obj_context.constraints:=New object:C1471
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				fields_Handler (New object:C1471(\
					"action";"update"))
				
				  // Preload the icons
				CALL FORM:C1391($Obj_form.window;"editor_CALLBACK";"fieldIcons")
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="field")  // Get field definition
		
		ASSERT:C1129($Obj_in.row#Null:C1517)
		
		  //%W-533.3
		$Lon_fieldNumber:=Num:C11((ui.pointer($Obj_form.ids))->{$Obj_in.row})
		
		$Col_buffer:=Split string:C1554((ui.pointer($Obj_form.fields))->{$Obj_in.row};".")
		
		If ($Col_buffer.length>1)  // RelatedDataclass
			
			$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][$Col_buffer[0]][String:C10((ui.pointer($Obj_form.ids))->{$Obj_in.row})]
			
		Else 
			
			If ($Lon_fieldNumber#0)
				
				$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][String:C10($Lon_fieldNumber)]
				
			Else 
				
				  // Take the name 
				$Obj_out:=Form:C1466.dataModel[String:C10($Obj_context.tableNumber)][String:C10($Col_buffer[0])]
				
			End if 
		End if 
		  //%W+533.3
		
		  //=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		$o:=fields_LIST (String:C10($Obj_context.tableNumber))
		
		If ($o.success)
			
			COLLECTION TO ARRAY:C1562($o.ids;(ui.pointer($Obj_form.ids))->)
			COLLECTION TO ARRAY:C1562($o.paths;(ui.pointer($Obj_form.fields))->)
			COLLECTION TO ARRAY:C1562($o.labels;(ui.pointer($Obj_form.labels))->)
			COLLECTION TO ARRAY:C1562($o.shortLabels;(ui.pointer($Obj_form.shortLabels))->)
			COLLECTION TO ARRAY:C1562($o.icons;(ui.pointer($Obj_form.icons))->)
			COLLECTION TO ARRAY:C1562($o.formats;(ui.pointer($Obj_form.formats))->)
			
			For ($i;0;$o.formatColors.length-1;1)
				
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.formats;$i+1;$o.formatColors[$i];lk font color:K53:24)
				
			End for 
			
			LISTBOX SORT COLUMNS:C916(*;$Obj_form.fieldList;2;>)
			
			If (Num:C11($o.count)=0)
				
				OBJECT SET VISIBLE:C603(*;"empty";True:C214)
				OBJECT SET VISIBLE:C603(*;$Obj_form.fieldList;False:C215)
				
			Else 
				
				OBJECT SET VISIBLE:C603(*;"empty";False:C215)
				OBJECT SET VISIBLE:C603(*;$Obj_form.fieldList;True:C214)
				
			End if 
			
		Else 
			
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.ids))->)
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.fields))->)
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.labels))->)
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.shortLabels))->)
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.icons))->)
			CLEAR VARIABLE:C89((ui.pointer($Obj_form.formats))->)
			
			OBJECT SET VISIBLE:C603(*;"empty";True:C214)
			OBJECT SET VISIBLE:C603(*;$Obj_form.fieldList;False:C215)
			
		End if 
		
		editor_Locked ($Obj_form.labels;$Obj_form.shortLabels;$Obj_form.formats)
		
		$Obj_context.current:=0
		LISTBOX SELECT ROW:C912(*;$Obj_form.fieldList;0;lk remove from selection:K53:3)
		editor_ui_LISTBOX ($Obj_form.fieldList)
		
		  //=========================================================
	: ($Obj_in.action="fieldIcons")  // Call back from widget
		
		If ($Obj_in.item>0)\
			 & ($Obj_in.item<=$Obj_in.pathnames.length)
			
			  // Update data model
			fields_Handler (New object:C1471("action";"field";"row";$Obj_in.row)).icon:=$Obj_in.pathnames[$Obj_in.item-1]
			
			  // Update UI
			$r:=ui.pointer($Obj_form.icons)
			
			  //%W-533.3
			
			If ($Obj_in.pictures[$Obj_in.item-1]#Null:C1517)
				
				$p:=$Obj_in.pictures[$Obj_in.item-1]
				CREATE THUMBNAIL:C679($p;$p;24;24;Scaled to fit:K6:2)
				
				$r->{$Obj_in.row}:=$p
				
			Else 
				
				CLEAR VARIABLE:C89($r->{$Obj_in.row})
				
			End if 
			  //%W+533.3
			
			ui.saveProject()
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="icons")  // Preload the icons
		
		$Obj_in.target:="fieldIcons"
		(ui.pointer($Obj_form.iconGrid))->:=editor_LoadIcons ($Obj_in)
		
		  //=========================================================
	: ($Obj_in.action="select")  // Set the selected field
		
		$Obj_context.currentFieldNumber:=Num:C11($Obj_in.fieldNumber)
		
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