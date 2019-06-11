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

C_LONGINT:C283($i;$Lon_parameters)
C_TEXT:C284($t;$tt)
C_OBJECT:C1216($o;$Obj_context;$Obj_current;$Obj_form;$Obj_menu;$Obj_table)
C_COLLECTION:C1488($c;$cc)

If (False:C215)
	C_LONGINT:C283(ACTIONS_PARAMS_OBJECTS_HANDLER )
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
			Else 
				
				ASSERT:C1129(False:C215;"Form event activated unnecessarily ("+String:C10($Obj_form.form.event)+")")
				
				  //______________________________________________________
		End case 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.typeMenu.name)  // Types choice
		
		$Obj_menu:=menu 
		
		$Obj_current:=$Obj_context.parameter  //current parameter
		$t:=String:C10($Obj_current.format)  //current format
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_current.defaultField=Null:C1517)  // User parameter
				
				$o:=menu 
				$o.append(":xliff:text";"text";False:C215)
				$o.line()
				$o.append(":xliff:name";"name";$t="name")
				$o.append(":xliff:email";"email";$t="email")
				$o.append(":xliff:phone";"phone";$t="phone")
				$o.append(":xliff:account";"account";$t="account")
				$o.append(":xliff:password";"password";$t="password")
				$o.append(":xliff:url";"url";$t="url")
				$o.append(":xliff:zipCode";"zipCode";$t="zipCode")
				$Obj_menu.append(":xliff:text";$o)
				
				$o:=menu 
				$o.append(":xliff:number";"number";False:C215)
				$o.line()
				$o.append(":xliff:scientific";"scientific";$t="scientific")
				$o.append(":xliff:percent";"percent";$t="percent")
				$o.append(":xliff:energy";"energy";$t="energy")
				$o.append(":xliff:mass";"mass";$t="mass")
				$Obj_menu.append(":xliff:number";$o)
				
				$o:=menu 
				$o.append(":xliff:dateMedium";"dateMedium";$t="dateMedium")
				$o.append(":xliff:dateShort";"dateShort";$t="dateShort")
				$o.append(":xliff:dateLong";"dateLong";$t="dateLong")
				$Obj_menu.append(":xliff:date";$o)
				
				$o:=menu 
				$o.append(":xliff:hour";"hour";$t="hour")
				$o.append(":xliff:duration";"duration";$t="duration")
				$Obj_menu.append(":xliff:time";$o)
				
				$Obj_menu.line()
				$Obj_menu.append(":xliff:bool";"bool";$t="bool")
				$Obj_menu.append(":xliff:image";"image";$t="image")
				
				  //______________________________________________________
			: ($Obj_current.type="string")
				
				$Obj_menu.append(":xliff:text";"null";$Obj_current.format=Null:C1517)
				$Obj_menu.line()
				$Obj_menu.append(":xliff:textArea";"textArea";$t="textArea")
				$Obj_menu.append(":xliff:name";"name";$t="name")
				$Obj_menu.append(":xliff:email";"email";$t="email")
				$Obj_menu.append(":xliff:phone";"phone";$t="phone")
				$Obj_menu.append(":xliff:account";"account";$t="account")
				$Obj_menu.append(":xliff:password";"password";$t="password")
				$Obj_menu.append(":xliff:url";"url";$t="url")
				$Obj_menu.append(":xliff:zipCode";"zipCode";$t="zipCode")
				
				  //______________________________________________________
			: ($Obj_current.type="date")
				
				$Obj_menu.append(":xliff:dateMedium";"dateMedium";$t="dateMedium")
				$Obj_menu.append(":xliff:dateShort";"dateShort";$t="dateShort")
				$Obj_menu.append(":xliff:dateLong";"dateLong";$t="dateLong")
				
				  //______________________________________________________
			: ($Obj_current.type="number")
				
				$Obj_menu.append(":xliff:number";"null";$Obj_current.format=Null:C1517)
				$Obj_menu.line()
				$Obj_menu.append(":xliff:scientific";"scientific";$t="scientific")
				$Obj_menu.append(":xliff:percent";"percent";$t="percent")
				$Obj_menu.append(":xliff:energy";"energy";$t="energy")
				$Obj_menu.append(":xliff:mass";"mass";$t="mass")
				$Obj_menu.append(":xliff:spellOut";"spellOut";$t="spellOut")
				
				  //______________________________________________________
			: ($Obj_current.type="time")
				
				$Obj_menu.append(":xliff:hour";"hour";$t="hour")
				$Obj_menu.append(":xliff:duration";"duration";$t="duration")
				
				  //______________________________________________________
			: ($Obj_current.type="bool")
				
				$Obj_menu.append(":xliff:bool";"null";$Obj_current.format=Null:C1517)
				
				  //______________________________________________________
			: ($Obj_current.type="image")
				
				$Obj_menu.append(":xliff:image";"null";$Obj_current.format=Null:C1517)
				
				  //______________________________________________________
			Else 
				
				$Obj_menu.append(":xliff:standard";"null";$Obj_current.format=Null:C1517)
				
				  //______________________________________________________
		End case 
		
		  // Position according to the box
		$o:=$Obj_form.typeBorder.getCoordinates()
		$Obj_menu.popup("";$o.windowCoordinates.left;$o.windowCoordinates.bottom)
		
		If ($Obj_menu.selected)
			
			If ($Obj_menu.choice="null")
				
				OB REMOVE:C1226($Obj_current;"format")
				
			Else 
				
				$Obj_current.format:=$Obj_menu.choice
				
				If ($Obj_current.defaultField=Null:C1517)  // User parameter
					
					$t:=$Obj_current.format
					
					Case of 
							
							  //______________________________________________________
						: ($t="name")\
							 | ($t="email")\
							 | ($t="phone")\
							 | ($t="account")\
							 | ($t="password")\
							 | ($t="url")\
							 | ($t="zipCode")
							
							$Obj_current.type:="text"
							
							  //______________________________________________________
						: ($t="scientific")\
							 | ($t="percent")\
							 | ($t="energy")\
							 | ($t="mass")
							
							$Obj_current.type:="number"
							
							  //______________________________________________________
						: ($t="dateMedium")\
							 | ($t="dateShort")\
							 | ($t="dateLong")
							
							$Obj_current.type:="date"
							
							  //______________________________________________________
						: ($t="hour")\
							 | ($t="duration")
							
							$Obj_current.type:="time"
							
							  //______________________________________________________
						Else 
							
							$Obj_current.type:=$t
							
							  //______________________________________________________
					End case 
					
				End if 
			End if 
			
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
			: ($Obj_form.form.event=On Alternative Click:K2:36)  //
				
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
						"label";"";\
						"shortLabel";"";\
						"type";Null:C1517;\
						"default";Null:C1517)
					
					  //______________________________________________________
				Else   // Add a field
					
					$c:=$c.query("fieldNumber = :1";Num:C11($Obj_menu.choice))
					
					$o:=New object:C1471(\
						"fieldNumber";$c[0].fieldNumber;\
						"name";formatString ("field-name";$c[0].name);\
						"label";$c[0].label;\
						"shortLabel";$c[0].shortLabel;\
						"type";Null:C1517;\
						"defaultField";"")
					
					$o.defaultField:=$o.name
					
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
		
		$Obj_context.parameter:=New object:C1471
		$Obj_context.selected:=New collection:C1472
		$Obj_context.index:=0
		
		$Obj_context.parameter:=$Obj_context.parameter
		
		$Obj_form.form.refresh()
		
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