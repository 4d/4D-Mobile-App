//%attributes = {"publishedWeb":true}

var $jsonString : Text
WEB GET HTTP BODY:C814($jsonString)

COMPONENT_INIT

var $contents; $result : Object

$contents:=JSON Parse:C1218($jsonString)

$contents.appFolder:=Folder:C1567($contents.appFolder)
$contents.project._folder:=Folder:C1567($contents.project._folder)
$contents.project:=cs:C1710.project.new($contents.project)

$result:=mobile_Project($contents)

WEB SEND TEXT:C677(JSON Stringify:C1217($result))