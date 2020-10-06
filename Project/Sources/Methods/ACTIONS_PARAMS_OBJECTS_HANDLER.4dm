//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : ACTIONS_PARAMS_OBJECTS_HANDLER
// ID[35D81378EF494DE38795C6B491E4CAA8]
// Created 11-4-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
var $0 : Integer

If (False:C215)
	C_LONGINT:C283(ACTIONS_PARAMS_OBJECTS_HANDLER; $0)
End if 

var $format; $label; $t; $tt; $type : Text
var $date : Date
var $i; $index : Integer
var $x : Blob
var $current; $form; $formats; $ƒ; $o; $table; $widget : Object
var $c; $cc : Collection

var $menu : cs:C1710.menu

// ----------------------------------------------------
// Initialisations
$form:=ACTIONS_PARAMS_Handler(New object:C1471(\
"action"; "init"))

$ƒ:=$form.$

// ----------------------------------------------------
Case of 
		
		//==================================================
	: ($form.form.current=$form.parameters.name)  // Parameters listbox
		
		$widget:=$form.parameters
		
		Case of 
				
				//______________________________________________________
			: ($form.form.eventCode=On Getting Focus:K2:7)\
				 | ($form.form.eventCode=On Losing Focus:K2:8)
				
				$ƒ.listUI()
				
				//______________________________________________________
			: ($form.form.eventCode=On Selection Change:K2:29)
				
				$ƒ.$current:=$ƒ.parameter
				$form.form.refresh()
				
				//______________________________________________________
			: (editor_Locked)
				
				$0:=-1
				
				//______________________________________________________
			: ($widget.row=0)
				
				// <NOTHING MORE TO DO>
				
				//______________________________________________________
			: ($form.form.eventCode=On Mouse Leave:K2:34)
				
				$form.dropCursor.hide()
				
				//______________________________________________________
			: ($form.form.eventCode=On Begin Drag Over:K2:44)
				
				$o:=New object:C1471(\
					"src"; $ƒ.index)
				
				// Put into the container
				VARIABLE TO BLOB:C532($o; $x)
				APPEND DATA TO PASTEBOARD:C403("com.4d.private.ios.parameter"; $x)
				SET BLOB SIZE:C606($x; 0)
				
				//______________________________________________________
			: ($form.form.eventCode=On Drag Over:K2:13)  // Manage drag & drop cursor
				
				// Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.parameter"; $x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x; $o)
					SET BLOB SIZE:C606($x; 0)
					
					$o.tgt:=Drop position:C608
					
					If ($o.tgt=-1)  // After the last line
						
						If ($o.src#$widget.rowsNumber())  // Not if the source was the last line
							
							$o:=$widget.cellCoordinates(1; $widget.rowsNumber()).cellBox
							$o.top:=$o.bottom
							$o.right:=$widget.coordinates.right
							
							$form.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
							$form.dropCursor.show()
							
						Else 
							
							// Reject drop
							$form.dropCursor.hide()
							$0:=-1
							
						End if 
						
					Else 
						
						If ($o.src#$o.tgt)\
							 & ($o.tgt#($o.src+1))  // Not the same or the next one
							
							$o:=$widget.cellCoordinates(1; $o.tgt).cellBox
							$o.bottom:=$o.top
							$o.right:=$widget.coordinates.right
							
							$form.dropCursor.setCoordinates($o.left; $o.top; $o.right; $o.bottom)
							$form.dropCursor.show()
							
						Else 
							
							// Reject drop
							$form.dropCursor.hide()
							$0:=-1
							
						End if 
					End if 
					
				Else 
					
					// Reject drop
					$form.dropCursor.hide()
					$0:=-1
					
				End if 
				
				//______________________________________________________
			: ($form.form.eventCode=On Drop:K2:12)
				
				// Get the pastboard
				GET PASTEBOARD DATA:C401("com.4d.private.ios.parameter"; $x)
				
				If (Bool:C1537(OK))
					
					BLOB TO VARIABLE:C533($x; $o)
					SET BLOB SIZE:C606($x; 0)
					
					$o.tgt:=Drop position:C608
					
				End if 
				
				If ($o.src#$o.tgt)
					
					$current:=$ƒ.action.parameters[$o.src-1]
					
					If ($o.tgt=-1)  // After the last line
						
						$ƒ.action.parameters.push($current)
						$ƒ.action.parameters.remove($o.src-1)
						
					Else 
						
						$ƒ.action.parameters.insert($o.tgt-1; $current)
						
						If ($o.tgt<$o.src)
							
							$ƒ.action.parameters.remove($o.src)
							
						Else 
							
							$ƒ.action.parameters.remove($o.src-1)
							
						End if 
					End if 
				End if 
				
				$form.dropCursor.hide()
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(False:C215; "Form event activated unnecessarily ("+String:C10($form.form.eventCode)+")")
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($form.form.current=$form.format.name)  // Format choice
		
		$menu:=cs:C1710.menu.new()
		
		$current:=$ƒ.parameter  // Current parameter
		$t:=String:C10($current.format)  // Current format
		
		$formats:=JSON Parse:C1218(File:C1566("/RESOURCES/actionParameters.json").getText()).formats
		
		If ($current.fieldNumber#Null:C1517)  // Action linked to a field
			
			$menu.append(":xliff:byDefault"; "null"; $current.format=Null:C1517)
			$menu.line()
			
			For each ($format; $formats[$current.type])
				
				$menu.append(":xliff:f_"+$format; $format; $t=$format)
				
			End for each 
			
		Else 
			
			For each ($type; $formats)
				
				If ($formats[$type].length>0)
					
					$o:=cs:C1710.menu.new()
					
					$label:=Choose:C955($type="string"; "text"; $type)
					
					$o.append(":xliff:"+$label; $label)
					$o.line()
					
					For each ($format; $formats[$type])
						
						$o.append(":xliff:f_"+$format; $format; $t=$format)
						
					End for each 
					
					$menu.append(":xliff:"+$label; $o)
					
				Else 
					
					$menu.append(":xliff:f_"+$type; $type; $t=$type)
					
				End if 
			End for each 
		End if 
		
		// Position according to the box
		If ($menu.popup(""; $form.formatBorder.getCoordinates()).selected)
			
			If ($menu.choice="null")
				
				OB REMOVE:C1226($current; "format")
				
			Else 
				
				$current.format:=$menu.choice
				
				If ($current.defaultField=Null:C1517)  // User parameter
					
					For each ($type; $formats) Until ($index#-1)
						
						$index:=$formats[$type].indexOf($current.format)
						
						If ($index#-1)
							
							$t:=Choose:C955($type="string"; "text"; $type)
							
						End if 
					End for each 
					
					If ($index=-1)
						
						$t:=$current.format
						
					End if 
					
					If ($current.type#$t)  // The type is changed
						
						$current.type:=$t
						OB REMOVE:C1226($current; "default")
						
						If ($form.default.focused())
							
							GOTO OBJECT:C206(*; "")
							
						End if 
					End if 
				End if 
			End if 
			
			$form.form.refresh()
			PROJECT.save()
			
		End if 
		
		//==================================================
	: ($form.form.current=$form.add.name)  // Add action button
		
		Case of 
				
				//______________________________________________________
			: ($form.form.eventCode=On Clicked:K2:4)  // Add a user parameter
				
				$menu:=New object:C1471(\
					"selected"; True:C214; \
					"choice"; "new")
				
				//______________________________________________________
			: ($form.form.eventCode=On Alternative Click:K2:36)  // Display
				
				$menu:=cs:C1710.menu.new()
				$menu.append(":xliff:addParameter"; "new")
				
				If ($ƒ.action.tableNumber#Null:C1517)
					
					$table:=Form:C1466.dataModel[String:C10($ƒ.action.tableNumber)]
					
					$c:=New collection:C1472
					
					If ($ƒ.action.parameters=Null:C1517)
						
						For each ($t; $table)
							
							If (PROJECT.isField($t))
								
								$table[$t].fieldNumber:=Num:C11($t)
								$c.push($table[$t])
								
							End if 
						End for each 
						
					Else 
						
						For each ($t; $table)
							
							If (PROJECT.isField($t))
								
								If ($ƒ.action.parameters.query("fieldNumber = :1"; Num:C11($t)).length=0)
									
									$table[$t].fieldNumber:=Num:C11($t)
									$c.push($table[$t])
									
								End if 
							End if 
						End for each 
					End if 
					
					If ($c.length>0)
						
						$menu.line()
						
						For each ($o; $c)
							
							$menu.append($o.name; String:C10($o.fieldNumber))
							
						End for each 
					End if 
					
				Else 
					
					// No table affected to action
					
				End if 
				
				$menu.popup(""; $form.add.getCoordinates())
				
				//______________________________________________________
		End case 
		
		If ($menu.selected)
			
			Case of 
					
					//______________________________________________________
				: ($menu.choice="new")  // Add a user parameter
					
					$tt:=Get localized string:C991("newParameter")
					
					If ($ƒ.action.parameters#Null:C1517)
						
						If ($ƒ.action.parameters.query("name=:1"; $tt).length=0)
							
							$t:=$tt
							
						Else 
							
							Repeat 
								
								$i:=$i+1
								
								$c:=$ƒ.action.parameters.query("name=:1"; $tt+String:C10($i))
								
								If ($c.length=0)
									
									$t:=$tt+String:C10($i)
									
								End if 
							Until ($c.length=0)
						End if 
						
					Else 
						
						$t:=$tt
						
					End if 
					
					$o:=New object:C1471(\
						"name"; $t; \
						"label"; Get localized string:C991("addParameter"); \
						"shortLabel"; Get localized string:C991("addParameter"); \
						"type"; "string")
					
					//______________________________________________________
				Else   // Add a field
					
					$c:=$c.query("fieldNumber = :1"; Num:C11($menu.choice))
					
					$o:=New object:C1471(\
						"fieldNumber"; $c[0].fieldNumber; \
						"name"; _o_str($c[0].name).uperCamelCase(); \
						"label"; $c[0].label; \
						"shortLabel"; $c[0].shortLabel; \
						"defaultField"; formatString("field-name"; $c[0].name))
					
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
					$cc[_o_Is float:K8:26]:="number"
					$cc[Is text:K8:3]:="string"
					$cc[Is real:K8:4]:="number"
					$cc[Is time:K8:8]:="time"
					$cc[Is date:K8:7]:="date"
					
					$o.type:=$cc[$c[0].fieldType]
					
					ASSERT:C1129($o.type#Null:C1517)
					
					Case of 
							
							//……………………………………………………………………
						: ($o.type="date")
							
							$o.format:="mediumDate"
							
							//……………………………………………………………………
						: ($o.type="time")
							
							$o.format:="hour"
							
							//……………………………………………………………………
					End case 
					
					//______________________________________________________
			End case 
			
			$ƒ:=ob_createPath($ƒ; "action.parameters"; Is collection:K8:32)
			$ƒ.action.parameters.push($o)
			$form.parameters.focus()
			$form.parameters.reveal($form.parameters.rowsNumber()+Num:C11($form.parameters.rowsNumber()=0))
			
			$form.form.refresh()
			PROJECT.save()
			
		End if 
		
		//==================================================
	: ($form.form.current=$form.remove.name)  // Remove action button
		
		$i:=$ƒ.action.parameters.indexOf($ƒ.parameter)
		$ƒ.action.parameters.remove($i)
		
		$i:=$i+1  // Collection index to listbox index
		
		If ($i<=$form.parameters.rowsNumber())
			
			$form.parameters.select($i)
			
		Else 
			
			$form.parameters.deselect()
			
		End if 
		
		$form.form.refresh()
		PROJECT.save()
		
		//==================================================
	: ($form.form.current=$form.mandatory.name)  // Mandatory checkbox
		
		If (($form.mandatory.pointer())->)  // Checked
			
			ob_createPath($ƒ.parameter; "rules"; Is collection:K8:32)
			
			If ($ƒ.parameter.rules.indexOf("mandatory")=-1)
				
				$ƒ.parameter.rules.push("mandatory")
				
			End if 
			
		Else 
			
			If ($ƒ.parameter.rules#Null:C1517)
				
				$index:=$ƒ.parameter.rules.indexOf("mandatory")
				
				If ($index#-1)
					
					$ƒ.parameter.rules.remove($index)
					
				End if 
				
				If ($ƒ.parameter.rules.length=0)
					
					OB REMOVE:C1226($ƒ.parameter; "rules")
					
				End if 
			End if 
		End if 
		
		PROJECT.save()
		
		//==================================================
	: ($form.form.current=$form.min.name)\
		 | ($form.form.current=$form.max.name)  // Minimum & Maximum
		
		$o:=Choose:C955($form.form.current=$form.min.name; $form.min; $form.max)
		$t:=Choose:C955($form.form.current=$form.min.name; "min"; "max")
		
		If (Length:C16($o.value())>0)
			
			If ($ƒ.parameter.rules#Null:C1517)
				
				For ($i; 0; $ƒ.parameter.rules.length-1; 1)
					
					If (Value type:C1509($ƒ.parameter.rules[$i])=Is object:K8:27)
						
						If ($ƒ.parameter.rules[$i][$t]#Null:C1517)
							
							$ƒ.parameter.rules[$i][$t]:=Num:C11($o.value())
							$i:=MAXLONG:K35:2-1
							
						End if 
					End if 
				End for 
				
				If ($i#MAXLONG:K35:2)
					
					$ƒ.parameter.rules.push(New object:C1471(\
						$t; Num:C11($o.value())))
					
				End if 
				
			Else 
				
				ob_createPath($ƒ.parameter; "rules"; Is collection:K8:32)
				$ƒ.parameter.rules.push(New object:C1471(\
					$t; Num:C11($o.value())))
				
			End if 
			
		Else 
			
			If ($ƒ.parameter.rules#Null:C1517)
				
				For ($i; 0; $ƒ.parameter.rules.length-1; 1)
					
					If (Value type:C1509($ƒ.parameter.rules[$i])=Is object:K8:27)
						
						If ($ƒ.parameter.rules[$i][$t]#Null:C1517)
							
							$ƒ.parameter.rules.remove($i)
							$i:=MAXLONG:K35:2-1
							
						End if 
					End if 
				End for 
				
				If ($ƒ.parameter.rules.length=0)
					
					OB REMOVE:C1226($ƒ.parameter; "rules")
					
				End if 
			End if 
		End if 
		
		PROJECT.save()
		
		//==================================================
	: ($form.form.current=$form.default.name)  // Default value
		
		$o:=$ƒ.parameter
		
		Case of 
				
				//______________________________________________________
			: ($form.form.eventCode=On After Edit:K2:43)
				
				If (Length:C16(Get edited text:C655)=0)
					
					OB REMOVE:C1226($o; "default")
					
				End if 
				
				//______________________________________________________
			: ($form.form.eventCode=On Data Change:K2:15)
				
				$t:=$form.default.value()
				
				If (Length:C16(String:C10($t))>0)
					
					Case of 
							
							//______________________________________________________
						: ($o.type="number")
							
							$o.default:=Num:C11($t)
							
							//______________________________________________________
						: ($o.type="date")
							
							If (Match regex:C1019("(?m-si)^(?:today|tomorrow|yesterday)$"; $t; 1))
								
								$o.default:=$t
								
							Else 
								
								If (Match regex:C1019("(?m-si)^\\d+/\\d+/\\d+$"; $t; 1))
									
									// Use internal REST date format
									$date:=Date:C102($t)
									$o.default:=String:C10(Day of:C23($date); "00!")+String:C10(Month of:C24($date); "00!")+String:C10(Year of:C25($date); "0000")
									
								Else 
									
									BEEP:C151
									OB REMOVE:C1226($o; "default")
									$form.default.focus()
									
								End if 
							End if 
							
							//______________________________________________________
						: ($o.type="bool")
							
							If (String:C10($o.format)="check")
								
								If (Match regex:C1019("(?m-is)^(?:checked|unchecked)$"; $t; 1))
									
									$o.default:=Bool:C1537($t="checked")
									
								Else 
									
									If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($t)); 1))
										
										$o.default:=Num:C11($t)
										
									Else 
										
										BEEP:C151
										OB REMOVE:C1226($o; "default")
										$form.default.focus()
										
									End if 
								End if 
								
							Else 
								
								If (Match regex:C1019("(?m-is)^(?:true|false)$"; $t; 1))
									
									$o.default:=Bool:C1537($t="true")
									
								Else 
									
									If (Match regex:C1019("(?m-is)^(?:0|1)$"; String:C10(Num:C11($t)); 1))
										
										$o.default:=Num:C11($t)
										
									Else 
										
										BEEP:C151
										OB REMOVE:C1226($o; "default")
										$form.default.focus()
										
									End if 
								End if 
							End if 
							
							//______________________________________________________
						: ($o.type="time")
							
							$o.default:=String:C10(Time:C179($t); HH MM:K7:2)
							
							//______________________________________________________
						Else 
							
							$o.default:=$t
							
							//______________________________________________________
					End case 
					
				Else 
					
					OB REMOVE:C1226($o; "default")
					
				End if 
				
				$form.form.refresh()
				PROJECT.save()
				
				//______________________________________________________
		End case 
		
		//==================================================
	: ($form.form.current=$form.description.name)  // Description associated to the link
		
		PROJECT.save()
		
		//==================================================
	: ($form.linked.include($form.form.current))  // Linked widgets
		
		PROJECT.save()
		
		//==================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown widget: \""+String:C10($form.form.current)+"\"")
		
		//==================================================
End case 

If (FEATURE.with(8858))
	
	PROJECT.save()
	
End if 

// ----------------------------------------------------
// End