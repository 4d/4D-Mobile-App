//%attributes = {"invisible":true}
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

$reponse:=New object:C1471("database"; Null:C1517)

If (Is macOS:C1572)
	
	$project:=$in.project
	$database:=$project._folder.file("project.dataSet/Resources/Structures.sqlite")
	
	If ($database.exists)
		
		$scripts:=cs:C1710.path.new().scripts()
		
		$osVersion:=Get system info:C1571.osVersion
		
		If (Is macOS:C1572)
			
			//fixme: macOS <12
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
	End if 
End if 

CALL FORM:C1391($in.caller; Formula:C1597(editor_CALLBACK).source; "datasetInformations"; $reponse)