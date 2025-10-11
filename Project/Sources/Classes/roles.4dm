Class constructor
	
	This:C1470.forceLogin:=False:C215
	This:C1470.privileges:=New collection:C1472
	This:C1470.roles:=New collection:C1472
	This:C1470.permissions:=New object:C1471
	This:C1470.file:=Null:C1517
	
	This:C1470.load()
	
	
Function load
	
	var $rolesFile : 4D:C1709.File
	var $rolesObject : Object
	
	// Get the roles.json file from the structure
	$rolesFile:=File:C1566("/PACKAGE/Project/Sources/roles.json"; *)
	
	This:C1470.file:=$rolesFile
	If ($rolesFile.exists)
		
		
		// Read and parse the JSON file
		$rolesObject:=JSON Parse:C1218($rolesFile.getText())
		
		If ($rolesObject#Null:C1517)
			
			// Map properties from the JSON to class properties
			If ($rolesObject.forceLogin#Null:C1517)
				This:C1470.forceLogin:=Bool:C1537($rolesObject.forceLogin)
			End if 
			
			If ($rolesObject.privileges#Null:C1517)
				This:C1470.privileges:=$rolesObject.privileges
			End if 
			
			If ($rolesObject.roles#Null:C1517)
				This:C1470.roles:=$rolesObject.roles
			End if 
			
			If ($rolesObject.permissions#Null:C1517)
				This:C1470.permissions:=$rolesObject.permissions
			End if 
			
		End if 
		
	End if 
	
	
Function getPrivilege($privilegeName : Text) : Object
	
	var $privilege : Object
	For each ($privilege; This:C1470.privileges)
		If ($privilege.privilege=$privilegeName)
			return $privilege
		End if 
	End for each 
	
	return Null:C1517
	
Function getRole($roleName : Text) : Object
	
	var $role : Object
	For each ($role; This:C1470.roles)
		If ($role.role=$roleName)
			return $role
		End if 
	End for each 
	
	return Null:C1517
	
	
Function getAllowedPermissions : Collection
	
	If (This:C1470.permissions.allowed#Null:C1517)
		return This:C1470.permissions.allowed
	End if 
	
	return New collection:C1472
	
Function hasReadDataStorePermission($privilegeName : Text) : Boolean
	
	If (This:C1470.privileges=Null:C1517)
		return False:C215
	End if 
	If (This:C1470.privileges.filter(Formula:C1597(String:C10($1.value.privilege)=$privilegeName)).length=0)
		return False:C215
	End if 
	
	If (This:C1470.permissions=Null:C1517)
		return False:C215
	End if 
	If (This:C1470.permissions.allowed=Null:C1517)
		return False:C215
	End if 
	If (Not:C34((Value type:C1509(This:C1470.permissions.allowed)=Is collection:K8:32)))
		return False:C215
	End if 
	
	var $ds : Collection
	$ds:=This:C1470.permissions.allowed.filter(Formula:C1597(String:C10($1.value.type)="datastore"))
	$ds:=$ds.filter(Formula:C1597(Value type:C1509($1.value.read)=Is collection:K8:32))
	$ds:=$ds.filter(Formula:C1597($1.value.read.includes($privilegeName)))
	
	
	
	return $ds.length>0
	
Function addReadDataStorePermission($privilegeName : Text)
	
	If (This:C1470.privileges=Null:C1517)
		This:C1470.privileges:=New collection:C1472()
	End if 
	If (This:C1470.permissions=Null:C1517)
		This:C1470.permissions:=New object:C1471()
	End if 
	If (This:C1470.permissions.allowed=Null:C1517)
		This:C1470.permissions.allowed:=New collection:C1472()
	End if 
	If (Not:C34((Value type:C1509(This:C1470.permissions.allowed)=Is collection:K8:32)))
		ALERT:C41("cannot edit roles")
		return 
	End if 
	
	If (This:C1470.privileges.filter(Formula:C1597(String:C10($1.value.privilege)=$privilegeName)).length=0)
		
		This:C1470.privileges.push(New object:C1471("privilege"; $privilegeName; "includes"; New collection:C1472()))
		
	End if 
	
	
	var $ds : Collection
	$ds:=This:C1470.permissions.allowed.filter(Formula:C1597(String:C10($1.value.type)="datastore"))
	
	If ($ds.filter(Formula:C1597(Value type:C1509($1.value.read)=Is collection:K8:32))\
		.filter(Formula:C1597($1.value.read.includes($privilegeName))).length>0)
		This:C1470.save()
		return   // already done
	End if 
	
	
	If ($ds.length>0)
		
		If ($ds[0].read=Null:C1517)
			$ds[0].read:=New collection:C1472()
		End if 
		
		$ds[0].read.push($privilegeName)
		
	Else 
		
		This:C1470.permissions.allowed.push(New object:C1471("applyTo"; "ds"; "type"; "datastore"; "read"; New collection:C1472($privilegeName)))
		
	End if 
	
	This:C1470.save()
	
	
Function toObject : Object
	
	var $result : Object
	
	$result:=New object:C1471
	$result.forceLogin:=This:C1470.forceLogin
	$result.privileges:=This:C1470.privileges
	$result.roles:=This:C1470.roles
	$result.permissions:=This:C1470.permissions
	
	return $result
	
Function save()
	
	If (This:C1470.file.exists)
		This:C1470.file.copyTo(This:C1470.file.parent; "roles"+Generate UUID:C1066+".json")  // backup
	End if 
	
	This:C1470.file.setText(JSON Stringify:C1217(This:C1470.toObject(); *))
	
	
	