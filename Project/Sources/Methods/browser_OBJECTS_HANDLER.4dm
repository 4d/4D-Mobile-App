//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : BROWSER_OBJECTS_HANDLER
  // ID[5FD48D75EE7A4BF89BFF64B772B9C79B]
  // Created 10-1-2020 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_BOOLEAN:C305($b)
C_LONGINT:C283($end;$l;$start)
C_TEXT:C284($t;$Txt_url;$Txt_me)
C_OBJECT:C1216($archive;$event;$folder;$form;$http)

  // ----------------------------------------------------
  // Initialisations
$Txt_me:=OBJECT Get name:C1087(Object current:K67:2)
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($Txt_me="webarea")
		
		$form:=browser_HANDLER (New object:C1471(\
			"action";"init"))
		
		Case of 
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On Load:K2:1)
				
				$form.web.init()
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On End URL Loading:K2:47)
				
				$form.wait.hide()
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On URL Filtering:K2:49)
				
				$Txt_url:=$form.web.lastFiltered()
				
				Case of 
						
						  //______________________________________________________
					: (Match regex:C1019("(?m-si)/download/([^//]*)\\.zip$";$Txt_url;1;$start;$end))
						
						  //https://github.com/4d-for-ios/form-list-ClientList/releases/latest/download/form-list-ClientList.zip
						
						$l:=Progress New 
						
						Progress SET TITLE ($l;Get localized string:C991("downloadInProgress");-1)
						
						$start:=$start+Length:C16("/download/")
						$t:=Substring:C12($Txt_url;$start;($start+$end)-$start)
						
						Progress SET MESSAGE ($l;$t;True:C214)
						
						$archive:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file($t)
						
						If ($archive.exists)
							
							$archive.delete()
							
						End if 
						
						$http:=http ($Txt_url).get(Is a document:K24:1;False:C215;$archive)
						
						Progress QUIT ($l)
						
						If ($http.success)
							
							$folder:=COMPONENT_Pathname ("host")
							
							If ($folder.name="Resources")
								
								$folder:=$folder.folder("mobile")
								$folder.create()
								
							End if 
							
							Case of 
									
									  //……………………………………………………………………………………
								: ($t="form-list@")
									
									  //$t:=Replace string($t;"form-list-";"")
									$folder:=$folder.folder("form/list")
									
									  //……………………………………………………………………………………
								: ($t="form-detail@")
									
									  //$t:=Replace string($t;"form-detail-";"")
									$folder:=$folder.folder("form/detail")
									
									  //……………………………………………………………………………………
								: ($t="formatter-@")
									
									  //$t:=Replace string($t;"formatter-";"")
									$folder:=$folder.folder("formatters")
									
									  //……………………………………………………………………………………
								Else 
									
									  // https://github.com/4d-for-ios/formatter-Mail/releases/latest/download/formatter-Mail.zip
									
									  //……………………………………………………………………………………
							End case 
							
							$b:=$folder.create()
							
							  //$archive:=ZIP Read archive($archive).root
							  //$folder:=$archive.copyTo($folder;Replace string($t;".zip";"");fk overwrite)
							
							$folder:=$archive.copyTo($folder;fk overwrite:K87:5)
							
						Else 
							
							  // A "If" statement should never omit "Else"
							
						End if 
						
						  //______________________________________________________
					Else 
						
						  // A "Case of" statement should never omit "Else"
						  //______________________________________________________
				End case 
				
				  //………………………………………………………………………………………………………………
			Else 
				
				  // A "Case of" statement should never omit "Else"
				  //………………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($Txt_me="return")
		
		CALL SUBFORM CONTAINER:C1086(-1)
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End