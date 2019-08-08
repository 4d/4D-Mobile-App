//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : project_Audit
  // Database: 4D Mobile App
  // ID[93767D0FCF2340DB88335AB3B117AA44]
  // Created 24-8-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)

C_BOOLEAN:C305($Boo_detail;$Boo_filter;$Boo_formatter;$Boo_icon;$Boo_list;$Boo_OK)
C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_fieldIcons;$Dir_root;$Dir_tableIcons;$Dir_template;$Txt_fieldID;$Txt_file)
C_TEXT:C284($Txt_form;$Txt_format;$Txt_icon;$Txt_tableID)
C_OBJECT:C1216($Obj_audit;$Obj_dataModel;$Obj_detail;$Obj_in;$Obj_list)

If (False:C215)
	C_OBJECT:C1216(project_Audit ;$0)
	C_OBJECT:C1216(project_Audit ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	  // Required parameters
	$Obj_in:=$1
	
	  // Default values
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_audit:=New object:C1471(\
		"success";True:C214;\
		"errors";New collection:C1472)
	
	  // Allow passing value for test purpose. Normal behaviour is form
	$Obj_dataModel:=Choose:C955(Value type:C1509($Obj_in.dataModel)=Is object:K8:27;$Obj_in.dataModel;Form:C1466.dataModel)
	$Obj_list:=Choose:C955(Value type:C1509($Obj_in.list)=Is object:K8:27;$Obj_in.list;Form:C1466.list)
	$Obj_detail:=Choose:C955(Value type:C1509($Obj_in.detail)=Is object:K8:27;$Obj_in.detail;Form:C1466.detail)
	
	If ($Obj_in.target#Null:C1517)
		
		$Boo_list:=($Obj_in.target.indexOf("lists")#-1)
		$Boo_detail:=($Obj_in.target.indexOf("details")#-1)
		$Boo_icon:=($Obj_in.target.indexOf("icons")#-1)
		$Boo_formatter:=($Obj_in.target.indexOf("formatters")#-1)
		$Boo_filter:=($Obj_in.target.indexOf("filters")#-1)
		
	Else 
		
		$Boo_list:=True:C214
		$Boo_detail:=True:C214
		$Boo_icon:=True:C214
		$Boo_formatter:=True:C214
		$Boo_filter:=True:C214
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_dataModel#Null:C1517)
	
	  // Load manifest values
	$Obj_audit.list:=ob_parseDocument (_o_Pathname ("listForms")+"manifest.json").value
	$Obj_audit.detail:=ob_parseDocument (_o_Pathname ("detailForms")+"manifest.json").value
	
	For each ($Txt_tableID;$Obj_dataModel)
		
		If ($Boo_list)  // USER LIST FORMS
			
			$Dir_root:=_o_Pathname ("host_listForms")
			
			$Txt_form:=String:C10($Obj_list[$Txt_tableID].form)
			
			If (Position:C15("/";$Txt_form)=1)  // Host database resources
				
				$Txt_form:=Delete string:C232($Txt_form;1;1)
				
				$Dir_template:=Object to path:C1548(New object:C1471(\
					"name";$Txt_form;\
					"parentFolder";$Dir_root;\
					"isFolder";True:C214))
				
				If (Test path name:C476($Dir_template)=Is a folder:K24:2)
					
					$Boo_OK:=True:C214
					
					For each ($Txt_file;$Obj_audit.list.mandatory) While ($Boo_OK)
						
						$Boo_OK:=(Test path name:C476($Dir_template+Convert path POSIX to system:C1107($Txt_file))#-43)
						
					End for each 
					
					If (Not:C34($Boo_OK))
						
						  // Invalid template
						$Obj_audit.success:=False:C215
						$Obj_audit.errors.push(New object:C1471(\
							"type";"template";\
							"tab";"list";\
							"message";Replace string:C233(Get localized string:C991("theTemplateIsInvalid");"{tmpl}";$Txt_form);\
							"table";$Txt_tableID))
						
					End if 
					
				Else 
					
					  // Missing template
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"list";\
						"message";Replace string:C233(Get localized string:C991("theTemplateIsMissing");"{tmpl}";$Txt_form);\
						"table";$Txt_tableID))
					
				End if 
			End if 
		End if 
		
		If ($Boo_detail)  // USER DETAIL FORMS
			
			$Dir_root:=_o_Pathname ("host_detailForms")
			
			$Txt_form:=String:C10($Obj_detail[$Txt_tableID].form)
			
			If (Position:C15("/";$Txt_form)=1)  // Host database resources
				
				$Txt_form:=Delete string:C232($Txt_form;1;1)
				
				$Dir_template:=Object to path:C1548(New object:C1471(\
					"name";$Txt_form;\
					"parentFolder";$Dir_root;\
					"isFolder";True:C214))
				
				If (Test path name:C476($Dir_template)=Is a folder:K24:2)
					
					$Boo_OK:=True:C214
					
					For each ($Txt_file;$Obj_audit.detail.mandatory) While ($Boo_OK)
						
						$Boo_OK:=(Test path name:C476($Dir_template+Convert path POSIX to system:C1107($Txt_file))#-43)
						
					End for each 
					
					If (Not:C34($Boo_OK))
						
						  // Invalid template
						$Obj_audit.success:=False:C215
						$Obj_audit.errors.push(New object:C1471(\
							"type";"template";\
							"tab";"detail";\
							"message";Replace string:C233(Get localized string:C991("theTemplateIsInvalid");"{tmpl}";$Txt_form);\
							"table";$Txt_tableID))
						
					End if 
					
				Else 
					
					  // Missing template
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"template";\
						"tab";"detail";\
						"message";Replace string:C233(Get localized string:C991("theTemplateIsMissing");"{tmpl}";$Txt_form);\
						"table";$Txt_tableID))
					
				End if 
			End if 
		End if 
		
		If ($Boo_icon)  // USER ICONS
			
			$Dir_tableIcons:=_o_Pathname ("host_tableIcons")+Folder separator:K24:12
			$Dir_fieldIcons:=_o_Pathname ("host_fieldIcons")+Folder separator:K24:12
			
			$Txt_icon:=String:C10($Obj_dataModel[$Txt_tableID].icon)
			
			If (Position:C15("/";$Txt_icon)=1)  // Host database resources
				
				  //#107182 - Custom icons (in subfolder) are invalidated with project audit and ui refresh
				  //$Txt_icon:=Delete string($Txt_icon;1;1)
				$Txt_icon:=Replace string:C233(Delete string:C232($Txt_icon;1;1);"/";Folder separator:K24:12)
				
				If (Test path name:C476($Dir_tableIcons+$Txt_icon)#Is a document:K24:1)
					
					  // Missing table icon
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"icon";\
						"panel";"TABLES";\
						"message";Replace string:C233(Get localized string:C991("theTableIconIsMissing");"{icon}";$Txt_icon);\
						"table";$Txt_tableID;\
						"tab";"tableProperties"))
					
				End if 
			End if 
			
			For each ($Txt_fieldID;$Obj_dataModel[$Txt_tableID])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldID;1;*))
					
					$Txt_icon:=String:C10($Obj_dataModel[$Txt_tableID][$Txt_fieldID].icon)
					
					If (Position:C15("/";$Txt_icon)=1)  // Host database resources
						
						$Txt_icon:=Delete string:C232($Txt_icon;1;1)
						
						If (Test path name:C476($Dir_fieldIcons+$Txt_icon)#Is a document:K24:1)
							
							  // Missing field icon
							$Obj_audit.success:=False:C215
							$Obj_audit.errors.push(New object:C1471(\
								"type";"icon";\
								"panel";"TABLES";\
								"message";Replace string:C233(Get localized string:C991("theFieldIconIsMissing");"{icon}";$Txt_icon);\
								"table";$Txt_tableID;\
								"field";$Txt_fieldID))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($Boo_formatter)  // USER FORMATTERS
			
			$Dir_root:=_o_Pathname ("host_formatters")
			
			For each ($Txt_fieldID;$Obj_dataModel[$Txt_tableID])
				
				If (Match regex:C1019("(?m-si)^\\d+$";$Txt_fieldID;1;*))
					
					$Txt_format:=String:C10($Obj_dataModel[$Txt_tableID][$Txt_fieldID].format)
					
					If (Position:C15("/";$Txt_format)=1)  // Host database resources
						
						$Txt_format:=Replace string:C233(Delete string:C232($Txt_format;1;1);"/";Folder separator:K24:12)
						
						If (Test path name:C476($Dir_root+$Txt_format)#Is a folder:K24:2)\
							 | (Test path name:C476($Dir_root+$Txt_format+Folder separator:K24:12+"manifest.json")#Is a document:K24:1)
							
							  // Missing formatter
							$Obj_audit.success:=False:C215
							$Obj_audit.errors.push(New object:C1471(\
								"type";"formatter";\
								"panel";"TABLES";\
								"message";Replace string:C233(Get localized string:C991("theFormatterIsMissingOrInvalid");"{formatter}";$Txt_format);\
								"table";$Txt_tableID;\
								"field";$Txt_fieldID))
							
						End if 
					End if 
				End if 
			End for each 
		End if 
		
		If ($Boo_filter)  // QUERY FILTERS
			
			If ($Obj_dataModel[$Txt_tableID].filter#Null:C1517)
				
				If (Not:C34(Bool:C1537($Obj_dataModel[$Txt_tableID].filter.validated)))
					
					  // Invalid filter
					$Obj_audit.success:=False:C215
					$Obj_audit.errors.push(New object:C1471(\
						"type";"filter";\
						"panel";"DATA";\
						"message";Replace string:C233(Get localized string:C991("theFilterForTheTableIsNotValid");"{tableName}";String:C10($Obj_dataModel[$Txt_tableID].name));\
						"table";$Txt_tableID))
					
				End if 
			End if 
		End if 
		
		  // ==================================================================================================================================
		
	End for each 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_audit

  // ----------------------------------------------------
  // End