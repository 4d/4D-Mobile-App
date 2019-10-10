//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : structure_TABLE_LIST
  // ID[805CAE4EB6024C04B45995284E0877F4]
  // Created 1-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_error)
C_LONGINT:C283($l;$Lon_parameters;$Lon_row;$Lon_table)
C_POINTER:C301($Ptr_fields;$Ptr_tables)
C_OBJECT:C1216($Obj_context;$Obj_dataModel;$Obj_form;$Obj_table)
C_COLLECTION:C1488($Col_catalog;$Col_unsynchronizedTableFields)

If (False:C215)
	C_OBJECT:C1216(structure_TABLE_LIST ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_form:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_context:=$Obj_form.form
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Ptr_tables:=ui.pointer($Obj_form.tables)
CLEAR VARIABLE:C89($Ptr_tables->)

$Col_catalog:=$Obj_context.catalog()

If (Form:C1466.$dialog.unsynchronizedTableFields#Null:C1517)
	
	$Col_unsynchronizedTableFields:=Form:C1466.$dialog.unsynchronizedTableFields
	
End if 

$Obj_dataModel:=Form:C1466.dataModel

Case of 
		
		  //________________________________________
	: ($Col_catalog=Null:C1517)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: (Length:C16(String:C10($Obj_context.tableFilter))>0)\
		 & (Bool:C1537($Obj_context.tableFilterPublished))
		
		  //For each ($Obj_table;$Obj_cache.structure.definition)
		For each ($Obj_table;$Col_catalog)
			
			CLEAR VARIABLE:C89($Boo_error)
			
			If (Position:C15($Obj_context.tableFilter;$Obj_table.name)>0)\
				 & ($Obj_dataModel[String:C10($Obj_table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
				$Lon_table:=$Lon_table+1
				
				If ($Col_unsynchronizedTableFields.length>$Obj_table.tableNumber)
					
					$Boo_error:=($Col_unsynchronizedTableFields[$Obj_table.tableNumber]#Null:C1517)
					
				End if 
				
				If ($Boo_error)
					
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;ui.errorColor;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Plain:K14:1)
					
				Else 
					
					  // Highlight published table name
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;lk inherited:K53:26;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Choose:C955($Obj_dataModel[String:C10($Obj_table.tableNumber)]=Null:C1517;Plain:K14:1;Bold:K14:2))
					
				End if 
			End if 
		End for each 
		
		  //______________________________________________________
	: (Length:C16(String:C10($Obj_context.tableFilter))>0)  // Filter by name
		
		  //For each ($Obj_table;$Obj_cache.structure.definition)
		For each ($Obj_table;$Col_catalog)
			
			$Boo_error:=False:C215
			
			If (Position:C15($Obj_context.tableFilter;$Obj_table.name)>0)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
				$Lon_table:=$Lon_table+1
				
				If ($Col_unsynchronizedTableFields.length>$Obj_table.tableNumber)
					
					$Boo_error:=($Col_unsynchronizedTableFields[$Obj_table.tableNumber]#Null:C1517)
					
				End if 
				
				If ($Boo_error)
					
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;ui.errorColor;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Plain:K14:1)
					
				Else 
					
					  // Highlight published table name
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;lk inherited:K53:26;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Choose:C955($Obj_dataModel[String:C10($Obj_table.tableNumber)]=Null:C1517;Plain:K14:1;Bold:K14:2))
					
				End if 
			End if 
		End for each 
		
		  //______________________________________________________
	: (Bool:C1537($Obj_context.tableFilterPublished))  // Filter published
		
		  //For each ($Obj_table;$Obj_cache.structure.definition)
		For each ($Obj_table;$Col_catalog)
			
			$Boo_error:=False:C215
			
			If ($Obj_dataModel[String:C10($Obj_table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
				$Lon_table:=$Lon_table+1
				
				If ($Col_unsynchronizedTableFields.length>$Obj_table.tableNumber)
					
					$Boo_error:=($Col_unsynchronizedTableFields[$Obj_table.tableNumber]#Null:C1517)
					
				End if 
				
				If ($Boo_error)
					
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;ui.errorColor;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Plain:K14:1)
					
				Else 
					
					  // Highlight published table name
					LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;lk inherited:K53:26;lk font color:K53:24)
					LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Choose:C955($Obj_dataModel[String:C10($Obj_table.tableNumber)]=Null:C1517;Plain:K14:1;Bold:K14:2))
					
				End if 
			End if 
		End for each 
		
		  //______________________________________________________
	Else   // No filter
		
		COLLECTION TO ARRAY:C1562($Col_catalog;$Ptr_tables->;"name")
		
		  //For each ($Obj_table;$Obj_cache.structure.definition)
		For each ($Obj_table;$Col_catalog)
			
			$Boo_error:=False:C215
			
			$Lon_table:=$Lon_table+1
			
			If ($Col_unsynchronizedTableFields.length>($Obj_table.tableNumber))
				
				$Boo_error:=($Col_unsynchronizedTableFields[$Obj_table.tableNumber]#Null:C1517)
				
			End if 
			
			If ($Boo_error)
				
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;ui.errorColor;lk font color:K53:24)
				LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Plain:K14:1)
				
			Else 
				
				  // Highlight published table name
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_table;lk inherited:K53:26;lk font color:K53:24)
				LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_table;Choose:C955($Obj_dataModel[String:C10($Obj_table.tableNumber)]=Null:C1517;Plain:K14:1;Bold:K14:2))
				
			End if 
		End for each 
		
		  //______________________________________________________
End case 


  //----------------------
  //  HIGHLIGHT ERRORS
  //----------------------
$c:=Form:C1466.$dialog.unsynchronizedTableFields

$i:=0















  // Sort if any
If (Bool:C1537($Obj_context.tableSortByName))
	
	LISTBOX SORT COLUMNS:C916(*;$Obj_form.tableList;1;>)
	
End if 

  // Select the first table if any [
If ($Obj_context.currentTable=Null:C1517)
	
	GOTO OBJECT:C206(*;$Obj_form.tableList)
	
	If (Size of array:C274($Ptr_tables->)>0)
		
		$l:=$Col_catalog.extract("name").indexOf($Ptr_tables->{1})
		$Obj_context.currentTable:=$Col_catalog[$l]
		
	End if 
	
Else 
	
	GOTO OBJECT:C206(*;$Obj_context.focus)
	
End if 
  //]

  // Get the current table
$Lon_row:=Find in array:C230($Ptr_tables->;String:C10($Obj_context.currentTable.name))

  // Update the field list
$Ptr_fields:=ui.pointer($Obj_form.fields)

If ($Lon_row>0)
	
	LISTBOX SELECT ROW:C912(*;$Obj_form.tableList;$Lon_row;lk replace selection:K53:1)
	OBJECT SET SCROLL POSITION:C906(*;$Obj_form.tableList;$Lon_row)
	
	  //If (Size of array($Ptr_fields->)=0)
	
	structure_FIELD_LIST ($Obj_form)
	
	  //End if 
	
Else 
	
	LISTBOX SELECT ROW:C912(*;$Obj_form.tableList;0;lk remove from selection:K53:3)
	OBJECT SET SCROLL POSITION:C906(*;$Obj_form.tableList)
	
	OB REMOVE:C1226($Obj_context;"currentTable")
	
	CLEAR VARIABLE:C89($Ptr_fields->)
	
	SET TIMER:C645(-1)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End