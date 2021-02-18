//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($in : Object)->$result : Object

If ((String:C10($in.project._buildTarget)="android")\
 | (String:C10(SHARED.buildType)="android"))
	
	$result:=cs:C1710.MobileProjectAndroid.new($in).main()
	
Else 
	
	// iOS
	$result:=mobile_Project_iOS($in)
	
End if 