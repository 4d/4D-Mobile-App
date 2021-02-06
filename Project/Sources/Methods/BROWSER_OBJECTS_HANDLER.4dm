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
var $formName; $url : Text
var $archive; $e; $folderDestination; $form; $progress : Object
var $c : Collection
var $http : cs:C1710.http

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

//record.info(Current form name+"."+$event.objectName+": "+$event.description)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.objectName="webarea")
		
		$form:=BROWSER_Handler(New object:C1471(\
			"action"; "init"))
		
		Case of 
				
				//………………………………………………………………………………………………………………
			: ($e.code=On Load:K2:1)
				
				//………………………………………………………………………………………………………………
			: ($e.code=On Unload:K2:2)
				
				//………………………………………………………………………………………………………………
			: ($e.code=On Begin URL Loading:K2:45)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($e.code=On URL Resource Loading:K2:46)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($e.code=On End URL Loading:K2:47)
				
				// Mask the spinner
				$form.wait.hide()
				
				//………………………………………………………………………………………………………………
			: ($e.code=On URL Loading Error:K2:48)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($e.code=On URL Filtering:K2:49)\
				 | ($e.code=On URL Loading Error:K2:48)\
				 | ($e.code=On Window Opening Denied:K2:51)
				
				$url:=$form.web.lastFiltered()
				
				$c:=Split string:C1554($url; "/")
				
				Case of 
						
						//______________________________________________________
					: ($c.indexOf("download")#-1)
						
						//https://github.com/4d-for-ios/form-detail-SimpleHeader/releases/download/0.0.1/form-detail-SimpleHeader.zip
						
						$formName:=$c.pop()  // Name of the archive
						
						// Create destination folder if any
						Case of 
								
								//……………………………………………………………………………………
							: ($formName="form-list@")
								
								$folderDestination:=path.hostlistForms(True:C214)
								
								//……………………………………………………………………………………
							: ($formName="form-detail@")
								
								$folderDestination:=path.hostdetailForms(True:C214)
								
								//……………………………………………………………………………………
							: ($formName="formatter-@")
								
								$folderDestination:=path.hostFormatters(True:C214)
								
								//……………………………………………………………………………………
							Else 
								
								TRACE:C157
								
								//……………………………………………………………………………………
						End case 
						
						If ($folderDestination.exists)
							
							$c:=Split string:C1554(Form:C1466.url; "/")
							
							If (Not:C34($folderDestination.file($formName).exists))  // Download
								
								$archive:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($formName)
								
								If ($archive.exists)
									
									$archive.delete()
									
								End if 
								
								$progress:=progress("downloadInProgress").showStop()  // ------ ->
								
								$progress.setMessage($formName).bringToFront()
								
								$http:=cs:C1710.http.new($url)
								$http.setResponseType(Is a document:K24:1; $archive)
								
								If (Not:C34($progress.isStopped()))
									
									$http.get()
									
								End if 
								
								$progress.close()  // ------------------------------------------ <-
								
								If (Not:C34($progress.stopped))
									
									If ($http.success)
										
										$folderDestination:=$archive.copyTo($folderDestination; fk overwrite:K87:5)
										
										Form:C1466.selector:=$c[$c.length-3]
										Form:C1466.form:="/"+$formName
										
										CALL SUBFORM CONTAINER:C1086(-1)
										
									Else 
										
										// ERROR
										CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "hideBrowser")
										
										POST_MESSAGE(New object:C1471(\
											"target"; Current form window:C827; \
											"action"; "show"; \
											"type"; "alert"; \
											"title"; "ERROR"; \
											"additional"; $http.errors.pop(); \
											"okFormula"; Formula:C1597(OBJECT SET VISIBLE:C603(*; "browser"; True:C214))\
											))
										
									End if 
								End if 
								
							Else 
								
								Form:C1466.selector:=$c[$c.length-3]
								Form:C1466.form:="/"+$formName
								
								CALL SUBFORM CONTAINER:C1086(-1)
								
							End if 
							
						Else 
							
							// ERROR
							CALL FORM:C1391(Current form window:C827; "editor_CALLBACK"; "hideBrowser")
							
							If ($folderDestination=Null:C1517)
								
								POST_MESSAGE(New object:C1471(\
									"target"; Current form window:C827; \
									"action"; "show"; \
									"type"; "alert"; \
									"title"; "fileNotFound"; \
									"additional"; "theAliasMobileOriginalCan'tBeFound"\
									))
								
							Else 
								
								POST_MESSAGE(New object:C1471(\
									"target"; Current form window:C827; \
									"action"; "show"; \
									"type"; "alert"; \
									"title"; "fileNotFound"; \
									"additional"; "fileNotFound"\
									))
								
							End if 
						End if 
						
						//______________________________________________________
					Else 
						
						OPEN URL:C673($url; *)
						
						//______________________________________________________
				End case 
				
				//………………………………………………………………………………………………………………
			: ($e.code=On Open External Link:K2:50)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($e.code=On Window Opening Denied:K2:51)
				
				//
				
				//………………………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
				
				//………………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($e.objectName="close")
		
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