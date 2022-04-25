Class constructor($project : Object)
	
	Super:C1705()
	
	If (Count parameters:C259>=1)
		
		This:C1470.init($project)
		
	End if 
	
	This:C1470.$regexParameters:="(?mi-s)(=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:[^\\s]*"
	
	// MARK: [COMPUTED]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// FIXME: DO NOT CREATE CALCULATED ATTRIBUTES, THEY WILL BE SAVED IN THE PROJECT FILE.
	
	// MARK:-
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init($project : Object)
	
	var $key : Text
	
	For each ($key; $project)
		
		If ($key[[1]]#"$")
			
			This:C1470[$key]:=$project[$key]
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function load($project) : cs:C1710.project
	
	var $o : Object
	
	var $file : 4D:C1709.File
	
	Case of 
			//______________________________________________________
		: (Value type:C1509($project)=Is text:K8:3)
			
			$file:=File:C1566($project; fk platform path:K87:2)
			
			//______________________________________________________
		: (Value type:C1509($project)=Is object:K8:27)
			
			If (OB Instance of:C1731($project; 4D:C1709.File))
				
				$file:=$project
				
			Else 
				
				// ERROR
				
			End if 
			
			//______________________________________________________
		Else 
			
			// ERROR
			
			//______________________________________________________
	End case 
	
	If (Bool:C1537($file.exists))
		
		// *SHORTCUTS
		This:C1470._folder:=Folder:C1567($file.parent.platformPath; fk platform path:K87:2)
		This:C1470._name:=This:C1470._folder.fullName
		
		$project:=JSON Parse:C1218($file.getText())
		
		If (project_Upgrade($project; This:C1470._folder))
			
			// If upgraded, keep a copy of the old project…
			$o:=This:C1470._folder.folder(Replace string:C233(Get localized string:C991("convertedFiles"); "{stamp}"; cs:C1710.dateTime.new().stamp()))
			$o.create()
			$file.moveTo($o)
			
			//… & immediately save
			This:C1470.save()
			
		End if 
		
		This:C1470.init($project)
		
		If (Value type:C1509($project.info.target)=Is collection:K8:32)
			
			This:C1470.$android:=($project.info.target.indexOf("android")#-1)
			This:C1470.$ios:=($project.info.target.indexOf("android")#-1)
			
		Else 
			
			This:C1470.$android:=($project.info.target="android")
			This:C1470.$ios:=($project.info.target="iOS")
			
		End if 
		
		This:C1470.$project:=Form:C1466
		
		This:C1470.prepare()
		
	Else 
		
		// ERROR
		
	End if 
	
	return (This:C1470)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Prepare the project folder according to the target systems
Function prepare($icon : Picture)
	
	var $iconƒ : Picture
	var $AndroidFolder; $iosFolder : 4D:C1709.Folder
	
	$iosFolder:=This:C1470._folder.folder("Assets.xcassets/AppIcon.appiconset")
	$AndroidFolder:=This:C1470._folder.folder("Android")
	
	If (Count parameters:C259>=1)
		
		$iconƒ:=$icon
		
	Else 
		
		If ($AndroidFolder.file("main/ic_launcher-playstore.png").exists)
			
			// Get the picture as default
			READ PICTURE FILE:C678($AndroidFolder.file("main/ic_launcher-playstore.png").platformPath; $iconƒ)
			
			// ⚠️ the picture size is 512x512 instead of 1024x1024
			TRANSFORM PICTURE:C988($iconƒ; Scale:K61:2; 2; 2)
			
		End if 
	End if 
	
	If (Picture size:C356($iconƒ)=0)
		
		// Get the default icon
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/4d.png").platformPath; $iconƒ)
		
	End if 
	
	If (This:C1470.$ios) | (Is macOS:C1572 & Not:C34(This:C1470.$android))  // On macOS default is iOS
		
		If (Not:C34($iosFolder.exists))  // Create & populate
			
			This:C1470.AppIconSet($iconƒ)
			
		End if 
		
		// Keep the picture for Android
		READ PICTURE FILE:C678($iosFolder.file("ios-marketing1024.png").platformPath; $iconƒ)
		
	Else 
		
		If ($iosFolder.exists)  // Delete
			
			$iosFolder.parent.delete(Delete with contents:K24:24)
			
		End if 
		
	End if 
	
	If (This:C1470.$android)
		
		If (Not:C34($AndroidFolder.exists))  // Create & populate
			
			This:C1470.AndroidIconSet($iconƒ)
			
		End if 
		
	Else 
		
		If ($AndroidFolder.exists)  // Delete
			
			$AndroidFolder.delete(Delete with contents:K24:24)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create the "Assets.xcassets/AppIcon.appiconset" resources
Function AppIconSet($icon : Picture)
	
	var $pixels : Real
	var $decimalSeparator; $fileName; $t : Text
	var $size : Real
	var $blank; $picture : Picture
	var $height; $pos; $width : Integer
	var $heightFactor; $widthFactor : Real
	var $o : Object
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	
	PICTURE PROPERTIES:C457($icon; $width; $height)
	
	If ($width>1024)\
		 | ($height>1024)
		
		CREATE THUMBNAIL:C679($icon; $icon; 1024; 1024; Scaled to fit prop centered:K6:6)
		PICTURE PROPERTIES:C457($icon; $width; $height)
		
	Else 
		
		$widthFactor:=1024/$width
		$heightFactor:=1024/$height
		
		If ($widthFactor#1) | ($heightFactor#1)
			
			TRANSFORM PICTURE:C988($icon; Scale:K61:2; $widthFactor; $heightFactor)
			PICTURE PROPERTIES:C457($icon; $width; $height)
			
		End if 
	End if 
	
	// Transparency is not allowed, so we add a white background.
	READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/blanck.png").platformPath; $blank)
	COMBINE PICTURES:C987($icon; $blank; Superimposition:K61:10; $icon; (1024-$width)\2; (1024-$height)\2)
	
	$folder:=This:C1470._folder.folder("Assets.xcassets/AppIcon.appiconset")
	$folder.create()
	
	$file:=$folder.file("Contents.json")
	
	If (Not:C34($file.exists))
		
		$file:=File:C1566("/RESOURCES/iOS.json")
		$file.copyTo($folder; "Contents.json")
		
	End if 
	
	GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $decimalSeparator)
	
	For each ($o; JSON Parse:C1218($file.getText()).images)
		
		$t:=$o.size
		$pos:=Position:C15("x"; $o.size)
		
		If ($pos>0)
			
			$size:=Num:C11(Replace string:C233(Substring:C12($t; 1; $pos-1); "."; $decimalSeparator))
			$pixels:=$size*Num:C11($o.scale)
			
			CREATE THUMBNAIL:C679($icon; $picture; $pixels; $pixels; Scaled to fit prop centered:K6:6)
			
			$fileName:=$o.idiom+Replace string:C233(String:C10($size); $decimalSeparator; "")
			
			If ($o.scale#"1x")
				
				//%W-533.1
				$fileName:=$fileName+"@"+$o.scale[[1]]
				//%W+533.1
				
			End if 
			
			$fileName:=$fileName+".png"
			
			WRITE PICTURE FILE:C680($folder.file($fileName).platformPath; $picture; ".png")
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Create the "Android" resources
Function AndroidIconSet($icon : Picture)
	
	var $pixels : Real
	var $t : Text
	var $blank; $picture : Picture
	var $height; $pos; $width : Integer
	var $heightFactor; $widthFactor : Real
	var $o : Object
	var $folder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	
	PICTURE PROPERTIES:C457($icon; $width; $height)
	
	If ($width>512)\
		 | ($height>512)
		
		CREATE THUMBNAIL:C679($icon; $icon; 512; 512; Scaled to fit prop centered:K6:6)
		
	Else 
		
		$widthFactor:=512/$width
		$heightFactor:=512/$height
		
		If ($widthFactor#1) | ($heightFactor#1)
			
			TRANSFORM PICTURE:C988($icon; Scale:K61:2; $widthFactor; $heightFactor)
			
		End if 
	End if 
	
	$folder:=This:C1470._folder.folder("android")
	$folder.create()
	
	$file:=File:C1566("/RESOURCES/android.json")
	
	For each ($o; JSON Parse:C1218($file.getText()).images)
		
		$file:=$folder.file($o.file)
		
		$t:=$o.size
		$pos:=Position:C15("x"; $o.size)
		
		If ($pos>0)
			
			$pixels:=Num:C11(Substring:C12($t; 1; $pos-1))
			
			CREATE THUMBNAIL:C679($icon; $picture; $pixels; $pixels; Scaled to fit prop centered:K6:6)
			
			$file:=$folder.file($o.file)
			$file.parent.create()
			
			WRITE PICTURE FILE:C680($file.platformPath; $picture; ".png")
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Save the project
Function save()
	
	var $file : 4D:C1709.File
	
	$file:=This:C1470.getProjectFile()
	$file.setText(JSON Stringify:C1217(This:C1470.cleaned(); *))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns target(s) as collection
Function targets() : Collection
	
	If (Value type:C1509(This:C1470.info.target)=Is text:K8:3)
		
		return (New collection:C1472(This:C1470.info.target))
		
	Else 
		
		return (This:C1470.info.target)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the project is intended to be run on iOS
Function iOS() : Boolean
	
	return (This:C1470.targets().indexOf("iOS")#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the project is intended to be run on Android
Function android() : Boolean
	
	return (This:C1470.targets().indexOf("android")#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the project is intended to run on both iOS and Android
Function allTargets() : Boolean
	
	return (This:C1470.targets().length=2)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Populate the target value into the project
Function setTarget($checkDevTools : Boolean; $target : Text)
	
	If (This:C1470.$ios & This:C1470.$android)
		
		This:C1470.info.target:=New collection:C1472("iOS"; "android")
		
	Else 
		
		If (Not:C34(This:C1470.$android))
			
			// According to platform
			This:C1470.info.target:=Is macOS:C1572 ? "iOS" : "android"
			
			var $t : Text
			$t:=This:C1470.info.target
			This:C1470["$"+Lowercase:C14($t)]:=True:C214
			
		Else 
			
			This:C1470.info.target:=This:C1470.$android ? "android" : "iOS"
			
		End if 
	End if 
	
	// Save & update the project folder
	This:C1470.save()
	This:C1470.prepare()
	
	// TODO:Move to EDITOR class
	UI.ios:=This:C1470.$ios
	UI.android:=This:C1470.$android
	
	If (Count parameters:C259>=1)
		
		If ($checkDevTools)  // Audit of development tools
			
			If (Count parameters:C259>=2)  // Set the build target
				
				Case of 
						
						//________________________
					: ($target="ios") & This:C1470.$ios
						
						This:C1470._buildTarget:=$target
						
						If (UI.xCode#Null:C1517)
							
							UI.xCode.canceled:=False:C215
							UI.xCode.alreadyNotified:=False:C215
							
						End if 
						
						//________________________
					: ($target="android") & This:C1470.$ios
						
						This:C1470._buildTarget:=$target
						
						If (UI.studio#Null:C1517)
							
							UI.studio.canceled:=False:C215
							UI.studio.alreadyNotified:=False:C215
							
						End if 
						
						//________________________
				End case 
			End if 
			
			UI.checkDevTools()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a cleaned project
Function cleaned()->$project : Object
	
	var $t; $tt : Text
	var $o; $project : Object
	
	$project:=OB Copy:C1225(This:C1470)
	
	For each ($t; $project)
		
		
		Case of 
				
				//______________________________________________________
			: (Length:C16($t)=0)
				
				OB REMOVE:C1226($project; $t)
				
				//______________________________________________________
			: ($t[[1]]="$")
				
				OB REMOVE:C1226($project; $t)
				
				//______________________________________________________
			: (OB Instance of:C1731($project["get "+$t]; 4D:C1709.Function))
				
				OB REMOVE:C1226($project; $t)
				
				//______________________________________________________
			Else 
				
				Case of 
						
						//…………………………………………………………………………………………………
					: (Value type:C1509($project[$t])=Is object:K8:27)
						
						This:C1470.cleanup($project[$t])
						
						//…………………………………………………………………………………………………
					: (Value type:C1509($project[$t])=Is collection:K8:32)
						
						For each ($o; $project[$t])
							
							This:C1470.cleanup($o)
							
						End for each 
						
						//…………………………………………………………………………………………………
				End case 
				
				//______________________________________________________
		End case 
	End for each 
	
	// Cleaning inner objects
	For each ($o; OB Entries:C1720($project).query("key =:1"; "_@"))
		
		OB REMOVE:C1226($project; $o.key)
		
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Cleaning inner objects
Function cleanup($dirtyObject : Object)->$cleanObject : Object
	
	var $o : Object
	
	If (Count parameters:C259>=1)
		
		$cleanObject:=$dirtyObject
		
		For each ($o; OB Entries:C1720($cleanObject).query("key =:1"; "$@"))
			
			OB REMOVE:C1226($cleanObject; $o.key)
			
		End for each 
		
	Else 
		
		$cleanObject:=OB Copy:C1225(This:C1470)
		
		For each ($o; OB Entries:C1720($cleanObject).query("key =:1"; "$@"))
			
			OB REMOVE:C1226($cleanObject; $o.key)
			
		End for each 
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if the project is locked
Function isLocked() : Boolean
	
	// TODO:Move to EDITOR class
	
	If (This:C1470.structure#Null:C1517)
		
		return (Bool:C1537(This:C1470.structure.unsynchronized))
		
	Else 
		
		return (Bool:C1537(This:C1470.$project.structure.unsynchronized))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if the project is not locked and
Function isNotLocked() : Boolean
	
	// TODO:Move to EDITOR class
	
	return (Not:C34(This:C1470.isLocked()))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function updateActions
	var $indx : Integer
	var $dataModel; $parameter; $table : Object
	var $actions : Collection
	
	$actions:=This:C1470.actions
	
	If ($actions#Null:C1517)
		
		$dataModel:=This:C1470.dataModel
		
		For each ($table; $actions)
			
			If ($dataModel[String:C10($table.tableNumber)]#Null:C1517)
				
				If ($table.parameters#Null:C1517)
					
					For each ($parameter; $table.parameters)
						
						If ($dataModel[String:C10($table.tableNumber)][String:C10($parameter.fieldNumber)]=Null:C1517)
							
							// ❌ THE FIELD DOESN'T EXIST ANYMORE
							$table.parameters.remove($table.parameters.indexOf($parameter))
							
						End if 
					End for each 
				End if 
				
			Else 
				
				// ❌ THE TABLE DOESN'T EXIST ANYMORE
				$actions.remove($indx)
				
			End if 
			
			$indx:=$indx+1
			
		End for each 
		
		If ($actions.length=0)
			
			// ❌ NO MORE ACTION
			OB REMOVE:C1226(This:C1470; "actions")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of the tables of the data model
Function tables($datamodel : Object)->$tables : Collection
	
	If (Count parameters:C259>=1)
		
		$tables:=OB Entries:C1720($datamodel)
		
	Else 
		
		// Use current
		$tables:=OB Entries:C1720(This:C1470.dataModel)
		
	End if 
	
	$tables:=$tables.filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1)))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of the fields of a table data model
Function fields($table : Variant)->$fields : Collection
	
	var $model : Object
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($table)=Is object:K8:27)  // Table model
				
				$model:=$table
				
				//______________________________________________________
			: (Value type:C1509($table)=Is longint:K8:6)\
				 | (Value type:C1509($table)=Is real:K8:4)  // Table number
				
				$model:=This:C1470.dataModel[String:C10($table)]
				
				//______________________________________________________
			Else   // Table name
				
				$model:=This:C1470.dataModel[$table]
				
				//______________________________________________________
		End case 
		
		//key # "" et object
		$fields:=OB Entries:C1720($model).filter("col_formula"; Formula:C1597($1.result:=(Length:C16($1.value.key)#0) & (Value type:C1509($1.value.value)=Is object:K8:27)))
		
	Else 
		
		// #Error
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of the storage  fields of a table data model
Function storageFields($table : Variant)->$fields : Collection
	
	var $model : Object
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($table)=Is object:K8:27)  // Table model
				
				$model:=$table
				
				//______________________________________________________
			: (Value type:C1509($table)=Is longint:K8:6)\
				 | (Value type:C1509($table)=Is real:K8:4)  // Table number
				
				$model:=This:C1470.dataModel[String:C10($table)]
				
				//______________________________________________________
			Else   // Table name
				
				$model:=This:C1470.dataModel[$table]
				
				//______________________________________________________
		End case 
		
		$fields:=OB Entries:C1720($model).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1)))
		
	Else 
		
		// #Error
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isField($field) : Boolean
	
	Case of 
			//______________________________________________________
		: ($field=Null:C1517)  // Value type($field)=Is object seems to be true if an object null is passed
			
			return False:C215
			
			//______________________________________________________
		: (Value type:C1509($field)=Is text:K8:3)  // Key property
			
			return (Match regex:C1019("(?m-si)^\\d+$"; $field; 1; *))
			
			//______________________________________________________
		: (Value type:C1509($field)=Is object:K8:27)  // The field itself
			
			// Eventually, just the kind will be needed
			return (($field.kind="storage") || ($field.fieldType#Null:C1517))
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if it is a storage or calculated attribute
Function isFieldAttribute($fieldName : Text; $tableName : Text) : Boolean
	
	var $field; $table : Object
	
	$table:=This:C1470.getCatalog().query("name = :1"; $tableName).pop()
	
	If ($table#Null:C1517)
		
		$field:=$table.fields.query("name = :1"; $fieldName).pop()
		
	End if 
	
	return ($field#Null:C1517)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelation($attribute : Variant) : Boolean
	
	return (($attribute.relatedTableNumber#Null:C1517)\
		 || ((This:C1470.isRelationToOne($attribute))\
		 || (This:C1470.isRelationToMany($attribute))))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelationToOne($attribute : Variant) : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		return (String:C10($attribute.kind)="relatedEntity")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelationToMany($attribute : Variant) : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		//$is:=(($attribute.relatedEntities#Null) | (String($attribute.kind)="relatedEntities")) | (Bool($attribute.isToMany))
		return (String:C10($attribute.kind)="relatedEntities")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Given a dataclass & a path, returns true if the path is valid (in ds)
Function isAvailable($dataClass : 4D:C1709.DataClass; $path)->$success : Boolean
	
	var $key : Text
	var $o : Object
	var $c : Collection
	
	$o:=$dataClass
	
	For each ($key; Split string:C1554($path; "."))
		
		If ($o[$key].relatedDataClass#Null:C1517)
			
			$o:=ds:C1482[$o[$key].relatedDataClass]
			
		Else 
			
			$o:=$o[$key]
			
		End if 
	End for each 
	
	$success:=($o#Null:C1517)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isComputedAttribute($field : Object; $tableName : Text)->$is : Boolean
	
	var $o : Object
	var $catalog : Collection
	
	$is:=($field.kind#Null:C1517) && ($field.kind="calculated")
	
	If ($is & (Count parameters:C259>=2))
		
		$is:=False:C215
		
		// Filter writable (not readOnly) computed attrbutes
		$catalog:=This:C1470.getCatalog()
		
		If ($catalog#Null:C1517)
			
			$o:=$catalog.query("name = :1"; $tableName).pop()
			
			If ($o#Null:C1517)
				
				$o:=$o.fields.query("name = :1"; $field.name).pop()
				
				If ($o#Null:C1517)
					
					$is:=Not:C34(Bool:C1537($o.readOnly))
					
				End if 
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if field is an alias
Function isAlias($attribute : Variant) : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		return (String:C10($attribute.kind)="alias")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// ??
Function isLink
	var $0 : Boolean
	var $1 : Object
	
	var $t : Text
	
	If (True:C214)
		
		For each ($t; OB Keys:C1719($1)) Until ($0)
			
			$0:=Value type:C1509($1[$t])=Is object:K8:27
			
		End for each 
		
	Else 
		
		$0:=OB Entries:C1720($1).filter("col_formula"; Formula:C1597($1.result:=(Value type:C1509($1.value)=Is object:K8:27))).length>0
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function checkRestQueryFilter($table : Object)
	
	var $buffer : Text
	var $success : Boolean
	var $filter; $response : Object
	
	If ($table.filter#Null:C1517)
		
		$filter:=$table.filter
		
		OB REMOVE:C1226($filter; "error")
		OB REMOVE:C1226($filter; "errors")
		OB REMOVE:C1226($filter; "code")
		OB REMOVE:C1226($filter; "httpError")
		OB REMOVE:C1226($filter; "parameters")
		
		OB REMOVE:C1226($table; "count")
		
		// Detect a query with parameters
		$filter.parameters:=(Match regex:C1019(This:C1470.$regexParameters; $filter.string; 1))
		
		If ($filter.parameters)
			
			OB REMOVE:C1226($filter; "embedded")
			
			$buffer:=$filter.string
			
			If (Rgx_SubstituteText(This:C1470.$regexParameters; "\\1\"@\""; ->$buffer)=0)
				
				$response:=Rest(New object:C1471(\
					"action"; "records"; \
					"table"; $table.name; \
					"url"; This:C1470.server.urls.production; \
					"handler"; "mobileapp"; \
					"queryEncode"; True:C214; \
					"query"; New object:C1471("$filter"; $buffer; \
					"$limit"; "1")))
				
			Else 
				
				$success:=True:C214
				
			End if 
			
		Else 
			
			OB REMOVE:C1226($filter; "parameters")
			
			$response:=Rest(New object:C1471(\
				"action"; "records"; \
				"table"; $table.name; \
				"url"; This:C1470.server.urls.production; \
				"handler"; "mobileapp"; \
				"queryEncode"; True:C214; \
				"query"; New object:C1471("$filter"; $filter.string)))
			
		End if 
		
		$success:=$response.success
		
		Case of 
				
				//______________________________________________________
			: ($success)
				
				If ($response.__COUNT#Null:C1517)
					
					$table.count:=Num:C11($response.__COUNT)
					
				End if 
				
				//______________________________________________________
			: ($response.code=0)  //server not reachable
				
				$filter.code:=$response.code
				$filter.error:=".The server is not reachable"
				
				//______________________________________________________
			: ($response.httpError#Null:C1517)  //?????
				
				$filter.httpError:=$response.httpError
				$filter.error:=".Server error ("+String:C10($response.httpError)+")"
				
				
				//______________________________________________________
		End case 
		
		$filter.errors:=$response.errors
		$filter.validated:=$success
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function checkLocalQueryFilter($table : Object)
	
	var $buffer : Text
	var $success : Boolean
	var $filter; $o : Object
	var $es : 4D:C1709.EntitySelection
	var $error : cs:C1710.error
	
	If ($table#Null:C1517)
		
		$table.total:=ds:C1482[$table.name].all().length
		
		If ($table.filter#Null:C1517)
			
			$filter:=$table.filter
			
			OB REMOVE:C1226($filter; "error")
			OB REMOVE:C1226($filter; "errors")
			OB REMOVE:C1226($filter; "code")
			OB REMOVE:C1226($filter; "httpError")
			OB REMOVE:C1226($filter; "parameters")
			
			OB REMOVE:C1226($table; "count")
			
			// Detect a query with parameters
			$filter.parameters:=(Match regex:C1019(This:C1470.$regexParameters; $filter.string; 1))
			
			If ($filter.parameters)
				
				OB REMOVE:C1226($filter; "embedded")
				
				$buffer:=$filter.string
				
				If (Rgx_SubstituteText(This:C1470.$regexParameters; "\\1:1"; ->$buffer)=0)
					
					//mark: - START TRAPPING ERRORS
					$error:=cs:C1710.error.new("capture")
					ds:C1482[$table.name].query($buffer; "@")
					$error.release()
					//mark: - STOP TRAPPING ERRORS
					
					$success:=Bool:C1537(Num:C11($error.lastError().error)=0)
					
				Else 
					
					$success:=True:C214
					
				End if 
				
			Else 
				
				OB REMOVE:C1226($filter; "parameters")
				
				//mark: - START TRAPPING ERRORS
				$error:=cs:C1710.error.new("capture")
				
				var $es : 4D:C1709.EntitySelection
				$es:=ds:C1482[$table.name].query($filter.string)
				
				$error.release()
				//mark: - STOP TRAPPING ERRORS
				
				$success:=Bool:C1537(Num:C11($error.lastError().error)=0)
				
				If ($success)
					
					$table.count:=$es.length
					
				End if 
			End if 
			
			If (Not:C34($success))
				
				$filter.errors:=$error.lastError().stack
				
				// Build the error message
				$filter.error:=""
				
				For each ($o; $filter.errors.query("component='dbmg'").reverse())
					
					If (Position:C15($o.desc; $filter.error)=0)
						
						$filter.error:=$filter.error+$o.desc+"\r"
						
					End if 
				End for each 
				
				// Remove last carriage return
				$filter.error:=Split string:C1554($filter.error; "\r"; sk ignore empty strings:K86:1).join("\r")
				
			End if 
			
			$filter.validated:=$success
			
		End if 
	End if 
	
	// Returns alias destination if alias
	// CLEAN: maybe move to structure? or somewhere where ds is authorized
Function __getAliasDestination($dataClass : Variant; $attribute : Variant; $recursive : Boolean)->$result : Object
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		If (String:C10($attribute.kind)="alias")
			
			If (Length:C16(String:C10($attribute.path))>0)
				
				var $ds : Object
				$ds:=ds:C1482  // DS not allowed?
				
				var $paths : Collection
				var $path : Text
				$paths:=Split string:C1554($attribute.path; ".")
				
				$result:=New object:C1471
				$result.paths:=New collection:C1472
				
				var $sourceDataClass; $destination; $previousDataClass : Object
				
				If (Value type:C1509($dataClass)=Is text:K8:3)
					
					$sourceDataClass:=$ds[$dataClass]
					
				Else 
					
					$sourceDataClass:=$dataClass
					
				End if 
				
				Repeat 
					
					$path:=$paths.shift()
					$destination:=$sourceDataClass[$path]
					
					$result.paths.push(New object:C1471(\
						"path"; $path; \
						"dataClass"; $sourceDataClass.getInfo().name))
					
					$previousDataClass:=$sourceDataClass
					
					If ($destination.relatedDataClass#Null:C1517)  // Is relatedDataClass filled for alias? like destination field
						
						$sourceDataClass:=$ds[$destination.relatedDataClass]
						
					End if 
				Until ($paths.length=0)
				
				$result.field:=$destination
				
				If (Bool:C1537($recursive))
					
					If (String:C10($result.field.kind)="alias")  // Maybe an alias too
						
						var $rs : Object
						$rs:=This:C1470.__getAliasDestination($previousDataClass; $result.field; True:C214)
						
						$result.paths.combine($rs.paths)
						$result.field:=$rs
						
					End if 
				End if 
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the 4D Type is a Numeric type
Function isNumeric($type : Integer) : Boolean
	
	return (New collection:C1472(Is integer:K8:5; Is longint:K8:6; Is integer 64 bits:K8:25; Is real:K8:4; _o_Is float:K8:26).indexOf($type)#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the 4D Type is a String type
Function isString($type : Integer) : Boolean
	
	return (New collection:C1472(Is alpha field:K8:1; Is text:K8:3).indexOf($type)#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the field is sortable
Function isSortable($field : Object) : Boolean
	
	If ($field.fieldType#Null:C1517)
		
		return (($field.fieldType#Is object:K8:27)\
			 && ($field.fieldType#Is BLOB:K8:12)\
			 && ($field.fieldType#Is picture:K8:10)\
			 && ($field.fieldType#Is object:K8:27)\
			 && ($field.fieldType#Is collection:K8:32))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the resource comes from the host's database.
Function isCustomResource($resource : Text) : Boolean
	
	If (Length:C16($resource)>0)
		
		//%W-533.1
		return ($resource[[1]]="/")
		//%W+533.1
		
	Else 
		
		return (False:C215)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of table's sortable field
Function getSortableFields($table; $ordered : Boolean)->$fields : Collection
	
	var $member; $model : Object
	
	$fields:=New collection:C1472
	
	If (Count parameters:C259>=1)
		
		Case of 
				
				//______________________________________________________
			: (Value type:C1509($table)=Is object:K8:27)  // Table model
				
				$model:=$table
				
				//______________________________________________________
			: (Value type:C1509($table)=Is longint:K8:6)\
				 | (Value type:C1509($table)=Is real:K8:4)  // Table number
				
				$model:=This:C1470.dataModel[String:C10($table)]
				
				//______________________________________________________
			Else   // Table name
				
				$model:=This:C1470.dataModel[$table]
				
				//______________________________________________________
		End case 
		
		For each ($member; OB Entries:C1720($model).query("key !=''"))
			
			If (This:C1470.isSortable($member.value))
				
				var $field : cs:C1710.field
				$field:=OB Copy:C1225($member.value)
				
				If ($member.value.kind="storage")
					
					$field.fieldNumber:=($field.fieldNumber#Null:C1517) ? $field.fieldNumber : Num:C11($member.key)
					
				Else 
					
					$field.name:=$member.key
					
				End if 
				
				$fields.push($field)
				
			End if 
		End for each 
		
		If ($ordered)
			
			// Sort by name
			$fields:=$fields.orderBy("name")
			
		End if 
		
	Else 
		
		// #Error
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Add a table to the data model
Function addTable($table)->$tableModel : Object
	
	var $tableID : Text
	var $o : cs:C1710.table
	
	$tableID:=This:C1470._tableID($table)
	
	$o:=This:C1470.getCatalog().query("tableNumber = :1"; Num:C11($tableID)).pop()
	ASSERT:C1129($o#Null:C1517)
	
	// Put internal properties into a substructure
	$tableModel:=New object:C1471(\
		""; New object:C1471(\
		"name"; $o.name; \
		"label"; This:C1470.label($o.name); \
		"shortLabel"; This:C1470.shortLabel($o.name); \
		"primaryKey"; String:C10($o.primaryKey); \
		"embedded"; True:C214)\
		)
	
	// Update dataModel
	If (This:C1470.dataModel=Null:C1517)
		
		This:C1470.dataModel:=New object:C1471
		
	End if 
	
	This:C1470.dataModel[String:C10($tableID)]:=$tableModel
	
	// Update dependencies
	This:C1470.addToMain($table)
	This:C1470.createFormEntries($table)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Delete the table from the data model
Function removeTable($table)
	
	var $tableID : Text
	
	If (This:C1470.dataModel#Null:C1517)
		
		$tableID:=This:C1470._tableID($table)
		
		OB REMOVE:C1226(This:C1470.dataModel; $tableID)
		
		// Update dependencies
		This:C1470.removeFromMain($table)
		This:C1470.deleteFormEntries($table)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Add table to the Main Menu
Function addToMain($table)
	
	var $tableID : Text
	var $main : Object
	
	$tableID:=This:C1470._tableID($table)
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472($tableID)
		
	Else 
		
		If ($main.order.indexOf($tableID)=-1)
			
			$main.order.push($tableID)
			This:C1470.save()
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Remove table to the Main Menu
Function removeFromMain($table)
	
	var $tableID : Text
	var $index : Integer
	var $main : Object
	
	$tableID:=This:C1470._tableID($table)
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472
		
	Else 
		
		$index:=$main.order.indexOf($tableID)
		
		If ($index#-1)
			
			$main.order.remove($index)
			
		End if 
	End if 
	
	This:C1470.save()
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Create list and detail form entries
Function createFormEntries($table)
	
	var $tableID : Text
	
	This:C1470.list:=This:C1470.list=Null:C1517 ? New object:C1471 : This:C1470.list
	This:C1470.detail:=This:C1470.detail=Null:C1517 ? New object:C1471 : This:C1470.detail
	
	$tableID:=This:C1470._tableID($table)
	
	This:C1470.list[$tableID]:=This:C1470.list[$tableID]=Null:C1517 ? New object:C1471 : This:C1470.list[$tableID]
	This:C1470.detail[$tableID]:=This:C1470.detail[$tableID]=Null:C1517 ? New object:C1471 : This:C1470.detail[$tableID]
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Delete entries for the list and detail forms
Function deleteFormEntries($table)
	
	var $tableID : Text
	
	This:C1470.list:=This:C1470.list=Null:C1517 ? New object:C1471 : This:C1470.list
	This:C1470.detail:=This:C1470.detail=Null:C1517 ? New object:C1471 : This:C1470.detail
	
	$tableID:=This:C1470._tableID($table)
	
	OB REMOVE:C1226(This:C1470.list; $tableID)
	OB REMOVE:C1226(This:C1470.detail; $tableID)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Get the current catalog
Function getCatalog() : Collection
	
	Case of 
			
			//____________________________________
		: (This:C1470.$project#Null:C1517)
			
			return ((This:C1470.$project.$catalog#Null:C1517) ? This:C1470.$project.$catalog : This:C1470.$project.ExposedStructure.catalog)
			
			//____________________________________
		: (This:C1470.ExposedStructure#Null:C1517)
			
			return (This:C1470.ExposedStructure.catalog)
			
			//____________________________________
		Else 
			
			return This:C1470.getCatalogObject().structure.definition
			
			//____________________________________
	End case 
	
	//====================================
Function label  // Format labels
	var $0 : Text
	var $1 : Text
	
	var $t : Text
	var $i : Integer
	
	ARRAY TEXT:C222($words; 0)
	
	$t:=$1
	
	Case of 
			
			//______________________________________________________
		: (Not:C34(Match regex:C1019("(?mi-s)^[[:ascii:]]*$"; $t; 1)))  //#ACI0099182
			
			$0:=$t
			
			//______________________________________________________
		: (Match regex:C1019("(?m-si)%[^%]*%"; $t; 1))  //#122850
			
			$0:=$t
			
			//______________________________________________________
		Else 
			
			$t:=Replace string:C233($t; "_"; " ")
			
			// Camelcase to spaced
			If (Rgx_SubstituteText("(?m-si)([[:lower:]])([[:upper:]])"; "\\1 \\2"; ->$t)=0)
				
				$t:=Lowercase:C14($t)
				
			End if 
			
			// Capitalize first letter of words
			GET TEXT KEYWORDS:C1141($t; $words)
			
			For ($i; 1; Size of array:C274($words); 1)
				
				If (Length:C16($words{$i})>3)\
					 | ($i=1)
					
					$words{$i}[[1]]:=Uppercase:C13($words{$i}[[1]])
					
				End if 
				
				$0:=$0+((" ")*Num:C11($i>1))+$words{$i}
				
			End for 
			
			If ($0="id")
				
				$0:=Replace string:C233($0; "id"; "ID")
				
			End if 
			
			//______________________________________________________
	End case 
	
	//====================================
Function shortLabel  // Format short labels
	var $0 : Text
	var $1 : Text
	
	$0:=This:C1470.label($1)
	
	If (Length:C16($0)>10)
		
		$0:=Substring:C12($0; 1; 10)
		
	End if 
	
	//====================================
Function labelList  // List of x
	var $0 : Text
	var $1 : Text
	
	$0:=This:C1470.label(Replace string:C233(Get localized string:C991("listOf"); "{values}"; $1))
	
	// === === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Convert legacy type (integer) to orda type (text)
Function fieldType2type($legacyFieldType : Integer)->$fieldType : Text
	
	var $c : Collection
	
	$c:=New collection:C1472
	$c[Is integer 64 bits:K8:25]:="number"
	$c[Is alpha field:K8:1]:="string"
	$c[Is integer:K8:5]:="number"
	$c[Is longint:K8:6]:="number"
	$c[Is picture:K8:10]:="image"
	$c[Is boolean:K8:9]:="bool"
	$c[_o_Is float:K8:26]:="number"
	$c[Is text:K8:3]:="string"
	$c[Is real:K8:4]:="number"
	$c[Is time:K8:8]:="time"
	$c[Is date:K8:7]:="date"
	$c[Is object:K8:27]:="object"
	
	If (Asserted:C1132($legacyFieldType<=$c.length))
		
		$fieldType:=$c[$legacyFieldType]
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getIcon($relativePath : Text)->$icon : Picture
	
	var $file : 4D:C1709.File
	
	If (Length:C16($relativePath)=0)
		
		$file:=File:C1566("/RESOURCES/images/noIcon.svg")
		
	Else 
		
		$file:=cs:C1710.path.new().icon($relativePath)
		
		If (Not:C34($file.exists))
			
			$file:=File:C1566("/RESOURCES/images/errorIcon.svg")
			
		End if 
	End if 
	
	If ($file.exists)
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if a field is still available in the table catalog
Function fieldAvailable($tableID; $field : Object)->$available : Boolean
	
	var $fieldID : Text
	var $relatedCatalog; $tableCatalog : Object
	var $c : Collection
	
	// Accept num or string
	$tableID:=String:C10($tableID)
	$fieldID:=String:C10($field.id)
	
	$c:=Split string:C1554($field.name; ".")
	
	Case of 
			
			//______________________________________________________
		: ($c.length=1)
			
			// Check the data class
			//TODO:Remove computed
			If ($field.relatedTableNumber#Null:C1517)\
				 | ($field.kind="calculated")\
				 | (Bool:C1537($field.computed))
				
				// Relation or computed attribute --> use name
				$available:=(This:C1470.dataModel[$tableID][$field.name]#Null:C1517)
				
			Else 
				
				// Field --> use ID
				$available:=(This:C1470.dataModel[$tableID][$fieldID]#Null:C1517)
				
			End if 
			
			If (Not:C34($available))
				
				$available:=cs:C1710.ob.new(This:C1470.dataModel[$tableID]).toCollection().query("name = :1"; $c[0]).pop()#Null:C1517
				
			End if 
			
			//______________________________________________________
		: ($c.length=2)
			
			// Check the related data class
			$tableCatalog:=ds:C1482[Table name:C256(Num:C11($tableID))]
			
			If ($tableCatalog#Null:C1517)  // The table exists
				
				$relatedCatalog:=ds:C1482[$tableCatalog[$c[0]].relatedDataClass]
				
				If ($relatedCatalog#Null:C1517)  // The linked table exists
					
					$available:=$relatedCatalog[$c[1]]#Null:C1517
					
				End if 
			End if 
			
			//______________________________________________________
		Else 
			
			// TODO: Allow more levels with recursivity
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//returns minimium field definition
Function minimumField($field : cs:C1710.field)
	
	$field:=This:C1470.cleanup($field)
	
	//FIXME:#TEMPO
	OB REMOVE:C1226($field; "id")
	OB REMOVE:C1226($field; "relatedEntities")
	
	OB REMOVE:C1226($field; "fromIndex")  // Internal D&D
	
	OB REMOVE:C1226($field; "type")
	OB REMOVE:C1226($field; "valueType")
	OB REMOVE:C1226($field; "computed")
	
	OB REMOVE:C1226($field; "label")
	OB REMOVE:C1226($field; "shortLabel")
	
	If ($field.kind#"alias")
		
		If ($field.path=$field.name)
			
			//OB REMOVE($field; "path")
			
		End if 
		
		If ($field.fieldType=8858)\
			 | ($field.fieldType=8859)\
			 | ($field.fieldType<0)
			
			OB REMOVE:C1226($field; "fieldType")
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update all form definition according to the datamodel
	// Ie. remove from forms, the fields that are no more published
Function updateFormDefinitions()
	
	var $formType; $tableID : Text
	var $field; $target : Object
	
	Logger.info("updateFormDefinitions()")
	
	For each ($formType; New collection:C1472("list"; "detail"))
		
		If (Form:C1466[$formType]#Null:C1517)
			
			For each ($tableID; This:C1470[$formType])
				
				If (This:C1470.dataModel[$tableID]#Null:C1517)
					
					$target:=Form:C1466[$formType][$tableID]
					
					If ($target.fields#Null:C1517)
						
						// FIELDS ---------------------------------------------------------------------
						For each ($field; $target.fields)
							
							If ($field#Null:C1517)
								
								If (Not:C34(This:C1470.fieldAvailable($tableID; $field)))
									
									$target.fields[$target.fields.indexOf($field)]:=Null:C1517
									
								End if 
							End if 
						End for each 
					End if 
					
					If ($formType="list")
						
						// SEARCH WIDGET --------------------------------------------------------------
						If ($target.searchableField#Null:C1517)
							
							If (Value type:C1509($target.searchableField)=Is collection:K8:32)
								
								For each ($field; $target.searchableField)
									
									If (Not:C34(This:C1470.fieldAvailable($tableID; $field)))
										
										$target.searchableField.remove($target.searchableField.indexOf($field))
										
									End if 
								End for each 
								
								Case of 
										
										//…………………………………………………………………………………………………
									: ($target.searchableField.length=0)  // There are no more
										
										OB REMOVE:C1226($target; "searchableField")
										
										//…………………………………………………………………………………………………
									: ($target.searchableField.length=1)  // Convert to object
										
										$target.searchableField:=$target.searchableField[0]
										
										//…………………………………………………………………………………………………
								End case 
								
							Else 
								
								If (Not:C34(This:C1470.fieldAvailable($tableID; $target.searchableField)))
									
									OB REMOVE:C1226($target; "searchableField")
									
								End if 
							End if 
						End if 
						
						// SECTION WIDGET -------------------------------------------------------------
						If ($target.sectionField#Null:C1517)
							
							If (Not:C34(This:C1470.fieldAvailable($tableID; $target.sectionField)))
								
								OB REMOVE:C1226($target; "sectionField")
								
							End if 
						End if 
					End if 
				End if 
			End for each 
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// TODO:Move to EDITOR class
	/// Performs the project audit
Function audit($audits : Object)
	
	If (Count parameters:C259>=1)
		
		UI.projectAudit:=project_Audit($audits)
		
	Else 
		
		UI.projectAudit:=project_Audit
		
	End if 
	
	// FIXME:TO REMOVE
	cs:C1710.ob.new(This:C1470).set("$project.status.project"; UI.projectAudit.success)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the published tables as a collection
Function publishedTables()->$tables : Collection
	
	var $tableID : Text
	var $meta; $table : Object
	
	$tables:=New collection:C1472
	
	If (This:C1470.dataModel#Null:C1517)
		
		For each ($tableID; This:C1470.dataModel)
			
			$meta:=This:C1470.dataModel[$tableID][""]  // Table properties
			
			If ($meta.label=Null:C1517)
				
				$meta.label:=PROJECT.label($meta.name)
				
			End if 
			
			If ($meta.shortLabel=Null:C1517)
				
				$meta.shortLabel:=$meta.label
				
			End if 
			
			$table:=New object:C1471(\
				"tableNumber"; Num:C11($tableID); \
				"name"; $meta.name; \
				"label"; $meta.label; \
				"shortLabel"; $meta.shortLabel; \
				"embedded"; Bool:C1537($meta.embedded); \
				"iconPath"; String:C10($meta.icon); \
				"icon"; PROJECT.getIcon(String:C10($meta.icon)))
			
			If ($meta.filter#Null:C1517)
				
				$table.filter:=Choose:C955(Value type:C1509($meta.filter)=Is text:K8:3; New object:C1471(\
					"string"; $meta.filter); \
					$meta.filter)
				
			End if 
			
			$tables.push($table)
			
		End for each 
		
	Else   // <NOTHING MORE TO DO>
	End if 
	
	//================================================================================
	/// Gets a datamodel table definition from ID, table number, name or object
Function table($table) : cs:C1710.table
	
	return (This:C1470.dataModel[This:C1470._tableID($table)])
	
	//================================================================================
	/// Gets a datamodel field definition from ID, field number, name or object
Function field($table; $field) : Object
	
	$table:=This:C1470.table($table)
	
	If ($table#Null:C1517)
		
		var $t : Text
		$t:=This:C1470._fieldID($field; $table)
		
		If (Length:C16($t)>0)
			
			return ($table[$t])
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Get the project file
Function getProjectFile() : 4D:C1709.File
	
	return (This:C1470._folder.file("project.4dmobileapp"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Get the associated catalog file
Function getCatalogFile() : 4D:C1709.File
	
	return (This:C1470._folder.file("catalog.json"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the catalog as object
Function getCatalogObject() : Object
	
	return (JSON Parse:C1218(This:C1470.getCatalogFile().getText()))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Makes a Backup of the project & catalog
Function backup()
	
	var $file : 4D:C1709.File
	var $backup : 4D:C1709.Folder
	
	$backup:=This:C1470._folder.folder(Replace string:C233(Get localized string:C991("replacedFiles"); "{stamp}"; cs:C1710.dateTime.new().stamp()))
	$backup.create()
	
	// Copy the project
	$file:=This:C1470.getProjectFile()
	$file.copyTo($backup)
	
	// Copy the catalog
	$file:=This:C1470.getCatalogFile()
	$file.copyTo($backup)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function repairStructure($audit : Collection)
	
	var $index; $relatedCount; $tablePublishedFieldNumber : Integer
	var $current; $datastore; $field; $item; $linkedItem; $relatedField : Object
	var $relatedItem; $tableModel : Object
	var $table : Collection
	
	This:C1470.backup()
	
	$datastore:=catalog("datastore").datastore
	
	For each ($table; $audit)
		
		If ($table#Null:C1517)
			
			If ($table.length=0)
				
				// ❌ THE TABLE DOESN'T EXIST ANYMORE
				OB REMOVE:C1226(This:C1470.dataModel; String:C10($index))
				
			Else 
				
				// *CHECK THE FIELDS
				$tableModel:=This:C1470.dataModel[String:C10($index)]
				
				$tablePublishedFieldNumber:=0
				
				For each ($item; This:C1470.fields($tableModel))
					
					$current:=$tableModel[$item.key]
					
					Case of 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: ($item.value.kind="storage")
							
							$field:=$table.query("fieldNumber = :1"; Num:C11($item.key)).pop()
							
							If (This:C1470._checkFieldForRepair($current; $field))
								
								$tablePublishedFieldNumber+=1
								
							Else 
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: ($item.value.kind="calculated")\
							 | ($item.value.kind="alias")
							
							$field:=$table.query("name = :1"; $item.key).pop()
							
							If (This:C1470._checkFieldForRepair($current; $field))
								
								$tablePublishedFieldNumber+=1
								
							Else 
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: ($item.value.kind="relatedEntities")
							
							If ($datastore[$tableModel[$item.key].relatedEntities]=Null:C1517)
								
								// ❌ THE RELATED TABLE DOESN'T EXIST ANYMORE
								OB REMOVE:C1226($tableModel; String:C10($item.key))
								
							Else 
								
								$tablePublishedFieldNumber+=1
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: ($item.value.kind="relatedEntity")
							
							$field:=$table.query("name = :1"; $item.key).pop()
							
							If ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							Else 
								
								$relatedCount:=0
								
								For each ($relatedItem; OB Entries:C1720($item.value).query("value.name != null"))
									
									$relatedField:=$relatedItem.value
									
									Case of 
											
											//======================================
										: ($relatedField.kind="storage")
											
											$field:=$table.query("fieldNumber = :1"; Num:C11($relatedItem.key)).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($current[$item.key]; $relatedItem.key)
												
											End if 
											
											//======================================
										: ($relatedField.kind="calculated")\
											 | ($relatedField.kind="alias")
											
											$field:=$table.query("name = :1"; $relatedField.name).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($item.value; $relatedItem.key)
												
											End if 
											
											//======================================
										: ($relatedField.kind="relatedEntities")
											
											$field:=$table.query("name = :1"; $relatedField.name).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($current; $relatedItem.key)
												
											End if 
											
											//======================================
										: ($relatedField.kind="relatedEntity")
											
											var $linkedItem : Object
											For each ($linkedItem; This:C1470.storageFields($relatedField))
												
												$field:=$table.query("fieldNumber = :1"; Num:C11($linkedItem.key)).pop()
												
												If (This:C1470._checkFieldForRepair($current; $field))
													
													$relatedCount:=$relatedCount+1
													
												Else 
													
													OB REMOVE:C1226($current; $linkedItem.key)
													
												End if 
											End for each 
											
											//======================================
									End case 
								End for each 
								
								If ($relatedCount=0)  // ❌ NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
									
									OB REMOVE:C1226($tableModel; $item.key)
									
								Else 
									
									$tablePublishedFieldNumber+=1
									
								End if 
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						Else 
							
							oops
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					End case 
				End for each 
				
				If ($tablePublishedFieldNumber=0)
					
					// ❌ NO MORE FIELDS PUBLISHED FOR THIS TABLE
					OB REMOVE:C1226(This:C1470.dataModel; String:C10($index))
					
				End if 
			End if 
		End if 
		
		$index:=$index+1
		
	End for each 
	
	If (OB Is empty:C1297(This:C1470.dataModel))
		
		OB REMOVE:C1226(This:C1470; "dataModel")
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Repairing the project
Function fix($data : Object)->$result : Object
	
	$result:=project_Fix($data)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//
Function repairProject()
	
	var $actionIndex; $parameterIndex; $type : Integer
	var $dataModel; $o; $param : Object
	var $c : Collection
	
/*
=============================================================================================
|                                       ACTIONS                                             |
=============================================================================================
*/
	
	If (This:C1470.actions#Null:C1517)
		
		$c:=New collection:C1472
		$c[Is integer 64 bits:K8:25]:="number"
		$c[Is alpha field:K8:1]:="string"
		$c[Is integer:K8:5]:="number"
		$c[Is longint:K8:6]:="number"
		$c[Is picture:K8:10]:="image"
		$c[Is boolean:K8:9]:="bool"
		$c[_o_Is float:K8:26]:="number"
		$c[Is text:K8:3]:="string"
		$c[Is real:K8:4]:="number"
		$c[Is time:K8:8]:="time"
		$c[Is date:K8:7]:="date"
		
		$dataModel:=This:C1470.dataModel
		
		For each ($o; This:C1470.actions)
			
			$parameterIndex:=0
			
			If ($dataModel[String:C10($o.tableNumber)]#Null:C1517)
				
				If ($o.parameters#Null:C1517)
					
					For each ($param; $o.parameters)
						
						If ($dataModel[String:C10($o.tableNumber)][String:C10($param.fieldNumber)]#Null:C1517)
							
							$type:=$dataModel[String:C10($o.tableNumber)][String:C10($param.fieldNumber)].fieldType
							
							If ($c[$type]#$param.type)
								
								$param.type:=$c[$type]
								
								Case of 
										
										//……………………………………………………………………
									: ($param.type="date")
										
										$param.format:="mediumDate"
										
										//……………………………………………………………………
									: ($param.type="time")
										
										$param.format:="hour"
										
										//……………………………………………………………………
									Else 
										
										OB REMOVE:C1226($param; "format")
										
										//……………………………………………………………………
								End case 
								
							Else 
								
								// <NOTHING MORE TO DO>
								
							End if 
							
						Else 
							
							// THE FIELD DOESN'T EXIST ANYMORE
							$o.parameters.remove($parameterIndex)
							
						End if 
						
						$parameterIndex:=$parameterIndex+1
						
					End for each 
				End if 
				
			Else 
				
				// THE TABLE DOESN'T EXIST ANYMORE
				This:C1470.actions.remove($actionIndex)
				
			End if 
			
			$actionIndex:=$actionIndex+1
			
		End for each 
		
		If (This:C1470.actions.length=0)
			
			// NO MORE ACTION
			OB REMOVE:C1226(This:C1470; "actions")
			
		End if 
	End if 
	
/*
=============================================================================================
|                                        FORMS                                              |
=============================================================================================
*/
	
	If (Form:C1466.audit#Null:C1517)
		
		If (Form:C1466.audit.errors#Null:C1517)
			
			For each ($o; Form:C1466.audit.errors)
				
				This:C1470[$o.tab][$o.table]:=New object:C1471
				
			End for each 
		End if 
		
	End if 
	
	OB REMOVE:C1226(Form:C1466; "audit")
	Form:C1466.status.project:=True:C214
	
	//MARK:-[PRIVATE]
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _fieldID($field; $table) : Text
	
	var $key : Text
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($field)=Is object:K8:27)
			
			Case of 
					
					//======================================
				: ($field.fieldNumber#Null:C1517)
					
					return (String:C10($field.fieldNumber))
					
					//======================================
				: ($field.id#Null:C1517)
					
					return (String:C10($field.id))
					
					//======================================
				: (Length:C16(String:C10($field.name))>0)
					
					If ($table[String:C10($field.name)]#Null:C1517)  // Name refrenced
						
						return (String:C10($field.name))
						
					Else 
						
						For each ($key; $table)
							
							If (Length:C16($key)=0)
								
								continue
								
							End if 
							
							If (Match regex:C1019("(?m-si)^\\d+$"; $key; 1; *))\
								 && ($table[$key].name=String:C10($field.name))
								
								return ($key)
								
							End if 
						End for each 
					End if 
					
					//======================================
				Else 
					
					ASSERT:C1129(False:C215)
					
					//======================================
			End case 
			
			//______________________________________________________
		: (Value type:C1509($field)=Is text:K8:3)
			
			If (Match regex:C1019("(?m-si)^\\d+$"; $field; 1; *))  // ID
				
				return ($field)
				
			Else 
				
				If ($table[$field]#Null:C1517)  // Name refrenced
					
					return ($field)
					
				Else 
					
					For each ($key; $table)
						
						If (Length:C16($key)=0)
							
							continue
							
						End if 
						
						If (Match regex:C1019("(?m-si)^\\d+$"; $key; 1; *))\
							 && ($table[$key].name=$field)
							
							return ($key)
							
						End if 
					End for each 
				End if 
			End if 
			
			//______________________________________________________
		: (Value type:C1509($field)=Is longint:K8:6)\
			 | (Value type:C1509($field)=Is real:K8:4)
			
			return (String:C10($field))
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215)
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _tableID($table) : Text
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($table)=Is object:K8:27)
			
			Case of 
					
					//======================================
				: ($table[""].name#Null:C1517)
					
					return (String:C10(ds:C1482[$table[""].name].getInfo().tableNumber))
					
					//======================================
				: ($table.tableNumber#Null:C1517)
					
					return (String:C10($table.tableNumber))
					
					//======================================
				: ($table[""].tableNumber#Null:C1517)
					
					return (String:C10($table[""].tableNumber))
					
					//======================================
				: ($table.relatedTableNumber#Null:C1517)
					
					return (String:C10($table.relatedTableNumber))
					
					//======================================
				Else 
					
					ASSERT:C1129(False:C215)
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($table)=Is text:K8:3)
			
			If (Match regex:C1019("(?m-si)^\\d+$"; $table; 1; *))
				
				return ($table)
				
			Else 
				
				var $key : Text
				For each ($key; This:C1470.dataModel)
					
					If (This:C1470.dataModel[$key][""].name=$table)
						
						return ($key)
						
					End if 
				End for each 
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Value type:C1509($table)=Is longint:K8:6)\
			 | (Value type:C1509($table)=Is real:K8:4)
			
			return (String:C10($table))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			ASSERT:C1129(False:C215)
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function _checkFieldForRepair($current : Object; $audit : Object) : Boolean
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($audit=Null:C1517)
			
			return (True:C214)  // 😇 We can go dancing
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($audit.missing)
			
			// ❌ THE FIELD DOESN'T EXIST ANYMORE
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Bool:C1537($audit.typeMismatch))
			
			Case of 
					
					//======================================
				: (This:C1470.isString($audit.fieldType))\
					 & (This:C1470.isString($audit.current.fieldType))
					
					$current.fieldType:=$audit.current.fieldType  // Update
					return (True:C214)  // 🆗
					
					//======================================
				: (This:C1470.isNumeric($audit.fieldType))\
					 & (This:C1470.isNumeric($audit.current.fieldType))
					
					$current.fieldType:=$audit.current.fieldType  // Update
					return (True:C214)  // 🆗
					
					//======================================
				Else 
					
					// ❌ INCOMPATIBLE TYPE
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Bool:C1537($audit.nameMismatch))
			
			$current.name:=$audit.current.name  // Update
			return (True:C214)  // 🆗
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			oops
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 