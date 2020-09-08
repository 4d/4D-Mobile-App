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
C_TEXT:C284($t; $tForm; $tURL)
C_OBJECT:C1216($archive; $event; $folderDestination; $form; $http; $oProgress)
C_COLLECTION:C1488($c)

// ----------------------------------------------------
// Initialisations
$event:=FORM Event:C1606

//record.info(Current form name+"."+$event.objectName+": "+$event.description)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($event.objectName="webarea")
		
		$form:=BROWSER_Handler(New object:C1471(\
			"action"; "init"))
		
		Case of 
				
				//………………………………………………………………………………………………………………
			: ($event.code=On Load:K2:1)
				
				//………………………………………………………………………………………………………………
			: ($event.code=On Unload:K2:2)
				
				//………………………………………………………………………………………………………………
			: ($event.code=On Begin URL Loading:K2:45)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($event.code=On URL Resource Loading:K2:46)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($event.code=On End URL Loading:K2:47)
				
				// Mask the spinner
				$form.wait.hide()
				
				//………………………………………………………………………………………………………………
			: ($event.code=On URL Loading Error:K2:48)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($event.code=On URL Filtering:K2:49)\
				 | ($event.code=On URL Loading Error:K2:48)\
				 | ($event.code=On Window Opening Denied:K2:51)
				
				$tURL:=$form.web.lastFiltered()
				
				$c:=Split string:C1554($tURL; "/")
				
				Case of 
						
						//______________________________________________________
					: ($c.indexOf("download")#-1)
						
						//https://github.com/4d-for-ios/form-detail-SimpleHeader/releases/download/0.0.1/form-detail-SimpleHeader.zip
						
						$tForm:=$c.pop()  // Name of the archive
						
						// Create destination folder if any
						Case of 
								
								//……………………………………………………………………………………
							: ($tForm="form-list@")
								
								$folderDestination:=path.hostlistForms(True:C214)
								
								//……………………………………………………………………………………
							: ($tForm="form-detail@")
								
								$folderDestination:=path.hostdetailForms(True:C214)
								
								//……………………………………………………………………………………
							: ($tForm="formatter-@")
								
								$folderDestination:=path.hostFormatters(True:C214)
								
								//……………………………………………………………………………………
							Else 
								
								TRACE:C157
								
								//……………………………………………………………………………………
						End case 
						
						If ($folderDestination.exists)
							
							$c:=Split string:C1554(Form:C1466.url; "/")
							
							If (Not:C34($folderDestination.file($tForm).exists))  // Download
								
								$archive:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file($tForm)
								
								If ($archive.exists)
									
									$archive.delete()
									
								End if 
								
								$oProgress:=progress("downloadInProgress").showStop()  // ------ ->
								
								$oProgress.setMessage($tForm).bringToFront()
								
								$http:=http($tURL).get(Is a document:K24:1; False:C215; $archive)
								
								$oProgress.close()  // ------------------------------------------ <-
								
								If (Not:C34($oProgress.stopped))
									
									If ($http.success)
										
										$folderDestination:=$archive.copyTo($folderDestination; fk overwrite:K87:5)
										
										Form:C1466.selector:=$c[$c.length-3]
										Form:C1466.form:="/"+$tForm
										
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
								Form:C1466.form:="/"+$tForm
								
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
						
						OPEN URL:C673($tURL; *)
						
						//______________________________________________________
				End case 
				
				//………………………………………………………………………………………………………………
			: ($event.code=On Open External Link:K2:50)
				
				//
				
				//………………………………………………………………………………………………………………
			: ($event.code=On Window Opening Denied:K2:51)
				
				//
				
				//………………………………………………………………………………………………………………
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$event.description+")")
				
				//………………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($event.objectName="close")
		
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