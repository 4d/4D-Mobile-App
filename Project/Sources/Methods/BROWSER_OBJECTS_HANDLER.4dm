//%attributes = {"invisible":true}
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
C_LONGINT:C283($end;$start)
C_TEXT:C284($t;$tURL)
C_OBJECT:C1216($archive;$event;$folder;$form;$http;$oProgress)

  // ----------------------------------------------------
  // Initialisations
$event:=FORM Event:C1606

  // ----------------------------------------------------
Case of 
		
		  //______________________________________________________
	: ($event.objectName="webarea")
		
		$form:=BROWSER_Handler (New object:C1471(\
			"action";"init"))
		
		Case of 
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On Load:K2:1)
				
				$form.web.init()
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On End URL Loading:K2:47)
				
				$form.wait.hide()  // Mask the spinner
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On URL Filtering:K2:49)
				
				$tURL:=$form.web.lastFiltered()
				
				Case of 
						
						  //______________________________________________________
					: (Match regex:C1019("(?m-si)/download/([^//]*)\\.zip$";$tURL;1;$start;$end))
						
						  //https://github.com/4d-for-ios/form-list-ClientList/releases/latest/download/form-list-ClientList.zip
						
						$oProgress:=progress ("downloadInProgress").showStop()  // ------ ->
						
						$start:=$start+Length:C16("/download/")
						$t:=Substring:C12($tURL;$start;($start+$end)-$start)
						$oProgress.setMessage($t).bringToFront()
						
						$archive:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file($t)
						
						If ($archive.exists)
							
							$archive.delete()
							
						End if 
						
						$http:=http ($tURL).get(Is a document:K24:1;False:C215;$archive)
						
						$oProgress.close()  // ------------------------------------------ <-
						
						If (Not:C34($oProgress.stopped))
							
							If ($http.success)
								
								Case of 
										
										  //……………………………………………………………………………………
									: ($t="form-list@")
										
										$folder:=path .hostListForms(True:C214)
										
										  //……………………………………………………………………………………
									: ($t="form-detail@")
										
										$folder:=path .hostDetailForms(True:C214)
										
										  //……………………………………………………………………………………
									: ($t="formatter-@")
										
										$folder:=path .hostFormatters(True:C214)
										
										  //……………………………………………………………………………………
									Else 
										
										TRACE:C157
										
										  //……………………………………………………………………………………
								End case 
								
								If ($folder.exists)
									
									$folder:=$archive.copyTo($folder;fk overwrite:K87:5)
									
								Else 
									
									  // ERROR
									CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"hideBrowser")
									
									If ($folder=Null:C1517)
										
										POST_FORM_MESSAGE (New object:C1471(\
											"target";Current form window:C827;\
											"action";"show";\
											"type";"alert";\
											"title";"fileNotFound";\
											"additional";"theAliasMobileOriginalCan'tBeFound"\
											))
										
									Else 
										
										POST_FORM_MESSAGE (New object:C1471(\
											"target";Current form window:C827;\
											"action";"show";\
											"type";"alert";\
											"title";"fileNotFound";\
											"additional";"fileNotFound"\
											))
										
									End if 
								End if 
								
							Else 
								
								  // ERROR
								CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"hideBrowser")
								
								POST_FORM_MESSAGE (New object:C1471(\
									"target";Current form window:C827;\
									"action";"show";\
									"type";"alert";\
									"title";"ERROR";\
									"additional";$http.errors.pop();\
									"okFormula";Formula:C1597(OBJECT SET VISIBLE:C603(*;"browser";True:C214))\
									))
								
							End if 
						End if 
						
						  //______________________________________________________
					Else 
						
						  // <NOTHING MORE TO DO>
						
						  //WA OPEN URL("https://4d-for-ios.github.io/gallery/#/data/formatter")
						
						  //______________________________________________________
				End case 
				
				  //………………………………………………………………………………………………………………
			Else 
				
				  // A "Case of" statement should never omit "Else"
				  //………………………………………………………………………………………………………………
		End case 
		
		  //______________________________________________________
	: ($event.objectName="return")
		
		CALL SUBFORM CONTAINER:C1086(-1)
		
		  //______________________________________________________
	Else 
		
		TRACE:C157
		
		  //______________________________________________________
End case 

  // ----------------------------------------------------
  // Return
  // <NONE>
  // ----------------------------------------------------
  // End