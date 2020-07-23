//%attributes = {"invisible":true,"preemptive":"incapable"}
// ----------------------------------------------------
// Project method : fields_LIST
// ID[0F8855BDB0F7477397EEEE16B17EE729]
// Created 28-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Return selected table field list according to data model
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Text

var $fieldIdentifier; $key; $t; $tableIdentifier : Text
var $field; $out; $str; $table : Object

var $formatters : cs:C1710.path

If (False:C215)
End if 

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$tableIdentifier:=$1
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
	$out:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	$str:=str()
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($out.success)
	
	$out.success:=(Form:C1466.dataModel[$tableIdentifier]#Null:C1517)
	
	If ($out.success)
		
		$formatters:=cs:C1710.path.new().hostFormatters()
		
		$out.ids:=New collection:C1472
		$out.names:=New collection:C1472
		$out.labels:=New collection:C1472
		$out.shortLabels:=New collection:C1472
		$out.iconPaths:=New collection:C1472
		$out.icons:=New collection:C1472
		$out.types:=New collection:C1472
		$out.formats:=New collection:C1472
		$out.formatColors:=New collection:C1472
		$out.nameColors:=New collection:C1472
		
		// ***********************************
		// ***********************************
		$out.tableNumbers:=New collection:C1472
		
		// ***********************************
		// ***********************************
		
		$out.paths:=New collection:C1472
		
		$table:=Form:C1466.dataModel[$tableIdentifier]
		
		For each ($key; $table)
			
			Case of 
					
					//……………………………………………………………………………………………………………
				: (project.isField($key))\
					 & (Num:C11(This:C1470.selector)=0)
					
					$out.formatColors.push(Foreground color:K23:1)
					$out.nameColors.push(Foreground color:K23:1)
					
					$field:=$table[$key]
					$field.id:=Num:C11($key)
					
					// ***********************************
					// ***********************************
					$out.tableNumbers.push(Num:C11($tableIdentifier))
					
					// ***********************************
					// ***********************************
					
					$out.ids.push($field.id)
					$out.names.push($field.name)
					$out.paths.push($field.name)
					$out.types.push($field.type)
					
					If ($field.label=Null:C1517)
						
						$field.label:=project.label($field.name)
						
					End if 
					
					$out.labels.push($field.label)
					
					If ($field.shortLabel=Null:C1517)
						
						$field.shortLabel:=$field.label
						
					End if 
					
					$out.shortLabels.push($field.shortLabel)
					$out.iconPaths.push(String:C10($field.icon))
					$out.icons.push(getIcon(String:C10($field.icon)))
					
					If ($field.format#Null:C1517)
						
						//%W-533.1
						If ($field.format[[1]]="/")  // User resources
							
							$t:=Substring:C12($field.format; 2)
							
							If (Not:C34(formatters(New object:C1471(\
								"action"; "isValid"; \
								"format"; $formatters.folder($t))).success))
								
								$out.formatColors[$out.formats.length]:=ui.errorColor  // Missing or invalid
								
							End if 
							
						Else 
							
							$t:=$str.setText("_"+$field.format).localized()
							
						End if 
						//%W+533.1
						
					Else 
						
						$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
						
					End if 
					
					$out.formats.push($t)
					
					//……………………………………………………………………………………………………………
				: (Value type:C1509($table[$key])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//……………………………………………………………………………………………………………
				: (project.isRelationToOne($table[$key]))
					
					If (Num:C11(This:C1470.selector)=0)
						
						For each ($fieldIdentifier; $table[$key])
							
							If (project.isField($fieldIdentifier))
								
								$out.formatColors.push(Foreground color:K23:1)
								$out.nameColors.push(Foreground color:K23:1)
								
								$field:=$table[$key][$fieldIdentifier]
								$field.id:=Num:C11($fieldIdentifier)
								
								// ***********************************
								// ***********************************
								$out.tableNumbers.push(structure(New object:C1471(\
									"action"; "tableNumber"; \
									"name"; $table[$key].relatedDataClass)).tableNumber)
								
								// ***********************************
								// ***********************************
								
								$out.ids.push($field.id)
								$out.names.push($field.name)
								$out.paths.push($key+"."+$field.name)
								$out.types.push($field.fieldType)
								$out.labels.push($field.label)
								$out.shortLabels.push($field.shortLabel)
								$out.iconPaths.push(String:C10($field.icon))
								$out.icons.push(getIcon(String:C10($field.icon)))
								
								If ($field.format#Null:C1517)
									
									//%W-533.1
									If ($field.format[[1]]="/")  // User resources
										
										$t:=Substring:C12($field.format; 2)
										
										If (Not:C34(formatters(New object:C1471(\
											"action"; "isValid"; \
											"format"; $formatters.folder($t))).success))
											
											$out.formatColors[$out.formats.length]:=ui.errorColor  // Missing or invalid
											
										End if 
										
									Else 
										
										$t:=$str.setText("_"+$field.format).localized()
										
									End if 
									//%W+533.1
									
								Else 
									
									$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$field.fieldType])).localized()
									
								End if 
								
								$out.formats.push($t)
								
							End if 
						End for each 
						
					Else 
						
						If (feature.with("moreRelations"))
							
							$out.formatColors.push(Foreground color:K23:1)
							$out.nameColors.push(Foreground color:K23:1)
							
							$field:=$table[$key]
							
							// ***********************************
							// ***********************************
							$out.tableNumbers.push(Num:C11($tableIdentifier))
							
							// ***********************************
							// ***********************************
							
							$out.ids.push(Null:C1517)
							$out.names.push($key)
							$out.paths.push($key)
							$out.types.push(-1)
							
							If (String:C10($field.label)="")
								
								$field.label:=project.label($key)
								
							End if 
							
							$out.labels.push($field.label)
							
							If (String:C10($field.shortLabel)="")
								
								$field.shortLabel:=$field.label
								
							End if 
							
							$out.shortLabels.push($field.shortLabel)
							$out.iconPaths.push(String:C10($field.icon))
							$out.icons.push(getIcon(String:C10($field.icon)))
							
							If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
								
								$out.nameColors[$out.names.length-1]:=ui.errorColor  // Missing or invalid
								
							End if 
							
							$out.formats.push($field.format)
							
						End if 
					End if 
					
					//……………………………………………………………………………………………………………
				: (Num:C11(This:C1470.selector)=0)
					
					//……………………………………………………………………………………………………………
				: (project.isRelationToMany($table[$key]))  //&(Num(This.selector)=1)
					
					$out.formatColors.push(Foreground color:K23:1)
					$out.nameColors.push(Foreground color:K23:1)
					
					$field:=$table[$key]
					
					// ***********************************
					// ***********************************
					$out.tableNumbers.push(Num:C11($tableIdentifier))
					
					// ***********************************
					// ***********************************
					
					$out.ids.push(Null:C1517)
					$out.names.push($key)
					$out.paths.push($key)
					$out.types.push(-2)
					
					If (String:C10($field.label)="")
						
						$field.label:=project.label($key)
						
					End if 
					
					$out.labels.push($field.label)
					
					If (String:C10($field.shortLabel)="")
						
						$field.shortLabel:=$field.label
						
					End if 
					
					$out.shortLabels.push($field.shortLabel)
					$out.iconPaths.push(String:C10($field.icon))
					$out.icons.push(getIcon(String:C10($field.icon)))
					
					If (Form:C1466.dataModel[String:C10($field.relatedTableNumber)]=Null:C1517)
						
						$out.nameColors[$out.names.length-1]:=ui.errorColor  // Missing or invalid
						
					End if 
					
					$out.formats.push($field.format)
					
					//……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$out.count:=$out.ids.length
		
	Else 
		
		// No table selected
		
	End if 
	
Else 
	
	// Empty dataModel
	
End if 

// ----------------------------------------------------
// Return
$0:=$out

// ----------------------------------------------------
// End