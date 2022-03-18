//%attributes = {"invisible":true,"preemptive":"capable"}

var $PROJECT : Object
$PROJECT:=cs:C1710.project.new()

// In ds.Employes
var $employesFile : 4D:C1709.File
$employesFile:=Folder:C1567(fk database folder:K87:14).file("Project/Sources/Classes/EmployesEntity.4dm")

If (Shift down:C543)
	
	If (Not:C34($employesFile.exists))
		
		var $code : Text
		$code:="Class extends Entity\n\n"
		
		var $aliases : Collection
		$aliases:=New collection:C1472(\
			"exposed Alias offices employee_return.office"; \
			"exposed Alias group service"; \
			"exposed Alias collegues service.employees"; \
			"exposed Alias colleguesByGroup group.employees"; \
			"exposed Alias recu service.employees.group"; \
			"exposed Alias serviceName service.Name"; \
			"exposed Alias nom Name"\
			)
		
		$code+=$aliases.join("\n")
		
		$employesFile.setText($code)
		
	End if 
	
End if 

If (Asserted:C1132($employesFile.exists; "Data class EmployesEntity not declared, so no alias defined"))
	
	// MARK: - relation alias
	// Exposed Alias offices employee_return.office
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["offices"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["offices"]).field#Null:C1517)
	
	// Exposed Alias group service
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["group"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["group"]).field#Null:C1517)
	
	// Exposed Alias collegues service.employees
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["collegues"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["collegues"]).field#Null:C1517)
	
	// Exposed Alias colleguesByGroup group.employees
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["colleguesByGroup"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["colleguesByGroup"]).field#Null:C1517)
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["colleguesByGroup"]; /*recu*/True:C214).field#Null:C1517)
	
	// Test on recursive alias
	// Exposed Alias recu service.employees.group
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["recu"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]).field#Null:C1517)
	ASSERT:C1129($PROJECT.isAlias($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]).field))
	
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]; /*recu*/True:C214).field#Null:C1517)
	ASSERT:C1129(Not:C34($PROJECT.isAlias($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]; /*recu*/True:C214).field)))
	
	// MARK: -  scalar alias
	// Exposed Alias serviceName service.Name
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["serviceName"]))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["serviceName"]).field#Null:C1517)
	
	// Exposed Alias nom Name
	ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["nom"]))
	
	// FIXME: 4D Not return `path`
	// ASSERT($PROJECT.getAliasDestination(ds.Employes; ds.Employes["nom"])#Null)
	// TODO: uncomment test
	
	// MARK: - no alias
	ASSERT:C1129(Not:C34($PROJECT.isAlias(ds:C1482.Employes["Name"])))
	ASSERT:C1129($PROJECT.__getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["Name"])=Null:C1517)
	
End if 