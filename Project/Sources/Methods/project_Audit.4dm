//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_Audit
  // ID[93767D0FCF2340DB88335AB3B117AA44]
  // Created 24-8-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_OK)
C_TEXT:C284($t;$tt;$Txt_fieldNumber;$Txt_tableNumber)
C_OBJECT:C1216($file;$Obj_audit;$Obj_context;$Obj_dataModel;$Obj_detail;$Obj_in)
C_OBJECT:C1216($Obj_list;$Path_detailForms;$Path_fieldIcons;$Path_formaters;$Path_listForms;$Path_tableIcons)
C_OBJECT:C1216($Path_template)

If (False:C215)
	C_OBJECT:C1216(project_Audit ;$0)
	C_OBJECT:C1216(project_Audit ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Default values
	$Obj_audit:=New object:C1471(\
		"success";True:C214;\
		"errors";New collection:C1472)
	
	$Obj_context:=New object:C1471(\
		"list";True:C214;\
		"detail";True:C214;\
		"icons";True:C214;\
		"formatters";True:C214;\
		"filters";True:C214)
	
	  // Allow passing value for test purpose. Normal behaviour is form
	$Obj_dataModel:=Choose:C955(Value type:C1509($Obj_in.dataModel)=Is object:K8:27;$Obj_in.dataModel;Form:C1466.dataModel)
	$Obj_list:=Choose:C955(Value type:C1509($Obj_in.list)=Is object:K8:27;$Obj_in.list;Form:C1466.list)
	$Obj_detail:=Choose:C955(Value type:C1509($Obj_in.detail)=Is object:K8:27;$Obj_in.detail;Form:C1466.detail)
	
	If ($Obj_in.target#Null:C1517)
		
		$Obj_context.list:=($Obj_in.target.indexOf("lists")#-1)
		$Obj_context.detail:=($Obj_in.target.indexOf("details")#-1)
		$Obj_context.icons:=($Obj_in.target.indexOf("icons")#-1)
		$Obj_context.formatters:=($Obj_in.target.indexOf("formatters")#-1)
		$Obj_context.filters:=($Obj_in.target.indexOf("filters")#-1)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_dataModel#Null:C1517)
	
	  // Load manifest values
	$file:=COMPONENT_Pathname ("listForms").file("manifest.json")
	
	If ($file.exists)
		
		$Obj_context.listManifest:=JSON Parse:C1218($file.getText())
		
	End if 
	
	$file:=COMPONENT_Pathname ("detailForms").file("manifest.json")
	
	If ($file.exists)
		
		$Obj_context.detailManifest:=JSON Parse:C1218($file.getText())
		
	End if 
	
	$Path_listForms:=COMPONENT_Pathname ("host_listForms")
	$Path_detailForms:=COMPONENT_Pathname ("host_detailForms")
	$Path_tableIcons:=COMPONENT_Pathname ("host_tableIcons")
	$Path_fieldIcons:=COMPONENT_Pathname ("host_fieldIcons")
	$Path_formaters:=COMPONENT_Pathname ("host_formatters")
	
	For each ($Txt_tableNumber;$Obj_dataModel)
		
		If ($Obj_context.list)
			
			$t:=String:C10($Obj_list[$Txt_tableNumber].form)
			
			If (Position:C15("/";$t)=1)
				
				$t:=Delete string:C232($t;1;1)
				
				$Path_template:=$Path_listForms.folder($t)
				$Boo_OK:=$Path_template.exists
				
				If ($Boo_OK)
					
					For each ($tt;$Obj_context.listManifest.mandatory) While ($Boo_OK)
						
						$Boo_OK:=$Path_template.file($tt).exists
						
					End for each 
					
					If (Not:C34($Boo_OK))
						
						  //======================================================
						  //                   INVALID TEMPLATE
						  //======================================================
						
						$Obj_audit.success:=False:C215
						$Obj_audit.errors.push(New object:C1471(\
							"type";"template";\
							"tab";"list";\
							"message";str ("theTemplateIsInvalid").localized($t);\
							"table";$Txt_tableNumber))
						
					End if 
					
				Else 
					
					  //======================================================
					  //                   MISSING TEMPLATE
					  //======================================================
					
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"list";\
						"message";str ("theTemplateIsMissing").localized($t);\
						"table";$Txt_tableNumber))
					
				End if 
			End if 
		End if 
		
		If ($Obj_context.detail)
			
			$t:=String:C10($Obj_detail[$Txt_tableNumber].form)
			
			If (Position:C15("/";$t)=1)
				
				$t:=Delete string:C232($t;1;1)
				
				$Path_template:=$Path_detailForms.folder($t)
				$Boo_OK:=$Path_template.exists
				
				If ($Boo_OK)
					
					For each ($tt;$Obj_context.detailManifest.mandatory) While ($Boo_OK)
						
						$Boo_OK:=$Path_template.file($tt).exists
						
					End for each 
					
					If (Not:C34($Boo_OK))
						
						  //======================================================
						  //                   INVALID TEMPLATE
						  //======================================================
						
						$Obj_audit.success:=False:C215
						$Obj_audit.errors.push(New object:C1471(\
							"type";"template";\
							"tab";"detail";\
							"message";str ("theTemplateIsInvalid").localized($t);\
							"table";$Txt_tableNumber))
						
					End if 
					
				Else 
					
					  //======================================================
					  //                   MISSING TEMPLATE
					  //======================================================
					
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"detail";\
						"message";str ("theTemplateIsMissing").localized($t);\
						"table";$Txt_tableNumber))
					
				End if 
			End if 
		End if 
		
		If ($Obj_context.icons)
			
			$t:=String:C10($Obj_dataModel[$Txt_tableNumber].icon)
			
			If (Position:C15("/";$t)=1)  // Host database resources
				
				$Boo_OK:=$Path_tableIcons.file(Delete string:C232($t;1;1)).exists
				
				If (Not:C34($Boo_OK))
					
					  //======================================================
					  //                  MISSING TABLE ICON
					  //======================================================
					
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"icon";\
						"panel";"TABLES";\
						"message";str ("theTableIconIsMissing").localized(Delete string:C232($t;1;1));\
						"table";$Txt_tableNumber;\
						"tab";"tableProperties"))
					
				End if 
			End if 
			
			For each ($Txt_fieldNumber;$Obj_dataModel[$Txt_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))
					
					$t:=String:C10($Obj_dataModel[$Txt_tableNumber][$Txt_fieldNumber].icon)
					
					If (Position:C15("/";$t)=1)  // Host resources
						
						$Boo_OK:=$Path_fieldIcons.file(Delete string:C232($t;1;1)).exists
						
						If (Not:C34($Boo_OK))
							
							  //======================================================
							  //                  MISSING FIELD ICON
							  //======================================================
							
							$Obj_audit.success:=False:C215
							$Obj_audit.errors.push(New object:C1471(\
								"type";"icon";\
								"panel";"TABLES";\
								"message";str ("theFieldIconIsMissing").localized(Delete string:C232($t;1;1));\
								"table";$Txt_tableNumber;\
								"field";$Txt_fieldNumber))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($Obj_context.formatters)
			
			For each ($Txt_fieldNumber;$Obj_dataModel[$Txt_tableNumber])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))
					
					$t:=String:C10($Obj_dataModel[$Txt_tableNumber][$Txt_fieldNumber].format)
					
					If (Position:C15("/";$t)=1)  // Host resources
						
						$Boo_OK:=$Path_formaters.folder(Delete string:C232($t;1;1)).exists\
							 & $Path_formaters.folder(Delete string:C232($t;1;1)).file("manifest.json").exists
						
						If (Not:C34($Boo_OK))
							
							  //======================================================
							  //              MISSING OR INVALID FORMATTER
							  //======================================================
							
							$Obj_audit.success:=False:C215
							$Obj_audit.errors.push(New object:C1471(\
								"type";"formatter";\
								"panel";"TABLES";\
								"message";str ("theFormatterIsMissingOrInvalid").localized(Delete string:C232($t;1;1));\
								"table";$Txt_tableNumber;\
								"field";$Txt_fieldNumber))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($Obj_context.filters)
			
			If ($Obj_dataModel[$Txt_tableNumber].filter#Null:C1517)
				
				If (Not:C34(Bool:C1537($Obj_dataModel[$Txt_tableNumber].filter.validated)))
					
					  //======================================================
					  //                   INVALID FILTER
					  //======================================================
					
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"filter";\
						"panel";"DATA";\
						"message";str ("theFilterForTheTableIsNotValid").localized(String:C10($Obj_dataModel[$Txt_tableNumber].name));\
						"table";$Txt_tableNumber))
					
				End if 
			End if 
		End if 
	End for each 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_audit

  // ----------------------------------------------------
  // End