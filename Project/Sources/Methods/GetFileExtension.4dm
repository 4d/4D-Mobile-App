//%attributes = {}
#DECLARE($path : Variant; $pathType : Integer)->$result : Text

If (Count parameters:C259<2)
	$pathType:=fk platform path:K87:2
End if 

Case of 
	: (Value type:C1509($path)=Is text:K8:3)
		Case of 
			: (Length:C16($path)=0)
				$result:=""
			: (Feature.with("buildWithCmd"))
				// TODO: and maybe find more efficiant way to get ext
				$result:=Folder:C1567($path; $pathType).extension
			Else 
				$result:=Path to object:C1547($path; $pathType).extension
		End case 
	: ((Value type:C1509($path)=Is object:K8:27) && (OB Instance of:C1731($path; 4D:C1709.File) || OB Instance of:C1731($path; 4D:C1709.Folder)))
		$result:=$path.extension
	Else 
		ASSERT:C1129(False:C215; "Not correct passed type to create File instance: "+String:C10(Value type:C1509($path)))
End case 