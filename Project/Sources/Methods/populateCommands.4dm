//%attributes = {}
var $pathnameSyntaxINTL; $pathnameSyntaxINTL_W; $themeName : Text
var $index; $info; $number : Integer
var $command; $ds_; $o; $status : Object
var $commands; $obsoletes; $resnames; $syntax : Collection
var $dataClass : 4D:C1709.DataClass
var $theme : 4D:C1709.Entity
var $entitySelection; $et : 4D:C1709.EntitySelection
var $str : cs:C1710.str
var $xml : cs:C1710.xml

$dataClass:=ds:C1482.Commands

$commands:=New collection:C1472
$obsoletes:=New collection:C1472

$pathnameSyntaxINTL:=Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxEN.xlf"
$pathnameSyntaxINTL_W:=Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxWPEN.xlf"

$str:=cs:C1710.str.new()
$xml:=cs:C1710.xml.new()

// Retrieve the list of command names
Repeat 
	
	$number+=1
	
	$command:=New object:C1471(\
		"ID"; $number; \
		"Command name"; "")
	
	$command["Command name"]:=Command name:C538($command.ID; $info; $themeName)
	
	Case of 
			
			//______________________________________________________
		: (OK=0)
			
			// There is no more command
			
			//______________________________________________________
		: (Length:C16($command["Command name"])=0)  // Deleted / Obfuscated command
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_4D"; $command["Command name"])=1)  // Private command
			
			// NOTHING MORE TO DO
			
			//______________________________________________________
		: (Position:C15("_O_"; $command["Command name"])=1)  // Obsolete commmand
			
			$command.themeName:=$themeName
			
			$obsoletes.push($command)
			
			// Delete from cmnd if any
			$entitySelection:=$dataClass.query("ID = :1"; $command.ID)
			
			If ($entitySelection.length>0)
				
				$status:=$entitySelection.drop()
				
			End if 
			
			//______________________________________________________
		Else 
			
			$command["Command Number"]:=$command.ID
			$command.threadsafe:=$info ?? 0
			
			$command.themeName:=$themeName
			
			If (Length:C16($themeName)>0)
				
				$et:=ds:C1482.Themes.query("Name = :1"; $themeName)
				
				If ($et.length=0)
					
					$theme:=ds:C1482.Themes.new()
					//%W-550.2
					$theme.Name:=$themeName
					//%W+550.2
					$theme.save()
					
				Else 
					
					$theme:=$et[0]
					
				End if 
				
				//%W-550.2
				$command.themeID:=$theme.ID
				//%W+550.2
				
			Else 
				
				// A "If" statement should never omit "Else"
				
			End if 
			
			If ($dataClass.query("ID = :1"; $command.ID).length=0)
				
				// New command
				$command.version:=Application version:C493
				
			End if 
			
			$commands.push($command)
			
			//______________________________________________________
	End case 
Until (OK=0)

// Add syntax and description
If (Asserted:C1132(Test path name:C476($pathnameSyntaxINTL)=Is a document:K24:1; "file not found"))
	
	// Get INTL 4D Syntax
	$o:=$xml.load(File:C1566($pathnameSyntaxINTL; fk platform path:K87:2)).toObject()
	
	$syntax:=$o.file.body.group["trans-unit"]
	
	If (Test path name:C476($pathnameSyntaxINTL_W)=Is a document:K24:1)
		
		// Get INTL Write Pro Syntax
		$o:=$xml.load(File:C1566($pathnameSyntaxINTL_W; fk platform path:K87:2)).toObject()
		
		$syntax:=$syntax.combine($o.file.body.group["trans-unit"])
		
	End if 
	
	$resnames:=$syntax.extract("resname")
	
	For each ($command; $commands)
		
		$index:=$resnames.indexOf("cmd"+String:C10($command["Command Number"]))
		
		If ($index#-1)
			
			$command.syntax:=$str.setText($syntax[$index].target.$).xmlSafe()
			
			$index:=$resnames.indexOf("desc"+String:C10($command["Command Number"]))
			
			If ($index#-1)
				
				$command.description:=$syntax[$index].target.$
				
				// Some corrections
				$command.description:=$str.setText($command.description).trim()
				$command.description:=Replace string:C233($command.description; "  "; " ")
				$command.description:=Replace string:C233($command.description; "<em>"; "")
				$command.description:=Replace string:C233($command.description; "</em>"; "")
				//%W-533.1
				$command.description[[1]]:=Uppercase:C13($command.description[[1]])
				//%W+533.1
				
			End if 
		End if 
		
		If (Bool:C1537($command.threadsafe))
			
			$command.Comment:="Thread safe"
			
		Else 
			
			$command.Comment:=""
			
		End if 
	End for each 
	
	$ds_:=$dataClass.fromCollection($commands)
	
	//For each ($command; $obsoletes)
	//$index:=$resnames.indexOf("cmd"+String($command["Command Number"]))
	//If ($index#-1)
	//$command.syntax:=$syntax[$index].target.$
	//$index:=$resnames.indexOf("desc"+String($command["Command Number"]))
	//If ($index#-1)
	//$command.description:=$syntax[$index].target.$
	//// Some corrections
	//$command.description:=$str.setText($command.description).trim()
	//$command.description:=Replace string($command.description; "  "; " ")
	//$command.description:=Replace string($command.description; "<em>"; "")
	//$command.description:=Replace string($command.description; "</em>"; "")
	//$command.description[[1]]:=Uppercase($command.description[[1]])
	//End if
	//End if
	//End for each
	//$ds_:=ds.obsoletes.fromCollection($obsoletes)
	
End if 

BEEP:C151