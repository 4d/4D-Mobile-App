//%attributes = {}
C_OBJECT:C1216($o; $Obj_content; $Obj_result)

$o:=ENV.caches("lastBuild.4dmobile")

If ($o.exists)
	
	COMPILER_COMPONENT
	
	$Obj_content:=JSON Parse:C1218(Document to text:C1236($o.platformPath))
	$Obj_content.verbose:=True:C214  // force verbose
	$Obj_content.caller:=Null:C1517  // no caller windows, want to have result here
	
	$o:=New object:C1471(\
		"create"; Bool:C1537($Obj_content.create); \
		"build"; Bool:C1537($Obj_content.build); \
		"run"; Bool:C1537($Obj_content.run))
	
	LOG_EVENT(New object:C1471(\
		"message"; "Relaunch a previous build: "+JSON Stringify:C1217($o); \
		"importance"; Information message:K38:1))
	
	$Obj_result:=mobile_Project($Obj_content)
	
	If (String:C10($Obj_result.path)#"")
		
		$Obj_result.posix:=Convert path system to POSIX:C1106($Obj_result.path)
		
	End if 
	
	If (Bool:C1537($Obj_result.success))
		
		LOG_EVENT(New object:C1471(\
			"message"; "Last Build Success"; \
			"importance"; Information message:K38:1))
		
	Else 
		
		LOG_EVENT(New object:C1471(\
			"message"; "Last Build Failed: "+JSON Stringify:C1217($Obj_result); \
			"importance"; Warning message:K38:2))
		
		SHOW ON DISK:C922($Obj_result.path)
		
	End if 
	
Else 
	
	LOG_EVENT(New object:C1471(\
		"message"; "No last build file"; \
		"importance"; Information message:K38:1))
	
End if 