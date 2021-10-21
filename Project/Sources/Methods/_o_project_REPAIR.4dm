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
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(_o_project_REPAIR; $1)
End if 

var $actionIndex; $parameterIndex; $type : Integer
var $dataModel; $o; $param; $project : Object
var $c : Collection

// ----------------------------------------------------
// Initialisations
If (Count parameters:C259>=1)
	
	$project:=$1
	
Else 
	
	$project:=PROJECT  //(UI.pointer("project"))->
	
End if 

ASSERT:C1129($project#Null:C1517)

$dataModel:=$project.dataModel

/*
=============================================================================================
|                                       ACTIONS                                             |
=============================================================================================
*/

If ($project.actions#Null:C1517)
	
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
	
	For each ($o; $project.actions)
		
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
			$project.actions.remove($actionIndex)
			
		End if 
		
		$actionIndex:=$actionIndex+1
		
	End for each 
	
	If ($project.actions.length=0)
		
		// NO MORE ACTION
		OB REMOVE:C1226($project; "actions")
		
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
			
			$project[$o.tab][$o.table]:=New object:C1471
			
		End for each 
	End if 
	
End if 

OB REMOVE:C1226(Form:C1466; "audit")
Form:C1466.status.project:=True:C214
