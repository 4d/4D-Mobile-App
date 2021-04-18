//%attributes = {"invisible":true}
#DECLARE($in : Object)->$out : Object

var $archive : Object
var $http : cs:C1710.http
var $progress : cs:C1710.progress

$out:=New object:C1471(\
"success"; False:C215; \
"form"; Split string:C1554($in.url; "/").pop())

// Create destination folder if any
Case of 
		
		//……………………………………………………………………………………
	: ($out.form="form-list@")
		
		$out.folder:=cs:C1710.path.new().hostlistForms(True:C214)
		$out.selector:="list"
		
		//……………………………………………………………………………………
	: ($out.form="form-detail@")
		
		$out.folder:=cs:C1710.path.new().hostdetailForms(True:C214)
		$out.selector:="detail"
		
		//……………………………………………………………………………………
	: ($out.form="formatter-@")
		
		$out.folder:=cs:C1710.path.new().hostFormatters(True:C214)
		$out.selector:="formatter"
		
		//……………………………………………………………………………………
	Else 
		
		TRACE:C157
		
		//……………………………………………………………………………………
End case 

If ($out.folder.exists)
	
	$out.file:=$out.folder.file($out.form)
	
	If (Not:C34($out.file.exists))\
		 | (Bool:C1537($in.overwrite))  // Download
		
		$archive:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($out.form)
		
		If ($archive.exists)
			
			$archive.delete()
			
		End if 
		
		$progress:=cs:C1710.progress.new("downloadInProgress")\
			.showStop()\
			.setMessage($out.form)\
			.bringToFront()  // ------ ->
		
		$http:=cs:C1710.http.new($in.url)
		$http.setResponseType(Is a document:K24:1; $archive)
		
		If (Not:C34($progress.isStopped()))
			
			$http.get()
			
		End if 
		
		$progress.close()  // ------------------------------------------ <-
		
		If (Not:C34($progress.stopped))
			
			If ($http.success)
				
				$out.file:=$archive.copyTo($out.folder; fk overwrite:K87:5)
				$out.success:=($out.file#Null:C1517)
				
				If ($out.success)
					
					
					
					
				End if 
				
			Else 
				
				$out.error:=$http.errors.pop()
				
			End if 
		End if 
		
	Else 
		
		$out.success:=True:C214
		
	End if 
	
Else 
	
	$out.error:=Choose:C955($out.folder=Null:C1517; "cannotResolveAlias"; "fileNotFound")
	
End if 

$0:=$out