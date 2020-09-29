Class extends Template

Class constructor
	C_OBJECT:C1216($1)
	Super:C1705($1)
	ASSERT:C1129(This:C1470.template.type="choice")
	
Function doRun
	C_OBJECT:C1216($0)
	$0:=This:C1470.makeTheChoice()
	
Function makeTheChoice
	// according to the default or user choice select an another template
	C_OBJECT:C1216($0; $Obj_out)
	$Obj_out:=New object:C1471()
	
	
	C_OBJECT:C1216($Obj_in; $Obj_template)
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	C_OBJECT:C1216($copyResult; $folder; $pathForm)
	
	C_TEXT:C284($t; $Txt_name)
	// Later must be a user choice by table Feature #93726, here we take default one
	// in Feature #93726 make it choice a byTable=True
	$t:=$Obj_template.default
	
	// Check choice make by tag path
	If (Length:C16(String:C10($Obj_template.tag))>0)
		
		If (Length:C16(String:C10($Obj_in.tags[$Obj_template.tag]))>0)
			
			$t:=$Obj_in.tags[$Obj_template.tag]
			
		End if 
	End if 
	
	$t:=$Obj_template.source+$t+Folder separator:K24:12
	
	If (Length:C16(String:C10($Obj_template.projectTag))>0)
		
		$Txt_name:=String:C10($Obj_in.project[String:C10($Obj_template.projectTag)])
		
		If (Length:C16($Txt_name)>0)
			
			$pathForm:=tmpl_form($Txt_name; String:C10($Obj_template.projectTag))
			
			If (Path to object:C1547($Txt_name).extension=SHARED.archiveExtension)  // Archive
				
				// Extract
				$copyResult:=$pathForm.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); "template"; fk overwrite:K87:5)
				$t:=$copyResult.platformPath
				
			Else 
				
				$t:=$pathForm.platformPath
				
			End if 
			
		Else 
			
			// Project file doesn't contain any custom template key
			
		End if 
		
	Else 
		
		// No projectTag in template manifest
		
	End if 
	
	C_OBJECT:C1216($o)
	$o:=OB Copy:C1225($Obj_in)
	
	$Obj_out:=New object:C1471("success"; True:C214)
	$Obj_out.template:=ob_parseDocument($t+"manifest.json")
	
	If ($Obj_out.template.success)
		
		$o.template:=$Obj_out.template.value  // TODO RELATION COMPARE code with previous  $Obj_out.template.value
		$o.template.source:=$t
		$o.template.parent:=$Obj_template.parent  // or $Obj_template?
		$o.projfile:=$Obj_in.projfile  // do not want a copy (done by ob copy to be able to change it)
		
		$Obj_out.template:=TemplateInstanceFactory($o).run()  // <================================== RECURSIVE
		ob_error_combine($Obj_out; $Obj_out.template)
		
	Else 
		
		ob_error_combine($Obj_out; $Obj_out.template)
	End if 
	
	$0:=$Obj_out