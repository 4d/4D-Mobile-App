Class extends scrollable

//________________________________________________________________
Class constructor
	C_TEXT:C284($1)
	C_VARIANT:C1683($2)
	
	If (Count parameters:C259>=2)
		
		Super:C1705($1; $2)
		
	Else 
		
		Super:C1705($1)
		
	End if 
	
	ASSERT:C1129(This:C1470.type=Object type listbox:K79:8)
	
	//________________________________________________________________
Function getCoordinates
	
	Super:C1706.getCoordinates()
	This:C1470.getScrollbars()
	This:C1470.updateDefinition()
	This:C1470.getCell()
	
	//________________________________________________________________
	// Select a row #TO_DO: use a collection for multiple selection
Function select($row : Integer)->$this : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; $row; lk replace selection:K53:1)
	
	$this:=This:C1470
	
	//________________________________________________________________
	// Select all rows
Function selectAll()->$this : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; 0; lk replace selection:K53:1)
	
	$this:=This:C1470
	
	//________________________________________________________________
	// Deselect all items
Function deselect()->$this : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; 0; lk remove from selection:K53:3)
	
	$this:=This:C1470
	
	//________________________________________________________________
Function selectedNumber()->$count : Integer
	
	$count:=Count in array:C907((This:C1470.pointer())->; True:C214)
	
	//________________________________________________________________
Function rowsNumber()->$count : Integer
	
	$count:=LISTBOX Get number of rows:C915(*; This:C1470.name)
	
	//________________________________________________________________
Function 
	
	//________________________________________________________________
	// Reveal the row
Function reveal($row : Integer)->$this : cs:C1710.listbox
	
	LISTBOX SELECT ROW:C912(*; This:C1470.name; $row; lk replace selection:K53:1)
	OBJECT SET SCROLL POSITION:C906(*; This:C1470.name; $row)
	
	$this:=This:C1470
	
	//________________________________________________________________
	// Update the listbox columns/rows definition
Function updateDefinition()->$this : cs:C1710.listbox
	
	var $i : Integer
	
	ARRAY BOOLEAN:C223($areVisible; 0x0000)
	ARRAY POINTER:C280($columnsPtr; 0x0000)
	ARRAY POINTER:C280($footersPtr; 0x0000)
	ARRAY POINTER:C280($headersPtr; 0x0000)
	ARRAY POINTER:C280($stylesPtr; 0x0000)
	ARRAY TEXT:C222($columnNames; 0x0000)
	ARRAY TEXT:C222($footerNames; 0x0000)
	ARRAY TEXT:C222($headerNames; 0x0000)
	
	LISTBOX GET ARRAYS:C832(*; This:C1470.name; \
		$columnNames; $headerNames; \
		$columnsPtr; $headersPtr; \
		$areVisible; \
		$stylesPtr; \
		$footerNames; $footersPtr)
	
	This:C1470.definition:=New collection:C1472
	
	ARRAY TO COLLECTION:C1563(This:C1470.definition; \
		$columnNames; "names"; \
		$headerNames; "headers"; \
		$footerNames; "footers")
	
	This:C1470.columns:=New object:C1471
	
	For ($i; 1; Size of array:C274($columnNames); 1)
		
		This:C1470.columns[$columnNames{$i}]:=New object:C1471(\
			"number"; $i; \
			"pointer"; $columnsPtr{$i})
		
	End for 
	
	This:C1470.getScrollbars()
	
	$this:=This:C1470
	
	//________________________________________________________________
	// Update the current cell ondexes and coordinates
Function updateCell()->$this : cs:C1710.listbox
	
	This:C1470.cellPosition()
	This:C1470.cellCoordinates()
	
	$this:=This:C1470
	
	//________________________________________________________________
	// Current cell indexes {column,row}
Function cellPosition($event : Object)->$position : Object
	
	var $_; $column; $row; $x; $y : Integer
	var $e; $event : Object
	
	$e:=Choose:C955(Count parameters:C259>=1; $event; FORM Event:C1606)
	
	If ($e.code=On Clicked:K2:4)\
		 | ($e.code=On Double Clicked:K2:5)
		
		LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $column; $row)
		
	Else 
		
		GET MOUSE:C468($x; $y; $_)
		LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $x; $y; $column; $row)
		
	End if 
	
	$position:=New object:C1471(\
		"column"; $column; \
		"row"; $row)
	
	//________________________________________________________________
Function cellCoordinates($column : Integer; $row : Integer)->$coordinates : Object
	
	var $bottom; $left; $right; $top : Integer
	var $columnƒ; $rowƒ : Integer
	var $e : Object
	
	If (Count parameters:C259=0)
		
		$e:=FORM Event:C1606
		
		If ($e.column#Null:C1517)
			
			$columnƒ:=$e.column
			$rowƒ:=$e.row
			
		Else 
			
			// A "If" statement should never omit "Else"
			
		End if 
		
	Else 
		
		$columnƒ:=$column
		$rowƒ:=$row
		
	End if 
	
	LISTBOX GET CELL COORDINATES:C1330(*; This:C1470.name; $columnƒ; $rowƒ; $left; $top; $right; $bottom)
	
	If (This:C1470.cellBox=Null:C1517)
		
		This:C1470.cellBox:=New object:C1471(\
			"left"; $left; \
			"top"; $top; \
			"right"; $right; \
			"bottom"; $bottom)
		
	Else 
		
		This:C1470.cellBox.left:=$left
		This:C1470.cellBox.top:=$top
		This:C1470.cellBox.right:=$right
		This:C1470.cellBox.bottom:=$bottom
		
	End if 
	
	$coordinates:=This:C1470.cellBox
	
	//________________________________________________________________
	// Displays a cs.menu at the bottom left of the current cell
Function popup($menu : cs:C1710.menu; $default : Text)->$choice : cs:C1710.menu
	
	var $bottom; $left : Integer
	
	This:C1470.cellCoordinates()
	
	$left:=This:C1470.cellBox.left
	$bottom:=This:C1470.cellBox.bottom
	
	CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Current window:K27:6)
	
	If (Count parameters:C259=1)
		
		$menu.popup(""; $left; $bottom)
		
	Else 
		
		$menu.popup($default; $left; $bottom)
		
	End if 
	
	$choice:=$menu
	
	//________________________________________________________________
Function clear()->$this : cs:C1710.listbox
	
	var $o : Object
	
	This:C1470.updateDefinition()
	
	For each ($o; This:C1470.definition)
		
		CLEAR VARIABLE:C89(OBJECT Get pointer:C1124(Object named:K67:5; $o.names)->)
		
	End for each 
	
	$this:=This:C1470
	
	//________________________________________________________________
Function deleteRow($row : Integer)->$this : cs:C1710.listbox
	
	LISTBOX DELETE ROWS:C914(*; This:C1470.name; $row; 1)
	
	$this:=This:C1470
	
	//________________________________________________________________
Function deleteAllRows()->$this : cs:C1710.listbox
	
	LISTBOX DELETE ROWS:C914(*; This:C1470.name; 1; This:C1470.rowsNumber())
	
	$this:=This:C1470
	
	//________________________________________________________________
Function getProperty($property : Integer)->$value : Variant
	
	$value:=LISTBOX Get property:C917(*; This:C1470.name; $property)
	
	//________________________________________________________________
Function setProperty($property : Integer; $value)->$this : cs:C1710.listbox
	
	LISTBOX SET PROPERTY:C1440(*; This:C1470.name; $property; $value)
	
	$this:=This:C1470