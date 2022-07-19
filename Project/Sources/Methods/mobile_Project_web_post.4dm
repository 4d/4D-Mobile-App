//%attributes = {}
#DECLARE($data : Object)

If (Not:C34(WEB Is server running:C1313))
	WEB START SERVER:C617
End if 
var $url : Text
var $response; $contents : Object
var $code : Integer

$url:="http://localhost:"+String:C10(WEB Get server info:C1531.options.webPortID)+"/4DAction/"+Formula:C1597(mobile_Project_web_receive).source

$contents:=OB Copy:C1225($data)
// remove cyclic
$contents.project.$dialog:=Null:C1517
$contents.project.$project.$dialog:=Null:C1517
// pass file path
$contents.appFolder:=String:C10($contents.appFolder.path)
$contents.project._folder:=String:C10($contents.project._folder.path)

$code:=HTTP Request:C1158(HTTP POST method:K71:2; $url; JSON Stringify:C1217($contents); $response)