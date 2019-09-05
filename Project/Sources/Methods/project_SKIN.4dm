//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_SKIN
  // ID[B90401BEDC9A4549941B7E4978430FFE]
  // Created 16-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_skin)

If (False:C215)
	C_OBJECT:C1216(project_SKIN ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_skin:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_skin.ui#Null:C1517)
	
	  //background color
	If ($Obj_skin.ui.background#Null:C1517)
		
		OBJECT SET RGB COLORS:C628(*;"__background";Background color none:K23:10;$Obj_skin.ui.background)
		
	End if 
	
	  //lines color
	If ($Obj_skin.ui.line#Null:C1517)
		
		OBJECT SET RGB COLORS:C628(*;"@line@";$Obj_skin.ui.line;Background color:K23:2)
		
	End if 
	
	  //labels color
	If ($Obj_skin.ui.labels#Null:C1517)
		
		OBJECT SET RGB COLORS:C628(*;"@label@";$Obj_skin.ui.labels;Background color:K23:2)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End