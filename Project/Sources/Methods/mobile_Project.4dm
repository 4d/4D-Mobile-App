//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

If (False:C215)
	C_OBJECT:C1216(mobile_Project; $0)
	C_OBJECT:C1216(mobile_Project; $1)
End if 

If ((String:C10($1.buildType)="android") | (String:C10(SHARED.buildType)="android"))
	$0:=mobile_Project_android($1)
Else 
	$0:=mobile_Project_iOS($1)
End if 