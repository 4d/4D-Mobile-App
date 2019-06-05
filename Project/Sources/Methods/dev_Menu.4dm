//%attributes = {"invisible":true}
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_pageNumber)
C_TEXT:C284($Mnu_bar;$Mnu_dev;$Mnu_method;$Mnu_navigate;$Mnu_product;$Mnu_window)

If (False:C215)
	C_TEXT:C284(dev_Menu ;$1)
End if 

$Mnu_bar:=$1

$Mnu_navigate:=Create menu:C408

$Lon_pageNumber:=6  // TODO Factorize menu declaraton
ARRAY TEXT:C222($tTxt_pages;$Lon_pageNumber)
$tTxt_pages{1}:="general"
$tTxt_pages{2}:="structure"
$tTxt_pages{3}:="properties"
$tTxt_pages{4}:="main"
$tTxt_pages{5}:="views"
$tTxt_pages{6}:="deployment"

For ($Lon_i;1;$Lon_pageNumber;1)
	
	APPEND MENU ITEM:C411($Mnu_navigate;":xliff:page_"+$tTxt_pages{$Lon_i})
	SET MENU ITEM METHOD:C982($Mnu_navigate;-1;"menu_goToPage")
	SET MENU ITEM PARAMETER:C1004($Mnu_navigate;-1;$tTxt_pages{$Lon_i})
	
End for 

APPEND MENU ITEM:C411($Mnu_bar;"Navigate";$Mnu_navigate)
RELEASE MENU:C978($Mnu_navigate)

$Mnu_product:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_product;"Create project without building")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"menu_product")
SET MENU ITEM PARAMETER:C1004($Mnu_product;-1;"create")

APPEND MENU ITEM:C411($Mnu_product;"Build and run (")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"menu_product")
SET MENU ITEM PARAMETER:C1004($Mnu_product;-1;"build")

APPEND MENU ITEM:C411($Mnu_product;"Create, build and run")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"menu_product")
SET MENU ITEM PARAMETER:C1004($Mnu_product;-1;"buildAndRun")

APPEND MENU ITEM:C411($Mnu_product;"Run only (must have been builded)")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"menu_product")
SET MENU ITEM PARAMETER:C1004($Mnu_product;-1;"run")

APPEND MENU ITEM:C411($Mnu_product;"(-")

APPEND MENU ITEM:C411($Mnu_product;"Launch Last Build")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"01_LASTBUILD")

APPEND MENU ITEM:C411($Mnu_product;"(-")

APPEND MENU ITEM:C411($Mnu_product;"Reveal in Finder")
SET MENU ITEM METHOD:C982($Mnu_product;-1;"menu_product")
SET MENU ITEM PARAMETER:C1004($Mnu_product;-1;"reveal")

APPEND MENU ITEM:C411($Mnu_bar;"Product";$Mnu_product)
RELEASE MENU:C978($Mnu_product)

$Mnu_window:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_window;"Close")
SET MENU ITEM METHOD:C982($Mnu_window;-1;"menu_window")
SET MENU ITEM PARAMETER:C1004($Mnu_window;-1;"close")

APPEND MENU ITEM:C411($Mnu_window;"Minimize")
SET MENU ITEM METHOD:C982($Mnu_window;-1;"menu_window")
SET MENU ITEM PARAMETER:C1004($Mnu_window;-1;"minimize")

APPEND MENU ITEM:C411($Mnu_window;"Maximize")
SET MENU ITEM METHOD:C982($Mnu_window;-1;"menu_window")
SET MENU ITEM PARAMETER:C1004($Mnu_window;-1;"maximize")

APPEND MENU ITEM:C411($Mnu_window;"Centered")
SET MENU ITEM METHOD:C982($Mnu_window;-1;"menu_window")
SET MENU ITEM PARAMETER:C1004($Mnu_window;-1;"centered")

APPEND MENU ITEM:C411($Mnu_bar;"Window";$Mnu_window)
RELEASE MENU:C978($Mnu_window)

$Mnu_dev:=Create menu:C408

APPEND MENU ITEM:C411($Mnu_dev;"00_TESTS")
SET MENU ITEM METHOD:C982($Mnu_dev;-1;"00_TESTS")

APPEND MENU ITEM:C411($Mnu_dev;"(-")

APPEND MENU ITEM:C411($Mnu_dev;"Build component")
SET MENU ITEM METHOD:C982($Mnu_dev;-1;"menu_component")
SET MENU ITEM PARAMETER:C1004($Mnu_dev;-1;"build")

APPEND MENU ITEM:C411($Mnu_dev;"Increment build component")
SET MENU ITEM METHOD:C982($Mnu_dev;-1;"menu_component")
SET MENU ITEM PARAMETER:C1004($Mnu_dev;-1;"increment")

APPEND MENU ITEM:C411($Mnu_dev;"Deploy component")
SET MENU ITEM METHOD:C982($Mnu_dev;-1;"menu_component")
SET MENU ITEM PARAMETER:C1004($Mnu_dev;-1;"deploy")

APPEND MENU ITEM:C411($Mnu_dev;"(-")

If (env_userPathname ("home").file(".p4settings").exists)
	
	APPEND MENU ITEM:C411($Mnu_dev;"P4 component")
	SET MENU ITEM METHOD:C982($Mnu_dev;-1;"menu_component")
	SET MENU ITEM PARAMETER:C1004($Mnu_dev;-1;"p4")
	
End if 

APPEND MENU ITEM:C411($Mnu_dev;"(-")
APPEND MENU ITEM:C411($Mnu_dev;"Update SDK")
SET MENU ITEM METHOD:C982($Mnu_dev;-1;"menu_component")
SET MENU ITEM PARAMETER:C1004($Mnu_dev;-1;"updateSDK")

APPEND MENU ITEM:C411($Mnu_bar;"Dev";$Mnu_dev)
RELEASE MENU:C978($Mnu_dev)