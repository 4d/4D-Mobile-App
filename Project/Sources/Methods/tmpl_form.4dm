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
C_TEXT:C284($t;$tFormName;$tTypeForm)
C_OBJECT:C1216($archive;$errors;$oManifest;$pathForm)

If (False:C215)
	C_OBJECT:C1216(tmpl_form ;$0)
	C_TEXT:C284(tmpl_form ;$1)
	C_TEXT:C284(tmpl_form ;$2)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=2;"Missing parameter"))
	
	  // Required parameters
	$tFormName:=$1
	$tTypeForm:=$2
	
	  // Default values
	
	  // Optional parameters
	If (Count parameters:C259>=3)
		
		  // <NONE>
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($tFormName[[1]]="/")  // Host database resources
	
	$tFormName:=Delete string:C232($tFormName;1;1)  // Remove initial slash
	
	If (featuresFlags.with("resourcesBrowser"))
		
		If (Path to object:C1547($tFormName).extension=shared.archiveExtension)  // Archive
			
/* START HIDING ERRORS */$errors:=err .hide()
			$archive:=ZIP Read archive:C1637(COMPONENT_Pathname ("host_"+$tTypeForm+"Forms").file($tFormName))
/* STOP HIDING ERRORS */$errors.show()
			
			If ($archive#Null:C1517)
				
				$pathForm:=$archive.root
				
			End if 
			
		Else 
			
			$pathForm:=Folder:C1567(COMPONENT_Pathname ("host_"+$tTypeForm+"Forms").folder($tFormName).platformPath;fk platform path:K87:2)
			
		End if 
		
	Else 
		
		$pathForm:=Folder:C1567(COMPONENT_Pathname ("host_"+$tTypeForm+"Forms").folder($tFormName).platformPath;fk platform path:K87:2)
		
	End if 
	
	$success:=Bool:C1537($pathForm.exists)
	
	If ($success)
		
		  // Verify the structure validity
		$oManifest:=JSON Parse:C1218(COMPONENT_Pathname ($tTypeForm+"Forms").file("manifest.json").getText())
		
		For each ($t;$oManifest.mandatory) While ($success)
			
			$success:=$pathForm.file($t).exists
			
		End for each 
	End if 
	
Else 
	
	$pathForm:=Folder:C1567(COMPONENT_Pathname ($tTypeForm+"Forms").folder($tFormName).platformPath;fk platform path:K87:2)
	
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