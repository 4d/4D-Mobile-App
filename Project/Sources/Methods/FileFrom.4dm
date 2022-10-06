//%attributes = {}
#DECLARE($path : Variant)->$result : 4D:C1709.File

Case of 
	: (Value type:C1509($path)=Is text:K8:3)
		$result:=File:C1566(This:C1470.input.path; fk platform path:K87:2)
	: ((Value type:C1509(This:C1470.input.path)=Is object:K8:27) && (OB Instance of:C1731($path; 4D:C1709.File)))
		$result:=This:C1470.input.path
	Else 
		ASSERT:C1129(False:C215; "Not correct passed type to create File instance: "+String:C10(Value type:C1509($path)))
End case 