Class constructor($project : Object)
	
	Super:C1705()
	
	If (Count parameters:C259>=1)
		
		This:C1470.init($project)
		
	End if 
	
	This:C1470.regexParameters:="(?mi-s)(=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:[^\\s]*"
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function init($project : Object)
	
	var $key : Text
	
	For each ($key; $project)
		
		If ($key[[1]]#"$")
			
			This:C1470[$key]:=$project[$key]
			
		End if 
	End for each 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function load($project)->$this : cs:C1710.project
	
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
		This:C1470._folder:=$file.parent
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
	
	$this:=This:C1470
	
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
	
	$file:=This:C1470._folder.file("project.4dmobileapp")
	$file.setText(JSON Stringify:C1217(This:C1470.cleaned(); *))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Populate the target value into the project                                                                         #MARK_TODO : SHOULD BE TREATED INTO THE EDITOR CLASS
Function setTarget($checkDevTools : Boolean; $target : Text)
	
	If (This:C1470.$ios & This:C1470.$android)
		
		This:C1470.info.target:=New collection:C1472("iOS"; "android")
		
	Else 
		
		If (Not:C34(This:C1470.$android))
			
			// According to platform
			This:C1470.info.target:=Choose:C955(Is macOS:C1572; "iOS"; "android")
			
			var $t : Text
			$t:=This:C1470.info.target
			This:C1470["$"+Lowercase:C14($t)]:=True:C214
			
		Else 
			
			This:C1470.info.target:=Choose:C955(This:C1470.$android; "android"; "iOS")
			
		End if 
	End if 
	
	// Save & update the project folder
	This:C1470.save()
	This:C1470.prepare()
	
	EDITOR.ios:=This:C1470.$ios
	EDITOR.android:=This:C1470.$android
	
	If (Count parameters:C259>=1)
		
		If ($checkDevTools)  // Audit of development tools
			
			If (Count parameters:C259>=2)  // Set the build target
				
				Case of 
						
						//________________________
					: ($target="ios") & This:C1470.$ios
						
						This:C1470._buildTarget:=$target
						
						If (EDITOR.xCode#Null:C1517)
							
							EDITOR.xCode.canceled:=False:C215
							EDITOR.xCode.alreadyNotified:=False:C215
							
						End if 
						
						//________________________
					: ($target="android") & This:C1470.$ios
						
						This:C1470._buildTarget:=$target
						
						If (EDITOR.studio#Null:C1517)
							
							EDITOR.studio.canceled:=False:C215
							EDITOR.studio.alreadyNotified:=False:C215
							
						End if 
						
						//________________________
				End case 
			End if 
			
			EDITOR.checkDevTools()
			
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
Function isLocked()->$isLocked : Boolean
	
	If (This:C1470.structure#Null:C1517)
		
		$isLocked:=Bool:C1537(This:C1470.structure.unsynchronized)
		
	Else 
		
		$isLocked:=Bool:C1537(This:C1470.$project.structure.unsynchronized)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tests if the project is not locked and
Function isNotLocked()->$isNotLocked : Boolean
	
	$isNotLocked:=Not:C34(This:C1470.isLocked())
	
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
Function removeFromMain($table)
	var $index : Integer
	var $main : Object
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472
		
	Else 
		
		$index:=$main.order.indexOf(String:C10($table))
		
		If ($index#-1)
			
			$main.order.remove($index)
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function addToMain($table)
	var $main : Object
	
	$main:=This:C1470.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472(String:C10($table))
		
	Else 
		
		If ($main.order.indexOf(String:C10($table))=-1)
			
			$main.order.push(String:C10($table))
			
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
Function isField($attribute : Variant)->$is : Boolean
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($attribute)=Is text:K8:3)
			
			$is:=Match regex:C1019("(?m-si)^\\d+$"; $attribute; 1; *)
			
			//______________________________________________________
		: (Value type:C1509($attribute)=Is object:K8:27)
			
			$is:=($attribute.fieldType#Null:C1517)
			
			//______________________________________________________
	End case 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if it is a storage or calculated attribute
Function isFieldAttribute($fieldName : Text; $tableName : Text)->$is : Boolean
	
	var $field; $table : Object
	
	$table:=This:C1470.getCatalog().query("name = :1"; $tableName).pop()
	
	If ($table#Null:C1517)
		
		$field:=$table.field.query("name = :1"; $fieldName).pop()
		
	End if 
	
	$is:=$field#Null:C1517
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelation($attribute : Variant)->$is : Boolean
	
	$is:=((This:C1470.isRelationToOne($attribute)) | (This:C1470.isRelationToMany($attribute)))
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelationToOne($attribute : Variant)->$is : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		$is:=($attribute.relatedDataClass#Null:C1517) & (Not:C34(Bool:C1537($attribute.isToMany)))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isRelationToMany($attribute : Variant)->$is : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		$is:=(($attribute.relatedEntities#Null:C1517) | (String:C10($attribute.kind)="relatedEntities")) | (Bool:C1537($attribute.isToMany))
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function isAvailable($dataClass : 4D:C1709.DataClass; $path : Variant)->$success : Boolean
	
	var $t : Text
	var $o : Object
	var $c : Collection
	
	$o:=$dataClass
	$c:=Split string:C1554($path; ".")
	
	For each ($t; $c)
		
		If ($o[$t].relatedDataClass#Null:C1517)
			
			$o:=ds:C1482[$o[$t].relatedDataClass]
			
		Else 
			
			$o:=$o[$t]
			
		End if 
	End for each 
	
	$success:=($o#Null:C1517)
	
	//====================================
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
Function isComputedAttribute($field : Object; $tableName : Text)->$is : Boolean
	
	var $o : Object
	var $c : Collection
	
	$is:=(String:C10($field.kind)="calculated") | (Bool:C1537($field.computed)) | (Num:C11($field.type)=-3)
	
	If ($is & (Count parameters:C259>=2))
		
		$is:=False:C215
		
		// Filter writable (not readOnly) computed attrbutes
		$c:=This:C1470.getCatalog()
		
		If ($c#Null:C1517)
			
			$o:=$c.query("name = :1"; $tableName).pop()
			
			If ($o#Null:C1517)
				
				$o:=$o.field.query("name = :1"; $field.name).pop()
				
				If ($o#Null:C1517)
					
					$is:=Not:C34(Bool:C1537($o.readOnly))
					
				End if 
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function checkRestQueryFilter($table : Object)
	
	var $buffer : Text
	var $success : Boolean
	var $filter; $response : Object
	
	$filter:=$table.filter
	
	OB REMOVE:C1226($filter; "error")
	OB REMOVE:C1226($filter; "errors")
	OB REMOVE:C1226($filter; "code")
	OB REMOVE:C1226($filter; "httpError")
	OB REMOVE:C1226($filter; "parameters")
	
	OB REMOVE:C1226($table; "count")
	
	// Detect a query with parameters
	$filter.parameters:=(Match regex:C1019(This:C1470.regexParameters; $filter.string; 1))
	
	If ($filter.parameters)
		
		$buffer:=$filter.string
		
		If (Rgx_SubstituteText(This:C1470.regexParameters; "\\1\"@\""; ->$buffer)=0)
			
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
			
			ASSERT:C1129(Length:C16(String:C10($table.filter.string))>0)
			
			$filter:=$table.filter
			
			OB REMOVE:C1226($filter; "error")
			OB REMOVE:C1226($filter; "errors")
			OB REMOVE:C1226($filter; "code")
			OB REMOVE:C1226($filter; "httpError")
			OB REMOVE:C1226($filter; "parameters")
			
			OB REMOVE:C1226($table; "count")
			
			// Detect a query with parameters
			$filter.parameters:=(Match regex:C1019(This:C1470.regexParameters; $filter.string; 1))
			
			If ($filter.parameters)
				
				$buffer:=$filter.string
				
				If (Rgx_SubstituteText(This:C1470.regexParameters; "\\1:1"; ->$buffer)=0)
					
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
				
				If (FEATURE.with("cancelableDatasetGeneration"))
					
					$table.count:=ds:C1482[$table.name].count($filter.string)
					
				Else 
					
					ds:C1482[$table.name].query($filter.string)
					
				End if 
				
				$error.release()
				//mark: - STOP TRAPPING ERRORS
				
				$success:=Bool:C1537(Num:C11($error.lastError().error)=0)
				
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
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if field is an alias
Function isAlias($attribute : Variant)->$is : Boolean
	
	If (Value type:C1509($attribute)=Is object:K8:27)
		
		$is:=(String:C10($attribute.kind)="alias")
		
	End if 
	
	// Returns alias destination if alias 
	// CLEAN: maybe move to structure?
Function getAliasDestination($dataClass : Variant; $attribute : Variant; $recursive : Boolean)->$result : Object
	If (Value type:C1509($attribute)=Is object:K8:27)
		If (String:C10($attribute.kind)="alias")
			If (Length:C16(String:C10($attribute.path))>0)
				
				var $ds : Object
				$ds:=ds:C1482
				
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
					
					$result.paths.push(New object:C1471("path"; $path; "dataClass"; $sourceDataClass.getInfo().name))
					
					$previousDataClass:=$sourceDataClass
					If ($destination.relatedDataClass#Null:C1517)  // is relatedDataClass filled for alias? like destination field
						$sourceDataClass:=$ds[$destination.relatedDataClass]
					End if 
					
				Until ($paths.length=0)
				
				$result.field:=$destination
				
				If (Bool:C1537($recursive))
					If (String:C10($result.field.kind)="alias")  // maybe an alias too
						var $rs : Object
						$rs:=This:C1470.getAliasDestination($previousDataClass; $result.field; True:C214)
						
						$result.paths.combine($rs.paths)
						$result.field:=$rs
					End if 
				End if 
				
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the 4D Type is a Numeric type
Function isNumeric($type : Integer)->$is : Boolean
	
	$is:=(New collection:C1472(Is integer:K8:5; Is longint:K8:6; Is integer 64 bits:K8:25; Is real:K8:4; _o_Is float:K8:26).indexOf($type)#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the 4D Type is a String type
Function isString($type : Integer)->$is : Boolean
	
	$is:=(New collection:C1472(Is alpha field:K8:1; Is text:K8:3).indexOf($type)#-1)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the field is sortable
Function isSortable($field : Object)->$sortable : Boolean
	
	If ($field.fieldType#Null:C1517)
		
		If ($field.fieldType#Is object:K8:27)\
			 & ($field.fieldType#Is BLOB:K8:12)\
			 & ($field.fieldType#Is picture:K8:10)
			
			$sortable:=True:C214
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns True if the resource comes from the host's database.
Function isCustomResource($resource : Text)->$custom : Boolean
	
	If (Length:C16($resource)>0)
		//%W-533.1
		$custom:=($resource[[1]]="/")
		//%W+533.1
	Else 
		$custom:=False:C215
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the collection of table's sortable field
Function getSortableFields($table; $ordered : Boolean)->$fields : Collection
	
	var $field; $model : Object
	
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
		
		If (FEATURE.with("computedProperties"))
			
			For each ($field; OB Entries:C1720($model))
				
				If ($field.value.fieldType#Null:C1517)
					
					If (This:C1470.isSortable($field.value))
						
						If (Bool:C1537($field.value.computed)) | ($field.value.type=-3)
							
							OB REMOVE:C1226($field.value; "fieldNumber")
							
						End if 
						
						$fields.push($field.value)
						
					End if 
				End if 
			End for each 
			
		Else 
			
			var $c : Collection
			$c:=OB Entries:C1720($model).filter("col_formula"; Formula:C1597($1.result:=Match regex:C1019("^\\d+$"; $1.value.key; 1)))
			
			For each ($field; $c)
				
				If (This:C1470.isSortable($field.value))
					
					$field.value.fieldNumber:=Num:C11($field.key)
					$fields.push($field.value)
					
				End if 
			End for each 
		End if 
		If (Count parameters:C259>=2)
			
			If ($ordered)
				
				// Sort by name
				$fields:=$fields.orderBy("name")
				
			End if 
		End if 
		
	Else 
		
		// #Error
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	//Add a table to the data model
Function addTable($table : Object)->$tableModel : Object
	
	var $o : Object
	
	ASSERT:C1129($table.tableNumber#Null:C1517)
	
	$o:=This:C1470.getCatalog().query("tableNumber = :1"; $table.tableNumber).pop()
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
	
	// Update main
	This:C1470.addToMain($table.tableNumber)
	
	This:C1470.dataModel[String:C10($table.tableNumber)]:=$tableModel
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Delete the table from the data model
Function removeTable($table)
	
	If (This:C1470.dataModel#Null:C1517)
		
		OB REMOVE:C1226(This:C1470.dataModel; String:C10($table))
		
	End if 
	
	// Update main
	This:C1470.removeFromMain($table)
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
Function getCatalog()->$catalog : Collection
	
	Case of 
			
			//____________________________________
		: (This:C1470.$project#Null:C1517)
			
			$catalog:=This:C1470.$project.$catalog
			
			//____________________________________
		: (This:C1470.$catalog#Null:C1517)
			
			$catalog:=This:C1470.$catalog
			
			//____________________________________
		Else 
			
			ASSERT:C1129(False:C215)
			
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
			
			$0:=Replace string:C233($0; "id"; "ID")
			
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
		
		$file:=File:C1566(EDITOR.noIcon; fk platform path:K87:2)
		
	Else 
		
		$file:=cs:C1710.path.new().icon($relativePath)
		
		If (Not:C34($file.exists))
			
			$file:=File:C1566(EDITOR.errorIcon; fk platform path:K87:2)
			
		End if 
	End if 
	
	If ($file.exists)
		
		READ PICTURE FILE:C678($file.platformPath; $icon)
		CREATE THUMBNAIL:C679($icon; $icon; 24; 24; Scaled to fit:K6:2)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Check if a field is still available in the table catalog
Function fieldAvailable($tableID : Variant; $field : Object)->$available : Boolean
	
	var $relatedTableNumber : Integer
	var $o; $relatedCatalog; $tableCatalog : Object
	var $c : Collection
	var $fieldID : Text
	
	// Accept num or string
	$tableID:=String:C10($tableID)
	$fieldID:=String:C10($field.id)
	
	$c:=Split string:C1554($field.name; ".")
	
	If ($c.length=1)
		
		// Check the data class
		If ($field.relatedTableNumber#Null:C1517)
			
			// Relation = use name
			$available:=(This:C1470.dataModel[$tableID][$field.name]#Null:C1517)
			
		Else 
			
			// Field = use id
			$available:=(This:C1470.dataModel[$tableID][$fieldID]#Null:C1517)
			
		End if 
		
	Else 
		
		// Check the related data class
		$tableCatalog:=This:C1470.$project.$catalog.query("tableNumber = :1"; Num:C11($tableID)).pop()
		
		If ($tableCatalog#Null:C1517)  // The table exists
			
			$relatedTableNumber:=Num:C11($tableCatalog.field.query("name= :1"; $c[0]).pop().relatedTableNumber)
			
			If ($relatedTableNumber>0)
				
				$relatedCatalog:=This:C1470.$project.$catalog.query("tableNumber = :1"; $relatedTableNumber).pop()
				
				If ($relatedCatalog#Null:C1517)  // The linked table exists
					
					If (This:C1470.dataModel[$tableID][$c[0]]#Null:C1517)  // The relation is published
						
						If (Num:C11($fieldID)#0)
							
							If ($relatedCatalog.field.query("id = :1"; Num:C11($fieldID)).pop()#Null:C1517)
								
								$available:=(This:C1470.dataModel[$tableID][$c[0]][$fieldID]#Null:C1517)
								
							End if 
							
						Else 
							
							If ($relatedCatalog.field.query("name = :1"; $c[1]).pop()#Null:C1517)
								
								$available:=(This:C1470.dataModel[$tableID][$c[0]][$c[1]]#Null:C1517)
								
							End if 
						End if 
					End if 
				End if 
			End if 
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Update all form definition according to the datamodel
	// Ie. remove from forms, the fields that are no more published
Function updateFormDefinitions()
	var $formType; $tableID : Text
	var $field; $target : Object
	
	RECORD.info("updateFormDefinitions()")
	
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
	/// Performs the project audit                                                                                          #MARK_TODO : remove $project.status.project
Function audit($audits : Object)->$audit : Object
	
	If (Count parameters:C259>=1)
		
		EDITOR.projectAudit:=project_Audit($audits)
		
	Else 
		
		EDITOR.projectAudit:=project_Audit
		
	End if 
	
	cs:C1710.ob.new(This:C1470).set("$project.status.project"; EDITOR.projectAudit.success)  //#TO_REMOVE
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns the published tables as a collection
Function publishedTables()->$tables : Collection
	
	var $tableID : Text
	var $meta; $table : Object
	
	$tables:=New collection:C1472
	
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
	
	//================================================================================
Function fieldDefinition
	
	//MARK: TODO
	
	//=== === === === === === === === === === === === === === === === === === === === === === === === === === === ===
	// Makes a Backup of the project & catalog
Function backup()
	
	var $file : 4D:C1709.File
	var $backup : 4D:C1709.Folder
	
	$backup:=This:C1470._folder.folder(Replace string:C233(Get localized string:C991("replacedFiles"); "{stamp}"; cs:C1710.dateTime.new().stamp()))
	$backup.create()
	
	// Copy the project
	$file:=This:C1470._folder.file("project.4dmobileapp")
	$file.copyTo($backup)
	
	// Copy the catalog
	$file:=$file.parent.file("catalog.json")
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
						: (This:C1470.isField($item.key))
							
							$field:=$table.query("fieldNumber = :1"; Num:C11($item.key)).pop()
							
							If (This:C1470._checkFieldForRepair($current; $field))
								
								$tablePublishedFieldNumber:=$tablePublishedFieldNumber+1
								
							Else 
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (This:C1470.isRelationToOne($item.value))
							
							$field:=$table.query("name = :1"; $item.key).pop()
							
							If ($field.missing)  // ❌ THE RELATION DOESN'T EXIST ANYMORE
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							Else 
								
								$relatedCount:=0
								
								For each ($relatedItem; OB Entries:C1720($item.value).query("value.name != null"))
									
									$relatedField:=$relatedItem.value
									
									Case of 
											
											//======================================
										: (This:C1470.isField($relatedItem.key))
											
											$field:=$table.query("fieldNumber = :1"; Num:C11($relatedItem.key)).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($current[$item.key]; $relatedItem.key)
												
											End if 
											
											//======================================
										: (This:C1470.isRelationToMany($relatedField))
											
											$field:=$table.query("name = :1"; $relatedField.name).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($current; $relatedItem.key)
												
											End if 
											
											//======================================
										: (This:C1470.isRelationToOne($relatedField))
											
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
										: (This:C1470.isComputedAttribute($relatedField))
											
											$field:=$table.query("name = :1"; $relatedField.name).pop()
											
											If (This:C1470._checkFieldForRepair($current; $field))
												
												$relatedCount:=$relatedCount+1
												
											Else 
												
												OB REMOVE:C1226($item.value; $relatedItem.key)
												
											End if 
											
											//======================================
									End case 
								End for each 
								
								If ($relatedCount=0)  // ❌ NO MORE PUBLISHED FIELDS FROM THE RELATED TABLE
									
									OB REMOVE:C1226($tableModel; $item.key)
									
								Else 
									
									$tablePublishedFieldNumber:=$tablePublishedFieldNumber+1
									
								End if 
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (This:C1470.isRelationToMany($item.value))
							
							If ($datastore[$tableModel[$item.key].relatedEntities]=Null:C1517)
								
								// ❌ THE RELATED TABLE DOESN'T EXIST ANYMORE
								OB REMOVE:C1226($tableModel; String:C10($item.key))
								
							Else 
								
								$tablePublishedFieldNumber:=$tablePublishedFieldNumber+1
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (This:C1470.isComputedAttribute($item.value))
							
							$field:=$table.query("name = :1"; $item.key).pop()
							
							If (This:C1470._checkFieldForRepair($current; $field))
								
								$tablePublishedFieldNumber:=$tablePublishedFieldNumber+1
								
							Else 
								
								OB REMOVE:C1226($tableModel; $item.key)
								
							End if 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						Else 
							
							ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
							
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
	
	//*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	//
Function _checkFieldForRepair($current : Object; $fromAudit : Object)->$succes : Boolean
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($fromAudit=Null:C1517)
			
			$succes:=True:C214  // 😇 We can go dancing
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($fromAudit.missing)
			
			// ❌ THE FIELD DOESN'T EXIST ANYMORE
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Bool:C1537($fromAudit.typeMismatch))
			
			Case of 
					
					//======================================
				: (This:C1470.isString($fromAudit.fieldType))\
					 & (This:C1470.isString($fromAudit.current.fieldType))
					
					$succes:=True:C214  // 🆗
					$current.fieldType:=$fromAudit.current.fieldType  // Update
					
					//======================================
				: (This:C1470.isNumeric($fromAudit.fieldType))\
					 & (This:C1470.isNumeric($fromAudit.current.fieldType))
					
					$succes:=True:C214  // 🆗
					$current.fieldType:=$fromAudit.current.fieldType  // Update
					
					//======================================
				Else 
					
					// ❌ INCOMPATIBLE TYPE
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (Bool:C1537($fromAudit.nameMismatch))
			
			$succes:=True:C214  // 🆗
			$current.name:=$fromAudit.current.name  // Update
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			ASSERT:C1129(Not:C34(DATABASE.isMatrix); "😰 I wonder why I'm here")
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
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
	