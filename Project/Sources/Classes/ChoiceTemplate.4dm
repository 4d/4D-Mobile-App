Class extends Template

Class constructor($input : Object)
	Super:C1705($input)
	ASSERT:C1129(This:C1470.template.type="choice")
	
Function doRun()->$result : Object
	$result:=This:C1470.makeTheChoice()
	
Function makeTheChoice()->$Obj_out : Object
	// according to the default or user choice select an another template
	
	$Obj_out:=New object:C1471()
	
	var $Obj_in; $Obj_template : Object
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	var $default : Text
	// Later must be a user choice by table Feature #93726, here we take default one
	// in Feature #93726 make it choice a byTable=True
	$default:=$Obj_template.default
	
	// Check choice make by tag path
	If (Length:C16(String:C10($Obj_template.tag))>0)
		
		If (Length:C16(String:C10($Obj_in.tags[$Obj_template.tag]))>0)
			
			$default:=$Obj_in.tags[$Obj_template.tag]
			
		End if 
	End if 
	
	var $defaultPathForm; $pathForm : Object/*4D.Folder or 4D.ZIPFolder*/
	$defaultPathForm:=Folder:C1567($Obj_template.source; fk platform path:K87:2).folder($default)
	$pathForm:=$defaultPathForm
	
	var $wanted : Text
	If (Length:C16(String:C10($Obj_template.projectTag))>0)
		
		$wanted:=String:C10($Obj_in.project[String:C10($Obj_template.projectTag)])
		
		If (Length:C16($wanted)>0)
			
			$pathForm:=cs:C1710.tmpl.new().getSources($wanted; String:C10($Obj_template.projectTag))
			
			If (GetFileExtension($wanted)=SHARED.archiveExtension)  // Archive
				
				// Extract
				$pathForm:=$pathForm.copyTo(Folder:C1567(Temporary folder:C486; fk platform path:K87:2); "template"; fk overwrite:K87:5)
				
			End if 
			
			// Else Project file doesn't contain any custom template key
			
		End if 
		
		// Else No projectTag in template manifest, so nothing to care about
		
	End if 
	
	$Obj_out:=New object:C1471("success"; True:C214)
	$Obj_out.template:=ob_parseFile($pathForm.file("manifest.json"))
	
	If (Not:C34(This:C1470._isValidChoice($Obj_out.template; $pathForm)))
		
		ob_error_combine($Obj_out; "Template do not exist at path "+$pathForm.path+" or not for iOS. Default will be used")
		$pathForm:=$defaultPathForm
		$Obj_out.template:=ob_parseFile($pathForm.file("manifest.json"))
		
	End if 
	
	If ($Obj_out.template.success)
		
		var $children : Object
		$children:=OB Copy:C1225($Obj_in)
		
		$children.template:=$Obj_out.template.value  // TODO RELATION COMPARE code with previous  $Obj_out.template.value
		$children.template.source:=$pathForm.platformPath
		$children.template.parent:=$Obj_template.parent  // or $Obj_template?
		$children.projfile:=$Obj_in.projfile  // do not want a copy (done by ob copy to be able to change it)
		
		$Obj_out.template:=TemplateInstanceFactory($children).run()  // <================================== RECURSIVE
		
	End if 
	
	ob_error_combine($Obj_out; $Obj_out.template)
	
Function _isValidChoice($template : Object; $parentPath : 4D:C1709.Folder)->$valid : Boolean
	If (Not:C34($template.success))
		$valid:=False:C215
		return 
	End if 
	
	Case of 
		: ($template.target=Null:C1517)
			$template.target:=New collection:C1472
		: (Value type:C1509($template.target)=Is text:K8:3)
			$template.target:=New collection:C1472($template.target)
	End case 
	
	If ($template.target.length=0)
		If (($parentPath.folder("ios").exists) || ($parentPath.folder("Sources").exists))
			$template.target.push("ios")
		End if 
	End if 
	
	$valid:=($template.target.indexOf("ios")#-1)
	