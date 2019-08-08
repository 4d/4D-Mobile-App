//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_Fix
  // Database: 4D Mobile App
  // ID[534F9A527DA04E99B71444FEF1C97A15]
  // Created 30-8-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_audit;$Obj_dataModel;$Obj_detail;$Obj_fix;$Obj_in;$Obj_list)

If (False:C215)
	C_OBJECT:C1216(project_Fix ;$0)
	C_OBJECT:C1216(project_Fix ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_fix:=New object:C1471(\
		"success";False:C215;\
		"fix";0)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Obj_dataModel:=Choose:C955(Value type:C1509($Obj_in.dataModel)=Is object:K8:27;$Obj_in.dataModel;Form:C1466.dataModel)  // test purpose // normal form behaviour
$Obj_list:=Choose:C955(Value type:C1509($Obj_in.list)=Is object:K8:27;$Obj_in.list;Form:C1466.list)  // test purpose // normal form behaviour
$Obj_detail:=Choose:C955(Value type:C1509($Obj_in.detail)=Is object:K8:27;$Obj_in.detail;Form:C1466.detail)  // test purpose // normal form behaviour

For each ($Obj_audit;$Obj_in.audit.errors)
	
	Case of 
			
			  //________________________________________
		: ($Obj_audit.type="template")
			
			Case of 
					
					  //…………………………………………………………………………………
				: ($Obj_audit.tab="list")
					
					If (Value type:C1509($Obj_list[$Obj_audit.table])=Is object:K8:27)
						
						OB REMOVE:C1226($Obj_list[$Obj_audit.table];"form")
						$Obj_fix.fix:=$Obj_fix.fix+1
						
					End if 
					
					  //…………………………………………………………………………………
				: ($Obj_audit.tab="detail")
					
					If (Value type:C1509($Obj_detail[$Obj_audit.table])=Is object:K8:27)
						
						OB REMOVE:C1226($Obj_detail[$Obj_audit.table];"form")
						$Obj_fix.fix:=$Obj_fix.fix+1
						
					End if 
					
					  //…………………………………………………………………………………
				Else 
					
					ASSERT:C1129(dev_Matrix ;"Unknown project audit template type "+$Obj_audit.tab)
					
					  //…………………………………………………………………………………
			End case 
			
			  //________________________________________
		: ($Obj_audit.type="icon")
			
			If ($Obj_audit.field#Null:C1517)
				
				If (Value type:C1509($Obj_dataModel[$Obj_audit.table])=Is object:K8:27)
					
					OB REMOVE:C1226($Obj_dataModel[$Obj_audit.table][$Obj_audit.field];"icon")
					$Obj_fix.fix:=$Obj_fix.fix+1
					
				End if 
				
			Else 
				
				If (Value type:C1509($Obj_dataModel[$Obj_audit.table])=Is object:K8:27)
					
					OB REMOVE:C1226($Obj_dataModel[$Obj_audit.table];"icon")
					$Obj_fix.fix:=$Obj_fix.fix+1
					
				End if 
				
			End if 
			
			  //________________________________________
		: ($Obj_audit.type="formatter")
			
			If (Value type:C1509($Obj_dataModel[$Obj_audit.table])=Is object:K8:27)
				
				OB REMOVE:C1226($Obj_dataModel[$Obj_audit.table][$Obj_audit.field];"format")
				$Obj_fix.fix:=$Obj_fix.fix+1
				
			End if 
			
			  //________________________________________
		: ($Obj_audit.type="filter")
			
			If (Value type:C1509($Obj_dataModel[$Obj_audit.table])=Is object:K8:27)
				
				OB REMOVE:C1226($Obj_dataModel[$Obj_audit.table];"filter")
				$Obj_fix.fix:=$Obj_fix.fix+1
				
			End if 
			
			  //________________________________________
		Else 
			
			ASSERT:C1129(dev_Matrix ;"Unknown project audit error type "+$Obj_audit.type)
			
			  //________________________________________
	End case 
End for each 

$Obj_fix.success:=($Obj_fix.fix=$Obj_in.audit.errors.length)

  // ----------------------------------------------------
  // Return
$0:=$Obj_fix

  // ----------------------------------------------------
  // End