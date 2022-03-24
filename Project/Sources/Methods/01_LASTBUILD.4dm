//%attributes = {}
var $content; $o; $result : Object

COMPILER_COMPONENT
$o:=cs:C1710.path.new().userCache().parent.file("lastBuild.ios.4dmobile")

If ($o.exists)
	
	COMPILER_COMPONENT
	
	//$content:=JSON Parse(Document to text($o.platformPath))
	$content:=JSON Parse:C1218(File:C1566($o.platformPath; fk platform path:K87:2).getText())
	$content.verbose:=True:C214  // force verbose
	$content.caller:=Null:C1517  // no caller windows, want to have result here
	
	$o:=New object:C1471(\
		"create"; Bool:C1537($content.create); \
		"build"; Bool:C1537($content.build); \
		"run"; Bool:C1537($content.run))
	
	LOG_EVENT(New object:C1471(\
		"message"; "Relaunch a previous build: "+JSON Stringify:C1217($o); \
		"importance"; Information message:K38:1))
	
	$result:=mobile_Project($content)
	
	If (String:C10($result.path)#"")
		
		$result.posix:=Convert path system to POSIX:C1106($result.path)
		
	End if 
	
	If (Bool:C1537($result.success))
		
		LOG_EVENT(New object:C1471(\
			"message"; "Last Build Success"; \
			"importance"; Information message:K38:1))
		
	Else 
		
		LOG_EVENT(New object:C1471(\
			"message"; "Last Build Failed: "+JSON Stringify:C1217($result); \
			"importance"; Warning message:K38:2))
		
		SHOW ON DISK:C922($result.path)
		
	End if 
	
Else 
	
	LOG_EVENT(New object:C1471(\
		"message"; "No last build file"; \
		"importance"; Information message:K38:1))
	
End if 