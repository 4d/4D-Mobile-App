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

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t)
C_OBJECT:C1216($o;$Obj_context;$Obj_form;$Obj_menu;$Obj_table)
C_COLLECTION:C1488($c)

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
	: ($Obj_form.form.event=On Display Detail:K2:22)
		
		  // Should not!
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.parameters.name)  // Parameters listbox
		
		$Obj_form.parameters.get()
		
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
		
		$Obj_menu:=ui.menu()
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="string")
				
				$Obj_menu.append(":xliff:_text";"null";$Obj_context.parameter.format=Null:C1517)
				$Obj_menu.line()
				$Obj_menu.append(":xliff:textArea";"textArea";String:C10($Obj_context.parameter.format)="textArea")
				$Obj_menu.append(":xliff:name";"name";String:C10($Obj_context.parameter.format)="name")
				$Obj_menu.append(":xliff:_mail";"email";String:C10($Obj_context.parameter.forma)="email")
				$Obj_menu.append(":xliff:_phone";"phone";String:C10($Obj_context.parameter.format)="phone")
				$Obj_menu.append(":xliff:account";"account";String:C10($Obj_context.parameter.format)="account")
				$Obj_menu.append(":xliff:password";"password";String:C10($Obj_context.parameter.format)="password")
				$Obj_menu.append(":xliff:_url";"url";String:C10($Obj_context.parameter.format)="url")
				$Obj_menu.append(":xliff:zipCode";"zipCode";String:C10($Obj_context.parameter.format)="zipCode")
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="date")
				
				$Obj_menu.append(":xliff:_mediumDate";"dateMedium";String:C10($Obj_context.parameter.format)="dateMedium")
				$Obj_menu.append(":xliff:_shortDate";"dateShort";String:C10($Obj_context.parameter.format)="dateShort")
				$Obj_menu.append(":xliff:_longDate";"dateLong";String:C10($Obj_context.parameter.format)="dateLong")
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="number")
				
				$Obj_menu.append(":xliff:number";"null";$Obj_context.parameter.format=Null:C1517)
				$Obj_menu.line()
				$Obj_menu.append(":xliff:scientific";"scientific";String:C10($Obj_context.parameter.format)="scientific")
				$Obj_menu.append(":xliff:_percent";"percent";String:C10($Obj_context.parameter.format)="percent")
				$Obj_menu.append(":xliff:energy";"energy";String:C10($Obj_context.parameter.format)="energy")
				$Obj_menu.append(":xliff:mass";"mass";String:C10($Obj_context.parameter.format)="mass")
				$Obj_menu.append(":xliff:_spellOut";"spellOut";String:C10($Obj_context.parameter.format)="spellOut")
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="time")
				
				$Obj_menu.append(":xliff:hour";"hour";String:C10($Obj_context.parameter.format)="hour")
				$Obj_menu.append(":xliff:_duration";"duration";String:C10($Obj_context.parameter.format)="duration")
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="bool")
				
				$Obj_menu.append(":xliff:boolean";"null";$Obj_context.parameter.format=Null:C1517)
				
				  //______________________________________________________
			: ($Obj_context.parameter.type="image")
				
				$Obj_menu.append(":xliff:_restImage";"null";$Obj_context.parameter.format=Null:C1517)
				
				  //______________________________________________________
			Else 
				
				$Obj_menu.append(":xliff:standard";"null";$Obj_context.parameter.format=Null:C1517)
				
				  //______________________________________________________
		End case 
		
		  // Position according to the box
		$o:=$Obj_form.typeBorder.getCoordinates()
		$Obj_menu.popup("";$o.windowCoordinates.left;$o.windowCoordinates.bottom)
		$Obj_menu.clear()
		
		If (Length:C16($Obj_menu.choice)#0)
			
			If ($Obj_menu.choice="null")
				
				OB REMOVE:C1226($Obj_context.parameter;"format")
				
			Else 
				
				$Obj_context.parameter.format:=$Obj_menu.choice
				
			End if 
			
			project.save()
			
		End if 
		
		  //==================================================
	: ($Obj_form.form.currentWidget=$Obj_form.add.name)  // Add action button
		
		Case of 
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Clicked:K2:4)  // Add a user parameter
				
				$t:="new"
				
				  //______________________________________________________
			: ($Obj_form.form.event=On Alternative Click:K2:36)  //
				
				$Obj_menu:=ui.menu()
				$Obj_menu.append(".New parameter";"new")
				
				$Obj_table:=Form:C1466.dataModel[String:C10($Obj_context.action.tableNumber)]
				
				$c:=New collection:C1472
				
				For each ($t;$Obj_table)
					
					If (Storage:C1525.ƒ.isField($t))
						
						Case of 
								
								  //______________________________________________________
							: ($Obj_context.action.parameters=Null:C1517)
								
								$c.push($Obj_table[$t])
								
								  //______________________________________________________
							: ($Obj_context.action.parameters.query("fieldNumber = :1";Num:C11($t)).length=0)
								
								$c.push($Obj_table[$t])
								
								  //______________________________________________________
						End case 
					End if 
				End for each 
				
				If ($c.length>0)
					
					$Obj_menu.line()
					
					For each ($o;$c)
						
						$Obj_menu.append($o.name;String:C10($o.fieldNumber))
						
					End for each 
				End if 
				
				$Obj_menu.popup()
				$Obj_menu.clear()
				
				$t:=String:C10($Obj_menu.choice)
				
				Case of 
						
						  //______________________________________________________
					: (Length:C16($t)=0)
						
						  // <NOTHING MORE TO DO>
						
						  //______________________________________________________
					: ($t="new")  // Add a user parameter
						
						  //______________________________________________________
					Else   // Add a field
						
						  //$c:=$c.query("fieldNumber = :1";Num($t))
						
						  //$o:=New object(\
							"fieldNumber";$c[0].fieldNumber;\
							"name";formatString ("field-name";$c[0].name);\
							"label";$c[0].label;\
							"shortLabel";$c[0].shortLabel;\
							"type";Choose($c[0].fieldType=Is time;"time";$c[0].fieldType))
						
						  // Case of
						  //  //……………………………………………………………………
						  //: ($o.type="date")
						
						  //$o.format:="dateMedium"
						
						  //  //……………………………………………………………………
						  //: ($o.type="string")\
							| ($o.type="text")
						
						  //  //$o.format:="textArea"
						
						  //  //……………………………………………………………………
						  //: ($o.type="time")
						
						  //$o.format:="hour"
						
						  //  //……………………………………………………………………
						  // Else
						
						  //  //$o.format:="dateShort"
						
						  //  //……………………………………………………………………
						  // End case
						
						  //$o.defaultField:=$o.name
						
						  //______________________________________________________
				End case 
				
				  //______________________________________________________
		End case 
		
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