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

C_TEXT:C284($t_pathname)
C_OBJECT:C1216($file; $o; $o_project)

If (False:C215)
	C_OBJECT:C1216(_o_project_Load; $0)
	C_TEXT:C284(_o_project_Load; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$t_pathname:=$1  // Project pathname
	
	$file:=File:C1566($t_pathname; fk platform path:K87:2)
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
RECORD.info("Opening project: "+$file.parent.fullName)

If ($file.exists)
	
	$o_project:=JSON Parse:C1218($file.getText())
	
	If (project_Upgrade($o_project))
		
		// If upgraded Keep a copy of the old project…
		$o:=$file.parent.folder(Replace string:C233(Get localized string:C991("convertedFiles"); "{stamp}"; str_date("stamp")))
		$o.create()
		$file.moveTo($o)
		
		RECORD.warning("Prior project was saved in: "+$o.fullName)
		
		//… & immediately save
		_o_project_SAVE($o_project)
		
	End if 
	
Else 
	
	RECORD.error("File not found: "+$file.path)
	
End if 

// ----------------------------------------------------
// Return
$0:=$o_project  // Definition of the project updated if necessary

// ----------------------------------------------------
// End