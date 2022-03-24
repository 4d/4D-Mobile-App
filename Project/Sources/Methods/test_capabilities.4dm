//%attributes = {"invisible":true,"preemptive":"capable"}

C_OBJECT:C1216($Obj_result; $Obj_projfile)
C_OBJECT:C1216($Folder_target; $Folder_source)

C_BOOLEAN:C305($Bool_shiftDown)
$Bool_shiftDown:=Shift down:C543

//_____________________________________________________________
If (Not:C34($Bool_shiftDown))
	err_TRY
End if 

//_____________________________________________________________
// Setup
$Folder_source:=Folder:C1567(fk resources folder:K87:11).folder("templates").folder("list")
$Folder_target:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Current method name:C684)
If ($Folder_target.exists)
	$Folder_target.delete(fk recursive:K87:7)
End if 
$Folder_target.create()
$Folder_source.copyTo($Folder_target)
$Folder_target:=$Folder_target.folder("list")

// For test purpose, must have a real between <real></real> tags, etc.
C_TEXT:C284($settingsContent; $settingsFilePath)
$settingsFilePath:=$Folder_target.platformPath+Convert path POSIX to system:C1107("Settings/Settings.plist")
//$settingsContent:=Document to text($settingsFilePath)
$settingsContent:=File:C1566($settingsFilePath; fk platform path:K87:2).getText()

$settingsContent:=Replace string:C233($settingsContent; "___SERVER_PORT___"; "80")
$settingsContent:=Replace string:C233($settingsContent; "___SERVER_HTTPS_PORT___"; "443")
$settingsContent:=Replace string:C233($settingsContent; "___SERVER_AUTHENTIFICATION_EMAIL___"; "false")
$settingsContent:=Replace string:C233($settingsContent; "___SERVER_AUTHENTIFICATION_RELOAD_DATA___"; "false")
$settingsContent:=Replace string:C233($settingsContent; "___HAS_ACTION___"; "false")
//TEXT TO DOCUMENT($settingsFilePath; $settingsContent)
File:C1566($settingsFilePath; fk platform path:K87:2).setText($settingsContent)

//_____________________________________________________________
// Test

// READ
$Obj_result:=capabilities(New object:C1471("action"; "read"))
ASSERT:C1129(Not:C34($Obj_result.success); "No project target defined, must not be able to read files")

$Obj_result:=capabilities(New object:C1471("action"; "read"; "target"; $Folder_target.platformPath; "tags"; New object:C1471("product"; "___PRODUCT___")))
ASSERT:C1129($Obj_result.success; "Must success to read files:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is object:K8:27; "Must return an info")
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is object:K8:27; "Must return an entitlements")


// NATIFY: simple to complex native value

$Obj_result:=capabilities(New object:C1471("action"; "natify"; "map"; True:C214))
ASSERT:C1129($Obj_result.success; "Must success to get map capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is collection:K8:32; "Must return an info plist modification for map:"+JSON Stringify:C1217($Obj_result))

$Obj_result:=capabilities(New object:C1471("action"; "natify"; "home"; True:C214))
ASSERT:C1129($Obj_result.success; "Must success to get home capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is collection:K8:32; "Must return an entitlements plist modification for home:"+JSON Stringify:C1217($Obj_result))

$Obj_result:=capabilities(New object:C1471("action"; "natify"; "home"; True:C214; "map"; True:C214))
ASSERT:C1129($Obj_result.success; "Must success to get home capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is collection:K8:32; "Must return an entitlements plist modification for home:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.info)=Is collection:K8:32; "Must return an info plist modification for map:"+JSON Stringify:C1217($Obj_result))

$Obj_result:=capabilities(New object:C1471("action"; "natify"; "signInWithOS"; True:C214))
ASSERT:C1129($Obj_result.success; "Must success to get signInWithOS capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements)=Is collection:K8:32; "Must return an entitlements plist modification for signInWithOS:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.entitlements[0])=Is object:K8:27; "Must return an entitlements plist modification for signInWithOS:"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.info.length=0; "Must found nothing")

$Obj_result:=capabilities(New object:C1471("action"; "natify"; "service"; "MyService"))
ASSERT:C1129($Obj_result.success; "Must success to get map capabilities"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129(Value type:C1509($Obj_result.settings)=Is collection:K8:32; "Must return an setting plist modification for service:"+JSON Stringify:C1217($Obj_result))
If (Value type:C1509($Obj_result.settings)=Is collection:K8:32)
	ASSERT:C1129(Value type:C1509($Obj_result.settings[0]["application.services"])=Is collection:K8:32; "Must return an setting plist with service modification for service:"+JSON Stringify:C1217($Obj_result))
End if 

// WRITE

$Obj_projfile:=New object:C1471()

$Obj_result:=capabilities(New object:C1471("action"; "inject"; "target"; $Folder_target.platformPath; "tags"; New object:C1471("product"; "___PRODUCT___"); "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))

$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("map"; True:C214; "home"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214))))
$Obj_result:=capabilities(New object:C1471("action"; "inject"; "target"; $Folder_target.platformPath; "tags"; New object:C1471("product"; "___PRODUCT___"); "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))

$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("signInWithOS"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214))))
$Obj_result:=capabilities(New object:C1471("action"; "inject"; "target"; $Folder_target.platformPath; "tags"; New object:C1471("product"; "___PRODUCT___"); "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))

$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("signInWithOS"; True:C214; "settings"; New object:C1471("application.services"; New collection:C1472("SignInWithAppleCredentialStateService"))))
$Obj_result:=capabilities(New object:C1471("action"; "inject"; "target"; $Folder_target.platformPath; "tags"; New object:C1471("product"; "___PRODUCT___"); "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))

// FIND

C_LONGINT:C283($nbCapabilities)

$Obj_projfile:=New object:C1471()

$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129(Not:C34($Obj_result.success); "Must found nothing "+JSON Stringify:C1217($Obj_result))
If (Value type:C1509($Obj_result.capabilities)=Is collection:K8:32)
	ASSERT:C1129($Obj_result.capabilities.length=0; "Must found nothing")
End if 


$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("map"; True:C214; "home"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214))))
$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.capabilities.length=2; "Must found all capabilities")  // capabilities + templates.capabilities
$nbCapabilities:=0
C_OBJECT:C1216($capabilities)
For each ($capabilities; $Obj_result.capabilities)
	ARRAY TEXT:C222($arrProperties; 0)
	OB GET PROPERTY NAMES:C1232($capabilities; $arrProperties)
	$nbCapabilities:=$nbCapabilities+Size of array:C274($arrProperties)
End for each 
ASSERT:C1129($nbCapabilities=3; "Must found all capabilities")  // map + home + contacts


$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("map"; True:C214; "home"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214)); New object:C1471("capabilities"; New object:C1471("signInWithOS"; True:C214))))
$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.capabilities.length=3; "Must found all capabilities")  // capabilities + templates.capabilities + template.capabilities
$nbCapabilities:=0
For each ($capabilities; $Obj_result.capabilities)
	ARRAY TEXT:C222($arrProperties; 0)
	OB GET PROPERTY NAMES:C1232($capabilities; $arrProperties)
	$nbCapabilities:=$nbCapabilities+Size of array:C274($arrProperties)
End for each 
ASSERT:C1129($nbCapabilities=4; "Must found all capabilities")  // map + home + contacts + signInWithOS


$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("map"; True:C214; "home"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214))); "newobject"; New object:C1471("capabilities"; New object:C1471("signInWithOS"; True:C214; "settings"; New object:C1471("application.services"; New collection:C1472("SignInWithAppleCredentialStateService")))))
$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.capabilities.length=3; "Must found all capabilities")  // capabilities + templates.capabilities + newobject
$nbCapabilities:=0
For each ($capabilities; $Obj_result.capabilities)
	ARRAY TEXT:C222($arrProperties; 0)
	OB GET PROPERTY NAMES:C1232($capabilities; $arrProperties)
	$nbCapabilities:=$nbCapabilities+Size of array:C274($arrProperties)
End for each 
ASSERT:C1129($nbCapabilities=5; "Must found all capabilities")  // map + home + contacts + signInWithOS + settings


$Obj_projfile:=New object:C1471("capabilities"; New object:C1471("map"; True:C214; "home"; True:C214); "templates"; New collection:C1472(New object:C1471("capabilities"; New object:C1471("contacts"; True:C214)); New object:C1471("capabilities"; New object:C1471("signInWithOS"; True:C214))))
$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to inject"+JSON Stringify:C1217($Obj_result))
ASSERT:C1129($Obj_result.capabilities.length=3; "Must found all capabilities")  // capabilities + templates.capabilities + template.capabilities


$Obj_projfile.actions:=New collection:C1472(\
New object:C1471(\
"name"; "action_1"; "scope"; "table"; "shortLabel"; "action_1"; "label"; "action_1"; "$icon"; "[object Picture]"; "tableNumber"; 5; "icon"; "actions 2/Locate-map.svg"); \
New object:C1471(\
"icon"; "actions/Edit.svg"; "$icon"; "[object Picture]"; "tableNumber"; 5; "scope"; "currentRecord"; "name"; "editAllTypes"; "shortLabel"; "Edit…"; "label"; "Edit…"; "parameters"; \
New collection:C1472(\
New object:C1471(\
"fieldNumber"; 1; "name"; "iD"; "label"; "Id"; "shortLabel"; "Id"; "type"; "number"; "defaultField"; "iD"); \
New object:C1471(\
"fieldNumber"; 2; "name"; "alphaField"; "label"; "Alpha Field"; "shortLabel"; "Alpha Field"; "type"; "string"; "defaultField"; "alphaField"); \
New object:C1471(\
"fieldNumber"; 3; "name"; "textField"; "label"; "Text Field"; "shortLabel"; "Text Field"; "type"; "string"; "defaultField"; "textField"); \
New object:C1471(\
"fieldNumber"; 4; "name"; "dateField"; "label"; "Date Field"; "shortLabel"; "Date Field"; "type"; "date"; "defaultField"; "dateField"; "format"; "dateShort"); \
New object:C1471(\
"fieldNumber"; 5; "name"; "timeField"; "label"; "Time Field"; "shortLabel"; "Time Field"; "type"; "time"; "defaultField"; "timeField"; "format"; "hour"); \
New object:C1471(\
"fieldNumber"; 6; "name"; "booleanField"; "label"; "Boolean Field"; "shortLabel"; "Boolean Field"; "type"; "bool"; "defaultField"; "booleanField"); \
New object:C1471(\
"fieldNumber"; 7; "name"; "integerField"; "label"; "Integer Field"; "shortLabel"; "Integer Field"; "type"; "number"; "defaultField"; "integerField"); \
New object:C1471(\
"fieldNumber"; 8; "name"; "longIntegerField"; "label"; "Long Integer Field"; "shortLabel"; "Long Integer Field"; "type"; "number"; "defaultField"; "longIntegerField"); \
New object:C1471(\
"fieldNumber"; 9; "name"; "integer64BitsField"; "label"; "Integer 64 Bits Field"; "shortLabel"; "Integer 64 Bits Field"; "type"; "number"; "defaultField"; "integer64BitsField"); \
New object:C1471(\
"fieldNumber"; 10; "name"; "realField"; "label"; "Real Field"; "shortLabel"; "Real Field"; "type"; "number"; "defaultField"; "realField"); \
New object:C1471(\
"fieldNumber"; 11; "name"; "floatField"; "label"; "Float Field"; "shortLabel"; "Float Field"; "type"; "number"; "defaultField"; "floatField"); \
New object:C1471(\
"fieldNumber"; 13; "name"; "pictureField"; "label"; "Picture Field"; "shortLabel"; "Picture Field"; "type"; "image"; "capabilities"; New object:C1471("photo"; True:C214); "defaultField"; "pictureField"))))

$Obj_result:=capabilities(New object:C1471("action"; "find"; "value"; $Obj_projfile))
ASSERT:C1129($Obj_result.success; "Nothing to found inject"+JSON Stringify:C1217($Obj_result))

ASSERT:C1129($Obj_result.capabilities.length=4; "Must found all capabilities")  // capabilities + templates

// natify found objects
For each ($Obj_projfile; $Obj_result.capabilities)
	$Obj_result:=capabilities(New object:C1471("action"; "natify"; "value"; $Obj_projfile))
	ASSERT:C1129($Obj_result.success; "Must success to get map capabilities"+JSON Stringify:C1217($Obj_result))
	ASSERT:C1129(Value type:C1509($Obj_result.info)=Is collection:K8:32; "Must return an info plist modification for map:"+JSON Stringify:C1217($Obj_result))
End for each 
//_____________________________________________________________
// Teardown
If ($Bool_shiftDown)
	SHOW ON DISK:C922($Folder_target.platformPath)
Else 
	$Folder_target.delete(fk recursive:K87:7)
End if 

//_____________________________________________________________
If (Not:C34($Bool_shiftDown))
	err_FINALLY
End if 

