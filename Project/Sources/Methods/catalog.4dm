//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : catalog
// ID[0A02376FAA54403A995124AC0945593D]
// Created 6-2-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Text
var $2 : Object

If (False:C215)
	C_OBJECT:C1216(catalog; $0)
	C_TEXT:C284(catalog; $1)
	C_OBJECT:C1216(catalog; $2)
End if 

var $Txt_action; $fieldName : Text
var $Lon_parameters : Integer
var $o; $Obj_datastore; $Obj_in; $Obj_out; $table : Object
var $Col_tables : Collection

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Txt_action:=$1  // datastore | fields
	
	// Default values
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		// MARK:- datastore
	: ($Txt_action="datastore")
		
		$Obj_datastore:=_4D_Build Exposed Datastore:C1598
		
		$Obj_out.success:=($Obj_datastore#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.datastore:=$Obj_datastore
			
		Else 
			
			err_PUSH($Obj_out; "Null datastore")
			
		End if 
		
		// MARK:- table
	: ($Txt_action="table")
		
		ASSERT:C1129($Obj_in.tableName#Null:C1517)
		
		If ($Obj_in.datastore=Null:C1517)
			
			// Get the datastore
			$Obj_datastore:=catalog("datastore").datastore
			
		Else 
			
			$Obj_datastore:=$Obj_in.datastore
			
		End if 
		
		$Obj_out.success:=($Obj_datastore#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.success:=($Obj_datastore[$Obj_in.tableName]#Null:C1517)
			
			If ($Obj_out.success)
				
				$table:=$Obj_datastore[$Obj_in.tableName]
				$Obj_out.success:=($table#Null:C1517)
				
			End if 
			
			If ($Obj_out.success)
				
				$Obj_out.fields:=New collection:C1472
				
				For each ($fieldName; $table)
					
					$o:=OB Copy:C1225($table[$fieldName])
					
					Case of 
							
							//______________________________________________________
						: ($o.kind="storage")  // Field
							
							$o.typeLegacy:=$o.fieldType
							$Obj_out.fields.push($o)
							
							//______________________________________________________
						: ($o.kind="relatedEntity")  // N -> 1 relation
							
							$Obj_out.fields.push($o)
							
							//______________________________________________________
						: ($o.kind="relatedEntities")  // 1 -> N relation
							
							// <NOT YET  MANAGED>
							
							//______________________________________________________
						: ($o.kind="calculated")  // Computed properties
							
							$o.computed:=True:C214
							$o.type:=-3
							$Obj_out.fields.push($o)
							
							//______________________________________________________
					End case 
				End for each 
				
			Else 
				
				err_PUSH($Obj_out; "Table not found \""+String:C10($Obj_in.tableName)+"\"")
				
			End if 
		End if 
		
		// MARK:- fields
	: ($Txt_action="fields")
		
		ASSERT:C1129($Obj_in.tableName#Null:C1517)
		
		If ($Obj_in.datastore=Null:C1517)
			
			// Get the datastore
			$Obj_datastore:=catalog("datastore").datastore
			
		Else 
			
			$Obj_datastore:=$Obj_in.datastore
			
		End if 
		
		$Obj_out.success:=($Obj_datastore#Null:C1517)
		
		If ($Obj_out.success)
			
			If ($Obj_in.tables=Null:C1517)
				
				// Create
				$Col_tables:=New collection:C1472
				
			Else 
				
				$Col_tables:=$Obj_in.tables
				
			End if 
			
			$Obj_out.success:=($Obj_datastore[$Obj_in.tableName]#Null:C1517)
			
			If ($Obj_out.success)
				
				$table:=$Obj_datastore[$Obj_in.tableName]
				$Obj_out.success:=($table#Null:C1517)
				
			End if 
			
			If ($Obj_out.success)
				
				$Col_tables.push($Obj_in.tableName)
				$Obj_out.fields:=New collection:C1472
				
				For each ($fieldName; $table)
					
					Case of 
							
							//______________________________________________________
						: ($table[$fieldName].name=SHARED.stampField.name)
							
							// DON'T DISPLAY STAMP FIELD
							
							//______________________________________________________
						: ($table[$fieldName].kind="storage")  // Field
							
							$o:=OB Copy:C1225($table[$fieldName])
							$o.path:=$o.name
							
							// #TEMPO [
							$o.valueType:=$o.type
							$o.type:=_o_tempoFieldType($o.fieldType)
							$o.typeLegacy:=$o.fieldType
							//]
							
							$Obj_out.fields.push($o)
							
							//______________________________________________________
						: ($table[$fieldName].kind="relatedEntity")  // N -> 1 relation
							
							If (Num:C11($Obj_in.level)=0)
								
								If ($Col_tables.indexOf($table[$fieldName].relatedDataClass)=-1)\
									 | ($table[$fieldName].relatedDataClass=$Obj_in.tableName)
									
									If ($table[$fieldName].relatedDataClass=$Obj_in.tableName)  // Recursive relation
										
										err_PUSH($Obj_out; "Recursive relation \""+$fieldName+"\" on ["+String:C10($Obj_in.tableName)+"]"; Information message:K38:1)
										
										$o:=catalog("fields"; New object:C1471(\
											"tableName"; $table[$fieldName].relatedDataClass; \
											"datastore"; $Obj_datastore; \
											"tables"; $Col_tables; \
											"level"; 1))  // <================================== [RECURSIVE CALL]
										
									Else 
										
										$o:=catalog("fields"; New object:C1471(\
											"tableName"; $table[$fieldName].relatedDataClass; \
											"datastore"; $Obj_datastore; \
											"tables"; $Col_tables))  // <================================== [RECURSIVE CALL]
										
									End if 
									
									err_COMBINE($o; $Obj_out)
									
									If ($o.success)
										
										For each ($o; $o.fields)
											
											$o.path:=$table[$fieldName].name+"."+$o.path
											$Obj_out.fields.push($o)
											
										End for each 
									End if 
									
									$Col_tables.pop()
									
								Else 
									
									// <CIRCULAR REFERENCES>
									
									err_PUSH($Obj_out; "Circular relation ["+String:C10($Obj_in.tableName)+"] -> ["+String:C10($table[$fieldName].relatedDataClass)+"]"; Warning message:K38:2)
									
								End if 
							End if 
							
							//______________________________________________________
						: ($table[$fieldName].kind="relatedEntities")  // 1 -> N relation
							
							// <NOT YET  MANAGED>
							
							//______________________________________________________
						: ($table[$fieldName].kind="calculated")  // Computed properties
							
							$o:=OB Copy:C1225($table[$fieldName])
							$o.path:=$o.name
							$o.valueType:=$o.type
							$o.computed:=True:C214
							$o.type:=-3
							
							// #TEMPO [
							$o.typeLegacy:=$o.fieldType
							//]
							
							$Obj_out.fields.push($o)
							
							//______________________________________________________
					End case 
				End for each 
				
			Else 
				
				err_PUSH($Obj_out; "Table not found \""+String:C10($Obj_in.tableName)+"\"")
				
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Txt_action+"\"")
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out  // Success {fields {errors} {warnings}}

// ----------------------------------------------------
// End