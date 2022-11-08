//%attributes = {}
#DECLARE($sourceFile : Object)->$picture : Picture

If (Is macOS:C1572 || Is Windows:C1573 || ($sourceFile.extension#".svg"))
	
	Case of 
		: (OB Instance of:C1731($sourceFile; 4D:C1709.ZipFile))
			BLOB TO PICTURE:C682($sourceFile.getContent(); $picture)
		Else 
			READ PICTURE FILE:C678($sourceFile.platformPath; $picture)
	End case 
	
Else 
	// on linux svg because not supported we rasterize it
	
	var $worker : 4D:C1709.SystemWorker
	var $cmd : Text
	var $tempOutput; $inputFile : 4D:C1709.File
	
	Case of 
		: (OB Instance of:C1731($sourceFile; 4D:C1709.ZipFile))
			$inputFile:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($sourceFile.name+Generate UUID:C1066+".svg")
			$inputFile.setContent($sourceFile.getContent())
		Else 
			$inputFile:=$sourceFile
	End case 
	
	$tempOutput:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($sourceFile.name+Generate UUID:C1066+".png")
	// sudo apt install -y librsvg2-bin
	// use a size according to our needs for image set, not big images
	$cmd:="rsvg-convert -w 64 -h 64 "+str_singleQuoted($inputFile.path)+" -o "+str_singleQuoted($tempOutput.path)
	$worker:=4D:C1709.SystemWorker.new($cmd)
	$worker.wait()
	
	If ($tempOutput.exists)
		$picture:=readPicture($tempOutput)
		$tempOutput.delete()
		If (OB Instance of:C1731($sourceFile; 4D:C1709.ZipFile))
			$inputFile.delete()
		End if 
	End if 
End if 