//%attributes = {"invisible":true}
/*
***PROJECT_UI_ALERT*** ( in )
 -> in (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : project_UI_ALERT
  // Database: 4D Mobile Express
  // ID[ACDDE8AE2FFC4989ADC083AF98BE31E1]
  // Created #10-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_ui)

If (False:C215)
	C_OBJECT:C1216(project_UI_ALERT ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  //Required parameters
	$Obj_ui:=$1
	
	  //Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (OB Get:C1224($Obj_ui;"reset";Is boolean:K8:9))
	
	OBJECT SET TITLE:C194(*;$Obj_ui.target;"")
	OBJECT SET HELP TIP:C1181(*;$Obj_ui.target;"")
	
Else 
	
	Case of 
			
			  //______________________________________________________
		: ($Obj_ui.type="alert")
			
			OBJECT SET TITLE:C194(*;$Obj_ui.target;ui.alert)
			
			  //______________________________________________________
		: ($Obj_ui.type="warning")
			
			OBJECT SET TITLE:C194(*;$Obj_ui.target;ui.warning)
			
			  //______________________________________________________
		Else 
			
			OBJECT SET TITLE:C194(*;$Obj_ui.target;ui.alert)
			
			  //______________________________________________________
	End case 
	
	OBJECT SET HELP TIP:C1181(*;$Obj_ui.target;$Obj_ui.tips)
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End