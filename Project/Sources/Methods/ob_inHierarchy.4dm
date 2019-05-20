//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Description:
  // Look in object hierarchy an object with a specific property
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0;$1)
C_TEXT:C284($2;$3)

C_OBJECT:C1216($Obj_in)
C_TEXT:C284($Txt_property;$Txt_parent)

If (False:C215)
	C_OBJECT:C1216(ob_inHierarchy ;$0)
	C_OBJECT:C1216(ob_inHierarchy ;$1)
	C_TEXT:C284(ob_inHierarchy ;$2)
	C_TEXT:C284(ob_inHierarchy ;$3)
End if 

  // ----------------------------------------------------
  // Initialisations
$Obj_in:=$1
$Txt_property:=$2

If (Count parameters:C259>2)
	
	$Txt_parent:=$3
	
Else 
	
	$Txt_parent:="parent"
	
End if 

Case of 
		
		  //________________________________________
	: ($Obj_in=Null:C1517)
		
		$0:=Null:C1517
		
		  //________________________________________
	: ($Obj_in[$Txt_property]#Null:C1517)
		
		$0:=$Obj_in
		
		  //________________________________________
	Else 
		
		$0:=ob_inHierarchy ($Obj_in[$Txt_parent];$Txt_property;$Txt_parent)
		
		  //________________________________________
End case 