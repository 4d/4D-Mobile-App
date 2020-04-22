//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : tmpl_compatibleType
  // ID[65F3645D18C04D849BF87223A26F3364]
  // Created 12-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_VARIANT:C1683($1)
C_LONGINT:C283($2)

C_BOOLEAN:C305($Boo_accepted)
C_LONGINT:C283($Lon_type)
C_COLLECTION:C1488($Col_types)

If (False:C215)
	C_BOOLEAN:C305(tmpl_compatibleType ;$0)
	C_VARIANT:C1683(tmpl_compatibleType ;$1)
	C_LONGINT:C283(tmpl_compatibleType ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations

If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	  // Required parameters
	Case of 
			
			  //___________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			$Col_types:=Split string:C1554($1;",";sk trim spaces:K86:2).map("col_formula";"$1.result:=Num:C11($1.value)")
			
			  //___________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			$Col_types:=$1  // Collection des types
			
			  //___________________________
		Else 
			
			TRACE:C157
			
			  //___________________________
	End case 
	
	$Lon_type:=$2  // Type à tester
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Col_types.every("col_formula";"$1.result:=($1.value>=0)"))
	
	  // One of them
	$Boo_accepted:=($Col_types.indexOf($Lon_type)#-1)
	
Else 
	
	  // None of them
	$Boo_accepted:=($Col_types.filter("col_formula";"$1.result:=($1.value="+String:C10(-$Lon_type)+")").length=0)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Boo_accepted  // Vrai si compatible

  // ----------------------------------------------------
  // End