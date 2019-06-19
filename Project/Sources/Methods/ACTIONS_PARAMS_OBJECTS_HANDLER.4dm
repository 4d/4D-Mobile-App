//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : ACTIONS_PARAMS_OBJECTS_HANDLER
  // Database: 4D Mobile Express
  // ID[35D81378EF494DE38795C6B491E4CAA8]
  // Created #11-4-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_LONGINT:C283($0)

C_LONGINT:C283($i;$l;$Lon_parameters)
C_TEXT:C284($t;$tt;$Txt_format;$Txt_label;$Txt_type)
C_OBJECT:C1216($o;$Obj_context;$Obj_current;$Obj_form;$Obj_formats;$Obj_menu)
C_OBJECT:C1216($Obj_table)
C_COLLECTION:C1488($c;$cc)

If (False:C215)
	C_LONGINT:C283(ACTIONS_PARAMS_OBJECTS_HANDLER ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Obj_form:=ACTIONS_PARAMS_Handler (New object:C1471(\
		"action";"init"))
	
	$Obj_context:=$Obj_form.$
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.parameters.name)  // Parameters listbox
		
		  //$Obj_form.parameters.get()
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Getting Focus:K2:7)\
				 | ($Obj_form.form.event=On Losing Focus:K2:8)
				
				$Obj_context.listUI()
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Selection Change:K2:29)
				
				$Obj_form.form.refresh()
				
				  //______________________________________________________
			: (editor_Locked )
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: ($Obj_form.parameters.row=0)
				
				  // <NOTHING MORE TO DO>
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Begin Drag Over:K2:44)
				
				$o:=New object:C1471(\
					"old";$Obj_context.index)
				
				  // Put into the container
				VARIABLE TO BLOB:C532($o;$x)
				APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.parameter";$x)
				SET BLOB SIZE:C606($x;0)
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Drop:K2:12)
				
				  // Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.parameter";$x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x;$o)
					SET BLOB SIZE:C606($x;0)
					
					$o.new:=Drop position:C608
					
				End if 
				
				If ($o.old#$o.new)
					
					$Obj_current:=$Obj_context.action.parameters[$o.old-1]
					
					If ($o.new=-1)  // After the last line
						
						$Obj_context.action.parameters.push($Obj_current)
						$Obj_context.action.parameters.remove($o.old-1)
						
					Else 
						
						$Obj_context.action.parameters.insert($o.new-1;$Obj_current)
						
						If ($o.new<$o.old)
							
							$Obj_context.action.parameters.remove($o.old)
							
						Else 
							
							$Obj_context.action.parameters.remove($o.old-1)
							
						End if 
					End if 
				End if 
				
				  //______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.format.name)  // Format choice
		
		$Obj_menu:=menu 
		
		$Obj_current:=$Obj_context.parameter  // Current parameter
		$t:=String:C10($Obj_current.format)  // Current format
		
		$Obj_formats:=JSON Parse:C1218(File:C1566("/RESOURCES/actionParameters.json").getText()).formats
		
		If (featuresFlags.with("allowPictureAsActionParameters"))
			
			  // Add picture formats
			  // Note: When flag will be integrated, update the file "/RESOURCES/actionParameters.json" by adding::
			  // ,
			  // "image" : []
			
			$Obj_formats.image:=New collection:C1472()
			
		End if 
		
		If ($Obj_current.defaultField=Null:C1517)  // User parameter
			
			For each ($Txt_type;$Obj_formats)
				
				If ($Obj_formats[$Txt_type].length>0)
					
					$o:=menu 
					
					$Txt_label:=Choose:C955($Txt_type="string";"text";$Txt_type)
					
					$o.append(":xliff:"+$Txt_label;$Txt_label)
					$o.line()
					
					For each ($Txt_format;$Obj_formats[$Txt_type])
						
						$o.append(":xliff:f_"+$Txt_format;$Txt_format;$t=$Txt_format)
						
					End for each 
					
					$Obj_menu.append(":xliff:"+$Txt_label;$o)
					
				Else 
					
					$Obj_menu.append(":xliff:f_"+$Txt_type;$Txt_type;$t=$Txt_type)
					
				End if 
			End for each 
			
			  // ----------------------------------------
			
		Else 
			
			If ($Obj_formats[$Obj_current.type].length>1)
				
				$Obj_menu.append(":xliff:byDefault";"null";$Obj_current.format=Null:C1517)
				$Obj_menu.line()
				
				For each ($Txt_format;$Obj_formats[$Obj_current.type])
					
					$Obj_menu.append(":xliff:f_"+$Txt_format;$Txt_format;$t=$Txt_format)
					
				End for each 
				
			Else 
				
				$Obj_menu.append(":xliff:"+$Obj_current.type;$Txt_format;$t=$Txt_format)
				
			End if 
		End if 
		
		  // Position according to the box
		$o:=$Obj_form.formatBorder.getCoordinates()
		$Obj_menu.popup("";$o.windowCoordinates.left;$o.windowCoordinates.bottom)
		
		If ($Obj_menu.selected)
			
			If ($Obj_menu.choice="null")
				
				OB REMOVE:C1226($Obj_current;"format")
				
			Else 
				
				$Obj_current.format:=$Obj_menu.choice
				
				If ($Obj_current.defaultField=Null:C1517)  // User parameter
					
					For each ($Txt_type;$Obj_formats) Until ($l#-1)
						
						$l:=$Obj_formats[$Txt_type].indexOf($Obj_current.format)
						
						If ($l#-1)
							
							$Obj_current.type:=Choose:C955($Txt_type="string";"text";$Txt_type)
							
						End if 
					End for each 
					
					If ($l=-1)
						
						$Obj_current.type:=$Obj_current.format
						
					End if 
				End if 
				
				If ($Obj_form.default.focused())
					
					GOTO OBJECT:C206(*;"")
					
				End if 
			End if 
			
			$Obj_form.form.refresh()
			project.save()
			
		End if 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.add.name)  // Add action button
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)  // Add a user parameter
				
				$Obj_menu:=New object:C1471(\
					"selected";True:C214;\
					"choice";"new")
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Alternative Click:K2:36)  // Display
				
				$Obj_menu:=menu 
				$Obj_menu.append(":xliff:addParameter";"new")
				
				If ($Obj_context.action.tableNumber#Null:C1517)
					
					$Obj_table:=Form:C1466.dataModel[String:C10($Obj_context.action.tableNumber)]
					
					$c:=New collection:C1472
					
					If ($Obj_context.action.parameters=Null:C1517)
						
						For each ($t;$Obj_table)
							
							If (Storage:C1525.ƒ.isField($t))
								
								$Obj_table[$t].fieldNumber:=Num:C11($t)
								$c.push($Obj_table[$t])
								
							End if 
						End for each 
						
					Else 
						
						For each ($t;$Obj_table)
							
							If (Storage:C1525.ƒ.isField($t))
								
								If ($Obj_context.action.parameters.query("fieldNumber = :1";Num:C11($t)).length=0)
									
									$Obj_table[$t].fieldNumber:=Num:C11($t)
									$c.push($Obj_table[$t])
									
								End if 
							End if 
						End for each 
					End if 
					
					If ($c.length>0)
						
						$Obj_menu.line()
						
						For each ($o;$c)
							
							$Obj_menu.append($o.name;String:C10($o.fieldNumber))
							
						End for each 
					End if 
					
				Else 
					
					  // No table affected to action
					
				End if 
				
				$o:=$Obj_form.add.getCoordinates()
				$Obj_menu.popup("";$o.windowCoordinates.left;$o.windowCoordinates.bottom)
				
				  //______________________________________________________
		End case 
		
		If ($Obj_menu.selected)
			
			Case of 
					
					  //______________________________________________________
				: ($Obj_menu.choice="new")  // Add a user parameter
					
					$tt:=Get localized string:C991("newParameter")
					
					If ($Obj_context.action.parameters#Null:C1517)
						
						If ($Obj_context.action.parameters.query("name=:1";$tt).length=0)
							
							$t:=$tt
							
						Else 
							
							Repeat 
								
								$i:=$i+1
								
								$c:=$Obj_context.action.parameters.query("name=:1";$tt+String:C10($i))
								
								If ($c.length=0)
									
									$t:=$tt+String:C10($i)
									
								End if 
							Until ($c.length=0)
						End if 
						
					Else 
						
						$t:=$tt
						
					End if 
					
					$o:=New object:C1471(\
						"name";$t;\
						"label";Get localized string:C991("addParameter");\
						"shortLabel";Get localized string:C991("addParameter");\
						"type";"string")
					
					  //______________________________________________________
				Else   // Add a field
					
					$c:=$c.query("fieldNumber = :1";Num:C11($Obj_menu.choice))
					
					$o:=New object:C1471(\
						"fieldNumber";$c[0].fieldNumber;\
						"name";str ($c[0].name).uperCamelCase();\
						"label";$c[0].label;\
						"shortLabel";$c[0].shortLabel;\
						"defaultField";formatString ("field-name";$c[0].name))
					
					If (Bool:C1537($c[0].mandatory))
						
						$o.rules:=New collection:C1472("mandatory")
						
					End if 
					
					$cc:=New collection:C1472
					$cc[Is integer 64 bits:K8:25]:="number"
					$cc[Is alpha field:K8:1]:="string"
					$cc[Is integer:K8:5]:="number"
					$cc[Is longint:K8:6]:="number"
					$cc[Is picture:K8:10]:="image"
					$cc[Is boolean:K8:9]:="bool"
					$cc[Is float:K8:26]:="number"
					$cc[Is text:K8:3]:="string"
					$cc[Is real:K8:4]:="number"
					$cc[Is time:K8:8]:="time"
					$cc[Is date:K8:7]:="date"
					
					$o.type:=$cc[$c[0].fieldType]
					
					ASSERT:C1129($o.type#Null:C1517)
					
					Case of 
							
							  //……………………………………………………………………
						: ($o.type="date")
							
							$o.format:="dateMedium"
							
							  //……………………………………………………………………
						: ($o.type="time")
							
							$o.format:="hour"
							
							  //……………………………………………………………………
					End case 
					
					  //______________________________________________________
			End case 
			
			$Obj_context:=ob_createPath ($Obj_context;"action.parameters";Is collection:K8:32)
			$Obj_context.action.parameters.push($o)
			$Obj_form.parameters.focus()
			$Obj_form.parameters.reveal($Obj_form.parameters.rowsNumber())
			
			$Obj_form.form.refresh()
			project.save()
			
		End if 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.remove.name)  // Remove action button
		
		$i:=$Obj_context.action.parameters.indexOf($Obj_context.parameter)
		$Obj_context.action.parameters.remove($i)
		
		$i:=$i+1  // Collection index to listbox index
		
		If ($i<=$Obj_form.parameters.rowsNumber())
			
			$Obj_form.parameters.select($i)
			
		Else 
			
			$Obj_form.parameters.deselect()
			
		End if 
		
		$Obj_form.form.refresh()
		project.save()
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.mandatory.name)  // Mandatory checkbox
		
		If (($Obj_form.mandatory.pointer())->)  // Checked
			
			ob_createPath ($Obj_context.parameter;"rules";Is collection:K8:32)
			
			If ($Obj_context.parameter.rules.indexOf("mandatory")=-1)
				
				$Obj_context.parameter.rules.push("mandatory")
				
			End if 
			
		Else 
			
			If ($Obj_context.parameter.rules#Null:C1517)
				
				$l:=$Obj_context.parameter.rules.indexOf("mandatory")
				
				If ($l#-1)
					
					$Obj_context.parameter.rules.remove($l)
					
				End if 
				
				If ($Obj_context.parameter.rules.length=0)
					
					OB REMOVE:C1226($Obj_context.parameter;"rules")
					
				End if 
			End if 
		End if 
		
		project.save()
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.min.name)\
		 | ($Obj_form.form.currentWidget=$Obj_form.max.name)  // Minimum & Maximum
		
		$o:=Choose:C955($Obj_form.form.currentWidget=$Obj_form.min.name;$Obj_form.min;$Obj_form.max)
		$t:=Choose:C955($Obj_form.form.currentWidget=$Obj_form.min.name;"min";"max")
		
		If (Length:C16($o.value())>0)
			
			If ($Obj_context.parameter.rules#Null:C1517)
				
				For ($i;0;$Obj_context.parameter.rules.length-1;1)
					
					If (Value type:C1509($Obj_context.parameter.rules[$i])=Is object:K8:27)
						
						If ($Obj_context.parameter.rules[$i][$t]#Null:C1517)
							
							$Obj_context.parameter.rules[$i][$t]:=Num:C11($o.value())
							$i:=MAXLONG:K35:2-1
							
						End if 
					End if 
				End for 
				
				If ($i#MAXLONG:K35:2)
					
					$Obj_context.parameter.rules.push(New object:C1471(\
						$t;Num:C11($o.value())))
					
				End if 
				
			Else 
				
				ob_createPath ($Obj_context.parameter;"rules";Is collection:K8:32)
				$Obj_context.parameter.rules.push(New object:C1471(\
					$t;Num:C11($o.value())))
				
			End if 
			
		Else 
			
			If ($Obj_context.parameter.rules#Null:C1517)
				
				For ($i;0;$Obj_context.parameter.rules.length-1;1)
					
					If (Value type:C1509($Obj_context.parameter.rules[$i])=Is object:K8:27)
						
						If ($Obj_context.parameter.rules[$i][$t]#Null:C1517)
							
							$Obj_context.parameter.rules.remove($i)
							$i:=MAXLONG:K35:2-1
							
						End if 
					End if 
				End for 
				
				If ($Obj_context.parameter.rules.length=0)
					
					OB REMOVE:C1226($Obj_context.parameter;"rules")
					
				End if 
			End if 
		End if 
		
		project.save()
		
		  //==================================================
	: ($Obj_form.linked.include($Obj_form.form.currentWidget))  // Linked widgets
		
		project.save()
		
		  //==================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown widget: \""+String:C10($Obj_form.form.currentWidget)+"\"")
		
		  //==================================================
End case 

If (featuresFlags.with(8858))
	
	project.save()
	
End if 

  // ----------------------------------------------------
  // Return
  // ----------------------------------------------------
  // End