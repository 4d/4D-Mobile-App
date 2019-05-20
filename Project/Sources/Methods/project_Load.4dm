//%attributes = {"invisible":true}
/*
project := ***project_Load*** ( pathname )
 -> pathname (Text)
 <- project (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : project_Load
  // Database: 4D Mobile Express
  // ID[4496D76DCBC64F2AA92340B61399720D]
  // Created #11-8-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($File_pathname)
C_OBJECT:C1216($o;$Obj_project;$oo)

If (False:C215)
	C_OBJECT:C1216(project_Load ;$0)
	C_TEXT:C284(project_Load ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$File_pathname:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // --------------h--------------------------------------
$Obj_project:=JSON Parse:C1218(Document to text:C1236($File_pathname))

  // Upgrade project if necessary
If (project_Upgrade ($Obj_project))
	
	  // If upgraded Keep a copy of the old project…
	$o:=File:C1566($File_pathname;fk platform path:K87:2)
	$oo:=$o.parent.folder(Replace string:C233(Get localized string:C991("convertedFiles");"{stamp}";str_date ("stamp")))
	$oo.create()
	$o.moveTo($oo)
	
	  //… & immediately save
	project_SAVE ($Obj_project)
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_project

  // ----------------------------------------------------
  // End