// ----------------------------------------------------
// Object method : RIBBON.151 (Build & Run button)
// ID[B7D612925297469AAD7F6709D491ED2E]
// Created 19-11-2020 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $bottom; $left; $right; $top : Integer
var $device; $e : Object
var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$e:=FORM Event:C1606

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($e.code=On Mouse Enter:K2:33)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Mouse Leave:K2:34)
		
		RIBBON(Num:C11($e.objectName))
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		// Autosave
		PROJECT.save()
		
		If (FEATURE.with("android"))
			
			If (Is Windows:C1573)
				
				If (Form:C1466.currentDevice#Null:C1517)
					
					$device:=Form:C1466.devices.android.query("udid = :1"; Form:C1466.currentDevice).pop()
					
				End if 
				
				If ($device#Null:C1517)
					
					PROJECT._simulator:=$device.udid
					PROJECT._buildTarget:="android"
					CALL SUBFORM CONTAINER:C1086(-151)
					
				Else 
					
					POST_MESSAGE(New object:C1471(\
						"target"; Form:C1466.editor.$mainWindow; \
						"action"; "show"; \
						"type"; "alert"; \
						"title"; "youMustFirstSelectASimulator"))
					
				End if 
				
			Else 
				
				If (Form:C1466.currentDevice#Null:C1517)
					
					$device:=Form:C1466.devices.apple.query("udid = :1"; Form:C1466.currentDevice).pop()
					
				End if 
				
				If ($device#Null:C1517)
					
					PROJECT._simulator:=$device.udid
					PROJECT._buildTarget:="ios"
					CALL SUBFORM CONTAINER:C1086(-151)
					
				Else 
					
					If (Form:C1466.currentDevice#Null:C1517)
						
						$device:=Form:C1466.devices.android.query("udid = :1"; Form:C1466.currentDevice).pop()
						
					End if 
					
					If ($device#Null:C1517)
						
						PROJECT._simulator:=$device.udid
						PROJECT._buildTarget:="android"
						CALL SUBFORM CONTAINER:C1086(-151)
						
					Else 
						
						POST_MESSAGE(New object:C1471(\
							"target"; Form:C1466.editor.$mainWindow; \
							"action"; "show"; \
							"type"; "alert"; \
							"title"; "youMustFirstSelectASimulator"))
						
					End if 
				End if 
			End if 
			
		Else 
			
			CALL SUBFORM CONTAINER:C1086(-151)
			
		End if 
		
		//______________________________________________________
		
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+$e.description+")")
		
		//______________________________________________________
End case 