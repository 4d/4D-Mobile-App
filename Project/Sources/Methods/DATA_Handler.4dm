//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : DATA_Handler
// ID[68574C7BCD7A4D5FA9CC3284DAEF4F51]
// Created 25-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BLOB:C604($x)
C_BOOLEAN:C305($b; $Boo_sqllite)
C_LONGINT:C283($Lon_backgroundColor; $Lon_formEvent; $Lon_index; $Lon_parameters; $Lon_row; $Lon_size)
C_TEXT:C284($Dir_root; $t)
C_OBJECT:C1216($file; $o; $Obj_context; $Obj_form; $Obj_in; $Obj_out)
C_OBJECT:C1216($Obj_table)

If (False:C215)
	C_OBJECT:C1216(DATA_Handler; $0)
	C_OBJECT:C1216(DATA_Handler; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	// NO PARAMETERS REQUIRED
	
	// Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window"; Current form window:C827; \
		"ui"; editor_Panel_init; \
		"list"; "01_tables"; \
		"filter"; "02_filter.options"; \
		"queryWidget"; "query.options"; \
		"validate"; "validate.options"; \
		"enter"; "enter.options"; \
		"embedded"; "embedded.options"; \
		"method"; "authenticationMethod.options"; \
		"focus"; OBJECT Get name:C1087(Object with focus:K67:3))
	
	$Obj_context:=$Obj_form.ui
	
	If (OB Is empty:C1297($Obj_context))\
		 | (Structure file:C489=Structure file:C489(*))
		
		$Obj_context.help:=Get localized string:C991("help_properties")
		
		// Define form methods
		$Obj_context.listboxUI:=Formula:C1597(DATA_Handler(New object:C1471(\
			"action"; "listboxUI")))
		
		$Obj_context.listBackground:=Formula:C1597(DATA_Handler(New object:C1471(\
			"action"; "background"; \
			"this"; $1)))
		
		$Obj_context.text:=Formula:C1597(DATA_Handler(New object:C1471(\
			"action"; "meta-infos")))
		
		$Obj_context.dumpSizes:=Formula:C1597(DATA_Handler(New object:C1471(\
			"action"; "dumpSizes")))
		
		$Obj_context.refresh:=Formula:C1597(SET TIMER:C645(-1))
		
		$Obj_context.update:=Formula:C1597(DATA_Handler(New object:C1471(\
			"action"; "update")))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				// This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*; $Obj_form.list; 0; 2)
				
				// Constraints definition
				$Obj_context.constraints:=New object:C1471
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.embedded); \
					"factor"; 1))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.method); \
					"factor"; 1))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($Obj_form.validate); \
					"alignment"; Align right:K42:4; \
					"factor"; 1))
				
				$Obj_context.update()
				
				GOTO OBJECT:C206(*; $Obj_form.list)
				
				UI.tips.enable()
				
				//______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				UI.tips.enable()
				
				androidLimitations(False:C215; "")
				
				If ($Obj_context.current#Null:C1517)
					
					OBJECT SET VISIBLE:C603(*; "@.options"; True:C214)
					
					OBJECT SET VISIBLE:C603(*; $Obj_form.queryWidget; Bool:C1537($Obj_form.focus=$Obj_form.filter))
					
					OBJECT SET VISIBLE:C603(*; $Obj_form.validate; False:C215)
					OBJECT SET HELP TIP:C1181(*; $Obj_form.filter; "")
					OBJECT SET RGB COLORS:C628(*; $Obj_form.filter; Foreground color:K23:1; Background color none:K23:10)
					OBJECT SET VISIBLE:C603(*; $Obj_form.embedded; True:C214)
					OBJECT SET VISIBLE:C603(*; $Obj_form.method; False:C215)
					
					OB REMOVE:C1226($Obj_context.current; "user")
					
					If (Length:C16(String:C10($Obj_context.current.filter.string))>0)
						
						$Obj_context.current.filterIcon:=EDITOR.filterIcon
						
						If (Bool:C1537($Obj_context.current.filter.validated))
							
							UI.tips.defaultDelay()
							
							If (Bool:C1537($Obj_context.current.filter.parameters))
								
								OBJECT SET HELP TIP:C1181(*; $Obj_form.filter; $Obj_context.current.filter.error)
								
								// Can't embed data
								OBJECT SET VISIBLE:C603(*; $Obj_form.embedded; False:C215)
								
								// Allow to edit the 'On Mobile App Authentification' method
								OBJECT SET VISIBLE:C603(*; $Obj_form.method; True:C214)
								
								// Populate user icon
								$Obj_context.current.filterIcon:=EDITOR.userIcon
								
							End if 
							
						Else 
							
							OBJECT SET RGB COLORS:C628(*; $Obj_form.filter; EDITOR.errorColor; Background color none:K23:10)
							
							If (Length:C16(String:C10($Obj_context.current.filter.error))>0)
								
								OBJECT SET HELP TIP:C1181(*; $Obj_form.filter; Get localized string:C991("error:")+$Obj_context.current.filter.error)
								
							Else 
								
								OBJECT SET HELP TIP:C1181(*; $Obj_form.filter; Get localized string:C991("notValidatedFilter"))
								
							End if 
							
							OBJECT SET VISIBLE:C603(*; $Obj_form.validate; True:C214)
							
						End if 
						
						If ($Obj_form.focus#$Obj_form.filter)
							
							UI.tips.instantly()
							
						End if 
						
					Else 
						
						$Obj_context.current.filterIcon:=Null:C1517
						
					End if 
					
				Else 
					
					OBJECT SET VISIBLE:C603(*; "@.options"; False:C215)
					
				End if 
				
				// Redraw list
				$Obj_context.tables:=$Obj_context.tables
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		//=========================================================
	: ($Obj_in.action="dumpSizes")  // Get the dump size if available
		
		$Obj_context.sqlite:=Null:C1517
		
		
		//If (FEATURE.with("android"))
		
		//$Dir_root:=dataSet(New object("action"; "path"; \
																																																									"project"; New object("product"; Form.product; "$project"; PROJECT))).path
		
		//Else
		
		$Dir_root:=dataSet(New object:C1471("action"; "path"; \
			"project"; New object:C1471("product"; Form:C1466.product; "$project"; Form:C1466.$project))).path
		
		//End if
		
		
		
		$file:=Folder:C1567($Dir_root; fk platform path:K87:2).file("Resources/Structures.sqlite")
		
		If ($file.exists)
			
			$o:=cs:C1710.lep.new()\
				.setOutputType(Is object:K8:27)\
				.launch(cs:C1710.path.new().scripts().file("sqlite3_sizes.sh"); $file.path)
			
			If ($o.success)
				
				$Obj_context.sqlite:=$o.outputStream
				
			End if 
		End if 
		
		//=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		$Obj_context.dumpSizes()
		
		OBJECT SET VISIBLE:C603(*; $Obj_form.list; False:C215)
		
		$o:=publishedTableList(New object:C1471(\
			"dataModel"; Form:C1466.dataModel; \
			"asCollection"; True:C214))
		
		If ($o.success)
			
			$Dir_root:=dataSet(New object:C1471("action"; "path"; \
				"project"; New object:C1471("product"; Form:C1466.product; "$project"; Form:C1466.$project))).path
			
			// Populate user icons if any
			For each ($Obj_table; $o.tables)
				
				$Lon_index:=$o.tables.indexOf($Obj_table)
				
				If (Length:C16(String:C10($Obj_table.filter.string))>0)
					
					$o.tables[$Lon_index].filterIcon:=Choose:C955(Bool:C1537($Obj_table.filter.parameters); EDITOR.userIcon; EDITOR.filterIcon)
					
				End if 
				
				If (Bool:C1537($Obj_table.embedded))\
					 & (Not:C34(Bool:C1537($Obj_table.filter.parameters)))
					
					$Boo_sqllite:=($Obj_context.sqlite#Null:C1517)
					
					If ($Boo_sqllite)
						
						$t:=formatString("table-name"; $Obj_table.name)
						
						If ($Obj_context.sqlite.tables["Z"+Uppercase:C13($t)]#Null:C1517)
							
							$Lon_size:=$Obj_context.sqlite.tables["Z"+Uppercase:C13($t)]  // Size of the data dump
							
							If ($Lon_size>4096)
								
								// Add pictures size if any
								$file:=Folder:C1567(asset(New object:C1471("action"; "path"; "path"; $Dir_root)).path+"Pictures"+Folder separator:K24:12+$t+Folder separator:K24:12; fk platform path:K87:2).file("manifest.json")
								
								If ($file.exists)
									
									$Lon_size:=$Lon_size+JSON Parse:C1218($file.getText()).contentSize
									
								End if 
								
								$o.tables[$Lon_index].dumpSize:=doc_bytesToString($Lon_size)
								
							Else 
								
								$o.tables[$Lon_index].dumpSize:=Choose:C955($Lon_size>0; "< "+doc_bytesToString($Lon_size); Get localized string:C991("notAvailable"))
								
							End if 
							
						Else 
							
							$o.tables[$Lon_index].dumpSize:=Get localized string:C991("notAvailable")
							
						End if 
						
					Else 
						
						$Boo_sqllite:=False:C215
						
					End if 
					
					If (Not:C34($Boo_sqllite))
						
						$file:=Folder:C1567($Dir_root; fk platform path:K87:2).file("Resources/Assets.xcassets/Data/"+$Obj_table.name+".dataset/"+$Obj_table.name+".data.json")
						
						If ($file.exists)
							
							// Get document size
							$x:=$file.getContent()
							$Lon_size:=BLOB size:C605($x)
							SET BLOB SIZE:C606($x; 0)
							
							$file:=Folder:C1567($Dir_root; fk platform path:K87:2).file("Resources/Assets.xcassets/Pictures/"+$Obj_table.name+"/manifest.json")
							
							If ($file.exists)
								
								$Lon_size:=$Lon_size+JSON Parse:C1218($file.getText()).contentSize
								
							End if 
							
							$o.tables[$Lon_index].dumpSize:=doc_bytesToString($Lon_size)
							
						Else 
							
							$o.tables[$Lon_index].dumpSize:=Get localized string:C991("notAvailable")
							
						End if 
					End if 
				End if 
			End for each 
			
			$Obj_context.tables:=$o.tables
			
			If (Num:C11($o.tables.length)>0)
				
				OBJECT SET VISIBLE:C603(*; $Obj_form.list; True:C214)
				OBJECT SET VISIBLE:C603(*; "noPublishedTable"; False:C215)
				GOTO OBJECT:C206(*; $Obj_form.list)
				
				// Select the last used table or the first one if none
				$Lon_row:=Choose:C955(Num:C11($Obj_context.lastIndex)=0; 1; Num:C11($Obj_context.lastIndex))
				$Lon_row:=Choose:C955($Lon_row>$o.tables.length; 1; $Lon_row)
				LISTBOX SELECT ROW:C912(*; $Obj_form.list; $Lon_row; lk replace selection:K53:1)
				
				OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; $o.tables.query("embedded=:1"; True:C214).length>0)
				
			Else 
				
				$Obj_context.lastIndex:=0
				
				OBJECT SET VISIBLE:C603(*; $Obj_form.list; False:C215)
				OBJECT SET VISIBLE:C603(*; "noPublishedTable"; True:C214)
				
				OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; False:C215)
				
			End if 
			
		Else 
			
			$Obj_context.lastIndex:=0
			
			OBJECT SET VISIBLE:C603(*; $Obj_form.list; False:C215)
			OBJECT SET VISIBLE:C603(*; "noPublishedTable"; True:C214)
			
			OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; False:C215)
			
		End if 
		
		// Redraw list
		$Obj_context.tables:=$Obj_context.tables
		
		$Obj_context.listboxUI()
		
		SET TIMER:C645(-1)
		
		//=========================================================
	: ($Obj_in.action="background")
		
		$Obj_out:=New object:C1471(\
			"color"; "transparent")  //0x00FFFFFF)
		
		If (Num:C11($Obj_context.index)#0)
			
			$b:=($Obj_form.focus=$Obj_form.list)
			
			If ($Obj_context.current.name=$Obj_in.this.name)
				
				$Obj_out.color:=Choose:C955($b; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
				
			Else 
				
				$Lon_backgroundColor:=Choose:C955($b; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
				$Obj_out.color:=Choose:C955($b; $Lon_backgroundColor; "transparent")  //0x00FFFFFF)
				
			End if 
		End if 
		
		//=========================================================
	: ($Obj_in.action="meta-infos")
		
		$Obj_out:=New object:C1471
		
		$Obj_out.stroke:=Choose:C955(EDITOR.isDark; "white"; "black")  // Default
		$Obj_out.fontWeight:="normal"
		
		If (Bool:C1537(This:C1470.embedded))
			
			$Obj_out.fontWeight:="bold"
			
		End if 
		
		If (This:C1470.filter#Null:C1517)
			
			If (Length:C16(String:C10(This:C1470.filter.string))>0)
				
				If (Not:C34(Bool:C1537(This:C1470.filter.parameters)))
					
					If (Not:C34(Bool:C1537(This:C1470.filter.validated)))
						
						$Obj_out.stroke:=EDITOR.errorRGB
						
					End if 
				End if 
			End if 
		End if 
		
		//=========================================================
	: ($Obj_in.action="listboxUI")
		
		If ($Obj_form.focus=$Obj_form.list)
			
			OBJECT SET RGB COLORS:C628(*; $Obj_form.list; Foreground color:K23:1; EDITOR.highlightColor; EDITOR.highlightColor)
			OBJECT SET RGB COLORS:C628(*; $Obj_form.list+".border"; EDITOR.selectedColor)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; $Obj_form.list; Foreground color:K23:1; 0x00FFFFFF; 0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*; $Obj_form.list+".border"; EDITOR.backgroundUnselectedColor)
			
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$Obj_in.action+"\"")
		
		//=========================================================
End case 

// ----------------------------------------------------
// Return
If ($Obj_out#Null:C1517)
	
	$0:=$Obj_out
	
End if 

// ----------------------------------------------------
// End