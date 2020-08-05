//%attributes = {"invisible":true,"preemptive":"capable"}
// ----------------------------------------------------
// Project method : Process_tags
// ID[CF26D63F6DF3493D9224934C8492CD74]
// Created 12-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// -
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)
C_COLLECTION:C1488($3)

C_LONGINT:C283($i; $Lon_parameters)
C_TEXT:C284($t; $Txt_in; $Txt_out)
C_OBJECT:C1216($o; $Obj_element; $Obj_field; $Obj_table; $Obj_tags)
C_COLLECTION:C1488($Col_newStrings; $Col_oldStrings; $Col_types)
C_VARIANT:C1683($Var_field)

If (False:C215)
	C_TEXT:C284(Process_tags; $0)
	C_TEXT:C284(Process_tags; $1)
	C_OBJECT:C1216(Process_tags; $2)
	C_COLLECTION:C1488(Process_tags; $3)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3; "Missing parameter"))
	
	// Required parameters
	$Txt_in:=$1
	$Obj_tags:=$2
	$Col_types:=$3
	
	// Optional parameters
	If ($Lon_parameters>=4)
		
		// <NONE>
		
	End if 
	
	$Obj_table:=$Obj_tags.table
	
	$o:=str  // Class
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Case of   // According to type replace the tag
		
		//______________________________________________________
	: ($Col_types.indexOf("swift")#-1)  // Sources file header (*.swift)
		
		$Col_oldStrings:=New collection:C1472(\
			"___DATE___"; \
			"___FULLUSERNAME___"; \
			"___PACKAGENAME___"; \
			"___COPYRIGHT___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.date; \
			$Obj_tags.fullname; \
			$Obj_tags.packageName; \
			$Obj_tags.copyright\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("Info.plist")#-1)
		
		// The following file could be edited using /usr/libexec/PListBuddy, plutil or default
		// Info.plist
		
		$Col_oldStrings:=New collection:C1472(\
			"___DEVELOPMENT_REGION___"; \
			"___PROJECT_DISPLAY_NAME___"; \
			"___VERSION___"; \
			"___BUILD_NUMBER___"; \
			"___STORYBOARD_LAUNCH_SCREEN___"; \
			"___STORYBOARD_MAIN___"; \
			"___COMPONENT_BUILD___"; \
			"___IDE_VERSION___"; \
			"___IDE_BUILD_VERSION___"; \
			"___SDK_VERSION___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.developmentRegion; \
			$Obj_tags.displayName; \
			$Obj_tags.version; \
			$Obj_tags.build; \
			$Obj_tags.storyboardLaunchScreen; \
			$Obj_tags.storyboardMain; \
			$Obj_tags.componentBuild; \
			$Obj_tags.ideVersion; \
			$Obj_tags.ideBuildVersion; \
			$Obj_tags.sdkVersion\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("settings")#-1)
		
		$Col_oldStrings:=New collection:C1472(\
			"___SERVER_URL___"; \
			"___SERVER_PORT___"; \
			"___SERVER_URL_SCHEME___"; \
			"___SERVER_HTTPS_PORT___"; \
			"___SERVER_URLS___"; \
			"___SERVER_AUTHENTIFICATION_EMAIL___"; \
			"___SERVER_AUTHENTIFICATION_RELOAD_DATA___"; \
			"___SETTING_UUID___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.prodUrl; \
			$Obj_tags.serverPort; \
			$Obj_tags.serverScheme; \
			$Obj_tags.serverHTTPSPort; \
			$Obj_tags.serverUrls; \
			$Obj_tags.serverAuthenticationEmail; \
			$Obj_tags.serverAuthenticationReloadData; \
			Generate UUID:C1066\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("asset")#-1)
		
		$Col_oldStrings:=New collection:C1472(\
			"___NAME___"; \
			"___FILE_NAME___"; \
			"___UTI___"; \
			"___RED___"; \
			"___BLUE___"; \
			"___GREEN___"; \
			"___WHITE___"; \
			"___ALPHA___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.name; \
			$Obj_tags.fileName; \
			$Obj_tags.uti; \
			$Obj_tags.red; \
			$Obj_tags.blue; \
			$Obj_tags.green; \
			$Obj_tags.white; \
			$Obj_tags.alpha\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("project.pbxproj")#-1)  // project.pbxproj
		
		$Col_oldStrings:=New collection:C1472(\
			"___PRODUCT___"; \
			"___PRODUCT_BUNDLE_IDENTIFIER___"; \
			"___ORGANIZATION___"; \
			"___IPHONEOS_DEPLOYMENT_TARGET___"; \
			"___SWIFT_VERSION___"; \
			"___ENABLE_ON_DEMAND_RESOURCES___"; \
			"___ENABLE_BITCODE___"; \
			"___TARGETED_DEVICE_FAMILY___"; \
			"___OTHER_SWIFT_FLAGS_DEBUG___"; \
			"___OTHER_SWIFT_FLAGS_RELEASE___"; \
			"___SWIFT_OPTIMIZATION_LEVEL_DEBUG___"; \
			"___SWIFT_OPTIMIZATION_LEVEL_RELEASE___"; \
			"___SWIFT_COMPILATION_MODE_DEBUG___"; \
			"___SWIFT_COMPILATION_MODE_RELEASE___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.product; \
			$Obj_tags.bundleIdentifier; \
			$Obj_tags.company; \
			$Obj_tags.iosDeploymentTarget; \
			$Obj_tags.swiftVersion; \
			$Obj_tags.onDemandResources; \
			$Obj_tags.bitcode; \
			$Obj_tags.targetedDeviceFamily; \
			$Obj_tags.swiftFlagsDebug; \
			$Obj_tags.swiftFlagsRelease; \
			$Obj_tags.swiftOptimizationLevelDebug; \
			$Obj_tags.swiftOptimizationLevelRelease; \
			$Obj_tags.swiftCompilationModeDebug; \
			$Obj_tags.swiftCompilationModeRelease\
			)
		
		If (String:C10($Obj_tags.teamId)#"")
			
			$Col_oldStrings.push("___DEVELOPMENT_TEAM___")
			$Col_newStrings.push($Obj_tags.teamId)
			
		Else 
			
			// Remove the keys
			$Col_oldStrings.push("DevelopmentTeam = \"___DEVELOPMENT_TEAM___\";")
			$Col_newStrings.push(Null:C1517)
			
			$Col_oldStrings.push("DEVELOPMENT_TEAM = \"___DEVELOPMENT_TEAM___\";")
			$Col_newStrings.push(Null:C1517)
			
		End if 
		
		// **************************** TEMPORARY ****************************
		// * all table files swift and storyboard must added to project      *
		// *******************************************************************
		$Col_oldStrings.push("___TABLE___")
		$Col_newStrings.push($Obj_table.name)
		
		//______________________________________________________
	: ($Col_types.indexOf("filename")#-1)
		
		$Col_oldStrings:=New collection:C1472(\
			"___PRODUCT___"; \
			"___TABLE___"; \
			"___NAME___"\
			)
		
		//ASSERT($Obj_table.name=Null)
		//ASSERT($Obj_table[""].name=Null)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.product; \
			$Obj_table.name; \
			$Obj_tags.name\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("navigation.storyboard")#-1)
		
		$Col_oldStrings:=New collection:C1472(\
			"___NAVIGATION_TRANSITION___"; \
			"___NAVIGATION_TITLE___"; \
			"___NAVIGATION_TABLE_ROW_HEIGHT___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.navigationTransition; \
			$Obj_tags.navigationTitle; \
			$Obj_tags.navigationRowHeight\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("script")#-1)
		
		$Col_oldStrings:=New collection:C1472(\
			"___MINIMUM_XCODE_VERSION___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.xCodeVersion\
			)
		
		//______________________________________________________
	: ($Col_types.indexOf("automatic")#-1)  // if pass a restricted tag object this add all keys
		
		$Col_oldStrings:=New collection:C1472
		$Col_newStrings:=New collection:C1472
		
		For each ($t; $Obj_tags)
			
			$Col_oldStrings.push("___"+Uppercase:C13($t)+"___")
			
			Case of 
					
					//________________________________________
				: (Value type:C1509($Obj_tags[$t])=Is collection:K8:32)
					
					$Col_newStrings.push($o.setText(JSON Stringify:C1217($Obj_tags[$t])).xmlEncode())
					
					//________________________________________
				: (Value type:C1509($Obj_tags[$t])=Is object:K8:27)
					
					$Col_newStrings.push($o.setText(JSON Stringify:C1217($Obj_tags[$t])).xmlEncode())
					
					//________________________________________
				Else 
					
					$Col_newStrings.push($Obj_tags[$t])
					
					//________________________________________
			End case 
		End for each 
		
		//______________________________________________________
	Else 
		
		$Col_oldStrings:=New collection:C1472(\
			"___PRODUCT___"\
			)
		
		$Col_newStrings:=New collection:C1472(\
			$Obj_tags.product\
			)
		
		//______________________________________________________
End case 

//___TABLE___ FILES [
If ($Col_types.indexOf("___TABLE___")#-1)  // ___TABLE___.* or file part
	
	$Col_oldStrings.push("___TABLE___")
	$Col_newStrings.push($Obj_table.name)
	
	Case of 
			
			//______________________________________________________
		: ($Col_types.indexOf("swift")#-1)  //___TABLE___.swift
			
			$Col_oldStrings.combine(New collection:C1472(\
				"___DETAILFORMTYPE___"; \
				"___LISTFORMTYPE___"\
				))
			
			$Col_newStrings.combine(New collection:C1472(\
				$Obj_tags.detailFormType; \
				$Obj_tags.listFormType\
				))
			
			C_VARIANT:C1683($Var_field)
			For each ($Var_field; $Obj_table.fields)
				
				If (Value type:C1509($Var_field)=Is object:K8:27)  // No real #114338
					
					$Obj_field:=$Var_field
					$i:=$i+1
					$t:="___FIELD_"+String:C10($i)
					
					$Col_oldStrings.combine(New collection:C1472(\
						$t+"___"; \
						$t+"_NAME___"; \
						$t+"_LABEL___"; \
						$t+"_SHORT_LABEL___"; \
						$t+"_FORMAT___"; \
						$t+"_BINDING_TYPE___"; \
						$t+"_ICON___"; \
						$t+"_LABEL_ALIGNMENT___"\
						))
					
					$Col_newStrings.combine(New collection:C1472(\
						$Obj_field.name; \
						$o.setText($Obj_field.originalName).xmlEncode(); \
						$o.setText($Obj_field.label).xmlEncode(); \
						$o.setText($Obj_field.shortLabel).xmlEncode(); \
						$o.setText($Obj_field.format).xmlEncode(); \
						$Obj_field.bindingType; \
						$o.setText($Obj_field.detailIcon).xmlEncode(); \
						$Obj_field.labelAlignment\
						))
					
				End if 
				
			End for each 
			
			//______________________________________________________
		: ($Col_types.indexOf("storyboard")#-1)  //___TABLE___XXX.storyboard
			
			$t:=String:C10($Obj_table.navigationTransition)
			
			If (Length:C16($t)=0)
				
				$t:=String:C10($Obj_tags.navigationTransition)  // the default one
				
			End if 
			
			$Col_oldStrings.combine(New collection:C1472(\
				"___LIST_TO_DETAIL_TRANSITION___"; \
				"___SEARCHABLE_FIELD___"; \
				"___SECTION_FIELD___"; \
				"___SECTION_FIELD_BINDING_TYPE___"; \
				"___SHOW_SECTION___"; \
				"___SORT_FIELD___"; \
				"___PRODUCT___"; \
				"___TABLE_NUMBER___"; \
				"___TABLE_NAME___"; \
				"___TABLE_LABEL___"; \
				"___TABLE_SHORT_LABEL___"; \
				"___TABLE_ICON___"; \
				"___TABLE_ACTIONS___"; \
				"___ENTITY_ACTIONS___"\
				))
			
			$Col_newStrings.combine(New collection:C1472(\
				$t; \
				$Obj_table.searchableField; \
				$Obj_table.sectionField; \
				$Obj_table.sectionFieldBindingType; \
				$Obj_table.showSection; \
				$Obj_table.sortField; \
				$Obj_tags.product; \
				$Obj_table.tableNumber; \
				$o.setText($Obj_table.originalName).xmlEncode(); \
				$o.setText($Obj_table.label).xmlEncode(); \
				$o.setText($Obj_table.shortLabel).xmlEncode(); \
				$o.setText($Obj_table.navigationIcon).xmlEncode(); \
				$o.setText($Obj_table.tableActions).xmlEncode(); \
				$o.setText($Obj_table.recordActions).xmlEncode()\
				))
			
			For each ($Var_field; $Obj_table.fields)
				If (Value type:C1509($Var_field)=Is object:K8:27)
					$Obj_field:=$Var_field
					$i:=$i+1
					$t:="___FIELD_"+String:C10($i)
					
					$Col_oldStrings.combine(New collection:C1472(\
						$t+"___"; \
						$t+"_NAME___"; \
						$t+"_LABEL___"; \
						$t+"_SHORT_LABEL___"; \
						$t+"_FORMAT___"; \
						$t+"_BINDING_TYPE___"; \
						$t+"_ICON___"; \
						$t+"_LABEL_ALIGNMENT___"\
						))
					
					$Col_newStrings.combine(New collection:C1472(\
						$Obj_field.name; \
						$o.setText($Obj_field.originalName).xmlEncode(); \
						$o.setText($Obj_field.label).xmlEncode(); \
						$o.setText($Obj_field.shortLabel).xmlEncode(); \
						$o.setText($Obj_field.format).xmlEncode(); \
						$Obj_field.bindingType; \
						$o.setText($Obj_field.detailIcon).xmlEncode(); \
						$Obj_field.labelAlignment\
						))
				End if 
			End for each 
			
			//______________________________________________________
		: ($Col_types.indexOf("detailform")#-1)  //___TABLE___DetailsForm.storyboard
			
			If ($Obj_tags.field#Null:C1517)
				
				$t:="___FIELD"
				
				$Col_oldStrings.combine(New collection:C1472(\
					$t+"___"; \
					$t+"_NAME___"; \
					$t+"_LABEL___"; \
					$t+"_SHORT_LABEL___"; \
					$t+"_FORMAT___"; \
					$t+"_BINDING_TYPE___"; \
					$t+"_ICON___"; \
					$t+"_LABEL_ALIGNMENT___"\
					))
				
				$Col_newStrings.combine(New collection:C1472(\
					$Obj_tags.field.name; \
					$o.setText($Obj_tags.field.originalName).xmlEncode(); \
					$o.setText($Obj_tags.field.label).xmlEncode(); \
					$o.setText($Obj_tags.field.shortLabel).xmlEncode(); \
					$o.setText($Obj_tags.field.format).xmlEncode(); \
					$Obj_tags.field.bindingType; \
					$o.setText($Obj_tags.field.detailIcon).xmlEncode(); \
					$Obj_tags.field.labelAlignment\
					))
				
				If (Num:C11($Obj_tags.field.id)=0)  // isRelation
					
					// If use field as relation, remove these lines if use ($Obj_tags.relation#Null)
					$Col_oldStrings.push("___DESTINATION___")
					
					Case of 
						: ($Obj_tags.field.relatedEntities#Null:C1517)  // isToMany ?
							$Col_newStrings.push(formatString("table-name"; String:C10($Obj_tags.field.relatedEntities)+"ListForm"))
						: ($Obj_tags.field.relatedEntity#Null:C1517)  //  ??
							$Col_newStrings.push(formatString("table-name"; String:C10($Obj_tags.field.relatedEntity)+"DetailsForm"))
						Else 
							$Col_newStrings.push(formatString("table-name"; String:C10($Obj_tags.field.relatedDataClass)+"DetailsForm"))
					End case 
					
				End if 
			End if 
			
			//______________________________________________________
		: ($Col_types.indexOf("navigation")#-1)  // MainNavigation.storyboard
			
			$Col_oldStrings.combine(New collection:C1472(\
				"___TABLE_NAME___"; \
				"___TABLE_LABEL___"; \
				"___TABLE_SHORT_LABEL___"; \
				"___TABLE_ICON___"; \
				"___TABLE_LABEL_ALIGNMENT___"; \
				"TAG-ID-SEG"\
				))
			
			$Col_newStrings.combine(New collection:C1472(\
				$o.setText($Obj_table.originalName).xmlEncode(); \
				$o.setText($Obj_table.label).xmlEncode(); \
				$o.setText($Obj_table.shortLabel).xmlEncode(); \
				$o.setText($Obj_table.navigationIcon).xmlEncode(); \
				$Obj_table.labelAlignment; \
				$Obj_table.segueDestinationId\
				))
			
			//______________________________________________________
	End case 
End if 
//]

If ($Col_types.indexOf("storyboardID")#-1)  // Dispatch storyboard id in TAG-<interfix>-<position>
	
	If (Length:C16(String:C10($Obj_tags.tagInterfix))>0)  // only one element defined directly at root tag level
		
		$Obj_tags.storyboardID:=New collection:C1472(New object:C1471(\
			"tagInterfix"; $Obj_tags.tagInterfix; \
			"storyboardIDs"; $Obj_tags.storyboardIDs))
		
	End if 
	
	If (Value type:C1509($Obj_tags.storyboardID)=Is collection:K8:32)  // we have a collection of storyboard ids to replace
		
		For each ($Obj_element; $Obj_tags.storyboardID)
			
			If (Length:C16(String:C10($Obj_element.tagInterfix))>0)
				
				If (Value type:C1509($Obj_element.storyboardIDs)=Is collection:K8:32)
					
					For ($i; 0; $Obj_element.storyboardIDs.length-1; 1)
						
						$Col_oldStrings.push("TAG-"+$Obj_element.tagInterfix+"-"+String:C10($i+1; "##000"))
						$Col_newStrings.push($Obj_element.storyboardIDs[$i])
						
					End for 
					
				Else 
					
					ASSERT:C1129(dev_Matrix; "storyboardID tag replacement asked but not collection of it provided for "+String:C10($Obj_element.tagInterfix))
					
				End if 
				
			Else 
				
				ASSERT:C1129(dev_Matrix; "When replacing storyboard id no tag interfix provided (TAG-interfix-position)")
				
			End if 
		End for each 
	End if 
End if 

ASSERT:C1129($Col_oldStrings.length=$Col_newStrings.length)

// Make replacements
$Txt_out:=$o.setText($Txt_in).replace($Col_oldStrings; $Col_newStrings)

// ----------------------------------------------------
// Return
$0:=$Txt_out

// ----------------------------------------------------
// End