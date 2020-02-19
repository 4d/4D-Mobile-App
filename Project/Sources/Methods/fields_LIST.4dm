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
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_TEXT:C284($key;$t;$t_tableNumber;$tField)
C_OBJECT:C1216($folderFormats;$ƒ;$o_out;$oField;$oTable;$str)

If (False:C215)
	C_OBJECT:C1216(fields_LIST ;$0)
	C_TEXT:C284(fields_LIST ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
If (Asserted:C1132(Count parameters:C259>=1;"Missing parameter"))
	
	$t_tableNumber:=$1
	
	  // Optional parameters
	If (Count parameters:C259>=2)
		
		  // <NONE>
		
	End if 
	
	$o_out:=New object:C1471(\
		"success";Form:C1466.dataModel#Null:C1517)
	
	$ƒ:=Storage:C1525.ƒ
	
	$str:=str ()
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($o_out.success)
	
	$o_out.success:=(Form:C1466.dataModel[$t_tableNumber]#Null:C1517)
	
	If ($o_out.success)
		
		$folderFormats:=path .hostFormatters()
		
		$o_out.ids:=New collection:C1472
		$o_out.names:=New collection:C1472
		$o_out.labels:=New collection:C1472
		$o_out.shortLabels:=New collection:C1472
		$o_out.iconPaths:=New collection:C1472
		$o_out.icons:=New collection:C1472
		$o_out.types:=New collection:C1472
		$o_out.formats:=New collection:C1472
		$o_out.formatColors:=New collection:C1472
		$o_out.nameColors:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		$o_out.tableNumbers:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		
		$o_out.paths:=New collection:C1472
		
		$oTable:=Form:C1466.dataModel[$t_tableNumber]
		
		For each ($key;$oTable)
			
			Case of 
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isField($key))\
					 & (Num:C11(This:C1470.selector)=0)
					
					$o_out.formatColors.push(Foreground color:K23:1)
					$o_out.nameColors.push(Foreground color:K23:1)
					
					$oField:=$oTable[$key]
					$oField.id:=Num:C11($key)
					
					  // ***********************************
					  // ***********************************
					$o_out.tableNumbers.push(Num:C11($t_tableNumber))
					
					  // ***********************************
					  // ***********************************
					
					$o_out.ids.push($oField.id)
					$o_out.names.push($oField.name)
					$o_out.paths.push($oField.name)
					$o_out.types.push($oField.type)
					
					If ($oField.label=Null:C1517)
						
						$oField.label:=formatString ("label";$oField.name)
						
					End if 
					
					$o_out.labels.push($oField.label)
					
					If ($oField.shortLabel=Null:C1517)
						
						$oField.shortLabel:=$oField.label
						
					End if 
					
					$o_out.shortLabels.push($oField.shortLabel)
					$o_out.iconPaths.push(String:C10($oField.icon))
					$o_out.icons.push(getIcon (String:C10($oField.icon)))
					
					If ($oField.format#Null:C1517)
						
						  //%W-533.1
						If ($oField.format[[1]]="/")  // User resources
							
							$t:=Substring:C12($oField.format;2)
							
							If (Not:C34(formatters (New object:C1471(\
								"action";"isValid";\
								"format";$folderFormats.folder($t))).success))
								
								$o_out.formatColors[$o_out.formats.length]:=ui.errorColor  // Missing or invalid
								
							End if 
							
						Else 
							
							$t:=$str.setText("_"+$oField.format).localized()
							
						End if 
						  //%W+533.1
						
					Else 
						
						$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$oField.fieldType])).localized()
						
					End if 
					
					$o_out.formats.push($t)
					
					  //……………………………………………………………………………………………………………
				: (Value type:C1509($oTable[$key])#Is object:K8:27)
					
					  // <NOTHING MORE TO DO>
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isRelationToOne($oTable[$key]))\
					 & (Num:C11(This:C1470.selector)=0)
					
					For each ($tField;$oTable[$key])
						
						If ($ƒ.isField($tField))
							
							$o_out.formatColors.push(Foreground color:K23:1)
							$o_out.nameColors.push(Foreground color:K23:1)
							
							$oField:=$oTable[$key][$tField]
							$oField.id:=Num:C11($tField)
							
							  // ***********************************
							  // ***********************************
							$o_out.tableNumbers.push(structure (New object:C1471(\
								"action";"tableNumber";\
								"name";$oTable[$key].relatedDataClass)).tableNumber)
							
							  // ***********************************
							  // ***********************************
							
							$o_out.ids.push($oField.id)
							$o_out.names.push($oField.name)
							$o_out.paths.push($key+"."+$oField.name)
							$o_out.types.push($oField.fieldType)
							$o_out.labels.push($oField.label)
							$o_out.shortLabels.push($oField.shortLabel)
							$o_out.iconPaths.push(String:C10($oField.icon))
							$o_out.icons.push(getIcon (String:C10($oField.icon)))
							
							If ($oField.format#Null:C1517)
								
								  //%W-533.1
								If ($oField.format[[1]]="/")  // User resources
									
									$t:=Substring:C12($oField.format;2)
									
									If (Not:C34(formatters (New object:C1471(\
										"action";"isValid";\
										"format";$folderFormats.folder($t))).success))
										
										$o_out.formatColors[$o_out.formats.length]:=ui.errorColor  // Missing or invalid
										
									End if 
									
								Else 
									
									$t:=$str.setText("_"+$oField.format).localized()
									
								End if 
								  //%W+533.1
								
							Else 
								
								$t:=$str.setText("_"+String:C10(SHARED.defaultFieldBindingTypes[$oField.fieldType])).localized()
								
							End if 
							
							$o_out.formats.push($t)
							
						End if 
					End for each 
					
					  //……………………………………………………………………………………………………………
				: (Num:C11(This:C1470.selector)=0)
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isRelationToMany($oTable[$key]))  //&(Num(This.selector)=1)
					
					$o_out.formatColors.push(Foreground color:K23:1)
					$o_out.nameColors.push(Foreground color:K23:1)
					
					$oField:=$oTable[$key]
					
					  // ***********************************
					  // ***********************************
					$o_out.tableNumbers.push(Num:C11($t_tableNumber))
					
					  // ***********************************
					  // ***********************************
					
					$o_out.ids.push(Null:C1517)
					$o_out.names.push($key)
					$o_out.paths.push($key)
					$o_out.types.push(-2)
					
					If (String:C10($oField.label)="")
						
						$oField.label:=formatString ("label";$key)
						
					End if 
					
					$o_out.labels.push($oField.label)
					
					If (String:C10($oField.shortLabel)="")
						
						$oField.shortLabel:=$oField.label
						
					End if 
					
					$o_out.shortLabels.push($oField.shortLabel)
					$o_out.iconPaths.push(String:C10($oField.icon))
					$o_out.icons.push(getIcon (String:C10($oField.icon)))
					
					If (Form:C1466.dataModel[String:C10($oField.relatedTableNumber)]=Null:C1517)
						
						$o_out.nameColors[$o_out.names.length-1]:=ui.errorColor  // Missing or invalid
						
					End if 
					
					$o_out.formats.push($oField.format)
					
					  //……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$o_out.count:=$o_out.ids.length
		
	Else 
		
		  // No table selected
		
	End if 
	
Else 
	
	  // Empty dataModel
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$o_out

  // ----------------------------------------------------
  // End