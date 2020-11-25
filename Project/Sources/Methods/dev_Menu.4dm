//%attributes = {"invisible":true}
C_OBJECT:C1216($1)

C_OBJECT:C1216($menu; $o)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(dev_Menu; $1)
End if 

$menu:=$1

$c:=New collection:C1472

$c.push(New object:C1471(\
"label"; "page_general"; \
"parameter"; "general"; \
"method"; "menu_goToPage"))

$c.push(New object:C1471(\
"label"; "page_structure"; \
"parameter"; "structure"; \
"method"; "menu_goToPage"))

$c.push(New object:C1471(\
"label"; "page_properties"; \
"parameter"; "properties"; \
"method"; "menu_goToPage"))

$c.push(New object:C1471(\
"label"; "page_main"; \
"parameter"; "main"; \
"method"; "menu_goToPage"))

$c.push(New object:C1471(\
"label"; "page_views"; \
"parameter"; "views"; \
"method"; "menu_goToPage"))

$c.push(New object:C1471(\
"label"; "page_deployment"; \
"parameter"; "deployment"; \
"method"; "menu_goToPage"))

$menu.append("Navigate"; cs:C1710.menu.new().append($c))

$o:=cs:C1710.menu.new()
$o.append("Create project without building"; "create").method("menu_product")
$o.append("Build and run"; "build").method("menu_product").disable()
$o.append("Create, build and run"; "buildAndRun").method("menu_product")
$o.append("Run only (must have been builded)"; "run").method("menu_product")
$o.line()
$o.append("Launch Last Build").method("01_LASTBUILD")
$o.line()
$o.append("Reveal in Finder"; "reveal").method("menu_product")
$o.append("Replace SDK"; "replaceSDK").method("menu_product")
$o.line()
$o.append("Generate core data model"; "xcdatamodel").method("menu_product")
$o.append("Generate data set"; "dataSet").method("menu_product")
$o.append("Generate core data set"; "coreDataSet").method("menu_product")
$menu.append("Product"; $o)

$o:=cs:C1710.menu.new()
cs:C1710.menu_component_class.new().fillMenu($o)
$menu.append("Component"; $o)

$o:=cs:C1710.menu.new()
$o.append("Close"; "close").method("menu_window")
$o.append("Minimize"; "minimize").method("menu_window")
$o.append("Maximize"; "maximize").method("menu_window")
$o.append("Centered"; "centered").method("menu_window")
$menu.append("Window"; $o)

$menu.append("DEV"; cs:C1710.menu.new()\
.append("00_TESTS"; "00_TESTS"))