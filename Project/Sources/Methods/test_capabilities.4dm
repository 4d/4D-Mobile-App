//%attributes = {"invisible":true,"preemptive":"capable"}

C_OBJECT:C1216($Obj_result;$Obj_projfile)
C_OBJECT:C1216($Folder_target;$Folder_source)

  //_____________________________________________________________
TRY 

  //_____________________________________________________________
  // Setup
$Folder_source:=Folder:C1567(fk resources folder:K87:11).folder("templates").folder("list")
$Folder_target:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).folder(Current method name:C684)
If ($Folder_target.exists)
	$Folder_target.delete(fk recursive:K87:7)
End if 
$Folder_target.create()
$Folder_source.copyTo($Folder_target)
$Folder_target:=$Folder_target.folder("list")

  //_____________________________________________________________
  // Test

  // READ
$Obj_result:=capabilities (New object:C1471("action";"read"))
ASSERT:C1129(Not:C34($Obj_result.success);"No project target defined, must not be able to read files")

$Obj_result:=capabilities (New object:C1471("action";"read";"target";$Folder_target.platformPath;"tags";New object:C1471("product";"___PRODUCT___")))
ASSERT:C1129($Obj_result.success;"Must success to read files:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is object:K8:27;"Must return an info")
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is object:K8:27;"Must return an entitlements")


  // NATIFY: simple to complex native value

$Obj_result:=capabilities (New object:C1471("action";"natify";"map";True:C214))
ASSERT:C1129($Obj_result.success;"Must success to get map capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is collection:K8:32;"Must return an info plist modification for map:"+JSON Stringify:C1217($Obj_result))

$Obj_result:=capabilities (New object:C1471("action";"natify";"home";True:C214))
ASSERT:C1129($Obj_result.success;"Must success to get home capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is collection:K8:32;"Must return an entitlements plist modification for home:"+JSON Stringify:C1217($Obj_result))

$Obj_result:=capabilities (New object:C1471("action";"natify";"home";True:C214;"map";True:C214))
ASSERT:C1129($Obj_result.success;"Must success to get home capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is collection:K8:32;"Must return an entitlements plist modification for home:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is collection:K8:32;"Must return an info plist modification for map:"+JSON Stringify:C1217($Obj_result))


  // WRITE

$Obj_projfile:=New object:C1471()

$Obj_result:=capabilities (New object:C1471("action";"inject";"target";$Folder_target.platformPath;"tags";New object:C1471("product";"___PRODUCT___");"value";$Obj_projfile))
ASSERT:C1129($Obj_result.success;"Nothing to inject"+JSON Stringify:C1217($Obj_result))


$Obj_projfile:=New object:C1471("capabilities";New object:C1471("map";True:C214;"home";True:C214);"templates";New collection:C1472(New object:C1471("capabilities";New object:C1471("contacts";True:C214))))
$Obj_result:=capabilities (New object:C1471("action";"inject";"target";$Folder_target.platformPath;"tags";New object:C1471("product";"___PRODUCT___");"value";$Obj_projfile))
ASSERT:C1129($Obj_result.success;"Nothing to inject"+JSON Stringify:C1217($Obj_result))


  //_____________________________________________________________
  // Teardown
If (Shift down:C543)
	SHOW ON DISK:C922($Folder_target.platformPath)
Else 
	$Folder_target.delete(fk recursive:K87:7)
End if 

  //_____________________________________________________________
FINALLY 