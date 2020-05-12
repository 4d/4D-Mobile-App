Class constructor
	
	COMPONENT_INIT 
	
	This:C1470.component:=SHARED.component
	This:C1470.requirement:=New object:C1471(\
		"xCodeVersion";SHARED.xCodeVersion;\
		"iosDeploymentTarget";SHARED.iosDeploymentTarget)
	This:C1470.targetedDeviceFamily:=SHARED.targetedDeviceFamily
	This:C1470.simulatorTimeout:=SHARED.simulatorTimeout
	
Function testSuite
	
	var $0;lastError : Object
	
	$0:=New object:C1471(\
		"errors";Formula:C1597(lastError);\
		"tests";New collection:C1472)
	
	var $o : Object
	$o:=New signal:C1641
	
	CALL WORKER:C1389(1;"unitTestSuites";$o)
	
	If ($o.wait(10))
		
		var $t : Text
		
		For each ($t;$o.result)
			
			$0.tests.push(Formula from string:C1601($t))
			
		End for each 
		
		$0.success:=($0.tests.length>0)
		
	Else 
		
		ASSERT:C1129(False:C215;"Failed to load internal test methods")
		
	End if 
	
	  //______________________________________________________
Function _parameters
	
	var $0 : Boolean
	var $1;$2 : Integer
	
	$0:=$2>$2
	
	  //______________________________________________________
Function featuresFlags
	
	var $0 : Object
	$0:=feature
	
	  //______________________________________________________
Function featuresFlag
	
	var $0 : Boolean
	var $1
	
	$0:=feature.with($1)
	
	  //______________________________________________________
Function loadProject
	
	var $0 : Boolean
	var $1 : Object
	
	If ($1.project#Null:C1517)
		
		$0:=project_Upgrade ($1.project)
		
	Else 
		
		$0:=project_Upgrade ($1)
		
	End if 
	
	  //______________________________________________________
Function checkRest
	
	var $0 : Object
	$0:=env_Database_setting ("rest")
	
	  //______________________________________________________
Function checkInstall
	
	var $0 : Object
	$0:=Xcode_CheckInstall 
	
	  //______________________________________________________
Function rest
	
	var $0;$1 : Object
	$0:=Rest ($1)
	
	  //______________________________________________________
Function structure
	
	var $0;$1 : Object
	$0:=structure ($1)
	
	  //______________________________________________________
Function dump
	
	var $0;$1 : Object
	$0:=dump ($1)
	
	  //______________________________________________________
Function pathname
	
	var $0;$1 : Object
	$0:=New object:C1471(\
		"success";True:C214;\
		"value";COMPONENT_Pathname ($1.target).platformPath)
	
	  //______________________________________________________