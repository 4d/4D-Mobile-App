//%attributes = {"invisible":true,"preemptive":"incapable"}
  // ----------------------------------------------------
  // Project method : fields_LIST
  // Database: 4D Mobile App
  // ID[0F8855BDB0F7477397EEEE16B17EE729]
  // Created #28-3-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Return selected table field list according to data model
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($Dir_formats;$t;$Txt_field;$Txt_table;$Txt_tableNumber)
C_OBJECT:C1216($ƒ;$Obj_field;$Obj_out;$Obj_table)

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
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If ($Obj_out.success)
	
	$Obj_out.success:=(Form:C1466.dataModel[$Txt_tableNumber]#Null:C1517)
	
	If ($Obj_out.success)
		
		  //$Dir_root:=Pathname ("fieldIcons")+Folder separator
		  //$Dir_hostRoot:=Pathname ("host_fieldIcons")
		$Dir_formats:=_o_Pathname ("host_formatters")
		
		$Obj_out.ids:=New collection:C1472
		$Obj_out.names:=New collection:C1472
		$Obj_out.labels:=New collection:C1472
		$Obj_out.shortLabels:=New collection:C1472
		$Obj_out.iconPaths:=New collection:C1472
		$Obj_out.icons:=New collection:C1472
		$Obj_out.types:=New collection:C1472
		$Obj_out.formats:=New collection:C1472
		$Obj_out.formatColors:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		$Obj_out.tableNumbers:=New collection:C1472
		
		  // ***********************************
		  // ***********************************
		
		$Obj_out.paths:=New collection:C1472
		
		$Obj_table:=Form:C1466.dataModel[$Txt_tableNumber]
		
		For each ($Txt_table;$Obj_table)
			
			Case of 
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isField($Txt_table))
					
					$Obj_field:=$Obj_table[$Txt_table]
					$Obj_field.id:=Num:C11($Txt_table)
					
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
					
					$Obj_out.formatColors[$Obj_out.formats.length]:=Foreground color:K23:1
					
					If ($Obj_field.format#Null:C1517)
						
						  //%W-533.1
						If ($Obj_field.format[[1]]="/")  // User resources
							
							$t:=Substring:C12($Obj_field.format;2)
							
							  //$t:=$Dir_formats+$t+Folder separator
							
							If (Not:C34(formatters (New object:C1471(\
								"action";"isValid";\
								"path";$Dir_formats+$t+Folder separator:K24:12)).success))
								
								$Obj_out.formatColors[$Obj_out.formats.length]:=ui.errorColor  // Missing or invalid
								
							End if 
							
						Else 
							
							$t:=str_localized (New collection:C1472("_"+$Obj_field.format))
							
						End if 
						  //%W+533.1
						
					Else 
						
						$t:=str_localized (New collection:C1472("_"+String:C10(commonValues.defaultFieldBindingTypes[$Obj_field.fieldType])))
						
					End if 
					
					$Obj_out.formats.push($t)
					
					  //……………………………………………………………………………………………………………
				: (Value type:C1509($Obj_table[$Txt_table])#Is object:K8:27)
					
					  // <NOTHING MORE TO DO>
					
					  //……………………………………………………………………………………………………………
				: ($ƒ.isRelatedDataClass($Obj_table[$Txt_table]))
					
					For each ($Txt_field;$Obj_table[$Txt_table])
						
						If ($ƒ.isField($Txt_field))
							
							$Obj_field:=$Obj_table[$Txt_table][$Txt_field]
							$Obj_field.id:=Num:C11($Txt_field)
							
							  // ***********************************
							  // ***********************************
							$Obj_out.tableNumbers.push(structure (New object:C1471(\
								"action";"tableNumber";\
								"name";$Obj_table[$Txt_table].relatedDataClass)).tableNumber)
							
							  // ***********************************
							  // ***********************************
							
							$Obj_out.ids.push($Obj_field.id)
							$Obj_out.names.push($Obj_field.name)
							$Obj_out.paths.push($Txt_table+"."+$Obj_field.name)
							$Obj_out.types.push($Obj_field.fieldType)
							$Obj_out.labels.push($Obj_field.label)
							$Obj_out.shortLabels.push($Obj_field.shortLabel)
							$Obj_out.iconPaths.push(String:C10($Obj_field.icon))
							$Obj_out.icons.push(getIcon (String:C10($Obj_field.icon)))
							$Obj_out.formatColors[$Obj_out.formats.length]:=Foreground color:K23:1
							
							If ($Obj_field.format#Null:C1517)
								
								  //%W-533.1
								If ($Obj_field.format[[1]]="/")  // User resources
									
									$t:=$Dir_formats+Substring:C12($Obj_field.format;2)+Folder separator:K24:12
									
									If (Not:C34(formatters (New object:C1471(\
										"action";"isValid";\
										"path";$t)).success))
										
										$Obj_out.formatColors[$Obj_out.formats.length]:=ui.errorColor  // Missing or invalid
										
									End if 
									
								Else 
									
									$t:=str_localized (New collection:C1472("_"+$Obj_field.format))
									
								End if 
								  //%W+533.1
								
							Else 
								
								ASSERT:C1129(commonValues.defaultFieldBindingTypes.length>($Obj_field.fieldType-1))
								
								$t:=str_localized (New collection:C1472("_"+String:C10(commonValues.defaultFieldBindingTypes[$Obj_field.fieldType])))
								
							End if 
							
							$Obj_out.formats.push($t)
							
						End if 
					End for each 
					
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