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
var $0 : Object
var $1 : Text
var $2 : Object

var $fieldIdentifier; $key; $tableIdentifier : Text
var $o; $out; $table : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	$tableIdentifier:=$1
	
	$out:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($out.success)
	
	$table:=Form:C1466.dataModel[$tableIdentifier]
	
	$out.success:=($table#Null:C1517)
	
	If ($out.success)
		
		$out.fields:=New collection:C1472
		
		For each ($key; $table)
			
			Case of 
					
					//……………………………………………………………………………………………………………
				: (Length:C16($key)=0)
					
					// table meta-data
					
					//……………………………………………………………………………………………………………
				: (project.isField($key))
					
					$o:=OB Copy:C1225($table[$key])
					
					// #TEMPO [
					$o.id:=Num:C11($key)
					$o.fieldNumber:=Num:C11($key)
					//]
					
					$o.path:=$o.name
					
					$out.fields.push($o)
					
					//……………………………………………………………………………………………………………
				: (Value type:C1509($table[$key])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//……………………………………………………………………………………………………………
				: (project.isRelationToOne($table[$key]))
					
					If (feature.with("moreRelations"))
						
						If ($table[$key].label=Null:C1517)
							
							$table[$key].label:=project.label($key)
							
						End if 
						
						If ($table[$key].shortLabel=Null:C1517)
							
							$table[$key].shortLabel:=project.shortLabel($key)
							
						End if 
						
						$o:=New object:C1471(\
							"name"; $key; \
							"fieldType"; 8858; \
							"relatedTableNumber"; $table[$key].relatedTableNumber; \
							"label"; $table[$key].label; \
							"shortlabel"; $table[$key].$t.shortLabel; \
							"path"; $key)
						
						// #TEMPO [
						$o.id:=Num:C11($fieldIdentifier)
						//]
						
						$out.fields.push($o)
						
					End if 
					
					For each ($fieldIdentifier; $table[$key])
						
						If (project.isField($fieldIdentifier))  // fieldNumber
							
							$o:=OB Copy:C1225($table[$key][$fieldIdentifier])
							
							// #TEMPO [
							$o.id:=Num:C11($fieldIdentifier)
							$o.fieldNumber:=Num:C11($fieldIdentifier)
							//]
							
							$o.path:=$key+"."+$o.name
							
							//$o.path:="┊"+$o.path
							
							$out.fields.push($o)
							
						End if 
					End for each 
					
					//……………………………………………………………………………………………………………
				: (project.isRelationToMany($table[$key]))
					
					If (Form:C1466.$dialog.VIEWS.template.detailform)
						
						$o:=OB Copy:C1225($table[$key])
						
						$o.name:=$key
						$o.fieldType:=8859
						
						// #TEMPO [
						$o.id:=0
						$o.fieldNumber:=0
						//]
						
						$o.path:=$key
						
						$out.fields.push($o)
						
					Else 
						
						If (feature.with("moreRelations"))
							
							$o:=New object:C1471(\
								"name"; $key; \
								"fieldType"; 8859; \
								"relatedTableNumber"; $table[$key].relatedTableNumber; \
								"label"; $table[$key].label; \
								"shortlabel"; $table[$key].$t.shortLabel; \
								"path"; $key)
							
							// #TEMPO [
							$o.id:=Num:C11($fieldIdentifier)
							//]
							
							$out.fields.push($o)
							
						End if 
					End if 
					
					//……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$out.fields.orderBy("path")
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$out

// ----------------------------------------------------
// End