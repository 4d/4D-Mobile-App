//%attributes = {"invisible":true,"preemptive":"capable"}

var $PROJECT : Object
$PROJECT:=cs:C1710.project.new()


// in ds.Employes


// MARK: - relation alias
// exposed Alias offices employee_return.office
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["offices"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["offices"]).field#Null:C1517)

// exposed Alias group service
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["group"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["group"]).field#Null:C1517)

// exposed Alias collegues service.employees
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["collegues"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["collegues"]).field#Null:C1517)

// exposed Alias colleguesByGroup group.employees
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["colleguesByGroup"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["colleguesByGroup"]).field#Null:C1517)
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["colleguesByGroup"]; /*recu*/True:C214).field#Null:C1517)

// test on recursive alias
// exposed Alias recu service.employees.group
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["recu"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]).field#Null:C1517)
ASSERT:C1129($PROJECT.isAlias($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]).field))

ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]; /*recu*/True:C214).field#Null:C1517)
ASSERT:C1129(Not:C34($PROJECT.isAlias($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["recu"]; /*recu*/True:C214).field)))

// MARK: -  scalar alias
// exposed Alias serviceName service.Name
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["serviceName"]))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["serviceName"]).field#Null:C1517)

// exposed Alias nom Name
ASSERT:C1129($PROJECT.isAlias(ds:C1482.Employes["nom"]))
// FIXME: 4D Not return `path`
// ASSERT($PROJECT.getAliasDestination(ds.Employes; ds.Employes["nom"])#Null)
// TODO: uncomment test

// MARK: - no alias
ASSERT:C1129(Not:C34($PROJECT.isAlias(ds:C1482.Employes["Name"])))
ASSERT:C1129($PROJECT.getAliasDestination(ds:C1482.Employes; ds:C1482.Employes["Name"])=Null:C1517)
