
Class constructor
	
Function homeFolder
	var $0 : 4D:C1709.Folder
	$0:=Folder:C1567(fk desktop folder:K87:19).parent  // maybe there is a better way for all OS 
	
Function launch
	C_OBJECT:C1216($0)
	C_TEXT:C284($1)
	C_COLLECTION:C1488($2)
	C_TEXT:C284($cmd; $in; $out; $err)
	$cmd:=$1+" "+$2.join(" ")
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
	$0:=New object:C1471()
	$0.out:=$out
	$0.error:=$err
	$0.success:=((OK=1) & (Length:C16($err)=0))
	