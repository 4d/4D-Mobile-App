//%attributes = {"invisible":true,"preemptive":"capable"}
#DECLARE($in : Object)

If (False:C215)
	C_OBJECT:C1216(getSQLite; $1)
End if 

var $osVersion : Text
var $len; $pos : Integer
var $project; $reponse : Object
var $database : 4D:C1709.File
var $scripts : 4D:C1709.Folder
var $lep : cs:C1710.lep

$reponse:=New object:C1471("database"; Null:C1517; "target"; String:C10($in.target))

$project:=$in.project
Case of 
	: ((String:C10($in.target)="ios") && (Is macOS:C1572))
		$database:=$project._folder.file("project.dataSet/Resources/Structures.sqlite")
	: (String:C10($in.target)="android")
		$database:=$project._folder.file("project.dataSet/android/static.db")
	Else 
		$database:=New object:C1471("exists"; False:C215)
		ASSERT:C1129(dev_Matrix; "Unknown target for data dump")
End case 

If ($database.exists)
	
	If (Not:C34(Feature.with("androidDataSet")))
		
		$scripts:=cs:C1710.path.new().scripts()
		
		// Warning: Get system info should not be called frequently (consumer) as the system will not change during the execution of the code
		$osVersion:=Get system info:C1571.osVersion
		
		If (Is macOS:C1572)
			
			// Fixme: macOS <12
			If (Match regex:C1019("(?m-si)macOS\\s(\\d+)"; $osVersion; 1; $pos; $len))
				
				If (Num:C11(Substring:C12($osVersion; $pos; $len))<12)
					
					$lep:=cs:C1710.lep.new()\
						.setOutputType(Is object:K8:27)\
						.launch($scripts.file("sqlite3_sizes_11.sh"); "'"+$database.path+"'")
					
				Else 
					
					$lep:=cs:C1710.lep.new()\
						.setOutputType(Is object:K8:27)\
						.launch($scripts.file("sqlite3_sizes.sh"); "'"+$database.path+"'")
					
				End if 
			End if 
			
		Else 
			
			$lep:=cs:C1710.lep.new()\
				.setOutputType(Is object:K8:27)\
				.launch($scripts.file("sqlite3_sizes.sh"); "'"+$database.path+"'")
			
		End if 
		
		If ($lep.success)
			
			$reponse.database:=$lep.outputStream
			
		End if 
	Else 
		
		$reponse.database:=cs:C1710.sqliteSizes.new().stats($database)
		
	End if 
End if 

If ($in.caller#Null:C1517)
	
	CALL FORM:C1391($in.caller; $in.method; $in.message; $reponse)
	
End if 