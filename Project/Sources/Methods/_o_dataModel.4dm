//%attributes = {"invisible":true,"preemptive":"capable"}
// Manager model with some possible "action"
// - tableNames : get only names
// - fields: flatten fields on key path
#DECLARE($Obj_in : Object)->$Obj_out : Object

// ----------------------------------------------------
// Declarations
var $t; $tt : Text
var $Obj_dataModel : Object


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