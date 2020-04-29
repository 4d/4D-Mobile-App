//%attributes = {"invisible":true,"preemptive":"capable"}

TRY 

  // Create from scratch
C_OBJECT:C1216($xml)
$xml:=xml ("create";New object:C1471("root";"document"))
ASSERT:C1129($xml.success)
$xml.close()

  // Create by parsing
C_OBJECT:C1216($xml)
$xml:=xml ("parse";New object:C1471("variable";"<html><header></header><body></body></html>"))
ASSERT:C1129($xml.success)
$xml.close()

  // Create from file
C_OBJECT:C1216($folder)
$folder:=Folder:C1567(fk resources folder:K87:11).folder("templates").folder("form").folder("list")
$xml:=xml ("load";$folder.file("Simple Table/Sources/Forms/Tables/___TABLE___/___TABLE___ListForm.storyboard"))
ASSERT:C1129($xml.success)

  // export to an internal variable
C_OBJECT:C1216($value)
$value:=$xml.export()
ASSERT:C1129($value.variable#Null:C1517;"Failed to export")  // Must dump data into value

  // find 
  /// find ok
C_OBJECT:C1216($scenes)
$scenes:=$xml.findByXPath("/document/scenes")
ASSERT:C1129($scenes.success;"Failed to find xml element")
ASSERT:C1129($scenes.elementRef#"00000000000000000000000000000000")
ASSERT:C1129($scenes.elementRef#Null:C1517)

$result:=$scenes.findByAttribute("userLabel";"List Form")
ASSERT:C1129(Num:C11($result.elements.length)=1)

$result:=$scenes.findByAttribute("key";"backgroundColor")
ASSERT:C1129(Num:C11($result.elements.length)=5)

$result:=$scenes.findByAttribute("key";"backgroundColor";"color")  // add name speed up because we do not consult all attribute for all node
ASSERT:C1129(Num:C11($result.elements.length)=5)

$result:=$scenes.findByAttribute("key";"backgroundColor";"scene")
ASSERT:C1129(Num:C11($result.elements.length)=0)

$result:=$scenes.findById("Dxc-Bl-At2")
ASSERT:C1129(Bool:C1537($result.success))

  /// find ko
C_OBJECT:C1216($scene)
$scene:=$xml.findByXPath("/document/scene")
ASSERT:C1129(Not:C34($scene.success);"Must failed to find invalid value")
ASSERT:C1129($scene.elementRef=Null:C1517)

  // root
ASSERT:C1129($scenes.root().elementRef=$xml.elementRef;"Failed to get root of dom element")

  // browsing
C_OBJECT:C1216($element;$result)
$result:=$scenes.findByName("scene")
ASSERT:C1129(Num:C11($result.elements.length)=3)

$result:=$xml.findMany("/document/scenes/scene")
ASSERT:C1129(Num:C11($result.elements.length)=3)

  // findOrCreate
C_OBJECT:C1216($parent)
$parent:=$result.elements[0]  // /!\ need result from findMany
$result:=$parent.findOrCreate("eric")
ASSERT:C1129($result.elementRef=$parent.findOrCreate("eric").elementRef;"Must not recreate a new node with findOrCreate")

  // parentWithName
  // one level
C_OBJECT:C1216($parentWithName)
$parentWithName:=$result.parentWithName("scene")
ASSERT:C1129($parentWithName.success)
ASSERT:C1129($parentWithName.elementRef=$parent.elementRef)
  // two levels (recursive)
$parentWithName:=$result.parentWithName("scenes")
ASSERT:C1129($parentWithName.success)
ASSERT:C1129($parentWithName.elementRef=$parent.parent().elementRef)
  //not found
$parentWithName:=$result.parentWithName("unavailable")
ASSERT:C1129(Not:C34($parentWithName.success))

  // children
C_OBJECT:C1216($children)
$children:=$scenes.children()
ASSERT:C1129($children.success;"Failed to get xml children")
ASSERT:C1129($children.elements.length=3;"Incorrect number of children for xml node. Expected 3 but receive "+String:C10($children.elements.length))

$children:=$scenes.children(True:C214)
ASSERT:C1129($children.success;"Failed to get xml children recursively")
ASSERT:C1129($children.elements.length=108;"Incorrect number of children for xml node. Expected 108 but receive "+String:C10($children.elements.length))

  // final close
$xml.close()


FINALLY 