//%attributes = {"invisible":true}
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(await_MESSAGE; $0)
	C_OBJECT:C1216(await_MESSAGE; $1)
End if 

$0:=New signal:C1641

Use ($0)
	
	$0.validate:=False:C215
	
End use 

$1.signal:=$0

POST_MESSAGE($1)

$0.wait()
