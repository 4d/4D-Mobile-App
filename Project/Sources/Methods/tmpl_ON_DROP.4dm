//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : tmpl_ON_DROP
// ID[FC685A0A360B4F518FF6B8E40D4BA148]
// Created 6-9-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $buffer; $cible; $ObjectName; $t; $tableIdentifier : Text
var $success : Boolean
var $fixed; $indx : Integer
var $x : Blob
var $current; $dropped; $relation; $table; $target : Object
var $c; $cCurrent; $cDroped : Collection

// ----------------------------------------------------
// Initialisations
$cible:=This:C1470.$.current
$tableIdentifier:=This:C1470.$.tableNumber
$ObjectName:=This:C1470.preview.name

// ----------------------------------------------------
If (Length:C16($cible)>0)
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.ios.field"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $dropped)
		SET BLOB SIZE:C606($x; 0)
		
		project.cleanup($dropped)
		
		// Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "ios:type"; $t)
		
		If ($t="all")
			
			$success:=True:C214
			
		Else 
			
			// Check the type compatibility
			$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
			$success:=tmpl_compatibleType($c; $dropped.fieldType)
			
		End if 
		
		If ($success)
			
			$target:=Form:C1466[Choose:C955(Num:C11(This:C1470.$.selector)=2; "detail"; "list")][$tableIdentifier]
			
			$dropped.name:=$dropped.path
			
			SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "ios:bind"; $t)
			ARRAY TEXT:C222($tMatches; 0x0000)
			Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $t; ->$tMatches)
			
			If (Size of array:C274($tMatches)=2)  // List of fields
				
				// Belt and braces
				If ($target[$tMatches{1}]=Null:C1517)
					
					$target[$tMatches{1}]:=New collection:C1472
					
				End if 
				
				If ($dropped.fromIndex#Null:C1517)  // Internal D&D
					
					If ($dropped.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
						
						$indx:=Num:C11(Replace string:C233($cible; "e"; ""))
						$target.fields.remove($dropped.fromIndex)
						$indx:=$indx-1-Num:C11($dropped.fromIndex<$indx)
						$target.fields.insert($indx; $dropped)
						
					End if 
					
				Else 
					
					// The current item, if any
					$current:=$target[$tMatches{1}][Num:C11($tMatches{2})]
					
					// Splits path for later
					$cCurrent:=Split string:C1554(String:C10($current.path); ".")
					$cDroped:=Split string:C1554($dropped.path; ".")
					
					// Get current table
					$table:=Form:C1466.dataModel[$tableIdentifier]
					
					Case of 
							
							//______________________________________________________
						: ($dropped.fieldType=8858)  // N -> 1 relation
							
							//OB REMOVE($dropped; "id")
							
							If ($cCurrent.length=2)\
								 & ($cDroped.length=1)  // Drop a relation on a field
								
								If ($cCurrent[0]=$cDroped[0])  // Same related table
									
									// Keep the droped relation & add/update the format
									$relation:=$table[$cDroped[0]]
									$relation.format:="%"+$cCurrent[1]+"%"
									
								End if 
							End if 
							
							//______________________________________________________
						: ($dropped.fieldType=8859)  // 1 -> N relation
							
							//OB REMOVE($dropped; "id")
							
							//______________________________________________________
						: ($current=Null:C1517)  // Add
							
							// <NOTHING MORE TO DO>
							
							//______________________________________________________
						Else 
							
							// Check for the same root
							
							Case of 
									
									//……………………………………………………………………………………………………
								: ($cCurrent.length=$cDroped.length)
									
									// Replace
									
									//……………………………………………………………………………………………………
								: ($cCurrent.length=1)\
									 & ($cDroped.length=2)  // Drop a field on a relation
									
									$relation:=$table[$current.name]
									
									If ($current.fieldType=8858)  // 1 -> N relation
										
										If ($cCurrent[0]=$cDroped[0])  // Same related table
											
											// Switch to relation & add/modify the format
											$dropped:=New object:C1471(\
												"name"; $cDroped[0]; \
												"fieldType"; 8858; \
												"relatedTableNumber"; $relation.relatedTableNumber; \
												"label"; $relation.label; \
												"shortlabel"; $relation.shortLabel; \
												"path"; $cDroped[0])
											
											$relation.format:="%"+$cDroped[1]+"%"
											
										End if 
									End if 
									
									//……………………………………………………………………………………………………
							End case 
							
							//______________________________________________________
					End case 
					
					$target[$tMatches{1}][Num:C11($tMatches{2})]:=$dropped
					
				End if 
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				SVG GET ATTRIBUTE:C1056(*; $ObjectName; $cible; "4D-isOfClass-multi-criteria"; $buffer)
				
				If (JSON Parse:C1218($buffer; Is boolean:K8:9))  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($target[$t])#Is collection:K8:32)
						
						If ($target[$t]#Null:C1517)
							
							// Convert
							$target[$t]:=New collection:C1472($target[$t])
							
						Else 
							
							$target[$t]:=$dropped
							
						End if 
					End if 
					
					If (Value type:C1509($target[$t])=Is collection:K8:32)
						
						If ($target[$t].extract("name").indexOf($dropped.path)=-1)
							
							// Append field
							$target[$t].push($dropped)
							
						End if 
					End if 
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($cible="background")
							
							If ($dropped.fromIndex#Null:C1517)
								
								$target.fields.remove($dropped.fromIndex)
								
							End if 
							
							$fixed:=Form:C1466.$dialog.VIEWS.template.manifest.fields.count
							$indx:=$target.fields.indexOf(Null:C1517; $fixed)
							
							If ($indx=-1)
								
								If ($target.fields.length<$fixed)
									
									$target.fields[$fixed]:=$dropped
									
								Else 
									
									$target.fields.push($dropped)
									
								End if 
								
							Else 
								
								$target.fields[$indx]:=$dropped
								
							End if 
							
							//______________________________________________________
						: ($cible="@.vInsert")
							
							$indx:=Num:C11(Replace string:C233($cible; "e"; ""))
							
							If ($dropped.fromIndex#Null:C1517)
								
								$target.fields.remove($dropped.fromIndex)
								$indx:=$indx-1-Num:C11($dropped.fromIndex<$indx)
								
							Else 
								
								$indx:=$indx-1
								
							End if 
							
							$target.fields.insert($indx; $dropped)
							
							//______________________________________________________
						Else 
							
							$target[$t]:=$dropped
							
							//______________________________________________________
					End case 
				End if 
			End if 
			
			If (feature.with("newViewUI"))
				
				OB REMOVE:C1226(Form:C1466.$dialog.VIEWS; "scroll")
				
			End if 
			
			project.save()
			
			// Update preview
			views_preview("draw"; This:C1470)
			
		End if 
	End if 
End if 

// ----------------------------------------------------
// End