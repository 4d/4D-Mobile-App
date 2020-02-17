//%attributes = {"invisible":true}
C_OBJECT:C1216($1)

C_TEXT:C284($t)
C_OBJECT:C1216($file;$menu;$o;$o_infos)

If (False:C215)
	C_OBJECT:C1216(tmpl_CONTEXTUAL ;$1)
End if 

$o_infos:=$1

If ($o_infos#Null:C1517)
	
	$menu:=menu \
		.append("accessTheGithubRepository";"show")\
		.line()\
		.append("downloadTheLatestRevision";"update")
	
	If (Not:C34($o_infos.used))
		
		$menu\
			.line()\
			.append("forgetThisTemplate";"forget")
		
	End if 
	
	$menu.popup()
	
	Case of 
			
			  //______________________________________________________
		: (Not:C34($menu.selected))
			
			  //______________________________________________________
		: ($menu.choice="show")
			
			OPEN URL:C673($o_infos.homepage)
			
			  //______________________________________________________
		: ($menu.choice="update")
			
			$o:=browser_DOWNLOAD (New object:C1471(\
				"url";$o_infos.updateURL;\
				"overwrite";True:C214))
			
			Case of 
					
					  //______________________________________________________
				: ($o.success)
					
					  //______________________________________________________
				: ($o.error=Null:C1517)
					
					  //______________________________________________________
				: ($o.error="cannotResolveAlias")
					
					ALERT:C41(Get localized string:C991("theAliasMobileOriginalCan'tBeFound"))
					
					  //______________________________________________________
				: ($o.error="fileNotFound")
					
					ALERT:C41(Get localized string:C991("fileNotFound'tBeFound"))
					
					  //______________________________________________________
				Else 
					
					ALERT:C41($o.error)
					
					  //______________________________________________________
			End case 
			
			  //______________________________________________________
		: ($menu.choice="forget")
			
			$t:=Split string:C1554($o_infos.updateURL;"/").pop()
			
			Case of 
					
					  //……………………………………………………………………………………
				: ($t="form-list@")
					
					$file:=path .hostlistForms().file($t)
					
					  //……………………………………………………………………………………
				: ($t="form-detail@")
					
					$file:=path .hostdetailForms().file($t)
					
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
			
			ASSERT:C1129(False:C215;"Unmanaged selector: "+$menu.choice)
			
			  //______________________________________________________
	End case 
End if 