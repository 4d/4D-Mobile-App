//%attributes = {"invisible":true}
#DECLARE($infos : Object)

var $form : Text
var $download : Object
var $file : 4D:C1709.File
var $menu : cs:C1710.menu

If ($infos#Null:C1517)
	$menu:=cs:C1710.menu.new()
	
	If ($infos.homepage#Null:C1517)
		$menu\
			.append("accessTheGithubRepository"; "show")
	End if 
	
	If ($infos.file#Null:C1517)
		
		If ($infos.file.isFile)  // ie. zip
			
			If ($infos.updateURL#Null:C1517)
				$menu\
					.line()\
					.append("downloadTheLatestRevision"; "update")
				// XXX Do not add line if no homepage but update URL (but must not occurs); have an appendWithLine that check if first or not will be cool
			End if 
			
		End if 
	Else   // old code to remove if "file" validated
		If ($infos.updateURL#Null:C1517)
			$menu\
				.line()\
				.append("downloadTheLatestRevision"; "update")
			// XXX Do not add line if no homepage but update URL (but must not occurs); have an appendWithLine that check if first or not will be cool
		End if 
	End if 
	
	If (Not:C34(Bool:C1537($infos.used)))
		
		If ($infos.file#Null:C1517)
			
			If ($infos.file.parent.parent.path=cs:C1710.path.new().hostForms().path)  // ie. host form CLEAN if we have in $infos this info it will be better
				
				$menu\
					.line()\
					.append("forgetThisTemplate"; Choose:C955($infos.file.isFile; "forget"; "forgetFolder"))
				
			End if 
			
		Else   // old code to remove if "file" validated
			$menu\
				.line()\
				.append("forgetThisTemplate"; "forget")
		End if 
	End if 
	
	If ($infos.file#Null:C1517)
		$menu\
			.line()\
			.append("duplicate"; "duplicate")
		
		If ($infos.file.exists)
			
			$menu\
				.line()\
				.append("showOnDisk"; "showOnDisk")
			
			If ($infos.file.isFolder)
				// XXX work only on macOS if installed here (the best is no known if someone could respond to x-github-client://)
				If (Folder:C1567("/Applications/Github Desktop.app").exists)
					$menu\
						.line()\
						.append("openWithGithubDesktop"; "openWithGithubDesktop")  // or "share"
				End if 
			End if 
		End if 
	End if 
	
	$menu.popup()
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			//______________________________________________________
		: ($menu.choice="show")
			
			OPEN URL:C673($infos.homepage)
			
			//______________________________________________________
		: ($menu.choice="showOnDisk")
			
			SHOW ON DISK:C922($infos.file.platformPath)
			
			//______________________________________________________
		: ($menu.choice="openWithGithubDesktop")
			
			// XXX there is no CAN OPEN URL for 4d (on mac I known how to implement it!)
			// or OK=1 if not open to propose to download...
			OPEN URL:C673("x-github-client://openLocalRepo/"+Folder:C1567($infos.file.platformPath; fk platform path:K87:2).path)  // to test on window
			
			//______________________________________________________
		: ($menu.choice="duplicate")
			
			// ask new name
			var $form : Text
			$form:=Request:C163("New template name?")
			If (Length:C16($form)>0)
				// CLEAN: extract code to a class about template? like cs.tmpl (allowing us to make TU) ; but this class do too much things in init
				
				// copy to new folder
				var $destination : 4D:C1709.Folder
				Case of 
					: ($infos.type="listform")  // could also do  cs.path.new()["host"+xx].call() but ase must match
						$destination:=cs:C1710.path.new().hostlistForms()
					: ($infos.type="detailform")
						$destination:=cs:C1710.path.new().hostdetailForms()
					Else 
						ASSERT:C1129(False:C215; "not implemented type "+String:C10($infos.type))
				End case 
				
				Case of 
					: ($destination=Null:C1517)
						// ignore
					: ($destination.folder($form).exists)
						ALERT:C41("A template with same name already exists")
					Else 
						If ($destination#Null:C1517)
							
							$destination.create()
							If ($infos.file.isFile)
								ZIP Read archive:C1637($infos.file).root.copyTo($destination; $form)
							Else 
								$infos.file.copyTo($destination; $form)
							End if 
							// in new folder rename in manifest.json all needed vars
							var $manifest : Object
							$manifest:=JSON Parse:C1218($destination.folder($form).file("manifest.json").getText())
							$manifest.name:=$form
							var $key : Text
							For each ($key; New collection:C1472("homepage"; "updateURL"; "version"; "release"; "organization"; "repository"; "sender"))
								OB REMOVE:C1226($manifest; $key)
							End for each 
							$destination.folder($form).file("manifest.json").setText(JSON Stringify:C1217($manifest; *))
							
							// close form
							CALL SUBFORM CONTAINER:C1086(-2)
							
							// finally show on disk (maybe ask user?)
							SHOW ON DISK:C922($destination.folder($form).platformPath)
							
						End if 
				End case 
			End if 
			
			//______________________________________________________
		: ($menu.choice="update")
			
			$download:=browser_DOWNLOAD(New object:C1471(\
				"url"; $infos.updateURL; \
				"overwrite"; True:C214))
			
			Case of 
					
					//______________________________________________________
				: ($download.success) | ($download.error=Null:C1517)
					
					// <NOTHING MORE TO DO>
					
					//______________________________________________________
				: ($download.error="cannotResolveAlias")
					
					ALERT:C41(Get localized string:C991("theAliasMobileOriginalCan'tBeFound"))
					
					//______________________________________________________
				: ($download.error="fileNotFound")
					
					ALERT:C41(Get localized string:C991("fileNotFound'tBeFound"))
					
					//______________________________________________________
				Else 
					
					ALERT:C41($download.error)
					
					//______________________________________________________
			End case 
			
			//______________________________________________________
		: ($menu.choice="forget")
			
			$form:=Split string:C1554($infos.updateURL; "/").pop()
			
			Case of 
					
					//……………………………………………………………………………………
				: ($form="form-list@")
					
					$file:=cs:C1710.path.new().hostlistForms().file($form)
					
					//……………………………………………………………………………………
				: ($form="form-detail@")
					
					$file:=cs:C1710.path.new().hostdetailForms().file($form)
					
					//……………………………………………………………………………………
				Else 
					
					TRACE:C157
					
					//……………………………………………………………………………………
			End case 
			
			If ($file.exists)
				
				$file.delete()
				
				CALL SUBFORM CONTAINER:C1086(-2)
				
			End if 
			
			
			//______________________________________________________
		: ($menu.choice="forgetFolder")
			
			If ($infos.file.exists)
				
				$infos.file.delete(Delete with contents:K24:24)
				
				CALL SUBFORM CONTAINER:C1086(-2)
				
			End if 
			
			//______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215; "Unmanaged selector: "+$menu.choice)
			
			//______________________________________________________
	End case 
End if 