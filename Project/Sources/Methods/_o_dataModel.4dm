//%attributes = {"invisible":true,"preemptive":"capable"}
// Manager model with some possible "action"
// - tableNames : get only names
// - fields: flatten fields on key path
#DECLARE($Obj_in : Object)->$Obj_out : Object

// ----------------------------------------------------
// Declarations
var $Boo_4dType; $Boo_found : Boolean
var $Lon_attributs; $Lon_field; $Lon_field2; $Lon_fieldID; $Lon_parameters; $Lon_relatedTableID : Integer
var $Lon_relationField; $Lon_table; $Lon_table2; $Lon_tableID; $Lon_type : Integer
var $Ptr_field : Pointer
var $Dom_attribute; $Dom_elements; $Dom_entity; $Dom_model; $Dom_node; $Dom_userInfo : Text
var $File_; $t; $tt; $Txt_buffer; $Txt_field; $Txt_fieldName : Text
var $Txt_fieldNumber; $Txt_inverseName; $Txt_relationName; $Txt_tableName; $Txt_tableNumber; $Txt_value : Text
var $o; $Obj_buffer; $Obj_dataModel; $Obj_field; $Obj_in : Object
var $Obj_out; $Obj_path; $Obj_relationTable; $Obj_table : Object
var $relatedField : Variant
var $Col_fields; $Col_tables; $actions : Collection

ARRAY TEXT:C222($tTxt_fields; 0)
ARRAY TEXT:C222($tTxt_relationFields; 0)
ARRAY TEXT:C222($tTxt_tables; 0)

If (False:C215)
	C_OBJECT:C1216(_o_dataModel; $0)
	C_OBJECT:C1216(_o_dataModel; $1)
End if 

// ----------------------------------------------------
// Initialisations

$Obj_out:=New object:C1471(\
"success"; False:C215)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)  // Missing parameter
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		// MARK:- tableNames
	: ($Obj_in.action="tableNames")  // CALLERS : mobile_Project for structure adjustments
		
		$Obj_dataModel:=$Obj_in.dataModel
		
		$Obj_out.success:=($Obj_dataModel#Null:C1517)
		
		If ($Obj_out.success)
			
			$Obj_out.values:=New collection:C1472
			
			For each ($t; $Obj_dataModel)
				
				$Obj_out.values.push($Obj_dataModel[$t][""].name)
				
				If (Bool:C1537($Obj_in.relation))
					
					For each ($tt; $Obj_dataModel[$t])
						
						If (Value type:C1509($Obj_dataModel[$t][$tt])=Is object:K8:27)
							
							If ($Obj_dataModel[$t][$tt].relatedDataClass#Null:C1517)
								
								$Obj_out.values.push($Obj_dataModel[$t][$tt].relatedDataClass)
								
							End if 
						End if 
					End for each 
				End if 
			End for each 
			
		Else 
			
			ASSERT:C1129(dev_Matrix; "No data model")  //#ERROR
			
		End if 
		
		//________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//________________________________________
End case 

// ----------------------------------------------------
// End