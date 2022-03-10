//%attributes = {"invisible":true,"preemptive":"capable"}
//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($Dir_root : Text; $Txt_filter : Text)->$Col_catalog : Collection
// ----------------------------------------------------
// Project method : doc_catalog
// ID[8328FC3981DB45DC9CFEF6A39E8F4473]
// Created 12-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// #THREAD-SAFE
// ----------------------------------------------------
// Description:
// Returns a folder catalog as a collection
// ----------------------------------------------------
// Declarations
var $Boo_push : Boolean
var $Lon_parameters : Integer
var $Col_catalog; $Col_exclude; $children : Collection

If (False:C215)
	C_COLLECTION:C1488(_o_doc_catalog; $0)
	C_TEXT:C284(_o_doc_catalog; $1)
	C_TEXT:C284(_o_doc_catalog; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	ASSERT:C1129(Folder:C1567($Dir_root; fk platform path:K87:2).exists; $Dir_root+" is not a folder")
	
	// Optional parameters
	If ($Lon_parameters<2)
		// Default values
		$Txt_filter:="."  // Ignore invisible
	Else 
		//#ACI0098517
		//If ($Txt_filter="[@]")
		If (Match regex:C1019("(?m-si)^\\[.*\\]$"; $Txt_filter; 1))
			
			$Col_exclude:=JSON Parse:C1218($Txt_filter)
			
		End if 
	End if 
	
	If ($Txt_filter=".")
		
		$children:=Folder:C1567($Dir_root; fk platform path:K87:2).files(Ignore invisible:K24:16)
		
		$Txt_filter:="*"
		
	Else 
		
		$children:=Folder:C1567($Dir_root; fk platform path:K87:2).files()
		
	End if 
	
	$Col_catalog:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
var $childDoc : 4D:C1709.File
For each ($childDoc; $children)
	
	$Boo_push:=($Txt_filter="*")
	
	Case of 
			
			//________________________________________
		: ($Boo_push)
			
			$Col_catalog.push($childDoc.fullName)
			
			//________________________________________
		: ($Col_exclude#Null:C1517)
			
			If ($Col_exclude.indexOf($childDoc.fullName)=-1)
				
				$Col_catalog.push($childDoc.fullName)
				
			End if 
			
			//________________________________________
		: (Length:C16($Txt_filter)>0)
			
			EXECUTE METHOD:C1007($Txt_filter; $Boo_push; $Dir_root; $childDoc.fullName)
			
			If ($Boo_push)
				
				$Col_catalog.push($childDoc.fullName)
				
			End if 
			
			//________________________________________
	End case 
End for each 

var $childFolder : 4D:C1709.Folder
For each ($childFolder; Folder:C1567($Dir_root; fk platform path:K87:2).folders())
	
	$Col_catalog.push(New object:C1471(\
		$childFolder.fullName; _o_doc_catalog($childFolder.platformPath; $Txt_filter)))  // <=========== RECURSIVE
	
End for each 
