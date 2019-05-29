//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : catalog
  // Database: 4D Mobile App
  // ID[0A02376FAA54403A995124AC0945593D]
  // Created #6-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($l;$Lon_parameters)
C_TEXT:C284($Txt_action;$Txt_field)
C_OBJECT:C1216($o;$Obj_datastore;$Obj_in;$Obj_out;$Obj_table)
C_COLLECTION:C1488($Col_tables)

If (False:C215)
	C_OBJECT:C1216(catalog ;$0)
	C_TEXT:C284(catalog ;$1)
	C_OBJECT:C1216(catalog ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_action:=$1  // datastore | fields
	
	  // Default values
	$Obj_out:=New object:C1471(\
		"success";False:C215)
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Obj_in:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_action="datastore")
		
		$Obj_datastore:=Build Exposed Datastore:C1598
		$Obj_out.success:=($Obj_datastore#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.datastore:=$Obj_datastore
			
		Else 
			
			err_PUSH ($Obj_out;"Null datastore")
			
		End if 
		
		  //______________________________________________________
	: ($Txt_action="table")
		
		ASSERT:C1129($Obj_in.tableName#Null:C1517)
		
		If ($Obj_in.datastore=Null:C1517)
			
			  // Get the datastore
			$Obj_datastore:=catalog ("datastore").datastore
			
		Else 
			
			$Obj_datastore:=$Obj_in.datastore
			
		End if 
		
		$Obj_out.success:=($Obj_datastore#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.success:=($Obj_datastore[$Obj_in.tableName]#Null:C1517)
			
			If ($Obj_out.success)
				
				$Obj_table:=$Obj_datastore[$Obj_in.tableName]
				$Obj_out.success:=($Obj_table#Null:C1517)
				
			End if 
			
			If ($Obj_out.success)
				
				$Obj_out.fields:=New collection:C1472
				
				For each ($Txt_field;$Obj_table)
					
					Case of 
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="storage")  // Field
							
							$o:=OB Copy:C1225($Obj_table[$Txt_field])
							
							If (Bool:C1537(featuresFlags.withNewFieldProperties))
								
								$o.typeLegacy:=$o.fieldType
								
							Else 
								
								GET FIELD PROPERTIES:C258(Num:C11($Obj_table.getInfo().tableNumber);$o.fieldNumber;$l)
								$o.typeLegacy:=$l
								
							End if 
							
							$Obj_out.fields.push($o)
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="relatedEntity")  // N -> 1 relation
							
							$Obj_out.fields.push(OB Copy:C1225($Obj_table[$Txt_field]))
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="relatedEntities")  // 1 -> N relation
							
							  // <NOT YET  MANAGED>
							  //______________________________________________________
						Else 
							
							  // <NOTHING MORE TO DO>
							  //______________________________________________________
					End case 
				End for each 
				
			Else 
				
				err_PUSH ($Obj_out;"Table not found \""+String:C10($Obj_in.tableName)+"\"")
				
			End if 
		End if 
		
		  //______________________________________________________
	: ($Txt_action="fields")
		
		ASSERT:C1129($Obj_in.tableName#Null:C1517)
		
		If ($Obj_in.datastore=Null:C1517)
			
			  // Get the datastore
			$Obj_datastore:=catalog ("datastore").datastore
			
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
				
				$Obj_table:=$Obj_datastore[$Obj_in.tableName]
				$Obj_out.success:=($Obj_table#Null:C1517)
				
			End if 
			
			If ($Obj_out.success)
				
				$Col_tables.push($Obj_in.tableName)
				$Obj_out.fields:=New collection:C1472
				
				For each ($Txt_field;$Obj_table)
					
					Case of 
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].name=commonValues.stampField.name)
							
							  // DON'T DISPLAY STAMP FIELD
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="storage")  // Field
							
							$o:=OB Copy:C1225($Obj_table[$Txt_field])
							$o.path:=$o.name
							
							If (Bool:C1537(featuresFlags.withNewFieldProperties))
								
								  // #TEMPO [
								$o.valueType:=$o.type
								$o.type:=tempoFiledType ($o.fieldType)
								$o.typeLegacy:=$o.fieldType
								  //]
								
							Else 
								
								GET FIELD PROPERTIES:C258(Num:C11($Obj_table.getInfo().tableNumber);$o.fieldNumber;$l)
								$o.typeLegacy:=$l
								
							End if 
							
							$Obj_out.fields.push($o)
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="relatedEntity")  // N -> 1 relation
							
							If (Num:C11($Obj_in.level)=0)
								
								If ($Col_tables.indexOf($Obj_table[$Txt_field].relatedDataClass)=-1)\
									 | ($Obj_table[$Txt_field].relatedDataClass=$Obj_in.tableName)
									
									If ($Obj_table[$Txt_field].relatedDataClass=$Obj_in.tableName)  // Recursive relation
										
										err_PUSH ($Obj_out;"Recursive relation \""+$Txt_field+"\" on ["+String:C10($Obj_in.tableName)+"]";Information message:K38:1)
										
										$o:=catalog ("fields";New object:C1471(\
											"tableName";$Obj_table[$Txt_field].relatedDataClass;\
											"datastore";$Obj_datastore;\
											"tables";$Col_tables;\
											"level";1))  // <================================== [RECURSIVE CALL]
										
									Else 
										
										$o:=catalog ("fields";New object:C1471(\
											"tableName";$Obj_table[$Txt_field].relatedDataClass;\
											"datastore";$Obj_datastore;\
											"tables";$Col_tables))  // <================================== [RECURSIVE CALL]
										
									End if 
									
									err_COMBINE ($o;$Obj_out)
									
									If ($o.success)
										
										For each ($o;$o.fields)
											
											$o.path:=$Obj_table[$Txt_field].name+"."+$o.path
											$Obj_out.fields.push($o)
											
										End for each 
									End if 
									
									$Col_tables.pop()
									
								Else 
									
									  // <CIRCULAR REFERENCES>
									
									err_PUSH ($Obj_out;"Circular relation ["+String:C10($Obj_in.tableName)+"] -> ["+String:C10($Obj_table[$Txt_field].relatedDataClass)+"]";Warning message:K38:2)
									
								End if 
							End if 
							
							  //______________________________________________________
						: ($Obj_table[$Txt_field].kind="relatedEntities")  // 1 -> N relation
							
							  // <NOT YET  MANAGED>
							  //______________________________________________________
						Else 
							
							  // <NOTHING MORE TO DO>
							  //______________________________________________________
					End case 
				End for each 
				
			Else 
				
				err_PUSH ($Obj_out;"Table not found \""+String:C10($Obj_in.tableName)+"\"")
				
			End if 
		End if 
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Txt_action+"\"")
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out  // Success {fields {errors} {warnings}}

  // ----------------------------------------------------
  // End