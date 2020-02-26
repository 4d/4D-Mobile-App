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
C_TEXT:C284($t;$t_formName;$t_typeForm)
C_OBJECT:C1216($archive;$errors;$fileManifest;$o;$pathForm;$pathFormFormula)

If (False:C215)
	C_OBJECT:C1216(tmpl_form ;$0)
	C_TEXT:C284(tmpl_form ;$1)
	C_TEXT:C284(tmpl_form ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	  // Required parameters
	$t_formName:=$1
	$t_typeForm:=$2
	
	  // Default values
	
	  // Optional parameters
	If (Count parameters:C259>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------

$pathFormFormula:=path ["host"+$t_typeForm+"Forms"]
If ($pathFormFormula=Null:C1517)
	ASSERT:C1129("Unknown template path: "+"host"+$t_typeForm+"Forms")
End if 

If ($t_formName[[1]]="/")  // Host database resources
	
	$t_formName:=Delete string:C232($t_formName;1;1)  // Remove initial slash
	
	If (feature.with("resourcesBrowser"))
		
		If (Path to object:C1547($t_formName).extension=SHARED.archiveExtension)  // Archive
			
/* START HIDING ERRORS */$errors:=err .hide()
			$archive:=ZIP Read archive:C1637($pathFormFormula().file($t_formName))
/* STOP HIDING ERRORS */$errors.show()
			
			If ($archive#Null:C1517)
				
				$pathForm:=$archive.root
				
			End if 
			
		Else 
			
			$pathForm:=Folder:C1567($pathFormFormula().folder($t_formName).platformPath;fk platform path:K87:2)
			
		End if 
		
	Else 
		
		$pathForm:=Folder:C1567($pathFormFormula().folder($t_formName).platformPath;fk platform path:K87:2)
		
	End if 
	
	$success:=Bool:C1537($pathForm.exists)
	
	If ($success)
		
		  // Verify the structure validity
		$fileManifest:=path [$t_typeForm+"Forms"]().file("manifest.json")
		
		If ($fileManifest.exists)
			
			$o:=JSON Parse:C1218($fileManifest.getText())
			
			If ($o.mandatory#Null:C1517)
				
				For each ($t;$o.mandatory) While ($success)
					
					$success:=$pathForm.file($t).exists
					
				End for each 
				
			Else 
				
				RECORD.warning("No mandatory for: "+$fileManifest.path)
				
			End if 
			
		Else 
			
			RECORD.warning("Missing manifest : "+$fileManifest.path)
			
		End if 
	End if 
	
Else 
	
	$pathForm:=Folder:C1567(path [$t_typeForm+"Forms"]().folder($t_formName).platformPath;fk platform path:K87:2)
	
	  // We assume that our templates are OK!
	$success:=$pathForm.exists
	
End if 

  // ----------------------------------------------------
  // Return
If ($success)
	
	$0:=$pathForm
	
Else 
	
	$0:=New object:C1471(\
		"exists";False:C215)
	
End if 

  // ----------------------------------------------------
  // End