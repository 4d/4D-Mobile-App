//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : DATA_Handler
  // Database: 4D Mobile App
  // ID[68574C7BCD7A4D5FA9CC3284DAEF4F51]
  // Created 25-9-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_withFocus)
C_LONGINT:C283($Lon_backgroundColor;$Lon_formEvent;$Lon_index;$Lon_parameters;$Lon_row;$Lon_size)
C_TEXT:C284($Dir_picture;$Dir_root;$File_data)
C_OBJECT:C1216($Obj_;$o;$Obj_context;$Obj_form;$Obj_in;$Obj_manifest)
C_OBJECT:C1216($Obj_out)

If (False:C215)
	C_OBJECT:C1216(DATA_Handler ;$0)
	C_OBJECT:C1216(DATA_Handler ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		$Obj_in:=$1
		
	End if 
	
	$Obj_form:=New object:C1471(\
		"window";Current form window:C827;\
		"ui";editor_INIT ;\
		"list";"01_tables";\
		"filter";"02_filter.options";\
		"queryWidget";"query.options";\
		"validate";"validate.options";\
		"enter";"enter.options";\
		"embedded";"embedded.options";\
		"method";"authenticationMethod.options";\
		"focus";OBJECT Get name:C1087(Object with focus:K67:3))
	
	$Obj_context:=$Obj_form.ui
	
	If (OB Is empty:C1297($Obj_context))
		
		$Obj_context.help:=Get localized string:C991("help_properties")
		
		  // Define form methods
		$Obj_context.listboxUI:=Formula:C1597(DATA_Handler (New object:C1471(\
			"action";"listboxUI")))
		
		$Obj_context.listBackground:=Formula:C1597(DATA_Handler (New object:C1471(\
			"action";"background")))
		
		$Obj_context.text:=Formula:C1597(DATA_Handler (New object:C1471(\
			"action";"meta-infos")))
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
Case of 
		
		  //=========================================================
	: ($Obj_in=Null:C1517)  // Form method
		
		$Lon_formEvent:=panel_Form_common (On Load:K2:1;On Timer:K2:25)
		
		Case of 
				
				  //______________________________________________________
			: ($Lon_formEvent=On Load:K2:1)
				
				  // This trick remove the horizontal gap
				OBJECT SET SCROLLBAR:C843(*;$Obj_form.list;0;2)
				
				  // Constraints definition
				$Obj_context.constraints:=New object:C1471
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.embedded);\
					"factor";1))
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.method);\
					"factor";1))
				
				DATA_Handler (New object:C1471(\
					"action";"update"))
				
				ui_BEST_SIZE (New object:C1471(\
					"widgets";New collection:C1472($Obj_form.validate);\
					"alignment";Align right:K42:4;\
					"factor";1))
				
				  // Declare check box as boolean
				EXECUTE FORMULA:C63("C_BOOLEAN:C305((OBJECT Get pointer:C1124(Object named:K67:5;\"embedded.options\"))->)")
				
				GOTO OBJECT:C206(*;$Obj_form.list)
				
				ui.tips.enable()
				
				  //______________________________________________________
			: ($Lon_formEvent=On Timer:K2:25)
				
				ui.tips.enable()
				
				  // Redraw list
				$Obj_context.tables:=$Obj_context.tables
				
				If ($Obj_context.current#Null:C1517)
					
					OBJECT SET VISIBLE:C603(*;"@.options";True:C214)
					
					OBJECT SET VISIBLE:C603(*;$Obj_form.queryWidget;Bool:C1537($Obj_form.focus=$Obj_form.filter))
					
					OBJECT SET VISIBLE:C603(*;$Obj_form.validate;False:C215)
					OBJECT SET HELP TIP:C1181(*;$Obj_form.filter;"")
					OBJECT SET RGB COLORS:C628(*;$Obj_form.filter;Foreground color:K23:1;Background color none:K23:10)
					OBJECT SET VISIBLE:C603(*;$Obj_form.embedded;True:C214)
					OBJECT SET VISIBLE:C603(*;$Obj_form.method;False:C215)
					
					OB REMOVE:C1226($Obj_context.current;"user")
					
					If (Length:C16(String:C10($Obj_context.current.filter.string))>0)
						
						$Obj_context.current.filterIcon:=ui.filter
						
						If (Bool:C1537($Obj_context.current.filter.validated))
							
							ui.tips.defaultDelay()
							
							If (Bool:C1537($Obj_context.current.filter.parameters))
								
								OBJECT SET HELP TIP:C1181(*;$Obj_form.filter;$Obj_context.current.filter.error)
								
								  // Can't embed data
								OBJECT SET VISIBLE:C603(*;$Obj_form.embedded;False:C215)
								
								  // Allow to edit the 'On Mobile App Authentification' method
								OBJECT SET VISIBLE:C603(*;$Obj_form.method;True:C214)
								
								  // Populate user icon
								$Obj_context.current.filterIcon:=ui.user
								
							End if 
							
						Else 
							
							OBJECT SET RGB COLORS:C628(*;$Obj_form.filter;ui.errorColor;Background color none:K23:10)
							
							If (Length:C16(String:C10($Obj_context.current.filter.error))>0)
								
								OBJECT SET HELP TIP:C1181(*;$Obj_form.filter;Get localized string:C991("error:")+$Obj_context.current.filter.error)
								
							Else 
								
								OBJECT SET HELP TIP:C1181(*;$Obj_form.filter;Get localized string:C991("notValidatedFilter"))
								
							End if 
							
							OBJECT SET VISIBLE:C603(*;$Obj_form.validate;True:C214)
							
						End if 
						
						If ($Obj_form.focus#$Obj_form.filter)
							
							ui.tips.instantly()
							
						End if 
						
					Else 
						
						$Obj_context.current.filterIcon:=Null:C1517
						
					End if 
					
					If (Bool:C1537($Obj_context.current.embedded))\
						 & (Not:C34(Bool:C1537($Obj_context.current.filter.parameters)))
						
						$Dir_root:=dataSet (New object:C1471("action";"path";\
							"project";New object:C1471("product";Form:C1466.product;"$project";Form:C1466.$project))).path
						
						  //If (Bool(featuresFlags._101725))
						
						$File_data:=asset (New object:C1471("action";"path";"path";$Dir_root)).path+"Data"+Folder separator:K24:12\
							+$Obj_context.current.name+".dataset"+Folder separator:K24:12+$Obj_context.current.name+".data.json"
						
						  //Else 
						  //$File_data:=$Dir_root+"JSON"+Folder separator+$Obj_context.current.name+".data.json"
						  //End if
						
						
						$Dir_picture:=$Dir_root+"Resources"
						
						If (Test path name:C476($File_data)=Is a document:K24:1)
							
							  // Get document size
							$Lon_size:=Get document size:C479($File_data)
							
							  //If (Bool(featuresFlags._101725))
							
							$Dir_picture:=asset (New object:C1471("action";"path";"path";$Dir_root)).path+"Pictures"+Folder separator:K24:12+$Obj_context.current.name+Folder separator:K24:12
							$Obj_manifest:=ob_parseDocument ($Dir_picture+"manifest.json")
							
							If ($Obj_manifest.success)
								
								$Lon_size:=$Lon_size+$Obj_manifest.value.contentSize
								
							End if 
							  //End if 
							
							$Obj_context.current.dumpSize:=doc_bytesToString ($Lon_size)
							
							  // XXX add image dump sizes
							
						Else 
							
							$Obj_context.current.dumpSize:=Get localized string:C991("#NA")
							
						End if 
						
					Else 
						
						OB REMOVE:C1226($Obj_context.current;"dumpSize")
						
					End if 
					
				Else 
					
					OBJECT SET VISIBLE:C603(*;"@.options";False:C215)
					
				End if 
				
				  //______________________________________________________
		End case 
		
		  //=========================================================
	: ($Obj_in.action=Null:C1517)  // Error
		
		ASSERT:C1129(False:C215;"Missing parameter \"action\"")
		
		  //=========================================================
	: ($Obj_in.action="init")  // Return the form objects definition
		
		$Obj_out:=$Obj_form
		
		  //=========================================================
	: ($Obj_in.action="update")  // Display published tables according to data model
		
		OBJECT SET VISIBLE:C603(*;$Obj_form.list;False:C215)
		
		$o:=publishedTableList (New object:C1471(\
			"dataModel";Form:C1466.dataModel;\
			"asCollection";True:C214))
		
		If ($o.success)
			
			$Dir_root:=dataSet (New object:C1471("action";"path";\
				"project";New object:C1471("product";Form:C1466.product;"$project";Form:C1466.$project))).path
			
			  // Populate user icons if any
			For each ($Obj_;$o.tables)
				
				$Lon_index:=$o.tables.indexOf($Obj_)
				
				If (Length:C16(String:C10($Obj_.filter.string))>0)
					
					$o.tables[$Lon_index].filterIcon:=Choose:C955(Bool:C1537($Obj_.filter.parameters);ui.user;ui.filter)
					
				End if 
				
				If (Bool:C1537($Obj_.embedded))\
					 & (Not:C34(Bool:C1537($Obj_.filter.parameters)))
					
					  //If (Bool(featuresFlags._101725))
					
					$File_data:=$Dir_root+"Resources"+Folder separator:K24:12\
						+"Assets.xcassets"+Folder separator:K24:12\
						+"Data"+Folder separator:K24:12\
						+$Obj_.name+".dataset"+Folder separator:K24:12\
						+$Obj_.name+".data.json"
					
					  //Else 
					  //$File_data:=$Dir_root+"JSON"+Folder separator+$Obj_.name+".data.json"
					  //End if 
					
					If (Test path name:C476($File_data)=Is a document:K24:1)
						
						  // Get document size
						$Lon_size:=Get document size:C479($File_data)
						
						  //If (Bool(featuresFlags._101725))
						
						$Dir_picture:=$Dir_root+"Resources"+Folder separator:K24:12\
							+"Assets.xcassets"+Folder separator:K24:12\
							+"Pictures"+Folder separator:K24:12\
							+$Obj_.name+Folder separator:K24:12
						
						$Obj_manifest:=ob_parseDocument ($Dir_picture+"manifest.json")
						
						If ($Obj_manifest.success)
							
							$Lon_size:=$Lon_size+$Obj_manifest.value.contentSize
							
						End if 
						  //End if 
						
						$o.tables[$Lon_index].dumpSize:=doc_bytesToString ($Lon_size)
						
					Else 
						
						$o.tables[$Lon_index].dumpSize:="#na"  //Get localized string("unknown")
						
					End if 
				End if 
			End for each 
			
			$Obj_context.tables:=$o.tables
			
			If (Num:C11($o.tables.length)>0)
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.list;True:C214)
				OBJECT SET VISIBLE:C603(*;"noPublishedTable";False:C215)
				GOTO OBJECT:C206(*;$Obj_form.list)
				
				  // Select the last used table or the first one if none
				$Lon_row:=Choose:C955(Num:C11($Obj_context.lastIndex)=0;1;Num:C11($Obj_context.lastIndex))
				$Lon_row:=Choose:C955($Lon_row>$o.tables.length;1;$Lon_row)
				LISTBOX SELECT ROW:C912(*;$Obj_form.list;$Lon_row;lk replace selection:K53:1)
				
			Else 
				
				$Obj_context.lastIndex:=0
				
				OBJECT SET VISIBLE:C603(*;$Obj_form.list;False:C215)
				OBJECT SET VISIBLE:C603(*;"noPublishedTable";True:C214)
				
			End if 
			
		Else 
			
			$Obj_context.lastIndex:=0
			
			OBJECT SET VISIBLE:C603(*;$Obj_form.list;False:C215)
			OBJECT SET VISIBLE:C603(*;"noPublishedTable";True:C214)
			
		End if 
		
		$Obj_context.listboxUI()
		
		  //=========================================================
	: ($Obj_in.action="background")
		
		$Obj_out:=New object:C1471
		
		If (Num:C11($Obj_context.index)#0)
			
			$Boo_withFocus:=($Obj_form.focus=$Obj_form.list)
			
			  //If (Form.$dialog.DATA.current.name=This.name)
			If ($Obj_context.current.name=This:C1470.name)
				
				$Obj_out.color:=Choose:C955($Boo_withFocus;ui.backgroundSelectedColor;ui.alternateSelectedColor)
				
			Else 
				
				$Lon_backgroundColor:=Choose:C955($Boo_withFocus;ui.highlightColor;ui.highlightColorNoFocus)
				$Obj_out.color:=Choose:C955($Boo_withFocus;$Lon_backgroundColor;0x00FFFFFF)
				
			End if 
			
		Else 
			
			$Obj_out.color:=0x00FFFFFF
			
		End if 
		
		  //=========================================================
	: ($Obj_in.action="meta-infos")
		
		$Obj_out:=New object:C1471
		
		$Obj_out.stroke:="black"  // Default
		$Obj_out.fontWeight:="normal"
		
		If (Bool:C1537(This:C1470.embedded))
			
			$Obj_out.fontWeight:="bold"
			
		End if 
		
		If (This:C1470.filter#Null:C1517)
			
			If (Length:C16(String:C10(This:C1470.filter.string))>0)
				
				If (Not:C34(Bool:C1537(This:C1470.filter.parameters)))
					
					If (Not:C34(Bool:C1537(This:C1470.filter.validated)))
						
						$Obj_out.stroke:=ui.errorRGB
						
					End if 
				End if 
			End if 
		End if 
		
		  //=========================================================
	: ($Obj_in.action="listboxUI")
		
		If ($Obj_form.focus=$Obj_form.list)\
			 & (Form event code:C388=On Getting Focus:K2:7)
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.list;Foreground color:K23:1;ui.highlightColor;ui.highlightColor)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.list+".border";ui.selectedColor;Background color none:K23:10)
			
		Else 
			
			OBJECT SET RGB COLORS:C628(*;$Obj_form.list;Foreground color:K23:1;0x00FFFFFF;0x00FFFFFF)
			OBJECT SET RGB COLORS:C628(*;$Obj_form.list+".border";ui.backgroundUnselectedColor;Background color none:K23:10)
			
		End if 
		
		  //=========================================================
	Else 
		
		ASSERT:C1129(False:C215;"Unknown entry point: \""+$Obj_in.action+"\"")
		
		  //=========================================================
End case 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End