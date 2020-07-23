Class constructor
	
	var $1 : Object
	This:C1470.project:=$1
	
	//====================================
Function get
	var $0 : Object
	
	var $t; $tt : Text
	var $o; $project : Object
	
	$project:=OB Copy:C1225(This:C1470.project)
	
	For each ($t; $project)
		
		If ($t[[1]]="$")
			
			OB REMOVE:C1226($project; $t)
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Value type:C1509($project[$t])=Is object:K8:27)
					
					For each ($tt; $project[$t])
						
						If ($tt[[1]]="$")
							
							OB REMOVE:C1226($project[$t]; $tt)
							
						End if 
					End for each 
					
					//______________________________________________________
				: (Value type:C1509($project[$t])=Is collection:K8:32)
					
					For each ($o; $project[$t])
						
						For each ($tt; $o)
							
							If ($tt[[1]]="$")
								
								OB REMOVE:C1226($o; $tt)
								
							End if 
						End for each 
					End for each 
					
					//______________________________________________________
			End case 
		End if 
	End for each 
	
	$0:=$project
	
	//====================================
Function save
	
	var $project : Object
	$project:=OB Copy:C1225(This:C1470.project)
	
	var $o : Object
	
	If (Bool:C1537(feature._8858))  // Debug mode
		
		$o:=Folder:C1567(fk desktop folder:K87:19).folder("DEV")
		
		If ($o.exists)
			
			$o.file("project.json").setText(JSON Stringify:C1217(This:C1470.project; *))
			
		End if 
	End if 
	
	$project:=This:C1470.get()
	
	var $t : Text
	$t:=This:C1470.project.$project.project
	CREATE FOLDER:C475($t; *)
	
	TEXT TO DOCUMENT:C1237($t; JSON Stringify:C1217($project; *))
	
	//====================================
Function updateActions
	var $indx : Integer
	var $dataModel; $parameter; $table : Object
	var $actions : Collection
	
	$actions:=This:C1470.project.actions
	
	If ($actions#Null:C1517)
		
		$dataModel:=This:C1470.project.dataModel
		
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
			OB REMOVE:C1226(This:C1470.project; "actions")
			
		End if 
	End if 
	
	//====================================
Function removeFromMain
	
	var $1
	var $main : Object
	$main:=This:C1470.project.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472
		
	Else 
		
		var $l : Integer
		$l:=$main.order.indexOf(String:C10($1))
		
		If ($l#-1)
			
			$main.order.remove($l)
			
		End if 
	End if 
	
	//====================================
Function addToMain
	
	var $1
	var $main : Object
	$main:=This:C1470.project.main
	
	If ($main.order=Null:C1517)
		
		$main.order:=New collection:C1472(String:C10($1))
		
	Else 
		
		If ($main.order.indexOf(String:C10($1))=-1)
			
			$main.order.push(String:C10($1))
			
		End if 
	End if 
	
	//====================================
Function isField
	
	var $0 : Boolean
	var $1 : Text
	$0:=Match regex:C1019("(?m-si)^\\d+$"; $1; 1; *)
	
	//====================================
Function isRelation
	
	var $0 : Boolean
	var $1 : Object
	$0:=((This:C1470.isRelationToOne($1)) | (This:C1470.isRelationToMany($1)))
	
	//====================================
Function isRelationToOne
	
	var $0 : Boolean
	var $1 : Object
	$0:=($1.relatedDataClass#Null:C1517)
	
	//====================================
Function isRelationToMany
	
	var $0 : Boolean
	var $1 : Object  // Field
	$0:=(($1.relatedEntities#Null:C1517) | (String:C10($1.kind)="relatedEntities"))
	
/* ===================================
Add the table to the data model
====================================*/
Function addTable
	var $0 : Object
	var $1 : Object
	
	var $o : Object
	
	$o:=This:C1470.getCatalog().query("tableNumber = :1"; $1.tableNumber).pop()
	
	// Put internal properties into a substructure
	$0:=New object:C1471(\
		""; New object:C1471(\
		"name"; $o.name; \
		"label"; formatString("label"; $o.name); \
		"shortLabel"; formatString("label"; $o.name); \
		"primaryKey"; String:C10($o.primaryKey); \
		"embedded"; True:C214)\
		)
	
	// Update dataModel
	If (This:C1470.project.dataModel=Null:C1517)
		
		This:C1470.project.dataModel:=New object:C1471
		
	End if 
	
	// Update main
	This:C1470.addToMain($1.tableNumber)
	
	This:C1470.project.dataModel[String:C10($1.tableNumber)]:=$0
	
/* ===================================
Delete the table from the data model
====================================*/
Function removeTable
	
	var $1
	OB REMOVE:C1226(This:C1470.project.dataModel; String:C10($1))
	
	// Update main
	This:C1470.removeFromMain($1)
	
	//====================================
Function getCatalog
	
	var $0 : Collection
	
	Case of 
			
			//____________________________________
		: (This:C1470.project.$project#Null:C1517)
			
			$0:=This:C1470.project.$project.$catalog
			
			//____________________________________
		: (This:C1470.project.$catalog#Null:C1517)
			
			$0:=This:C1470.project.$catalog
			
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