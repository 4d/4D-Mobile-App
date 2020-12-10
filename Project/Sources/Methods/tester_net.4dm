//%attributes = {}
var $result : Object

$result:=net(New object:C1471("action"; "resolve"; "url"; "fr.wikipedia.org"))

If ($result.success)
	
	$result.ping:=net(New object:C1471("action"; "ping"; "url"; $result.ip))
	
End if 

$result:=net(New object:C1471("action"; "ping"; "url"; "127.0.0.1:8880"))

$result:=net(New object:C1471("action"; "ping"; "url"; "localhost"))
$result:=net(New object:C1471("action"; "resolve"; "url"; "localhost"))

//$Obj_result.ping:=server (New object("action";"ping";"url";"www.fr.wikipedia.org"))
//$Obj_result.ping:=server (New object("action";"ping";"url";"http://www.fr.wikipedia.org:80/"))
$result.ping:=net(New object:C1471("action"; "ping"; "url"; "testbugs.4d.fr"))