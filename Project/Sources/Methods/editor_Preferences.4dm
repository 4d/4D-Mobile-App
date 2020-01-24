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

C_OBJECT:C1216($file;$oOUT;$oIN)

If (False:C215)
	C_OBJECT:C1216(editor_Preferences ;$0)
	C_OBJECT:C1216(editor_Preferences ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations

  // Optional parameters
If (Count parameters:C259>=1)
	
	$oIN:=$1
	
End if 

$file:=path .databasePreferences().file("4D Mobile App.preferences")

  // ----------------------------------------------------
If ($file.exists)
	
	  // Get
	$oOUT:=JSON Parse:C1218($file.getText())
	
Else 
	
	  // Create
	$oOUT:=New object:C1471
	
End if 

If ($oIN#Null:C1517)
	
	  // Set
	$oOUT[$oIN.key]:=$oIN.value
	
	  // Save
	$file.setText(JSON Stringify:C1217($oOUT;*))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$oOUT

  // ----------------------------------------------------
  // End