//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($data : Object) : Object

If ((String:C10($data.target)="android")\
 || (String:C10($data.project._buildTarget)="android")\
 || (String:C10(SHARED.buildType)="android"))
	
	return (cs:C1710.MobileProjectAndroid.new($data).main())
	
Else 
	
	return (cs:C1710.MobileProjectIOS.new($data).main())
	
End if 