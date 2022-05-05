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
var $bind; $binding; $buffer; $cible; $currentForm; $preview : Text
var $tableNumber : Text
var $fixed; $indx : Integer
var $x : Blob
var $context; $dropped; $target : Object
var $tmpl : cs:C1710.tmpl

// ----------------------------------------------------
// Initialisations
$context:=panel
$cible:=$context.current
$tableNumber:=$context.tableNumber

$preview:=This:C1470.preview.name

// ----------------------------------------------------
If (Length:C16($cible)>0)
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.field"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $dropped)
		SET BLOB SIZE:C606($x; 0)
		
		PROJECT.cleanup($dropped)
		
		// Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:type"; $bind)
		
		$currentForm:=Current form name:C1298
		$tmpl:=$context.template
		
		If ($tmpl.isTypeAccepted($bind; $dropped.fieldType))
			
			$target:=Form:C1466[This:C1470.$.typeForm()][$tableNumber]
			//$dropped.name:=$dropped.path
			
			SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:bind"; $binding)
			
			ARRAY TEXT:C222($tMatches; 0x0000)
			Rgx_MatchText("(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$"; $binding; ->$tMatches)
			
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
						OB REMOVE:C1226($dropped; "fromIndex")
						$target.fields.insert($indx; $dropped)
						
					End if 
					
				Else 
					
					$dropped:=$tmpl.fieldDescription($dropped; $target[$tMatches{1}][Num:C11($tMatches{2})])
					
				End if 
				
				PROJECT.minimumField($dropped)
				
				$target[$tMatches{1}][Num:C11($tMatches{2})]:=$dropped
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "4D-isOfClass-multi-criteria"; $buffer)
				
				If (JSON Parse:C1218($buffer; Is boolean:K8:9))  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($target[$binding])#Is collection:K8:32)
						
						$target[$binding]:=($target[$binding]=Null:C1517) ? $dropped : New collection:C1472($target[$binding])
						
					End if 
					
					If (Value type:C1509($target[$binding])=Is collection:K8:32)
						
						If ($target[$binding].query("name = :1"; $dropped.path).pop()=Null:C1517)
							
							// Append field
							$target[$binding].push($dropped)
							
						End if 
					End if 
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($cible="background")
							
							If ($dropped.fromIndex#Null:C1517)
								
								$target.fields.remove($dropped.fromIndex)
								
							End if 
							
							$fixed:=$tmpl.manifest.fields.count
							
							If ($fixed>0)
								
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
								
							Else 
								
								$target.fields.push($dropped)
								
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
							
							$target[$binding]:=$dropped
							
							//______________________________________________________
					End case 
				End if 
				
				//MARK:Cleanup
				PROJECT.minimumField($dropped)
				
			End if 
			
			OB REMOVE:C1226(Form:C1466.$dialog[$currentForm]; "scroll")
			
			PROJECT.save()
			
			// Update preview
			tmpl_DRAW(This:C1470)
			
		Else 
			
			// SHOULD NOT: incompatible type
			
		End if 
		
	Else 
		
		// NOT AUTHORIZED DROP
		
	End if 
	
Else 
	
	// SHOULD NOT
	
End if 