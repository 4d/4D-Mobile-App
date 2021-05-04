//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_form
// ID[5A5E314B52D74229853B34D28FC902B5]
// Created 15-1-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_TEXT:C284($2)

C_BOOLEAN:C305($success)
C_TEXT:C284($t; $t_formName; $t_typeForm)
C_OBJECT:C1216($archive; $error; $fileManifest; $o; $pathForm)

If (False:C215)
	C_OBJECT:C1216(_o_tmpl_form; $0)
	C_TEXT:C284(_o_tmpl_form; $1)
	C_TEXT:C284(_o_tmpl_form; $2)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=2; "Missing parameter"))
	
	// Required parameters
	$t_formName:=$1
	$t_typeForm:=$2
	
	// Default values
	
	// Optional parameters
	If (Count parameters:C259>=3)
		
		// <NONE>
		
	End if 
	
	var $path : cs:C1710.path
	$path:=cs:C1710.path.new()
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($t_formName[[1]]="/")  // Host database resources
	
	$t_formName:=Delete string:C232($t_formName; 1; 1)  // Remove initial slash
	
	If (Path to object:C1547($t_formName).extension=SHARED.archiveExtension)  // Archive
		
/* START HIDING ERRORS */$error:=err.hide()
		$archive:=ZIP Read archive:C1637($path["host"+$t_typeForm+"Forms"]().file($t_formName))
/* STOP HIDING ERRORS */$error.show()
		
		If ($archive#Null:C1517)
			
			$pathForm:=$archive.root
			
		End if 
		
	Else 
		
		$pathForm:=Folder:C1567($path["host"+$t_typeForm+"Forms"]().folder($t_formName).platformPath; fk platform path:K87:2)
		
	End if 
	
	$success:=Bool:C1537($pathForm.exists)
	
	If ($success)
		
		// Verify the structure validity
		$o:=$path[$t_typeForm+"Forms"]()
		
		If ($o#Null:C1517)
			
			$fileManifest:=$o.file("manifest.json")
			
			If ($fileManifest.exists)
				
				$o:=JSON Parse:C1218($fileManifest.getText())
				
				If ($o.mandatory#Null:C1517)
					
					For each ($t; $o.mandatory) While ($success)
						
						$success:=$pathForm.file($t).exists | \
							$pathForm.folder("ios").file($t).exists
						
					End for each 
					
				Else 
					
					RECORD.warning("No mandatory for: "+$fileManifest.path)
					
				End if 
				
			Else 
				
				RECORD.warning("Missing manifest: "+$fileManifest.path)
				
			End if 
			
		Else 
			
			RECORD.warning("Unmanaged form type: "+$t_typeForm)
			
		End if 
	End if 
	
Else 
	
	$pathForm:=Folder:C1567($path[$t_typeForm+"Forms"]().folder($t_formName).platformPath; fk platform path:K87:2)
	
	// We assume that our templates are OK!
	$success:=$pathForm.exists
	
End if 

// ----------------------------------------------------
// Return
If ($success)
	
	$0:=$pathForm
	
Else 
	
	$0:=New object:C1471(\
		"exists"; False:C215)
	
End if 

// ----------------------------------------------------
// End