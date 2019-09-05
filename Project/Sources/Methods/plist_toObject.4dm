//%attributes = {"invisible":true,"preemptive":"capable"}
  // ----------------------------------------------------
  // Project method : plist_toObject
  // ID[156E1073847B47D19113A97F9C700DDF]
  // Created 15-9-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // A very partial conversion of a .plist into an object
  // Need enhancement in the future
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i;$Lon_parameters)
C_TEXT:C284($Dom_root;$Dom_value;$Txt_element;$Txt_key;$Txt_plist;$Txt_string)
C_OBJECT:C1216($Obj_plist)

If (False:C215)
	C_OBJECT:C1216(plist_toObject ;$0)
	C_TEXT:C284(plist_toObject ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Txt_plist:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$Dom_root:=DOM Parse XML variable:C720($Txt_plist)

If (OK=1)
	
	ARRAY TEXT:C222($tDom_dicts;0x0000)
	$tDom_dicts{0}:=DOM Find XML element:C864($Dom_root;"plist/dict/key";$tDom_dicts)
	
	If (OK=1)
		
		$Obj_plist:=New object:C1471
		
		For ($Lon_i;1;Size of array:C274($tDom_dicts);1)
			
			DOM GET XML ELEMENT VALUE:C731($tDom_dicts{$Lon_i};$Txt_key)
			
			$Obj_plist[$Txt_key]:=New object:C1471
			
			$Dom_value:=DOM Get next sibling XML element:C724($tDom_dicts{$Lon_i})
			
			DOM GET XML ELEMENT NAME:C730($Dom_value;$Txt_element)
			
			Case of 
					
					  //______________________________________________________
				: ($Txt_element="string")
					
					DOM GET XML ELEMENT VALUE:C731($Dom_value;$Txt_string)
					
					$Obj_plist[$Txt_key].string:=$Txt_string
					
					  //______________________________________________________
				Else 
					
					  //ASSERT(Structure file#Structure file(*))  //#ERROR
					
					  //______________________________________________________
			End case 
		End for 
	End if 
	
	DOM CLOSE XML:C722($Dom_root)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_plist

  // ----------------------------------------------------
  // End