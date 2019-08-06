//%attributes = {"invisible":true,"preemptive":"capable"}

TRY 

  // Create from scratch
C_OBJECT:C1216($xml)
$xml:=xml ("create";New object:C1471("root";"document"))
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
$scenes:=$xml.find("/document/scenes")
ASSERT:C1129($scenes.success;"Failed to find xml element")
ASSERT:C1129($scenes.elementRef#"00000000000000000000000000000000")
ASSERT:C1129($scenes.elementRef#Null:C1517)
  /// find ko
C_OBJECT:C1216($scene)
$scene:=$xml.find("/document/scene")
ASSERT:C1129(Not:C34($scene.success);"Must failed to find invalid value")
ASSERT:C1129($scene.elementRef=Null:C1517)

  // root
ASSERT:C1129($scenes.root().elementRef=$xml.elementRef;"Failed to get root of dom element")

$xml.close()


FINALLY 