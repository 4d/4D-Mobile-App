//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : dev_assert
  // ID[9401AFF3119A4712A1FBDC1738CDE350]
  // Created 4-4-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_done;$Boo_OK)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Txt_key)
C_OBJECT:C1216($Obj_in)

If (False:C215)
	C_BOOLEAN:C305(dev_assert ;$0)
	C_OBJECT:C1216(dev_assert ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Boo_OK:=dev_Matrix   // No assert in deploiement

If (Not:C34($Boo_OK))
	
	For each ($Txt_key;$Obj_in) Until ($Boo_done)
		
		Case of 
				
				  //______________________________________________________
			: ($Txt_key="equal")
				
				If ($Obj_in.equal=$Obj_in.value)
					
					$Boo_OK:=True:C214
					
				End if 
				
				$Boo_done:=True:C214
				
				  //______________________________________________________
			: ($Txt_key="unequal")
				
				If ($Obj_in.unequal#$Obj_in.value)
					
					$Boo_OK:=True:C214
					
				End if 
				
				$Boo_done:=True:C214
				
				  //______________________________________________________
			: ($Txt_key="pathname")  // Test a pathname
				
				If ($Obj_in.value=-43)
					
					  // Return true if the path is valid (folder or file)
					$Boo_OK:=(Test path name:C476($Obj_in.pathname)#$Obj_in.value)
					
				Else 
					
					$Boo_OK:=(Test path name:C476($Obj_in.pathname)=$Obj_in.value)
					
				End if 
				
				$Boo_done:=True:C214
				
				  //______________________________________________________
		End case 
	End for each 
	
	If (Not:C34($Boo_OK))
		
		If ($Obj_in.message#Null:C1517)
			
			ASSERT:C1129(False:C215;$Obj_in.message)
			
		End if 
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Boo_OK

  // ----------------------------------------------------
  // End