//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : db
// ID[688E4624BD3B4182AB62DD632AD26182]
// Created 4-7-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_BOOLEAN:C305($b; $Boo_found)
C_LONGINT:C283($l)
C_TEXT:C284($t; $Txt_field; $Txt_table)
C_OBJECT:C1216($o; $Obj_catalog; $Obj_field; $Obj_table)
C_COLLECTION:C1488($c; $cc)

If (False:C215)
	C_OBJECT:C1216(db; $0)
	C_TEXT:C284(db; $1)
	C_OBJECT:C1216(db; $2)
End if 

// ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	$o:=New object:C1471(\
		""; "db"; \
		"deletedRecordsTable"; "__DeletedRecords"; \
		"stampField"; "__GlobalStamp"; \
		"exclude"; New collection:C1472; \
		"datastore"; Null:C1517; \
		"pushError"; Formula:C1597(db("pushError"; New object:C1471("container"; $1; "message"; $2; "type"; $3))); \
		"exposedDatastore"; Formula:C1597(db("exposedDatastore"; New object:C1471("table"; $1; "sorted"; $2))); \
		"table"; Formula:C1597(db("table"; New object:C1471("table"; $1))); \
		"field"; Formula:C1597(db("field"; New object:C1471("table"; $1; "field"; $2)))\
		)
	
	If (Count parameters:C259>=1)
		
		// Semicolon separated list of excluded field type
		$o.exclude:=Split string:C1554(String:C10($1); ";")
		
	End if 
	
Else 
	
	$o:=New object:C1471(\
		"success"; False:C215)
	
	Case of 
			
			//______________________________________________________
		: (This:C1470=Null:C1517)
			
			ASSERT:C1129(False:C215; "OOPS, this method must be called from a member method")
			
			//______________________________________________________
		: ($1="pushError")  // Push error
			
			If ($2.type=Null:C1517)
				
				$2.type:=Error message:K38:3
				
			End if 
			
			$t:=Choose:C955(Num:C11($2.type); "infos"; "warnings"; "errors")
			
			If ($2.container[$t]=Null:C1517)
				
				$2.container[$t]:=New collection:C1472($2.message)
				
			Else 
				
				If ($2.container[$t].indexOf($2.message)=-1)
					
					$2.container[$t].push($2.message)
					
				End if 
			End if 
			
			//______________________________________________________
		: ($1="field")  // Returns the field definition from the starting table number and its path
			
			If (This:C1470.datastore=Null:C1517)
				
				This:C1470.exposedDatastore()
				
			End if 
			
			Case of 
					
					//______________________________________________________
				: ($2.table=Null:C1517)
					
					This:C1470.pushError($o; "Missing table identifier")
					
					//______________________________________________________
				: (Value type:C1509($2.table)=Is longint:K8:6)\
					 | (Value type:C1509($2.table)=Is real:K8:4)
					
					$c:=This:C1470.datastore.query("tableNumber = :1"; $2.table)
					
					//______________________________________________________
				Else 
					
					$c:=This:C1470.datastore.query("name = :1"; $2.table)
					
					//______________________________________________________
			End case 
			
			If ($c.length=1)
				
				$Obj_table:=$c[0]
				
				Case of 
						
						//______________________________________________________
					: ($2.field=Null:C1517)
						
						This:C1470.pushError($o; "Missing field identifier")
						
						//______________________________________________________
					: (Value type:C1509($2.field)=Is longint:K8:6)\
						 | (Value type:C1509($2.field)=Is real:K8:4)
						
						$c:=$Obj_table.fields.query("fieldNumber = :1"; $2.field)
						
						//______________________________________________________
					Else 
						
						$cc:=Split string:C1554($2.field; ".")
						
						If ($cc.length=1)
							
							$c:=$Obj_table.fields.query("name = :1"; $2.field)
							
						Else 
							
							// #MARK_TODO with a path if any
							
							//$c:=$Obj_table.fields.query("name = :1";$c[0])
							//If ($c.length=1)
							//$Lon_tableNumber:=$c[0].relatedTableNumber
							// Else
							//  // A "If" statement should never omit "Else"
							// End if
							
						End if 
						
						//______________________________________________________
				End case 
				
				If ($c.length=1)
					
					$o.success:=True:C214
					$o.result:=$c[0]
					
				Else 
					
					This:C1470.pushError($o; "Field not found")
					
				End if 
				
			Else 
				
				This:C1470.pushError($o; "Table not found: "+Choose:C955((Value type:C1509($2.table)=Is longint:K8:6) | (Value type:C1509($2.table)=Is real:K8:4); "#"+String:C10($2.table); "\""+String:C10($2.table)+"\""))
				
			End if 
			
			//______________________________________________________
		: ($1="table")  // Returns the definition of the table from the number or name of the table.
			
			If (This:C1470.datastore=Null:C1517)
				
				This:C1470.exposedDatastore()
				
			End if 
			
			Case of 
					
					//______________________________________________________
				: ($2.table=Null:C1517)
					
					This:C1470.pushError($o; "Missing table identifier")
					
					//______________________________________________________
				: (Value type:C1509($2.table)=Is longint:K8:6)\
					 | (Value type:C1509($2.table)=Is real:K8:4)
					
					$c:=This:C1470.datastore.query("tableNumber = :1"; $2.table)
					
					//______________________________________________________
				Else 
					
					$c:=This:C1470.datastore.query("name = :1"; $2.table)
					
					//______________________________________________________
			End case 
			
			If ($c.length=1)
				
				$o.success:=True:C214
				$o.result:=$c[0]
				
			Else 
				
				This:C1470.pushError($o; "Table not found: "+Choose:C955((Value type:C1509($2.table)=Is longint:K8:6) | (Value type:C1509($2.table)=Is real:K8:4); "#"+String:C10($2.table); "\""+String:C10($2.table)+"\""))
				
			End if 
			
			//______________________________________________________
		: ($1="exposedDatastore")  // Update & returns the exposed datastore
			
			// --------------------------------------------------------------------------------------
			// If a name or table number is passed, the result is limited to the corresponding table
			// --------------------------------------------------------------------------------------
			
			// • Only references tables with a single primary key. Tables without a primary key or with composite primary keys are not referenced.
			// • Only references tables & fields exposed with 4D Mobile services.
			// • BLOB type attributes are not managed in the datastore.
			// • A relation N -> 1 is not referenced if the field isn't exposed !
			// • A relation 1 -> N is not referenced if the related dataclass isn't exposed !
			
			This:C1470.datastore:=New collection:C1472
			
			$Obj_catalog:=_4D_Build Exposed Datastore:C1598
			
			$o.success:=($Obj_catalog#Null:C1517)
			
			If ($o.success)
				
				For each ($Txt_table; $Obj_catalog) Until ($Boo_found)
					
					$Obj_table:=$Obj_catalog[$Txt_table].getInfo()
					
					If ($Txt_table#This:C1470.deletedRecordsTable)
						
						This:C1470.datastore.push($Obj_table)
						
						$Obj_table.fields:=New collection:C1472
						
						For each ($Txt_field; $Obj_catalog[$Txt_table])
							
							If ($Txt_field#This:C1470.stampField)
								
								$Obj_field:=$Obj_catalog[$Txt_table][$Txt_field]
								
								// NOT ALLOW DUPLICATE NAMES !
								
								$l:=$Obj_table.fields.extract("name").indexOf($Txt_field)
								$b:=($l=-1)
								
								If (Not:C34($b))
									
									$t:=$Obj_table.fields.extract("name")[$l]
									
									Case of 
											
											//_____________________________
										: (Length:C16($Txt_field)#Length:C16($t))
											
											// Obviously not identical
											$b:=True:C214
											
											//_____________________________
										Else 
											
											$b:=(Position:C15($Txt_field; $t; 1; *)#1)
											
											//_____________________________
									End case 
								End if 
								
								Case of 
										
										//…………………………………………………………………………………………………
									: (Not:C34($b))  // Duplicate name
										
										This:C1470.pushError(This:C1470; "Name conflict for \""+$Txt_field+"\""; Warning message:K38:2)
										
										//…………………………………………………………………………………………………
									: (Position:C15("."; $Txt_field)>0)  // Field or relation name with dot
										
										This:C1470.pushError(This:C1470; "Name with dot : \""+$Txt_field+"\""; Warning message:K38:2)
										
										//…………………………………………………………………………………………………
									: ($Obj_field.kind="storage")
										
										// Exclude subtable and given field types, if any
										If ($Obj_field.fieldType#Is subtable:K8:11)\
											 & (This:C1470.exclude.indexOf($Obj_field.type)=-1)
											
											$Obj_table.fields.push($Obj_field)
											
										End if 
										
										//…………………………………………………………………………………………………
									: ($Obj_field.kind="relatedEntity")\
										 | ($Obj_field.kind="relatedEntities")
										
										If ($Obj_catalog[$Obj_field.relatedDataClass]#Null:C1517)
											
											$Obj_table.fields.push($Obj_field)
											
										End if 
										
										//…………………………………………………………………………………………………
								End case 
								
							Else 
								
								// DON'T DISPLAY STAMP FIELD
								
							End if 
						End for each 
					End if 
				End for each 
				
				$o.result:=This:C1470.datastore
				
			Else 
				
				This:C1470.pushError(This:C1470; "No table exposed")
				
			End if 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unknown entry point: \""+$1+"\"")
			
			//______________________________________________________
	End case 
End if 

// ----------------------------------------------------
// Return
$0:=$o

// ----------------------------------------------------
// End