//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_Load
  // ID[4496D76DCBC64F2AA92340B61399720D]
  // Created 11-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_OBJECT:C1216($file;$o;$Obj_project)

If (False:C215)
	C_OBJECT:C1216(project_Load ;$0)
	C_TEXT:C284(project_Load ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$file:=File:C1566($1;fk platform path:K87:2)
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Asserted:C1132($file.exists;"File not found: "+$file.path))
	
	$Obj_project:=JSON Parse:C1218($file.getText())
	
	  // Upgrade project if necessary
	If (project_Upgrade ($Obj_project))
		
		  // If upgraded Keep a copy of the old project…
		$o:=$file.parent.folder(Replace string:C233(Get localized string:C991("convertedFiles");"{stamp}";str_date ("stamp")))
		$o.create()
		$file.moveTo($o)
		
		  //… & immediately save
		project_SAVE ($Obj_project)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_project

  // ----------------------------------------------------
  // End