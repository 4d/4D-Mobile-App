//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($data : Object) : Object

If ((String:C10($data.project._buildTarget)="android")\
 || (String:C10(SHARED.buildType)="android"))
	
	return (cs:C1710.MobileProjectAndroid.new($data).main())
	
Else 
	
	If (Bool:C1537(FEATURE.with("iosBuildWithClass")))
		
		return (cs:C1710.MobileProjectIOS.new($data).main())
		
	Else 
		
		return (_o_mobile_Project_iOS($data))
		
	End if 
End if 