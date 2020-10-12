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
var $1 : Variant

If (False:C215)
	C_OBJECT:C1216(views_fieldList; $0)
	C_VARIANT:C1683(views_fieldList; $1)
End if 

var $attribute; $key; $tableID : Text
var $o; $out; $table : Object

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	If (Value type:C1509($1)=Is text:K8:3)
		
		$tableID:=$1
		
	Else 
		
		$tableID:=String:C10($1)
		
	End if 
	
	$out:=New object:C1471(\
		"success"; Form:C1466.dataModel#Null:C1517)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If ($out.success)
	
	$table:=Form:C1466.dataModel[$tableID]
	
	$out.success:=($table#Null:C1517)
	
	If ($out.success)
		
		$out.fields:=New collection:C1472
		
		For each ($key; $table)
			
			Case of 
					
					//……………………………………………………………………………………………………………
				: (Length:C16($key)=0)
					
					// table meta-data
					
					//……………………………………………………………………………………………………………
				: (Value type:C1509($table[$key])#Is object:K8:27)
					
					// <NOTHING MORE TO DO>
					
					//……………………………………………………………………………………………………………
				: (PROJECT.isField($key))
					
					$o:=OB Copy:C1225($table[$key])
					
					// #TEMPO [
					$o.id:=Num:C11($key)
					$o.fieldNumber:=Num:C11($key)
					//]
					
					$o.path:=$o.name
					
					$out.fields.push($o)
					
					//……………………………………………………………………………………………………………
				: (PROJECT.isRelationToOne($table[$key]))
					
					If (FEATURE.with("moreRelations"))
						
						
						If (Form:C1466.dataModel[String:C10($table[$key].relatedTableNumber)]#Null:C1517)
							
							If ($table[$key].label=Null:C1517)
								
								$table[$key].label:=PROJECT.label($key)
								
							End if 
							
							If ($table[$key].shortLabel=Null:C1517)
								
								$table[$key].shortLabel:=PROJECT.shortLabel($key)
								
							End if 
							
							$o:=New object:C1471(\
								"name"; $key; \
								"path"; $key; \
								"fieldType"; 8858; \
								"relatedDataClass"; $table[$key].relatedDataclass; \
								"inverseName"; $table[$key].inverseName; \
								"label"; $table[$key].label; \
								"shortlabel"; $table[$key].$t.shortLabel; \
								"relatedTableNumber"; $table[$key].relatedTableNumber; \
								"$added"; True:C214)
							
							// #TEMPO [
							$o.id:=0
							//]
							
							$out.fields.push($o)
							
						End if 
					End if 
					
					For each ($attribute; $table[$key])
						
						Case of 
								
								//______________________________________________________
							: (Value type:C1509($table[$key][$attribute])#Is object:K8:27)
								
								// <NOTHING MORE TO DO>
								
								//______________________________________________________
							: (PROJECT.isField($attribute))
								
								$o:=OB Copy:C1225($table[$key][$attribute])
								
								// #TEMPO [
								$o.id:=Num:C11($attribute)
								$o.fieldNumber:=Num:C11($attribute)
								//]
								
								$o.path:=$key+"."+$o.name
								
								//$o.path:="┊"+$o.path
								
								$out.fields.push($o)
								
								//______________________________________________________
							: (Not:C34(FEATURE.with("moreRelations")))
								
								// <NOT DELIVERED>
								
								//______________________________________________________
							Else 
								
								$o:=OB Copy:C1225($table[$key][$attribute])
								$o.id:=0
								$o.fieldType:=Choose:C955(Bool:C1537($o.isToMany); 8859; 8858)
								$o.$added:=True:C214
								$out.fields.push($o)
								
								
								//______________________________________________________
						End case 
						
					End for each 
					
					//……………………………………………………………………………………………………………
				: (PROJECT.isRelationToMany($table[$key]))
					
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
						
						If (FEATURE.with("moreRelations"))
							
							$o:=New object:C1471(\
								"name"; $key; \
								"path"; $key; \
								"fieldType"; 8859; \
								"relatedDataClass"; $table[$key].relatedDataclass; \
								"inverseName"; $table[$key].inverseName; \
								"label"; PROJECT.label($table[$key].label); \
								"shortlabel"; PROJECT.label($table[$key].$t.shortLabel); \
								"isToMany"; True:C214; \
								"relatedTableNumber"; $table[$key].relatedTableNumber)
							
							// #TEMPO [
							$o.id:=0
							//]
							
							$out.fields.push($o)
							
						End if 
					End if 
					
					//……………………………………………………………………………………………………………
			End case 
		End for each 
		
		$out.fields:=$out.fields.orderBy("path")
		
	End if 
End if 

// ----------------------------------------------------
// Return
$0:=$out

// ----------------------------------------------------
// End