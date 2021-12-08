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
#DECLARE($in : Object)->$out : Object

If (False:C215)
	C_OBJECT:C1216(DATA_Handler; $1)
	C_OBJECT:C1216(DATA_Handler; $0)
End if 

var $pathname; $t : Text
var $b; $withSQLlite : Boolean
var $index; $size : Integer
var $backgroundColor; $Lon_formEvent; $row : Integer
var $x : Blob
var $context; $filter; $form; $o; $table : Object
var $file : 4D:C1709.File
var $lep : cs:C1710.lep

// ----------------------------------------------------
// Initialisations
$form:=New object:C1471(\
"window"; Current form window:C827; \
"ui"; editor_Panel_init; \
"list"; "01_tables"; \
"filter"; "02_filter.options"; \
"queryWidget"; "query.options"; \
"validate"; "validate.options"; \
"enter"; "enter.options"; \
"embedded"; "embedded.options"; \
"method"; "authenticationMethod.options"; \
"focus"; OBJECT Get name:C1087(Object with focus:K67:3); \
"result"; "result")

$context:=$form.ui

If (OB Is empty:C1297($context))
	
	$context.help:=Get localized string:C991("help_properties")
	
	// Define form methods
	$context.listboxUI:=Formula:C1597(DATA_Handler(New object:C1471(\
		"action"; "listboxUI")))
	
	$context.listBackground:=Formula:C1597(DATA_Handler(New object:C1471(\
		"action"; "background"; \
		"this"; $1)))
	
	$context.text:=Formula:C1597(DATA_Handler(New object:C1471(\
		"action"; "meta-infos"; \
		"this"; $1)))
	
	$context.dumpSizes:=Formula:C1597(DATA_Handler(New object:C1471(\
		"action"; "dumpSizes")))
	
	$context.refresh:=Formula:C1597(SET TIMER:C645(-1))
	
	$context.update:=Formula:C1597(DATA_Handler(New object:C1471(\
		"action"; "update")))
	
End if 

// Mark: WORK IN PROGRESS
//$cs:=cs.DATA.new()

// ----------------------------------------------------
Case of 
		
		//=========================================================
	: ($in=Null:C1517)  // Form method
		
		$Lon_formEvent:=_o_panel_Form_common(On Load:K2:1; On Timer:K2:25)
		
		Case of 
				
				//______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				If (Not:C34(FEATURE.with("cancelableDatasetGeneration")))
					
					OBJECT SET COORDINATES:C1248(*; $form.method; 486; 104; 486+330; 104+22)
					_o_UI.tips.enable()
					
				End if 
				
				// This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*; $form.list; 0; 2)
				
				// Constraints definition
				$context.constraints:=New object:C1471
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.embedded); \
					"factor"; 1))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.method); \
					"factor"; 1))
				
				_o_ui_BEST_SIZE(New object:C1471(\
					"widgets"; New collection:C1472($form.validate); \
					"alignment"; Align right:K42:4; \
					"factor"; 1))
				
				If ($context.tables=Null:C1517)\
					 | (Num:C11(($context.tables.length))=0)
					
					$context.tables:=PROJECT.publishedTables()
					
					PROJECT.checkLocalQueryFilter($table)
					
				End if 
				
				$context.update()
				
				GOTO OBJECT:C206(*; $form.list)
				
				//______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				// _o_UI.tips.enable()
				
				//$cs.update()
				
				androidLimitations(False:C215; "")
				
				var $table : Object
				$table:=$context.current
				
				If ($table#Null:C1517)
					
					OBJECT SET VISIBLE:C603(*; "@.options"; True:C214)
					
					OBJECT SET VISIBLE:C603(*; $form.queryWidget; Bool:C1537($form.focus=$form.filter))
					
					OBJECT SET VISIBLE:C603(*; $form.validate; String:C10($table.filter.string)#"")
					OBJECT SET VISIBLE:C603(*; $form.method; False:C215)
					OBJECT SET VISIBLE:C603(*; $form.embedded; True:C214)
					
					OBJECT SET RGB COLORS:C628(*; $form.filter; Foreground color:K23:1)
					
					OB REMOVE:C1226($table; "user")
					
					var $Comment : Text
					OBJECT SET VISIBLE:C603(*; $form.result; FEATURE.with("cancelableDatasetGeneration"))
					OBJECT SET RGB COLORS:C628(*; $form.result; EDITOR.selectedFillColor)
					
					$filter:=$table.filter
					
					Case of 
							
							//______________________________________________________
						: (Length:C16(String:C10($filter.string))=0)  // No filter
							
							$table.filterIcon:=Null:C1517
							
							If ($table.total=Null:C1517)
								
								If (PROJECT.dataSource.source="server")
									
									var $rest : Object
									$rest:=Rest(New object:C1471(\
										"action"; "records"; \
										"table"; $table.name; \
										"url"; This:C1470.server.urls.production; \
										"handler"; "mobileapp"))
									
									If ($rest.success)
										
										If ($rest.__COUNT#Null:C1517)
											
											$table.total:=Num:C11($rest.__COUNT)
											
										End if 
									End if 
									
								Else 
									
									$table.total:=ds:C1482[$table.name].all().length
									
								End if 
							End if 
							
							If ($table.total=Null:C1517)
								
								If (Bool:C1537($table.embedded))
									
									$Comment:=EDITOR.str.setText("allDataEmbedded").localized()
									
								Else 
									
									$Comment:=EDITOR.str.setText("allDataLoaded").localized()
									
								End if 
								
							Else 
								
								If ($table.total=0)
									
									If (Bool:C1537($table.embedded))
										
										$Comment:=EDITOR.str.setText("noEntityToEmbed").localized()
										
									Else 
										
										$Comment:=EDITOR.str.setText("noEntityToLoad").localized()
										
									End if 
									
								Else 
									
									If ($table.total>100000)
										
										If (Bool:C1537($table.embedded))
											
											$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToEmbed").localized()
											
										Else 
											
											$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToLoad").localized()
											
										End if 
										
									Else 
										
										If (Bool:C1537($table.embedded))
											
											$Comment:=EDITOR.str.setText("entitiesToEmbed").localized(String:C10($table.total; "### ###"))
											
										Else 
											
											$Comment:=EDITOR.str.setText("entitiesToLoad").localized(String:C10($table.total; "### ###"))
											
										End if 
									End if 
								End if 
							End if 
							
							//______________________________________________________
						: (Length:C16(String:C10($filter.error))>0)  // With errors
							
							OBJECT SET RGB COLORS:C628(*; $form.filter; EDITOR.errorColor)
							OBJECT SET RGB COLORS:C628(*; $form.result; EDITOR.errorColor)
							
							$Comment:=EDITOR.str.setText("error:").localized()+$filter.error
							
							//______________________________________________________
						: (Not:C34(Bool:C1537($filter.validated)))  // Not validated
							
							OBJECT SET RGB COLORS:C628(*; $form.filter; EDITOR.errorColor)
							OBJECT SET RGB COLORS:C628(*; $form.result; EDITOR.errorColor)
							
							$Comment:=EDITOR.str.setText("notValidatedFilter").localized()
							
							//______________________________________________________
						Else 
							
							$filter.parameters:=(Match regex:C1019("(?m-si)(?:=|==|===|IS|!=|#|!==|IS NOT|>|<|>=|<=|%)\\s*:"; $filter.string; 1))
							
							If (Bool:C1537($filter.parameters))
								
								$table.filterIcon:=EDITOR.userIcon
								
								OBJECT SET VISIBLE:C603(*; $form.embedded; False:C215)
								OBJECT SET VISIBLE:C603(*; $form.method; True:C214)
								
								$Comment:=EDITOR.str.setText("dataFilteringByUser").localized()
								
							Else 
								
								If ($table.count=Null:C1517)
									
									If (Bool:C1537($table.embedded))
										
										$Comment:=EDITOR.str.setText("dataEmbedded").localized()
										
									Else 
										
										$Comment:=EDITOR.str.setText("dataLoaded").localized()
										
									End if 
									
								Else 
									
									If ($table.count=0)
										
										If (Bool:C1537($table.embedded))
											
											$Comment:=EDITOR.str.setText("noEntityToEmbed").localized()
											
										Else 
											
											$Comment:=EDITOR.str.setText("noEntityToLoad").localized()
											
										End if 
										
									Else 
										
										If (Bool:C1537($table.embedded))
											
											If ($table.count>100000)
												
												$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToEmbed").localized()
												
											Else 
												
												$Comment:=EDITOR.str.setText("entitiesEmbeddedUponConnection").localized(New collection:C1472(String:C10($table.count; "### ###"); String:C10($table.total; "### ### ### ### ###")))
												
											End if 
											
										Else 
											
											If ($table.count>100000)
												
												$Comment:=EDITOR.str.setText("largeNumberOfEntitiesToLoad").localized()
												
											Else 
												
												$Comment:=EDITOR.str.setText("entitiesLoadedUponConnection").localized(New collection:C1472(String:C10($table.count; "### ###"); String:C10($table.total; "### ### ### ### ###")))
												
											End if 
										End if 
									End if 
								End if 
							End if 
							
							//______________________________________________________
					End case 
					
					OBJECT SET VALUE:C1742("result"; $Comment)
					
				Else 
					
					OBJECT SET VISIBLE:C603(*; "@.options"; False:C215)
					
				End if 
				
				// Redraw list
				$context.tables:=$context.tables
				
				//______________________________________________________
		End case 
		
		//=========================================================
	: ($in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215; "Missing parameter \"action\"")
		
		//=========================================================
	: ($in.action="init")  // Return the form objects definition
		
		$out:=$form
		
		//=========================================================
	: ($in.action="dumpSizes")  // Get the dump size if available
		
		$context.sqlite:=Null:C1517
		
		$pathname:=dataSet(New object:C1471("action"; "path"; \
			"project"; New object:C1471("product"; Form:C1466.product; "$project"; Form:C1466.$project))).path
		
		$file:=Folder:C1567($pathname; fk platform path:K87:2).file("Resources/Structures.sqlite")
		
		If ($file.exists)
			
			$lep:=cs:C1710.lep.new()\
				.setOutputType(Is object:K8:27)\
				.launch(cs:C1710.path.new().scripts().file("sqlite3_sizes.sh"); "'"+$file.path+"'")
			
			If ($lep.success)
				
				$context.sqlite:=$lep.outputStream
				
			End if 
		End if 
		
		//=========================================================
	: ($in.action="update")  // Display published tables according to data model
		
		// Update the table list if any
		var $c : Collection
		$c:=PROJECT.publishedTables()
		
		If ($c.length>0)
			
			For each ($table; $c)
				
				If ($context.tables.query("tableNumber = :1"; Num:C11($table.tableNumber)).pop()=Null:C1517)
					
					// Add the table
					$context.tables.push($table)
					
				End if 
			End for each 
			
			For each ($table; $context.tables)
				
				If ($c.query("tableNumber = :1"; Num:C11($table.tableNumber)).pop()=Null:C1517)
					
					// Mark to remove
					$table.toRemove:=True:C214
					
				End if 
			End for each 
			
			$context.tables:=$context.tables.query("toRemove = null")
			
		Else 
			
			$context.tables:=New collection:C1472
			
		End if 
		
		$context.dumpSizes()
		
		OBJECT SET VISIBLE:C603(*; $form.list; False:C215)
		
		If ($context.tables.length>0)
			
			$pathname:=dataSet(New object:C1471("action"; "path"; \
				"project"; New object:C1471("product"; Form:C1466.product; "$project"; Form:C1466.$project))).path
			
			// Populate user icons if any
			For each ($table; $context.tables)
				
				$index:=$context.tables.indexOf($table)
				
				If (Length:C16(String:C10($table.filter.string))>0)
					
					$context.tables[$index].filterIcon:=Choose:C955(Bool:C1537($table.filter.parameters); EDITOR.userIcon; EDITOR.filterIcon)
					
				End if 
				
				If (Bool:C1537($table.embedded))\
					 & (Not:C34(Bool:C1537($table.filter.parameters)))
					
					$withSQLlite:=($context.sqlite#Null:C1517)
					
					If ($withSQLlite)
						
						$t:=formatString("table-name"; $table.name)
						
						If ($context.sqlite.tables["Z"+Uppercase:C13($t)]#Null:C1517)
							
							$size:=$context.sqlite.tables["Z"+Uppercase:C13($t)]  // Size of the data dump
							
							If ($size>4096)
								
								// Add pictures size if any
								$file:=Folder:C1567(asset(New object:C1471(\
									"action"; "path"; \
									"path"; $pathname)).path+"Pictures"+Folder separator:K24:12+$t+Folder separator:K24:12; \
									fk platform path:K87:2).file("manifest.json")
								
								If ($file.exists)
									
									$size:=$size+JSON Parse:C1218($file.getText()).contentSize
									
								End if 
								
							Else 
								
							End if 
							
						Else 
							
							$context.tables[$index].dumpSize:=Get localized string:C991("notAvailable")
							
						End if 
						
					Else 
						
						$withSQLlite:=False:C215
						
					End if 
					
					If (Not:C34($withSQLlite))
						
						$file:=Folder:C1567($pathname; fk platform path:K87:2).file("Resources/Assets.xcassets/Data/"+$table.name+".dataset/"+$table.name+".data.json")
						
						If ($file.exists)
							
							// Get document size
							$x:=$file.getContent()
							$size:=BLOB size:C605($x)
							SET BLOB SIZE:C606($x; 0)
							
							$file:=Folder:C1567($pathname; fk platform path:K87:2).file("Resources/Assets.xcassets/Pictures/"+$table.name+"/manifest.json")
							
							If ($file.exists)
								
								$size:=$size+JSON Parse:C1218($file.getText()).contentSize
								
							End if 
							
						Else 
							
							$context.tables[$index].dumpSize:=Get localized string:C991("notAvailable")
							
						End if 
					End if 
				End if 
			End for each 
			
			If (Num:C11($context.tables.length)>0)
				
				OBJECT SET VISIBLE:C603(*; $form.list; True:C214)
				OBJECT SET VISIBLE:C603(*; "noPublishedTable"; False:C215)
				GOTO OBJECT:C206(*; $form.list)
				
				// Select the last used table or the first one if none
				$row:=Choose:C955(Num:C11($context.lastIndex)=0; 1; Num:C11($context.lastIndex))
				$row:=Choose:C955($row>$context.tables.length; 1; $row)
				LISTBOX SELECT ROW:C912(*; $form.list; $row; lk replace selection:K53:1)
				
				OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; $context.tables.query("embedded=:1"; True:C214).length>0)
				
			Else 
				
				$context.lastIndex:=0
				
				OBJECT SET VISIBLE:C603(*; $form.list; False:C215)
				OBJECT SET VISIBLE:C603(*; "noPublishedTable"; True:C214)
				
				OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; False:C215)
				
			End if 
			
		Else 
			
			$context.lastIndex:=0
			
			OBJECT SET VISIBLE:C603(*; $form.list; False:C215)
			OBJECT SET VISIBLE:C603(*; "noPublishedTable"; True:C214)
			
			OBJECT SET VISIBLE:C603(*; "01_tables.embeddedLabel"; False:C215)
			
		End if 
		
		// Redraw list
		$context.tables:=$context.tables
		
		$context.listboxUI()
		
		SET TIMER:C645(-1)
		
		//=========================================================
	: ($in.action="background")
		
		$out:=New object:C1471(\
			"color"; "transparent")  //0x00FFFFFF)
		
		If (Num:C11($context.index)#0)
			
			$b:=($form.focus=$form.list)
			
			If ($context.current.name=$in.this.name)
				
				$out.color:=Choose:C955($b; EDITOR.backgroundSelectedColor; EDITOR.alternateSelectedColor)
				
			Else 
				
				$backgroundColor:=Choose:C955($b; EDITOR.highlightColor; EDITOR.highlightColorNoFocus)
				$out.color:=Choose:C955($b; $backgroundColor; "transparent")  //0x00FFFFFF)
				
			End if 
		End if 
		
		//=========================================================
	: ($in.action="meta-infos")  // Table list meta info expression
		
		// Default values
		$out:=New object:C1471(\
			"stroke"; Choose:C955(EDITOR.isDark; "white"; "black"); \
			"fontWeight"; "normal"; \
			"cell"; New object:C1471(\
			"table_names"; New object:C1471))
		
		If (Bool:C1537(This:C1470.embedded))
			
			$out.cell.table_names.fontWeight:="bold"
			
		End if 
		
		If (This:C1470.filter#Null:C1517)
			
			If (Length:C16(String:C10(This:C1470.filter.string))>0)
				
				If (Not:C34(Bool:C1537(This:C1470.filter.validated)))
					
					$out.cell.table_names.stroke:=EDITOR.errorRGB
					
				End if 
			End if 
		End if 
		
		//=========================================================
	: ($in.action="listboxUI")
		
		If ($form.focus=$form.list)
			
			OBJECT SET RGB COLORS:C628(*; $form.list; Foreground color:K23:1; EDITOR.highlightColor; EDITOR.highlightColor)
			OBJECT SET RGB COLORS:C628(*; $form.list+".border"; EDITOR.selectedColor)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*; $form.list; Foreground color:K23:1; 0x00FFFFFF; 0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*; $form.list+".border"; EDITOR.backgroundUnselectedColor)
			
		End if 
		
		//=========================================================
	Else 
		
		ASSERT:C1129(False:C215; "Unknown entry point: \""+$in.action+"\"")
		
		//=========================================================
End case 