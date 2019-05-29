//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ob_createPath
  // Database: 4D Mobile App
  // ID[DB7D702D7871447A85665BA027992DB3]
  // Created #14-1-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_LONGINT:C283($3)

C_LONGINT:C283($Lon_parameters;$Lon_type)
C_PICTURE:C286($p)
C_TEXT:C284($t;$Txt_path)
C_OBJECT:C1216($o;$Obj_in)
C_COLLECTION:C1488($c)

If (False:C215)
	C_OBJECT:C1216(ob_createPath ;$0)
	C_OBJECT:C1216(ob_createPath ;$1)
	C_TEXT:C284(ob_createPath ;$2)
	C_LONGINT:C283(ob_createPath ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Txt_path:=$2
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=3)
		
		$Lon_type:=$3
		
	Else 
		
		$Lon_type:=Is object:K8:27
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_in=Null:C1517)
	
	$Obj_in:=New object:C1471
	
End if 

$c:=Split string:C1554($Txt_path;".")

$o:=$Obj_in

For each ($t;$c)
	
	If ($o[$t]=Null:C1517)
		
		If ($t=$c[$c.length-1])  // Last item
			
			Case of 
					
					  //______________________________________________________
				: ($Lon_type=Is object:K8:27)
					
					$o[$t]:=New object:C1471
					
					  //______________________________________________________
				: ($Lon_type=Is collection:K8:32)
					
					$o[$t]:=New collection:C1472
					
					  //______________________________________________________
				: ($Lon_type=Is text:K8:3)
					
					$o[$t]:=""
					
					  //______________________________________________________
				: ($Lon_type=Is longint:K8:6)
					
					$o[$t]:=0
					
					  //______________________________________________________
				: ($Lon_type=Is null:K8:31)
					
					$o[$t]:=Null:C1517
					
					  //______________________________________________________
				: ($Lon_type=Is date:K8:7)
					
					$o[$t]:=!00-00-00!
					
					  //______________________________________________________
				: ($Lon_type=Is time:K8:8)
					
					$o[$t]:=?00:00:00?
					
					  //______________________________________________________
				: ($Lon_type=Is picture:K8:10)
					
					$o[$t]:=$p
					
					  //______________________________________________________
				Else 
					
					$o[$t]:=Null:C1517
					
					  //______________________________________________________
			End case 
			
		Else 
			
			$o[$t]:=New object:C1471
			$o:=$o[$t]
			
		End if 
		
	Else 
		
		If ($t#$c[$c.length-1])
			
			$o:=$o[$t]
			
		End if 
	End if 
End for each 

  // ----------------------------------------------------
  // Return
$0:=$Obj_in

  // ----------------------------------------------------
  // End