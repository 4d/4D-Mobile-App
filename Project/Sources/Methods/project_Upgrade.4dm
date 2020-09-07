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

C_BOOLEAN:C305($b_upgraded)
C_LONGINT:C283($l)
C_TEXT:C284($t; $tField; $tRelated; $tTable)
C_OBJECT:C1216($file; $o; $o_project; $oCatalog; $oDatabase)
C_OBJECT:C1216($oInfos; $oInternal; $oTable; $oTemplate)
C_COLLECTION:C1488($c; $cFieldTypes; $cTypes)

If (False:C215)
	C_BOOLEAN:C305(project_Upgrade; $0)
	C_OBJECT:C1216(project_Upgrade; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$o_project:=$1  // Project definition
	
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Form:C1466#Null:C1517)
	
	// Rename cache.json -> catalog.json
	If (Test path name:C476(Form:C1466.root+"cache.json")=Is a document:K24:1)
		
		COPY DOCUMENT:C541(Form:C1466.root+"cache.json"; Form:C1466.root; "catalog.json"; *)
		DELETE DOCUMENT:C159(Form:C1466.root+"cache.json")
		
	End if 
End if 

// Create current information to compare
$oInfos:=New object:C1471

$o:=xml_fileToObject(Get 4D folder:C485(Database folder:K5:14)+"Info.plist").value.plist.dict

$l:=$o.key.extract("$").indexOf("CFBundleVersion")

If ($l#-1)
	
	$oInfos.componentBuild:=String:C10($o.string[$l].$)
	
End if 

$oInfos.ideVersion:=SHARED.ide.version
$oInfos.ideBuildVersion:=String:C10(SHARED.ide.build)

If ($o_project.info.ideVersion=Null:C1517)  // "1720"
	
	If (Value type:C1509($o_project.dataModel)=Is object:K8:27)
		
		/// Remove first / on icon path #100580
		For each ($tTable; $o_project.dataModel)
			
			$t:=String:C10($o_project.dataModel[$tTable].icon)
			
			If (Position:C15("/"; $t)=1)
				
				$o_project.dataModel[$tTable].icon:=Delete string:C232($t; 1; 1)
				$b_upgraded:=True:C214
				
			End if 
			
			For each ($tField; $o_project.dataModel[$tTable])
				
				If (Match regex:C1019("(?m-si)^\\d+$"; $tField; 1; *))
					
					$t:=String:C10($o_project.dataModel[$tTable][$tField].icon)
					
					If (Position:C15("/"; $t)=1)
						
						$o_project.dataModel[$tTable][$tField].icon:=Delete string:C232($t; 1; 1)
						$b_upgraded:=True:C214
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	// Rename internal templates
	If ($o_project.detail#Null:C1517)
		
		For each ($tTable; $o_project.detail)
			
			Case of 
					
					//______________________________________________________
				: ($o_project.detail[$tTable].form=Null:C1517)
					
					//______________________________________________________
				: ($o_project.detail[$tTable].form="Cards Detail")
					
					$o_project.detail[$tTable].form:="Cards"
					
					//______________________________________________________
				: ($o_project.detail[$tTable].form="Numbers Detail")
					
					$o_project.detail[$tTable].form:="Numbers"
					
					//______________________________________________________
				: ($o_project.detail[$tTable].form="Tasks Detail")
					
					$o_project.detail[$tTable].form:="Tasks"
					
					//______________________________________________________
				: ($o_project.detail[$tTable].form="Tasks Detail Plus")
					
					$o_project.detail[$tTable].form:="Tasks Plus"
					
					//______________________________________________________
			End case 
		End for each 
	End if 
	
	If ($o_project.list#Null:C1517)
		
		For each ($tTable; $o_project.list)
			
			If ($o_project.list[$tTable].form#Null:C1517)
				
				Case of 
						
						//______________________________________________________
					: ($o_project.list[$tTable].form=Null:C1517)
						
						//______________________________________________________
					: ($o_project.list[$tTable].form="Profil")
						
						$o_project.list[$tTable].form:="Profile"
						
						//______________________________________________________
					: ($o_project.list[$tTable].form="Square Profil")
						
						$o_project.list[$tTable].form:="Square Profile"
						
						//______________________________________________________
					: ($o_project.list[$tTable].form="Tasks List")
						
						$o_project.list[$tTable].form:="Tasks"
						
						//______________________________________________________
				End case 
			End if 
		End for each 
	End if 
End if 

RECORD.info("Project version: "+String:C10($o_project.info.version))

If (Num:C11($o_project.info.version)<2)
	
	// Add datasource property if any
	If ($o_project.dataSource=Null:C1517)
		
		$o_project.dataSource:=New object:C1471(\
			"source"; "local"; \
			"doNotGenerateDataAtEachBuild"; False:C215)
		
		$b_upgraded:=True:C214
		
	End if 
	
	If ($o_project.dataModel#Null:C1517)
		
		For each ($tTable; $o_project.dataModel)
			
			If ($o_project.dataModel[$tTable].embedded=Null:C1517)
				
				$o_project.dataModel[$tTable].embedded:=True:C214
				
			End if 
		End for each 
		
		$b_upgraded:=True:C214
		
	End if 
	
	$o_project.info.version:=2
	RECORD.warning("Upadted to version: "+String:C10($o_project.info.version))
	
End if 

//=====================================================================
//                 REORGANIZATION FIX AND RENAMING
//=====================================================================
If (Num:C11($o_project.info.version)<3)
	
	If ($o_project.dataModel#Null:C1517)
		
		For each ($tTable; $o_project.dataModel)
			
			$oTable:=$o_project.dataModel[$tTable]
			
			$o:=$oTable.primary_key
			
			If ($o=Null:C1517)
				
				$o:=$oTable["primary_key:"]
				
			End if 
			
			If ($o#Null:C1517)
				
				OB REMOVE:C1226($oTable; "primary_key")
				OB REMOVE:C1226($oTable; "primary_key:")
				
				$oTable.primaryKey:=String:C10($o.field_name)
				
				$b_upgraded:=True:C214
				
			End if 
		End for each 
		
		$o_project.info.version:=3
		RECORD.warning("Upadted to version: "+String:C10($o_project.info.version))
		
	End if 
End if 

//=====================================================================
//                    NEW FIELD DESCRIPTION
//=====================================================================
If (Num:C11($o_project.info.version)<4)
	
	// Remap field type
	
	If (Value type:C1509($o_project.dataModel)=Is object:K8:27)
		
		If (Value type:C1509($o_project.dataModel)=Is object:K8:27)
			
			// Update dataModel to be compliant with ds
			
			$cFieldTypes:=New collection:C1472
			$cFieldTypes[0]:=Is alpha field:K8:1
			$cFieldTypes[1]:=Is boolean:K8:9
			$cFieldTypes[3]:=Is integer:K8:5
			$cFieldTypes[4]:=Is longint:K8:6
			$cFieldTypes[5]:=Is integer 64 bits:K8:25
			$cFieldTypes[6]:=Is real:K8:4
			$cFieldTypes[7]:=_o_Is float:K8:26
			$cFieldTypes[8]:=Is date:K8:7
			$cFieldTypes[9]:=Is time:K8:8
			$cFieldTypes[10]:=Is text:K8:3
			$cFieldTypes[12]:=Is picture:K8:10
			$cFieldTypes[18]:=Is BLOB:K8:12
			$cFieldTypes[21]:=Is object:K8:27
			
			$cTypes:=New collection:C1472
			$cTypes[Is alpha field:K8:1]:="string"
			$cTypes[Is boolean:K8:9]:="bool"
			$cTypes[Is integer:K8:5]:="number"
			$cTypes[Is longint:K8:6]:="number"
			$cTypes[Is integer 64 bits:K8:25]:="number"
			$cTypes[Is real:K8:4]:="number"
			$cTypes[_o_Is float:K8:26]:="number"
			$cTypes[Is date:K8:7]:="date"
			$cTypes[Is time:K8:8]:="time"  // WARNING: for ds it's a number, but I think we must do the distinguo
			$cTypes[Is text:K8:3]:="string"
			$cTypes[Is picture:K8:10]:="image"
			$cTypes[Is BLOB:K8:12]:="blob"
			$cTypes[Is object:K8:27]:="object"
			
			$oCatalog:=_4D_Build Exposed Datastore:C1598
			
			For each ($tTable; $o_project.dataModel)
				
				$oTable:=$o_project.dataModel[$tTable]
				
				For each ($tField; $oTable)
					
					Case of 
							
							//______________________________________________________
						: (PROJECT.isField($tField))
							
							$oTable[$tField].fieldNumber:=$oTable[$tField].id
							$oTable[$tField].fieldType:=$cFieldTypes[$oTable[$tField].type]
							$oTable[$tField].type:=$cTypes[$oTable[$tField].fieldType]
							
							//______________________________________________________
						: ((Value type:C1509($oTable[$tField])#Is object:K8:27))
							
							// <NOTHING MORE TO DO>
							//________________________________________
						: (PROJECT.isRelationToOne($oTable[$tField]))
							
							If ($oTable[$tField].relatedTableNumber=Null:C1517)
								
								$oTable[$tField].relatedTableNumber:=$oCatalog[$oTable[$tField].relatedDataClass].getInfo().tableNumber
								
							End if 
							
							If ($oTable[$tField].inverseName=Null:C1517)
								
								$oTable[$tField].inverseName:=$oCatalog[$oTable.name][$tField].inverseName
								
							End if 
							
							For each ($tRelated; $oTable[$tField])
								
								If (PROJECT.isField($tRelated))
									
									$oTable[$tField][$tRelated].fieldNumber:=$oTable[$tField][$tRelated].id
									
									$l:=$oTable[$tField][$tRelated].type
									
									If ($l=10)
										
										//#WARNING - COMPILER TYPES THE FIRST PARAMETER AS POINTER
										//GET FIELD PROPERTIES($Obj_table[$t].relatedTableNumber;$Obj_table[$t][$tt].id;$l)
										GET FIELD PROPERTIES:C258(Num:C11($oTable[$tField].relatedTableNumber); $oTable[$tField][$tRelated].id; $l)
										
									End if 
									
									$oTable[$tField][$tRelated].fieldType:=$cFieldTypes[$l]
									$oTable[$tField][$tRelated].type:=$cTypes[$oTable[$tField][$tRelated].fieldType]
									
								End if 
							End for each 
							
							//______________________________________________________
					End case 
				End for each 
			End for each 
		End if 
		
		$b_upgraded:=True:C214
		
		$o_project.info.version:=4
		RECORD.warning("Upadted to version: "+String:C10($o_project.info.version))
		
	End if 
End if 

//=====================================================================
//                    NEW DATA MODEL
//=====================================================================
If (Num:C11($o_project.info.version)<5)
	
	If ($o_project.dataModel#Null:C1517)
		
		For each ($tTable; $o_project.dataModel)
			
			$oTable:=$o_project.dataModel[$tTable]
			
			If ($oTable[""]=Null:C1517)
				
				$oTable[""]:=New object:C1471(\
					"name"; $oTable.name; \
					"label"; $oTable.label; \
					"shortLabel"; $oTable.shortLabel; \
					"primaryKey"; $oTable.primaryKey\
					)
				
				OB REMOVE:C1226($oTable; "name")
				OB REMOVE:C1226($oTable; "label")
				OB REMOVE:C1226($oTable; "shortLabel")
				OB REMOVE:C1226($oTable; "primaryKey")
				
				If (Bool:C1537($oTable.embedded))
					
					$oTable[""].embedded:=True:C214
					
				End if 
				
				OB REMOVE:C1226($oTable; "embedded")
				
				If (Length:C16(String:C10($oTable.icon))>0)
					
					$oTable[""].icon:=$oTable.icon
					
				End if 
				
				OB REMOVE:C1226($oTable; "icon")
				
				//#ACI0100305
				If ($oTable.filter#Null:C1517)
					
					$oTable[""].filter:=$oTable.filter
					OB REMOVE:C1226($oTable; "filter")
					
				End if 
			End if 
		End for each 
		
		$b_upgraded:=True:C214
		
	End if 
	
	$o_project.info.version:=5
	RECORD.warning("Upadted to version: "+String:C10($o_project.info.version))
	
End if 

//=====================================================================
//                     "Simple List" -> "Blank Form"
//=====================================================================
If ($o_project.detail#Null:C1517)
	
	For each ($tTable; $o_project.detail)
		
		If (String:C10($o_project.detail[$tTable].form)="Simple List")
			
			$o_project.detail[$tTable].form:="Blank Form"
			
		End if 
	End for each 
End if 

//=====================================================================
//                              MISCELLANEOUS
//=====================================================================
If ($o_project.dataModel#Null:C1517)
	
	For each ($tTable; $o_project.dataModel)
		
		For each ($tField; $o_project.dataModel[$tTable])
			
			If (Match regex:C1019("(?m-si)^\\d+$"; $tField; 1; *))
				
				If (String:C10($o_project.dataModel[$tTable][$tField].icon)="")
					
					OB REMOVE:C1226($o_project.dataModel[$tTable][$tField]; "icon")
					
				End if 
			End if 
		End for each 
	End for each 
End if 

If (FEATURE.with("resourcesBrowser"))
	
	If ($o_project.list#Null:C1517)
		
		RECORD.info("Check list forms")
		
		$oInternal:=path.listForms()
		$oDatabase:=path.hostlistForms()
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/Compatibility/manifest.json").getText()).list
		
		For each ($tTable; $o_project.list)
			
			$t:=String:C10($o_project.list[$tTable].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($oInternal.folder($t).exists))
						
						RECORD.warning("Missing internal form: "+$t)
						
						// Ensure database folder exists
						$oDatabase.create()
						
						$oTemplate:=$c.query("old=:1"; $t).pop()
						
						If ($oTemplate#Null:C1517)
							
							// Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/Compatibility/"+$oTemplate.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($oDatabase; fk overwrite:K87:5)
								
								If ($file#Null:C1517)
									
									$o_project.list[$tTable].form:="/"+$oTemplate.new
									RECORD.info("Replaced by: "+$o_project.list[$tTable].form)
									
								Else 
									
									RECORD.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								RECORD.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							RECORD.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	If ($o_project.detail#Null:C1517)
		
		RECORD.info("Check detail forms")
		
		$oInternal:=path.detailForms()
		$oDatabase:=path.hostdetailForms()
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/Compatibility/manifest.json").getText()).detail
		
		For each ($tTable; $o_project.detail)
			
			$t:=String:C10($o_project.detail[$tTable].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($oInternal.folder($t).exists))
						
						RECORD.warning("Missing internal form: "+$t)
						
						// Ensure database folder exists
						$oDatabase.create()
						
						$oTemplate:=$c.query("old=:1"; $t).pop()
						
						If ($oTemplate#Null:C1517)
							
							// Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/Compatibility/"+$oTemplate.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($oDatabase; fk overwrite:K87:5)
								
								If ($file#Null:C1517)
									
									$o_project.detail[$tTable].form:="/"+$oTemplate.new
									RECORD.info("Replaced by: "+$o_project.detail[$tTable].form)
									
								Else 
									
									RECORD.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								RECORD.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							RECORD.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
End if 

// Set the current version
$o_project.info.componentBuild:=$oInfos.componentBuild
$o_project.info.ideVersion:=$oInfos.ideVersion
$o_project.info.ideBuildVersion:=$oInfos.ideBuildVersion

// ----------------------------------------------------
// Return
$0:=$b_upgraded  // True if project was modified

// ----------------------------------------------------
// End