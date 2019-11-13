//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_Upgrade
  // ID[4496D76DCBC74F1AA92340B61399720D]
  // Created 31-8-2018 by Eric Marchand
  // ----------------------------------------------------
  // Description:
  // Version check & update
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_upgraded)
C_LONGINT:C283($l;$Lon_build;$Lon_parameters)
C_TEXT:C284($t;$tt;$Txt_fieldID;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$o;$Obj_catalog;$Obj_info;$Obj_project;$Obj_table)
C_COLLECTION:C1488($Col_fieldTypes;$Col_types)

If (False:C215)
	C_BOOLEAN:C305(project_Upgrade ;$0)
	C_OBJECT:C1216(project_Upgrade ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Obj_project:=$1
	
	$ƒ:=Storage:C1525.ƒ
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Form:C1466#Null:C1517)
	
	  // Rename cache.json -> catalog.json
	If (Test path name:C476(Form:C1466.root+"cache.json")=Is a document:K24:1)
		
		COPY DOCUMENT:C541(Form:C1466.root+"cache.json";Form:C1466.root;"catalog.json";*)
		DELETE DOCUMENT:C159(Form:C1466.root+"cache.json")
		
	End if 
End if 

  // Create current information to compare
$Obj_info:=New object:C1471

$o:=xml_fileToObject (Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict

$l:=$o.key.extract("$").indexOf("CFBundleVersion")

If ($l#-1)
	
	$Obj_info.componentBuild:=String:C10($o.string[$l].$)
	
End if 

$Obj_info.ideVersion:=String:C10(Application version:C493($Lon_build))
$Obj_info.ideBuildVersion:=String:C10($Lon_build)

If ($Obj_project.info.ideVersion=Null:C1517)  // "1720"
	
	If (Value type:C1509($Obj_project.dataModel)=Is object:K8:27)
		
		  /// Remove first / on icon path #100580
		For each ($Txt_tableNumber;$Obj_project.dataModel)
			
			$t:=String:C10($Obj_project.dataModel[$Txt_tableNumber].icon)
			
			If (Position:C15("/";$t)=1)
				
				$Obj_project.dataModel[$Txt_tableNumber].icon:=Delete string:C232($t;1;1)
				$Boo_upgraded:=True:C214
				
			End if 
			
			For each ($Txt_fieldID;$Obj_project.dataModel[$Txt_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldID;1;*))
					
					$t:=String:C10($Obj_project.dataModel[$Txt_tableNumber][$Txt_fieldID].icon)
					
					If (Position:C15("/";$t)=1)
						
						$Obj_project.dataModel[$Txt_tableNumber][$Txt_fieldID].icon:=Delete string:C232($t;1;1)
						$Boo_upgraded:=True:C214
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	  // Rename internal templates
	If ($Obj_project.detail#Null:C1517)
		
		For each ($Txt_tableNumber;$Obj_project.detail)
			
			Case of 
					
					  //______________________________________________________
				: ($Obj_project.detail[$Txt_tableNumber].form=Null:C1517)
					
					  //______________________________________________________
				: ($Obj_project.detail[$Txt_tableNumber].form="Cards Detail")
					
					$Obj_project.detail[$Txt_tableNumber].form:="Cards"
					
					  //______________________________________________________
				: ($Obj_project.detail[$Txt_tableNumber].form="Numbers Detail")
					
					$Obj_project.detail[$Txt_tableNumber].form:="Numbers"
					
					  //______________________________________________________
				: ($Obj_project.detail[$Txt_tableNumber].form="Tasks Detail")
					
					$Obj_project.detail[$Txt_tableNumber].form:="Tasks"
					
					  //______________________________________________________
				: ($Obj_project.detail[$Txt_tableNumber].form="Tasks Detail Plus")
					
					$Obj_project.detail[$Txt_tableNumber].form:="Tasks Plus"
					
					  //______________________________________________________
			End case 
		End for each 
	End if 
	
	If ($Obj_project.list#Null:C1517)
		
		For each ($Txt_tableNumber;$Obj_project.list)
			
			If ($Obj_project.list[$Txt_tableNumber].form#Null:C1517)
				
				Case of 
						
						  //______________________________________________________
					: ($Obj_project.list[$Txt_tableNumber].form=Null:C1517)
						
						  //______________________________________________________
					: ($Obj_project.list[$Txt_tableNumber].form="Profil")
						
						$Obj_project.list[$Txt_tableNumber].form:="Profile"
						
						  //______________________________________________________
					: ($Obj_project.list[$Txt_tableNumber].form="Square Profil")
						
						$Obj_project.list[$Txt_tableNumber].form:="Square Profile"
						
						  //______________________________________________________
					: ($Obj_project.list[$Txt_tableNumber].form="Tasks List")
						
						$Obj_project.list[$Txt_tableNumber].form:="Tasks"
						
						  //______________________________________________________
				End case 
			End if 
		End for each 
	End if 
End if 

If (Num:C11($Obj_project.info.version)<2)
	
	  // Add datasource property if any
	If ($Obj_project.dataSource=Null:C1517)
		
		$Obj_project.dataSource:=New object:C1471(\
			"source";"local";\
			"doNotGenerateDataAtEachBuild";False:C215)
		
	End if 
	
	If ($Obj_project.dataModel#Null:C1517)
		
		For each ($Txt_tableNumber;$Obj_project.dataModel)
			
			If ($Obj_project.dataModel[$Txt_tableNumber].embedded=Null:C1517)
				
				$Obj_project.dataModel[$Txt_tableNumber].embedded:=True:C214
				
			End if 
		End for each 
	End if 
	
	$Obj_project.info.version:=2
	$Boo_upgraded:=True:C214
	
End if 

  //=====================================================================
  //                 REORGANIZATION FIX AND RENAMING
  //=====================================================================

If (Num:C11($Obj_project.info.version)<3)
	
	If ($Obj_project.dataModel#Null:C1517)
		
		For each ($Txt_tableNumber;$Obj_project.dataModel)
			
			$Obj_table:=$Obj_project.dataModel[$Txt_tableNumber]
			
			$o:=$Obj_table.primary_key
			
			If ($o=Null:C1517)
				
				$o:=$Obj_table["primary_key:"]
				
			End if 
			
			If ($o#Null:C1517)
				
				OB REMOVE:C1226($Obj_table;"primary_key")
				OB REMOVE:C1226($Obj_table;"primary_key:")
				
				$Obj_table.primaryKey:=String:C10($o.field_name)
				
				$Boo_upgraded:=True:C214
				
			End if 
		End for each 
	End if 
	
	$Obj_project.info.version:=3
	
End if 

  //=====================================================================
  //                    NEW FIELD DESCRIPTION
  //=====================================================================
If (Num:C11($Obj_project.info.version)<4)
	
	  // Remap field type
	
	If (Value type:C1509($Obj_project.dataModel)=Is object:K8:27)
		
		If (Value type:C1509($Obj_project.dataModel)=Is object:K8:27)
			
			  // Update dataModel to be compliant with ds
			
			$Col_fieldTypes:=New collection:C1472
			$Col_fieldTypes[0]:=Is alpha field:K8:1
			$Col_fieldTypes[1]:=Is boolean:K8:9
			$Col_fieldTypes[3]:=Is integer:K8:5
			$Col_fieldTypes[4]:=Is longint:K8:6
			$Col_fieldTypes[5]:=Is integer 64 bits:K8:25
			$Col_fieldTypes[6]:=Is real:K8:4
			$Col_fieldTypes[7]:=_o_Is float:K8:26
			$Col_fieldTypes[8]:=Is date:K8:7
			$Col_fieldTypes[9]:=Is time:K8:8
			$Col_fieldTypes[10]:=Is text:K8:3
			$Col_fieldTypes[12]:=Is picture:K8:10
			$Col_fieldTypes[18]:=Is BLOB:K8:12
			$Col_fieldTypes[21]:=Is object:K8:27
			
			$Col_types:=New collection:C1472
			$Col_types[Is alpha field:K8:1]:="string"
			$Col_types[Is boolean:K8:9]:="bool"
			$Col_types[Is integer:K8:5]:="number"
			$Col_types[Is longint:K8:6]:="number"
			$Col_types[Is integer 64 bits:K8:25]:="number"
			$Col_types[Is real:K8:4]:="number"
			$Col_types[_o_Is float:K8:26]:="number"
			$Col_types[Is date:K8:7]:="date"
			$Col_types[Is time:K8:8]:="time"  // WARNING: for ds it's a number, but I think we must do the distinguo
			$Col_types[Is text:K8:3]:="string"
			$Col_types[Is picture:K8:10]:="image"
			$Col_types[Is BLOB:K8:12]:="blob"
			$Col_types[Is object:K8:27]:="object"
			
			$Obj_catalog:=Build Exposed Datastore:C1598
			
			For each ($Txt_tableNumber;$Obj_project.dataModel)
				
				$Obj_table:=$Obj_project.dataModel[$Txt_tableNumber]
				
				For each ($t;$Obj_table)
					
					Case of 
							
							  //______________________________________________________
						: ($ƒ.isField($t))
							
							$Obj_table[$t].fieldNumber:=$Obj_table[$t].id
							$Obj_table[$t].fieldType:=$Col_fieldTypes[$Obj_table[$t].type]
							$Obj_table[$t].type:=$Col_types[$Obj_table[$t].fieldType]
							
							  //______________________________________________________
						: ((Value type:C1509($Obj_table[$t])#Is object:K8:27))
							
							  // <NOTHING MORE TO DO>
							  //________________________________________
						: ($ƒ.isRelationToOne($Obj_table[$t]))
							
							If ($Obj_table[$t].relatedTableNumber=Null:C1517)
								
								$Obj_table[$t].relatedTableNumber:=$Obj_catalog[$Obj_table[$t].relatedDataClass].getInfo().tableNumber
								
							End if 
							
							If ($Obj_table[$t].inverseName=Null:C1517)
								
								$Obj_table[$t].inverseName:=$Obj_catalog[$obj_table.name][$t].inverseName
								
							End if 
							
							For each ($tt;$Obj_table[$t])
								
								If ($ƒ.isField($tt))
									
									$Obj_table[$t][$tt].fieldNumber:=$Obj_table[$t][$tt].id
									
									$l:=$Obj_table[$t][$tt].type
									
									If ($l=10)
										
										  //#WARNING - COMPILER TYPES THE FIRST PARAMETER AS POINTER
										  //GET FIELD PROPERTIES($Obj_table[$t].relatedTableNumber;$Obj_table[$t][$tt].id;$l)
										GET FIELD PROPERTIES:C258(Num:C11($Obj_table[$t].relatedTableNumber);$Obj_table[$t][$tt].id;$l)
										
									End if 
									
									$Obj_table[$t][$tt].fieldType:=$Col_fieldTypes[$l]
									$Obj_table[$t][$tt].type:=$Col_types[$Obj_table[$t][$tt].fieldType]
									
								End if 
							End for each 
							
							  //______________________________________________________
					End case 
				End for each 
			End for each 
		End if 
		
		$Obj_project.info.version:=4
		$Boo_upgraded:=True:C214
		
	End if 
End if 


If (Bool:C1537(featuresFlags.with("newDataModel")))
	
	  //=====================================================================
	  //                    NEW DATA MODEL
	  //=====================================================================
	If (Num:C11($Obj_project.info.version)<5)
		
		If ($Obj_project.dataModel#Null:C1517)
			
			For each ($Txt_tableNumber;$Obj_project.dataModel)
				
				$Obj_table:=$Obj_project.dataModel[$Txt_tableNumber]
				
				$Obj_table[""]:=New object:C1471(\
					"name";$Obj_table.name;\
					"label";$Obj_table.label;\
					"shortLabel";$Obj_table.shortLabel;\
					"primaryKey";$Obj_table.primaryKey;\
					"embedded";True:C214\
					)
				
				If (Bool:C1537($Obj_table.embedded))
					
					$Obj_table[""].embedded:=True:C214
					
				End if 
				
				If (Length:C16(String:C10($Obj_table.icon))>0)
					
					$Obj_table[""].icon:=$Obj_table.icon
					
				End if 
				
				OB REMOVE:C1226($Obj_table;"name")
				OB REMOVE:C1226($Obj_table;"label")
				OB REMOVE:C1226($Obj_table;"shortLabel")
				OB REMOVE:C1226($Obj_table;"primaryKey")
				OB REMOVE:C1226($Obj_table;"embedded")
				OB REMOVE:C1226($Obj_table;"icon")
				
			End for each 
		End if 
		
		  //*****************************
		  //$Obj_project.info.version:=5
		  //*****************************
		  //$Boo_upgraded:=True
		
	End if 
	
	
	  //=====================================================================
	  //                              MISCELLANEOUS
	  //=====================================================================
	If ($Obj_project.dataModel#Null:C1517)
		
		For each ($Txt_tableNumber;$Obj_project.dataModel)
			
			For each ($Txt_fieldID;$Obj_project.dataModel[$Txt_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldID;1;*))
					
					If (String:C10($Obj_project.dataModel[$Txt_tableNumber][$Txt_fieldID].icon)="")
						
						OB REMOVE:C1226($Obj_project.dataModel[$Txt_tableNumber][$Txt_fieldID];"icon")
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
End if 


  // Set the current version
$Obj_project.info.componentBuild:=$Obj_info.componentBuild
$Obj_project.info.ideVersion:=$Obj_info.ideVersion
$Obj_project.info.ideBuildVersion:=$Obj_info.ideBuildVersion

  // ----------------------------------------------------
  // Return
$0:=$Boo_upgraded

  // ----------------------------------------------------
  // End