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
#DECLARE($project : Object; $folder : 4D:C1709.Folder)->$isUpgraded : Boolean

If (False:C215)
	C_OBJECT:C1216(project_Upgrade; $1)
	C_OBJECT:C1216(project_Upgrade; $2)
	C_BOOLEAN:C305(project_Upgrade; $0)
End if 

var $fieldID; $relatedID; $t; $tableID; $tt : Text
var $picture : Picture
var $type : Integer
var $exposedDatastore; $info; $o; $table; $template : Object
var $c; $catalog; $fieldTypes; $types : Collection
var $file : 4D:C1709.File
var $internalFolder; $userFolder : 4D:C1709.Folder
var $field : cs:C1710.field
var $path : cs:C1710.path
var $plist : cs:C1710.plist

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$path:=cs:C1710.path.new()
	
	$info:=New object:C1471
	
	$plist:=cs:C1710.plist.new(File:C1566("/PACKAGE/Info.plist"))
	
Else 
	
	ABORT:C156
	
End if 

If ($project.targetBackup#Null:C1517)
	
	// Restore
	$project.info.target:=$project.targetBackup
	OB REMOVE:C1226($project; "targetBackup")
	
End if 

// ----------------------------------------------------
// RENAME cache.json -> catalog.json
If (Form:C1466#Null:C1517)
	
	$file:=Form:C1466.folder.file("cache.json")
	
	If ($file.exists)
		
		$file.copyTo(Form:C1466.folder; "catalog.json"; fk overwrite:K87:5)
		$file.delete()
		
	End if 
End if 

// Create current information to compare
$info.componentBuild:=$plist.success ? $plist.get("CFBundleVersion") : SHARED.componentBuild

$info.ideVersion:=SHARED.ide.version
$info.ideBuildVersion:=String:C10(SHARED.ide.build)

If ($project.info.ideVersion=Null:C1517)  // "1720"
	
	// * REMOVE FIRST "/" ON ICON PATH #100580
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			$t:=String:C10($project.dataModel[$tableID].icon)
			
			If (Position:C15("/"; $t)=1)
				
				$project.dataModel[$tableID].icon:=Delete string:C232($t; 1; 1)
				$isUpgraded:=True:C214
				
			End if 
			
			For each ($fieldID; $project.dataModel[$tableID])
				
				If (Match regex:C1019("(?m-si)^\\d+$"; $fieldID; 1; *))
					
					$t:=String:C10($project.dataModel[$tableID][$fieldID].icon)
					
					If (Position:C15("/"; $t)=1)
						
						$project.dataModel[$tableID][$fieldID].icon:=Delete string:C232($t; 1; 1)
						$isUpgraded:=True:C214
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	// * RENAME INTERNAL DETAIL TEMPLATES
	If ($project.detail#Null:C1517)
		
		For each ($tableID; $project.detail)
			
			Case of 
					
					//______________________________________________________
				: ($project.detail[$tableID].form=Null:C1517)
					
					//______________________________________________________
				: ($project.detail[$tableID].form="Simple List")  // "Simple List" -> "Blank Form"
					
					$project.detail[$tableID].form:="Blank Form"
					
					//______________________________________________________
				: ($project.detail[$tableID].form="Cards Detail")
					
					$project.detail[$tableID].form:="Cards"
					
					//______________________________________________________
				: ($project.detail[$tableID].form="Numbers Detail")
					
					$project.detail[$tableID].form:="Numbers"
					
					//______________________________________________________
				: ($project.detail[$tableID].form="Tasks Detail")
					
					$project.detail[$tableID].form:="Tasks"
					
					//______________________________________________________
				: ($project.detail[$tableID].form="Tasks Detail Plus")
					
					$project.detail[$tableID].form:="Tasks Plus"
					
					//______________________________________________________
			End case 
		End for each 
	End if 
	
	// * RENAME INTERNAL LIST TEMPLATES
	If ($project.list#Null:C1517)
		
		For each ($tableID; $project.list)
			
			If ($project.list[$tableID].form#Null:C1517)
				
				Case of 
						
						//______________________________________________________
					: ($project.list[$tableID].form=Null:C1517)
						
						//______________________________________________________
					: ($project.list[$tableID].form="Profil")
						
						$project.list[$tableID].form:="Profile"
						
						//______________________________________________________
					: ($project.list[$tableID].form="Square Profil")
						
						$project.list[$tableID].form:="Square Profile"
						
						//______________________________________________________
					: ($project.list[$tableID].form="Tasks List")
						
						$project.list[$tableID].form:="Tasks"
						
						//______________________________________________________
				End case 
			End if 
		End for each 
	End if 
End if 

Logger.info("Project version: "+String:C10($project.info.version))

// MARK:v2
If (Num:C11($project.info.version)<2)
	
	// * ADD DATASOURCE PROPERTY
	If ($project.dataSource=Null:C1517)
		
		$project.dataSource:=New object:C1471(\
			"source"; "local"; \
			"doNotGenerateDataAtEachBuild"; False:C215)
		
		$isUpgraded:=True:C214
		
	End if 
	
	// * SET DEFAULT EMBEDDED PROPERTY, IF ANY
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			If ($project.dataModel[$tableID].embedded=Null:C1517)
				
				$project.dataModel[$tableID].embedded:=True:C214
				
			End if 
		End for each 
		
		$isUpgraded:=True:C214
		
	End if 
	
	$project.info.version:=2
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:v3 -REORGANIZATION FIX AND RENAMING
If (Num:C11($project.info.version)<3)
	
	// *CHANGE PRIMARY KEY PROPERTY
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			$table:=$project.dataModel[$tableID]
			
			$o:=$table.primary_key
			
			If ($o=Null:C1517)
				
				$o:=$table["primary_key:"]
				
			End if 
			
			If ($o#Null:C1517)
				
				OB REMOVE:C1226($table; "primary_key")
				OB REMOVE:C1226($table; "primary_key:")
				
				$table.primaryKey:=String:C10($o.field_name)
				
				$isUpgraded:=True:C214
				
			End if 
		End for each 
		
		$project.info.version:=3
		Logger.warning("Updated to version: "+String:C10($project.info.version))
		
	End if 
End if 

// MARK:v4 - NEW FIELD DESCRIPTION
If (Num:C11($project.info.version)<=4)
	
	// *REMAP FIELD TYPE TO BE COMPLIANT WITH DS
	If ($project.dataModel#Null:C1517)
		
		$fieldTypes:=New collection:C1472
		$fieldTypes[0]:=Is alpha field:K8:1
		$fieldTypes[1]:=Is boolean:K8:9
		$fieldTypes[3]:=Is integer:K8:5
		$fieldTypes[4]:=Is longint:K8:6
		$fieldTypes[5]:=Is integer 64 bits:K8:25
		$fieldTypes[6]:=Is real:K8:4
		$fieldTypes[7]:=_o_Is float:K8:26
		$fieldTypes[8]:=Is date:K8:7
		$fieldTypes[9]:=Is time:K8:8
		$fieldTypes[10]:=Is text:K8:3
		$fieldTypes[12]:=Is picture:K8:10
		$fieldTypes[18]:=Is BLOB:K8:12
		$fieldTypes[21]:=Is object:K8:27
		
		$types:=New collection:C1472
		$types[Is alpha field:K8:1]:="string"
		$types[Is boolean:K8:9]:="bool"
		$types[Is integer:K8:5]:="number"
		$types[Is longint:K8:6]:="number"
		$types[Is integer 64 bits:K8:25]:="number"
		$types[Is real:K8:4]:="number"
		$types[_o_Is float:K8:26]:="number"
		$types[Is date:K8:7]:="date"
		$types[Is time:K8:8]:="time"  // #WARNING: for ds it's a number, but I think we must do the distinguo
		$types[Is text:K8:3]:="string"
		$types[Is picture:K8:10]:="image"
		$types[Is BLOB:K8:12]:="blob"
		$types[Is object:K8:27]:="object"
		
		$exposedDatastore:=_o_structure(New object:C1471("action"; "ds")).value
		$catalog:=New collection:C1472
		
		//TRACE
		
		For each ($tableID; $project.dataModel)
			
			$table:=$project.dataModel[$tableID]
			$catalog[Num:C11($tableID)]:=New collection:C1472
			
			For each ($o; OB Entries:C1720($table).query("key != ''"))
				
				Case of 
						
						//______________________________________________________
					: (PROJECT.isField(String:C10($o.key)))
						
						If (PROJECT.isNumeric($table[$o.key].type))
							
							$table[$o.key].fieldNumber:=$table[$o.key].id
							$table[$o.key].fieldType:=$fieldTypes[$table[$o.key].type]
							$table[$o.key].type:=$types[$table[$o.key].fieldType]
							
						End if 
						
						$catalog[Num:C11($tableID)].push($table[$o.key])
						
						//________________________________________
					: (PROJECT.isRelationToOne($o.value))
						
						If ($table[$o.key].relatedTableNumber=Null:C1517)
							
							$table[$o.key].relatedTableNumber:=$exposedDatastore[$table[$o.key].relatedDataClass].getInfo().tableNumber
							
						End if 
						
						If ($table[$o.key].inverseName=Null:C1517)
							
							$table[$o.key].inverseName:=$exposedDatastore[$table.name][$o.key].inverseName
							
						End if 
						
						For each ($relatedID; $table[$o.key])
							
							If (PROJECT.isField($relatedID))
								
								$table[$o.key][$relatedID].fieldNumber:=$table[$o.key][$relatedID].id
								
								If (PROJECT.isNumeric($table[$o.key][$relatedID].type))
									
									$type:=$table[$o.key][$relatedID].type
									
									If ($type=10)
										
										GET FIELD PROPERTIES:C258(Num:C11($table[$o.key].relatedTableNumber); $table[$o.key][$relatedID].id; $type)
										
									End if 
									
									$table[$o.key][$relatedID].fieldType:=$fieldTypes[$type]
									$table[$o.key][$relatedID].type:=$types[$table[$o.key][$relatedID].fieldType]
									
								End if 
							End if 
						End for each 
						
						$catalog[Num:C11($tableID)].push($table[$o.key])
						
						//______________________________________________________
				End case 
			End for each 
		End for each 
		
		// *UPDATE LIST FORMS
		If ($project.list#Null:C1517)
			
			For each ($tableID; $project.list)
				
				$table:=$project.list[$tableID]
				
				If (Not:C34(OB Is empty:C1297($table)))
					
					// *SEARCH FIELD
					$field:=$table.searchableField
					
					If ($field#Null:C1517)
						
						$o:=$catalog[Num:C11($tableID)].query("fieldNumber = :1"; $field.id).pop()
						
						If ($o#Null:C1517)
							
							$table.searchableField:=$o
							
						End if 
					End if 
					
					// *SECTION FIELD
					$field:=$table.sectionField
					
					If ($field#Null:C1517)
						
						$o:=$catalog[Num:C11($tableID)].query("id = :1"; $field.id).pop()
						
						If ($o#Null:C1517)
							
							$table.sectionField:=$o
							
						End if 
					End if 
					
					// *FIELDS
					For each ($field; $table.fields)
						
						If ($field#Null:C1517)
							
							$o:=$catalog[Num:C11($tableID)].query("fieldNumber = :1"; $field.id).pop()
							
							If ($o#Null:C1517)
								
								$o.path:=$o.name
								$table.fields[$table.fields.indices("id = :1"; $field.id)[0]]:=$o
								
							End if 
						End if 
					End for each 
				End if 
			End for each 
		End if 
		
		// *UPDATE DETAIL FORMS
		If ($project.detail#Null:C1517)
			
			For each ($tableID; $project.detail)
				
				$table:=$project.detail[$tableID]
				
				If (Not:C34(OB Is empty:C1297($table)))
					
					// *FIELDS
					For each ($field; $table.fields)
						
						If ($field#Null:C1517)
							
							$o:=$catalog[Num:C11($tableID)].query("fieldNumber = :1"; $field.id).pop()
							
							If ($o#Null:C1517)
								
								$o.path:=$o.name
								$table.fields[$table.fields.indices("id = :1"; $field.id)[0]]:=$o
								
							End if 
						End if 
					End for each 
				End if 
			End for each 
		End if 
		
		// *MISCELLANEOUS
		OB REMOVE:C1226($project; "status")
		
		$isUpgraded:=True:C214
		
	End if 
	
	$project.info.version:=4
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:v5 - NEW DATA MODEL
If (Num:C11($project.info.version)<5)
	
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			$table:=$project.dataModel[$tableID]
			
			If ($table[""]=Null:C1517)
				
				$table[""]:=New object:C1471(\
					"name"; $table.name; \
					"label"; $table.label; \
					"shortLabel"; $table.shortLabel; \
					"primaryKey"; $table.primaryKey\
					)
				
				OB REMOVE:C1226($table; "name")
				OB REMOVE:C1226($table; "label")
				OB REMOVE:C1226($table; "shortLabel")
				OB REMOVE:C1226($table; "primaryKey")
				
				If (Bool:C1537($table.embedded))
					
					$table[""].embedded:=True:C214
					
				End if 
				
				OB REMOVE:C1226($table; "embedded")
				
				If (Length:C16(String:C10($table.icon))>0)
					
					$table[""].icon:=$table.icon
					
				End if 
				
				OB REMOVE:C1226($table; "icon")
				
				//#ACI0100305
				If ($table.filter#Null:C1517)
					
					$table[""].filter:=$table.filter
					OB REMOVE:C1226($table; "filter")
					
				End if 
			End if 
		End for each 
		
		$isUpgraded:=True:C214
		
	End if 
	
	$project.info.version:=5
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:v6 - #132487
// Update old iOS project with Title and long/short label for N>1 relation
If (Num:C11($project.info.version)<6)
	
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			For each ($fieldID; $project.dataModel[$tableID])
				
				$o:=$project.dataModel[$tableID][$fieldID]
				
				If ($o.relatedDataClass#Null:C1517)  // N -> 1
					
					If ($o.format#Null:C1517)
						
						$o.label:=$o.format
						OB REMOVE:C1226($o; "format")
						
						$isUpgraded:=True:C214
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	$project.info.version:=6
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:v7 - POPULATE field.kind
If (Num:C11($project.info.version)<7)
	
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			For each ($t; $project.dataModel[$tableID])
				
				If (Length:C16($t)=0)
					
					continue
					
				End if 
				
				$field:=$project.dataModel[$tableID][$t]
				
				If ($field.kind#Null:C1517)
					
					continue
					
				End if 
				
				Case of 
						
						//______________________________________________________
					: (Match regex:C1019("^\\d+$"; $t; 1))
						
						$field.kind:="storage"
						
						//______________________________________________________
					: (Bool:C1537($field.computed))
						
						$field.kind:="calculated"
						
						//______________________________________________________
					: (Bool:C1537($field.isToMany))
						
						$field.kind:="relatedEntities"
						
						//______________________________________________________
					: ($field.relatedDataClass#Null:C1517)
						
						$field.kind:="relatedEntity"
						
						For each ($tt; $field)
							
							If (Value type:C1509($field[$tt])#Is object:K8:27)
								
								continue
								
							End if 
							
							$o:=$project.dataModel[$tableID][$t][$tt]
							
							Case of 
									//______________________________________________________
								: (Match regex:C1019("^\\d+$"; $tt; 1))
									
									$o.kind:="storage"
									
									//______________________________________________________
								: (Bool:C1537($o.computed))
									
									$o.kind:="calculated"
									
									//______________________________________________________
								: (Bool:C1537($o.isToMany))
									
									$o.kind:="relatedEntities"
									
									//______________________________________________________
								: ($o.relatedDataClass#Null:C1517)
									
									$o.kind:="relatedEntity"
									
									//______________________________________________________
								: ($o.relatedTableNumber#Null:C1517)
									
									$o.kind:="relatedEntities"
									
									//______________________________________________________
								Else 
									
									oops
									
									//______________________________________________________
							End case 
						End for each 
						
						//______________________________________________________
					: ($field.relatedTableNumber#Null:C1517)
						
						$field.kind:="relatedEntities"
						
						//______________________________________________________
					Else 
						
						oops
						
						//______________________________________________________
				End case 
			End for each 
		End for each 
		
	End if 
	
	$isUpgraded:=True:C214
	$project.info.version:=7
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:v8 - Add fieldNumber in the data model for storage
If (Num:C11($project.info.version)<8)
	
	If ($project.dataModel#Null:C1517)
		
		For each ($tableID; $project.dataModel)
			
			For each ($t; $project.dataModel[$tableID])
				
				If (Length:C16($t)=0)
					
					continue
					
				End if 
				
				$field:=$project.dataModel[$tableID][$t]
				
				If ($field.kind="storage")
					
					$field.fieldNumber:=Num:C11($t)
					
				End if 
			End for each 
		End for each 
	End if 
	
	$isUpgraded:=True:C214
	$project.info.version:=8
	Logger.warning("Updated to version: "+String:C10($project.info.version))
	
End if 

// MARK:MISCELLANEOUS
If (True:C214)
	
	If ($project.dataModel#Null:C1517)
		
		// * REMOVE EMPTY ICONS
		For each ($tableID; $project.dataModel)
			
			For each ($fieldID; $project.dataModel[$tableID])
				
				If (Match regex:C1019("(?m-si)^\\d+$"; $fieldID; 1; *))
					
					If (String:C10($project.dataModel[$tableID][$fieldID].icon)="")
						
						OB REMOVE:C1226($project.dataModel[$tableID][$fieldID]; "icon")
						
					End if 
				End if 
			End for each 
		End for each 
	End if 
	
	// * REPLACE THE OLD INTERNAL FORMS WITH A USER ARCHIVE AS IF HE HAD DOWNLOADED IT
	If ($project.list#Null:C1517)
		
		Logger.info("Check list forms")
		
		$internalFolder:=$path.listForms()
		$userFolder:=$path.hostlistForms()
		$userFolder.create()
		
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/Compatibility/manifest.json").getText()).list
		
		For each ($tableID; $project.list)
			
			$t:=String:C10($project.list[$tableID].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($internalFolder.folder($t).exists))
						
						Logger.warning("Missing internal form: "+$t)
						
						$template:=$c.query("old=:1"; $t).pop()
						
						If ($template#Null:C1517)
							
							// Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/Compatibility/"+$template.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($userFolder; fk overwrite:K87:5)
								
								If ($file#Null:C1517)
									
									$project.list[$tableID].form:="/"+$template.new
									Logger.info("Replaced by: "+$project.list[$tableID].form)
									
								Else 
									
									Logger.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								Logger.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							Logger.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	If ($project.detail#Null:C1517)
		
		Logger.info("Check detail forms")
		
		$internalFolder:=$path.detailForms()
		$userFolder:=$path.hostdetailForms()
		$userFolder.create()
		
		$c:=JSON Parse:C1218(File:C1566("/RESOURCES/Compatibility/manifest.json").getText()).detail
		
		For each ($tableID; $project.detail)
			
			$t:=String:C10($project.detail[$tableID].form)
			
			If (Length:C16($t)>0)
				
				If ($t[[1]]#"/")  // Internal template
					
					If (Not:C34($internalFolder.folder($t).exists))
						
						Logger.warning("Missing internal form: "+$t)
						
						$template:=$c.query("old=:1"; $t).pop()
						
						If ($template#Null:C1517)
							
							// Copy from tempo folder to database
							$file:=File:C1566("/RESOURCES/Compatibility/"+$template.new)
							
							If ($file.exists)
								
								$file:=$file.copyTo($userFolder; fk overwrite:K87:5)
								
								If ($file#Null:C1517)
									
									$project.detail[$tableID].form:="/"+$template.new
									Logger.info("Replaced by: "+$project.detail[$tableID].form)
									
								Else 
									
									Logger.error("Error during copy: "+$file.path)
									
								End if 
								
							Else 
								
								Logger.error("Missing archive: "+$file.path)
								
							End if 
							
						Else 
							
							Logger.error("Unknown template: "+$t)
							
						End if 
					End if 
				End if 
			End if 
		End for each 
	End if 
	
	// * ADD DOMINANT COLOR, IF ANY
	If ($project.ui.dominantColor=Null:C1517)
		
		//
		If (Count parameters:C259>=2)
			
			var $iconFile : 4D:C1709.File
			For each ($iconFile; New collection:C1472(\
				$folder.file("app_icon.png"); \
				$folder.file("Assets.xcassets/AppIcon.appiconset/universal1024.png"); \
				$folder.file("Assets.xcassets/AppIcon.appiconset/ios-marketing1024.png"); \
				$folder.file("android/main/ic_launcher-playstore.png")))
				
				If ($iconFile.exists)
					READ PICTURE FILE:C678($iconFile.platformPath; $picture)
					break
				End if 
			End for each 
			
			If (Picture size:C356($picture)>0)
				
				$project.ui.dominantColor:=cs:C1710.color.new(cs:C1710.bmp.new($picture).getDominantColor()).css.components
				$isUpgraded:=True:C214
				
			End if 
		End if 
	End if 
	
	// * CHANGE ACTION PRESET
	If ($project.actions#Null:C1517)
		
		For each ($o; $project.actions.query("preset = adding"))
			
			$o.preset:="add"
			$isUpgraded:=True:C214
			
		End for each 
		
		For each ($o; $project.actions.query("preset = suppression"))
			
			$o.preset:="delete"
			$isUpgraded:=True:C214
			
		End for each 
		
		For each ($o; $project.actions.query("preset = sharing"))
			
			$o.preset:="share"
			$isUpgraded:=True:C214
			
		End for each 
		
		For each ($o; $project.actions.query("preset = edition"))
			
			$o.preset:="edit"
			$isUpgraded:=True:C214
			
		End for each 
	End if 
	
	OB REMOVE:C1226($project; "regexParameters")
	
End if 

// Set the current version
$project.info.componentBuild:=$info.componentBuild
$project.info.ideVersion:=$info.ideVersion
$project.info.ideBuildVersion:=$info.ideBuildVersion