//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($in : Object)

If (False:C215)
	C_OBJECT:C1216(getSQLite; $1)
End if 

var $project; $reponse : Object
var $database : 4D:C1709.File

$reponse:=New object:C1471(\
"database"; Null:C1517; \
"target"; String:C10($in.target))

$project:=$in.project

// CLEAN: maybe use cs.path iOSDB and androidDB
Case of 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: (String:C10($in.target)="ios")
		
		$database:=$project._folder.file("project.dataSet/Resources/Structures.sqlite")
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: (String:C10($in.target)="android")
		
		$database:=$project._folder.file("project.dataSet/android/static.db")
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Else 
		
		$database:=New object:C1471(\
			"exists"; False:C215)
		
		ASSERT:C1129(dev_Matrix; "Unknown target '"+String:C10($in.target)+"' for data dump")
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 

If ($database.exists)
	
	$reponse.database:=cs:C1710.sqliteSizes.new().stats($database)
	
End if 

If ($in.caller#Null:C1517)
	
	CALL FORM:C1391($in.caller; $in.method; $in.message; $reponse)
	
End if 