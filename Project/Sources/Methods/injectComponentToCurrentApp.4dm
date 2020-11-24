//%attributes = {"invisible":true,"preemptive":"capable"}
// sometime you want to debug other 4d database mobile app
// and want to use TRACE or debug
// so replace into current 4d app the 4d mobile app by this one to debug

var $app : 4D:C1709.Folder
$app:=Folder:C1567(Application file:C491; fk platform path:K87:2)

var $appComponent : 4D:C1709.Folder
$appComponent:=$app.folder("Contents/Resources/Internal User Components/4D Mobile App.4dbase/")

If ($appComponent.exists)
	$appComponent.delete(Delete with contents:K24:24)
End if 

var $result : 4D:C1709.Folder
$result:=Folder:C1567(fk database folder:K87:14).copyTo($appComponent.parent; "4D Mobile App.4dbase")

SHOW ON DISK:C922($result.platformPath)
