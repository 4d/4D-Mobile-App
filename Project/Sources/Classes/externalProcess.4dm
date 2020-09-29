Class constructor
	
Function homeFolder
	var $0 : 4D:C1709.Folder
	
	$0:=Folder:C1567(fk desktop folder:K87:19).parent  // Maybe there is a better way for all OS
	
Function launch
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $cmd; $err; $in; $out : Text
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($2)=Is text:K8:3)
			
			$cmd:=$1+" "+$2
			
			//______________________________________________________
		: (Value type:C1509($2)=Is collection:K8:32)
			
			$cmd:=$1+" "+$2.join(" ")
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "$2 must be a text or a collection")
			
			//______________________________________________________
	End case 
	
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
	If (Length:C16($err)=0)
		
		If (Position:C15("ERROR:"; $out)>0)
			
			$err:=$out
			$out:=""
			
		End if 
	End if 
	
	$0:=New object:C1471(\
		"out"; $out; \
		"error"; $err; \
		"success"; Bool:C1537(OK) & (Length:C16($err)=0))
	
	
Function launchAsync
	var $0 : Object
	var $1 : Text
	var $2 : Variant
	
	var $cmd; $err; $in; $out : Text
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($2)=Is text:K8:3)
			
			$cmd:=$1+" "+$2
			
			//______________________________________________________
		: (Value type:C1509($2)=Is collection:K8:32)
			
			$cmd:=$1+" "+$2.join(" ")
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "$2 must be a text or a collection")
			
			//______________________________________________________
	End case 
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
	$0:=New object:C1471(\
		"out"; $out; \
		"error"; $err; \
		"success"; Bool:C1537(OK) & (Length:C16($err)=0))
	