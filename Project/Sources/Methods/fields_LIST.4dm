//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Project method : fields_LIST
  // Database: 4D Mobile App
  // ID[0F8855BDB0F7477397EEEE16B17EE729]
  // Created 28-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return selected table field list according to data model
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t;$tt;$Txt_field;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$Obj_field;$Obj_out;$Obj_table;$o;$Path_formats)

If (False:C215)
	C_OBJECT:C1216(fields_LIST ;$0)
	C_TEXT:C284(fields_LIST ;$1)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Txt_tableNumber:=$1
	
	  // Optional parameters
	If ($Lon_parameters>=2)
		
		  // <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success";Form:C1466.dataModel#Null:C1517)
	
	$ƒ:=Storage:C1525.ƒ
	
	$o:=str ()
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_out.success)
	
	$Obj_out.success:=(Form:C1466.dataModel[$Txt_tableNumber]#Null:C1517)
	
	If ($Obj_out.success)
		
		$Path_formats:=COMPONENT_Pathname ("host_formatters")
		
		$Obj_out.ids:=New collection:C1472
		$Obj_out.names:=New collection:C1472
		$Obj_out.labels:=New collection:C1472
		$Obj_out.shortLabels:=New collection:C1472
		$Obj_out.iconPaths:=New collection:C1472
		$Obj_out.icons:=New collection:C1472
		$Obj_out.types:=New collection:C1472
		$Obj_out.formats:=New collection:C1472
		$Obj_out.formatColors:=New collection:C1472
		$Obj_out.nameColors:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		$Obj_out.tableNumbers:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		
		$Obj_out.paths:=New collection:C1472
		
		$Obj_table:=Form:C1466.dataModel[$Txt_tableNumber]
		
		For each ($tt;$Obj_table)
			
			Case of 
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isField($tt))\
					 & (Num:C11(This:C1470.selector)=0)
					
					$Obj_out.formatColors.push(Foreground color:K23:1)
					$Obj_out.nameColors.push(Foreground color:K23:1)
					
					$Obj_field:=$Obj_table[$tt]
					$Obj_field.id:=Num:C11($tt)
					
					  // ***********************************
					  // ***********************************
					$Obj_out.tableNumbers.push(Num:C11($Txt_tableNumber))
					
					  // ***********************************
					  // ***********************************
					
					$Obj_out.ids.push($Obj_field.id)
					$Obj_out.names.push($Obj_field.name)
					$Obj_out.paths.push($Obj_field.name)
					$Obj_out.types.push($Obj_field.type)
					
					If ($Obj_field.label=Null:C1517)
						
						$Obj_field.label:=formatString ("label";$Obj_field.name)
						
					End if 
					
					$Obj_out.labels.push($Obj_field.label)
					
					If ($Obj_field.shortLabel=Null:C1517)
						
						$Obj_field.shortLabel:=$Obj_field.label
						
					End if 
					
					$Obj_out.shortLabels.push($Obj_field.shortLabel)
					$Obj_out.iconPaths.push(String:C10($Obj_field.icon))
					$Obj_out.icons.push(getIcon (String:C10($Obj_field.icon)))
					
					If ($Obj_field.format#Null:C1517)
						
						  //%W-533.1
						If ($Obj_field.format[[1]]="/")  // User resources
							
							$t:=Substring:C12($Obj_field.format;2)
							
							If (Not:C34(formatters (New object:C1471(\
								"action";"isValid";\
								"format";$Path_formats.folder($t))).success))
								
								$Obj_out.formatColors[$Obj_out.formats.length]:=ui.errorColor  // Missing or invalid
								
							End if 
							
						Else 
							
							$t:=$o.setText("_"+$Obj_field.format).localized()
							
						End if 
						  //%W+533.1
						
					Else 
						
						$t:=$o.setText("_"+String:C10(commonValues.defaultFieldBindingTypes[$Obj_field.fieldType])).localized()
						
					End if 
					
					$Obj_out.formats.push($t)
					
					  //……………………………………………………………………………………………………………
				: (Value type:C1509($Obj_table[$tt])#Is object:K8:27)
					
					  // <NOTHING MORE TO DO>
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isRelationToOne($Obj_table[$tt]))\
					 & (Num:C11(This:C1470.selector)=0)
					
					For each ($Txt_field;$Obj_table[$tt])
						
						If ($ƒ.isField($Txt_field))
							
							$Obj_out.formatColors.push(Foreground color:K23:1)
							$Obj_out.nameColors.push(Foreground color:K23:1)
							
							$Obj_field:=$Obj_table[$tt][$Txt_field]
							$Obj_field.id:=Num:C11($Txt_field)
							
							  // ***********************************
							  // ***********************************
							$Obj_out.tableNumbers.push(structure (New object:C1471(\
								"action";"tableNumber";\
								"name";$Obj_table[$tt].relatedDataClass)).tableNumber)
							
							  // ***********************************
							  // ***********************************
							
							$Obj_out.ids.push($Obj_field.id)
							$Obj_out.names.push($Obj_field.name)
							$Obj_out.paths.push($tt+"."+$Obj_field.name)
							$Obj_out.types.push($Obj_field.fieldType)
							$Obj_out.labels.push($Obj_field.label)
							$Obj_out.shortLabels.push($Obj_field.shortLabel)
							$Obj_out.iconPaths.push(String:C10($Obj_field.icon))
							$Obj_out.icons.push(getIcon (String:C10($Obj_field.icon)))
							
							If ($Obj_field.format#Null:C1517)
								
								  //%W-533.1
								If ($Obj_field.format[[1]]="/")  // User resources
									
									$t:=Substring:C12($Obj_field.format;2)
									
									If (Not:C34(formatters (New object:C1471(\
										"action";"isValid";\
										"format";$Path_formats.folder($t))).success))
										
										$Obj_out.formatColors[$Obj_out.formats.length]:=ui.errorColor  // Missing or invalid
										
									End if 
									
								Else 
									
									$t:=$o.setText("_"+$Obj_field.format).localized()
									
								End if 
								  //%W+533.1
								
							Else 
								
								$t:=$o.setText("_"+String:C10(commonValues.defaultFieldBindingTypes[$Obj_field.fieldType])).localized()
								
							End if 
							
							$Obj_out.formats.push($t)
							
						End if 
					End for each 
					
					  //……………………………………………………………………………………………………………
				: (Num:C11(This:C1470.selector)=0)
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isRelationToMany($Obj_table[$tt]))  //&(Num(This.selector)=1)
					
					$Obj_out.formatColors.push(Foreground color:K23:1)
					$Obj_out.nameColors.push(Foreground color:K23:1)
					
					$Obj_field:=$Obj_table[$tt]
					
					  // ***********************************
					  // ***********************************
					$Obj_out.tableNumbers.push(Num:C11($Txt_tableNumber))
					
					  // ***********************************
					  // ***********************************
					
					$Obj_out.ids.push(Null:C1517)
					$Obj_out.names.push($tt)
					$Obj_out.paths.push($tt)
					$Obj_out.types.push(-2)
					
					If (String:C10($Obj_field.label)="")
						
						$Obj_field.label:=formatString ("label";$tt)
						
					End if 
					
					$Obj_out.labels.push($Obj_field.label)
					
					If (String:C10($Obj_field.shortLabel)="")
						
						$Obj_field.shortLabel:=$Obj_field.label
						
					End if 
					
					$Obj_out.shortLabels.push($Obj_field.shortLabel)
					$Obj_out.iconPaths.push(String:C10($Obj_field.icon))
					$Obj_out.icons.push(getIcon (String:C10($Obj_field.icon)))
					
					If (Form:C1466.dataModel[String:C10($Obj_field.relatedTableNumber)]=Null:C1517)
						
						$Obj_out.nameColors[$Obj_out.names.length-1]:=ui.errorColor  // Missing or invalid
						
					End if 
					
					$Obj_out.formats.push($Obj_field.format)
					
					  //……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$Obj_out.count:=$Obj_out.ids.length
		
	Else 
		
		  // No table selected
		
	End if 
	
Else 
	
	  // Empty dataModel
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_out

  // ----------------------------------------------------
  // End