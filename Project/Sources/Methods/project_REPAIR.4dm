//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_REPAIR
  // ID[ECE5239C52D746B4A01A459D8DBE8A9D]
  // Created 27-8-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_actionIndex;$Lon_parameterIndex;$Lon_type)
C_OBJECT:C1216($o;$Obj_dataModel;$Obj_project;$oo)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(project_REPAIR ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Count parameters:C259>=1)
	
	$Obj_project:=$1
	
Else 
	
	$Obj_project:=(ui.pointer("project"))->
	
End if 

ASSERT:C1129($Obj_project#Null:C1517)

$Obj_dataModel:=$Obj_project.dataModel

  // ----------------------------------------------------
If ($Obj_project.actions#Null:C1517)
	
	$c:=New collection:C1472
	$c[Is integer 64 bits:K8:25]:="number"
	$c[Is alpha field:K8:1]:="string"
	$c[Is integer:K8:5]:="number"
	$c[Is longint:K8:6]:="number"
	$c[Is picture:K8:10]:="image"
	$c[Is boolean:K8:9]:="bool"
	$c[Is float:K8:26]:="number"
	$c[Is text:K8:3]:="string"
	$c[Is real:K8:4]:="number"
	$c[Is time:K8:8]:="time"
	$c[Is date:K8:7]:="date"
	
	For each ($o;$Obj_project.actions)
		
		$Lon_parameterIndex:=0
		
		If ($Obj_dataModel[String:C10($o.tableNumber)]#Null:C1517)
			
			If ($o.parameters#Null:C1517)
				
				For each ($oo;$o.parameters)
					
					If ($Obj_dataModel[String:C10($o.tableNumber)][String:C10($oo.fieldNumber)]#Null:C1517)
						
						$Lon_type:=$Obj_dataModel[String:C10($o.tableNumber)][String:C10($oo.fieldNumber)].fieldType
						
						If ($c[$Lon_type]#$oo.type)
							
							$oo.type:=$c[$Lon_type]
							
							Case of 
									
									  //……………………………………………………………………
								: ($oo.type="date")
									
									$oo.format:="mediumDate"
									
									  //……………………………………………………………………
								: ($oo.type="time")
									
									$oo.format:="hour"
									
									  //……………………………………………………………………
								Else 
									
									OB REMOVE:C1226($oo;"format")
									
									  //……………………………………………………………………
							End case 
							
						Else 
							
							  // <NOTHING MORE TO DO>
							
						End if 
						
					Else 
						
						  // THE FIELD DOESN'T EXIST ANYMORE
						$o.parameters.remove($Lon_parameterIndex)
						
					End if 
					
					$Lon_parameterIndex:=$Lon_parameterIndex+1
					
				End for each 
			End if 
			
		Else 
			
			  // THE TABLE DOESN'T EXIST ANYMORE
			$Obj_project.actions.remove($Lon_actionIndex)
			
		End if 
		
		$Lon_actionIndex:=$Lon_actionIndex+1
		
	End for each 
	
	If ($Obj_project.actions.length=0)
		
		  // NO MORE ACTION
		OB REMOVE:C1226($Obj_project;"actions")
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End