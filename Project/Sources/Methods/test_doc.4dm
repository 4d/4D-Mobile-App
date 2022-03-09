//%attributes = {}
C_TEXT:C284($Dir_; $Dir_resources; $File_; $t; $t2; $Txt_expected)
C_TEXT:C284($Txt_nullDateTime; $Txt_reference)
C_OBJECT:C1216($o; $Obj_expected; $oFile; $oRoot)
C_COLLECTION:C1488($c)

err_TRY

If (True:C214)
	
	// Default reference to database folder
	$oRoot:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)
	$oFile:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2).file("folder1/folder2/file.txt")
	
	$c:=New collection:C1472
	
	$o:=cs:C1710.doc.new($oFile)
	$c.push(New object:C1471(\
		"path"; $o.path; \
		"platformPath"; $o.platformPath; \
		"relativePath"; $o.relativePath))
	
	$o:=cs:C1710.doc.new($oFile.path)
	$c.push(New object:C1471(\
		"path"; $o.path; \
		"platformPath"; $o.platformPath; \
		"relativePath"; $o.relativePath))
	
	$o:=cs:C1710.doc.new($oFile.platformPath)
	$c.push(New object:C1471(\
		"path"; $o.path; \
		"platformPath"; $o.platformPath; \
		"relativePath"; $o.relativePath))
	
	$o:=cs:C1710.doc.new(":"+Replace string:C233($oFile.platformPath; $oRoot.platformPath; ""))
	$c.push(New object:C1471(\
		"path"; $o.path; \
		"platformPath"; $o.platformPath; \
		"relativePath"; $o.relativePath))
	
	ASSERT:C1129($c.query("path = :1"; $oFile.path).length=4)
	ASSERT:C1129($c.query("platformPath = :1"; $oFile.platformPath).length=4)
	ASSERT:C1129($c.query("relativePath = :1"; "/folder1/folder2/file.txt").length=4)
	
	// Set the reference to a directory
	$c:=New collection:C1472
	
	$oRoot:=Folder:C1567(fk user preferences folder:K87:10)
	$o:=cs:C1710.doc.new("/folder1/folder2/"; $oRoot)
	ASSERT:C1129($o.relativePath="/folder1/folder2/")
	ASSERT:C1129($o.path=($oRoot.path+"folder1/folder2/"))
	
	$oRoot:=Folder:C1567(fk desktop folder:K87:19)
	$oFile:=$oRoot.file("folder1/folder2/file.txt")
	$o:=cs:C1710.doc.new($oFile)
	ASSERT:C1129($o.path=$o.relativePath)
	
End if 

err_FINALLY