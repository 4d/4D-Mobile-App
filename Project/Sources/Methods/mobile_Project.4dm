//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($data : Object)->$result : Object

If ((String:C10($data.project._buildTarget)="android")\
 | (String:C10(SHARED.buildType)="android"))
	
	$result:=cs:C1710.MobileProjectAndroid.new($data).main()
	
Else 
	
	// iOS
	$result:=mobile_Project_iOS($data)
	
End if 