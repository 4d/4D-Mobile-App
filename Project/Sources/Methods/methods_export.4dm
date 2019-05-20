//%attributes = {"invisible":true}
/*
***methods_export*** ( param )
 -> param (Object)
________________________________________________________

*/
  // ----------------------------------------------------
  // Project method : export Methods
  // ---------------------------------------------------
  // Description:
  // Bugs: method in subfolders are exported multiple times
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_methods)
C_OBJECT:C1216($Obj_export_param;$Obj_param;$Obj_result)

If (False:C215)
	C_OBJECT:C1216(methods_export ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Obj_param:=$1
		
	Else 
		
		$Obj_param:=New object:C1471
		
	End if 
End if 

If ($Obj_param.path=Null:C1517)
	
	$Dir_methods:=Get 4D folder:C485(Database folder:K5:14;*)
	
	Repeat 
		
		$Dir_methods:=Delete string:C232($Dir_methods;Length:C16($Dir_methods);1)
		
	Until ($Dir_methods[[Length:C16($Dir_methods)]]#Folder separator:K24:12)
	
	$Obj_param.path:=Replace string:C233($Dir_methods;".4dbase";"")+" Project"+Folder separator:K24:12
	
End if 

If (Test path name:C476($Obj_param.path)#Is a folder:K24:2)
	
	CREATE FOLDER:C475($Obj_param.path;*)
	
End if 

If ($Obj_param.git=Null:C1517)
	
	$Obj_param.git:=True:C214
	
End if 

$Obj_export_param:=New object:C1471

If (Value type:C1509($Obj_param.filter)=Is object:K8:27)
	
	$Obj_export_param.filter:=$Obj_param.filter
	
Else 
	
	$Obj_export_param.filter:=New object:C1471
	$Obj_export_param.filter.projectMethods:=True:C214
	$Obj_export_param.filter.databaseMethods:=True:C214
	$Obj_export_param.filter.triggerMethods:=True:C214
	$Obj_export_param.filter.forms:=True:C214
	$Obj_export_param.filter.catalog:=True:C214
	$Obj_export_param.filter.resources:=False:C215
	$Obj_export_param.filter.trash:=True:C214
	
End if 

  // Do export
$Obj_result:=Export structure file:C1565($Obj_param.path;$Obj_export_param)

If ($Obj_param.git)
	
	$Obj_result:=git (New object:C1471(\
		"action";"create";\
		"path";$Obj_param.path))
	
End if 

If (Shift down:C543)
	
	SHOW ON DISK:C922($Obj_param.path)
	
End if 

  // ----------------------------------------------------
  // End