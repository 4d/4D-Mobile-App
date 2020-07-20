//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : views_fieldList
// ID[6CB8A40D701F4747A463177B92640A0E]
// Created 28-3-2019 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Return a readonly flat table field collection
// ----------------------------------------------------
// Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_LONGINT:C283($Lon_parameters)
C_TEXT:C284($t; $tt; $Txt_tableNumber)
C_OBJECT:C1216($ƒ; $o; $Obj_out; $Obj_table)

If (False:C215)
	C_OBJECT:C1216(views_fieldList; $0)
	C_TEXT:C284(views_fieldList; $1)
	C_OBJECT:C1216(views_fieldList; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_tableNumber:=$1
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
	$ƒ:=Storage:C1525.ƒ
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($Obj_out.success)
	
	$Obj_table:=Form:C1466.dataModel[$Txt_tableNumber]
	
	$Obj_out.success:=($Obj_table#Null:C1517)
	
	If ($Obj_out.success)
		
		$Obj_out.fields:=New collection:C1472
		
		For each ($t; $Obj_table)
			
			Case of 
					
					//……………………………………………………………………………………………………………
				: ($ƒ.isField($t))
					
					$o:=OB Copy:C1225($Obj_table[$t])
					
					// #TEMPO [
					$o.id:=Num:C11($t)
					$o.fieldNumber:=Num:C11($t)
					//]
					
					$o.path:=$o.name
					
					$Obj_out.fields.push($o)
					
					//……………………………………………………………………………………………………………
				: (Value type:C1509($Obj_table[$t])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//……………………………………………………………………………………………………………
				: ($ƒ.isRelationToOne($Obj_table[$t]))
					
					If (feature.with("moreRelations"))
						
						// Label & shortLabel should come from fields panel
						
						$o:=New object:C1471(\
							"name"; $t; \
							"fieldType"; 8858; \
							"relatedTableNumber"; $Obj_table[$t].relatedTableNumber; \
							"label"; formatString("label"; $t); \
							"shortlabel"; formatString("shortlabel"; $t); \
							"path"; $t)
						
						$Obj_out.fields.push($o)
						
					End if 
					
					For each ($tt; $Obj_table[$t])
						
						If ($ƒ.isField($tt))  // fieldNumber
							
							$o:=OB Copy:C1225($Obj_table[$t][$tt])
							
							// #TEMPO [
							$o.id:=Num:C11($tt)
							$o.fieldNumber:=Num:C11($tt)
							//]
							
							$o.path:=$t+"."+$o.name
							
							$Obj_out.fields.push($o)
							
						End if 
					End for each 
					
					//……………………………………………………………………………………………………………
				: ($ƒ.isRelationToMany($Obj_table[$t]))
					
					If (Form:C1466.$dialog.VIEWS.typeForm()="detail") | feature.with("moreRelations")
						
						$o:=OB Copy:C1225($Obj_table[$t])
						
						$o.name:=$t
						$o.fieldType:=8859
						
						// #TEMPO [
						$o.id:=0
						$o.fieldNumber:=0
						//]
						
						$o.path:=$t
						
						$Obj_out.fields.push($o)
						
					End if 
					
					//……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$Obj_out.fields.orderBy("path")
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End