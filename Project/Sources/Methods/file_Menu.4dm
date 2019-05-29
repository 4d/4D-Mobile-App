//%attributes = {"invisible":true}
C_TEXT:C284($1)

C_TEXT:C284($Mnu_bar;$Mnu_file;$Mnu_project)
C_OBJECT:C1216($o)

ARRAY TEXT:C222($tTxt_items;0)
ARRAY TEXT:C222($tTxt_ref;0)

If (False:C215)
	C_TEXT:C284(file_Menu ;$1)
End if 

$Mnu_bar:=$1

$Mnu_project:=Create menu:C408

For each ($o;Folder:C1567("/PACKAGE/Mobile Projects").folders())
	
	If ($o.files().query("name = 'project'").length=1)
		
		APPEND MENU ITEM:C411($Mnu_project;String:C10($o.name))
		SET MENU ITEM METHOD:C982($Mnu_project;-1;"menu_file")
		SET MENU ITEM PARAMETER:C1004($Mnu_project;-1;$o.platformPath)
		
	End if 
End for each 

GET MENU ITEMS:C977($Mnu_bar;$tTxt_items;$tTxt_ref)
$Mnu_file:=$tTxt_ref{1}

APPEND MENU ITEM:C411($Mnu_file;"Open";$Mnu_project)

APPEND MENU ITEM:C411($Mnu_file;"New…")
SET MENU ITEM METHOD:C982($Mnu_file;-1;"C_NEW_MOBILE_PROJECT")
SET MENU ITEM PARAMETER:C1004($Mnu_file;-1;"new")
SET MENU ITEM SHORTCUT:C423($Mnu_file;-1;"N";Command key mask:K16:1)

APPEND MENU ITEM:C411($Mnu_file;"-")

APPEND MENU ITEM:C411($Mnu_file;"Close")
SET MENU ITEM METHOD:C982($Mnu_file;-1;"menu_window")
SET MENU ITEM PARAMETER:C1004($Mnu_file;-1;"close")
SET MENU ITEM SHORTCUT:C423($Mnu_file;-1;"W";Command key mask:K16:1)