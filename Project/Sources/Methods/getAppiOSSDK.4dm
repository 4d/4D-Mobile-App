//%attributes = {"invisible":true,"preemptive":"capable"}
// each night SDK is builded and injected to 4D
// SDK in resource control is not the latest one (only sources are because source control are not for binary)
// so here to test we could copy latest one from 4D app

var $app : 4D:C1709.Folder
$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)

var $sdk : 4D:C1709.File
$sdk:=$app.file("Contents/Resources/Internal User Components/4D Mobile App.4dbase/Resources/sdk/Versions/1.0.zip")

var $component : 4D:C1709.Folder
$component:=Folder:C1567(fk resources folder:K87:11).folder("sdk/Versions")

// Do the job
var $result : 4D:C1709.File
$result:=$sdk.copyTo($component; fk overwrite:K87:5)

SHOW ON DISK:C922($result.platformPath)