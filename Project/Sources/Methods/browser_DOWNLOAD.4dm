//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_OBJECT:C1216($archive;$http;$o_IN;$o_OUT;$oProgress)

If (False:C215)
	C_OBJECT:C1216(browser_DOWNLOAD ;$0)
	C_OBJECT:C1216(browser_DOWNLOAD ;$1)
End if 

$o_IN:=$1

$o_OUT:=New object:C1471(\
"success";False:C215;\
"form";Split string:C1554($o_IN.url;"/").pop())

  // Create destination folder if any
Case of 
		
		  //……………………………………………………………………………………
	: ($o_OUT.form="form-list@")
		
		$o_OUT.folder:=path .hostlistForms(True:C214)
		$o_OUT.selector:="list"
		
		  //……………………………………………………………………………………
	: ($o_OUT.form="form-detail@")
		
		$o_OUT.folder:=path .hostdetailForms(True:C214)
		$o_OUT.selector:="detail"
		
		  //……………………………………………………………………………………
	: ($o_OUT.form="formatter-@")
		
		$o_OUT.folder:=path .hostFormatters(True:C214)
		$o_OUT.selector:="formatter"
		
		  //……………………………………………………………………………………
	Else 
		
		TRACE:C157
		
		  //……………………………………………………………………………………
End case 

If ($o_OUT.folder.exists)
	
	$o_OUT.file:=$o_OUT.folder.file($o_OUT.form)
	
	If (Not:C34($o_OUT.file.exists))\
		 | (Bool:C1537($o_IN.overwrite))  // Download
		
		$archive:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file($o_OUT.form)
		
		If ($archive.exists)
			
			$archive.delete()
			
		End if 
		
		$oProgress:=progress ("downloadInProgress").showStop()  // ------ ->
		
		$oProgress.setMessage($o_OUT.form).bringToFront()
		
		$http:=http ($o_IN.url).get(Is a document:K24:1;False:C215;$archive)
		
		$oProgress.close()  // ------------------------------------------ <-
		
		If (Not:C34($oProgress.stopped))
			
			If ($http.success)
				
				$o_OUT.file:=$archive.copyTo($o_OUT.folder;fk overwrite:K87:5)
				$o_OUT.success:=($o_OUT.file#Null:C1517)
				
			Else 
				
				$o_OUT.error:=$http.errors.pop()
				
			End if 
		End if 
		
	Else 
		
		$o_OUT.success:=True:C214
		
	End if 
	
Else 
	
	$o_OUT.error:=Choose:C955($o_OUT.folder=Null:C1517;"cannotResolveAlias";"fileNotFound")
	
End if 

$0:=$o_OUT