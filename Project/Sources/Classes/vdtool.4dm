Class extends lep

Class constructor()
	Super:C1705()
	
	var $studio : cs:C1710.studio
	$studio:=cs:C1710.studio.new()
	
	This:C1470.classPath:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2).folder("scripts").file("vd-tool.jar").path
	This:C1470.javaExe:="java"
	
	If ($studio.success)
		
		var $androidStudio : Text
		
		If (Is macOS:C1572)
			
			$androidStudio:=Folder:C1567($studio.exe.path+"Contents").path
			This:C1470.classPath:=This:C1470.classPath+":"+$androidStudio+"/lib/*:"+$androidStudio+"/plugins/android/lib/*:"+$androidStudio+"/plugins/android-layoutlib/lib/*"
			
		Else 
			
			$androidStudio:=Folder:C1567($studio.exe.platformPath; fk platform path:K87:2).parent.parent.platformPath
			This:C1470.classPath:=This:C1470.classPath+";"+$androidStudio+"lib\\*;"+$androidStudio+"plugins\\android\\lib\\*;"+$androidStudio+"plugins\\android-layoutlib\\lib\\*"
			
		End if 
		
		If (Bool:C1537($studio.javaHome.exists))
			
			This:C1470.setEnvironnementVariable("JAVA_HOME"; $studio.javaHome.path)
			
			This:C1470.javaExe:=$studio.javaHome.file("bin/java").path
			If (Is Windows:C1573)
				This:C1470.javaExe:=This:C1470.javaExe+".exe"
			End if 
			
		End if 
	End if 
	
	
/*
Convert one file or content of a folder $source into $destination
*/
Function convert($source : Object/*File or Folder*/; $destination : 4D:C1709.Folder)->$result : Boolean
	ASSERT:C1129(Value type:C1509($source.path)=Is text:K8:3; "$source to convert svg must be a file or a folder")
	
	var $cmd : Text
	$cmd:="\""+This:C1470.javaExe+"\" -Djava.awt.headless=true -classpath \""+This:C1470.classPath+"\" com.android.ide.common.vectordrawable.VdCommandLineTool"
	
	If (Is macOS:C1572)
		$cmd:=$cmd+" -c -in \""+$source.path+"\" -out \""+$destination.path+"\""
	Else 
		$cmd:=$cmd+" -c -in \""+$source.parent.platformPath+$source.name+"\" -out \""+$destination.parent.platformPath+$destination.name+"\""
	End if 
	
	This:C1470.launch($cmd)
	
	// TODO manage result
	// outputStream contains Convert XXX SVG files in total, errors found in YYY files
	This:C1470.success:=Length:C16(This:C1470.errorStream)=0  // maybe check also outputStream (errors found in YYY files)
	
	$result:=This:C1470.success
	
	
/**
a code to test: cs.vdtool.new()._test() (no static function so no cs.vdtool._test())
*/
Function _test()
	var $vdtool : Object
	$vdtool:=cs:C1710.vdtool.new()
	
	var $source : 4D:C1709.File
	var $destination : 4D:C1709.File
	$source:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2).folder("images/tableIcons/actions")
	$destination:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).folder(Generate UUID:C1066)
	$destination.create()
	
	var $result : Boolean
	$result:=$vdtool.convert($source; $destination)
	
	ASSERT:C1129($result; "Failed to convert")
	
	
	If (Shift down:C543)  // maintain shift to see result
		SHOW ON DISK:C922($destination.platformPath)
	Else 
		$destination.delete(Delete with contents:K24:24)  // clean all
	End if 