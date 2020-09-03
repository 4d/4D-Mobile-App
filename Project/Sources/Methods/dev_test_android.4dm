//%attributes = {}

var $emu : Object
$emu:=cs:C1710.androidEmulator.new()

var $listOfEmu : Collection
$listOfEmu:=$emu.list().emulators

ASSERT:C1129($listOfEmu.length>0; "No emu")

$emu.start($listOfEmu[0])  // seem to block until close, maybe run start in background or not using option of LAUNCH Exxternal process


var $adb : Object
$adb:=cs:C1710.adb.new()

$adb.killserver()