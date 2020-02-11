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

C_BOOLEAN:C305($bUpgraded)
C_LONGINT:C283($l;$Lon_build;$Lon_parameters)
C_TEXT:C284($t;$t_field;$t_related;$t_tableNumber)
C_OBJECT:C1216($file;$ƒ;$logger;$o;$o_catalog;$o_infos)
C_OBJECT:C1216($oDatabase;$oInternal;$oProject;$oTable;$oTemplate)
C_COLLECTION:C1488($c;$Col_fieldTypes;$Col_types)

If (False:C215)
	C_BOOLEAN:C305(project_Upgrade ;$0)
	C_OBJECT:C1216(project_Upgrade ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	$oProject:=$1
	
	$ƒ:=Storage:C1525.ƒ
	
Else 
	
	ABORT:C156
	
End if 

$logger:=logger ("~/Library/Logs/4D Mobile/"+String:C10($oProject.product.name)+".log").reset()
$logger.verbose:=True:C214

  // ----------------------------------------------------
If (Form:C1466#Null:C1517)
	
	  // Rename cache.json -> catalog.json
	If (Test path name:C476(Form:C1466.root+"cache.json")=Is a document:K24:1)
		
		COPY DOCUMENT:C541(Form:C1466.root+"cache.json";Form:C1466.root;"catalog.json";*)
		DELETE DOCUMENT:C159(Form:C1466.root+"cache.json")
		
	End if 
End if 

  // Create current information to compare
$o_infos:=New object:C1471

$o:=xml_fileToObject (Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict

$l:=$o.key.extract("$").indexOf("CFBundleVersion")

If ($l#-1)
	
	$o_infos.componentBuild:=String:C10($o.string[$l].$)
	
End if 

$o_infos.ideVersion:=String:C10(Application version:C493($Lon_build))
$o_infos.ideBuildVersion:=String:C10($Lon_build)

If ($oProject.info.ideVersion=Null:C1517)  // "1720"
	
	If (Value type:C1509($oProject.dataModel)=Is object:K8:27)
		
		  /// Remove first / on icon path #100580
		For each ($t_tableNumber;$oProject.dataModel)
			
			$t:=String:C10($oProject.dataModel[$t_tableNumber].icon)
			
			If (Position:C15("/";$t)=1)
				
				$oProject.dataModel[$t_tableNumber].icon:=Delete string:C232($t;1;1)
				$bUpgraded:=True:C214
				
			End if 
			
			For each ($t_field;$oProject.dataModel[$t_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$t_field;1;*))
					
					$t:=String:C10($oProject.dataModel[$t_tableNumber][$t_field].icon)
					
					If (Position:C15("/";$t)=1)
						
						$oProject.dataModel[$t_tableNumber][$t_field].icon:=Delete string:C232($t;1;1)
						$bUpgraded:=True:C214
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	  // Rename internal templates
	If ($oProject.detail#Null:C1517)
		
		For each ($t_tableNumber;$oProject.detail)
			
			Case of 
					
					  //______________________________________________________
				: ($oProject.detail[$t_tableNumber].form=Null:C1517)
					
					  //______________________________________________________
				: ($oProject.detail[$t_tableNumber].form="Cards Detail")
					
					$oProject.detail[$t_tableNumber].form:="Cards"
					
					  //______________________________________________________
				: ($oProject.detail[$t_tableNumber].form="Numbers Detail")
					
					$oProject.detail[$t_tableNumber].form:="Numbers"
					
					  //______________________________________________________
				: ($oProject.detail[$t_tableNumber].form="Tasks Detail")
					
					$oProject.detail[$t_tableNumber].form:="Tasks"
					
					  //______________________________________________________
				: ($oProject.detail[$t_tableNumber].form="Tasks Detail Plus")
					
					$oProject.detail[$t_tableNumber].form:="Tasks Plus"
					
					  //______________________________________________________
			End case 
		End for each 
	End if 
	
	If ($oProject.list#Null:C1517)
		
		For each ($t_tableNumber;$oProject.list)
			
			If ($oProject.list[$t_tableNumber].form#Null:C1517)
				
				Case of 
						
						  //______________________________________________________
					: ($oProject.list[$t_tableNumber].form=Null:C1517)
						
						  //______________________________________________________
					: ($oProject.list[$t_tableNumber].form="Profil")
						
						$oProject.list[$t_tableNumber].form:="Profile"
						
						  //______________________________________________________
					: ($oProject.list[$t_tableNumber].form="Square Profil")
						
						$oProject.list[$t_tableNumber].form:="Square Profile"
						
						  //______________________________________________________
					: ($oProject.list[$t_tableNumber].form="Tasks List")
						
						$oProject.list[$t_tableNumber].form:="Tasks"
						
						  //______________________________________________________
				End case 
			End if 
		End for each 
	End if 
End if 

$logger.info("Version: "+String:C10($oProject.info.version))

If (Num:C11($oProject.info.version)<2)
	
	  // Add datasource property if any
	If ($oProject.dataSource=Null:C1517)
		
		$oProject.dataSource:=New object:C1471(\
			"source";"local";\
			"doNotGenerateDataAtEachBuild";False:C215)
		
		$bUpgraded:=True:C214
		
	End if 
	
	If ($oProject.dataModel#Null:C1517)
		
		For each ($t_tableNumber;$oProject.dataModel)
			
			If ($oProject.dataModel[$t_tableNumber].embedded=Null:C1517)
				
				$oProject.dataModel[$t_tableNumber].embedded:=True:C214
				
			End if 
		End for each 
		
		$bUpgraded:=True:C214
		
	End if 
	
	$oProject.info.version:=2
	$logger.info("Upadted to version: "+String:C10($oProject.info.version))
	
End if 

  //=====================================================================
  //                 REORGANIZATION FIX AND RENAMING
  //=====================================================================
If (Num:C11($oProject.info.version)<3)
	
	If ($oProject.dataModel#Null:C1517)
		
		For each ($t_tableNumber;$oProject.dataModel)
			
			$oTable:=$oProject.dataModel[$t_tableNumber]
			
			$o:=$oTable.primary_key
			
			If ($o=Null:C1517)
				
				$o:=$oTable["primary_key:"]
				
			End if 
			
			If ($o#Null:C1517)
				
				OB REMOVE:C1226($oTable;"primary_key")
				OB REMOVE:C1226($oTable;"primary_key:")
				
				$oTable.primaryKey:=String:C10($o.field_name)
				
				$bUpgraded:=True:C214
				
			End if 
		End for each 
		
		$oProject.info.version:=3
		$logger.info("Upadted to version: "+String:C10($oProject.info.version))
		
	End if 
End if 

  //=====================================================================
  //                    NEW FIELD DESCRIPTION
  //=====================================================================
If (Num:C11($oProject.info.version)<4)
	
	  // Remap field type
	
	If (Value type:C1509($oProject.dataModel)=Is object:K8:27)
		
		If (Value type:C1509($oProject.dataModel)=Is object:K8:27)
			
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
			
			$o_catalog:=_4D_Build Exposed Datastore:C1598
			
			For each ($t_tableNumber;$oProject.dataModel)
				
				$oTable:=$oProject.dataModel[$t_tableNumber]
				
				For each ($t_field;$oTable)
					
					Case of 
							
							  //______________________________________________________
						: ($ƒ.isField($t_field))
							
							$oTable[$t_field].fieldNumber:=$oTable[$t_field].id
							$oTable[$t_field].fieldType:=$Col_fieldTypes[$oTable[$t_field].type]
							$oTable[$t_field].type:=$Col_types[$oTable[$t_field].fieldType]
							
							  //______________________________________________________
						: ((Value type:C1509($oTable[$t_field])#Is object:K8:27))
							
							  // <NOTHING MORE TO DO>
							  //________________________________________
						: ($ƒ.isRelationToOne($oTable[$t_field]))
							
							If ($oTable[$t_field].relatedTableNumber=Null:C1517)
								
								$oTable[$t_field].relatedTableNumber:=$o_catalog[$oTable[$t_field].relatedDataClass].getInfo().tableNumber
								
							End if 
							
							If ($oTable[$t_field].inverseName=Null:C1517)
								
								$oTable[$t_field].inverseName:=$o_catalog[$oTable.name][$t_field].inverseName
								
							End if 
							
							For each ($t_related;$oTable[$t_field])
								
								If ($ƒ.isField($t_related))
									
									$oTable[$t_field][$t_related].fieldNumber:=$oTable[$t_field][$t_related].id
									
									$l:=$oTable[$t_field][$t_related].type
									
									If ($l=10)
										
										  //#WARNING - COMPILER TYPES THE FIRST PARAMETER AS POINTER
										  //GET FIELD PROPERTIES($Obj_table[$t].relatedTableNumber;$Obj_table[$t][$tt].id;$l)
										GET FIELD PROPERTIES:C258(Num:C11($oTable[$t_field].relatedTableNumber);$oTable[$t_field][$t_related].id;$l)
										
									End if 
									
									$oTable[$t_field][$t_related].fieldType:=$Col_fieldTypes[$l]
									$oTable[$t_field][$t_related].type:=$Col_types[$oTable[$t_field][$t_related].fieldType]
									
								End if 
							End for each 
							
							  //______________________________________________________
					End case 
				End for each 
			End for each 
		End if 
		
		$bUpgraded:=True:C214
		
		$oProject.info.version:=4
		$logger.info("Upadted to version: "+String:C10($oProject.info.version))
		
	End if 
End if 

If (featuresFlags.with("newDataModel"))
	
	  //=====================================================================
	  //                    NEW DATA MODEL
	  //=====================================================================
	If (Num:C11($oProject.info.version)<5)
		
		If ($oProject.dataModel#Null:C1517)
			
			For each ($t_tableNumber;$oProject.dataModel)
				
				$oTable:=$oProject.dataModel[$t_tableNumber]
				
				If ($oTable[""]=Null:C1517)
					
					$oTable[""]:=New object:C1471(\
						"name";$oTable.name;\
						"label";$oTable.label;\
						"shortLabel";$oTable.shortLabel;\
						"primaryKey";$oTable.primaryKey\
						)
					
					OB REMOVE:C1226($oTable;"name")
					OB REMOVE:C1226($oTable;"label")
					OB REMOVE:C1226($oTable;"shortLabel")
					OB REMOVE:C1226($oTable;"primaryKey")
					
					If (Bool:C1537($oTable.embedded))
						
						$oTable[""].embedded:=True:C214
						
					End if 
					
					OB REMOVE:C1226($oTable;"embedded")
					
					If (Length:C16(String:C10($oTable.icon))>0)
						
						$oTable[""].icon:=$oTable.icon
						
					End if 
					
					OB REMOVE:C1226($oTable;"icon")
					
					  //#ACI0100305
					If ($oTable.filter#Null:C1517)
						
						$oTable[""].filter:=$oTable.filter
						OB REMOVE:C1226($oTable;"filter")
						
					End if 
				End if 
			End for each 
			
			$bUpgraded:=True:C214
			
		End if 
		
		$oProject.info.version:=5
		$logger.info("Upadted to version: "+String:C10($oProject.info.version))
		
	End if 
	
	  //=====================================================================
	  //                     "Simple List" -> "Blank Form"
	  //=====================================================================
	If ($oProject.detail#Null:C1517)
		
		For each ($t_tableNumber;$oProject.detail)
			
			If (String:C10($oProject.detail[$t_tableNumber].form)="Simple List")
				
				$oProject.detail[$t_tableNumber].form:="Blank Form"
				
			End if 
		End for each 
	End if 
	
	  //=====================================================================
	  //                              MISCELLANEOUS
	  //=====================================================================
	If ($oProject.dataModel#Null:C1517)
		
		For each ($t_tableNumber;$oProject.dataModel)
			
			For each ($t_field;$oProject.dataModel[$t_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$t_field;1;*))
					
					If (String:C10($oProject.dataModel[$t_tableNumber][$t_field].icon)="")
						
						OB REMOVE:C1226($oProject.dataModel[$t_tableNumber][$t_field];"icon")
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
End if 

If (featuresFlags.with("resourcesBrowser"))
	
	If ($oProject.list#Null:C1517)
		
		$logger.info("Check list forms")
		
		$oInternal:=path .listForms()
		$oDatabase:=path .hostlistForms()
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/TEMPO/manifest.json").getText()).list
		
		For each ($t_tableNumber;$oProject.list)
			
			$t:=String:C10($oProject.list[$t_tableNumber].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($oInternal.folder($t).exists))
						
						$logger.warning("Missing internal form: "+$t)
						
						  // Ensure database folder exists
						$oDatabase.create()
						
						$oTemplate:=$c.query("old=:1";$t).pop()
						
						If ($oTemplate#Null:C1517)
							
							  // Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/TEMPO/"+$oTemplate.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($oDatabase)
								
								If ($file#Null:C1517)
									
									$oProject.list[$t_tableNumber].form:="/"+$oTemplate.new
									$logger.info("Replaced by: "+$oProject.list[$t_tableNumber].form)
									
								Else 
									
									$logger.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								$logger.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							$logger.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	If ($oProject.detail#Null:C1517)
		
		$logger.info("Check detail forms")
		
		$oInternal:=path .detailForms()
		$oDatabase:=path .hostdetailForms()
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/TEMPO/manifest.json").getText()).detail
		
		For each ($t_tableNumber;$oProject.detail)
			
			$t:=String:C10($oProject.detail[$t_tableNumber].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($oInternal.folder($t).exists))
						
						$logger.warning("Missing internal form: "+$t)
						
						  // Ensure database folder exists
						$oDatabase.create()
						
						$oTemplate:=$c.query("old=:1";$t).pop()
						
						If ($oTemplate#Null:C1517)
							
							  // Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/TEMPO/"+$oTemplate.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($oDatabase)
								
								If ($file#Null:C1517)
									
									$oProject.detail[$t_tableNumber].form:="/"+$oTemplate.new
									$logger.info("Replaced by: "+$oProject.detail[$t_tableNumber].form)
									
								Else 
									
									$logger.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								$logger.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							$logger.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
End if 

If (Not:C34(Is compiled mode:C492) & Shift down:C543)
	
	$logger.open()
	
End if 

  // Set the current version
$oProject.info.componentBuild:=$o_infos.componentBuild
$oProject.info.ideVersion:=$o_infos.ideVersion
$oProject.info.ideBuildVersion:=$o_infos.ideBuildVersion

  // ----------------------------------------------------
  // Return
$0:=$bUpgraded

  // ----------------------------------------------------
  // End