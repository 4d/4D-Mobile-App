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
#DECLARE($in : Object)->$result : Object

If (False:C215)
	C_OBJECT:C1216(project_Audit; $0)
	C_OBJECT:C1216(project_Audit; $1)
End if 

var $name : Text
var $toCheck; $datamodel; $detail; $field; $list; $metadata; $table : Object
var $errors : Collection
var $hostFormaters; $hostIcons : 4D:C1709.Folder
var $path : cs:C1710.path
var $str : cs:C1710.str
var $tmpl : cs:C1710.tmpl

// ----------------------------------------------------
// Initialisations
$toCheck:=New object:C1471(\
"list"; True:C214; \
"detail"; True:C214; \
"icons"; True:C214; \
"formatters"; True:C214; \
"filters"; True:C214)

If (Count parameters:C259=0)
	
	// Normal behaviour is form
	$datamodel:=PROJECT.dataModel
	$list:=PROJECT.list
	$detail:=PROJECT.detail
	
	var $target : Collection
	$target:=Value type:C1509(PROJECT.info.target)=Is collection:K8:32 ? PROJECT.info.target : New collection:C1472(PROJECT.info.target)
	
Else 
	
	// Allow passing value for test purpose.
	$datamodel:=Choose:C955($in.dataModel#Null:C1517; $in.dataModel; PROJECT.dataModel)
	$list:=Choose:C955($in.list#Null:C1517; $in.list; PROJECT.list)
	$detail:=Choose:C955($in.detail#Null:C1517; $in.detail; PROJECT.detail)
	
	If ($in.target#Null:C1517)
		
		$toCheck.list:=($in.target.indexOf("lists")#-1)
		$toCheck.detail:=($in.target.indexOf("details")#-1)
		$toCheck.icons:=($in.target.indexOf("icons")#-1)
		$toCheck.formatters:=($in.target.indexOf("formatters")#-1)
		$toCheck.filters:=($in.target.indexOf("filters")#-1)
		
	End if 
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
		
		If ($toCheck.list)  // ① CHECK LIST FORMS
			
			If ($list[$table.key].form#Null:C1517)
				
				$name:=String:C10($list[$table.key].form)
				
				If (Not:C34($tmpl.getSources($name; "list").exists))  // 👎 MISSING OR INVALID LIST FORM
					
					$errors.push(New object:C1471(\
						"type"; "template"; \
						"tab"; "list"; \
						"message"; $str.localize("theTemplateIsMissing"; $name); \
						"table"; $table.key))
					
				Else 
					
					// CHECK FORMS FIELDS
					If ($list[$table.key].fields#Null:C1517)
						
						For each ($field; $list[$table.key].fields)
							
							If ($field#Null:C1517)
								
								If (Not:C34(PROJECT.fieldAvailable($table.key; $field)))
									
									// Missing
									$errors.push(New object:C1471(\
										"type"; "field"; \
										"tab"; "list"; \
										"message"; $str.localize("theFieldFieldIsMissing"; $field.name); \
										"table"; $table.key))
									
								End if 
							End if 
						End for each 
					End if 
				End if 
			End if 
		End if 
		
		If ($toCheck.detail)  // ② CHECK DETAIL FORMS
			
			$name:=String:C10($detail[$table.key].form)
			$name:=$name*Num:C11($name#"null")  // Reject null value
			
			If (Length:C16($name)>0)
				
				If (Not:C34($tmpl.getSources($name; "detail").exists))  // 👎 MISSING OR INVALID DETAIL FORM
					
					$errors.push(New object:C1471(\
						"type"; "template"; \
						"tab"; "detail"; \
						"message"; $str.localize("theTemplateIsMissing"; $name); \
						"table"; $table.key))
					
				Else 
					
					// CHECK FORMS FIELDS
					If ($detail[$table.key].fields#Null:C1517)
						
						For each ($field; $detail[$table.key].fields)
							
							If ($field#Null:C1517)
								
								If (Not:C34(PROJECT.fieldAvailable($table.key; $field)))
									
									// Missing
									$errors.push(New object:C1471(\
										"type"; "field"; \
										"tab"; "detail"; \
										"message"; $str.localize("theFieldFieldIsMissing"; $field.name); \
										"table"; $table.key))
									
								End if 
							End if 
						End for each 
					End if 
				End if 
			End if 
		End if 
		
		If ($toCheck.icons)\
			 | ($toCheck.formatters)
			
			If ($toCheck.icons)  // ③ CHECK TABLE ICONS
				
				$name:=String:C10($datamodel[$table.key][""].icon)
				
				If (Position:C15("/"; $name)=1)  // Host database resources
					
					$name:=Delete string:C232($name; 1; 1)
					
					If (Not:C34($hostIcons.file($name).exists))  // 👎 MISSING TABLE ICON
						
						$errors.push(New object:C1471(\
							"type"; "icon"; \
							"panel"; "TABLES"; \
							"message"; $str.localize("theTableIconIsMissing"; $name); \
							"table"; $table.key; \
							"tab"; "tableProperties"))
						
					End if 
				End if 
			End if 
			
			For each ($field; PROJECT.fields($table.key))
				
				If ($toCheck.icons)  // ④ CHECK FIELD ICONS
					
					$name:=String:C10($datamodel[$table.key][$field.key].icon)
					
					If (Position:C15("/"; $name)=1)  // Host resources
						
						$name:=Delete string:C232($name; 1; 1)
						
						If (Not:C34($hostIcons.file($name).exists))  // 👎 MISSING FIELD ICON
							
							$errors.push(New object:C1471(\
								"type"; "icon"; \
								"panel"; "TABLES"; \
								"message"; $str.localize("theFieldIconIsMissing"; $name); \
								"table"; $table.key; \
								"field"; $field.key))
							
						End if 
						
					Else 
						
						// 👅 We assume that the built-in icons are still there.
						
					End if 
				End if 
				
				If ($toCheck.formatters)  // ⑤ CHECK FORMATERS
					
					$name:=String:C10($datamodel[$table.key][$field.key].format)
					
					Case of 
							
							//______________________________________________________
						: (Length:C16($name)=0)
							
							// Default format
							
							//______________________________________________________
						: (Position:C15("/"; $name)=1)  // Host resources
							
							var $formater : cs:C1710.formatter
							$formater:=cs:C1710.formatter.new($name)
							
							If ($formater.isValid())
								
								var $manifest : Object
								$manifest:=JSON Parse:C1218($formater.source.file("manifest.json").getText())
								$manifest.type:=(Value type:C1509($manifest.type)=Is collection:K8:32) ? $manifest.type : New collection:C1472(String:C10($manifest.type))
								
								If ($manifest.target#Null:C1517)
									
									$manifest.target:=(Value type:C1509($manifest.target)=Is collection:K8:32) ? $manifest.target : New collection:C1472(String:C10($manifest.target))
									
								Else 
									
									$formater._createTarget($manifest; $formater)
									
								End if 
								
								If (Not:C34((($manifest.target.length=2) & ($target.length=2))\
									 || (($target.length=1) & ($manifest.target.indexOf($target[0])#-1))))  // Not compatible with the target
									
									$errors.push(New object:C1471(\
										"type"; "formatter"; \
										"panel"; "TABLES"; \
										"message"; $str.localize("theFormatIsNotValidForThisTarget"; $formater.label); \
										"table"; $table.key; \
										"field"; $field.key))
									
								End if 
								
								
							Else   // 👎 MISSING OR INVALID FORMATTER
								
								$errors.push(New object:C1471(\
									"type"; "formatter"; \
									"panel"; "TABLES"; \
									"message"; $str.localize("theFormatterIsMissingOrInvalid"; $formater.label); \
									"table"; $table.key; \
									"field"; $field.key))
								
							End if 
							
							//______________________________________________________
						Else 
							
							// 👅 We assume that built-in formaters are not poxed.
							
							//______________________________________________________
					End case 
				End if 
			End for each 
		End if 
		
		If ($toCheck.filters)  // ⑥ CHECK FILTERS
			
			$metadata:=$datamodel[$table.key][""]
			
			If ($metadata.filter#Null:C1517)
				
				If (Not:C34(Bool:C1537($metadata.filter.validated)))  // 👎 NOT VALIDATED FILTER
					
					$errors.push(New object:C1471(\
						"type"; "filter"; \
						"panel"; "DATA"; \
						"message"; $str.localize("theFilterForTheTableIsNotValid"; String:C10($metadata.name)); \
						"table"; $table.key))
					
				End if 
			End if 
		End if 
	End for each 
End if 

If ($errors.length=0)
	
	$result:=New object:C1471(\
		"success"; True:C214)
	
Else 
	
	$result:=New object:C1471(\
		"success"; False:C215; \
		"errors"; $errors)
	
End if 

If (Form:C1466#Null:C1517)
	
	EDITOR.updateHeader(New object:C1471(\
		"show"; Not:C34($result.success)))
	
End if 