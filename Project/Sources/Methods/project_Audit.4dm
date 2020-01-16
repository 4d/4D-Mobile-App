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
C_TEXT:C284($t;$tFormName;$tTable;$Txt_fieldNumber)
C_OBJECT:C1216($context;$file;$o;$oDataModel;$oDetail;$oIN)
C_OBJECT:C1216($oList;$oOUT;$Path_fieldIcons;$Path_formaters;$Path_tableIcons;$pathForm)

If (False:C215)
	C_OBJECT:C1216(project_Audit ;$0)
	C_OBJECT:C1216(project_Audit ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	  // Required parameters
	$oIN:=$1
	
	  // Default values
	$oOUT:=New object:C1471(\
		"success";True:C214;\
		"errors";New collection:C1472)
	
	$context:=New object:C1471(\
		"list";True:C214;\
		"detail";True:C214;\
		"icons";True:C214;\
		"formatters";True:C214;\
		"filters";True:C214)
	
	  // Allow passing value for test purpose. Normal behaviour is form
	$oDataModel:=Choose:C955(Value type:C1509($oIN.dataModel)=Is object:K8:27;$oIN.dataModel;Form:C1466.dataModel)
	$oList:=Choose:C955(Value type:C1509($oIN.list)=Is object:K8:27;$oIN.list;Form:C1466.list)
	$oDetail:=Choose:C955(Value type:C1509($oIN.detail)=Is object:K8:27;$oIN.detail;Form:C1466.detail)
	
	If ($oIN.target#Null:C1517)
		
		$context.list:=($oIN.target.indexOf("lists")#-1)
		$context.detail:=($oIN.target.indexOf("details")#-1)
		$context.icons:=($oIN.target.indexOf("icons")#-1)
		$context.formatters:=($oIN.target.indexOf("formatters")#-1)
		$context.filters:=($oIN.target.indexOf("filters")#-1)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($oDataModel#Null:C1517)
	
	  // Load manifest values
	$file:=COMPONENT_Pathname ("listForms").file("manifest.json")
	
	If ($file.exists)
		
		$context.listManifest:=JSON Parse:C1218($file.getText())
		
	End if 
	
	$file:=COMPONENT_Pathname ("detailForms").file("manifest.json")
	
	If ($file.exists)
		
		$context.detailManifest:=JSON Parse:C1218($file.getText())
		
	End if 
	
	$Path_tableIcons:=COMPONENT_Pathname ("host_tableIcons")
	$Path_fieldIcons:=COMPONENT_Pathname ("host_fieldIcons")
	$Path_formaters:=COMPONENT_Pathname ("host_formatters")
	
	For each ($tTable;$oDataModel)
		
		If ($context.list)  // LIST FORM
			
			$tFormName:=String:C10($oList[$tTable].form)
			$tFormName:=$tFormName*Num:C11($tFormName#"null")  // Reject null value
			
			If (Length:C16($tFormName)>0)
				
				$pathForm:=tmpl_form ($tFormName;"list")
				
				If (Not:C34($pathForm.exists))
					
					$oOUT.success:=False:C215
					$oOUT.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"list";\
						"message";str ("theTemplateIsMissing").localized($tFormName);\
						"table";$tTable))
					
				End if 
			End if 
		End if 
		
		If ($context.detail)  // DETAIL FORM
			
			$tFormName:=String:C10($oDetail[$tTable].form)
			$tFormName:=$tFormName*Num:C11($tFormName#"null")  // Reject null value
			
			If (Length:C16($tFormName)>0)
				
				$pathForm:=tmpl_form ($tFormName;"detail")
				
				If (Not:C34($pathForm.exists))
					
					$oOUT.success:=False:C215
					$oOUT.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"list";\
						"message";str ("theTemplateIsMissing").localized($tFormName);\
						"table";$tTable))
					
				End if 
			End if 
		End if 
		
		If ($context.icons)  // ICONS
			
			If (featuresFlags.with("newDataModel"))
				
				$t:=String:C10($oDataModel[$tTable][""].icon)
				
			Else 
				
				  //old
				$t:=String:C10($oDataModel[$tTable].icon)
				
			End if 
			
			If (Position:C15("/";$t)=1)  // Host database resources
				
				$t:=Delete string:C232($t;1;1)
				
				$Boo_OK:=$Path_tableIcons.file($t).exists
				
				If (Not:C34($Boo_OK))
					
					  //======================================================
					  //                  MISSING TABLE ICON
					  //======================================================
					
					$oOUT.success:=False:C215
					$oOUT.errors.push(New object:C1471(\
						"type";"icon";\
						"panel";"TABLES";\
						"message";str ("theTableIconIsMissing").localized($t);\
						"table";$tTable;\
						"tab";"tableProperties"))
					
				End if 
			End if 
			
			For each ($Txt_fieldNumber;$oDataModel[$tTable])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))
					
					$t:=String:C10($oDataModel[$tTable][$Txt_fieldNumber].icon)
					
					If (Position:C15("/";$t)=1)  // Host resources
						
						$t:=Delete string:C232($t;1;1)
						
						$Boo_OK:=$Path_fieldIcons.exists
						
						If ($Boo_OK)
							
							$Boo_OK:=$Path_fieldIcons.file($t).exists
							
						End if 
						
						If (Not:C34($Boo_OK))
							
							  //======================================================
							  //                  MISSING FIELD ICON
							  //======================================================
							
							$oOUT.success:=False:C215
							$oOUT.errors.push(New object:C1471(\
								"type";"icon";\
								"panel";"TABLES";\
								"message";str ("theFieldIconIsMissing").localized($t);\
								"table";$tTable;\
								"field";$Txt_fieldNumber))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($context.formatters)  // FORMATTERS
			
			For each ($Txt_fieldNumber;$oDataModel[$tTable])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldNumber;1;*))
					
					$t:=String:C10($oDataModel[$tTable][$Txt_fieldNumber].format)
					
					If (Position:C15("/";$t)=1)  // Host resources
						
						$t:=Delete string:C232($t;1;1)
						
						$Boo_OK:=$Path_formaters.folder($t).file("manifest.json").exists
						
						If (Not:C34($Boo_OK))
							
							  //======================================================
							  //              MISSING OR INVALID FORMATTER
							  //======================================================
							
							$oOUT.success:=False:C215
							$oOUT.errors.push(New object:C1471(\
								"type";"formatter";\
								"panel";"TABLES";\
								"message";str ("theFormatterIsMissingOrInvalid").localized(Delete string:C232($t;1;1));\
								"table";$tTable;\
								"field";$Txt_fieldNumber))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($context.filters)  // FILTERS
			
			$o:=Choose:C955(featuresFlags.with("newDataModel");$oDataModel[$tTable][""];$oDataModel[$tTable])
			
			If ($o.filter#Null:C1517)
				
				If (Not:C34(Bool:C1537($o.filter.validated)))
					
					  //======================================================
					  //                   INVALID FILTER
					  //======================================================
					
					$oOUT.success:=False:C215
					$oOUT.errors.push(New object:C1471(\
						"type";"filter";\
						"panel";"DATA";\
						"message";str ("theFilterForTheTableIsNotValid").localized(String:C10($o.name));\
						"table";$tTable))
					
				End if 
			End if 
		End if 
	End for each 
End if 

CALL FORM:C1391(Current form window:C827;"editor_CALLBACK";"description";New object:C1471(\
"show";Not:C34($oOUT.success)))

  // ----------------------------------------------------
  // Return
$0:=$oOUT

  // ----------------------------------------------------
  // End