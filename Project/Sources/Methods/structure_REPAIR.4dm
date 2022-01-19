//%attributes = {"invisible":true}
var $cache; $file : Object

//MARK: Audit result should be in EDITOR not into PROJECT.$dialog
PROJECT.repairStructure(PROJECT.$dialog.unsynchronizedTableFields)

// Update status & cache
OB REMOVE:C1226(PROJECT.$dialog; "unsynchronizedTableFields")
OB REMOVE:C1226(PROJECT.$project.structure; "unsynchronized")

$file:=PROJECT._folder.file("catalog.json")

If ($file.exists)
	
	$cache:=JSON Parse:C1218($file.getText())
	cs:C1710.ob.new($cache).createPath("structure")
	
Else 
	
	$cache:=cs:C1710.ob.new().createPath("structure").content
	
End if 

Form:C1466.$catalog:=_o_structure(New object:C1471("action"; "catalog")).value

$cache.structure.definition:=Form:C1466.$catalog
$cache.structure.digest:=Generate digest:C1147(JSON Stringify:C1217(Form:C1466.$catalog); SHA1 digest:K66:2)

$file.setText(JSON Stringify:C1217($cache; *))

// Refresh UI
STRUCTURE_Handler(New object:C1471(\
"action"; "update"))

PROJECT.repairProject()

// Save project
PROJECT.save()

//EDITOR.callMeBack("projectAuditResult"; PROJECT.audit())

// Launch project verifications
EDITOR.callMeBack("projectAudit")

// Update UI
EDITOR.updateRibbon()
EDITOR.refreshViews()
EDITOR.hidePicker()
EDITOR.updateHeader(New object:C1471("show"; False:C215))
EDITOR.callChild("project"; Formula:C1597(PROJECT_ON_ACTIVATE).source)