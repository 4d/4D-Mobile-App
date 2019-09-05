//%attributes = {"invisible":true,"shared":true}
  // ----------------------------------------------------
  // Project method : C_OPEN_MOBILE_PROJECT
  // ID[E0BBE7A463F54391B61C51274CA84C45]
  // Created 13-6-2017 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters;$Win_hdl)
C_TEXT:C284($Dir_default;$File_project;$Txt_projectName)
C_OBJECT:C1216($Obj_form)

If (False:C215)
	C_TEXT:C284(C_OPEN_MOBILE_PROJECT ;$1)
End if 

  // ----------------------------------------------------
  // Declarations

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	COMPILER_COMPONENT 
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$File_project:=$1  // {project file path}
		
		OK:=Num:C11(Test path name:C476($File_project)=Is a document:K24:1)
		
	Else 
		
		$Dir_default:=Storage:C1525.database.projects.platformPath
		
		$Txt_projectName:=Select document:C905($Dir_default;commonValues.extension;Get localized string:C991("mess_openProject");Package open:K24:8+Use sheet window:K24:11)
		
		If (OK=1)
			
			$File_project:=DOCUMENT
			
		End if 
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (OK=1)
	
	  // Open the project editor
	$Win_hdl:=Open form window:C675("EDITOR";Plain form window:K39:10;Horizontally centered:K39:1;At the top:K39:5;*)
	
	$Obj_form:=New object:C1471(\
		"project";$File_project;\
		"file";File:C1566($File_project;fk platform path:K87:2))
	
	  // Launch the worker
	$Obj_form.$worker:="4D Mobile ("+String:C10($Win_hdl)+")"
	CALL WORKER:C1389(String:C10($Obj_form.$worker);"COMPILER_COMPONENT")
	
	If (Storage:C1525.database.isMatrix)
		
		DIALOG:C40("EDITOR";$Obj_form)
		
		CLOSE WINDOW:C154($Win_hdl)
		
	Else 
		
		DIALOG:C40("EDITOR";$Obj_form;*)
		
	End if 
End if 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End