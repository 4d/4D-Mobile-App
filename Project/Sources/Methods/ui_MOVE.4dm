//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ui_MOVE
  // Database: 4D Mobile Express
  // ID[89C0950E701C4181B023120633257EEC]
  // Created 11-10-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)
C_LONGINT:C283($4)

C_LONGINT:C283($Lon_alignment;$Lon_bottom;$Lon_left;$Lon_offset;$Lon_parameters;$Lon_rBottom)
C_LONGINT:C283($Lon_right;$Lon_rLeft;$Lon_rRight;$Lon_rTop;$Lon_top;$Lon_width)
C_TEXT:C284($Txt_object;$Txt_reference)

If (False:C215)
	C_TEXT:C284(ui_MOVE ;$1)
	C_TEXT:C284(ui_MOVE ;$2)
	C_LONGINT:C283(ui_MOVE ;$3)
	C_LONGINT:C283(ui_MOVE ;$4)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	  // Required parameters
	$Txt_object:=$1
	$Txt_reference:=$2
	$Lon_alignment:=$3
	
	  // Optional parameters
	If ($Lon_parameters>=4)
		
		$Lon_offset:=$4
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
OBJECT GET COORDINATES:C663(*;$Txt_reference;$Lon_rLeft;$Lon_rTop;$Lon_rRight;$Lon_rBottom)
OBJECT GET COORDINATES:C663(*;$Txt_object;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)

$Lon_width:=$Lon_right-$Lon_left

Case of 
		
		  //______________________________________________________
	: ($Lon_alignment=Align left:K42:2)
		
		$Lon_left:=$Lon_rLeft+$Lon_offset
		$Lon_right:=$Lon_left+$Lon_width
		
		  //______________________________________________________
	: ($Lon_alignment=Align right:K42:4)
		
		$Lon_right:=$Lon_rRight-$Lon_offset
		$Lon_left:=$Lon_right-$Lon_width
		
		  //______________________________________________________
	Else 
		
		  //
		
		  //______________________________________________________
End case 

OBJECT SET COORDINATES:C1248(*;$Txt_object;$Lon_left;$Lon_top;$Lon_right;$Lon_bottom)

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End