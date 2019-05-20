//%attributes = {"invisible":true,"preemptive":"capable"}
/*
out := ***Process_tags*** ( in ; tags ; types )
 -> in (Text)
 -> tags (Object)
 -> types (Collection)
 <- out (Text)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : Process_tags
  // Database: 4D Mobile Express
  // ID[CF26D63F6DF3493D9224934C8492CD74]
  // Created #12-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // -
  // ----------------------------------------------------
  // Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)
C_COLLECTION:C1488($3)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Txt_in;$Txt_out;$Txt_buffer)
C_OBJECT:C1216($Obj_table;$Obj_tags;$Obj_field)
C_COLLECTION:C1488($Col_types)

ARRAY TEXT:C222($tTxt_types;0)

If (False:C215)
	C_TEXT:C284(Process_tags ;$0)
	C_TEXT:C284(Process_tags ;$1)
	C_OBJECT:C1216(Process_tags ;$2)
	C_COLLECTION:C1488(Process_tags ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_tags:=$2
		
		If ($Lon_parameters>=3)
			
			$Col_types:=$3
			
			  //col_TO_TEXT_ARRAY ($Col_types;->$tTxt_types)
			COLLECTION TO ARRAY:C1562($Col_types;$tTxt_types)
			
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Txt_out:=$Txt_in
$Obj_table:=$Obj_tags.table

Case of   // According to type replace the tag
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"swift")>0)
		
		  // Sources file header (*.swift)
		$Txt_out:=Replace string:C233($Txt_out;"___DATE___";String:C10($Obj_tags.date))
		$Txt_out:=Replace string:C233($Txt_out;"___FULLUSERNAME___";String:C10($Obj_tags.fullname))
		$Txt_out:=Replace string:C233($Txt_out;"___PACKAGENAME___";String:C10($Obj_tags.packageName))
		$Txt_out:=Replace string:C233($Txt_out;"___COPYRIGHT___";String:C10($Obj_tags.copyright))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"Info.plist")>0)
		
		  // The following file could be edited using /usr/libexec/PListBuddy, plutil or default
		  // Info.plist
		$Txt_out:=Replace string:C233($Txt_out;"___DEVELOPMENT_REGION___";String:C10($Obj_tags.developmentRegion))
		$Txt_out:=Replace string:C233($Txt_out;"___PROJECT_DISPLAY_NAME___";String:C10($Obj_tags.displayName))
		$Txt_out:=Replace string:C233($Txt_out;"___VERSION___";String:C10($Obj_tags.version))
		$Txt_out:=Replace string:C233($Txt_out;"___BUILD_NUMBER___";String:C10($Obj_tags.build))
		$Txt_out:=Replace string:C233($Txt_out;"___STORYBOARD_LAUNCH_SCREEN___";String:C10($Obj_tags.storyboardLaunchScreen))
		$Txt_out:=Replace string:C233($Txt_out;"___STORYBOARD_MAIN___";String:C10($Obj_tags.storyboardMain))
		$Txt_out:=Replace string:C233($Txt_out;"___URL_SCHEME___";String:C10($Obj_tags.urlScheme))
		
		$Txt_out:=Replace string:C233($Txt_out;"___COMPONENT_BUILD___";String:C10($Obj_tags.componentBuild))
		$Txt_out:=Replace string:C233($Txt_out;"___IDE_VERSION___";String:C10($Obj_tags.ideVersion))
		$Txt_out:=Replace string:C233($Txt_out;"___IDE_BUILD_VERSION___";String:C10($Obj_tags.ideBuildVersion))
		$Txt_out:=Replace string:C233($Txt_out;"___SDK_VERSION___";String:C10($Obj_tags.sdkVersion))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"settings")>0)
		
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_URL___";String:C10($Obj_tags.prodUrl))
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_PORT___";String:C10($Obj_tags.serverPort))
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_URL_SCHEME___";String:C10($Obj_tags.serverScheme))
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_HTTPS_PORT___";String:C10($Obj_tags.serverHTTPSPort))
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_URLS___";String:C10($Obj_tags.serverUrls))
		
		  // has login form
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_AUTHENTIFICATION_EMAIL___";String:C10($Obj_tags.serverAuthenticationEmail))
		$Txt_out:=Replace string:C233($Txt_out;"___SERVER_AUTHENTIFICATION_RELOAD_DATA___";String:C10($Obj_tags.serverAuthenticationReloadData))
		
		  // An unique UUID created for a new generated app
		$Txt_out:=Replace string:C233($Txt_out;"___SETTING_UUID___";Generate UUID:C1066)
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"asset")>0)
		
		$Txt_out:=Replace string:C233($Txt_out;"___NAME___";String:C10($Obj_tags.name))
		$Txt_out:=Replace string:C233($Txt_out;"___FILE_NAME___";String:C10($Obj_tags.fileName))
		$Txt_out:=Replace string:C233($Txt_out;"___UTI___";String:C10($Obj_tags.uti))
		$Txt_out:=Replace string:C233($Txt_out;"___RED___";String:C10($Obj_tags.red))
		$Txt_out:=Replace string:C233($Txt_out;"___BLUE___";String:C10($Obj_tags.blue))
		$Txt_out:=Replace string:C233($Txt_out;"___GREEN___";String:C10($Obj_tags.green))
		$Txt_out:=Replace string:C233($Txt_out;"___WHITE___";String:C10($Obj_tags.white))
		$Txt_out:=Replace string:C233($Txt_out;"___ALPHA___";String:C10($Obj_tags.alpha))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"project.pbxproj")>0)
		
		  // project.pbxproj
		$Txt_out:=Replace string:C233($Txt_out;"___PRODUCT___";String:C10($Obj_tags.product))
		$Txt_out:=Replace string:C233($Txt_out;"___PRODUCT_BUNDLE_IDENTIFIER___";String:C10($Obj_tags.bundleIdentifier))
		$Txt_out:=Replace string:C233($Txt_out;"___ORGANIZATION___";String:C10($Obj_tags.company))
		$Txt_out:=Replace string:C233($Txt_out;"___IPHONEOS_DEPLOYMENT_TARGET___";String:C10($Obj_tags.iosDeploymentTarget))
		$Txt_out:=Replace string:C233($Txt_out;"___SWIFT_VERSION___";String:C10($Obj_tags.swiftVersion))
		$Txt_out:=Replace string:C233($Txt_out;"___ENABLE_ON_DEMAND_RESOURCES___";String:C10($Obj_tags.onDemandResources))
		$Txt_out:=Replace string:C233($Txt_out;"___ENABLE_BITCODE___";String:C10($Obj_tags.bitcode))
		$Txt_out:=Replace string:C233($Txt_out;"___TARGETED_DEVICE_FAMILY___";String:C10($Obj_tags.targetedDeviceFamily))
		$Txt_out:=Replace string:C233($Txt_out;"___OTHER_SWIFT_FLAGS_DEBUG___";String:C10($Obj_tags.swiftFlagsDebug))
		$Txt_out:=Replace string:C233($Txt_out;"___OTHER_SWIFT_FLAGS_RELEASE___";String:C10($Obj_tags.swiftFlagsRelease))
		$Txt_out:=Replace string:C233($Txt_out;"___SWIFT_OPTIMIZATION_LEVEL_DEBUG___";String:C10($Obj_tags.swiftOptimizationLevelDebug))
		$Txt_out:=Replace string:C233($Txt_out;"___SWIFT_OPTIMIZATION_LEVEL_RELEASE___";String:C10($Obj_tags.swiftOptimizationLevelRelease))
		$Txt_out:=Replace string:C233($Txt_out;"___SWIFT_COMPILATION_MODE_DEBUG___";String:C10($Obj_tags.swiftCompilationModeDebug))
		$Txt_out:=Replace string:C233($Txt_out;"___SWIFT_COMPILATION_MODE_RELEASE___";String:C10($Obj_tags.swiftCompilationModeRelease))
		
		If (String:C10($Obj_tags.teamId)#"")
			
			$Txt_out:=Replace string:C233($Txt_out;"___DEVELOPMENT_TEAM___";$Obj_tags.teamId)
			
		Else 
			
			  // Remove the keys
			$Txt_out:=Replace string:C233($Txt_out;"DevelopmentTeam = \"___DEVELOPMENT_TEAM___\";";"")
			$Txt_out:=Replace string:C233($Txt_out;"DEVELOPMENT_TEAM = \"___DEVELOPMENT_TEAM___\";";"")
			
		End if 
		
		  // **************************** TEMPORARY ****************************
		  // * all table files swift and storyboard must added to project      *
		  // *******************************************************************
		$Txt_out:=Replace string:C233($Txt_out;"___TABLE___";String:C10($Obj_table.name))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"filename")>0)
		
		$Txt_out:=Replace string:C233($Txt_out;"___PRODUCT___";String:C10($Obj_tags.product))
		$Txt_out:=Replace string:C233($Txt_out;"___TABLE___";String:C10($Obj_table.name))
		$Txt_out:=Replace string:C233($Txt_out;"___NAME___";String:C10($Obj_tags.name))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"navigation.storyboard")>0)
		
		$Txt_out:=Replace string:C233($Txt_out;"___NAVIGATION_TRANSITION___";String:C10($Obj_tags.navigationTransition))
		$Txt_out:=Replace string:C233($Txt_out;"___NAVIGATION_TITLE___";String:C10($Obj_tags.navigationTitle))
		$Txt_out:=Replace string:C233($Txt_out;"___NAVIGATION_TABLE_ROW_HEIGHT___";String:C10($Obj_tags.navigationRowHeight))
		
		  //______________________________________________________
	: (Find in array:C230($tTxt_types;"script")>0)
		
		$Txt_out:=Replace string:C233($Txt_out;"___MINIMUM_XCODE_VERSION___";String:C10($Obj_tags.xCodeVersion))
		
		  //______________________________________________________
	Else 
		
		$Txt_out:=Replace string:C233($Txt_out;"___PRODUCT___";String:C10($Obj_tags.product))
		
		  //______________________________________________________
End case 

  //___TABLE___ FILES [
If (Find in array:C230($tTxt_types;"___TABLE___")>0)  // ___TABLE___.* or file part
	
	$Txt_out:=Replace string:C233($Txt_out;"___TABLE___";$Obj_table.name)
	
	Case of 
			
			  //______________________________________________________
		: (Find in array:C230($tTxt_types;"swift")>0)  //___TABLE___.swift
			
			$Txt_out:=Replace string:C233($Txt_out;"___DETAILFORMTYPE___";String:C10($Obj_tags.detailFormType))
			$Txt_out:=Replace string:C233($Txt_out;"___LISTFORMTYPE___";String:C10($Obj_tags.listFormType))
			
			For each ($Obj_field;$Obj_table.fields)
				
				$Lon_i:=$Lon_i+1
				
				$Txt_buffer:="___FIELD_"+String:C10($Lon_i)
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"___";$Obj_field.name)
				
			End for each 
			
			  //______________________________________________________
		: (Find in array:C230($tTxt_types;"storyboard")>0)  //___TABLE___XXX.storyboard
			
			$Txt_buffer:=String:C10($Obj_table.navigationTransition)
			
			If (Length:C16($Txt_buffer)=0)
				
				$Txt_buffer:=String:C10($Obj_tags.navigationTransition)  // the default one
				
			End if 
			
			$Txt_out:=Replace string:C233($Txt_out;"___LIST_TO_DETAIL_TRANSITION___";$Txt_buffer)
			
			$Txt_out:=Replace string:C233($Txt_out;"___SEARCHABLE_FIELD___";String:C10($Obj_table.searchableField))
			$Txt_out:=Replace string:C233($Txt_out;"___SECTION_FIELD___";String:C10($Obj_table.sectionField))
			$Txt_out:=Replace string:C233($Txt_out;"___SHOW_SECTION___";String:C10($Obj_table.showSection))
			$Txt_out:=Replace string:C233($Txt_out;"___SORT_FIELD___";String:C10($Obj_table.sortField))
			
			$Txt_out:=Replace string:C233($Txt_out;"___PRODUCT___";String:C10($Obj_tags.product))
			
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_NUMBER___";String:C10($Obj_table.tableNumber))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_NAME___";xml_encode (String:C10($Obj_table.originalName)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_LABEL___";xml_encode (String:C10($Obj_table.label)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_SHORT_LABEL___";xml_encode (String:C10($Obj_table.shortLabel)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_ICON___";xml_encode (String:C10($Obj_table.navigationIcon)))
			
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_ACTIONS___";xml_encode (String:C10($Obj_table.tableActions)))
			$Txt_out:=Replace string:C233($Txt_out;"___ENTITY_ACTIONS___";xml_encode (String:C10($Obj_table.recordActions)))
			
			  //$Txt_out:=Replace string($Txt_out;"___SELECTION_ACTIONS___";xml_encode (String($Obj_table.selectionActions)))
			
			For each ($Obj_field;$Obj_table.fields)
				
				$Lon_i:=$Lon_i+1
				
				$Txt_buffer:="___FIELD_"+String:C10($Lon_i)
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"___";$Obj_field.name)
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_NAME___";xml_encode (String:C10($Obj_field.originalName)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_LABEL___";xml_encode (String:C10($Obj_field.label)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_SHORT_LABEL___";xml_encode (String:C10($Obj_field.shortLabel)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_BINDING_TYPE___";String:C10($Obj_field.bindingType))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_ICON___";xml_encode (String:C10($Obj_field.detailIcon)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_LABEL_ALIGNMENT___";String:C10($Obj_field.labelAlignment))
				
			End for each 
			
			  //______________________________________________________
		: (Find in array:C230($tTxt_types;"detailform")>0)  //___TABLE___DetailsForm.storyboard
			
			If ($Obj_tags.field#Null:C1517)
				
				$Txt_buffer:="___FIELD"
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"___";$Obj_tags.field.name)
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_NAME___";xml_encode (String:C10($Obj_field.originalName)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_LABEL___";xml_encode ($Obj_tags.field.label))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_SHORT_LABEL___";xml_encode (String:C10($Obj_tags.field.shortLabel)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_BINDING_TYPE___";String:C10($Obj_tags.field.bindingType))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_ICON___";xml_encode (String:C10($Obj_tags.field.detailIcon)))
				$Txt_out:=Replace string:C233($Txt_out;$Txt_buffer+"_LABEL_ALIGNMENT___";String:C10($Obj_tags.field.labelAlignment))
				
			End if 
			
			  //______________________________________________________
		: (Find in array:C230($tTxt_types;"navigation")>0)  // MainNavigation.storyboard
			
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_NAME___";xml_encode (String:C10($Obj_table.originalName)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_LABEL___";xml_encode (String:C10($Obj_table.label)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_SHORT_LABEL___";xml_encode (String:C10($Obj_table.shortLabel)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_ICON___";xml_encode (String:C10($Obj_table.navigationIcon)))
			$Txt_out:=Replace string:C233($Txt_out;"___TABLE_LABEL_ALIGNMENT___";String:C10($Obj_table.labelAlignment))
			
			$Txt_out:=Replace string:C233($Txt_out;"TAG-ID-SEG";$Obj_table.segueDestinationId)
			
			  //______________________________________________________
	End case 
	
	If (Find in array:C230($tTxt_types;"storyboardID")>0)  // Dispatch storyboard id in TAG-<interfix>-<position>
		
		If (Length:C16(String:C10($Obj_tags.tagInterfix))>0)
			
			If (Value type:C1509($Obj_tags.storyboardIDs)=Is collection:K8:32)
				
				For ($Lon_i;0;$Obj_tags.storyboardIDs.length-1;1)
					
					$Txt_buffer:=String:C10($Lon_i+1;"##000")
					$Txt_out:=Replace string:C233($Txt_out;"TAG-"+$Obj_tags.tagInterfix+"-"+$Txt_buffer;$Obj_tags.storyboardIDs[$Lon_i])
					
				End for 
				
			Else 
				
				ASSERT:C1129(dev_Matrix ;"storyboardID tag replacement asked but not collection of it provided")
				
			End if 
			
		Else 
			
			ASSERT:C1129(dev_Matrix ;"When replacing storyboard id no tag interfix provided (TAG-interfix-position)")
			
		End if 
	End if 
End if 
  //]

  // ----------------------------------------------------
  // Return
$0:=$Txt_out

  // ----------------------------------------------------
  // End