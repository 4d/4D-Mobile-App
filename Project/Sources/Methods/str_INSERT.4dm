//%attributes = {"invisible":true,"preemptive":"capable"}
/*
***ui_INSERT_TEXT*** ( in )
 -> in (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : str_INSERT
  // Database: 4D Mobile App
  // ID[85D40EC622F54403A5145C09B0F39ADE]
  // Created #26-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // #THREAD_SAFE
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_selected)
C_LONGINT:C283($Lon_parameters;$Lon_size)
C_OBJECT:C1216($Obj_in;$Obj_out)

If (False:C215)
	C_OBJECT:C1216(str_INSERT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
$Boo_selected:=($Obj_in.end>$Obj_in.begin)  // True if selected text

If ($Boo_selected)
	
	  // Replace the selection with the string to insert
	$Obj_in.target:=Substring:C12($Obj_in.target;1;$Obj_in.begin-1)+$Obj_in.text+Substring:C12($Obj_in.target;$Obj_in.end)
	$Obj_in.end:=$Obj_in.begin+Length:C16($Obj_in.text)
	
Else 
	
	  // Insert the chain at the insertion point
	$Lon_size:=Length:C16($Obj_in.target)
	$Obj_in.target:=Insert string:C231($Obj_in.target;$Obj_in.text;$Obj_in.begin)
	
	If ($Obj_in.begin=$Lon_size)
		
		  // We were at the end of the text and we stay
		$Lon_size:=Length:C16($Obj_in.target)+1
		
	Else 
		
		  // The insertion point is translated from the length of the inserted string
		$Lon_size:=$Obj_in.begin+Length:C16($Obj_in.text)
		
	End if 
	
	$Obj_in.begin:=$Lon_size
	$Obj_in.end:=$Lon_size
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End