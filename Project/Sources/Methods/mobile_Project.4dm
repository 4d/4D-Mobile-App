//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE ($in : Object)->$result : Object

If ((String:C10($in.project.buildTarget)="android")\
 | (String:C10(SHARED.buildType)="android"))
	
	var $mobileProjectAndroid : Object
	$mobileProjectAndroid:=cs:C1710.MobileProjectAndroid.new($in)
	
	$result:=$mobileProjectAndroid.main()
	
	//$result:=mobile_Project_android($in)
	
Else 
	
	$result:=mobile_Project_iOS($in)
	
End if 