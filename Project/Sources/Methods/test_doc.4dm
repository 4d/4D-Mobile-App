//%attributes = {}
C_TEXT:C284($Dir_;$Dir_resources;$File_;$t;$t2;$Txt_expected)
C_TEXT:C284($Txt_nullDateTime;$Txt_reference)
C_OBJECT:C1216($o;$Obj_expected;$oFile;$oRoot)
C_COLLECTION:C1488($c)

TRY 

If (True:C214)
	
	  // Default reference to database folder
	$oRoot:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
	$oFile:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2).file("folder1/folder2/file.txt")
	
	$c:=New collection:C1472
	
	$o:=cs:C1710.doc.new($oFile)
	$c.push(New object:C1471(\
		"path";$o.path;\
		"platformPath";$o.platformPath;\
		"relativePath";$o.relativePath))
	
	$o:=cs:C1710.doc.new($oFile.path)
	$c.push(New object:C1471(\
		"path";$o.path;\
		"platformPath";$o.platformPath;\
		"relativePath";$o.relativePath))
	
	$o:=cs:C1710.doc.new($oFile.platformPath)
	$c.push(New object:C1471(\
		"path";$o.path;\
		"platformPath";$o.platformPath;\
		"relativePath";$o.relativePath))
	
	$o:=cs:C1710.doc.new(":"+Replace string:C233($oFile.platformPath;$oRoot.platformPath;""))
	$c.push(New object:C1471(\
		"path";$o.path;\
		"platformPath";$o.platformPath;\
		"relativePath";$o.relativePath))
	
	ASSERT:C1129($c.query("path = :1";$oFile.path).length=4)
	ASSERT:C1129($c.query("platformPath = :1";$oFile.platformPath).length=4)
	ASSERT:C1129($c.query("relativePath = :1";"/folder1/folder2/file.txt").length=4)
	
	  // Set the reference to a directory
	$c:=New collection:C1472
	
	$oRoot:=Folder:C1567(fk user preferences folder:K87:10)
	$o:=cs:C1710.doc.new("/folder1/folder2/";$oRoot)
	ASSERT:C1129($o.relativePath="/folder1/folder2/")
	ASSERT:C1129($o.path=($oRoot.path+"folder1/folder2/"))
	
	$oRoot:=Folder:C1567(fk desktop folder:K87:19)
	$oFile:=$oRoot.file("folder1/folder2/file.txt")
	$o:=cs:C1710.doc.new($oFile)
	ASSERT:C1129($o.path=$o.relativePath)
	
	If (True:C214)  // doc_Relative_path & doc_Absolute_path
		
		$Txt_reference:=Get 4D folder:C485(Database folder:K5:14;*)
		$File_:=$Txt_reference+Convert path POSIX to system:C1107("folder/subfolder/key.mobileapp")
		$Txt_expected:="/"+Convert path POSIX to system:C1107("folder/subfolder/key.mobileapp")
		
		$t:=doc_Relative_path ($File_)
		ASSERT:C1129($t=$Txt_expected)
		
		$t2:=doc_Relative_path ($File_;$Txt_reference)
		ASSERT:C1129($t2=$Txt_expected)
		
		ASSERT:C1129(doc_Absolute_path ($t;$Txt_reference)=$File_)
		
		$Txt_reference:=Convert path POSIX to system:C1107("/Users/vdl/Desktop/DEV/")
		$File_:=$Txt_reference+Convert path POSIX to system:C1107("key.mobileapp")
		$Txt_expected:="/"+Convert path POSIX to system:C1107("key.mobileapp")
		
		$t:=doc_Relative_path ($File_;$Txt_reference)
		ASSERT:C1129($t=$Txt_expected)
		
		$t2:=doc_Relative_path ($File_)
		ASSERT:C1129($t2=$File_)
		
		ASSERT:C1129(doc_Absolute_path ($t;$Txt_reference)=$File_)
		
		ASSERT:C1129(doc_Absolute_path ($t)#$File_)
		
	End if 
	
	If (False:C215)  // doc_document
		
		$File_:=Temporary folder:C486+"alias"
		CREATE ALIAS:C694(Structure file:C489;$File_)
		ASSERT:C1129(doc_document (New object:C1471(\
			"action";"isAlias";\
			"path";$File_)).isAlias=True:C214)
		
	End if 
	
	If (False:C215)  // doc_File
		
		$Txt_nullDateTime:=String:C10(!00-00-00!;ISO date GMT:K1:10;?00:00:00?)
		$Dir_resources:=Get 4D folder:C485(Current resources folder:K5:16;*)
		
		$File_:=""
		$Obj_expected:=New object:C1471(\
			"exist";False:C215;\
			"name";"";\
			"extension";"";\
			"fullName";"";\
			"isFolder";False:C215;\
			"isFile";False:C215;\
			"creationDate";$Txt_nullDateTime;\
			"lastModification";$Txt_nullDateTime;\
			"parent";"";\
			"parentFolder";"";\
			"nativePath";"";\
			"path";"";\
			"size";0;\
			"icon";Null:C1517)
		
		ASSERT:C1129(New collection:C1472(doc_File ($File_)).equal(New collection:C1472($Obj_expected)))
		
		$File_:=$Dir_resources+"toto.png"
		$Obj_expected:=New object:C1471(\
			"creationDate";$Txt_nullDateTime;\
			"exist";False:C215;\
			"extension";".png";\
			"fullName";"toto.png";\
			"icon";Null:C1517;\
			"isFile";True:C214;\
			"isFolder";False:C215;\
			"lastModification";$Txt_nullDateTime;\
			"name";"toto";\
			"parent";Convert path system to POSIX:C1106($Dir_resources);\
			"parentFolder";$Dir_resources;\
			"nativePath";$Dir_resources+"toto.png";\
			"path";Convert path system to POSIX:C1106($Dir_resources+"toto.png");\
			"size";0)
		
		ASSERT:C1129(New collection:C1472(doc_File ($File_)).equal(New collection:C1472($Obj_expected)))
		
		$File_:=$Dir_resources
		$Obj_expected:=New object:C1471(\
			"creationDate";$Txt_nullDateTime;\
			"exist";False:C215;\
			"extension";"";\
			"fullName";"Resources";\
			"icon";Null:C1517;\
			"isFile";False:C215;\
			"isFolder";True:C214;\
			"lastModification";$Txt_nullDateTime;\
			"name";"Resources";\
			"parent";Convert path system to POSIX:C1106(Path to object:C1547($Dir_resources).parentFolder);\
			"parentFolder";Path to object:C1547($Dir_resources).parentFolder;\
			"nativePath";$Dir_resources;\
			"path";Convert path system to POSIX:C1106($Dir_resources);\
			"size";0)
		
		ASSERT:C1129(New collection:C1472(doc_File ($File_)).equal(New collection:C1472($Obj_expected)))
		
	End if 
	
	If (False:C215)  // doc_Folder
		
		$Dir_:=""
		$Obj_expected:=New object:C1471(\
			"exist";False:C215;\
			"writable";False:C215;\
			"isFolder";False:C215;\
			"isFile";False:C215;\
			"folders";New collection:C1472;\
			"files";New collection:C1472;\
			"name";"";\
			"extension";"";\
			"fullName";"";\
			"parent";"";\
			"parentFolder";"";\
			"nativePath";"";\
			"path";"")
		
		ASSERT:C1129(New collection:C1472(doc_Folder ($Dir_)).equal(New collection:C1472($Obj_expected)))
		
	End if 
	
	If (False:C215)  // Doc_expandPath
		
		ASSERT:C1129(doc_Expand_path ("$TEMP/")=Temporary folder:C486)
		
		ASSERT:C1129(doc_Expand_path ("$DESKTOP/")=System folder:C487(Desktop:K41:16))
		ASSERT:C1129(doc_Expand_path ("$DOCUMENTS/")=System folder:C487(Documents folder:K41:18))
		ASSERT:C1129(doc_Expand_path ("$APPLICATION/")=System folder:C487(Applications or program files:K41:17))
		ASSERT:C1129(doc_Expand_path ("$PREFERENCES/")=System folder:C487(User preferences_all:K41:3))
		ASSERT:C1129(doc_Expand_path ("$USER_PREFERENCES/")=System folder:C487(User preferences_user:K41:4))
		
		ASSERT:C1129(doc_Expand_path ("$4D/")=Get 4D folder:C485(Active 4D Folder:K5:10))
		ASSERT:C1129(doc_Expand_path ("$RESSOURCES/")=Get 4D folder:C485(Current resources folder:K5:16))
		ASSERT:C1129(doc_Expand_path ("$RESSOURCES_HOST/")=Get 4D folder:C485(Current resources folder:K5:16;*))
		ASSERT:C1129(doc_Expand_path ("$DATA/")=Get 4D folder:C485(Data folder:K5:33;*))
		ASSERT:C1129(doc_Expand_path ("$DATABASE/")=Get 4D folder:C485(Database folder:K5:14))
		ASSERT:C1129(doc_Expand_path ("$DATABASE_HOST/")=Get 4D folder:C485(Database folder:K5:14;*))
		ASSERT:C1129(doc_Expand_path ("$HTML/")=Get 4D folder:C485(HTML Root folder:K5:20))
		ASSERT:C1129(doc_Expand_path ("$HTML_HOST/")=Get 4D folder:C485(HTML Root folder:K5:20;*))
		ASSERT:C1129(doc_Expand_path ("$LICENCES/")=Get 4D folder:C485(Licenses folder:K5:11))
		ASSERT:C1129(doc_Expand_path ("$LOGS/")=Get 4D folder:C485(Logs folder:K5:19))
		ASSERT:C1129(doc_Expand_path ("$LOGS_HOST/")=Get 4D folder:C485(Logs folder:K5:19;*))
		ASSERT:C1129(doc_Expand_path ("$MOBILE/")=Get 4D folder:C485(MobileApps folder:K5:47;*))
		  //ASSERT(doc_Expand_path ("$MOBILE_HOST/")=Get 4D folder(MobileApps folder;*))
		
		ASSERT:C1129(doc_Expand_path ("$TEMP/folder/subfolder/")=(Temporary folder:C486+"folder"+Folder separator:K24:12+"subfolder"+Folder separator:K24:12))
		ASSERT:C1129(doc_Expand_path ("$TEMP/folder/file")=(Temporary folder:C486+"folder"+Folder separator:K24:12+"file"))
		
	End if 
End if 

FINALLY 