//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : mnu_defaultBar
  // Database: 4D Mobile App
  // ID[37E7CD9FBD464C9295C8DE97C6392851]
  // Created #18-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Mnu_bar;$t)

If (False:C215)
	C_TEXT:C284(mnu_defaultBar ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Mnu_bar:=Create menu:C408
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
  // FILE
  // ----------------------------------------------------
$t:=Create menu:C408

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemQuit")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak quit:K76:61)
SET MENU ITEM SHORTCUT:C423($t;-1;"Q";Command key mask:K16:1)

APPEND MENU ITEM:C411($Mnu_bar;":xliff:CommonMenuFile";$t)
RELEASE MENU:C978($t)


  // ----------------------------------------------------
  // EDIT
  // ----------------------------------------------------
$t:=Create menu:C408

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemUndo")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak undo:K76:51)
SET MENU ITEM SHORTCUT:C423($t;-1;"Z";Command key mask:K16:1)

APPEND MENU ITEM:C411($t;":xliff:CommonMenuRedo")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak redo:K76:52)
SET MENU ITEM SHORTCUT:C423($t;-1;"Z";Shift key mask:K16:3)

APPEND MENU ITEM:C411($t;"-")

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemCut")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak cut:K76:53)
SET MENU ITEM SHORTCUT:C423($t;-1;"X";Command key mask:K16:1)

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemCopy")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak copy:K76:54)
SET MENU ITEM SHORTCUT:C423($t;-1;"C";Command key mask:K16:1)

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemPaste")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak paste:K76:55)
SET MENU ITEM SHORTCUT:C423($t;-1;"V";Command key mask:K16:1)

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemClear")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak clear:K76:56)

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemSelectAll")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak select all:K76:57)
SET MENU ITEM SHORTCUT:C423($t;-1;"A";Command key mask:K16:1)

APPEND MENU ITEM:C411($t;"(-")

APPEND MENU ITEM:C411($t;":xliff:CommonMenuItemShowClipboard")
SET MENU ITEM PROPERTY:C973($t;-1;Associated standard action:K28:8;ak show clipboard:K76:58)

APPEND MENU ITEM:C411($Mnu_bar;":xliff:CommonMenuEdit";$t)
RELEASE MENU:C978($t)

  // ----------------------------------------------------
  // Return
$0:=$Mnu_bar

  // ----------------------------------------------------
  // End