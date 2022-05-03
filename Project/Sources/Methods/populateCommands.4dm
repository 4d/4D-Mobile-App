//%attributes = {}
var $applicationVersion; $name; $themeName : Text
var $index; $info; $number : Integer
var $command; $ds_; $o; $status : Object
var $commands; $obsoletes; $resnames; $syntax : Collection
var $commandDataClass : 4D:C1709.DataClass
var $commandEntity; $themeEntity : 4D:C1709.Entity
var $file : 4D:C1709.File
var $str : cs:C1710.str
var $xml : cs:C1710.xml

$commandDataClass:=ds:C1482.Commands

$commands:=New collection:C1472
$obsoletes:=New collection:C1472

$str:=cs:C1710.str.new()
$xml:=cs:C1710.xml.new()

// Retrieve the list of command names
Repeat 
	
	$number+=1
	
	$command:=New object:C1471(\
		"ID"; $number; \
		"Command name"; "")
	
	$name:=Command name:C538($command.ID; $info; $themeName)
	
	If (OK=0)\
		 || (Length:C16($name)=0)\
		 || (Position:C15("_4D"; $name)=1)
		
		continue
		
	End if 
	
	$command["Command name"]:=$name
	
	$commandEntity:=$commandDataClass.query("ID = :1"; $command.ID).first()
	
	If (Position:C15("_O_"; $name)=1)  // Obsolete commmand
		
		// TODO: Put into an Obsolete data class
		$command.themeName:=$themeName
		
		$obsoletes.push($command)
		
		// Delete from Commands if any
		If ($commandEntity#Null:C1517)
			
			$status:=$commandEntity.drop()
			
		End if 
		
		continue
		
	End if 
	
	$applicationVersion:=Application version:C493
	
	If ($commandEntity#Null:C1517)
		
		// Correction
		If (String:C10($commandEntity.Comment)="Thread safe")
			
			$commandEntity.Comment:=""
			$commandEntity.save()
			
			$command.Comment:=""
			
		Else 
			
			// keep the precedent comment
			$command.Comment:=$commandEntity.Comment
			
		End if 
		
		If (Length:C16($commandEntity.version)=0)
			
			If ($applicationVersion[[3]]="0")
				
				$commandEntity.version:=$applicationVersion[[1]]+$applicationVersion[[2]]
				$commandEntity.version+="."+$applicationVersion[[4]]
				
			Else 
				
				$commandEntity.version:=$applicationVersion[[1]]+$applicationVersion[[2]]+"R"+$applicationVersion[[3]]
				
			End if 
			
			$commandEntity.save()
			
		Else 
			
			//%W-533.1
			If (Length:C16($commandEntity.version)>=4)\
				 && ($commandEntity.version[[3]]#"R")\
				 && ($commandEntity.version[[3]]#".")
				
				If ($applicationVersion[[3]]="0")
					
					$commandEntity.version:=$applicationVersion[[1]]+$applicationVersion[[2]]
					$commandEntity.version+="."+$applicationVersion[[4]]
					
				Else 
					
					$commandEntity.version:=$applicationVersion[[1]]+$applicationVersion[[2]]+"R"+$applicationVersion[[3]]
					
				End if 
				
				$commandEntity.save()
				
			End if 
			//%W+533.1
			
		End if 
		
	Else 
		
		// New command
		If ($applicationVersion[[3]]="0")
			
			$command.version:=$applicationVersion[[1]]+$applicationVersion[[2]]+"."+$applicationVersion[[4]]
			
		Else 
			
			$command.version:=$applicationVersion[[1]]+$applicationVersion[[2]]+"R"+$applicationVersion[[3]]
			
		End if 
	End if 
	
	$command["Command Number"]:=$command.ID
	$command.threadsafe:=$info ?? 0
	
	$command.themeName:=$themeName
	
	If (Length:C16($themeName)>0)
		
		$themeEntity:=ds:C1482.Themes.query("Name = :1"; $themeName).first()
		
		If ($themeEntity=Null:C1517)
			
			$themeEntity:=ds:C1482.Themes.new()
			$themeEntity.Name:=$themeName
			
			$themeEntity.save()
			
		End if 
		
		$command.themeID:=$themeEntity.ID
		
	End if 
	
	$commands.push($command)
	
Until (OK=0)

// Add syntax and description
$file:=File:C1566(Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxEN.xlf"; fk platform path:K87:2)

If (Asserted:C1132($file.exists; "file not found"))
	
	// Get INTL 4D Syntax
	$o:=$xml.load($file).toObject()
	
	$syntax:=$o.file.body.group["trans-unit"]
	
	$file:=File:C1566(Get 4D folder:C485(-1)+"en.lproj"+Folder separator:K24:12+"4DSyntaxWPEN.xlf"; fk platform path:K87:2)
	
	If ($file.exists)
		
		// Get INTL Write Pro Syntax
		$o:=$xml.load($file).toObject()
		
		$syntax:=$syntax.combine($o.file.body.group["trans-unit"])
		
	End if 
	
	$resnames:=$syntax.extract("resname")
	
	For each ($command; $commands)
		
		$index:=$resnames.indexOf("cmd"+String:C10($command["Command Number"]))
		
		If ($index#-1)
			
			$command.syntax:=$syntax[$index].target.$
			
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
	End for each 
	
	$ds_:=$commandDataClass.fromCollection($commands)
	
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
	// End if
	// End if
	// End for each
	//$ds_:=ds.obsoletes.fromCollection($obsoletes)
	
End if 

BEEP:C151