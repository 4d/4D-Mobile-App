//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : mobileUnit
  // ID[397F98984CE44B3CB94A856B86C833B1]
  // Created 21-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // API for unit tests
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t;$Txt_in;$Txt_out)
C_OBJECT:C1216($o;$Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(mobileUnit ;$0)
	C_TEXT:C284(mobileUnit ;$1)
	C_OBJECT:C1216(mobileUnit ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
	COMPONENT_INIT 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_in="testSuites")
		
		C_OBJECT:C1216(err)
		
		$Obj_out:=New object:C1471(\
			"errors";Formula:C1597(err);\
			"tests";New collection:C1472)
		
		$o:=New signal:C1641
		
		CALL WORKER:C1389(1;"unitTestSuites";$o)
		
		If ($o.wait(10))
			
			For each ($t;$o.result)
				
				$Obj_out.tests.push(Formula from string:C1601($t))
				
			End for each 
			
			$Obj_out.success:=($Obj_out.tests.length>0)
			
		Else 
			
			ASSERT:C1129(False:C215;"Failed to load internal test methods")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="featuresFlags")
		
		$Obj_out:=New object:C1471(\
			"features";Formula:C1597(featuresFlags))
		
		  //______________________________________________________
	: ($Txt_in="loadProject")
		
		If (Asserted:C1132($Obj_in.project#Null:C1517;"Expected 'project' key into object parameter"))
			
			EXECUTE METHOD:C1007("project_Upgrade";$b;$Obj_in.project)
			
			$Obj_out:=New object:C1471(\
				"upgraded";$b)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="checkRest")
		
		EXECUTE METHOD:C1007("env_Database_setting";$Obj_out;"rest")
		
		  //______________________________________________________
	: ($Txt_in="checkInstall")
		
		EXECUTE METHOD:C1007("Xcode_CheckInstall";$Obj_out)
		
		  //________________________________________
	: (Not:C34(Asserted:C1132($Lon_parameters=2;"Expected object parameter")))
		
		  // ALL SUBSEQUENT ENTRY POINTS REQUIRE AT LEAST 2 PARAMETERS
		
		  //______________________________________________________
	: ($Txt_in="rest")\
		 | ($Txt_in="structure")\
		 | ($Txt_in="dump")
		
		If (Asserted:C1132($Lon_parameters=2;"Expected object parameter"))
			
			EXECUTE METHOD:C1007($Txt_in;$Obj_out;$Obj_in)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="pathname")
		
		If (Asserted:C1132($Obj_in.target#Null:C1517;"Expected 'target' key into object parameter"))
			
			$Obj_out:=New object:C1471(\
				"success";True:C214;\
				"value";COMPONENT_Pathname ($Obj_in.target).platformPath)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="featuresFlags")
		
		  // see if a feature is activated and exist
		$Obj_out:=New object:C1471(\
			"value";featuresFlags["_"+String:C10($Obj_in.value)])
		
		$Obj_out.success:=($Obj_out.value#Null:C1517)
		
		  //________________________________________
	: (Not:C34(Asserted:C1132(Is macOS:C1572;"Command unavailable for this operating system")))
		
		  // ALL SUBSEQUENT ENTRY POINTS ARE ONLY AVAILABLE ON macOS
		
		  //________________________________________
	: ($Txt_in="xcode")\
		 | ($Txt_in="xcodeProj")\
		 | ($Txt_in="plist")\
		 | ($Txt_in="asset")\
		 | ($Txt_in="colors")\
		 | ($Txt_in="provisioningProfiles")\
		 | ($Txt_in="simulator")\
		 | ($Txt_in="dataSet")\
		 | ($Txt_in="dataModel")\
		 | ($Txt_in="storyboard")\
		 | ($Txt_in="templates")\
		 | ($Txt_in="TEMPLATE")\
		 | ($Txt_in="sdk")\
		 | ($Txt_in="git")\
		 | ($Txt_in="itunes_lookup")\
		 | ($Txt_in="xloc")\
		 | ($Txt_in="formatters")\
		 | ($Txt_in="PROJECT_HANDLER")\
		 | ($Txt_in="project_Audit")\
		 | ($Txt_in="device")\
		 | ($Txt_in="checkQueryFilter")\
		 | ($Txt_in="teamId")\
		 | ($Txt_in="swiftPM")\
		 | ($Txt_in="certificate")
		
		EXECUTE METHOD:C1007($Txt_in;$Obj_out;$Obj_in)
		
		  //______________________________________________________
	: ($Txt_in="project")
		
		EXECUTE METHOD:C1007("mobile_Project";$Obj_out;$Obj_in)
		
		  //______________________________________________________
	: ($Txt_in="Process_tags")
		
		If (Asserted:C1132($Obj_in.text#Null:C1517;"Expected 'text' key into object parameter"))
			
			Case of 
					
					  //……………………………………………………………………………………………………………………………
				: ($Obj_in.tags#Null:C1517)\
					 & ($Obj_in.types#Null:C1517)
					
					EXECUTE METHOD:C1007("Process_tags";$Txt_out;$Obj_in.text;$Obj_in.tags;$Obj_in.types)
					
					  //……………………………………………………………………………………………………………………………
				: ($Obj_in.tags#Null:C1517)
					
					EXECUTE METHOD:C1007("Process_tags";$Txt_out;$Obj_in.text;$Obj_in.tags)
					
					  //……………………………………………………………………………………………………………………………
				Else 
					
					EXECUTE METHOD:C1007("Process_tags";$Txt_out;$Obj_in.text)
					
					  //……………………………………………………………………………………………………………………………
			End case 
			
			$Obj_out:=New object:C1471(\
				"success";True:C214;\
				"value";$Txt_out)
			
		End if 
		
		  //______________________________________________________
	: ($Txt_in="Process_tags_on_file")
		
		If (Asserted:C1132($Obj_in.text#Null:C1517;"Expected 'text' key into object parameter"))
			
			Case of 
					
					  //……………………………………………………………………………………………………………………………
				: (Not:C34(Asserted:C1132($Obj_in.file#Null:C1517;"Expected 'file' key into object parameter")))
					
					  //……………………………………………………………………………………………………………………………
				: (Not:C34(Asserted:C1132($Obj_in.tags#Null:C1517;"Expected 'tags' key into object parameter")))
					
					  //……………………………………………………………………………………………………………………………
				: (Not:C34(Asserted:C1132($Obj_in.types#Null:C1517;"Expected 'types' key into object parameter")))
					
					  //……………………………………………………………………………………………………………………………
				Else 
					
					EXECUTE METHOD:C1007("Process_tags_on_file";$Obj_out;$Obj_in.file;$Obj_in.tags;$Obj_in.types)
					
					  //…………………………………………………………………………………………………………………………
			End case 
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_in+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End