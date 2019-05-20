//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Description:
  // Find recursively property in object
  // ----------------------------------------------------
  // Declarations

C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_TEXT:C284($2)
C_OBJECT:C1216($3)

C_LONGINT:C283($Lon_parameters;$Lon_i)
C_TEXT:C284($Txt_property;$Txt_buffer)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(ob_findProperty ;$0)
	C_OBJECT:C1216(ob_findProperty ;$1)
	C_TEXT:C284(ob_findProperty ;$2)
	C_OBJECT:C1216(ob_findProperty ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	$Txt_property:=$2
	
	If ($Lon_parameters>=3)
		
		$Obj_out:=$3
		
	End if 
	
	If ($Obj_out=Null:C1517)
		
		$Obj_out:=New object:C1471(\
			"success";False:C215;\
			"value";New collection:C1472())
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

For each ($Txt_buffer;$Obj_in)
	
	Case of 
			
			  //________________________________________
		: ($Txt_buffer=$Txt_property)  // we found an instance
			
			$Obj_out.value.push($Obj_in[$Txt_buffer])
			
			  //________________________________________
		: (Value type:C1509($Obj_in[$Txt_buffer])=Is collection:K8:32)
			
			For ($Lon_i;0;$Obj_in[$Txt_buffer].length-1;1)
				
				If (Value type:C1509($Obj_in[$Txt_buffer][$Lon_i])=Is object:K8:27)
					
					ob_findProperty ($Obj_in[$Txt_buffer][$Lon_i];$Txt_property;$Obj_out)
					
				End if 
			End for 
			
			  //________________________________________
		: (Value type:C1509($Obj_in[$Txt_buffer])=Is object:K8:27)
			
			Case of 
					
					  //----------------------------------------
				: ($Obj_in[$Txt_buffer].isFile#Null:C1517)
					
					  // Exclude special object with cycle: File
					  // XXX other object
					  //----------------------------------------
				Else   // normal object
					
					ob_findProperty ($Obj_in[$Txt_buffer];$Txt_property;$Obj_out)
					
					  //----------------------------------------
			End case 
			
			  //________________________________________
		Else 
			
			  // Ignore
			
			  //________________________________________
	End case 
End for each 

$Obj_out.success:=$Obj_out.value.length>0

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End