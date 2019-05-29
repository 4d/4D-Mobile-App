//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_listboxPopUp
  // Database: 4D Mobile App
  // ID[1ED8CFA6205545E69F146592DD632D76]
  // Created #12-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // 
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)
C_LONGINT:C283($4)

C_LONGINT:C283($Lon_bottom;$Lon_column;$Lon_left;$Lon_parameters;$Lon_right;$Lon_row)
C_LONGINT:C283($Lon_top)
C_TEXT:C284($Mnu_choice;$Mnu_pop;$Txt_name)

If (False:C215)
	C_TEXT:C284(ui_listboxPopUp ;$0)
	C_TEXT:C284(ui_listboxPopUp ;$1)
	C_TEXT:C284(ui_listboxPopUp ;$2)
	C_LONGINT:C283(ui_listboxPopUp ;$3)
	C_LONGINT:C283(ui_listboxPopUp ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Txt_name:=$1  // listbox widget name
	$Mnu_pop:=$2  // menu reference
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Lon_column:=$3
		$Lon_row:=$4
		
	Else 
		
		LISTBOX GET CELL POSITION:C971(*;$Txt_name;$Lon_column;$Lon_row)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
LISTBOX GET CELL COORDINATES:C1330(*;$Txt_name;$Lon_column;$Lon_row;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)
CONVERT COORDINATES:C1365($Lon_left;$Lon_bottom;XY Current form:K27:5;XY Current window:K27:6)

$Mnu_choice:=Dynamic pop up menu:C1006($Mnu_pop;"";$Lon_left;$Lon_bottom)
RELEASE MENU:C978($Mnu_pop)

  // ----------------------------------------------------
  // Return
$0:=$Mnu_choice

  // ----------------------------------------------------
  // End