//%attributes = {}

If (Feature=Null:C1517)
	COMPONENT_INIT
End if 

// MARK: GetFileExtension
ASSERT:C1129(GetFileExtension("")="")
ASSERT:C1129(GetFileExtension("a")="")
ASSERT:C1129(GetFileExtension("a"+Folder separator:K24:12+"b")="")
ASSERT:C1129(GetFileExtension("a"+Folder separator:K24:12+"b"+Folder separator:K24:12)="")
ASSERT:C1129(GetFileExtension("a.c"+Folder separator:K24:12+"b")="")
ASSERT:C1129(GetFileExtension("a.e")=".e")
ASSERT:C1129(GetFileExtension("a.e"+Folder separator:K24:12+"")=".e")
ASSERT:C1129(GetFileExtension("a.c"+Folder separator:K24:12+"b.e")=".e")
ASSERT:C1129(GetFileExtension("a.c"+Folder separator:K24:12+"b.e"+Folder separator:K24:12+"")=".e")

ASSERT:C1129(GetFileExtension(""; fk posix path:K87:1)="")
ASSERT:C1129(GetFileExtension("a"+"/"+"b"; fk posix path:K87:1)="")
ASSERT:C1129(GetFileExtension("a"+"/"+"b"+"/"; fk posix path:K87:1)="")
ASSERT:C1129(GetFileExtension("a.c"+"/"+"b"; fk posix path:K87:1)="")
ASSERT:C1129(GetFileExtension("a.e"; fk posix path:K87:1)=".e")
ASSERT:C1129(GetFileExtension("a.e"+"/"+""; fk posix path:K87:1)=".e")
ASSERT:C1129(GetFileExtension("a.c"+"/"+"b.e"; fk posix path:K87:1)=".e")
ASSERT:C1129(GetFileExtension("a.c"+"/"+"b.e"+"/"+""; fk posix path:K87:1)=".e")

// MARK: GetFileName
ASSERT:C1129(GetFileName("")="")
//ASSERT(GetFileName("a")="a") // not valid path (platform path start with some metadata and folder sep)
//ASSERT(GetFileName("a.e")="a") // not valid path (platform path start with some metadata and folder sep)
//ASSERT(GetFileName("a.e"+Folder separator+"")="a") // not valid path (platform path start with some metadata and folder sep)
ASSERT:C1129(GetFileName("a"+Folder separator:K24:12+"b")="b")
ASSERT:C1129(GetFileName("a"+Folder separator:K24:12+"b"+Folder separator:K24:12)="b")
ASSERT:C1129(GetFileName("a.c"+Folder separator:K24:12+"b")="b")
ASSERT:C1129(GetFileName("a.c"+Folder separator:K24:12+"b.e")="b")
ASSERT:C1129(GetFileName("a.c"+Folder separator:K24:12+"b.e"+Folder separator:K24:12+"")="b")

ASSERT:C1129(GetFileName(""; fk posix path:K87:1)="")
ASSERT:C1129(GetFileName("/a"; fk posix path:K87:1)="a")
ASSERT:C1129(GetFileName("a"+"/"+"b"; fk posix path:K87:1)="b")
ASSERT:C1129(GetFileName("a"+"/"+"b"+"/"; fk posix path:K87:1)="b")
ASSERT:C1129(GetFileName("a.c"+"/"+"b"; fk posix path:K87:1)="b")
ASSERT:C1129(GetFileName("/a.e"; fk posix path:K87:1)="a")
ASSERT:C1129(GetFileName("/a.e"+"/"+""; fk posix path:K87:1)="a")
ASSERT:C1129(GetFileName("a.c"+"/"+"b.e"; fk posix path:K87:1)="b")
ASSERT:C1129(GetFileName("a.c"+"/"+"b.e"+"/"+""; fk posix path:K87:1)="b")