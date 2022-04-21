//%attributes = {"invisible":true}
#DECLARE($menu : cs:C1710.menu)

If (False:C215)
	C_OBJECT:C1216(dev_Menu; $1)
End if 

var $c : Collection
var $o : cs:C1710.menu

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
$o.append("🍏 Create project without building"; "createiOS").method(Formula:C1597(menu_product).source)
$o.append("🍏 Build and run"; "build").method(Formula:C1597(menu_product).source).disable()
$o.append("🍏 Create, build and run"; "buildAndRun").method(Formula:C1597(menu_product).source)
$o.append("🍏 Run only (must have been builded)"; "run").method(Formula:C1597(menu_product).source)
$o.line()
$o.append("🍏 Launch Last Build").method(Formula:C1597(01_LASTBUILD).source)
$o.line()
$o.append("🤖 Create project without building"; "createandroid").method(Formula:C1597(menu_product).source)
$o.line()
$o.append("Reveal in Finder"; "reveal").method(Formula:C1597(menu_product).source)
$o.append("Replace SDK"; "replaceSDK").method(Formula:C1597(menu_product).source)
$o.line()
$o.append("Generate core data model"; "xcdatamodel").method(Formula:C1597(menu_product).source).shortcut(New object:C1471("key"; "E"; "modifier"; Command key mask:K16:1))
$o.append("Generate data set"; "dataSet").method(Formula:C1597(menu_product).source)
$o.append("Generate core data set"; "coreDataSet").method(Formula:C1597(menu_product).source)
$menu.append("Product"; $o)

$o:=cs:C1710.menu.new()
cs:C1710.menu_component_class.new().fillMenu($o)
$menu.append("Component"; $o)

$o:=cs:C1710.menu.new()
$o.append("Close"; "close").method(Formula:C1597(menu_window).source)
$o.append("Minimize"; "minimize").method(Formula:C1597(menu_window).source)
$o.append("Maximize"; "maximize").method(Formula:C1597(menu_window).source)
$o.append("Centered"; "centered").method(Formula:C1597(menu_window).source)
$menu.append("Window"; $o)

$menu.append("DEV"; cs:C1710.menu.new()\
.append("00_TESTS"; Formula:C1597(00_TESTS).source))