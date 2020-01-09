//%attributes = {"invisible":true}
C_BOOLEAN:C305($b)
C_LONGINT:C283($end;$start)
C_TEXT:C284($t;$Txt_url;$Txt_widget)
C_OBJECT:C1216($archive;$event;$folder;$http)

$Txt_widget:=OBJECT Get name:C1087(Object current:K67:2)

Case of 
		  //______________________________________________________
	: ($Txt_widget="webarea")
		
		$event:=FORM Event:C1606
		
		Case of 
				  //………………………………………………………………………………………………………………
			: ($event.code=On Load:K2:1)
				
				ARRAY TEXT:C222($tTxt_url;0x0000)
				ARRAY BOOLEAN:C223($tBoo_allow;0x0000)
				
				  //All are forbidden
				APPEND TO ARRAY:C911($tTxt_url;"*")  //all
				APPEND TO ARRAY:C911($tBoo_allow;False:C215)  //forbidden
				
				  //Allow WA SET PAGE CONTENT
				APPEND TO ARRAY:C911($tTxt_url;"file*")
				APPEND TO ARRAY:C911($tBoo_allow;True:C214)  // to allow including HTML files
				
				WA SET URL FILTERS:C1030(*;$Txt_widget;$tTxt_url;$tBoo_allow)
				
				WA SET PREFERENCE:C1041(*;$Txt_widget;WA enable Java applets:K62:3;False:C215)
				WA SET PREFERENCE:C1041(*;$Txt_widget;WA enable JavaScript:K62:4;True:C214)
				WA SET PREFERENCE:C1041(*;$Txt_widget;WA enable plugins:K62:5;False:C215)  //
				
				  //Active the contextual menu in debug mode
				WA SET PREFERENCE:C1041(*;$Txt_widget;WA enable contextual menu:K62:6;Not:C34(Is compiled mode:C492) | (Structure file:C489=Structure file:C489(*)))
				WA SET PREFERENCE:C1041(*;$Txt_widget;WA enable Web inspector:K62:7;True:C214)
				
				  //………………………………………………………………………………………………………………
			: ($event.code=On URL Filtering:K2:49)
				
				$Txt_url:=WA Get last filtered URL:C1035(*;$Txt_widget)
				
				Case of 
						
						  //______________________________________________________
					: (Match regex:C1019("(?m-si)/download/(.*)\\.zip";$Txt_url;1;$start;$end))
						
						  //https://github.com/4d-for-ios/form-list-ClientList/releases/latest/download/form-list-ClientList.zip
						$start:=$start+10
						$t:=Substring:C12($Txt_url;$start;($start+$end)-$start)
						$archive:=Folder:C1567(Temporary folder:C486;fk platform path:K87:2).file($t)
						
						If ($archive.exists)
							
							$archive.delete()
							
						End if 
						
						$http:=http ($Txt_url).get(Is a document:K24:1;False:C215;$archive)
						
						If ($http.success)
							
							$folder:=COMPONENT_Pathname ("host")
							
							If (Not:C34($folder.exists))
								
								$folder:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16;*);fk platform path:K87:2).folder("mobile")
								$folder.create()
								
							End if 
							
							Case of 
									  //……………………………………………………………………………………
								: ($t="form-list@")
									
									$t:=Replace string:C233($t;"form-list-";"")
									$folder:=$folder.folder("form/list")
									
									  //……………………………………………………………………………………
								: ($t="form-detail@")
									
									$t:=Replace string:C233($t;"form-detail-";"")
									$folder:=$folder.folder("form/detail")
									
									  //……………………………………………………………………………………
								Else 
									
									  // A "Case of" statement should never omit "Else"
									
									  //……………………………………………………………………………………
							End case 
							
							$b:=$folder.create()
							
							$archive:=ZIP Read archive:C1637($archive).root
							$folder:=$archive.copyTo($folder;Replace string:C233($t;".zip";"");fk overwrite:K87:5)
							
						Else 
							
							  // A "If" statement should never omit "Else"
							
						End if 
						
						  //______________________________________________________
					: (False:C215)
						
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
	: ($Txt_widget="return")
		
		
		CALL SUBFORM CONTAINER:C1086(-1)
		
		  //______________________________________________________
	: (False:C215)
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		
		  //______________________________________________________
End case 