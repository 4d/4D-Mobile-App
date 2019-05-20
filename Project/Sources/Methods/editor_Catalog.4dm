//%attributes = {"invisible":true}
/*
catalog := ***editor_Catalog*** ( property )
 -> property (Text)
 <- catalog (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : editor_Catalog
  // Database: 4D Mobile App
  // ID[8D67858E8305469488DC634C018A859E]
  // Created #31-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return the current catalog according with the level code execution
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_property)
C_COLLECTION:C1488($Col_catalog)

If (False:C215)
	C_COLLECTION:C1488(editor_Catalog ;$0)
	C_TEXT:C284(editor_Catalog ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // <NO PARAMETERS REQUIRED>
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Txt_property:=$1
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: (Form:C1466=Null:C1517)
		
		ASSERT:C1129(False:C215;"Oops, this method must be called from a form!")
		
		  //______________________________________________________
	: (ob_testPath (Form:C1466;"$project";"$catalog"))
		
		$Col_catalog:=Form:C1466.$project.$catalog
		
		  //______________________________________________________
	: (ob_testPath (Form:C1466;"$catalog"))
		
		$Col_catalog:=Form:C1466.$catalog
		
		  //______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		  //______________________________________________________
End case 

If ($Col_catalog#Null:C1517)\
 & (Length:C16($Txt_property)>0)
	
	$Col_catalog:=$Col_catalog.extract($Txt_property)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Col_catalog

  // ----------------------------------------------------
  // End