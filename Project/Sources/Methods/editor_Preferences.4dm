//%attributes = {"invisible":true}
  // Project method : editor_Preferences
  // ID[D3B9FB0808EE47F79518B159B704340F]
  // Created 5-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_OBJECT:C1216($file;$o;$Obj_in)

If (False:C215)
	C_OBJECT:C1216(editor_Preferences ;$0)
	C_OBJECT:C1216(editor_Preferences ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // Optional parameters
If (Count parameters:C259>=1)
	
	$Obj_in:=$1
	
End if 

$file:=COMPONENT_Pathname ("databasePreferences").file("4D Mobile App.preferences")

  // ----------------------------------------------------
If ($file.exists)
	
	  // Get
	$o:=JSON Parse:C1218($file.getText())
	
Else 
	
	  // Create
	$o:=New object:C1471
	
End if 

If ($Obj_in#Null:C1517)
	
	  // Set
	$o[$Obj_in.key]:=$Obj_in.value
	
	  // Save
	$file.setText(JSON Stringify:C1217($o;*))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End