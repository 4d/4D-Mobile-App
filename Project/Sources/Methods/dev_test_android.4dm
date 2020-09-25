//%attributes = {}

var $emu : cs:C1710.androidEmulator
$emu:=cs:C1710.androidEmulator.new()

var $listOfEmu : Collection
$listOfEmu:=$emu.list().emulators

ASSERT:C1129($listOfEmu.length>0; "No emu")

var $result : Object
$result:=$emu.start($listOfEmu[0]; True:C214/*async*/)  // seem to block until close, maybe run start in background or not using option of LAUNCH Exxternal process

var $adb : cs:C1710.adb
$adb:=cs:C1710.adb.new()

$result:=$adb.kill($listOfEmu[0])  // seems to no work
$result:=$adb.killServer()  // seems to no work

var $java : cs:C1710.java
$java:=cs:C1710.java.new()

$result:=$java.version()  // return to version to err
ALERT:C41(JSON Stringify:C1217($result))
