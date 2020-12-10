//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : project_Fix
// ID[534F9A527DA04E99B71444FEF1C97A15]
// Created 30-8-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(project_Fix; $0)
	C_OBJECT:C1216(project_Fix; $1)
End if 

var $dataModel; $detail; $error; $fix; $IN; $list : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$IN:=$1
	
	// Default values
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
	$fix:=New object:C1471(\
		"success"; False:C215; \
		"fix"; 0)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$dataModel:=Choose:C955(Value type:C1509($IN.dataModel)=Is object:K8:27; $IN.dataModel; Form:C1466.dataModel)  // test purpose // normal form behaviour
$list:=Choose:C955(Value type:C1509($IN.list)=Is object:K8:27; $IN.list; Form:C1466.list)  // test purpose // normal form behaviour
$detail:=Choose:C955(Value type:C1509($IN.detail)=Is object:K8:27; $IN.detail; Form:C1466.detail)  // test purpose // normal form behaviour

For each ($error; $IN.audit.errors)
	
	Case of 
			
			//________________________________________
		: ($error.type="template")
			
			Case of 
					
					//…………………………………………………………………………………
				: ($error.tab="list")
					
					If (Value type:C1509($list[$error.table])=Is object:K8:27)
						
						OB REMOVE:C1226($list[$error.table]; "form")
						$fix.fix:=$fix.fix+1
						
					End if 
					
					//…………………………………………………………………………………
				: ($error.tab="detail")
					
					If (Value type:C1509($detail[$error.table])=Is object:K8:27)
						
						OB REMOVE:C1226($detail[$error.table]; "form")
						$fix.fix:=$fix.fix+1
						
					End if 
					
					//…………………………………………………………………………………
				Else 
					
					ASSERT:C1129(dev_Matrix; "Unknown project audit template type "+$error.tab)
					
					//…………………………………………………………………………………
			End case 
			
			//________________________________________
		: ($error.type="icon")
			
			If ($error.field#Null:C1517)
				
				If (Value type:C1509($dataModel[$error.table])=Is object:K8:27)
					
					OB REMOVE:C1226($dataModel[$error.table][$error.field]; "icon")
					$fix.fix:=$fix.fix+1
					
				End if 
				
			Else 
				
				If (Value type:C1509($dataModel[$error.table])=Is object:K8:27)
					
					OB REMOVE:C1226($dataModel[$error.table]; "icon")
					$fix.fix:=$fix.fix+1
					
				End if 
				
			End if 
			
			//________________________________________
		: ($error.type="formatter")
			
			If (Value type:C1509($dataModel[$error.table])=Is object:K8:27)
				
				OB REMOVE:C1226($dataModel[$error.table][$error.field]; "format")
				$fix.fix:=$fix.fix+1
				
			End if 
			
			//________________________________________
		: ($error.type="filter")
			
			If (Value type:C1509($dataModel[$error.table])=Is object:K8:27)
				
				OB REMOVE:C1226($dataModel[$error.table]; "filter")
				$fix.fix:=$fix.fix+1
				
			End if 
			
			//________________________________________
		Else 
			
			ASSERT:C1129(dev_Matrix; "Unknown project audit error type "+$error.type)
			
			//________________________________________
	End case 
End for each 

$fix.success:=($fix.fix=$IN.audit.errors.length)

// ----------------------------------------------------
// Return
$0:=$fix

// ----------------------------------------------------
// End