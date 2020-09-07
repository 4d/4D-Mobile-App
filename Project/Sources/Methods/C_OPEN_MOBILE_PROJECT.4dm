//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project method : C_OPEN_MOBILE_PROJECT
// ID[E0BBE7A463F54391B61C51274CA84C45]
// Created 13-6-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
var $1 : Text

If (False:C215)
	C_TEXT:C284(C_OPEN_MOBILE_PROJECT; $1)
End if 

var $directory; $pathName; $projectName : Text
var $window : Integer
var $formData : Object

// ----------------------------------------------------
// Declarations

// ----------------------------------------------------
// Initialisations

// NO PARAMETERS REQUIRED

COMPILER_COMPONENT

// Optional parameters
If (Count parameters:C259>=1)
	
	$pathName:=$1  // {project file path}
	
	OK:=Num:C11(Test path name:C476($pathName)=Is a document:K24:1)
	
Else 
	
	$directory:=Folder:C1567("/PACKAGE/Mobile Projects").platformPath
	$projectName:=Select document:C905($directory; SHARED.extension; Get localized string:C991("mess_openProject"); Package open:K24:8+Use sheet window:K24:11)
	
	If (OK=1)
		
		$pathName:=DOCUMENT
		
	End if 
End if 

// ----------------------------------------------------
If (OK=1)
	
	// Open the project editor
	$window:=Open form window:C675("EDITOR"; Plain form window:K39:10; Horizontally centered:K39:1; At the top:K39:5; *)
	
	$formData:=New object:C1471(\
		"project"; $pathName; \
		"file"; File:C1566($pathName; fk platform path:K87:2))
	
	// Launch the worker
	$formData.$worker:="4D Mobile ("+String:C10($window)+")"
	CALL WORKER:C1389(String:C10($formData.$worker); "COMPILER_COMPONENT")
	
	If (DATABASE.isMatrix)
		
		DIALOG:C40("EDITOR"; $formData)
		CLOSE WINDOW:C154($window)
		
	Else 
		
		DIALOG:C40("EDITOR"; $formData; *)
		
	End if 
End if 

// ----------------------------------------------------
// End