var $url : Text
$url:="https://github.com/4d/4D-Mobile-App/releases/latest/download/4D.Mobile.App.4dbase.zip"

var $response : Object
$response:=4D.HTTPRequest.new($url).wait().response

If ($response.status=200)
	
	var $archiveFile : 4D.File
	$archiveFile:=Folder(fk database folder).folder("Components").file("4D.Mobile.App.4dbase.zip")
	$archiveFile.setContent($response.body)
	
	var $archive : 4D.ZipArchive
	$archive:=ZIP Read archive($archiveFile)
	var $archiveFolder : 4D.ZipFolder
	$archiveFolder:=$archive.root
	If ($archiveFolder.folder("4D Mobile App.4dbase").exists)
		$archiveFolder:=$archiveFolder.folder("4D Mobile App.4dbase")
	End if 
	$archiveFolder.copyTo(Folder(fk database folder).folder("Components"); "4D Mobile App.4dbase")
	$archive:=Null
	$archiveFolder:=Null
	
	$archiveFile.delete()
	
	RESTART 4D
Else 
	ALERT("Cannot download from latest release")
End if 
