//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : FIELDS_CALLBACK
// ID[BF3981E8AF72452DB0171AEDA52AF625]
// Created 26-10-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Callbacks management for the "FIELDS" panel
// ----------------------------------------------------
// Declarations
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(FIELDS_CALLBACK; $1)
End if 

var $action : Text
var $p : Picture
var $field; $ƒ; $params : Object
var $c : Collection

If (Count parameters:C259>=1)
	
	$params:=$1
	$action:=String:C10($1.action)
	
End if 

$ƒ:=Form:C1466.$dialog[Current form name:C1298]
$ƒ.tableNumber:=Num:C11(Form:C1466.$dialog.TABLES.currentTableNumber)

// ----------------------------------------------------
Case of 
		
		//________________________________________________________________
	: (Length:C16($action)=0)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//________________________________________________________________
	: ($action="update")  // Display published tables according to data model
		
		$ƒ.updateFieldList()
		
		//________________________________________________________________
	: ($ƒ.tableNumber=0)
		
		// <NOTHING MORE TO DO>
		
		//________________________________________________________________
	: ($action="fieldIcons")  // Call back from picker
		
		If ($params.item>0)\
			 & ($params.item<=$params.pathnames.length)
			
			// Update data model
			$ƒ.field($params.row).icon:=$params.pathnames[$params.item-1]
			
			// Update UI
			If ($params.pictures[$params.item-1]#Null:C1517)
				
				$p:=$params.pictures[$params.item-1]
				CREATE THUMBNAIL:C679($p; $p; 24; 24; Scaled to fit:K6:2)
				
				//%W-533.3
				$ƒ.icons.pointer->{$params.row}:=$p
				//%W+533.3
				
			Else 
				
				//%W-533.3
				CLEAR VARIABLE:C89($ƒ.icons.pointer->{$params.row})
				//%W+533.3
				
			End if 
			
			PROJECT.save()
			
		End if 
		
		//________________________________________________________________
	: ($action="select")  // Set the selected field
		
		$ƒ.currentFieldNumber:=Num:C11($params.fieldNumber)
		
		//________________________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$action+"\"")
		
		//________________________________________________________________
End case 