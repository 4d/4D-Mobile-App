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
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(structure_TABLE_LIST; $1)
End if 

var $index; $row : Integer
var $tablesPtr : Pointer
var $ƒ; $dataModel; $form; $table : Object
var $c; $catalog : Collection

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$form:=$1
	
	// Optional parameters
	// <NONE>
	
	$ƒ:=$form.form
	
	$dataModel:=Form:C1466.dataModel
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$tablesPtr:=OBJECT Get pointer:C1124(Object named:K67:5; $form.tables)
CLEAR VARIABLE:C89($tablesPtr->)

$catalog:=PROJECT.getCatalog()

Case of 
		
		//________________________________________
	: ($catalog=Null:C1517)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: (Length:C16(String:C10($ƒ.tableFilter))>0)\
		 & (Bool:C1537($ƒ.tableFilterPublished))
		
		For each ($table; $catalog)
			
			If (Position:C15($ƒ.tableFilter; $table.name)>0)\
				 & ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($tablesPtr->; $table.name)
				
			End if 
		End for each 
		
		//______________________________________________________
	: (Length:C16(String:C10($ƒ.tableFilter))>0)  // Filter by name
		
		For each ($table; $catalog)
			
			If (Position:C15($ƒ.tableFilter; $table.name)>0)
				
				APPEND TO ARRAY:C911($tablesPtr->; $table.name)
				
			End if 
		End for each 
		
		//______________________________________________________
	: (Bool:C1537($ƒ.tableFilterPublished))  // Filter published
		
		For each ($table; $catalog)
			
			If ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
				
				APPEND TO ARRAY:C911($tablesPtr->; $table.name)
				
			End if 
		End for each 
		
		//______________________________________________________
	Else   // No filter
		
		COLLECTION TO ARRAY:C1562($catalog; $tablesPtr->; "name")
		
		//______________________________________________________
End case 

// ----------------------
//  HIGHLIGHT ERRORS
// ----------------------
$c:=Form:C1466.$dialog.unsynchronizedTableFields

For each ($table; $catalog)
	
	If (Find in array:C230($tablesPtr->; $table.name)>0)
		
		$row:=$row+1
		
		Case of 
				
				//______________________________________________________
			: ($c.length<=$table.tableNumber)
				
				LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; lk inherited:K53:26; lk font color:K53:24)
				
				//______________________________________________________
			: ($c[$table.tableNumber]#Null:C1517)
				
				LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; EDITOR.errorColor; lk font color:K53:24)
				
				//______________________________________________________
			Else 
				
				LISTBOX SET ROW COLOR:C1270(*; $form.tableList; $row; lk inherited:K53:26; lk font color:K53:24)
				
				//______________________________________________________
		End case 
		
		// Highlight published table name
		LISTBOX SET ROW FONT STYLE:C1268(*; $form.tableList; $row; Choose:C955($dataModel[String:C10($table.tableNumber)]=Null:C1517; Plain:K14:1; Bold:K14:2))
		
	End if 
End for each 

// Sort if any
If (Bool:C1537($ƒ.tableSortByName))
	
	LISTBOX SORT COLUMNS:C916(*; $form.tableList; 1; >)
	
End if 

// Select the first table if any [
If ($ƒ.currentTable=Null:C1517)
	
	GOTO OBJECT:C206(*; $form.tableList)
	
	If (Size of array:C274($tablesPtr->)>0)
		
		$index:=$catalog.extract("name").indexOf($tablesPtr->{1})
		$ƒ.currentTable:=$catalog[$index]
		
	End if 
	
Else 
	
	GOTO OBJECT:C206(*; $ƒ.focus)
	
End if 

// Get the current table & update the field list
$index:=Find in array:C230($tablesPtr->; String:C10($ƒ.currentTable.name))

If ($index>0)
	
	LISTBOX SELECT ROW:C912(*; $form.tableList; $index; lk replace selection:K53:1)
	OBJECT SET SCROLL POSITION:C906(*; $form.tableList; $index)
	
	structure_FIELD_LIST($form)
	
Else 
	
	LISTBOX SELECT ROW:C912(*; $form.tableList; 0; lk remove from selection:K53:3)
	OBJECT SET SCROLL POSITION:C906(*; $form.tableList)
	
	OB REMOVE:C1226($ƒ; "currentTable")
	
	CLEAR VARIABLE:C89((OBJECT Get pointer:C1124(Object named:K67:5; $form.fields))->)
	
	SET TIMER:C645(-1)
	
End if 

// ----------------------------------------------------
// Return
// <NONE>
// ----------------------------------------------------
// End