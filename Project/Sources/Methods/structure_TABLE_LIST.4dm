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

C_LONGINT:C283($l;$Lon_row)
C_POINTER:C301($Ptr_tables)
C_OBJECT:C1216($Obj_context;$Obj_dataModel;$Obj_form;$Obj_table)
C_COLLECTION:C1488($c;$Col_catalog)

If (False:C215)
	C_OBJECT:C1216(structure_TABLE_LIST ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_form:=$1
	
	  // Optional parameters
	  // <NONE>
	
	$Obj_context:=$Obj_form.form
	
	$Obj_dataModel:=Form:C1466.dataModel
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Ptr_tables:=ui.pointer($Obj_form.tables)
CLEAR VARIABLE:C89($Ptr_tables->)

$Col_catalog:=$Obj_context.catalog()

Case of 
		
		  //________________________________________
	: ($Col_catalog=Null:C1517)
		
		  // NOTHING MORE TO DO
		
		  //______________________________________________________
	: (Length:C16(String:C10($Obj_context.tableFilter))>0)\
		 & (Bool:C1537($Obj_context.tableFilterPublished))
		
		For each ($Obj_table;$Col_catalog)
			
			If (Position:C15($Obj_context.tableFilter;$Obj_table.name)>0)\
				 & ($Obj_dataModel[String:C10($Obj_table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
			End if 
		End for each 
		
		  //______________________________________________________
	: (Length:C16(String:C10($Obj_context.tableFilter))>0)  // Filter by name
		
		For each ($Obj_table;$Col_catalog)
			
			If (Position:C15($Obj_context.tableFilter;$Obj_table.name)>0)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
			End if 
		End for each 
		
		  //______________________________________________________
	: (Bool:C1537($Obj_context.tableFilterPublished))  // Filter published
		
		For each ($Obj_table;$Col_catalog)
			
			If ($Obj_dataModel[String:C10($Obj_table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($Ptr_tables->;$Obj_table.name)
				
			End if 
		End for each 
		
		  //______________________________________________________
	Else   // No filter
		
		COLLECTION TO ARRAY:C1562($Col_catalog;$Ptr_tables->;"name")
		
		  //______________________________________________________
End case 

  // ----------------------
  //  HIGHLIGHT ERRORS
  // ----------------------
$c:=Form:C1466.$dialog.unsynchronizedTableFields

$Lon_row:=0

For each ($Obj_table;$Col_catalog)
	
	If (Find in array:C230($Ptr_tables->;$Obj_table.name)>0)
		
		$Lon_row:=$Lon_row+1
		
		Case of 
				
				  //______________________________________________________
			: ($c.length<=$Obj_table.tableNumber)
				
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_row;lk inherited:K53:26;lk font color:K53:24)
				
				  //______________________________________________________
			: ($c[$Obj_table.tableNumber]#Null:C1517)
				
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_row;ui.errorColor;lk font color:K53:24)
				
				  //______________________________________________________
			Else 
				
				LISTBOX SET ROW COLOR:C1270(*;$Obj_form.tableList;$Lon_row;lk inherited:K53:26;lk font color:K53:24)
				
				  //______________________________________________________
		End case 
		
		  // Highlight published table name
		LISTBOX SET ROW FONT STYLE:C1268(*;$Obj_form.tableList;$Lon_row;Choose:C955($Obj_dataModel[String:C10($Obj_table.tableNumber)]=Null:C1517;Plain:K14:1;Bold:K14:2))
		
	End if 
End for each 

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

  // Get the current table & update the field list
$l:=Find in array:C230($Ptr_tables->;String:C10($Obj_context.currentTable.name))

If ($l>0)
	
	LISTBOX SELECT ROW:C912(*;$Obj_form.tableList;$l;lk replace selection:K53:1)
	OBJECT SET SCROLL POSITION:C906(*;$Obj_form.tableList;$l)
	
	structure_FIELD_LIST ($Obj_form)
	
Else 
	
	LISTBOX SELECT ROW:C912(*;$Obj_form.tableList;0;lk remove from selection:K53:3)
	OBJECT SET SCROLL POSITION:C906(*;$Obj_form.tableList)
	
	OB REMOVE:C1226($Obj_context;"currentTable")
	
	CLEAR VARIABLE:C89((ui.pointer($Obj_form.fields))->)
	
	SET TIMER:C645(-1)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End