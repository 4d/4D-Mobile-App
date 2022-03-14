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
#DECLARE($params : Object)

var $action : Text
var $p : Picture
var $ƒ : Object

If (Count parameters:C259>=1)
	
	$action:=String:C10($params.action)
	
End if 

$ƒ:=panel
$ƒ.tableNumber:=Num:C11($ƒ.tableLink.call())

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
			$ƒ.context.cache[$params.row-1].icon:=$params.pathnames[$params.item-1]
			
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
			
			$ƒ.updateForms($ƒ.context.cache[$params.row-1]; $params.row)
			
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