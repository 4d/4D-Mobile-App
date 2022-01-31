//%attributes = {}
#DECLARE($folder : 4D:C1709.Folder; $destination : 4D:C1709.Folder)

var $children : Object/* File & Folder*/

If (Not:C34($destination.exists))
	$destination.create()
End if 

For each ($children; $folder.folders())
	folder_copyMerge($children; $destination.folder($folder.fullName))
End for each 

For each ($children; $folder.files())
	$children.copyTo($destination.folder($folder.fullName); fk overwrite:K87:5)
End for each 