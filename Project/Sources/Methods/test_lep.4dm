//%attributes = {}
var $t : Text
var $folder; $env : Object
var $lep : cs:C1710.lep

TRY

$lep:=cs:C1710.lep.new()
ASSERT:C1129($lep.success)

$env:=$lep.getEnvironnementVariables()
ASSERT:C1129($lep.success)
ASSERT:C1129(Not:C34(OB Is empty:C1297($env)))
ASSERT:C1129($env._4D_OPTION_CURRENT_DIRECTORY#Null:C1517)
ASSERT:C1129($env._4D_OPTION_HIDE_CONSOLE#Null:C1517)
ASSERT:C1129($env._4D_OPTION_BLOCKING_EXTERNAL_PROCESS#Null:C1517)
ASSERT:C1129($env.HOME#Null:C1517)
ASSERT:C1129($env.USER=Get system info:C1571.accountName)

$t:=$lep.getEnvironnementVariable("HOME")
ASSERT:C1129($lep.success)

ASSERT:C1129(""=$lep.getEnvironnementVariable("HELLO"))
ASSERT:C1129(Not:C34($lep.success))

$lep.setEnvironnementVariable("HELLO"; "WORLD")
ASSERT:C1129($lep.success)

ASSERT:C1129("WORLD"=$lep.getEnvironnementVariable("HELLO"))
ASSERT:C1129($lep.success)

ASSERT:C1129(""=$lep.getEnvironnementVariable("hello"))  // Default is diacritic
ASSERT:C1129(Not:C34($lep.success))

ASSERT:C1129("WORLD"=$lep.getEnvironnementVariable("hello"; False:C215))  // Non diacritic
ASSERT:C1129($lep.success)

$folder:=Folder:C1567(fk database folder:K87:14)
$lep.setDirectory($folder)
ASSERT:C1129($lep.success)
ASSERT:C1129($folder.platformPath=$lep.getEnvironnementVariable("currentDirectory"))
ASSERT:C1129($lep.success)
ASSERT:C1129($folder.platformPath=$lep.getEnvironnementVariable("directory"))
ASSERT:C1129($lep.success)

FINALLY

If (Structure file:C489=Structure file:C489(*))
	
	ALERT:C41("Done")
	
End if 