//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : ob_deepMerge
  // Database: 4D Mobile Express
  // ----------------------------------------------------
  // Description:
  // Copy object properties from source to target
  // ----------------------------------------------------
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // !!!!!!!!!!!!!!!!!! NOT FINALIZED !!!!!!!!!!!!!!!!!!!
  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_i;$Lon_parameters;$Lon_sourceType;$Lon_targetType)
C_TEXT:C284($Txt_property)
C_OBJECT:C1216($Obj_source;$Obj_target)

If (False:C215)
	C_OBJECT:C1216(ob_deepMerge ;$0)
	C_OBJECT:C1216(ob_deepMerge ;$1)
	C_OBJECT:C1216(ob_deepMerge ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_target:=$1
	$Obj_source:=$2
	
	If ($Obj_target=Null:C1517)
		
		$Obj_target:=New object:C1471
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  //TRACE

  // ----------------------------------------------------
For each ($Txt_property;$Obj_source)
	
	$Lon_sourceType:=Value type:C1509($Obj_source[$Txt_property])
	
	Case of 
			
			  //________________________________________
		: ($Lon_sourceType=Is object:K8:27)
			
			If ($Obj_target[$Txt_property]=Null:C1517)
				
				$Obj_target[$Txt_property]:=OB Copy:C1225($Obj_source[$Txt_property])
				
			Else 
				
				If (Value type:C1509($Obj_target[$Txt_property])#Is object:K8:27)
					
					$Obj_target[$Txt_property]:=New object:C1471
					
				End if 
				
				$Obj_target[$Txt_property]:=ob_deepMerge (\
					$Obj_target[$Txt_property];\
					OB Copy:C1225($Obj_source[$Txt_property]))
				
			End if 
			
			  //________________________________________
		: ($Lon_sourceType=Is collection:K8:32)
			
			If ($Obj_target[$Txt_property]=Null:C1517)
				
				$Obj_target[$Txt_property]:=$Obj_source[$Txt_property].copy()
				
			Else 
				
				$Obj_target[$Txt_property]:=New collection:C1472.resize($Obj_source[$Txt_property].length)
				
				For ($Lon_i;0;$Obj_source[$Txt_property].length-1;1)
					
					$Lon_sourceType:=Value type:C1509($Obj_source[$Txt_property][$Lon_i])
					
					Case of 
							
							  //______________________________________________________
						: ($Lon_sourceType=Is object:K8:27)
							
							$Lon_targetType:=Value type:C1509($Obj_target[$Txt_property][$Lon_i])
							
							Case of 
									
									  //______________________________________________________
								: ($Obj_target[$Txt_property][$Lon_i]=Null:C1517)
									
									$Obj_target[$Txt_property][$Lon_i]:=OB Copy:C1225($Obj_source[$Txt_property][$Lon_i])
									
									  //______________________________________________________
								: ($Lon_targetType=Is object:K8:27)
									
									$Obj_target[$Txt_property][$Lon_i]:=ob_deepMerge (\
										$Obj_target[$Txt_property][$Lon_i];\
										OB Copy:C1225($Obj_source[$Txt_property][$Lon_i]))
									
									  //______________________________________________________
								: ($Lon_targetType=Is collection:K8:32)
									
									If (Not:C34($Obj_target[$Txt_property][$Lon_i].equal($Obj_target[$Txt_property][$Lon_i];ck diacritical:K85:3)))
										
										  //#MARK_TODO
										
									End if 
									
									  //______________________________________________________
								Else 
									
									$Obj_target[$Txt_property][$Lon_i]:=$Obj_source[$Txt_property][$Lon_i]
									
									  //______________________________________________________
							End case 
							
							  //______________________________________________________
						: ($Lon_sourceType=Is collection:K8:32)
							
							  //#MARK_TODO
							
							  //______________________________________________________
						Else 
							
							$Obj_target[$Txt_property]:=$Obj_source[$Txt_property]
							
							  //______________________________________________________
					End case 
				End for 
			End if 
			
			  //________________________________________
		Else 
			
			$Obj_target[$Txt_property]:=$Obj_source[$Txt_property]
			
			  //________________________________________
	End case 
End for each 

  // ----------------------------------------------------
  // Return
$0:=$Obj_target

  // ----------------------------------------------------
  // End