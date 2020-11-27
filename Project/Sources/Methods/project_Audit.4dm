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
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(project_Audit; $0)
	C_OBJECT:C1216(project_Audit; $1)
End if 

var $name : Text
var $audit; $audits; $datamodel; $detail; $field; $list; $metadata; $table : Object
var $errors : Collection
var $hostFormaters; $hostIcons : 4D:C1709.Folder
var $path : cs:C1710.path
var $str : cs:C1710.str
var $tmpl : cs:C1710.tmpl

// ----------------------------------------------------
// Initialisations
$audits:=New object:C1471(\
"list"; True:C214; \
"detail"; True:C214; \
"icons"; True:C214; \
"formatters"; True:C214; \
"filters"; True:C214)

If (Count parameters:C259>=1)
	
	// Allow passing value for test purpose.
	$datamodel:=Choose:C955($1.dataModel#Null:C1517; $1.dataModel; Form:C1466.dataModel)
	$list:=Choose:C955($1.list#Null:C1517; $1.list; Form:C1466.list)
	$detail:=Choose:C955($1.detail#Null:C1517; $1.detail; Form:C1466.detail)
	
	If ($1.target#Null:C1517)
		
		$audits.list:=($1.target.indexOf("lists")#-1)
		$audits.detail:=($1.target.indexOf("details")#-1)
		$audits.icons:=($1.target.indexOf("icons")#-1)
		$audits.formatters:=($1.target.indexOf("formatters")#-1)
		$audits.filters:=($1.target.indexOf("filters")#-1)
		
	End if 
	
Else 
	
	// Normal behaviour is form
	$datamodel:=Form:C1466.dataModel
	$list:=Form:C1466.list
	$detail:=Form:C1466.detail
	
End if 

// ----------------------------------------------------
If ($datamodel#Null:C1517)
	
	$errors:=New collection:C1472
	$path:=cs:C1710.path.new()
	$str:=cs:C1710.str.new()
	$tmpl:=cs:C1710.tmpl.new()
	
	$hostIcons:=$path.hostIcons()
	$hostFormaters:=$path.hostFormatters()
	
	For each ($table; PROJECT.tables($datamodel))
		
		If ($audits.list)  // ① CHECK LIST FORMS
			
			If ($list[$table.key].form#Null:C1517)
				
				$name:=String:C10($list[$table.key].form)
				
				If (Not:C34($tmpl.path($name; "list").exists))  // 👎 MISSING OR INVALID LIST FORM
					
					$errors.push(New object:C1471(\
						"type"; "template"; \
						"tab"; "list"; \
						"message"; $str.setText("theTemplateIsMissing").localized($name); \
						"table"; $table.key))
					
				End if 
			End if 
		End if 
		
		If ($audits.detail)  // ② CHECK DETAIL FORMS
			
			$name:=String:C10($detail[$table.key].form)
			$name:=$name*Num:C11($name#"null")  // Reject null value
			
			If (Length:C16($name)>0)
				
				If (Not:C34($tmpl.path($name; "detail").exists))  // 👎 MISSING OR INVALID DETAIL FORM
					
					$errors.push(New object:C1471(\
						"type"; "template"; \
						"tab"; "list"; \
						"message"; $str.setText("theTemplateIsMissing").localized($name); \
						"table"; $table.key))
					
				End if 
			End if 
		End if 
		
		If ($audits.icons)\
			 | ($audits.formatters)
			
			If ($audits.icons)  // ③ CHECK TABLE ICONS
				
				$name:=String:C10($datamodel[$table.key][""].icon)
				
				If (Position:C15("/"; $name)=1)  // Host database resources
					
					$name:=Delete string:C232($name; 1; 1)
					
					If (Not:C34($hostIcons.file($name).exists))  // 👎 MISSING TABLE ICON
						
						$errors.push(New object:C1471(\
							"type"; "icon"; \
							"panel"; "TABLES"; \
							"message"; $str.setText("theTableIconIsMissing").localized($name); \
							"table"; $table.key; \
							"tab"; "tableProperties"))
						
					End if 
				End if 
			End if 
			
			For each ($field; PROJECT.fields($table.key))
				
				If ($audits.icons)  // ④ CHECK FIELD ICONS
					
					$name:=String:C10($datamodel[$table.key][$field.key].icon)
					
					If (Position:C15("/"; $name)=1)  // Host resources
						
						$name:=Delete string:C232($name; 1; 1)
						
						If (Not:C34($hostIcons.file($name).exists))  // 👎 MISSING FIELD ICON
							
							$errors.push(New object:C1471(\
								"type"; "icon"; \
								"panel"; "TABLES"; \
								"message"; $str.setText("theFieldIconIsMissing").localized($name); \
								"table"; $table.key; \
								"field"; $field.key))
							
						End if 
						
					Else 
						
						// 👅 We assume that the built-in icons are still there.
						
					End if 
				End if 
				
				If ($audits.formatters)  // ⑤ CHECK FORMATTERS
					
					$name:=String:C10($datamodel[$table.key][$field.key].format)
					
					If (Position:C15("/"; $name)=1)  // Host resources
						
						$name:=Delete string:C232($name; 1; 1)
						
						If (Not:C34($hostFormaters.folder($name).file("manifest.json").exists))  // 👎 MISSING OR INVALID FORMATTER
							
							$errors.push(New object:C1471(\
								"type"; "formatter"; \
								"panel"; "TABLES"; \
								"message"; $str.setText("theFormatterIsMissingOrInvalid").localized($name); \
								"table"; $table.key; \
								"field"; $field.key))
							
						End if 
						
					Else 
						
						// 👅 We assume that built-in formatters are not poxed.
						
					End if 
				End if 
			End for each 
		End if 
		
		If ($audits.filters)  // ⑥ CHECK FILTERS
			
			$metadata:=$datamodel[$table.key][""]
			
			If ($metadata.filter#Null:C1517)
				
				If (Not:C34(Bool:C1537($metadata.filter.validated)))  // 👎 NOT VALIDATED FILTER
					
					$errors.push(New object:C1471(\
						"type"; "filter"; \
						"panel"; "DATA"; \
						"message"; $str.setText("theFilterForTheTableIsNotValid").localized(String:C10($metadata.name)); \
						"table"; $table.key))
					
				End if 
			End if 
		End if 
	End for each 
End if 

If ($errors.length=0)
	
	$audit:=New object:C1471(\
		"success"; True:C214)
	
Else 
	
	$audit:=New object:C1471(\
		"success"; False:C215; \
		"errors"; $errors)
	
End if 

If (Form:C1466#Null:C1517)
	
	//CALL FORM(Current form window; "editor_CALLBACK"; "description"; New object(\
		"show"; Not($audit.success)))
	
End if 

// ----------------------------------------------------
// Return
$0:=$audit
