//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_listbox
  // Database: 4D Mobile App
  // ID[FBE543BD1BC2456E9DC117830ADDAA1A]
  // Created #8-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Member methods for listbox widgets
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($Boo_horizontal;$Boo_vertical)
C_LONGINT:C283($i;$Lon_bottom;$Lon_column;$Lon_left;$Lon_parameters;$Lon_right)
C_LONGINT:C283($Lon_row;$Lon_top)
C_TEXT:C284($Txt_action)
C_OBJECT:C1216($Obj_out;$Obj_params)

If (False:C215)
	C_OBJECT:C1216(ui_listbox ;$0)
	C_TEXT:C284(ui_listbox ;$1)
	C_OBJECT:C1216(ui_listbox ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_action:=$1
		
		If ($Lon_parameters>=2)
			
			$Obj_params:=$2
			
		End if 
	End if 
	
	$Obj_out:=This:C1470
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (This:C1470=Null:C1517)
		
		ASSERT:C1129(False:C215;"This method must be called from an member method")
		
		  //______________________________________________________
	: (OBJECT Get type:C1300(*;String:C10(This:C1470.name))#Object type listbox:K79:8)
		
		ASSERT:C1129(False:C215;"The widget \""+String:C10(This:C1470.name)+"\" is not a listbox!")
		
		  //______________________________________________________
	: (Length:C16($Txt_action)=0)  // Definition
		
		ARRAY BOOLEAN:C223($tBoo_ColsVisible;0x0000)
		ARRAY POINTER:C280($tPtr_ColVars;0x0000)
		ARRAY POINTER:C280($tPtr_FooterVars;0x0000)
		ARRAY POINTER:C280($tPtr_HeaderVars;0x0000)
		ARRAY POINTER:C280($tPtr_Styles;0x0000)
		ARRAY TEXT:C222($tTxt_ColNames;0x0000)
		ARRAY TEXT:C222($tTxt_FooterNames;0x0000)
		ARRAY TEXT:C222($tTxt_HeaderNames;0x0000)
		
		LISTBOX GET ARRAYS:C832(*;This:C1470.name;$tTxt_ColNames;$tTxt_HeaderNames;$tPtr_ColVars;$tPtr_HeaderVars;$tBoo_ColsVisible;$tPtr_Styles;$tTxt_FooterNames;$tPtr_FooterVars)
		
		This:C1470.definition:=New collection:C1472
		
		ARRAY TO COLLECTION:C1563(This:C1470.definition;\
			$tTxt_ColNames;"names";\
			$tTxt_HeaderNames;"headers";\
			$tTxt_FooterNames;"footers")
		
		This:C1470.columns:=New object:C1471
		
		For ($i;1;Size of array:C274($tTxt_ColNames);1)
			
			This:C1470.columns[$tTxt_ColNames{$i}]:=New object:C1471(\
				"number";$i)
			
		End for 
		
		This:C1470.getScrollbar()
		
		  //______________________________________________________
	: ($Txt_action="cell")
		
		This:C1470.getCellPosition()
		This:C1470.getCellCoordinates()
		
		  //______________________________________________________
	: ($Txt_action="scrollbar")
		
		OBJECT GET SCROLLBAR:C1076(*;This:C1470.name;$Boo_horizontal;$Boo_vertical)
		
		This:C1470.scrollbar:=New object:C1471(\
			"vertical";$Boo_vertical;\
			"horizontal";$Boo_horizontal)
		
		  //______________________________________________________
	: ($Txt_action="cellPosition")
		
		LISTBOX GET CELL POSITION:C971(*;This:C1470.name;$Lon_column;$Lon_row)
		This:C1470.column:=$Lon_column
		This:C1470.row:=$Lon_row
		
		  //______________________________________________________
	: ($Txt_action="cellCoordinates")
		
		LISTBOX GET CELL COORDINATES:C1330(*;This:C1470.name;Num:C11(This:C1470.column);Num:C11(This:C1470.row);$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
		
		If (This:C1470.cellCoordinates=Null:C1517)
			
			This:C1470.cellCoordinates:=New object:C1471
			
		End if 
		
		This:C1470.cellCoordinates.left:=$Lon_left
		This:C1470.cellCoordinates.top:=$Lon_top
		This:C1470.cellCoordinates.right:=$Lon_right
		This:C1470.cellCoordinates.bottom:=$Lon_bottom
		
		  //______________________________________________________
	: ($Txt_action="property")
		
		$Obj_out:=New object:C1471(\
			"value";LISTBOX Get property:C917(*;\
			This:C1470.name;Num:C11($Obj_params.property)))
		
		  //______________________________________________________
	: ($Txt_action="popup")
		
		$Lon_left:=This:C1470.cellCoordinates.left
		$Lon_bottom:=This:C1470.cellCoordinates.bottom
		
		CONVERT COORDINATES:C1365($Lon_left;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)
		
		$Obj_out:=New object:C1471(\
			"choice";Dynamic pop up menu:C1006($Obj_params.menu;\
			"";$Lon_left;\
			$Lon_bottom))
		
		If (Not:C34(Bool:C1537($Obj_params.keep)))
			
			RELEASE MENU:C978($Obj_params.menu)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="show")
		
		LISTBOX SELECT ROW:C912(*;This:C1470.name;Num:C11($Obj_params.row);lk replace selection:K53:1)
		OBJECT SET SCROLL POSITION:C906(*;This:C1470.name;Num:C11($Obj_params.row))
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End