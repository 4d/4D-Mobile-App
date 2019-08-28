//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : editor_ui_LISTBOX
  // Database: 4D Mobile Express
  // ID[D73060B901234F998F527281594EC7B5]
  // Created 22-12-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($1)
C_BOOLEAN:C305($2)

C_BOOLEAN:C305($Boo_withFocus)
C_LONGINT:C283($i;$Lon_backgroundColor;$Lon_parameters)
C_POINTER:C301($Ptr_me)
C_TEXT:C284($Txt_listbox)

If (False:C215)
	C_TEXT:C284(editor_ui_LISTBOX ;$1)
	C_BOOLEAN:C305(editor_ui_LISTBOX ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_listbox:=$1
	
	$Ptr_me:=OBJECT Get pointer:C1124(Object named:K67:5;$Txt_listbox)
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Boo_withFocus:=$2
		
	Else 
		
		$Boo_withFocus:=(OBJECT Get pointer:C1124(Object with focus:K67:3)=$Ptr_me)
		
	End if 
	
	$Lon_backgroundColor:=Choose:C955($Boo_withFocus;ui.highlightColor;ui.highlightColorNoFocus)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // WARNING: This method can't apply to a selection or collection listbox

OBJECT SET RGB COLORS:C628(*;$Txt_listbox;Foreground color:K23:1)

OBJECT SET RGB COLORS:C628(*;$Txt_listbox+".border";Choose:C955($Boo_withFocus;ui.selectedColor;ui.backgroundUnselectedColor))

For ($i;1;LISTBOX Get number of rows:C915(*;$Txt_listbox);1)
	
	If ($Ptr_me->{$i})
		
		LISTBOX SET ROW COLOR:C1270(*;$Txt_listbox;$i;Choose:C955($Boo_withFocus;ui.backgroundSelectedColor;ui.alternateSelectedColor);lk background color:K53:25)
		
	Else 
		
		LISTBOX SET ROW COLOR:C1270(*;$Txt_listbox;$i;$Lon_backgroundColor;lk background color:K53:25)
		
	End if 
End for 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End