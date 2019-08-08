//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : doc_catalog
  // Database: 4D Mobile Express
  // ID[8328FC3981DB45DC9CFEF6A39E8F4473]
  // Created 12-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Description:
  // Returns a folder catalog as a collection
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($Boo_push)
C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dir_root;$Txt_filter)
C_COLLECTION:C1488($Col_catalog;$Col_exclude)

ARRAY TEXT:C222($tDir_;0)
ARRAY TEXT:C222($tFile_;0)

If (False:C215)
	C_COLLECTION:C1488(doc_catalog ;$0)
	C_TEXT:C284(doc_catalog ;$1)
	C_TEXT:C284(doc_catalog ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Dir_root:=$1
	
	ASSERT:C1129(Test path name:C476($Dir_root)=Is a folder:K24:2;$Dir_root+" is not a folder")
	
	  // Default values
	$Txt_filter:="."  // Ignore invisible
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		$Txt_filter:=$2
		
		  //#ACI0098517
		  //If ($Txt_filter="[@]")
		If (Match regex:C1019("(?m-si)^\\[.*\\]$";$Txt_filter;1))
			
			$Col_exclude:=JSON Parse:C1218($Txt_filter)
			
		End if 
	End if 
	
	If ($Txt_filter=".")
		
		DOCUMENT LIST:C474($Dir_root;$tFile_;Ignore invisible:K24:16)
		
		$Txt_filter:="*"
		
	Else 
		
		DOCUMENT LIST:C474($Dir_root;$tFile_)
		
	End if 
	
	$Col_catalog:=New collection:C1472
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
For ($Lon_i;1;Size of array:C274($tFile_);1)
	
	$Boo_push:=($Txt_filter="*")
	
	Case of 
			
			  //________________________________________
		: ($Boo_push)
			
			$Col_catalog.push($tFile_{$Lon_i})
			
			  //________________________________________
		: ($Col_exclude#Null:C1517)
			
			If ($Col_exclude.indexOf($tFile_{$Lon_i})=-1)
				
				$Col_catalog.push($tFile_{$Lon_i})
				
			End if 
			
			  //________________________________________
		: (Length:C16($Txt_filter)>0)
			
			EXECUTE METHOD:C1007($Txt_filter;$Boo_push;$Dir_root;$tFile_{$Lon_i})
			
			If ($Boo_push)
				
				$Col_catalog.push($tFile_{$Lon_i})
				
			End if 
			
			  //________________________________________
	End case 
End for 

FOLDER LIST:C473($Dir_root;$tDir_)

For ($Lon_i;1;Size of array:C274($tDir_);1)
	
	$Col_catalog.push(New object:C1471(\
		$tDir_{$Lon_i};doc_catalog ($Dir_root+$tDir_{$Lon_i}+Folder separator:K24:12;$Txt_filter)))  // <=========== RECURSIVE
	
End for 

  // ----------------------------------------------------
  // Return
$0:=$Col_catalog

  // ----------------------------------------------------
  // End