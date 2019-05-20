//%attributes = {"invisible":true}
/*
***sharedCollection*** ( src ; shared )
 -> src (Collection)
 -> shared (Collection)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : sharedCollection
  // Database: v14
  // ID[8826EB3FBC534F3090D85F3BD509B7E6]
  // Created #4-2-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_COLLECTION:C1488($1)
C_COLLECTION:C1488($2)

C_LONGINT:C283($i;$Lon_parameters)
C_COLLECTION:C1488($Col_shared;$Col_src)

If (False:C215)
	C_COLLECTION:C1488(sharedCollection ;$1)
	C_COLLECTION:C1488(sharedCollection ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Col_src:=$1
	$Col_shared:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Use ($Col_shared)
	
	For ($i;0;$Col_src.length-1;1)
		
		Case of 
				
				  //______________________________________________________
			: (Value type:C1509($Col_src[$i])=Is object:K8:27)
				
				$Col_shared[$i]:=New shared object:C1526
				sharedObject ($Col_src[$i];$Col_shared[$i])
				
				  //______________________________________________________
			: (Value type:C1509($Col_src[$i])=Is collection:K8:32)
				
				$Col_shared[$i]:=New shared collection:C1527
				sharedCollection ($Col_src[$i];$Col_shared[$i])
				
				  //______________________________________________________
			Else 
				
				$Col_shared[$i]:=$Col_src[$i]
				
				  //______________________________________________________
		End case 
	End for 
End use 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End