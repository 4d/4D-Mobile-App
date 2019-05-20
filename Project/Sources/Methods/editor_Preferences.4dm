//%attributes = {"invisible":true}
/*
preferences := ***editor_Preferences*** ( in )
 -> in (Object)
 <- preferences (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : editor_Preferences
  // Database: 4D Mobile App
  // ID[D3B9FB0808EE47F79518B159B704340F]
  // Created #5-2-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_preferences)
C_OBJECT:C1216($Obj_in;$Obj_preferences)

If (False:C215)
	C_OBJECT:C1216(editor_Preferences ;$0)
	C_OBJECT:C1216(editor_Preferences ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$File_preferences:=_o_Pathname ("databasePreferences")+"4D Mobile App.preferences"
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($File_preferences)=Is a document:K24:1)  // Get the preferences
	
	$Obj_preferences:=JSON Parse:C1218(Document to text:C1236($File_preferences))
	
Else 
	
	$Obj_preferences:=New object:C1471
	
End if 

If ($Obj_in#Null:C1517)
	
	$Obj_preferences[$Obj_in.key]:=$Obj_in.value
	
	  // Save
	TEXT TO DOCUMENT:C1237($File_preferences;JSON Stringify:C1217($Obj_preferences;*))
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_preferences

  // ----------------------------------------------------
  // End