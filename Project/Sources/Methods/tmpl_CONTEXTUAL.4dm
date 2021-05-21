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
	
	If ($infos.updateURL#Null:C1517)
		$menu\
			.line()\
			.append("downloadTheLatestRevision"; "update")
		// XXX Do not add line if no homepage but update URL (but must not occurs); have an appendWithLine that check if first or not will be cool
	End if 
	
	If (Not:C34($infos.used))
		
		$menu\
			.line()\
			.append("forgetThisTemplate"; "forget")
		
	End if 
	
	If ($infos.file#Null:C1517)
		If ($infos.file.exists)
			
			$menu\
				.line()\
				.append("showOnDisk"; "showOnDisk")
			
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
		Else 
			
			ASSERT:C1129(False:C215; "Unmanaged selector: "+$menu.choice)
			
			//______________________________________________________
	End case 
End if 