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
var $fixed; $indx : Integer
var $x : Blob
var $context; $target : Object
var $c : Collection
var $field : cs:C1710.field
var $tmpl : cs:C1710.tmpl

// ----------------------------------------------------
// Initialisations
$context:=panel
$cible:=$context.current

$preview:=This:C1470.preview.name

// ----------------------------------------------------
If (Length:C16($cible)>0)
	
	// Get the pastboard
	GET PASTEBOARD DATA:C401("com.4d.private.4dmobile.field"; $x)
	
	If (Bool:C1537(OK))
		
		BLOB TO VARIABLE:C533($x; $field)
		SET BLOB SIZE:C606($x; 0)
		
		If ($field.kind="alias")
			
			$field.name:=$field.$level>0 ? $field.path : $field.name
			
		Else 
			
			$field.name:=$field.path
			
		End if 
		
		PROJECT.cleanup($field)
		
		// Check the match of the type with the source
		SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:type"; $bind)
		
		$currentForm:=Current form name:C1298
		$tmpl:=$context.template
		
		If ($tmpl.isTypeAccepted($bind; $field.fieldType))
			
			$target:=Form:C1466[This:C1470.$.typeForm()][$context.tableNumber]
			SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "ios:bind"; $binding)
			$c:=cs:C1710.regex.new($binding; "(?m-si)^([^\\[]+)\\[(\\d+)]\\s*$").extract("1 2")
			
			If ($c.length=2)  // List of fields
				
				// Belt and braces
				$target[$c[0]]:=$target[$c[0]] || New collection:C1472
				
				If ($field.fromIndex#Null:C1517)  // Internal D&D
					
					If ($field.fromIndex#(Num:C11(Replace string:C233($cible; "e"; ""))-1))
						
						$indx:=Num:C11(Replace string:C233($cible; "e"; ""))
						$target.fields.remove($field.fromIndex)
						$indx:=$indx-1-Num:C11($field.fromIndex<$indx)
						OB REMOVE:C1226($field; "fromIndex")
						$target.fields.insert($indx; $field)
						
					End if 
					
				Else 
					
					$field:=$tmpl.fieldDescription($field; $target[$c[0]][Num:C11($c[1])]; $context.tableNumber)
					
				End if 
				
				PROJECT.minimumField($field)
				
				$target[$c[0]][Num:C11($c[1])]:=$field
				
			Else   // Single value field (Not aaaaa[000]) ie 'searchableField' or 'sectionField'
				
				SVG GET ATTRIBUTE:C1056(*; $preview; $cible; "4D-isOfClass-multi-criteria"; $buffer)
				
				If (JSON Parse:C1218($buffer; Is boolean:K8:9))  // Search on several fields - append to the field list if any
					
					If (Value type:C1509($target[$binding])#Is collection:K8:32)
						
						$target[$binding]:=($target[$binding]=Null:C1517) ? $field : New collection:C1472($target[$binding])
						
					End if 
					
					If (Value type:C1509($target[$binding])=Is collection:K8:32)
						
						If ($target[$binding].query("name = :1"; $field.path).pop()=Null:C1517)
							
							// Append field
							$target[$binding].push($field)
							
						End if 
					End if 
					
				Else 
					
					Case of 
							
							//______________________________________________________
						: ($cible="background")
							
							If ($field.fromIndex#Null:C1517)
								
								$target.fields.remove($field.fromIndex)
								
							End if 
							
							$fixed:=$tmpl.manifest.fields.count
							
							If ($fixed>0)
								
								$indx:=$target.fields.indexOf(Null:C1517; $fixed)
								
								If ($indx=-1)
									
									If ($target.fields.length<$fixed)
										
										$target.fields[$fixed]:=$field
										
									Else 
										
										$target.fields.push($field)
										
									End if 
									
								Else 
									
									$target.fields[$indx]:=$field
									
								End if 
								
							Else 
								
								$target.fields.push($field)
								
							End if 
							
							//______________________________________________________
						: ($cible="@.vInsert")
							
							$indx:=Num:C11(Replace string:C233($cible; "e"; ""))
							
							If ($field.fromIndex#Null:C1517)
								
								$target.fields.remove($field.fromIndex)
								$indx:=$indx-1-Num:C11($field.fromIndex<$indx)
								
							Else 
								
								$indx:=$indx-1
								
							End if 
							
							$target.fields.insert($indx; $field)
							
							//______________________________________________________
						Else 
							
							$target[$binding]:=$field
							
							//______________________________________________________
					End case 
				End if 
				
				//MARK:Cleanup
				PROJECT.minimumField($field)
				
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