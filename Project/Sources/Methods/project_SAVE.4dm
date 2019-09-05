//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_SAVE
  // ID[6AFFE5642DDA4B78AE743AABFCA0C23A]
  // Created 21-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Save the Object named "project" to path Form.project.
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_;$t;$tt)
C_OBJECT:C1216($o;$Obj_project)

If (False:C215)
	C_OBJECT:C1216(project_SAVE ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_project:=$1
		
	Else 
		
		$Obj_project:=OB Copy:C1225((OBJECT Get pointer:C1124(Object named:K67:5;"project"))->)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Bool:C1537(featuresFlags._8858))  // Debug mode
	
	$Dir_:=System folder:C487(Desktop:K41:16)+Convert path POSIX to system:C1107("DEV/")
	
	If (Test path name:C476($Dir_)=Is a folder:K24:2)
		
		TEXT TO DOCUMENT:C1237($Dir_+"project.json";JSON Stringify:C1217($Obj_project;*))
		
	End if 
End if 

If (Not:C34(editor_Locked ))
	
	For each ($t;$Obj_project)
		
		If ($t[[1]]="$")
			
			OB REMOVE:C1226($Obj_project;$t)
			
		Else 
			
			Case of 
					
					  //______________________________________________________
				: (Value type:C1509($Obj_project[$t])=Is object:K8:27)
					
					For each ($tt;$Obj_project[$t])
						
						If ($tt[[1]]="$")
							
							OB REMOVE:C1226($Obj_project[$t];$tt)
							
						End if 
					End for each 
					
					  //______________________________________________________
				: (Value type:C1509($Obj_project[$t])=Is collection:K8:32)
					
					For each ($o;$Obj_project[$t])
						
						For each ($tt;$o)
							
							If ($tt[[1]]="$")
								
								OB REMOVE:C1226($o;$tt)
								
							End if 
						End for each 
					End for each 
					
					  //______________________________________________________
			End case 
		End if 
	End for each 
	
	CREATE FOLDER:C475(Form:C1466.project;*)
	
	TEXT TO DOCUMENT:C1237(Form:C1466.project;JSON Stringify:C1217($Obj_project;*))
	
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End