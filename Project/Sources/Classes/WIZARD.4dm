Class extends form

// === === === === === === === === === === === === === === === === === === === === ===
Class constructor($wizard : Text; $method : Text)
	
	Super:C1705($method)
	
	This:C1470.OPEN:=($wizard="WIZARD_OPEN_PROJECT")
	This:C1470.NEW:=($wizard="WIZARD_NEW_PROJECT")
	
	This:C1470.init()
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Design definition
Function init()
	
	Case of 
			
			//______________________________________________________
		: (This:C1470.OPEN)
			
			This:C1470.button("browse").bestSize(Align left:K42:2)
			This:C1470.button("open").bestSize(Align right:K42:4; 70).disable()
			
			This:C1470.formObject("focus")
			This:C1470.button("up")
			This:C1470.button("down")
			
			This:C1470.centered:=cs:C1710.group.new("list,open,separator")
			This:C1470.leftAlign:=cs:C1710.group.new("list,browse")
			
			This:C1470.centered.centerVertically()
			This:C1470.leftAlign.alignLeft()
			
			This:C1470.listbox("list").setScrollbars(0; 2)
			
			If (Form:C1466._projects.length=0)
				
				cs:C1710.button.new("up").disable()
				cs:C1710.button.new("down").disable()
				
			Else 
				
				This:C1470.list.select(1)
				
			End if 
			
			This:C1470.appendEvents(On Scroll:K2:57)
			
			//______________________________________________________
		: (This:C1470.NEW)
			
			This:C1470.subform("message").setValue(New object:C1471)
			This:C1470.subform("newProject").setValue(Form:C1466)  // Pass the baby 🤣
			This:C1470.button("continue").bestSize(Align center:K42:3; 70)
			
			This:C1470.centered:=cs:C1710.group.new("list,continue,newProject,message")
			
			If (Is Windows:C1573)
				
				This:C1470.newProject.moveAndResizeVertically(50; -90)
				This:C1470.listbox("list")
				This:C1470.list.resizeVertically(50).setRowsHeight(5; lk lines:K53:23)
				
			End if 
			
			This:C1470.newProject.show()
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
	/// Events handler
Function handleEvents($e : Object)
	
	var $icon : Picture
	var $i : Integer
	var $item : Text
	var $c : Collection
	var $medias : 4D:C1709.Folder
	var $template : cs:C1710.str
	
	$e:=$e || FORM Event:C1606
	
	If ($e.objectName=Null:C1517)  // <== FORM METHOD
		
		Case of 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: ($e.code=On Load:K2:1)
				
				UI:=cs:C1710.EDITOR.new()
				
				Case of 
						
						//======================================
					: (This:C1470.OPEN)
						
						//
						
						//======================================
					: (This:C1470.NEW)
						
						// Populate the message list
						If (Is macOS:C1572)
							
							$template:=cs:C1710.str.new("<span style='color:dimgray'><span style='font-size: 14pt;font-weight: bold'>"\
								+"{title}"\
								+"</span>"\
								+"<br/>"\
								+"<span style='font-size: 13pt;font-weight: normal'>"\
								+"{description}"\
								+"</span></span>")
							
						Else 
							
							$template:=cs:C1710.str.new("<span style='color:dimgray'><span style='font-size: 13pt;font-weight: bold'>"\
								+"{title}"\
								+"</span>"\
								+"<br/>"\
								+"<span style='font-size: 12pt;font-weight: normal'>"\
								+"{description}"\
								+"</span></span>")
							
						End if 
						
						Form:C1466._list:=New collection:C1472
						
						$medias:=Folder:C1567("/RESOURCES/images/welcome/")
						
						If (UI.darkScheme)
							
							$c:=New collection:C1472("structure-dark.png"; "design-dark.png"; "generateAndTest-dark.png"; "deploy-dark.png")
							
						Else 
							
							$c:=New collection:C1472("structure.png"; "design.png"; "generateAndTest.png"; "deploy.png")
							
						End if 
						
						For each ($item; $c)
							
							$i:=$i+1
							READ PICTURE FILE:C678($medias.file($item).platformPath; $icon)
							
							If ($i<3)
								
								$item:=$template.localized(New collection:C1472("wel_title_"+String:C10($i); "wel_description_"+String:C10($i)))
								
							Else 
								
								$item:=$template.localized(New collection:C1472("wel_title_"+String:C10($i); "wel_description_"+String:C10($i)+"2"))
								
							End if 
							
							Form:C1466._list.push(New object:C1471(\
								"icon"; $icon; \
								"text"; $item))
							
						End for each 
						
						//======================================
				End case 
				
				SET TIMER:C645(-1)
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: ($e.code=On Timer:K2:25)
				
				SET TIMER:C645(0)
				
				Case of 
						
						//======================================
					: (This:C1470.OPEN)
						
						If (Form:C1466._index#0)
							
							This:C1470.focus.setCoordinates(This:C1470.list.rowCoordinates(Form:C1466._index)).show()
							This:C1470.open.enable()
							
						Else 
							
							This:C1470.focus.hide()
							This:C1470.open.disable()
							
						End if 
						
						//======================================
					: (This:C1470.NEW)
						
						This:C1470.newProject.focus()
						This:C1470.centered.centerVertically()
						
						//======================================
				End case 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: ($e.code=On Resize:K2:27)
				
				This:C1470.centered.centerVertically()
				
				If (This:C1470.OPEN)
					
					This:C1470.leftAlign.alignLeft()
					
					If (Form:C1466._index#0)
						
						This:C1470.focus.setCoordinates(This:C1470.list.rowCoordinates(Form:C1466._index)).show()
						
					End if 
				End if 
				
				//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
			: ($e.code=On Close Box:K2:21)
				
				UI.callWorker(Formula:C1597(killWorker).source)
				
				CANCEL:C270
				
				//______________________________________________________
		End case 
		
	Else   // <== WIDGETS METHOD
		
		Case of 
				
				//======================================
			: (This:C1470.OPEN)
				
				This:C1470.openObjectHandleEvents($e)
				
				//======================================
			: (This:C1470.NEW)
				
				This:C1470.newObjectHandleEvents($e)
				
				//======================================
		End case 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function openObjectHandleEvents($e : Object)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.list.catch())
			
			Case of 
					
					//==============================================
				: ($e.code=On Double Clicked:K2:5)
					
					If (Form:C1466._current#Null:C1517)
						
						ACCEPT:C269
						
					End if 
					
					//==============================================
				: ($e.code=On Clicked:K2:4)
					
					SET TIMER:C645(-1)
					
					//==============================================
				: ($e.code=On Scroll:K2:57)
					
					If (Form:C1466._index#0)
						
						This:C1470.focus.setCoordinates(This:C1470.list.rowCoordinates(Form:C1466._index)).show()
						
					End if 
					
					//==============================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.up.catch())
			
			If (Form:C1466._index>1)
				
				This:C1470.list.select(Form:C1466._index-1)
				
			Else 
				
				This:C1470.list.select(Form:C1466._projects.length)
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.down.catch())
			
			If (Form:C1466._index<Form:C1466._projects.length)
				
				This:C1470.list.select(Form:C1466._index+1)
				
			Else 
				
				This:C1470.list.select(1)
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.browse.catch())
			
			$e.document:=Select document:C905(UI.path.projects().platformPath; SHARED.extension; Get localized string:C991("selectTheProjectToOpen"); Package open:K24:8+Use sheet window:K24:11)
			
			If (Bool:C1537(OK))
				
				Form:C1466.file:=File:C1566(DOCUMENT; fk platform path:K87:2)
				Form:C1466.folder:=Form:C1466.file.parent
				Form:C1466.$name:=Form:C1466.folder.fullName
				
				Form:C1466.project:=DOCUMENT
				
				ACCEPT:C269
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function newObjectHandleEvents($e : Object)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: (This:C1470.continue.catch())
			
			If (Length:C16(Form:C1466.$name)=0)
				
				DO_MESSAGE(New object:C1471(\
					"action"; "show"; \
					"type"; "alert"; \
					"title"; "theProjectNameCanNotBeEmpty"); This:C1470.message)
				
				This:C1470.newProject.focus()
				
			Else 
				
				Form:C1466.folder:=cs:C1710.path.new().projects(True:C214).folder(Form:C1466.$name)
				
				If (Not:C34(Form:C1466.folder.exists))
					
					ACCEPT:C269
					
				Else 
					
					DO_MESSAGE(New object:C1471(\
						"action"; "show"; \
						"type"; "confirm"; \
						"title"; "thisProjectAlreadyExist"); This:C1470.message)
					
				End if 
			End if 
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === ===
Function messageHandleEvents($e : Object)
	
	var $offset : Integer
	var $coordinates; $data; $ƒ : Object
	var $widget : cs:C1710.subform
	
	$e:=$e || FORM Event:C1606
	
	$widget:=This:C1470.message
	$data:=$widget.getValue()
	$ƒ:=$data.ƒ
	
	Case of 
			
			//…………………………………………………………………………………………………
		: ($e.code=-2)\
			 | ($e.code=-1)  // Close
			
			If ($data.accept)
				
				ACCEPT:C269
				
			Else 
				
				GOTO OBJECT:C206(*; "newProject")
				
			End if 
			
			OBJECT SET VISIBLE:C603(*; "message@"; False:C215)
			
			$ƒ.restore($data)
			
			// Restore original size
			$widget.setDimensions($ƒ.width; $ƒ.height)
			
			//…………………………………………………………………………………………………
		: ($e.code=-8858)  // Resize
			
			$coordinates:=$widget.getCoordinates()
			$coordinates.bottom:=$coordinates.bottom+$ƒ.offset
			
			// Limit to the window's height
			$offset:=$widget.getParentDimensions().height-$coordinates.bottom-20
			
			If ($offset<0)
				
				$coordinates.bottom:=$coordinates.bottom+$offset
				$ƒ.background.coordinates.bottom:=$ƒ.background.coordinates.bottom+$offset
				$ƒ.additional.coordinates.bottom:=$ƒ.additional.coordinates.bottom+$offset
				$ƒ.offset:=$ƒ.offset+$offset
				$ƒ.scrollbar:=True:C214
				
			Else 
				
				$ƒ.scrollbar:=False:C215
				
			End if 
			
			$widget.setCoordinates($coordinates)
			$ƒ.update($data)
			
			//…………………………………………………………………………………………………
	End case 