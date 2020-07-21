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
var $ObjectName, $t, $tableIdentifier, $target : Text
var $b : Boolean
var $countFixed, $indx : Integer
var $x : Blob
var $current, $droped, $relation, $table, $targetTable : Object
var $c, $cc : Collection

ARRAY TEXT:C222($tMatches; 0)

// ----------------------------------------------------
// Initialisations
$target:=This:C1470.$.current
$tableIdentifier:=This:C1470.$.tableNumber
$ObjectName:=This:C1470.preview.name

// ----------------------------------------------------
If (Length:C16($target)>0)
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.ios.field"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $droped)
		SET BLOB SIZE:C606($x; 0)
		
		// Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*; $ObjectName; $target; "ios:type"; $t)
		
		If ($t="all")
			
			$b:=True:C214
			
		Else 
			
			// Check the type compatibility
			$c:=Split string:C1554($t; ","; sk trim spaces:K86:2).map("col_formula"; Formula:C1597($1.result:=Num:C11($1.value)))
			$b:=tmpl_compatibleType($c; $droped.fieldType)
			
		End if 
		
		If ($b)
			
			$targetTable:=Form:C1466[Choose:C955(Num:C11(This:C1470.$.selector)=2; "detail"; "list")][$tableIdentifier]
			
			$droped.name:=$droped.path
			
			SVG GET ATTRIBUTE:C1056(*; $ObjectName; $target; "ios:bind"; $t)
			Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $t; ->$tMatches)
			
			If (Size of array:C274($tMatches)=2)  // List of fields
				
				// Belt and braces
				If ($targetTable[$tMatches{1}]=Null:C1517)
					
					$targetTable[$tMatches{1}]:=New collection:C1472
					
				End if 
				
				If ($droped.fromIndex#Null:C1517)
					
					If ($droped.fromIndex#(Num:C11(Replace string:C233($target; "e"; ""))-1))
						
						$indx:=Num:C11(Replace string:C233($target; "e"; ""))
						$targetTable.fields.remove($droped.fromIndex)
						$indx:=$indx-1-Num:C11($droped.fromIndex<$indx)
						$targetTable.fields.insert($indx; $droped)
						
					End if 
					
				Else 
					
					$current:=$targetTable[$tMatches{1}][Num:C11($tMatches{2})]
					
					Case of 
							
							//______________________________________________________
						: ($droped.fieldType=8858)
							
							OB REMOVE:C1226($droped; "id")
							
							//______________________________________________________
						: ($droped.fieldType=8859)
							
							OB REMOVE:C1226($droped; "id")
							
							//______________________________________________________
						: ($current=Null:C1517)
							
							// Add
							
							//______________________________________________________
						Else 
							
							// Check for the same root
							$c:=Split string:C1554($current.path; ".")
							$cc:=Split string:C1554($droped.path; ".")
							
							$table:=Form:C1466.dataModel[$tableIdentifier]
							
							Case of 
									
									//______________________________________________________
								: ($c.length=$cc.length)
									
									// Replace
									
									//______________________________________________________
								: ($c.length=1)\
									 & ($cc.length=2)  // Relation + relation field
									
									$relation:=$table[$current.name]
									
									If ($current.fieldType=8858)
										
										If ($c[0]=$cc[0])  // Same relation
											
											// Switch to relation & add/modify the format
											$droped:=New object:C1471(\
												"name"; $cc[0]; \
												"fieldType"; 8858; \
												"relatedTableNumber"; $relation.relatedTableNumber; \
												"label"; $relation.label; \
												"shortlabel"; $relation.shortLabel; \
												"path"; $cc[0])
											
											$relation.format:="%"+$cc[1]+"%"
											
										Else 
											
											// Replace by the field (and remove the format ?)
											//If ($relation#Null)
											//OB REMOVE($relation; "format")
											//End if 
											
										End if 
										
									Else 
										
										// Replace (and remove the format ?)
										//If ($relation#Null)
										//OB REMOVE($relation; "format")
										//End if 
										
									End if 
									
									//______________________________________________________
								: ($c.length=2)\
									 & ($cc.length=1)  // Relation field + relation
									
									If ($c[0]=$cc[0])
										
										// Keep the droped relation & add the format
										$relation:=$table[$cc[0]]
										$relation.format:="%"+$cc[1]+"%"
										
									Else 
										
										// Replace by the new relation (and remove the format ?)
										//If ($relation#Null)
										//OB REMOVE($relation; "format")
										//End if 
										
									End if 
									
									//______________________________________________________
								Else 
									
									// Should not
									TRACE:C157
									
									//______________________________________________________
							End case 
							
							//______________________________________________________
					End case 
					
					$targetTable[$tMatches{1}][Num:C11($tMatches{2})]:=$droped
					
				End if 
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				var $buffer : Text
				SVG GET ATTRIBUTE:C1056(*; $ObjectName; $target; "4D-isOfClass-multi-criteria"; $buffer)
				
				If (JSON Parse:C1218($buffer; Is boolean:K8:9))  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($targetTable[$t])#Is collection:K8:32)
						
						If ($targetTable[$t]#Null:C1517)
							
							// Convert
							$targetTable[$t]:=New collection:C1472($targetTable[$t])
							
						Else 
							
							$targetTable[$t]:=$droped
							
						End if 
					End if 
					
					If (Value type:C1509($targetTable[$t])=Is collection:K8:32)
						
						If ($targetTable[$t].extract("name").indexOf($droped.path)=-1)
							
							// Append field
							$targetTable[$t].push($droped)
							
						End if 
					End if 
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($target="background")
							
							If ($droped.fromIndex#Null:C1517)
								
								$targetTable.fields.remove($droped.fromIndex)
								
							End if 
							
							$countFixed:=Form:C1466.$dialog.VIEWS.template.manifest.fields.count
							$indx:=$targetTable.fields.indexOf(Null:C1517; $countFixed)
							
							If ($indx=-1)
								
								If ($targetTable.fields.length<$countFixed)
									
									$targetTable.fields[$countFixed]:=$droped
									
								Else 
									
									$targetTable.fields.push($droped)
									
								End if 
								
							Else 
								
								$targetTable.fields[$indx]:=$droped
								
							End if 
							
							//______________________________________________________
						: ($target="@.vInsert")
							
							$indx:=Num:C11(Replace string:C233($target; "e"; ""))
							
							If ($droped.fromIndex#Null:C1517)
								
								$targetTable.fields.remove($droped.fromIndex)
								$indx:=$indx-1-Num:C11($droped.fromIndex<$indx)
								
							Else 
								
								$indx:=$indx-1
								
							End if 
							
							$targetTable.fields.insert($indx; $droped)
							
							//______________________________________________________
						Else 
							
							$targetTable[$t]:=$droped
							
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