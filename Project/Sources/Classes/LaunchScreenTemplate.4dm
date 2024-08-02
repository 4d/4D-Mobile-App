Class extends Template

Class constructor($value : Object)
	Super:C1705($value)
	ASSERT:C1129(This:C1470.template.type="ls")
	
Function doRun()->$result : Object
	$result:=Super:C1706.doRun()  // copy files
	$result:=ob_deepMerge($result)
	
Function generateAssets()->$Obj_out : Object
	var $assetFolder : 4D:C1709.Folder
	var $file : 4D:C1709.File
	var $Obj_in; $Obj_template; $o : Object
	
	$Obj_out:=New object:C1471()
	$Obj_in:=This:C1470.input
	$Obj_template:=This:C1470.template
	
	// Specific code for launch screen
	If (Value type:C1509($Obj_template.assets)=Is object:K8:27)
		
		ASSERT:C1129(String:C10($Obj_template.parent.assets.source)#"")  // Suppose main template is parent, to get app icon
		
		$Obj_out.assets:=New object:C1471
		
		ARRAY TEXT:C222($tTxt_keys; 0x0000)
		OB GET PROPERTY NAMES:C1232($Obj_template.assets; $tTxt_keys)
		
		var $i : Integer
		For ($i; 1; Size of array:C274($tTxt_keys); 1)
			
			
			// Hardcoding image path (maybe could do better)
			Case of 
					
					//________________________________________
				: ($tTxt_keys{$i}="center")
					
					$assetFolder:=FolderFrom($Obj_template.parent.assets.source)
					
					// Temporary or by default take app icon, later could be customizable by UI, and must be managed like AppIcon
					For each ($file; New collection:C1472(\
						$assetFolder.parent.file("app_icon.png"); \
						$assetFolder.file("AppIcon.appiconset/universal1024.png"); \
						$assetFolder.file("AppIcon.appiconset/ios-marketing1024.png")))
						If ($file.exists)
							break
						End if 
					End for each 
					
					//________________________________________
				: ($tTxt_keys{$i}="background")
					
					$file:=Folder:C1567(fk resources folder:K87:11).folder("images").file("monochrome.svg")
					
					// Inject color on background if defined
					If ((Bool:C1537(SHARED.launchScreen.useThemeColor))\
						 & (Value type:C1509($Obj_in.theme.BackgroundColor)=Is object:K8:27))
						
						$o:=colors(New object:C1471(\
							"action"; "rgbtohex"; \
							"color"; $Obj_in.theme.BackgroundColor\
							))
						
						If ($o.success)
							
							$Obj_in.tags.launchScreenBackgroundColor:=$o.value
							
						End if 
					End if 
					
					If (String:C10($Obj_in.tags.launchScreenBackgroundColor)#"")
						
						If (Asserted:C1132($file.exists; "Missing ressources: "+$file.path))
							
							C_TEXT:C284($Svg_root)
							$Svg_root:=DOM Parse XML source:C719($file.platformPath)
							
							If (Asserted:C1132(OK=1; "Failed to parse: "+$file.path))
								
								DOM SET XML ATTRIBUTE:C866(DOM Find XML element:C864($Svg_root; "/svg/rect"); \
									"fill"; $Obj_in.tags.launchScreenBackgroundColor)
								
								$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file(Generate UUID:C1066+".svg")
								DOM EXPORT TO FILE:C862($Svg_root; $file.platformPath)
								
								DOM CLOSE XML:C722($Svg_root)
								
							End if 
						End if 
					End if 
					
					//________________________________________
				Else 
					
					$file:=Null:C1517
					
					//________________________________________
			End case 
			
			If ($file#Null:C1517)
				
				$o:=$Obj_template.assets[$tTxt_keys{$i}]
				
				$Obj_out.assets[$tTxt_keys{$i}]:=asset(New object:C1471(\
					"action"; "create"; \
					"source"; $file.platformPath; \
					"target"; $Obj_template.parent.assets.target+$o.target+Folder separator:K24:12; \
					"tags"; New object:C1471("name"; $o.name); \
					"type"; $o.type; \
					"format"; $o.format; \
					"size"; $o.size; \
					"sizes"; $o.sizes\
					))
				
				ob_error_combine($Obj_out; $Obj_out.assets[$tTxt_keys{$i}])
				
			End if 
		End for 
	End if 
	